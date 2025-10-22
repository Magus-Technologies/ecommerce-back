<?php

namespace App\Http\Controllers\Facturacion;

use App\Http\Controllers\Controller;
use App\Models\Comprobante;
use App\Services\GreenterService;
use App\Services\WhatsAppService;
use App\Mail\ComprobanteEmail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Log;

class ComprobantesController extends Controller
{
    protected $greenterService;

    public function __construct(GreenterService $greenterService)
    {
        $this->greenterService = $greenterService;
    }

    public function index(Request $request)
    {
        try {
            $query = Comprobante::with(['cliente', 'user']);

            // Filtros
            if ($request->has('tipo_comprobante')) {
                $query->where('tipo_comprobante', $request->tipo_comprobante);
            }

            if ($request->has('estado')) {
                $query->where('estado', $request->estado);
            }

            if ($request->has('cliente_id')) {
                $query->where('cliente_id', $request->cliente_id);
            }

            if ($request->has('fecha_inicio') && $request->has('fecha_fin')) {
                $query->whereBetween('fecha_emision', [$request->fecha_inicio, $request->fecha_fin]);
            }

            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('numero_completo', 'LIKE', "%{$search}%")
                      ->orWhere('cliente_razon_social', 'LIKE', "%{$search}%")
                      ->orWhere('cliente_numero_documento', 'LIKE', "%{$search}%");
                });
            }

            $comprobantes = $query->orderBy('created_at', 'desc')->paginate(20);

            return response()->json($comprobantes);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener comprobantes',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $comprobante = Comprobante::with([
                'cliente', 
                'detalles.producto', 
                'user',
                'comprobanteReferencia',
                'notasRelacionadas'
            ])->findOrFail($id);

            return response()->json($comprobante);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Comprobante no encontrado',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function reenviar($id)
    {
        try {
            $resultado = $this->greenterService->reenviarComprobante($id);

            if ($resultado['success']) {
                return response()->json([
                    'message' => $resultado['mensaje'],
                    'comprobante' => $resultado['comprobante']
                ]);
            } else {
                return response()->json([
                    'message' => 'Error al reenviar comprobante',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al reenviar comprobante',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function consultar($id)
    {
        try {
            $comprobante = Comprobante::findOrFail($id);
            $resultado = $this->greenterService->consultarComprobante($comprobante);

            if ($resultado['success']) {
                return response()->json([
                    'message' => 'Estado consultado exitosamente',
                    'estado' => $resultado['estado'],
                    'comprobante' => $comprobante->fresh()
                ]);
            } else {
                return response()->json([
                    'message' => 'Error al consultar estado',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al consultar comprobante',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function descargarPdf($id)
    {
        try {
            $comprobante = Comprobante::findOrFail($id);

            if (!$comprobante->pdf_base64) {
                return response()->json([
                    'message' => 'PDF no disponible para este comprobante'
                ], 404);
            }

            $pdf = base64_decode($comprobante->pdf_base64);
            $filename = "comprobante_{$comprobante->numero_completo}.pdf";

            return Response::make($pdf, 200, [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => "attachment; filename=\"{$filename}\""
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al descargar PDF',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function descargarXml($id)
    {
        try {
            $comprobante = Comprobante::findOrFail($id);

            if (!$comprobante->xml_firmado) {
                return response()->json([
                    'message' => 'XML no disponible para este comprobante'
                ], 404);
            }

            $filename = "comprobante_{$comprobante->numero_completo}.xml";

            return Response::make($comprobante->xml_firmado, 200, [
                'Content-Type' => 'application/xml',
                'Content-Disposition' => "attachment; filename=\"{$filename}\""
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al descargar XML',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function estadisticas(Request $request)
    {
        try {
            $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->format('Y-m-d');
            $fechaFin = $request->fecha_fin ?? now()->format('Y-m-d');

            $totalComprobantes = Comprobante::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->count();
            $montoTotal = Comprobante::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->sum('importe_total');
            
            $estadisticasPorEstado = Comprobante::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                ->selectRaw('estado, COUNT(*) as cantidad, SUM(importe_total) as monto')
                ->groupBy('estado')
                ->get();

            $estadisticasPorTipo = Comprobante::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                ->selectRaw('tipo_comprobante, COUNT(*) as cantidad, SUM(importe_total) as monto')
                ->groupBy('tipo_comprobante')
                ->get();

            return response()->json([
                'success' => true,
                'data' => [
                    'total_comprobantes' => $totalComprobantes,
                    'monto_total' => $montoTotal,
                    'por_estado' => $estadisticasPorEstado,
                    'por_tipo' => $estadisticasPorTipo,
                    'periodo' => ['inicio' => $fechaInicio, 'fin' => $fechaFin]
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Descargar CDR (Constancia de Recepción)
     */
    public function descargarCdr($id)
    {
        try {
            $comprobante = Comprobante::findOrFail($id);

            if (!$comprobante->xml_respuesta_sunat) {
                return response()->json([
                    'success' => false,
                    'message' => 'CDR no disponible para este comprobante'
                ], 404);
            }

            $filename = "cdr_{$comprobante->numero_completo}.xml";

            return Response::make($comprobante->xml_respuesta_sunat, 200, [
                'Content-Type' => 'application/xml',
                'Content-Disposition' => "attachment; filename=\"{$filename}\""
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al descargar CDR',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar comprobante por email
     */
    public function enviarEmail(Request $request, $id)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'mensaje' => 'nullable|string|max:500'
            ]);

            $comprobante = Comprobante::with('cliente')->findOrFail($id);

            if (!$comprobante->pdf_base64) {
                return response()->json([
                    'success' => false,
                    'message' => 'PDF no disponible para este comprobante'
                ], 404);
            }

            // Enviar email con el comprobante adjunto
            Mail::to($request->email)->send(new ComprobanteEmail($comprobante, $request->mensaje));

            Log::info('Comprobante enviado por email', [
                'comprobante_id' => $comprobante->id,
                'numero' => $comprobante->serie . '-' . $comprobante->correlativo,
                'destinatario' => $request->email
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Comprobante enviado por email exitosamente',
                'data' => [
                    'email' => $request->email,
                    'comprobante' => $comprobante->serie . '-' . str_pad($comprobante->correlativo, 8, '0', STR_PAD_LEFT)
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Error al enviar email de comprobante', [
                'comprobante_id' => $id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error al enviar email',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar comprobante por WhatsApp
     */
    public function enviarWhatsApp(Request $request, $id)
    {
        try {
            $request->validate([
                'telefono' => 'required|string|min:9|max:15',
                'mensaje' => 'nullable|string|max:500'
            ]);

            $comprobante = Comprobante::with('cliente')->findOrFail($id);

            if (!$comprobante->pdf_base64) {
                return response()->json([
                    'success' => false,
                    'message' => 'PDF no disponible para este comprobante'
                ], 404);
            }

            // Verificar si WhatsApp está habilitado
            if (!WhatsAppService::estaHabilitado()) {
                return response()->json([
                    'success' => false,
                    'message' => 'El servicio de WhatsApp no está habilitado'
                ], 503);
            }

            // Enviar comprobante por WhatsApp
            $whatsappService = new WhatsAppService();
            $whatsappService->enviarComprobante($comprobante, $request->telefono);

            Log::info('Comprobante enviado por WhatsApp', [
                'comprobante_id' => $comprobante->id,
                'numero' => $comprobante->serie . '-' . $comprobante->correlativo,
                'telefono' => $request->telefono
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Comprobante enviado por WhatsApp exitosamente',
                'data' => [
                    'telefono' => $request->telefono,
                    'comprobante' => $comprobante->serie . '-' . str_pad($comprobante->correlativo, 8, '0', STR_PAD_LEFT)
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Error al enviar WhatsApp de comprobante', [
                'comprobante_id' => $id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error al enviar WhatsApp',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Anular comprobante
     */
    public function anular(Request $request, $id)
    {
        try {
            $request->validate([
                'motivo' => 'required|string|max:255'
            ]);

            $comprobante = Comprobante::findOrFail($id);

            if ($comprobante->estado === 'ANULADO') {
                return response()->json([
                    'success' => false,
                    'message' => 'El comprobante ya está anulado'
                ], 400);
            }

            if ($comprobante->estado === 'ACEPTADO') {
                return response()->json([
                    'success' => false,
                    'message' => 'No se puede anular un comprobante aceptado por SUNAT'
                ], 400);
            }

            $comprobante->update([
                'estado' => 'ANULADO',
                'observaciones' => $request->motivo
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Comprobante anulado exitosamente',
                'data' => $comprobante
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al anular comprobante',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}