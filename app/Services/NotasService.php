<?php

namespace App\Services;

use App\Models\NotaCredito;
use App\Models\NotaDebito;
use App\Models\Comprobante;
use Greenter\Model\Sale\Note;
use Greenter\Model\Sale\SaleDetail;
use Greenter\Model\Client\Client;
use Greenter\Model\Company\Address;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class NotasService
{
    protected $greenterService;

    public function __construct(GreenterService $greenterService)
    {
        $this->greenterService = $greenterService;
    }

    /**
     * Enviar Nota de Crédito a SUNAT
     */
    public function enviarNotaCreditoASunat($notaCreditoId)
    {
        try {
            $notaCredito = NotaCredito::with(['cliente', 'venta'])->findOrFail($notaCreditoId);

            // Validar estados permitidos para envío
            $estadosPermitidos = ['pendiente', 'generado', 'rechazado'];
            if (!in_array($notaCredito->estado, $estadosPermitidos)) {
                throw new \Exception("No se puede enviar la nota en estado '{$notaCredito->estado}'. Estados permitidos: pendiente, generado, rechazado");
            }

            // Obtener comprobante de referencia
            $comprobanteRef = Comprobante::where('serie', $notaCredito->serie_comprobante_ref)
                ->where('correlativo', $notaCredito->numero_comprobante_ref)
                ->first();

            if (!$comprobanteRef) {
                throw new \Exception('No se encontró el comprobante de referencia');
            }

            // Construir documento Greenter
            $note = $this->construirNotaCredito($notaCredito, $comprobanteRef);

            // Obtener instancia de See desde GreenterService
            $see = $this->greenterService->getSee();

            // Enviar a SUNAT
            $result = $see->send($note);

            // Guardar XML firmado
            $xmlFirmado = $see->getFactory()->getLastXml();
            
            if ($result->isSuccess()) {
                $cdr = $result->getCdrResponse();
                $cdrZip = $result->getCdrZip();

                $notaCredito->update([
                    'estado' => 'aceptado',
                    'xml' => $xmlFirmado,
                    'cdr' => $cdrZip ? base64_encode($cdrZip) : null,
                    'hash' => hash('sha256', $xmlFirmado),
                    'mensaje_sunat' => $cdr ? $cdr->getDescription() : 'Aceptado',
                    'fecha_envio_sunat' => now(),
                ]);

                // Generar PDF
                $this->generarPdfNotaCredito($notaCredito);

                Log::info('Nota de crédito enviada exitosamente', [
                    'nota_credito_id' => $notaCredito->id,
                    'numero' => $notaCredito->serie . '-' . $notaCredito->numero
                ]);

                return [
                    'success' => true,
                    'message' => 'Nota de crédito enviada a SUNAT exitosamente',
                    'data' => $notaCredito->fresh()
                ];
            } else {
                $error = $result->getError();
                
                $notaCredito->update([
                    'estado' => 'rechazado',
                    'xml' => $xmlFirmado,
                    'mensaje_sunat' => $error->getMessage(),
                    'codigo_error_sunat' => $error->getCode(),
                ]);

                Log::error('Nota de crédito rechazada por SUNAT', [
                    'nota_credito_id' => $notaCredito->id,
                    'error' => $error->getMessage(),
                    'codigo' => $error->getCode()
                ]);

                return [
                    'success' => false,
                    'message' => 'Nota de crédito rechazada por SUNAT',
                    'error' => $error->getMessage(),
                    'codigo_error' => $error->getCode()
                ];
            }

        } catch (\Exception $e) {
            Log::error('Error enviando nota de crédito a SUNAT', [
                'nota_credito_id' => $notaCreditoId,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return [
                'success' => false,
                'message' => 'Error al enviar nota de crédito',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Enviar Nota de Débito a SUNAT
     */
    public function enviarNotaDebitoASunat($notaDebitoId)
    {
        try {
            $notaDebito = NotaDebito::with(['cliente', 'venta'])->findOrFail($notaDebitoId);

            // Validar estados permitidos para envío
            $estadosPermitidos = ['pendiente', 'generado', 'rechazado'];
            if (!in_array($notaDebito->estado, $estadosPermitidos)) {
                throw new \Exception("No se puede enviar la nota en estado '{$notaDebito->estado}'. Estados permitidos: pendiente, generado, rechazado");
            }

            // Obtener comprobante de referencia
            $comprobanteRef = Comprobante::where('serie', $notaDebito->serie_comprobante_ref)
                ->where('correlativo', $notaDebito->numero_comprobante_ref)
                ->first();

            if (!$comprobanteRef) {
                throw new \Exception('No se encontró el comprobante de referencia');
            }

            // Construir documento Greenter
            $note = $this->construirNotaDebito($notaDebito, $comprobanteRef);

            // Obtener instancia de See desde GreenterService
            $see = $this->greenterService->getSee();

            // Enviar a SUNAT
            $result = $see->send($note);

            // Guardar XML firmado
            $xmlFirmado = $see->getFactory()->getLastXml();
            
            if ($result->isSuccess()) {
                $cdr = $result->getCdrResponse();
                $cdrZip = $result->getCdrZip();

                $notaDebito->update([
                    'estado' => 'aceptado',
                    'xml' => $xmlFirmado,
                    'cdr' => $cdrZip ? base64_encode($cdrZip) : null,
                    'hash' => hash('sha256', $xmlFirmado),
                    'mensaje_sunat' => $cdr ? $cdr->getDescription() : 'Aceptado',
                    'fecha_envio_sunat' => now(),
                ]);

                // Generar PDF
                $this->generarPdfNotaDebito($notaDebito);

                Log::info('Nota de débito enviada exitosamente', [
                    'nota_debito_id' => $notaDebito->id,
                    'numero' => $notaDebito->serie . '-' . $notaDebito->numero
                ]);

                return [
                    'success' => true,
                    'message' => 'Nota de débito enviada a SUNAT exitosamente',
                    'data' => $notaDebito->fresh()
                ];
            } else {
                $error = $result->getError();
                
                $notaDebito->update([
                    'estado' => 'rechazado',
                    'xml' => $xmlFirmado,
                    'mensaje_sunat' => $error->getMessage(),
                    'codigo_error_sunat' => $error->getCode(),
                ]);

                Log::error('Nota de débito rechazada por SUNAT', [
                    'nota_debito_id' => $notaDebito->id,
                    'error' => $error->getMessage(),
                    'codigo' => $error->getCode()
                ]);

                return [
                    'success' => false,
                    'message' => 'Nota de débito rechazada por SUNAT',
                    'error' => $error->getMessage(),
                    'codigo_error' => $error->getCode()
                ];
            }

        } catch (\Exception $e) {
            Log::error('Error enviando nota de débito a SUNAT', [
                'nota_debito_id' => $notaDebitoId,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return [
                'success' => false,
                'message' => 'Error al enviar nota de débito',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Construir Nota de Crédito para Greenter
     */
    private function construirNotaCredito(NotaCredito $notaCredito, Comprobante $comprobanteRef)
    {
        $note = new Note();

        // Datos básicos
        $note->setUblVersion('2.1')
            ->setTipoDoc('07') // Nota de Crédito
            ->setSerie($notaCredito->serie)
            ->setCorrelativo($notaCredito->numero)
            ->setFechaEmision(Carbon::parse($notaCredito->fecha_emision))
            ->setTipDocAfectado($comprobanteRef->tipo_comprobante)
            ->setNumDocfectado($comprobanteRef->serie . '-' . $comprobanteRef->correlativo)
            ->setCodMotivo($notaCredito->tipo_nota_credito ?? '01')
            ->setDesMotivo($notaCredito->motivo)
            ->setTipoMoneda($notaCredito->moneda ?? 'PEN');

        // Empresa
        $company = $this->greenterService->getCompany();
        $note->setCompany($company);

        // Cliente
        $client = new Client();
        $client->setTipoDoc($notaCredito->cliente->tipo_documento)
            ->setNumDoc($notaCredito->cliente->numero_documento)
            ->setRznSocial($notaCredito->cliente->razon_social);

        if ($notaCredito->cliente->direccion) {
            $client->setAddress(new Address(['direccion' => $notaCredito->cliente->direccion]));
        }

        $note->setClient($client);

        // Detalles - Crear un detalle genérico basado en los totales
        $item = new SaleDetail();
        $valorUnitario = $notaCredito->subtotal;
        $igv = $notaCredito->igv;
        $precioUnitario = $notaCredito->total;

        $item->setCodProducto('NOTA001')
            ->setUnidad('NIU')
            ->setDescripcion($notaCredito->motivo)
            ->setCantidad(1)
            ->setMtoValorUnitario($valorUnitario)
            ->setMtoValorVenta($valorUnitario)
            ->setMtoBaseIgv($valorUnitario)
            ->setPorcentajeIgv(18.00)
            ->setIgv($igv)
            ->setTipAfeIgv('10') // Gravado
            ->setTotalImpuestos($igv)
            ->setMtoPrecioUnitario($precioUnitario);

        $note->setDetails([$item]);

        // Totales
        $note->setMtoOperGravadas($notaCredito->subtotal)
            ->setMtoOperExoneradas(0.00)
            ->setMtoOperInafectas(0.00)
            ->setMtoIGV($notaCredito->igv)
            ->setTotalImpuestos($notaCredito->igv)
            ->setMtoImpVenta($notaCredito->total);

        return $note;
    }

    /**
     * Construir Nota de Débito para Greenter
     */
    private function construirNotaDebito(NotaDebito $notaDebito, Comprobante $comprobanteRef)
    {
        $note = new Note();

        // Datos básicos
        $note->setUblVersion('2.1')
            ->setTipoDoc('08') // Nota de Débito
            ->setSerie($notaDebito->serie)
            ->setCorrelativo($notaDebito->numero)
            ->setFechaEmision(Carbon::parse($notaDebito->fecha_emision))
            ->setTipDocAfectado($comprobanteRef->tipo_comprobante)
            ->setNumDocfectado($comprobanteRef->serie . '-' . $comprobanteRef->correlativo)
            ->setCodMotivo($notaDebito->tipo_nota_debito ?? '01')
            ->setDesMotivo($notaDebito->motivo)
            ->setTipoMoneda($notaDebito->moneda ?? 'PEN');

        // Empresa
        $company = $this->greenterService->getCompany();
        $note->setCompany($company);

        // Cliente
        $client = new Client();
        $client->setTipoDoc($notaDebito->cliente->tipo_documento)
            ->setNumDoc($notaDebito->cliente->numero_documento)
            ->setRznSocial($notaDebito->cliente->razon_social);

        if ($notaDebito->cliente->direccion) {
            $client->setAddress(new Address(['direccion' => $notaDebito->cliente->direccion]));
        }

        $note->setClient($client);

        // Detalles - Crear un detalle genérico basado en los totales
        $item = new SaleDetail();
        $valorUnitario = $notaDebito->subtotal;
        $igv = $notaDebito->igv;
        $precioUnitario = $notaDebito->total;

        $item->setCodProducto('NOTA001')
            ->setUnidad('NIU')
            ->setDescripcion($notaDebito->motivo)
            ->setCantidad(1)
            ->setMtoValorUnitario($valorUnitario)
            ->setMtoValorVenta($valorUnitario)
            ->setMtoBaseIgv($valorUnitario)
            ->setPorcentajeIgv(18.00)
            ->setIgv($igv)
            ->setTipAfeIgv('10') // Gravado
            ->setTotalImpuestos($igv)
            ->setMtoPrecioUnitario($precioUnitario);

        $note->setDetails([$item]);

        // Totales
        $note->setMtoOperGravadas($notaDebito->subtotal)
            ->setMtoOperExoneradas(0.00)
            ->setMtoOperInafectas(0.00)
            ->setMtoIGV($notaDebito->igv)
            ->setTotalImpuestos($notaDebito->igv)
            ->setMtoImpVenta($notaDebito->total);

        return $note;
    }

    /**
     * Generar PDF para Nota de Crédito
     */
    private function generarPdfNotaCredito(NotaCredito $notaCredito)
    {
        try {
            $html = view('pdf.nota-credito', [
                'nota' => $notaCredito,
                'cliente' => $notaCredito->cliente,
                'empresa' => [
                    'ruc' => config('services.company.ruc'),
                    'razon_social' => config('services.company.name'),
                    'direccion' => config('services.company.address'),
                ]
            ])->render();

            // Usar DomPDF si está disponible
            if (class_exists('\Dompdf\Dompdf')) {
                $dompdf = new \Dompdf\Dompdf();
                $dompdf->loadHtml($html);
                $dompdf->setPaper('A4', 'portrait');
                $dompdf->render();
                $pdfContent = $dompdf->output();
            } else {
                // Fallback: guardar HTML como PDF
                $pdfContent = $html;
            }

            $notaCredito->update([
                'pdf' => base64_encode($pdfContent)
            ]);

            Log::info('PDF de nota de crédito generado', [
                'nota_credito_id' => $notaCredito->id
            ]);

        } catch (\Exception $e) {
            Log::error('Error generando PDF de nota de crédito', [
                'nota_credito_id' => $notaCredito->id,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Generar PDF para Nota de Débito
     */
    private function generarPdfNotaDebito(NotaDebito $notaDebito)
    {
        try {
            $html = view('pdf.nota-debito', [
                'nota' => $notaDebito,
                'cliente' => $notaDebito->cliente,
                'empresa' => [
                    'ruc' => config('services.company.ruc'),
                    'razon_social' => config('services.company.name'),
                    'direccion' => config('services.company.address'),
                ]
            ])->render();

            // Usar DomPDF si está disponible
            if (class_exists('\Dompdf\Dompdf')) {
                $dompdf = new \Dompdf\Dompdf();
                $dompdf->loadHtml($html);
                $dompdf->setPaper('A4', 'portrait');
                $dompdf->render();
                $pdfContent = $dompdf->output();
            } else {
                // Fallback: guardar HTML como PDF
                $pdfContent = $html;
            }

            $notaDebito->update([
                'pdf' => base64_encode($pdfContent)
            ]);

            Log::info('PDF de nota de débito generado', [
                'nota_debito_id' => $notaDebito->id
            ]);

        } catch (\Exception $e) {
            Log::error('Error generando PDF de nota de débito', [
                'nota_debito_id' => $notaDebito->id,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Generar XML de Nota de Crédito (sin enviar a SUNAT)
     */
    public function generarXmlNotaCredito($notaCreditoId)
    {
        try {
            $notaCredito = NotaCredito::with(['cliente', 'venta'])->findOrFail($notaCreditoId);

            if ($notaCredito->estado !== 'pendiente') {
                throw new \Exception('Solo se puede generar XML para notas pendientes');
            }

            // Obtener comprobante de referencia
            $comprobanteRef = Comprobante::where('serie', $notaCredito->serie_comprobante_ref)
                ->where('correlativo', $notaCredito->numero_comprobante_ref)
                ->first();

            if (!$comprobanteRef) {
                throw new \Exception('No se encontró el comprobante de referencia');
            }

            // Construir documento Greenter
            $note = $this->construirNotaCredito($notaCredito, $comprobanteRef);

            // Obtener instancia de See desde GreenterService
            $see = $this->greenterService->getSee();

            // Generar XML firmado (sin enviar)
            $xmlFirmado = $see->getXmlSigned($note);

            // Guardar XML
            $notaCredito->update([
                'estado' => 'generado',
                'xml' => $xmlFirmado,
                'hash' => hash('sha256', $xmlFirmado),
            ]);

            // Generar PDF
            $this->generarPdfNotaCredito($notaCredito);

            Log::info('XML de nota de crédito generado', [
                'nota_credito_id' => $notaCredito->id,
                'numero' => $notaCredito->serie . '-' . $notaCredito->numero
            ]);

            return [
                'success' => true,
                'message' => 'XML generado exitosamente',
                'data' => $notaCredito->fresh()
            ];

        } catch (\Exception $e) {
            Log::error('Error generando XML de nota de crédito', [
                'nota_credito_id' => $notaCreditoId,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return [
                'success' => false,
                'message' => 'Error al generar XML',
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Generar XML de Nota de Débito (sin enviar a SUNAT)
     */
    public function generarXmlNotaDebito($notaDebitoId)
    {
        try {
            $notaDebito = NotaDebito::with(['cliente', 'venta'])->findOrFail($notaDebitoId);

            if ($notaDebito->estado !== 'pendiente') {
                throw new \Exception('Solo se puede generar XML para notas pendientes');
            }

            // Obtener comprobante de referencia
            $comprobanteRef = Comprobante::where('serie', $notaDebito->serie_comprobante_ref)
                ->where('correlativo', $notaDebito->numero_comprobante_ref)
                ->first();

            if (!$comprobanteRef) {
                throw new \Exception('No se encontró el comprobante de referencia');
            }

            // Construir documento Greenter
            $note = $this->construirNotaDebito($notaDebito, $comprobanteRef);

            // Obtener instancia de See desde GreenterService
            $see = $this->greenterService->getSee();

            // Generar XML firmado (sin enviar)
            $xmlFirmado = $see->getXmlSigned($note);

            // Guardar XML
            $notaDebito->update([
                'estado' => 'generado',
                'xml' => $xmlFirmado,
                'hash' => hash('sha256', $xmlFirmado),
            ]);

            // Generar PDF
            $this->generarPdfNotaDebito($notaDebito);

            Log::info('XML de nota de débito generado', [
                'nota_debito_id' => $notaDebito->id,
                'numero' => $notaDebito->serie . '-' . $notaDebito->numero
            ]);

            return [
                'success' => true,
                'message' => 'XML generado exitosamente',
                'data' => $notaDebito->fresh()
            ];

        } catch (\Exception $e) {
            Log::error('Error generando XML de nota de débito', [
                'nota_debito_id' => $notaDebitoId,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return [
                'success' => false,
                'message' => 'Error al generar XML',
                'error' => $e->getMessage()
            ];
        }
    }
}
