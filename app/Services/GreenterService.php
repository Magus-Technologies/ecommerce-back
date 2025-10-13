<?php

namespace App\Services;

use Greenter\See;
use Greenter\Ws\Services\SunatEndpoints;
use Greenter\Model\Client\Client;
use Greenter\Model\Company\Company;
use Greenter\Model\Company\Address;
use Greenter\Model\Sale\Invoice;
use Greenter\Model\Sale\SaleDetail;
use Greenter\Model\Sale\Legend;
use Greenter\Model\Sale\Document;
use Greenter\Report\HtmlReport;
use Greenter\Report\PdfReport;
use App\Models\Comprobante;
use App\Models\Cliente;
use App\Models\SerieComprobante;
use App\Models\SunatLog;
use App\Models\SunatErrorCode;
use Luecano\NumeroALetras\NumeroALetras;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class GreenterService
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
    // Configurar certificado (que incluye la clave privada)
    $this->see->setCertificate(file_get_contents(config('services.greenter.cert_path')));
    
    // Si tu certificado tiene contraseña, úsala aquí
    // $this->see->setClave('tu_password_del_certificado');
    
    $this->see->setCredentials(
        config('services.greenter.fe_user'),
        config('services.greenter.fe_password')
    );

    // Configurar servicios SUNAT
    $ambiente = config('services.greenter.ambiente', 'beta');
    if ($ambiente === 'produccion') {
        $this->see->setService(SunatEndpoints::FE_PRODUCCION);
    } else {
        $this->see->setService(SunatEndpoints::FE_BETA);
    }
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
                         'ubigueo' => '150101' // Lima-Lima-Lima por defecto
                     ]));
    }

    public function generarFactura($ventaId, $clienteData = null, $userId = null, $ipOrigen = null)
    {
        try {
            $venta = \App\Models\Venta::with(['detalles.producto', 'cliente'])->findOrFail($ventaId);
            
            // Determinar cliente
            $cliente = $clienteData ? $this->procesarDatosCliente($clienteData) : $venta->cliente;
            
            // Determinar tipo de comprobante
            $tipoComprobante = $cliente->tipo_documento === '6' ? '01' : '03'; // Factura o Boleta
            
            // Obtener serie
            $serie = SerieComprobante::where('tipo_comprobante', $tipoComprobante)
                                   ->where('activo', true)
                                   ->first();
            
            if (!$serie) {
                throw new \Exception("No hay series configuradas para el tipo de comprobante {$tipoComprobante}");
            }

            // Generar nuevo correlativo
            $correlativo = $serie->siguienteCorrelativo();

            // Crear comprobante en base de datos
            $comprobante = $this->crearComprobante($venta, $cliente, $tipoComprobante, $serie->serie, $correlativo);

            // Generar documento para Greenter
            $invoice = $this->construirDocumentoGreenter($comprobante, $cliente);

            // Enviar a SUNAT
            $result = $this->see->send($invoice);
            
            // Log del envío a SUNAT
            $xml = $this->see->getFactory()->getLastXml();
            if ($xml) {
                file_put_contents('xml_debug.xml', $xml);
                Log::info('XML Generado', ['xml' => $xml]);
                
                // Crear log de SUNAT
                $sunatLog = SunatLog::logEnvio($comprobante->id, $xml, $userId, $ipOrigen);
            }

            // Procesar respuesta con logging
            $this->procesarRespuestaSunatConLog($comprobante, $result, $invoice, $sunatLog ?? null);

            // Generar PDF
            $this->generarPdf($comprobante, $invoice);

            // Actualizar estado de venta
            $venta->update([
                'estado' => 'FACTURADO',
                'comprobante_id' => $comprobante->id
            ]);

            return [
                'success' => true,
                'comprobante' => $comprobante->fresh(),
                'mensaje' => 'Comprobante generado y enviado correctamente'
            ];

        } catch (\Exception $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    private function procesarDatosCliente($clienteData)
    {
        // Buscar cliente existente o crear uno nuevo
        $cliente = Cliente::where('numero_documento', $clienteData['numero_documento'])->first();
        
        if (!$cliente) {
            $cliente = Cliente::create([
                'tipo_documento' => $clienteData['tipo_documento'],
                'numero_documento' => $clienteData['numero_documento'],
                'razon_social' => $clienteData['razon_social'],
                'direccion' => $clienteData['direccion'] ?? 'Sin dirección',
                'email' => $clienteData['email'] ?? null,
                'telefono' => $clienteData['telefono'] ?? null,
                'activo' => true
            ]);
        }

        return $cliente;
    }

    private function crearComprobante($venta, $cliente, $tipoComprobante, $serie, $correlativo)
    {
        $comprobante = Comprobante::create([
            'tipo_comprobante' => $tipoComprobante,
            'serie' => $serie,
            'correlativo' => $correlativo,
            'fecha_emision' => now()->format('Y-m-d'),
            'cliente_id' => $cliente->id,
            'cliente_tipo_documento' => $cliente->tipo_documento,
            'cliente_numero_documento' => $cliente->numero_documento,
            'cliente_razon_social' => $cliente->razon_social,
            'cliente_direccion' => $cliente->direccion,
            'moneda' => 'PEN',
            'operacion_gravada' => $venta->subtotal,
            'total_igv' => $venta->igv,
            'importe_total' => $venta->total,
            'user_id' => 1, // Usuario por defecto para pruebas
            'estado' => 'PENDIENTE'
        ]);

        // Crear detalles
        foreach ($venta->detalles as $index => $detalle) {
            $comprobante->detalles()->create([
                'item' => $index + 1,
                'producto_id' => $detalle->producto_id,
                'codigo_producto' => $detalle->codigo_producto,
                'descripcion' => $detalle->nombre_producto,
                'unidad_medida' => 'NIU',
                'cantidad' => $detalle->cantidad,
                'valor_unitario' => $detalle->precio_sin_igv,
                'precio_unitario' => $detalle->precio_unitario,
                'descuento' => $detalle->descuento_unitario * $detalle->cantidad,
                'valor_venta' => $detalle->subtotal_linea,
                'porcentaje_igv' => 18.00,
                'igv' => $detalle->igv_linea,
                'tipo_afectacion_igv' => '10',
                'importe_total' => $detalle->total_linea
            ]);
        }

        return $comprobante;
    }

    public function construirDocumentoGreenter($comprobante, $cliente)
    {
        $invoice = new Invoice();
        
        // Datos básicos
        $fechaEmision = Carbon::parse($comprobante->fecha_emision);
        
        $invoice->setUblVersion('2.1')
                ->setTipoOperacion('1001')  // 1001 = Venta interna (Catálogo 51 UBL 2.1)
                ->setTipoDoc($comprobante->tipo_comprobante)
                ->setSerie($comprobante->serie)
                ->setCorrelativo($comprobante->correlativo)
                ->setFechaEmision($fechaEmision)
                ->setTipoMoneda($comprobante->moneda)
                ->setCompany($this->company);

        // Cliente
        $client = new Client();
        $client->setTipoDoc($comprobante->cliente_tipo_documento)
               ->setNumDoc($comprobante->cliente_numero_documento)
               ->setRznSocial($comprobante->cliente_razon_social);

        if ($cliente->direccion) {
            $client->setAddress(new Address(['direccion' => $cliente->direccion]));
        }

        $invoice->setClient($client);

        // Detalles - Asegurar precisión decimal
        $items = [];
        foreach ($comprobante->detalles as $detalle) {
            $valorUnitario = (float)number_format((float)$detalle->valor_unitario, 2, '.', '');
            $valorVenta = (float)number_format((float)$detalle->valor_venta, 2, '.', '');
            $igv = (float)number_format((float)$detalle->igv, 2, '.', '');
            $precioUnitario = (float)number_format((float)$detalle->precio_unitario, 2, '.', '');
            
            $item = new SaleDetail();
            $item->setCodProducto($detalle->codigo_producto)
                 ->setUnidad($detalle->unidad_medida)
                 ->setDescripcion($detalle->descripcion)
                 ->setCantidad((float)$detalle->cantidad)
                 ->setMtoValorUnitario($valorUnitario)
                 ->setMtoValorVenta($valorVenta)
                 ->setMtoBaseIgv($valorVenta)
                 ->setPorcentajeIgv((float)$detalle->porcentaje_igv)
                 ->setIgv($igv)
                 ->setTipAfeIgv($detalle->tipo_afectacion_igv)
                 ->setTotalImpuestos($igv)
                 ->setMtoPrecioUnitario($precioUnitario);

            $items[] = $item;
        }

        $invoice->setDetails($items);

        // Totales - Asegurar precisión decimal y fórmula correcta
        $mtoOperGravadas = number_format((float)$comprobante->operacion_gravada, 2, '.', '');
        $mtoIGV = number_format((float)$comprobante->total_igv, 2, '.', '');
        $mtoImpVenta = number_format((float)$comprobante->importe_total, 2, '.', '');
        
        // Verificar que la fórmula cuadre: MtoOperGravadas + IGV = MtoImpVenta
        $calculado = number_format($mtoOperGravadas + $mtoIGV, 2, '.', '');
        if ($calculado != $mtoImpVenta) {
            throw new \Exception("Error de cálculo: $mtoOperGravadas + $mtoIGV = $calculado, pero MtoImpVenta es $mtoImpVenta");
        }
        
        $invoice->setMtoOperGravadas((float)$mtoOperGravadas)
                ->setMtoOperExoneradas(0.00)
                ->setMtoOperInafectas(0.00)
                ->setMtoIGV((float)$mtoIGV)
                ->setValorVenta((float)$mtoOperGravadas)  // LineExtensionAmount (sin IGV)
                ->setSubTotal((float)$mtoImpVenta)        // TaxInclusiveAmount (con IGV)
                ->setTotalImpuestos((float)$mtoIGV)
                ->setMtoImpVenta((float)$mtoImpVenta);    // PayableAmount

        // Leyendas
        $formatter = new NumeroALetras();
        $legend = new Legend();
        $legend->setCode('1000')
               ->setValue($formatter->toInvoice($comprobante->importe_total, 2, 'SOLES'));

        $invoice->setLegends([$legend]);

        return $invoice;
    }

    private function procesarRespuestaSunat($comprobante, $result, $invoice)
    {
        $comprobante->update([
            'xml_firmado' => $this->see->getFactory()->getLastXml(),
            'codigo_hash' => $result->getCdrResponse() ? $result->getCdrResponse()->getDigestValue() : null
        ]);

        if ($result->isSuccess()) {
            $cdr = $result->getCdrResponse();
            
            $comprobante->update([
                'estado' => 'ACEPTADO',
                'xml_respuesta_sunat' => $result->getCdrZip(),
                'mensaje_sunat' => $cdr->getDescription()
            ]);
        } else {
            $comprobante->update([
                'estado' => 'RECHAZADO',
                'mensaje_sunat' => $result->getError()->getMessage()
            ]);
            
            throw new \Exception('Error SUNAT: ' . $result->getError()->getMessage());
        }
    }

    private function generarPdf($comprobante, $invoice)
    {
        try {
            $htmlReport = new HtmlReport();
            $pdfReport = new PdfReport($htmlReport);
            
            // Parámetros adicionales para el PDF
            $params = [
                'system' => [
                    'logo' => file_get_contents(public_path('logo-empresa.png')), // Logo de la empresa
                    'hash' => $comprobante->codigo_hash,
                ]
            ];

            $pdf = $pdfReport->render($invoice, $params);
            
            $comprobante->update([
                'pdf_base64' => base64_encode($pdf)
            ]);

        } catch (\Exception $e) {
            // Log del error pero no fallar el proceso
            Log::error('Error generando PDF: ' . $e->getMessage());
        }
    }

    public function consultarComprobante($comprobante)
    {
        try {
            $result = $this->see->getStatus($comprobante->serie . '-' . $comprobante->correlativo, $comprobante->tipo_comprobante);
            
            if ($result->isSuccess()) {
                $cdr = $result->getCdrResponse();
                
                $comprobante->update([
                    'estado' => 'ACEPTADO',
                    'xml_respuesta_sunat' => $result->getCdrZip(),
                    'mensaje_sunat' => $cdr->getDescription()
                ]);
                
                return ['success' => true, 'estado' => 'ACEPTADO'];
            } else {
                return ['success' => false, 'error' => $result->getError()->getMessage()];
            }
            
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    public function reenviarComprobante($comprobanteId)
    {
        try {
            $comprobante = Comprobante::findOrFail($comprobanteId);
            
            if (!$comprobante->puedeReenviar()) {
                throw new \Exception('El comprobante no puede ser reenviado');
            }

            // Reconstruir documento
            $invoice = $this->construirDocumentoGreenter($comprobante, $comprobante->cliente);
            
            // Reenviar
            $result = $this->see->send($invoice);
            
            // Procesar respuesta
            $this->procesarRespuestaSunat($comprobante, $result, $invoice);
            
            return [
                'success' => true,
                'comprobante' => $comprobante->fresh(),
                'mensaje' => 'Comprobante reenviado correctamente'
            ];
            
        } catch (\Exception $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Procesar respuesta de SUNAT con logging completo
     */
    private function procesarRespuestaSunatConLog($comprobante, $result, $invoice, $sunatLog = null)
    {
        $startTime = microtime(true);
        
        if ($result->isSuccess()) {
            // Éxito
            $ticket = method_exists($result, 'getTicket') ? $result->getTicket() : null;
            $comprobante->update([
                'estado' => 'ACEPTADO',
                'numero_ticket' => $ticket,
                'fecha_aceptacion' => now(),
                'mensaje_sunat' => 'El comprobante ha sido aceptado',
                'xml_firmado' => $this->see->getFactory()->getLastXml(),
                'hash_firma' => $this->generarHashFirma($invoice)
            ]);

            // Log de respuesta exitosa
            if ($sunatLog) {
                SunatLog::logRespuesta(
                    $comprobante->id,
                    'ACEPTADO',
                    $ticket,
                    $this->see->getFactory()->getLastXml(),
                    method_exists($result, 'getCdrResponse') ? $result->getCdrResponse() : null,
                    'El comprobante ha sido aceptado',
                    null,
                    round((microtime(true) - $startTime) * 1000)
                );
            }

            Log::info('Factura aceptada por SUNAT', [
                'comprobante_id' => $comprobante->id,
                'ticket' => $ticket
            ]);

        } else {
            // Error - Procesar códigos de error SUNAT
            $errores = $result->getError()->getMessage();
            $ticket = method_exists($result, 'getTicket') ? $result->getTicket() : null;
            
            // Extraer códigos de error del mensaje
            $codigosError = $this->extraerCodigosError($errores);
            $informacionErrores = $this->obtenerInformacionErrores($codigosError);
            
            $comprobante->update([
                'estado' => 'RECHAZADO',
                'numero_ticket' => $ticket,
                'errores_sunat' => $errores,
                'codigos_error_sunat' => json_encode($codigosError),
                'informacion_errores' => json_encode($informacionErrores),
                'mensaje_sunat' => 'El comprobante fue rechazado por SUNAT'
            ]);

            // Log de respuesta con error
            if ($sunatLog) {
                SunatLog::logRespuesta(
                    $comprobante->id,
                    'RECHAZADO',
                    $ticket,
                    $this->see->getFactory()->getLastXml(),
                    method_exists($result, 'getCdrResponse') ? $result->getCdrResponse() : null,
                    'El comprobante fue rechazado por SUNAT',
                    $errores,
                    round((microtime(true) - $startTime) * 1000)
                );
            }

            Log::error('Factura rechazada por SUNAT', [
                'comprobante_id' => $comprobante->id,
                'ticket' => $ticket,
                'errores' => $errores,
                'codigos_error' => $codigosError,
                'informacion_errores' => $informacionErrores
            ]);
        }
    }

    /**
     * Generar hash de la firma digital
     */
    private function generarHashFirma($invoice)
    {
        try {
            $xml = $this->see->getFactory()->getLastXml();
            if ($xml) {
                return hash('sha256', $xml);
            }
        } catch (\Exception $e) {
            Log::warning('Error generando hash de firma: ' . $e->getMessage());
        }
        
        return null;
    }

    /**
     * Extraer códigos de error del mensaje de SUNAT
     */
    private function extraerCodigosError($mensajeError)
    {
        $codigos = [];
        
        // Buscar patrones como "0100", "0101", etc.
        if (preg_match_all('/\b(\d{4})\b/', $mensajeError, $matches)) {
            $codigos = array_unique($matches[1]);
        }
        
        // Buscar patrones como "soap:Server.0100"
        if (preg_match_all('/\.(\d{4})/', $mensajeError, $matches)) {
            $codigos = array_merge($codigos, array_unique($matches[1]));
        }
        
        // Buscar patrones como "error: 0100"
        if (preg_match_all('/error:\s*(\d{4})/', $mensajeError, $matches)) {
            $codigos = array_merge($codigos, array_unique($matches[1]));
        }
        
        return array_unique($codigos);
    }

    /**
     * Obtener información detallada de los códigos de error
     */
    private function obtenerInformacionErrores($codigosError)
    {
        $informacion = [];
        
        foreach ($codigosError as $codigo) {
            $informacion[] = SunatErrorCode::obtenerInformacionError($codigo);
        }
        
        return $informacion;
    }

    /**
     * Obtener información de error por código
     */
    public function obtenerErrorPorCodigo($codigo)
    {
        return SunatErrorCode::obtenerInformacionError($codigo);
    }

    /**
     * Obtener todos los códigos de error activos
     */
    public function obtenerTodosLosErrores()
    {
        return SunatErrorCode::obtenerActivos();
    }

    /**
     * Obtener errores por categoría
     */
    public function obtenerErroresPorCategoria($categoria)
    {
        return SunatErrorCode::obtenerPorCategoria($categoria);
    }
}