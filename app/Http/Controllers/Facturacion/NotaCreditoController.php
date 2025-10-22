<?php

namespace App\Http\Controllers\Facturacion;

use App\Http\Controllers\Controller;
use App\Models\Comprobante;
use App\Models\NotaCredito;
use App\Models\SerieComprobante;
use App\Services\GreenterService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class NotaCreditoController extends Controller
{
    protected $greenterService;

    public function __construct(GreenterService $greenterService)
    {
        $this->greenterService = $greenterService;
    }

    /**
     * Listar notas de crédito
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = NotaCredito::with(['comprobanteReferencia', 'comprobante']);

            // Filtros
            if ($request->filled('estado')) {
                $query->where('estado', $request->estado);
            }

            if ($request->filled('fecha_inicio') && $request->filled('fecha_fin')) {
                $query->whereBetween('fecha_emision', [$request->fecha_inicio, $request->fecha_fin]);
            }

            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('numero_completo', 'LIKE', "%{$search}%")
                      ->orWhere('motivo', 'LIKE', "%{$search}%");
                });
            }

            $notas = $query->orderBy('created_at', 'desc')->paginate(20);

            return response()->json([
                'success' => true,
                'data' => $notas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener notas de crédito',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear nota de crédito
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'comprobante_referencia_id' => 'required|exists:comprobantes,id',
                'motivo' => 'required|string|max:255',
                'descripcion' => 'nullable|string|max:500',
                'items' => 'required|array|min:1',
                'items.*.producto_id' => 'required|exists:productos,id',
                'items.*.cantidad' => 'required|numeric|min:0.01',
                'items.*.precio_unitario' => 'required|numeric|min:0',
                'items.*.descuento' => 'nullable|numeric|min:0',
                'items.*.tipo_afectacion_igv' => 'required|string|max:2'
            ]);

            DB::beginTransaction();

            // Obtener comprobante de referencia
            $comprobanteReferencia = Comprobante::findOrFail($request->comprobante_referencia_id);

            // Obtener serie para nota de crédito
            $serie = SerieComprobante::where('tipo_comprobante', '07')
                ->where('activo', true)
                ->first();

            if (!$serie) {
                throw new \Exception('No hay serie disponible para notas de crédito');
            }

            // Calcular totales
            $subtotal = 0;
            $totalIgv = 0;
            $total = 0;

            foreach ($request->items as $item) {
                $precioUnitario = $item['precio_unitario'];
                $cantidad = $item['cantidad'];
                $descuento = $item['descuento'] ?? 0;
                
                $subtotalItem = ($precioUnitario * $cantidad) - $descuento;
                $igvItem = $item['tipo_afectacion_igv'] === '10' ? $subtotalItem * 0.18 : 0;
                
                $subtotal += $subtotalItem;
                $totalIgv += $igvItem;
            }

            $total = $subtotal + $totalIgv;

            // Crear nota de crédito
            $notaCredito = NotaCredito::create([
                'comprobante_referencia_id' => $comprobanteReferencia->id,
                'tipo_nota_credito' => '07',
                'motivo' => $request->motivo,
                'descripcion' => $request->descripcion,
                'serie' => $serie->serie,
                'numero' => $serie->correlativo,
                'numero_completo' => $serie->tipo_comprobante . '-' . str_pad($serie->correlativo, 8, '0', STR_PAD_LEFT),
                'fecha_emision' => now()->format('Y-m-d'),
                'hora_emision' => now()->format('H:i:s'),
                'subtotal' => $subtotal,
                'total_igv' => $totalIgv,
                'total' => $total,
                'moneda' => 'PEN',
                'estado' => 'PENDIENTE',
                'user_id' => auth()->user()->id
            ]);

            // Crear comprobante asociado
            $comprobante = Comprobante::create([
                'tipo_comprobante' => '07',
                'serie' => $serie->serie,
                'correlativo' => $serie->correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'cliente_id' => $comprobanteReferencia->cliente_id,
                'cliente_tipo_documento' => $comprobanteReferencia->cliente_tipo_documento,
                'cliente_numero_documento' => $comprobanteReferencia->cliente_numero_documento,
                'cliente_razon_social' => $comprobanteReferencia->cliente_razon_social,
                'cliente_direccion' => $comprobanteReferencia->cliente_direccion,
                'moneda' => 'PEN',
                'operacion_gravada' => $subtotal,
                'total_igv' => $totalIgv,
                'importe_total' => $total,
                'comprobante_referencia_id' => $comprobanteReferencia->id,
                'tipo_nota' => '07',
                'motivo_nota' => $request->motivo,
                'estado' => 'PENDIENTE',
                'user_id' => auth()->user()->id
            ]);

            // Actualizar correlativo de la serie
            $serie->increment('correlativo');

            // Crear detalles de la nota de crédito
            foreach ($request->items as $item) {
                $comprobante->detalles()->create([
                    'producto_id' => $item['producto_id'],
                    'cantidad' => $item['cantidad'],
                    'precio_unitario' => $item['precio_unitario'],
                    'descuento' => $item['descuento'] ?? 0,
                    'tipo_afectacion_igv' => $item['tipo_afectacion_igv'],
                    'subtotal' => ($item['precio_unitario'] * $item['cantidad']) - ($item['descuento'] ?? 0),
                    'igv' => $item['tipo_afectacion_igv'] === '10' ? (($item['precio_unitario'] * $item['cantidad']) - ($item['descuento'] ?? 0)) * 0.18 : 0,
                    'total' => (($item['precio_unitario'] * $item['cantidad']) - ($item['descuento'] ?? 0)) + ($item['tipo_afectacion_igv'] === '10' ? (($item['precio_unitario'] * $item['cantidad']) - ($item['descuento'] ?? 0)) * 0.18 : 0)
                ]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'data' => $notaCredito->load('comprobanteReferencia'),
                'message' => 'Nota de crédito creada exitosamente'
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al crear nota de crédito',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar nota de crédito
     */
    public function show($id): JsonResponse
    {
        try {
            $notaCredito = NotaCredito::with([
                'comprobanteReferencia',
                'comprobante.detalles.producto'
            ])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $notaCredito
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Nota de crédito no encontrada',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Enviar nota de crédito a SUNAT
     */
    public function enviarSunat($id): JsonResponse
    {
        try {
            $notaCredito = NotaCredito::with('comprobante')->findOrFail($id);

            if ($notaCredito->estado !== 'PENDIENTE') {
                return response()->json([
                    'success' => false,
                    'message' => 'Solo se pueden enviar notas de crédito pendientes'
                ], 400);
            }

            // Usar el GreenterService para enviar
            $resultado = $this->greenterService->enviarComprobante($notaCredito->comprobante);

            if ($resultado['success']) {
                $notaCredito->update(['estado' => 'ENVIADO']);
                
                return response()->json([
                    'success' => true,
                    'message' => 'Nota de crédito enviada a SUNAT exitosamente',
                    'data' => $notaCredito->fresh()
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al enviar nota de crédito a SUNAT',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar nota de crédito',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener estadísticas de notas de crédito
     */
    public function estadisticas(Request $request): JsonResponse
    {
        try {
            $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->format('Y-m-d');
            $fechaFin = $request->fecha_fin ?? now()->format('Y-m-d');

            $totalNotas = NotaCredito::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->count();
            $montoTotal = NotaCredito::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->sum('total');
            
            $estadisticasPorEstado = NotaCredito::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                ->selectRaw('estado, COUNT(*) as cantidad, SUM(total) as monto')
                ->groupBy('estado')
                ->get();

            return response()->json([
                'success' => true,
                'data' => [
                    'total_notas' => $totalNotas,
                    'monto_total' => $montoTotal,
                    'por_estado' => $estadisticasPorEstado,
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
}
