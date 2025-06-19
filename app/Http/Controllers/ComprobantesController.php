<?php

namespace App\Http\Controllers;

use App\Models\Comprobante;
use App\Services\GreenterService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;

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
                'total_comprobantes' => $totalComprobantes,
                'monto_total' => $montoTotal,
                'por_estado' => $estadisticasPorEstado,
                'por_tipo' => $estadisticasPorTipo,
                'periodo' => ['inicio' => $fechaInicio, 'fin' => $fechaFin]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}