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
use Luecano\NumeroALetras\NumeroALetras;
use Carbon\Carbon;

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
    $this->see->setService(SunatEndpoints::FE_BETA); // Para producción usar SunatEndpoints::FE_PRODUCCION
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

    public function generarFactura($ventaId, $clienteData = null)
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

            // Procesar respuesta
            $this->procesarRespuestaSunat($comprobante, $result, $invoice);

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
            'user_id' => auth()->id() ?? 1,
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

    private function construirDocumentoGreenter($comprobante, $cliente)
    {
        $invoice = new Invoice();
        
        // Datos básicos
        $invoice->setUblVersion('2.1')
                ->setTipoOperacion('0101')
                ->setTipoDoc($comprobante->tipo_comprobante)
                ->setSerie($comprobante->serie)
                ->setCorrelativo($comprobante->correlativo)
                ->setFechaEmision(Carbon::parse($comprobante->fecha_emision))
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

        // Detalles
        $items = [];
        foreach ($comprobante->detalles as $detalle) {
            $item = new SaleDetail();
            $item->setCodProducto($detalle->codigo_producto)
                 ->setUnidad($detalle->unidad_medida)
                 ->setDescripcion($detalle->descripcion)
                 ->setCantidad($detalle->cantidad)
                 ->setMtoValorUnitario($detalle->valor_unitario)
                 ->setMtoValorVenta($detalle->valor_venta)
                 ->setMtoBaseIgv($detalle->valor_venta)
                 ->setPorcentajeIgv($detalle->porcentaje_igv)
                 ->setIgv($detalle->igv)
                 ->setTipAfeIgv($detalle->tipo_afectacion_igv)
                 ->setTotalImpuestos($detalle->igv)
                 ->setMtoPrecioUnitario($detalle->precio_unitario);

            $items[] = $item;
        }

        $invoice->setDetails($items);

        // Totales
        $invoice->setMtoOperGravadas($comprobante->operacion_gravada)
                ->setMtoIGV($comprobante->total_igv)
                ->setTotalImpuestos($comprobante->total_igv)
                ->setMtoImpVenta($comprobante->importe_total);

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
            \Log::error('Error generando PDF: ' . $e->getMessage());
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
}