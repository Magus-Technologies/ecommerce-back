<?php

namespace App\Services;

use Greenter\See;
use Greenter\Ws\Services\SunatEndpoints;
use Greenter\Model\Client\Client;
use Greenter\Model\Company\Company;
use Greenter\Model\Company\Address;
use Greenter\Model\Despatch\Despatch;
use Greenter\Model\Despatch\DespatchDetail;
use Greenter\Model\Despatch\Shipment;
use Greenter\Model\Despatch\Driver;
use Greenter\Model\Despatch\Direction;
use Greenter\Report\HtmlReport;
use Greenter\Report\PdfReport;
use App\Models\GuiaRemision;
use App\Models\GuiaRemisionDetalle;
use App\Models\SunatLog;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class GuiaRemisionService
{
    private $see;
    private $company;

    public function __construct()
    {
        $this->see = new See();
        $this->configurarSee();
        $this->configurarEmpresa();
    }

    private function configurarSee()
    {
        $ambiente = env('GREENTER_MODE', 'BETA');

        // Configurar certificado según ambiente
        if (strtoupper($ambiente) === 'BETA') {
            // Para BETA, usar el certificado de prueba de Greenter
            // Este certificado ya viene incluido en la librería y no requiere configuración adicional
            $certPath = __DIR__ . '/../../vendor/greenter/xmldsig/tests/certificate.pem';

            if (file_exists($certPath)) {
                $certificadoContenido = file_get_contents($certPath);
                $this->see->setCertificate($certificadoContenido);
                Log::info('Usando certificado de prueba de Greenter para BETA (Guías de Remisión)');
            } else {
                // Fallback: intentar usar el certificado configurado
                $certPath = storage_path('app/' . env('GREENTER_CERT_PATH', 'certificates/certificate.pem'));
                if (file_exists($certPath)) {
                    $certificadoContenido = file_get_contents($certPath);
                    $this->see->setCertificate($certificadoContenido);
                    Log::info('Usando certificado personalizado desde storage (Guías de Remisión)');
                } else {
                    throw new \Exception("Certificado no encontrado. Verifica la instalación de Greenter o configura GREENTER_CERT_PATH");
                }
            }

            // Credenciales de prueba BETA
            $solUser = env('GREENTER_FE_USER', '20000000001MODDATOS');
            $solPassword = env('GREENTER_FE_PASSWORD', 'MODDATOS');

            $this->see->setService(SunatEndpoints::GUIA_BETA);

        } else {
            // Para PRODUCCIÓN, usar certificado real de la empresa
            $certPath = storage_path('app/' . env('GREENTER_CERT_PATH'));

            if (empty($certPath) || !file_exists($certPath)) {
                throw new \Exception("Certificado de producción no encontrado en: {$certPath}");
            }

            $certificadoContenido = file_get_contents($certPath);
            $this->see->setCertificate($certificadoContenido);

            // Credenciales reales de producción
            $solUser = env('GREENTER_FE_USER');
            $solPassword = env('GREENTER_FE_PASSWORD');

            if (empty($solUser) || empty($solPassword)) {
                throw new \Exception('Las credenciales SOL de producción no están configuradas');
            }

            $this->see->setService(SunatEndpoints::GUIA_PRODUCCION);
        }

        // Configurar credenciales SOL
        $this->see->setCredentials($solUser, $solPassword);

        Log::info('GuiaRemisionService configurado correctamente', [
            'ambiente' => $ambiente,
            'usuario_sol' => $solUser,
            'endpoint' => $ambiente === 'BETA' ? 'GUIA_BETA' : 'GUIA_PRODUCCION'
        ]);
    }

    private function configurarEmpresa()
    {
        $this->company = new Company();
        $this->company->setRuc(config('services.company.ruc'))
                     ->setRazonSocial(config('services.company.name'))
                     ->setNombreComercial(config('services.company.name'))
                     ->setAddress(new Address([
                         'direccion' => config('services.company.address'),
                         'distrito' => config('services.company.district'),
                         'provincia' => config('services.company.province'),
                         'departamento' => config('services.company.department'),
                         'ubigueo' => config('services.company.ubigeo', '150101')
                     ]));
    }

    /**
     * Enviar guía de remisión a SUNAT
     *
     * IMPORTANTE: SUNAT desactivó SOAP para guías de remisión (error 1085).
     * Ahora requiere usar la API REST de GRE con credenciales OAuth2.
     *
     * Para modo BETA/pruebas necesitas:
     * 1. Credenciales OAuth2 de SUNAT (diferentes a MODDATOS)
     * 2. O usar un PSE como Nubefact, FacturadorPE, etc.
     */
    public function enviarGuiaRemision(GuiaRemision $guia)
    {
        try {
            // Construir documento Greenter
            $despatch = $this->construirDocumentoGreenter($guia);

            // Generar XML firmado (sin enviar)
            $xml = $this->see->getXmlSigned($despatch);

            // Guardar XML en la guía
            $guia->update([
                'xml_firmado' => base64_encode($xml),
                'tiene_xml' => true
            ]);

            Log::info('XML de guía generado correctamente', [
                'guia_id' => $guia->id,
                'xml_length' => strlen($xml)
            ]);

            // NOTA: El envío a SUNAT requiere credenciales OAuth2
            // Por ahora solo generamos el XML
            $guia->update([
                'estado' => 'XML_GENERADO',
                'mensaje_sunat' => 'XML generado correctamente. Requiere credenciales OAuth2 para enviar a SUNAT.'
            ]);

            // Generar PDF
            $this->generarPdf($guia, $despatch);

            return [
                'success' => true,
                'mensaje' => 'XML de guía generado correctamente. NOTA: Para enviar a SUNAT necesitas configurar credenciales OAuth2 en el .env',
                'data' => [
                    'guia' => $guia->fresh(),
                    'xml_generado' => true,
                    'requiere_oauth2' => true,
                    'instrucciones' => 'Configura GREENTER_CLIENT_ID y GREENTER_CLIENT_SECRET en el .env para enviar a SUNAT'
                ]
            ];

        } catch (\Exception $e) {
            Log::error('Error en enviarGuiaRemision: ' . $e->getMessage(), [
                'guia_id' => $guia->id,
                'trace' => $e->getTraceAsString()
            ]);

            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Obtener instancia de See (para uso externo)
     */
    public function getSee()
    {
        return $this->see;
    }

    /**
     * Construir documento Greenter para guía de remisión (público para API REST)
     */
    public function construirDocumentoGreenterPublic(GuiaRemision $guia)
    {
        return $this->construirDocumentoGreenter($guia);
    }

    /**
     * Construir documento Greenter para guía de remisión
     */
    private function construirDocumentoGreenter(GuiaRemision $guia)
    {
        $despatch = new Despatch();

        // Datos básicos
        $fechaEmision = Carbon::parse($guia->fecha_emision);
        $fechaTraslado = Carbon::parse($guia->fecha_inicio_traslado ?? $guia->fecha_emision);

        // Tipo de documento según tipo de guía
        $tipoDoc = $guia->tipo_comprobante ?? '09';
        
        $despatch->setTipoDoc($tipoDoc)
                ->setSerie($guia->serie)
                ->setCorrelativo($guia->correlativo)
                ->setFechaEmision($fechaEmision)
                ->setCompany($this->company);

        // Agregar nota con comprobante relacionado (FT: F001-2950)
        if ($guia->nota_sunat) {
            $despatch->setObservacion($guia->nota_sunat);
        }

        // Destinatario
        if ($guia->destinatario_tipo_documento && $guia->destinatario_numero_documento) {
            $destinatario = new Client();
            $destinatario->setTipoDoc($guia->destinatario_tipo_documento)
                        ->setNumDoc($guia->destinatario_numero_documento)
                        ->setRznSocial($guia->destinatario_razon_social);

            if ($guia->destinatario_direccion) {
                $destinatario->setAddress(new Address([
                    'direccion' => $guia->destinatario_direccion,
                    'ubigueo' => $guia->destinatario_ubigeo ?? '150101'
                ]));
            }

            $despatch->setDestinatario($destinatario);
        }

        // Tercero (si es diferente del remitente o destinatario)
        if ($guia->cliente_id && ($guia->cliente_numero_documento != $this->company->getRuc())) {
            $tercero = new Client();
            $tercero->setTipoDoc($guia->cliente_tipo_documento)
                   ->setNumDoc($guia->cliente_numero_documento)
                   ->setRznSocial($guia->cliente_razon_social);

            $despatch->setTercero($tercero);
        }

        // Envío (Shipment) - Información del traslado
        $shipment = new Shipment();

        // Motivo y modalidad de traslado
        $shipment->setCodTraslado($guia->motivo_traslado ?? '01') // 01=Venta
                ->setDesTraslado($this->getMotivoTraslado($guia->motivo_traslado ?? '01'))
                ->setModTraslado($guia->modalidad_traslado ?? '02') // 01=Público, 02=Privado
                ->setFecTraslado($fechaTraslado);

        // Peso y bultos
        if ($guia->peso_total) {
            $shipment->setPesoTotal((float)$guia->peso_total);
        }

        if ($guia->numero_bultos) {
            $shipment->setNumBultos((int)$guia->numero_bultos);
        }

        // Datos del conductor - Requerido para transporte privado
        if (!$guia->esTrasladoInterno() && $guia->conductor_dni && $guia->conductor_nombres) {
            $driver = new Driver();
            $driver->setTipo('1') // 1=DNI
                  ->setNroDoc($guia->conductor_dni)
                  ->setLicencia('') // SUNAT no requiere licencia
                  ->setNombres($guia->conductor_nombres)
                  ->setApellidos(''); // Apellidos están incluidos en nombres

            $shipment->setChoferes([$driver]);
        }

        // Punto de partida
        if ($guia->punto_partida_direccion) {
            $partida = new Direction(
                $guia->punto_partida_ubigeo ?? '150101',
                $guia->punto_partida_direccion
            );

            $shipment->setPartida($partida);
        }

        // Punto de llegada
        if ($guia->punto_llegada_direccion) {
            $llegada = new Direction(
                $guia->punto_llegada_ubigeo ?? '150101',
                $guia->punto_llegada_direccion
            );

            $shipment->setLlegada($llegada);
        }

        $despatch->setEnvio($shipment);

        // Detalles de la guía (productos/bienes a transportar)
        $detalles = [];
        foreach ($guia->detalles as $detalle) {
            $item = new DespatchDetail();
            $item->setCantidad((float)$detalle->cantidad)
                ->setUnidad($detalle->unidad_medida ?? 'NIU')
                ->setDescripcion($detalle->descripcion)
                ->setCodigo($detalle->producto_id ? "P{$detalle->producto_id}" : 'PROD001');

            $detalles[] = $item;
        }

        $despatch->setDetails($detalles);

        // Si no hay nota SUNAT pero hay observaciones, usarlas
        if (!$guia->nota_sunat && $guia->observaciones) {
            $despatch->setObservacion($guia->observaciones);
        }

        return $despatch;
    }

    /**
     * Generar PDF de guía de remisión
     */
    public function generarPdf(GuiaRemision $guia, $despatch = null)
    {
        try {
            if (!$despatch) {
                $despatch = $this->construirDocumentoGreenter($guia);
            }

            $htmlReport = new HtmlReport();
            $pdfReport = new PdfReport($htmlReport);

            // Parámetros adicionales para el PDF
            $params = [
                'system' => [
                    'hash' => $guia->codigo_hash,
                ]
            ];

            // Agregar logo si existe
            $logoPath = public_path('logo-empresa.png');
            if (file_exists($logoPath) && is_readable($logoPath)) {
                try {
                    $logoContent = file_get_contents($logoPath);
                    if ($logoContent !== false) {
                        $params['system']['logo'] = $logoContent;
                        Log::info('Logo de empresa agregado al PDF de guía', ['guia_id' => $guia->id]);
                    }
                } catch (\Exception $e) {
                    Log::warning('Error al leer logo de empresa para guía', [
                        'path' => $logoPath,
                        'error' => $e->getMessage()
                    ]);
                }
            }

            $pdf = $pdfReport->render($despatch, $params);

            $guia->update([
                'pdf_base64' => base64_encode($pdf)
            ]);

            Log::info('PDF de guía generado exitosamente', [
                'guia_id' => $guia->id,
                'tamaño_bytes' => strlen($pdf)
            ]);

        } catch (\Exception $e) {
            Log::error('Error generando PDF de guía', [
                'guia_id' => $guia->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
        }
    }

    /**
     * Obtener descripción del motivo de traslado
     */
    private function getMotivoTraslado($codigo)
    {
        $motivos = [
            '01' => 'Venta',
            '02' => 'Compra',
            '04' => 'Traslado entre establecimientos de la misma empresa',
            '08' => 'Importación',
            '09' => 'Exportación',
            '13' => 'Otros'
        ];

        return $motivos[$codigo] ?? 'Otros';
    }

    /**
     * Obtener descripción del modo de transporte
     */
    private function getModoTransporte($codigo)
    {
        $modos = [
            '01' => 'Transporte público',
            '02' => 'Transporte privado'
        ];

        return $modos[$codigo] ?? 'Transporte privado';
    }

    /**
     * Método auxiliar para obtener CDR de forma segura
     */
    private function getCdrSafely($result)
    {
        try {
            if (method_exists($result, 'getCdrResponse')) {
                return $result->getCdrResponse();
            } elseif (method_exists($result, 'getCdr')) {
                return $result->getCdr();
            }
        } catch (\Exception $e) {
            // Ignorar errores de métodos no disponibles
        }
        return null;
    }

    /**
     * Método auxiliar para obtener CDR ZIP de forma segura
     */
    private function getCdrZipSafely($result)
    {
        try {
            if (method_exists($result, 'getCdrZip')) {
                return $result->getCdrZip();
            } elseif (method_exists($result, 'getZip')) {
                return $result->getZip();
            }
        } catch (\Exception $e) {
            // Ignorar errores de métodos no disponibles
        }
        return null;
    }
}
