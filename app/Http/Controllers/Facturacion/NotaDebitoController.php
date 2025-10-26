<?php

namespace App\Http\Controllers\Facturacion;

use App\Http\Controllers\Controller;
use App\Models\Comprobante;
use App\Models\NotaDebito;
use App\Models\SerieComprobante;
use App\Services\GreenterService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class NotaDebitoController extends Controller
{
    protected $greenterService;

    public function __construct(GreenterService $greenterService)
    {
        $this->greenterService = $greenterService;
    }

    /**
     * Listar notas de débito
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = NotaDebito::with(['comprobanteReferencia', 'comprobante']);

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
                'message' => 'Error al obtener notas de débito',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear nota de débito
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'comprobante_referencia_id' => 'required|exists:comprobantes,id',
                'motivo' => 'required|string|max:255',
                'descripcion' => 'nullable|string|max:500',
                'items' => 'required|array|min:1',
                'items.*.concepto' => 'required|string|max:255',
                'items.*.cantidad' => 'required|numeric|min:0.01',
                'items.*.precio_unitario' => 'required|numeric|min:0',
                'items.*.tipo_afectacion_igv' => 'required|string|max:2'
            ]);

            DB::beginTransaction();

            // Obtener comprobante de referencia
            $comprobanteReferencia = Comprobante::findOrFail($request->comprobante_referencia_id);

            // Obtener serie para nota de débito
            $serie = SerieComprobante::where('tipo_comprobante', '08')
                ->where('activo', true)
                ->first();

            if (!$serie) {
                throw new \Exception('No hay serie disponible para notas de débito');
            }

            // Calcular totales
            $subtotal = 0;
            $totalIgv = 0;
            $total = 0;

            foreach ($request->items as $item) {
                $precioUnitario = $item['precio_unitario'];
                $cantidad = $item['cantidad'];
                
                $subtotalItem = $precioUnitario * $cantidad;
                $igvItem = $item['tipo_afectacion_igv'] === '10' ? $subtotalItem * 0.18 : 0;
                
                $subtotal += $subtotalItem;
                $totalIgv += $igvItem;
            }

            $total = $subtotal + $totalIgv;

            // Crear nota de débito
            $notaDebito = NotaDebito::create([
                'comprobante_referencia_id' => $comprobanteReferencia->id,
                'tipo_nota_debito' => '08',
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
                'tipo_comprobante' => '08',
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
                'tipo_nota' => '08',
                'motivo_nota' => $request->motivo,
                'estado' => 'PENDIENTE',
                'user_id' => auth()->user()->id
            ]);

            // Actualizar correlativo de la serie
            $serie->increment('correlativo');

            // Crear detalles de la nota de débito
            foreach ($request->items as $item) {
                $comprobante->detalles()->create([
                    'producto_id' => null, // Las notas de débito pueden no tener producto específico
                    'descripcion' => $item['concepto'],
                    'cantidad' => $item['cantidad'],
                    'precio_unitario' => $item['precio_unitario'],
                    'tipo_afectacion_igv' => $item['tipo_afectacion_igv'],
                    'subtotal' => $item['precio_unitario'] * $item['cantidad'],
                    'igv' => $item['tipo_afectacion_igv'] === '10' ? ($item['precio_unitario'] * $item['cantidad']) * 0.18 : 0,
                    'total' => ($item['precio_unitario'] * $item['cantidad']) + ($item['tipo_afectacion_igv'] === '10' ? ($item['precio_unitario'] * $item['cantidad']) * 0.18 : 0)
                ]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'data' => $notaDebito->load('comprobanteReferencia'),
                'message' => 'Nota de débito creada exitosamente'
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al crear nota de débito',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar nota de débito
     */
    public function show($id): JsonResponse
    {
        try {
            $notaDebito = NotaDebito::with([
                'comprobanteReferencia',
                'comprobante.detalles'
            ])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $notaDebito
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Nota de débito no encontrada',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Enviar nota de débito a SUNAT
     */
    public function enviarSunat($id): JsonResponse
    {
        try {
            $notaDebito = NotaDebito::with('comprobante')->findOrFail($id);

            if ($notaDebito->estado !== 'PENDIENTE') {
                return response()->json([
                    'success' => false,
                    'message' => 'Solo se pueden enviar notas de débito pendientes'
                ], 400);
            }

            // Usar el GreenterService para enviar
            $resultado = $this->greenterService->enviarComprobante($notaDebito->comprobante);

            if ($resultado['success']) {
                $notaDebito->update(['estado' => 'ENVIADO']);
                
                return response()->json([
                    'success' => true,
                    'message' => 'Nota de débito enviada a SUNAT exitosamente',
                    'data' => $notaDebito->fresh()
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al enviar nota de débito a SUNAT',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar nota de débito',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener estadísticas de notas de débito
     */
    public function estadisticas(Request $request): JsonResponse
    {
        try {
            $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->format('Y-m-d');
            $fechaFin = $request->fecha_fin ?? now()->format('Y-m-d');

            $totalNotas = NotaDebito::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->count();
            $montoTotal = NotaDebito::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->sum('total');
            
            $estadisticasPorEstado = NotaDebito::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
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
