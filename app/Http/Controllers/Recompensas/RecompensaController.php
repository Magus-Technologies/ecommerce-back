<?php

namespace App\Http\Controllers\Recompensas;

use App\Http\Controllers\Controller;
use App\Models\Recompensa;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class RecompensaController extends Controller
{
    /**
     * Listar todas las recompensas con filtros
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Recompensa::with([
                'creador:id,name'
            ])->withCount([
                'clientes',
                'productos', 
                'puntos',
                'descuentos',
                'envios',
                'regalos'
            ]);

            // Filtros
            if ($request->has('tipo') && !empty($request->tipo)) {
                $query->porTipo($request->tipo);
            }

            if ($request->has('activo') && $request->activo !== '') {
                $query->where('activo', (bool) $request->activo);
            }

            if ($request->has('vigente') && $request->vigente) {
                $query->vigentes();
            }

            if ($request->has('fecha_inicio') && $request->has('fecha_fin')) {
                $query->whereBetween('fecha_inicio', [$request->fecha_inicio, $request->fecha_fin]);
            }

            // Búsqueda por nombre
            if ($request->has('buscar') && !empty($request->buscar)) {
                $query->where('nombre', 'like', '%' . $request->buscar . '%');
            }

            // Ordenamiento
            $orderBy = $request->get('order_by', 'created_at');
            $orderDirection = $request->get('order_direction', 'desc');
            $query->orderBy($orderBy, $orderDirection);

            // Paginación
            $perPage = $request->get('per_page', 15);
            $recompensas = $query->paginate($perPage);

            // Agregar información adicional a cada recompensa
            $recompensas->getCollection()->transform(function ($recompensa) {
                return [
                    'id' => $recompensa->id,
                    'nombre' => $recompensa->nombre,
                    'descripcion' => $recompensa->descripcion,
                    'tipo' => $recompensa->tipo,
                    'tipo_nombre' => $recompensa->tipo_nombre,
                    'fecha_inicio' => $recompensa->fecha_inicio,
                    'fecha_fin' => $recompensa->fecha_fin,
                    'activo' => $recompensa->activo,
                    'es_vigente' => $recompensa->es_vigente,
                    'total_aplicaciones' => $recompensa->total_aplicaciones,
                    'creador' => $recompensa->creador,
                    'created_at' => $recompensa->created_at,
                    'updated_at' => $recompensa->updated_at,
                    // Contadores de configuraciones (optimizado con withCount)
                    'tiene_clientes' => $recompensa->clientes_count > 0,
                    'tiene_productos' => $recompensa->productos_count > 0,
                    'tiene_configuracion' => (
                        $recompensa->puntos_count > 0 ||
                        $recompensa->descuentos_count > 0 ||
                        $recompensa->envios_count > 0 ||
                        $recompensa->regalos_count > 0
                    )
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Recompensas obtenidas exitosamente',
                'data' => $recompensas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener las recompensas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear una nueva recompensa
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'nombre' => 'required|string|max:255',
                'descripcion' => 'nullable|string',
                'tipo' => 'required|in:' . implode(',', Recompensa::getTipos()),
                'fecha_inicio' => 'required|date|after_or_equal:today',
                'fecha_fin' => 'required|date|after:fecha_inicio',
                'activo' => 'boolean'
            ], [
                'nombre.required' => 'El nombre es obligatorio',
                'tipo.required' => 'El tipo de recompensa es obligatorio',
                'tipo.in' => 'El tipo de recompensa no es válido',
                'fecha_inicio.required' => 'La fecha de inicio es obligatoria',
                'fecha_inicio.after_or_equal' => 'La fecha de inicio debe ser hoy o posterior',
                'fecha_fin.required' => 'La fecha de fin es obligatoria',
                'fecha_fin.after' => 'La fecha de fin debe ser posterior a la fecha de inicio'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            $recompensa = Recompensa::create([
                'nombre' => $request->nombre,
                'descripcion' => $request->descripcion,
                'tipo' => $request->tipo,
                'fecha_inicio' => $request->fecha_inicio,
                'fecha_fin' => $request->fecha_fin,
                'activo' => $request->get('activo', true),
                'creado_por' => Auth::id()
            ]);

            DB::commit();

            // Cargar relaciones para la respuesta
            $recompensa->load('creador:id,name');

            return response()->json([
                'success' => true,
                'message' => 'Recompensa creada exitosamente',
                'data' => $recompensa
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al crear la recompensa',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar detalle de una recompensa específica
     */
    public function show($id): JsonResponse
    {
        try {
            $recompensa = Recompensa::with([
                'creador:id,name',
                'clientes.cliente:id,nombres,apellidos,email',
                'productos.producto:id,nombre,codigo_producto',
                'productos.categoria:id,nombre',
                'puntos',
                'descuentos',
                'envios',
                'regalos.producto:id,nombre,codigo_producto,precio_venta,stock',
                'historial' => function($query) {
                    $query->with('cliente:id,nombres,apellidos')
                          ->orderBy('fecha_aplicacion', 'desc')
                          ->limit(10);
                }
            ])->find($id);

            if (!$recompensa) {
                return response()->json([
                    'success' => false,
                    'message' => 'Recompensa no encontrada'
                ], 404);
            }

            // Preparar datos detallados
            $data = [
                'recompensa' => [
                    'id' => $recompensa->id,
                    'nombre' => $recompensa->nombre,
                    'descripcion' => $recompensa->descripcion,
                    'tipo' => $recompensa->tipo,
                    'tipo_nombre' => $recompensa->tipo_nombre,
                    'fecha_inicio' => $recompensa->fecha_inicio,
                    'fecha_fin' => $recompensa->fecha_fin,
                    'activo' => $recompensa->activo,
                    'es_vigente' => $recompensa->es_vigente,
                    'total_aplicaciones' => $recompensa->total_aplicaciones,
                    'creador' => $recompensa->creador,
                    'created_at' => $recompensa->created_at,
                    'updated_at' => $recompensa->updated_at
                ],
                'configuracion' => [
                    'clientes' => $recompensa->clientes->map(function($cliente) {
                        return [
                            'id' => $cliente->id,
                            'segmento' => $cliente->segmento,
                            'segmento_nombre' => $cliente->segmento_nombre,
                            'cliente' => $cliente->cliente,
                            'es_cliente_especifico' => $cliente->es_cliente_especifico
                        ];
                    }),
                    'productos' => $recompensa->productos->map(function($producto) {
                        return [
                            'id' => $producto->id,
                            'tipo_elemento' => $producto->tipo_elemento,
                            'nombre_elemento' => $producto->nombre_elemento,
                            'producto' => $producto->producto,
                            'categoria' => $producto->categoria
                        ];
                    }),
                    'puntos' => $recompensa->puntos->map(function($punto) {
                        return $punto->getResumenConfiguracion();
                    }),
                    'descuentos' => $recompensa->descuentos->map(function($descuento) {
                        return $descuento->getResumenConfiguracion();
                    }),
                    'envios' => $recompensa->envios->map(function($envio) {
                        return $envio->getResumenConfiguracion();
                    }),
                    'regalos' => $recompensa->regalos->map(function($regalo) {
                        return $regalo->getResumenConfiguracion();
                    })
                ],
                'historial_reciente' => $recompensa->historial->map(function($historial) {
                    return [
                        'id' => $historial->id,
                        'cliente' => $historial->nombre_cliente,
                        'puntos_otorgados' => $historial->puntos_otorgados,
                        'beneficio_aplicado' => $historial->beneficio_aplicado,
                        'fecha_aplicacion' => $historial->fecha_aplicacion,
                        'tiempo_transcurrido' => $historial->tiempo_transcurrido
                    ];
                })
            ];

            return response()->json([
                'success' => true,
                'message' => 'Detalle de recompensa obtenido exitosamente',
                'data' => $data
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener el detalle de la recompensa',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Actualizar una recompensa existente
     */
    public function update(Request $request, $id): JsonResponse
    {
        try {
            $recompensa = Recompensa::find($id);

            if (!$recompensa) {
                return response()->json([
                    'success' => false,
                    'message' => 'Recompensa no encontrada'
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'nombre' => 'sometimes|required|string|max:255',
                'descripcion' => 'nullable|string',
                'tipo' => 'sometimes|required|in:' . implode(',', Recompensa::getTipos()),
                'fecha_inicio' => 'sometimes|required|date',
                'fecha_fin' => 'sometimes|required|date|after:fecha_inicio',
                'activo' => 'boolean'
            ], [
                'nombre.required' => 'El nombre es obligatorio',
                'tipo.required' => 'El tipo de recompensa es obligatorio',
                'tipo.in' => 'El tipo de recompensa no es válido',
                'fecha_inicio.required' => 'La fecha de inicio es obligatoria',
                'fecha_fin.required' => 'La fecha de fin es obligatoria',
                'fecha_fin.after' => 'La fecha de fin debe ser posterior a la fecha de inicio'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            $recompensa->update($request->only([
                'nombre',
                'descripcion',
                'tipo',
                'fecha_inicio',
                'fecha_fin',
                'activo'
            ]));

            DB::commit();

            // Cargar relaciones para la respuesta
            $recompensa->load('creador:id,name');

            return response()->json([
                'success' => true,
                'message' => 'Recompensa actualizada exitosamente',
                'data' => $recompensa
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar la recompensa',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Desactivar una recompensa (soft delete)
     */
    public function destroy($id): JsonResponse
    {
        try {
            $recompensa = Recompensa::find($id);

            if (!$recompensa) {
                return response()->json([
                    'success' => false,
                    'message' => 'Recompensa no encontrada'
                ], 404);
            }

            DB::beginTransaction();

            // Desactivar en lugar de eliminar
            $recompensa->update(['activo' => false]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Recompensa desactivada exitosamente'
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al desactivar la recompensa',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Activar una recompensa
     */
    public function activate($id): JsonResponse
    {
        try {
            $recompensa = Recompensa::find($id);

            if (!$recompensa) {
                return response()->json([
                    'success' => false,
                    'message' => 'Recompensa no encontrada'
                ], 404);
            }

            DB::beginTransaction();

            $recompensa->update(['activo' => true]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Recompensa activada exitosamente',
                'data' => $recompensa
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al activar la recompensa',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener estadísticas de recompensas
     */
    public function estadisticas(): JsonResponse
    {
        try {
            // Obtener fechas para comparación
            $mesActual = now()->format('Y-m');
            $mesAnterior = now()->subMonth()->format('Y-m');
            $inicioMesActual = now()->startOfMonth();
            $finMesActual = now()->endOfMonth();
            $inicioMesAnterior = now()->subMonth()->startOfMonth();
            $finMesAnterior = now()->subMonth()->endOfMonth();

            // Estadísticas básicas con una sola consulta optimizada
            $estadisticasBasicas = Recompensa::selectRaw('
                COUNT(*) as total_recompensas,
                SUM(CASE WHEN activo = 1 THEN 1 ELSE 0 END) as recompensas_activas,
                SUM(CASE WHEN activo = 1 AND fecha_inicio <= CURDATE() AND fecha_fin >= CURDATE() THEN 1 ELSE 0 END) as recompensas_vigentes
            ')->first();

            // Estadísticas por tipo
            $porTipo = Recompensa::selectRaw('tipo, COUNT(*) as total, SUM(CASE WHEN activo = 1 THEN 1 ELSE 0 END) as activas')
                ->groupBy('tipo')
                ->get()
                ->keyBy('tipo')
                ->map(function($item) {
                    return [
                        'total' => $item->total,
                        'activas' => $item->activas
                    ];
                });

            // Estadísticas de historial optimizadas (mes actual vs anterior)
            $historialStats = DB::table('recompensas_historial')
                ->selectRaw('
                    DATE_FORMAT(fecha_aplicacion, "%Y-%m") as mes,
                    COUNT(*) as aplicaciones,
                    COALESCE(SUM(puntos_otorgados), 0) as puntos_otorgados,
                    COUNT(DISTINCT cliente_id) as clientes_beneficiados
                ')
                ->whereBetween('fecha_aplicacion', [$inicioMesAnterior, $finMesActual])
                ->groupBy('mes')
                ->get()
                ->keyBy('mes');

            $mesActualData = $historialStats->get($mesActual, (object)[
                'aplicaciones' => 0,
                'puntos_otorgados' => 0,
                'clientes_beneficiados' => 0
            ]);

            $mesAnteriorData = $historialStats->get($mesAnterior, (object)[
                'aplicaciones' => 0,
                'puntos_otorgados' => 0,
                'clientes_beneficiados' => 0
            ]);

            // Cálculo de tendencias
            $tendencias = [
                'aplicaciones' => $this->calcularTendencia($mesAnteriorData->aplicaciones, $mesActualData->aplicaciones),
                'puntos' => $this->calcularTendencia($mesAnteriorData->puntos_otorgados, $mesActualData->puntos_otorgados),
                'clientes' => $this->calcularTendencia($mesAnteriorData->clientes_beneficiados, $mesActualData->clientes_beneficiados)
            ];

            // Top 5 recompensas más utilizadas este mes
            $topRecompensas = DB::table('recompensas_historial as rh')
                ->join('recompensas as r', 'rh.recompensa_id', '=', 'r.id')
                ->selectRaw('
                    r.id,
                    r.nombre,
                    r.tipo,
                    COUNT(*) as total_aplicaciones,
                    COUNT(DISTINCT rh.cliente_id) as clientes_unicos
                ')
                ->whereBetween('rh.fecha_aplicacion', [$inicioMesActual, $finMesActual])
                ->groupBy('r.id', 'r.nombre', 'r.tipo')
                ->orderByDesc('total_aplicaciones')
                ->limit(5)
                ->get();

            $estadisticas = [
                'resumen' => [
                    'total_recompensas' => (int) $estadisticasBasicas->total_recompensas,
                    'recompensas_activas' => (int) $estadisticasBasicas->recompensas_activas,
                    'recompensas_vigentes' => (int) $estadisticasBasicas->recompensas_vigentes,
                    'tasa_activacion' => $estadisticasBasicas->total_recompensas > 0 
                        ? round(($estadisticasBasicas->recompensas_activas / $estadisticasBasicas->total_recompensas) * 100, 2)
                        : 0
                ],
                'por_tipo' => $porTipo,
                'mes_actual' => [
                    'aplicaciones' => (int) $mesActualData->aplicaciones,
                    'puntos_otorgados' => (int) $mesActualData->puntos_otorgados,
                    'clientes_beneficiados' => (int) $mesActualData->clientes_beneficiados,
                    'promedio_puntos_por_aplicacion' => $mesActualData->aplicaciones > 0 
                        ? round($mesActualData->puntos_otorgados / $mesActualData->aplicaciones, 2)
                        : 0
                ],
                'comparativa_mes_anterior' => [
                    'aplicaciones' => [
                        'actual' => (int) $mesActualData->aplicaciones,
                        'anterior' => (int) $mesAnteriorData->aplicaciones,
                        'tendencia' => $tendencias['aplicaciones']
                    ],
                    'puntos_otorgados' => [
                        'actual' => (int) $mesActualData->puntos_otorgados,
                        'anterior' => (int) $mesAnteriorData->puntos_otorgados,
                        'tendencia' => $tendencias['puntos']
                    ],
                    'clientes_beneficiados' => [
                        'actual' => (int) $mesActualData->clientes_beneficiados,
                        'anterior' => (int) $mesAnteriorData->clientes_beneficiados,
                        'tendencia' => $tendencias['clientes']
                    ]
                ],
                'top_recompensas_mes' => $topRecompensas,
                'metadata' => [
                    'generado_en' => now()->toISOString(),
                    'periodo_analisis' => [
                        'mes_actual' => $mesActual,
                        'mes_anterior' => $mesAnterior
                    ],
                    'cache_valido_hasta' => now()->addHours(2)->toISOString()
                ]
            ];

            return response()->json([
                'success' => true,
                'message' => 'Estadísticas obtenidas exitosamente',
                'data' => $estadisticas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener las estadísticas',
                'error' => $e->getMessage(),
                'trace' => config('app.debug') ? $e->getTraceAsString() : null
            ], 500);
        }
    }

    /**
     * Calcular tendencia entre dos valores
     */
    private function calcularTendencia($valorAnterior, $valorActual): array
    {
        if ($valorAnterior == 0 && $valorActual == 0) {
            return [
                'porcentaje' => 0,
                'direccion' => 'estable',
                'diferencia' => 0
            ];
        }

        if ($valorAnterior == 0) {
            return [
                'porcentaje' => 100,
                'direccion' => 'subida',
                'diferencia' => $valorActual
            ];
        }

        $porcentaje = (($valorActual - $valorAnterior) / $valorAnterior) * 100;
        $direccion = $porcentaje > 0 ? 'subida' : ($porcentaje < 0 ? 'bajada' : 'estable');

        return [
            'porcentaje' => round(abs($porcentaje), 2),
            'direccion' => $direccion,
            'diferencia' => $valorActual - $valorAnterior
        ];
    }

    /**
     * Obtener tipos de recompensas disponibles
     */
    public function tipos(): JsonResponse
    {
        try {
            $tipos = collect(Recompensa::getTipos())->map(function($tipo) {
                $nombres = [
                    'puntos' => 'Sistema de Puntos',
                    'descuento' => 'Descuentos',
                    'envio_gratis' => 'Envío Gratuito',
                    'regalo' => 'Productos de Regalo',
                    'nivel_cliente' => 'Nivel de Cliente'
                ];

                return [
                    'value' => $tipo,
                    'label' => $nombres[$tipo] ?? ucfirst($tipo)
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Tipos de recompensas obtenidos exitosamente',
                'data' => $tipos
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener los tipos de recompensas',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}