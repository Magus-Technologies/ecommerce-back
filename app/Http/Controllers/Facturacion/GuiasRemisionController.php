<?php

namespace App\Http\Controllers\Facturacion;

use App\Http\Controllers\Controller;
use App\Models\GuiaRemision;
use App\Models\GuiaRemisionDetalle;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;
use App\Services\GuiaRemisionService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class GuiasRemisionController extends Controller
{
    protected $guiaRemisionService;

    public function __construct(GuiaRemisionService $guiaRemisionService)
    {
        $this->guiaRemisionService = $guiaRemisionService;
    }

    /**
     * Listar guías de remisión
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = GuiaRemision::with(['cliente', 'detalles.producto']);

            // Filtros
            if ($request->has('estado')) {
                $query->where('estado', $request->estado);
            }

            if ($request->has('fecha_inicio')) {
                $query->whereDate('fecha_emision', '>=', $request->fecha_inicio);
            }

            if ($request->has('fecha_fin')) {
                $query->whereDate('fecha_emision', '<=', $request->fecha_fin);
            }

            if ($request->has('cliente_id')) {
                $query->where('cliente_id', $request->cliente_id);
            }

            if ($request->has('serie')) {
                $query->where('serie', $request->serie);
            }

            // Ordenamiento
            $query->orderBy('created_at', 'desc');

            // Paginación
            $perPage = $request->get('per_page', 15);
            $guias = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $guias
            ]);

        } catch (\Exception $e) {
            Log::error('Error listando guías de remisión: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al listar guías de remisión',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear nueva guía de remisión
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'cliente_id' => 'required|exists:clientes,id',
                'destinatario_tipo_documento' => 'required|string|max:1',
                'destinatario_numero_documento' => 'required|string|max:20',
                'destinatario_razon_social' => 'required|string|max:200',
                'destinatario_direccion' => 'required|string|max:200',
                'destinatario_ubigeo' => 'required|string|max:6',
                'motivo_traslado' => 'required|string|max:2',
                'modalidad_traslado' => 'required|string|max:2',
                'fecha_inicio_traslado' => 'required|date',
                'punto_partida_ubigeo' => 'required|string|max:6',
                'punto_partida_direccion' => 'required|string|max:200',
                'punto_llegada_ubigeo' => 'required|string|max:6',
                'punto_llegada_direccion' => 'required|string|max:200',
                'productos' => 'required|array|min:1',
                'productos.*.producto_id' => 'required|exists:productos,id',
                'productos.*.cantidad' => 'required|numeric|min:0.01',
                'productos.*.peso_unitario' => 'required|numeric|min:0.01',
                'productos.*.observaciones' => 'nullable|string|max:500'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Datos de validación incorrectos',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            // Obtener cliente
            $cliente = Cliente::findOrFail($request->cliente_id);

            // Obtener serie para guías de remisión
            $serie = SerieComprobante::where('tipo_comprobante', '09')
                                   ->where('activo', true)
                                   ->first();

            if (!$serie) {
                throw new \Exception('No hay series activas para guías de remisión');
            }

            // Generar correlativo
            $correlativo = $serie->siguienteCorrelativo();

            // Crear guía de remisión
            $guia = GuiaRemision::create([
                'tipo_comprobante' => '09',
                'serie' => $serie->serie,
                'correlativo' => $correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'fecha_inicio_traslado' => $request->fecha_inicio_traslado,
                'cliente_id' => $cliente->id,
                'cliente_tipo_documento' => $cliente->tipo_documento,
                'cliente_numero_documento' => $cliente->numero_documento,
                'cliente_razon_social' => $cliente->razon_social,
                'cliente_direccion' => $cliente->direccion,
                'destinatario_tipo_documento' => $request->destinatario_tipo_documento,
                'destinatario_numero_documento' => $request->destinatario_numero_documento,
                'destinatario_razon_social' => $request->destinatario_razon_social,
                'destinatario_direccion' => $request->destinatario_direccion,
                'destinatario_ubigeo' => $request->destinatario_ubigeo,
                'motivo_traslado' => $request->motivo_traslado,
                'modalidad_traslado' => $request->modalidad_traslado,
                'peso_total' => $request->peso_total ?? 0,
                'numero_bultos' => $request->numero_bultos ?? 1,
                'modo_transporte' => $request->modo_transporte ?? '01',
                'numero_placa' => $request->numero_placa,
                'numero_licencia' => $request->numero_licencia,
                'conductor_dni' => $request->conductor_dni,
                'conductor_nombres' => $request->conductor_nombres,
                'punto_partida_ubigeo' => $request->punto_partida_ubigeo,
                'punto_partida_direccion' => $request->punto_partida_direccion,
                'punto_llegada_ubigeo' => $request->punto_llegada_ubigeo,
                'punto_llegada_direccion' => $request->punto_llegada_direccion,
                'observaciones' => $request->observaciones,
                'estado' => 'PENDIENTE',
                'user_id' => auth()->id() ?? 1
            ]);

            // Crear detalles
            $pesoTotal = 0;
            foreach ($request->productos as $index => $productoData) {
                $producto = Producto::findOrFail($productoData['producto_id']);
                $pesoItem = $productoData['cantidad'] * $productoData['peso_unitario'];
                $pesoTotal += $pesoItem;

                GuiaRemisionDetalle::create([
                    'guia_remision_id' => $guia->id,
                    'item' => $index + 1,
                    'producto_id' => $producto->id,
                    'codigo_producto' => $producto->codigo_producto,
                    'descripcion' => $producto->nombre,
                    'unidad_medida' => 'KGM', // Kilogramo por defecto
                    'cantidad' => $productoData['cantidad'],
                    'peso_unitario' => $productoData['peso_unitario'],
                    'peso_total' => $pesoItem,
                    'observaciones' => $productoData['observaciones'] ?? null
                ]);
            }

            // Actualizar peso total
            $guia->update(['peso_total' => $pesoTotal]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Guía de remisión creada exitosamente',
                'data' => $guia->load(['cliente', 'detalles.producto'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error creando guía de remisión: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al crear guía de remisión',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar guía de remisión específica
     */
    public function show($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto', 'usuario'])
                              ->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $guia
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Guía de remisión no encontrada',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Enviar guía de remisión a SUNAT
     */
    public function enviarSunat($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto'])->findOrFail($id);

            if (!$guia->puedeEnviar()) {
                return response()->json([
                    'success' => false,
                    'message' => 'La guía de remisión no puede ser enviada en su estado actual'
                ], 400);
            }

            $resultado = $this->guiaRemisionService->enviarGuiaRemision($guia);

            if ($resultado['success']) {
                return response()->json([
                    'success' => true,
                    'message' => 'Guía de remisión enviada a SUNAT exitosamente',
                    'data' => $guia->fresh()
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al enviar guía de remisión a SUNAT',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            Log::error('Error enviando guía de remisión: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar guía de remisión',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Descargar XML de guía de remisión
     */
    public function descargarXml($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (empty($guia->xml_firmado)) {
                return response()->json([
                    'success' => false,
                    'message' => 'No hay XML disponible para esta guía de remisión'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'xml' => $guia->xml_firmado,
                    'filename' => $guia->numero_completo . '.xml'
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener XML',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener estadísticas de guías de remisión
     */
    public function estadisticas(Request $request): JsonResponse
    {
        try {
            $fechaInicio = $request->get('fecha_inicio', now()->startOfMonth());
            $fechaFin = $request->get('fecha_fin', now()->endOfMonth());

            $estadisticas = [
                'total_guias' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->count(),
                'guias_pendientes' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                 ->where('estado', 'PENDIENTE')->count(),
                'guias_enviadas' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                               ->where('estado', 'ENVIADO')->count(),
                'guias_aceptadas' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                ->where('estado', 'ACEPTADO')->count(),
                'guias_rechazadas' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                 ->where('estado', 'RECHAZADO')->count(),
                'peso_total_transportado' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                        ->where('estado', 'ACEPTADO')
                                                        ->sum('peso_total')
            ];

            return response()->json([
                'success' => true,
                'data' => $estadisticas
            ]);

        } catch (\Exception $e) {
            Log::error('Error obteniendo estadísticas: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
