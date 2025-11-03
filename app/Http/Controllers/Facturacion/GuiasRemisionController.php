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
     * Obtener tipos de guía disponibles
     */
    public function tipos(): JsonResponse
    {
        try {
            $tipos = GuiaRemision::tiposGuia();

            return response()->json([
                'success' => true,
                'data' => $tipos
            ]);
        } catch (\Exception $e) {
            Log::error('Error obteniendo tipos de guía: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener tipos de guía',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Listar guías de remisión
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = GuiaRemision::with(['cliente', 'detalles.producto']);

            // Filtros
            if ($request->has('tipo_guia')) {
                $query->where('tipo_guia', $request->tipo_guia);
            }

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
     * Crear guía de remisión - GRE Remitente
     */
    public function storeRemitente(Request $request): JsonResponse
    {
        return $this->storeGuia($request, 'REMITENTE');
    }

    /**
     * Crear guía de remisión - Traslado Interno
     */
    public function storeInterno(Request $request): JsonResponse
    {
        return $this->storeGuia($request, 'INTERNO');
    }

    /**
     * Crear nueva guía de remisión (método genérico)
     */
    public function store(Request $request): JsonResponse
    {
        $tipoGuia = $request->input('tipo_guia', 'REMITENTE');
        return $this->storeGuia($request, $tipoGuia);
    }

    /**
     * Método privado para crear guía según tipo
     */
    private function storeGuia(Request $request, string $tipoGuia): JsonResponse
    {
        try {
            // Validaciones base - Comunes para todos los tipos
            $rules = [
                'cliente_id' => 'nullable|exists:clientes,id',
                'usar_cliente_como_destinatario' => 'nullable|boolean',
                'motivo_traslado' => 'required|string|max:2',
                'fecha_inicio_traslado' => 'required|date',
                'punto_partida_ubigeo' => 'required|string|size:6|regex:/^[0-9]{6}$/',
                'punto_partida_direccion' => 'required|string|max:200',
                'punto_llegada_ubigeo' => 'required|string|size:6|regex:/^[0-9]{6}$/',
                'punto_llegada_direccion' => 'required|string|max:200',
                'productos' => 'required|array|min:1',
                'productos.*.producto_id' => 'required|exists:productos,id',
                'productos.*.cantidad' => 'required|numeric|min:0.01',
                'productos.*.peso_unitario' => 'required|numeric|min:0.01',
                'productos.*.observaciones' => 'nullable|string|max:500',
                'numero_bultos' => 'nullable|integer|min:1',
                'observaciones' => 'nullable|string|max:500',
            ];

            // Validaciones específicas por tipo de guía
            if ($tipoGuia === 'REMITENTE') {
                // GRE Remitente - Requiere destinatario y modalidad
                $rules['modalidad_traslado'] = 'required|string|max:2';

                // Si usa el cliente como destinatario
                if ($request->input('usar_cliente_como_destinatario')) {
                    $rules['cliente_id'] = 'required|exists:clientes,id';
                } else {
                    // Si no usa el cliente como destinatario, cliente_id es opcional
                    $rules['cliente_id'] = 'nullable|exists:clientes,id';
                    // Pero los datos del destinatario son obligatorios
                    $rules['destinatario_tipo_documento'] = 'required|string|max:1';
                    $rules['destinatario_numero_documento'] = 'required|string|max:20';
                    $rules['destinatario_razon_social'] = 'required|string|max:200';
                    $rules['destinatario_direccion'] = 'required|string|max:200';
                    $rules['destinatario_ubigeo'] = 'required|string|size:6|regex:/^[0-9]{6}$/';
                }

                // Si es transporte privado, requiere datos del vehículo y conductor
                if ($request->modalidad_traslado === '02') {
                    $rules['modo_transporte'] = 'nullable|string|max:2';
                    $rules['numero_placa'] = 'required|string|max:20';
                    $rules['conductor_dni'] = 'required|string|max:8';
                    $rules['conductor_nombres'] = 'required|string|max:200';
                }

            } elseif ($tipoGuia === 'INTERNO') {
                // Traslado Interno - Campos mínimos (no requiere SUNAT)
                // Solo requiere puntos de origen/destino y productos
                $rules['destinatario_tipo_documento'] = 'nullable|string|max:1';
                $rules['destinatario_numero_documento'] = 'nullable|string|max:20';
                $rules['destinatario_razon_social'] = 'nullable|string|max:200';
                $rules['destinatario_direccion'] = 'nullable|string|max:200';
                $rules['destinatario_ubigeo'] = 'nullable|string|size:6|regex:/^[0-9]{6}$/';
            }

            // Validaciones de negocio adicionales
            if ($tipoGuia === 'REMITENTE' && $request->input('usar_cliente_como_destinatario')) {
                if (!$request->cliente_id) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Debes seleccionar un cliente cuando usas "El cliente es el destinatario"',
                        'errors' => ['cliente_id' => ['El cliente es requerido']]
                    ], 422);
                }
                
                $cliente = Cliente::find($request->cliente_id);
                if ($cliente && $cliente->tipo_documento !== '6') {
                    return response()->json([
                        'success' => false,
                        'message' => 'El cliente debe tener RUC para ser usado como destinatario',
                        'errors' => ['cliente_id' => ['El cliente debe tener RUC (no DNI) para ser el destinatario']]
                    ], 422);
                }
            }

            $validator = Validator::make($request->all(), $rules);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Datos de validación incorrectos',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            // Obtener cliente (si aplica)
            $cliente = null;
            if ($request->cliente_id) {
                $cliente = Cliente::findOrFail($request->cliente_id);
            }

            // Determinar tipo de comprobante según tipo de guía
            // Para ecommerce solo usamos tipo '09' (GRE Remitente e Interno)
            $tipoComprobante = '09';

            // Obtener serie para guías de remisión
            $serie = SerieComprobante::where('tipo_comprobante', $tipoComprobante)
                                   ->where('activo', true)
                                   ->first();

            if (!$serie) {
                throw new \Exception("No hay series activas para guías de remisión tipo {$tipoComprobante}");
            }

            // Generar correlativo
            $correlativo = $serie->siguienteCorrelativo();

            // Determinar si requiere SUNAT
            $requiereSunat = $tipoGuia !== 'INTERNO';

            // Usar cliente como destinatario si se especifica
            $destinatarioData = [];
            if ($request->input('usar_cliente_como_destinatario') && $cliente) {
                $destinatarioData = [
                    'destinatario_tipo_documento' => $cliente->tipo_documento,
                    'destinatario_numero_documento' => $cliente->numero_documento,
                    'destinatario_razon_social' => $cliente->razon_social,
                    'destinatario_direccion' => $cliente->direccion,
                    'destinatario_ubigeo' => $cliente->ubigeo, // Asumiendo que el cliente tiene ubigeo
                ];
            } else {
                $destinatarioData = [
                    'destinatario_tipo_documento' => $request->destinatario_tipo_documento,
                    'destinatario_numero_documento' => $request->destinatario_numero_documento,
                    'destinatario_razon_social' => $request->destinatario_razon_social,
                    'destinatario_direccion' => $request->destinatario_direccion,
                    'destinatario_ubigeo' => $request->destinatario_ubigeo,
                ];
            }


            // Crear guía de remisión
            $guiaData = [
                'tipo_comprobante' => $tipoComprobante,
                'tipo_guia' => $tipoGuia,
                'requiere_sunat' => $requiereSunat,
                'serie' => $serie->serie,
                'correlativo' => $correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'fecha_inicio_traslado' => $request->fecha_inicio_traslado,
                'cliente_id' => $cliente ? $cliente->id : null,
                'cliente_tipo_documento' => $cliente ? $cliente->tipo_documento : null,
                'cliente_numero_documento' => $cliente ? $cliente->numero_documento : null,
                'cliente_razon_social' => $cliente ? $cliente->razon_social : null,
                'cliente_direccion' => $cliente ? $cliente->direccion : null,
                'motivo_traslado' => $request->motivo_traslado,
                'modalidad_traslado' => $request->modalidad_traslado ?? '02', // Por defecto privado
                'peso_total' => $request->peso_total ?? 0,
                'numero_bultos' => $request->numero_bultos ?? 1,
                'modo_transporte' => $request->modo_transporte ?? '01', // Por defecto terrestre
                'numero_placa' => $request->numero_placa,
                'conductor_dni' => $request->conductor_dni,
                'conductor_nombres' => $request->conductor_nombres,
                'punto_partida_ubigeo' => $request->punto_partida_ubigeo,
                'punto_partida_direccion' => $request->punto_partida_direccion,
                'punto_llegada_ubigeo' => $request->punto_llegada_ubigeo,
                'punto_llegada_direccion' => $request->punto_llegada_direccion,
                'observaciones' => $request->observaciones,
                'estado' => 'PENDIENTE',
                'user_id' => auth()->id() ?? 1
            ];

            $guiaData = array_merge($guiaData, $destinatarioData);

            $guia = GuiaRemision::create($guiaData);

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
                    'unidad_medida' => 'KGM',
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
                'message' => "Guía de remisión {$tipoGuia} creada exitosamente",
                'data' => $guia->load(['cliente', 'detalles.producto'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Error creando guía de remisión {$tipoGuia}: " . $e->getMessage());
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

            // Validar si requiere envío a SUNAT
            if (!$guia->requiere_sunat) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta guía de remisión no requiere envío a SUNAT (Traslado Interno)'
                ], 400);
            }

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
                                                        ->sum('peso_total'),
                // Estadísticas por tipo
                'por_tipo' => [
                    'remitente' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                              ->where('tipo_guia', 'REMITENTE')->count(),
                    'interno' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                            ->where('tipo_guia', 'INTERNO')->count()
                ]
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
