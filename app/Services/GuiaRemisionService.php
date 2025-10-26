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
use Greenter\Model\Despatch\Transport;
use Greenter\Model\Despatch\Origin;
use Greenter\Model\Despatch\Delivery;
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
        // Validar y configurar certificado
        $certPath = config('services.greenter.cert_path');

        if (empty($certPath)) {
            throw new \Exception('La ruta del certificado no está configurada en services.greenter.cert_path');
        }

        if (!file_exists($certPath)) {
            throw new \Exception("Certificado no encontrado en la ruta: {$certPath}");
        }

        if (!is_readable($certPath)) {
            throw new \Exception("El certificado no tiene permisos de lectura: {$certPath}");
        }

        // Leer certificado
        $certificadoContenido = file_get_contents($certPath);

        if ($certificadoContenido === false) {
            throw new \Exception("Error al leer el contenido del certificado: {$certPath}");
        }

        // Configurar certificado
        $this->see->setCertificate($certificadoContenido);

        // Validar credenciales SOL
        $solUser = config('services.greenter.fe_user');
        $solPassword = config('services.greenter.fe_password');

        if (empty($solUser) || empty($solPassword)) {
            throw new \Exception('Las credenciales SOL no están configuradas correctamente');
        }

        // Configurar credenciales
        try {
            $solPasswordDecrypted = decrypt($solPassword);
            $this->see->setCredentials($solUser, $solPasswordDecrypted);
        } catch (\Exception $e) {
            $this->see->setCredentials($solUser, $solPassword);
        }

        // Configurar servicios SUNAT
        $ambiente = config('services.greenter.ambiente', 'beta');
        if ($ambiente === 'produccion') {
            $this->see->setService(SunatEndpoints::FE_PRODUCCION);
        } else {
            $this->see->setService(SunatEndpoints::FE_BETA);
        }

        Log::info('GuiaRemisionService configurado correctamente', [
            'ambiente' => $ambiente,
            'certificado' => basename($certPath)
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
     */
    public function enviarGuiaRemision(GuiaRemision $guia)
    {
        try {
            // Construir documento Greenter
            $despatch = $this->construirDocumentoGreenter($guia);

            // Enviar a SUNAT
            $result = $this->see->send($despatch);

            // Guardar XML
            $xml = $this->see->getFactory()->getLastXml();
            $guia->update(['xml_firmado' => $xml]);

            if ($result->isSuccess()) {
                // Obtener CDR si está disponible
                $cdrResponse = $this->getCdrSafely($result);
                $cdrZip = $this->getCdrZipSafely($result);

                $updateData = [
                    'estado' => 'ACEPTADO',
                    'xml_respuesta_sunat' => $cdrZip
                ];

                // Solo agregar datos del CDR si existe
                if ($cdrResponse) {
                    if (method_exists($cdrResponse, 'getDescription')) {
                        $updateData['mensaje_sunat'] = $cdrResponse->getDescription();
                    }

                    if (method_exists($cdrResponse, 'getDigestValue')) {
                        $updateData['codigo_hash'] = $cdrResponse->getDigestValue();
                    }
                }

                $guia->update($updateData);

                // Preparar datos de respuesta
                $responseData = [
                    'success' => true,
                    'mensaje' => 'Guía de remisión enviada a SUNAT exitosamente',
                    'data' => [
                        'guia' => $guia->fresh()
                    ]
                ];

                // Agregar detalles del CDR si existen
                if ($cdrResponse) {
                    if (method_exists($cdrResponse, 'getCode')) {
                        $responseData['data']['codigo_sunat'] = $cdrResponse->getCode();
                    }
                    if (method_exists($cdrResponse, 'getDescription')) {
                        $responseData['data']['mensaje_sunat'] = $cdrResponse->getDescription();
                    }
                }

                return $responseData;
            } else {
                $error = $result->getError();

                $guia->update([
                    'estado' => 'RECHAZADO',
                    'mensaje_sunat' => $error->getMessage(),
                    'errores_sunat' => $error->getMessage()
                ]);

                return [
                    'success' => false,
                    'error' => $error->getMessage(),
                    'codigo_error' => $error->getCode()
                ];
            }
        } catch (\Exception $e) {
            Log::error('Error en enviarGuiaRemision: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
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

        $despatch->setTipoDoc('09') // Tipo 09 = Guía de Remisión
                ->setSerie($guia->serie)
                ->setCorrelativo($guia->correlativo)
                ->setFechaEmision($fechaEmision)
                ->setCompany($this->company);

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
            $shipment->setPesoBruto((float)$guia->peso_total);
        }

        if ($guia->numero_bultos) {
            $shipment->setNumeroBultos((int)$guia->numero_bultos);
        }

        // Transportista (solo si es transporte privado - modalidad 02)
        if ($guia->modalidad_traslado === '02') {
            $transport = new Transport();

            // Modo de transporte (01=Terrestre, 02=Marítimo, etc.)
            if ($guia->modo_transporte) {
                $transport->setTransportMode($guia->modo_transporte);
            }

            // Datos del vehículo
            if ($guia->numero_placa) {
                $transport->setPlaca($guia->numero_placa);
            }

            // Datos del conductor
            if ($guia->conductor_dni && $guia->conductor_nombres) {
                $driver = new Driver();
                $driver->setTipo('1') // 1=DNI
                      ->setNroDoc($guia->conductor_dni)
                      ->setLicencia($guia->numero_licencia ?? '')
                      ->setNombres($guia->conductor_nombres)
                      ->setApellidos(''); // Apellidos están incluidos en nombres

                $transport->setDriver($driver);
            }

            $shipment->setTransport($transport);
        }

        // Punto de partida
        if ($guia->punto_partida_direccion) {
            $origin = new Origin();
            $origin->setUbigueo($guia->punto_partida_ubigeo ?? '150101')
                  ->setDireccion($guia->punto_partida_direccion);

            $shipment->setOrigin($origin);
        }

        // Punto de llegada
        if ($guia->punto_llegada_direccion) {
            $delivery = new Delivery();
            $delivery->setUbigueo($guia->punto_llegada_ubigeo ?? '150101')
                    ->setDireccion($guia->punto_llegada_direccion);

            $shipment->setDelivery($delivery);
        }

        $despatch->setShipment($shipment);

        // Detalles de la guía (productos/bienes a transportar)
        $detalles = [];
        foreach ($guia->detalles as $detalle) {
            $item = new DespatchDetail();
            $item->setCantidad((float)$detalle->cantidad)
                ->setUnidad($detalle->unidad_medida ?? 'NIU')
                ->setDescripcion($detalle->descripcion)
                ->setCodigo($detalle->producto_id ? "P{$detalle->producto_id}" : 'PROD001');

            // Peso unitario (opcional)
            if ($detalle->peso_unitario) {
                $item->setPeso((float)$detalle->peso_unitario);
            }

            $detalles[] = $item;
        }

        $despatch->setDetails($detalles);

        // Observaciones (opcional)
        if ($guia->observaciones) {
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
