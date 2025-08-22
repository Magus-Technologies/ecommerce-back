<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use App\Models\EmpresaInfo;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Storage;
use Barryvdh\DomPDF\Facade\Pdf;

class CotizacionController extends Controller
{
    /**
     * Generar cotización como PDF
     */
    public function generarPDF(Request $request): Response
    {
        try {
            $request->validate([
                'cliente' => 'required|string|max:255',
                'email' => 'required|email',
                'direccion' => 'required|string',
                'telefono' => 'required|string',
                'departamento' => 'required|string',
                'provincia' => 'required|string',
                'distrito' => 'required|string',
                'forma_envio' => 'required|string',
                'tipo_pago' => 'required|string',
                'observaciones' => 'nullable|string',
                'productos' => 'required|array',
                'total' => 'required|numeric'
            ]);
            $empresa = EmpresaInfo::first();
            if (!$empresa) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Información de empresa no encontrada'
                ], 404);
            }

            $logoBase64 = null;
            if ($empresa->logo && file_exists(public_path('storage/' . $empresa->logo))) {
                $logoPath = public_path('storage/' . $empresa->logo);
                $logoData = base64_encode(file_get_contents($logoPath));
                $logoMime = mime_content_type($logoPath);
                $logoBase64 = 'data:' . $logoMime . ';base64,' . $logoData;
            }

            // Preparar datos para la vista
            $datos = [
                'empresa' => $empresa,
                'logo_base64' => $logoBase64,
                'cliente' => $request->cliente,
                'email' => $request->email,
                'direccion' => $request->direccion,
                'telefono' => $request->telefono,
                'departamento' => $request->departamento,
                'provincia' => $request->provincia,
                'distrito' => $request->distrito,
                'forma_envio' => $request->forma_envio,
                'tipo_pago' => $request->tipo_pago,
                'observaciones' => $request->observaciones,
                'productos' => $request->productos,
                'total' => $request->total,
                'fecha' => now()->format('d/m/Y H:i:s'),
                'numero_cotizacion' => 'COT-' . date('Ymd') . '-' . str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT)
            ];

            // Generar PDF
            $pdf = PDF::loadView('pdf.cotizacion', $datos);
            $pdf->setPaper('a4', 'portrait');
            
            // Configurar opciones para mejor calidad
            $pdf->setOptions([
                'isHtml5ParserEnabled' => true,
                'isRemoteEnabled' => true,
                'defaultFont' => 'Arial'
            ]);

            // Devolver PDF como respuesta
            return response($pdf->output(), 200, [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => 'attachment; filename="cotizacion.pdf"'
            ]);

        } catch (\Exception $e) {
            \Log::error('Error generando PDF de cotización: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Error al generar la cotización: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar cotización por email
     */
    public function enviarEmail(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'cliente' => 'required|string|max:255',
                'email' => 'required|email',
                'direccion' => 'required|string',
                'telefono' => 'required|string',
                'departamento' => 'required|string',
                'provincia' => 'required|string',
                'distrito' => 'required|string',
                'forma_envio' => 'required|string',
                'tipo_pago' => 'required|string',
                'observaciones' => 'nullable|string',
                'productos' => 'required|array',
                'total' => 'required|numeric'
            ]);

            // Obtener información de la empresa
            $empresa = EmpresaInfo::first();
            
            if (!$empresa) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Información de empresa no encontrada'
                ], 404);
            }

            // Preparar datos para la vista
            $datos = [
                'empresa' => $empresa,
                'cliente' => $request->cliente,
                'email' => $request->email,
                'direccion' => $request->direccion,
                'telefono' => $request->telefono,
                'departamento' => $request->departamento,
                'provincia' => $request->provincia,
                'distrito' => $request->distrito,
                'forma_envio' => $request->forma_envio,
                'tipo_pago' => $request->tipo_pago,
                'observaciones' => $request->observaciones,
                'productos' => $request->productos,
                'total' => $request->total,
                'fecha' => now()->format('d/m/Y H:i:s'),
                'numero_cotizacion' => 'COT-' . date('Ymd') . '-' . str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT)
            ];

            // Generar PDF
            $pdf = PDF::loadView('pdf.cotizacion', $datos);
            $pdf->setPaper('a4', 'portrait');

            // Enviar email con PDF adjunto
            Mail::send('emails.cotizacion', $datos, function ($message) use ($request, $pdf, $datos) {
                $message->to($request->email, $request->cliente)
                        ->subject('Cotización - ' . $datos['numero_cotizacion'])
                        ->attachData($pdf->output(), 'cotizacion.pdf', [
                            'mime' => 'application/pdf',
                        ]);
            });

            return response()->json([
                'status' => 'success',
                'message' => 'Cotización enviada exitosamente al correo: ' . $request->email
            ]);

        } catch (\Exception $e) {
            \Log::error('Error enviando cotización por email: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Error al enviar la cotización: ' . $e->getMessage()
            ], 500);
        }
    }
}
