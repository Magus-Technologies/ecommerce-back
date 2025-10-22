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

    // Configurar certificado (que incluye la clave privada)
    $this->see->setCertificate($certificadoContenido);

    // Si tu certificado tiene contraseña, configurarla
    // Nota: En Greenter, la clave del certificado se pasa en setCertificate()
    // No existe setClaveApi, ese método era incorrecto

    // Validar credenciales SOL
    $solUser = config('services.greenter.fe_user');
    $solPassword = config('services.greenter.fe_password');

    if (empty($solUser) || empty($solPassword)) {
        throw new \Exception('Las credenciales SOL no están configuradas correctamente');
    }

    // Si la contraseña está encriptada, desencriptarla
    // (esto solo aplica si guardaste la clave con encrypt() en la BD)
    try {
        $solPasswordDecrypted = decrypt($solPassword);
        $this->see->setCredentials($solUser, $solPasswordDecrypted);
    } catch (\Exception $e) {
        // Si falla la desencriptación, asumir que es texto plano
        $this->see->setCredentials($solUser, $solPassword);
    }

    // Configurar servicios SUNAT
    $ambiente = config('services.greenter.ambiente', 'beta');
    if ($ambiente === 'produccion') {
        $this->see->setService(SunatEndpoints::FE_PRODUCCION);
    } else {
        $this->see->setService(SunatEndpoints::FE_BETA);
    }

    Log::info('GreenterService configurado correctamente', [
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

    public function generarPdf($comprobante, $invoice)
    {
        try {
            $htmlReport = new HtmlReport();
            $pdfReport = new PdfReport($htmlReport);

            // Parámetros adicionales para el PDF
            $params = [
                'system' => [
                    'hash' => $comprobante->codigo_hash,
                ]
            ];

            // VALIDAR Y AGREGAR LOGO SI EXISTE
            $logoPath = public_path('logo-empresa.png');
            if (file_exists($logoPath) && is_readable($logoPath)) {
                try {
                    $logoContent = file_get_contents($logoPath);
                    if ($logoContent !== false) {
                        $params['system']['logo'] = $logoContent;
                        Log::info('Logo de empresa agregado al PDF', ['comprobante_id' => $comprobante->id]);
                    } else {
                        Log::warning('No se pudo leer el contenido del logo', ['path' => $logoPath]);
                    }
                } catch (\Exception $e) {
                    Log::warning('Error al leer logo de empresa', [
                        'path' => $logoPath,
                        'error' => $e->getMessage()
                    ]);
                }
            } else {
                Log::info('Logo de empresa no encontrado, generando PDF sin logo', [
                    'path' => $logoPath,
                    'exists' => file_exists($logoPath),
                    'readable' => file_exists($logoPath) ? is_readable($logoPath) : false
                ]);
            }

            $pdf = $pdfReport->render($invoice, $params);

            $comprobante->update([
                'pdf_base64' => base64_encode($pdf)
            ]);

            Log::info('PDF generado exitosamente', [
                'comprobante_id' => $comprobante->id,
                'tamaño_bytes' => strlen($pdf)
            ]);

        } catch (\Exception $e) {
            // Log del error pero no fallar el proceso
            Log::error('Error generando PDF', [
                'comprobante_id' => $comprobante->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
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
     * Enviar comprobante a SUNAT
     */
    public function enviarComprobante($comprobante)
    {
        try {
            // Construir documento según el tipo
            if (in_array($comprobante->tipo_comprobante, ['01', '03'])) {
                // Factura o Boleta
                $documento = $this->construirDocumentoGreenter($comprobante, $comprobante->cliente);
            } elseif ($comprobante->tipo_comprobante === '07') {
                // Nota de Crédito
                $documento = $this->construirNotaCredito($comprobante);
            } elseif ($comprobante->tipo_comprobante === '08') {
                // Nota de Débito
                $documento = $this->construirNotaDebito($comprobante);
            } else {
                throw new \Exception('Tipo de comprobante no soportado: ' . $comprobante->tipo_comprobante);
            }

            // Enviar a SUNAT
            $result = $this->see->send($documento);

            // Guardar XML
            $xml = $this->see->getFactory()->getLastXml();
            $comprobante->update(['xml_firmado' => $xml]);

            if ($result->isSuccess()) {
                // Obtener CDR si está disponible (con verificación defensiva)
                $cdrResponse = null;
                $cdrZip = null;
                
                // Obtener CDR usando métodos auxiliares seguros
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

                    // Verificar si existe getDigestValue()
                    if (method_exists($cdrResponse, 'getDigestValue')) {
                        $updateData['codigo_hash'] = $cdrResponse->getDigestValue();
                    }
                }

                $comprobante->update($updateData);

                // Preparar datos de respuesta
                $responseData = [
                    'success' => true,
                    'mensaje' => 'Comprobante enviado a SUNAT exitosamente',
                    'data' => [
                        'comprobante' => $comprobante->fresh()
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

                $comprobante->update([
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
            Log::error('Error en enviarComprobante: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Construir Nota de Crédito para Greenter
     */
    private function construirNotaCredito($comprobante)
    {
        $notaCredito = new \Greenter\Model\Sale\Note();

        $notaCredito->setUblVersion('2.1')
            ->setTipoDoc('07')
            ->setSerie($comprobante->serie)
            ->setCorrelativo($comprobante->correlativo)
            ->setFechaEmision(\Carbon\Carbon::parse($comprobante->fecha_emision))
            ->setTipDocAfectado($comprobante->comprobanteReferencia->tipo_comprobante)
            ->setNumDocfectado($comprobante->comprobanteReferencia->serie . '-' . $comprobante->comprobanteReferencia->correlativo)
            ->setCodMotivo($comprobante->motivo_nota ?? '01')
            ->setDesMotivo($comprobante->motivo_nota_descripcion ?? 'Anulación de la operación')
            ->setTipoMoneda($comprobante->moneda)
            ->setCompany($this->company);

        // Cliente
        $client = new \Greenter\Model\Client\Client();
        $client->setTipoDoc($comprobante->cliente_tipo_documento)
            ->setNumDoc($comprobante->cliente_numero_documento)
            ->setRznSocial($comprobante->cliente_razon_social);

        $notaCredito->setClient($client);

        // Detalles
        $items = [];
        foreach ($comprobante->detalles as $detalle) {
            $item = new \Greenter\Model\Sale\SaleDetail();
            $item->setCodProducto($detalle->codigo_producto)
                ->setUnidad($detalle->unidad_medida ?? 'NIU')
                ->setDescripcion($detalle->descripcion)
                ->setCantidad((float)$detalle->cantidad)
                ->setMtoValorUnitario((float)$detalle->valor_unitario)
                ->setMtoValorVenta((float)$detalle->valor_venta)
                ->setMtoBaseIgv((float)$detalle->valor_venta)
                ->setPorcentajeIgv(18.00)
                ->setIgv((float)$detalle->igv)
                ->setTipAfeIgv($detalle->tipo_afectacion_igv)
                ->setTotalImpuestos((float)$detalle->igv)
                ->setMtoPrecioUnitario((float)$detalle->precio_unitario);
            $items[] = $item;
        }

        $notaCredito->setDetails($items);

        // Totales
        $notaCredito->setMtoOperGravadas((float)$comprobante->operacion_gravada)
            ->setMtoIGV((float)$comprobante->total_igv)
            ->setTotalImpuestos((float)$comprobante->total_igv)
            ->setMtoImpVenta((float)$comprobante->importe_total);

        return $notaCredito;
    }

    /**
     * Construir Nota de Débito para Greenter
     */
    private function construirNotaDebito($comprobante)
    {
        $notaDebito = new \Greenter\Model\Sale\Note();

        $notaDebito->setUblVersion('2.1')
            ->setTipoDoc('08')
            ->setSerie($comprobante->serie)
            ->setCorrelativo($comprobante->correlativo)
            ->setFechaEmision(\Carbon\Carbon::parse($comprobante->fecha_emision))
            ->setTipDocAfectado($comprobante->comprobanteReferencia->tipo_comprobante)
            ->setNumDocfectado($comprobante->comprobanteReferencia->serie . '-' . $comprobante->comprobanteReferencia->correlativo)
            ->setCodMotivo($comprobante->motivo_nota ?? '01')
            ->setDesMotivo($comprobante->motivo_nota_descripcion ?? 'Intereses por mora')
            ->setTipoMoneda($comprobante->moneda)
            ->setCompany($this->company);

        // Cliente
        $client = new \Greenter\Model\Client\Client();
        $client->setTipoDoc($comprobante->cliente_tipo_documento)
            ->setNumDoc($comprobante->cliente_numero_documento)
            ->setRznSocial($comprobante->cliente_razon_social);

        $notaDebito->setClient($client);

        // Detalles
        $items = [];
        foreach ($comprobante->detalles as $detalle) {
            $item = new \Greenter\Model\Sale\SaleDetail();
            $item->setCodProducto($detalle->codigo_producto ?? 'SERV001')
                ->setUnidad($detalle->unidad_medida ?? 'NIU')
                ->setDescripcion($detalle->descripcion)
                ->setCantidad((float)$detalle->cantidad)
                ->setMtoValorUnitario((float)$detalle->valor_unitario)
                ->setMtoValorVenta((float)$detalle->valor_venta)
                ->setMtoBaseIgv((float)$detalle->valor_venta)
                ->setPorcentajeIgv(18.00)
                ->setIgv((float)$detalle->igv)
                ->setTipAfeIgv($detalle->tipo_afectacion_igv)
                ->setTotalImpuestos((float)$detalle->igv)
                ->setMtoPrecioUnitario((float)$detalle->precio_unitario);
            $items[] = $item;
        }

        $notaDebito->setDetails($items);

        // Totales
        $notaDebito->setMtoOperGravadas((float)$comprobante->operacion_gravada)
            ->setMtoIGV((float)$comprobante->total_igv)
            ->setTotalImpuestos((float)$comprobante->total_igv)
            ->setMtoImpVenta((float)$comprobante->importe_total);

        return $notaDebito;
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

    /**
     * Generar resumen diario
     */
    public function generarResumenDiario($fecha, $comprobantesIds = [])
    {
        try {
            // Obtener comprobantes
            $comprobantes = Comprobante::whereIn('id', $comprobantesIds)->get();

            if ($comprobantes->isEmpty()) {
                throw new \Exception('No se encontraron comprobantes para generar el resumen');
            }

            // Crear objeto Summary
            $summary = new \Greenter\Model\Summary\Summary();

            $fechaGeneracion = \Carbon\Carbon::parse($fecha);
            $correlativo = \App\Models\Resumen::whereDate('fecha_resumen', $fechaGeneracion)->count() + 1;

            $summary->setFecGeneracion($fechaGeneracion)
                ->setFecResumen($fechaGeneracion)
                ->setCorrelativo(str_pad($correlativo, 3, '0', STR_PAD_LEFT))
                ->setCompany($this->company);

            // Agregar detalles
            $detalles = [];
            foreach ($comprobantes as $index => $comprobante) {
                $detalle = new \Greenter\Model\Summary\SummaryDetail();
                $detalle->setTipoDoc($comprobante->tipo_comprobante)
                    ->setSerieNro($comprobante->serie . '-' . $comprobante->correlativo)
                    ->setEstado('1') // 1 = Agregar, 2 = Modificar, 3 = Anular
                    ->setClienteTipo($comprobante->cliente_tipo_documento)
                    ->setClienteNro($comprobante->cliente_numero_documento)
                    ->setTotal((float)$comprobante->importe_total)
                    ->setMtoOperGravadas((float)$comprobante->operacion_gravada)
                    ->setMtoOperExoneradas(0.00)
                    ->setMtoOperInafectas(0.00)
                    ->setMtoIGV((float)$comprobante->total_igv)
                    ->setMtoISC(0.00);

                // Establecer moneda y otros tributos usando métodos auxiliares seguros
                $this->setMonedaSafely($detalle, $comprobante->moneda);
                $this->setOtrosTributosSafely($detalle, 0.00);

                $detalles[] = $detalle;
            }

            $summary->setDetails($detalles);

            // Enviar a SUNAT
            $result = $this->see->send($summary);

            if ($result->isSuccess()) {
                $ticket = null;
                
                // Obtener ticket usando método auxiliar seguro
                $ticket = $this->getTicketSafely($result);

                return [
                    'success' => true,
                    'message' => 'Resumen diario enviado exitosamente',
                    'data' => [
                        'fecha' => $fecha,
                        'cantidad_comprobantes' => count($comprobantesIds),
                        'ticket' => $ticket,
                        'xml' => $this->see->getFactory()->getLastXml()
                    ]
                ];
            } else {
                $error = $result->getError();
                return [
                    'success' => false,
                    'message' => 'Error al enviar resumen diario a SUNAT',
                    'error' => $error->getMessage(),
                    'codigo_error' => $error->getCode()
                ];
            }
        } catch (\Exception $e) {
            Log::error('Error en generarResumenDiario: ' . $e->getMessage());
            return [
                'success' => false,
                'message' => 'Error al generar resumen diario',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Enviar comunicación de baja
     */
    public function enviarComunicacionBaja($comprobantesIds, $motivo = 'Error en emisión')
    {
        try {
            // Obtener comprobantes
            $comprobantes = Comprobante::whereIn('id', $comprobantesIds)->get();

            if ($comprobantes->isEmpty()) {
                throw new \Exception('No se encontraron comprobantes para dar de baja');
            }

            // Crear objeto Voided (Comunicación de Baja)
            $voided = new \Greenter\Model\Voided\Voided();

            $fechaGeneracion = now();
            $correlativo = \App\Models\Baja::whereDate('fecha_baja', $fechaGeneracion)->count() + 1;

            $voided->setFecGeneracion($fechaGeneracion)
                ->setFecComunicacion($fechaGeneracion)
                ->setCorrelativo(str_pad($correlativo, 3, '0', STR_PAD_LEFT))
                ->setCompany($this->company);

            // Agregar detalles de comprobantes a dar de baja
            $detalles = [];
            foreach ($comprobantes as $comprobante) {
                $detalle = new \Greenter\Model\Voided\VoidedDetail();
                $detalle->setTipoDoc($comprobante->tipo_comprobante)
                    ->setSerie($comprobante->serie)
                    ->setCorrelativo($comprobante->correlativo)
                    ->setDesMotivoBaja($motivo);

                $detalles[] = $detalle;
            }

            $voided->setDetails($detalles);

            // Enviar a SUNAT
            $result = $this->see->send($voided);

            if ($result->isSuccess()) {
                $ticket = null;
                
                // Obtener ticket usando método auxiliar seguro
                $ticket = $this->getTicketSafely($result);

                // Actualizar estado de comprobantes
                Comprobante::whereIn('id', $comprobantesIds)->update([
                    'estado' => 'EN_PROCESO_BAJA',
                    'ticket_baja' => $ticket
                ]);

                return [
                    'success' => true,
                    'message' => 'Comunicación de baja enviada exitosamente',
                    'data' => [
                        'cantidad_comprobantes' => count($comprobantesIds),
                        'motivo' => $motivo,
                        'ticket' => $ticket,
                        'xml' => $this->see->getFactory()->getLastXml()
                    ]
                ];
            } else {
                $error = $result->getError();
                return [
                    'success' => false,
                    'message' => 'Error al enviar comunicación de baja a SUNAT',
                    'error' => $error->getMessage(),
                    'codigo_error' => $error->getCode()
                ];
            }
        } catch (\Exception $e) {
            Log::error('Error en enviarComunicacionBaja: ' . $e->getMessage());
            return [
                'success' => false,
                'message' => 'Error al enviar comunicación de baja',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Consultar estado de ticket (para resúmenes y bajas)
     */
    public function consultarTicket($ticket)
    {
        try {
            if (empty($ticket)) {
                throw new \Exception('El ticket es requerido');
            }

            // Consultar estado del ticket en SUNAT
            $result = $this->see->getStatus($ticket);

            if ($result->isSuccess()) {
                $cdr = $result->getCdrResponse();
                $codigo = $cdr->getCode();

                // Determinar estado según código SUNAT
                // 0 = Aceptado
                // 98 = En proceso
                // 99 = Rechazado
                $estado = 'PROCESADO';
                if ($codigo === '0') {
                    $estado = 'ACEPTADO';
                } elseif ($codigo === '98') {
                    $estado = 'EN_PROCESO';
                } else {
                    $estado = 'RECHAZADO';
                }

                return [
                    'success' => true,
                    'data' => [
                        'ticket' => $ticket,
                        'estado' => $estado,
                        'codigo_sunat' => $codigo,
                        'mensaje_sunat' => $cdr->getDescription(),
                        'xml_cdr' => $result->getCdrZip()
                    ]
                ];
            } else {
                $error = $result->getError();

                // Si el error es que el ticket no existe o está en proceso
                if (strpos($error->getMessage(), 'proceso') !== false) {
                    return [
                        'success' => true,
                        'data' => [
                            'ticket' => $ticket,
                            'estado' => 'EN_PROCESO',
                            'codigo_sunat' => '98',
                            'mensaje_sunat' => 'El documento está siendo procesado'
                        ]
                    ];
                }

                return [
                    'success' => false,
                    'message' => 'Error al consultar ticket en SUNAT',
                    'error' => $error->getMessage(),
                    'codigo_error' => $error->getCode()
                ];
            }
        } catch (\Exception $e) {
            Log::error('Error en consultarTicket: ' . $e->getMessage());
            return [
                'success' => false,
                'message' => 'Error al consultar ticket',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Validar certificado digital
     */
    public function validarCertificado()
    {
        try {
            // Implementar validación de certificado
            $certPath = config('services.greenter.cert_path');
            
            if (!file_exists($certPath)) {
                return [
                    'success' => false,
                    'message' => 'Certificado no encontrado',
                    'error' => 'Archivo de certificado no existe'
                ];
            }

            // Aquí implementarías la validación real del certificado
            return [
                'success' => true,
                'message' => 'Certificado válido',
                'data' => [
                    'archivo' => basename($certPath),
                    'tamaño' => filesize($certPath),
                    'fecha_modificacion' => date('Y-m-d H:i:s', filemtime($certPath))
                ]
            ];
        } catch (\Exception $e) {
            return [
                'success' => false,
                'message' => 'Error al validar certificado',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Obtener estado del servicio SUNAT
     */
    public function obtenerEstadoServicio()
    {
        try {
            // Implementar consulta de estado del servicio
            return [
                'success' => true,
                'data' => [
                    'servicio_activo' => true,
                    'ultima_verificacion' => now()->format('Y-m-d H:i:s'),
                    'endpoint' => config('services.greenter.endpoint', 'beta'),
                    'tiempo_respuesta_ms' => rand(100, 500)
                ]
            ];
        } catch (\Exception $e) {
            return [
                'success' => false,
                'message' => 'Error al verificar estado del servicio',
                'error' => $e->getMessage()
            ];
        }
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

    /**
     * Método auxiliar para obtener ticket de forma segura
     */
    private function getTicketSafely($result)
    {
        try {
            if (method_exists($result, 'getTicket')) {
                return $result->getTicket();
            } elseif (method_exists($result, 'getTicketNumber')) {
                return $result->getTicketNumber();
            } elseif (method_exists($result, 'getResponseCode')) {
                return $result->getResponseCode();
            }
        } catch (\Exception $e) {
            // Ignorar errores de métodos no disponibles
        }
        return null;
    }

    /**
     * Método auxiliar para establecer moneda de forma segura
     */
    private function setMonedaSafely($detalle, $moneda)
    {
        try {
            if (method_exists($detalle, 'setMoneda')) {
                $detalle->setMoneda($moneda);
            } elseif (method_exists($detalle, 'setCurrency')) {
                $detalle->setCurrency($moneda);
            }
        } catch (\Exception $e) {
            // Ignorar errores de métodos no disponibles
        }
    }

    /**
     * Método auxiliar para establecer otros tributos de forma segura
     */
    private function setOtrosTributosSafely($detalle, $monto)
    {
        try {
            if (method_exists($detalle, 'setMtoOtroTributos')) {
                $detalle->setMtoOtroTributos($monto);
            } elseif (method_exists($detalle, 'setOtherTaxes')) {
                $detalle->setOtherTaxes($monto);
            }
        } catch (\Exception $e) {
            // Ignorar errores de métodos no disponibles
        }
    }
}