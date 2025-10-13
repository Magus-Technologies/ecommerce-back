<?php

namespace App\Http\Controllers\Recompensas;

use App\Http\Controllers\Controller;
use App\Models\Recompensa;
use App\Models\RecompensaNotificacionCliente;
use App\Models\RecompensaPopup;
use App\Models\UserCliente;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class RecompensaNotificacionController extends Controller
{
    /**
     * Obtener popups activos para visitantes (no autenticados)
     */
    public function popupsActivosPublico(Request $request): JsonResponse
    {
        try {
            // Este endpoint es SOLO para visitantes no autenticados
            $user = $request->user();
            if ($user) {
                // CORREGIDO: Cualquier usuario autenticado (cliente, motorizado, admin) 
                // NO debe usar este endpoint público
                return response()->json([
                    'success' => false,
                    'message' => 'Este endpoint es solo para visitantes no autenticados. Usuarios autenticados deben usar el endpoint de clientes.'
                ], 403);
            }

            // Buscar popups activos cuyas recompensas estén vigentes
            $popupsQuery = \App\Models\RecompensaPopup::query()
                ->activos()
                ->deRecompensasActivas();

            // CORREGIDO: Solo pop-ups para 'no_registrados' en endpoint público
            $popupsQuery->whereHas('recompensa.clientes', function($q) {
                $q->where('segmento', 'no_registrados');
            });

            $popups = $popupsQuery->with(['recompensa:id,nombre,tipo,fecha_inicio,fecha_fin,estado'])
                ->orderBy('created_at', 'desc')
                ->get();

            $popupsActivos = $popups->map(function($popup) {
                $configuracion = $popup->getConfiguracionFrontend();
                if ($popup->imagen_popup) {
                    $configuracion['imagen_popup_url'] = asset('storage/popups/' . $popup->imagen_popup);
                }
                // En público no generamos notificación; solo devolvemos configuración
                return $configuracion;
            })->values()->all();

            return response()->json([
                'success' => true,
                'message' => 'Popups públicos obtenidos exitosamente',
                'data' => [
                    'popups_activos' => array_values($popupsActivos),
                    'total_popups' => count($popupsActivos)
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener los popups públicos',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    /**
     * Obtener popups activos para clientes (con filtro por segmento del cliente)
     */
    public function popupsActivos(Request $request): JsonResponse
    {
        try {
            // Intentar obtener usuario de sesión Sanctum
            $user = $request->user();

            // Si no hay usuario en request, verificar sesiones activas
            if (!$user) {
                if (auth()->guard('web')->check()) {
                    $user = auth()->guard('web')->user();
                } elseif (auth()->guard('cliente')->check()) {
                    $user = auth()->guard('cliente')->user();
                }
            }

            // Log para debugging
            Log::info('🔍 popupsActivos - Usuario detectado', [
                'user_id' => $user ? $user->id : null,
                'user_email' => $user ? $user->email : null,
                'user_class' => $user ? get_class($user) : null,
                'guard_web' => auth()->guard('web')->check(),
                'guard_cliente' => auth()->guard('cliente')->check(),
            ]);

            // Si hay usuario autenticado, verificar su tipo
            if ($user) {
                // Verificar que NO sea un usuario motorizado
                $userMotorizado = \App\Models\UserMotorizado::find($user->id);
                if ($userMotorizado) {
                    Log::info('❌ popupsActivos - Bloqueado: Motorizado', ['user_id' => $user->id]);
                    return response()->json([
                        'success' => true,
                        'message' => 'No hay popups disponibles',
                        'data' => [
                            'popups_activos' => [],
                            'total_popups' => 0,
                            'razon' => 'Los motorizados no tienen acceso a recompensas de clientes'
                        ]
                    ]);
                }

                // Verificar que NO sea de la tabla users (admin)
                $cliente = \App\Models\UserCliente::find($user->id);
                if (!$cliente) {
                    // Es un admin de la tabla users, NO mostrar pop-ups
                    Log::info('❌ popupsActivos - Bloqueado: Administrador', [
                        'user_id' => $user->id,
                        'user_email' => $user->email
                    ]);
                    return response()->json([
                        'success' => true,
                        'message' => 'No hay popups disponibles para administradores',
                        'data' => [
                            'popups_activos' => [],
                            'total_popups' => 0,
                            'razon' => 'Los administradores no tienen acceso a popups de clientes'
                        ]
                    ]);
                }

                Log::info('✅ popupsActivos - Cliente válido', [
                    'cliente_id' => $cliente->id,
                    'cliente_email' => $cliente->email
                ]);
            } else {
                Log::info('👤 popupsActivos - Visitante sin autenticar');
            }

            // Determinar segmentos del cliente
            $segmentosCliente = $this->obtenerSegmentosCliente($user);

            // Si no hay segmentos, no mostrar popups
            if (empty($segmentosCliente)) {
                return response()->json([
                    'success' => true,
                    'message' => 'No hay popups disponibles',
                    'data' => [
                        'popups_activos' => [],
                        'total_popups' => 0
                    ]
                ]);
            }

            // Buscar popups activos
            $popupsQuery = \App\Models\RecompensaPopup::query()
                ->activos()
                ->deRecompensasActivas();

            // Filtrar por segmentos
            if ($user) {
                // Usuario autenticado: excluir 'no_registrados'
                $popupsQuery->whereHas('recompensa.clientes', function($q) use ($segmentosCliente) {
                    $q->whereIn('segmento', $segmentosCliente)
                      ->where('segmento', '!=', 'no_registrados');
                });
            } else {
                // Usuario NO autenticado: solo 'no_registrados'
                $popupsQuery->whereHas('recompensa.clientes', function($q) {
                    $q->where('segmento', 'no_registrados');
                });
            }

            $popups = $popupsQuery->with(['recompensa:id,nombre,tipo,fecha_inicio,fecha_fin,estado'])
                ->orderBy('created_at', 'desc')
                ->get();

            $popupsActivos = $popups->map(function($popup) {
                $configuracion = $popup->getConfiguracionFrontend();
                if ($popup->imagen_popup) {
                    $configuracion['imagen_popup_url'] = asset('storage/popups/' . $popup->imagen_popup);
                }
                return $configuracion;
            })->values()->all();

            return response()->json([
                'success' => true,
                'message' => 'Popups obtenidos exitosamente',
                'data' => [
                    'popups_activos' => array_values($popupsActivos),
                    'total_popups' => count($popupsActivos),
                    'segmentos_cliente' => $segmentosCliente
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener los popups activos',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Marcar popup como visto
     */
    public function marcarVisto(Request $request, $popupId): JsonResponse
    {
        try {
            $user = $request->user();

            // Si no hay usuario autenticado, solo confirmar (para visitantes)
            if (!$user) {
                return response()->json([
                    'success' => true,
                    'message' => 'Popup marcado como visto',
                    'data' => [
                        'popup_id' => $popupId,
                        'visto_por' => 'visitante_no_autenticado'
                    ]
                ]);
            }

            // Verificar si es un cliente
            $cliente = \App\Models\UserCliente::find($user->id);

            // Si NO es cliente (puede ser admin o motorizado), permitir marcar sin registrar
            if (!$cliente) {
                return response()->json([
                    'success' => true,
                    'message' => 'Popup marcado como visto',
                    'data' => [
                        'popup_id' => $popupId,
                        'visto_por' => 'usuario_no_cliente'
                    ]
                ]);
            }

            // Si es cliente, buscar o crear notificación
            $notificacion = RecompensaNotificacionCliente::where('popup_id', $popupId)
                ->where('cliente_id', $cliente->id)
                ->first();

            if (!$notificacion) {
                // Si no existe notificación, crear una nueva
                $popup = RecompensaPopup::find($popupId);
                if (!$popup) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Popup no encontrado'
                    ], 404);
                }

                $notificacion = RecompensaNotificacionCliente::create([
                    'recompensa_id' => $popup->recompensa_id,
                    'cliente_id' => $cliente->id,
                    'popup_id' => $popupId,
                    'fecha_notificacion' => now(),
                    'estado' => RecompensaNotificacionCliente::ESTADO_ENVIADA
                ]);
            }

            $notificacion->marcarComoVista();

            return response()->json([
                'success' => true,
                'message' => 'Popup marcado como visto',
                'data' => $notificacion->getEstadisticas()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al marcar el popup como visto',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cerrar popup
     */
    public function cerrarPopup(Request $request, $popupId): JsonResponse
    {
        try {
            $user = $request->user();

            // Si no hay usuario autenticado, permitir cerrar popup (para visitantes)
            if (!$user) {
                // Para visitantes no autenticados, solo registrar que se cerró
                return response()->json([
                    'success' => true,
                    'message' => 'Popup cerrado exitosamente',
                    'data' => [
                        'popup_id' => $popupId,
                        'cerrado_por' => 'visitante_no_autenticado'
                    ]
                ]);
            }

            // Verificar si es un cliente
            $cliente = \App\Models\UserCliente::find($user->id);

            // Si NO es cliente (puede ser admin o motorizado), permitir cerrar sin registrar en BD
            if (!$cliente) {
                return response()->json([
                    'success' => true,
                    'message' => 'Popup cerrado exitosamente',
                    'data' => [
                        'popup_id' => $popupId,
                        'cerrado_por' => 'usuario_no_cliente'
                    ]
                ]);
            }

            // Si es cliente, buscar y actualizar la notificación
            $notificacion = RecompensaNotificacionCliente::where('popup_id', $popupId)
                ->where('cliente_id', $cliente->id)
                ->first();

            if (!$notificacion) {
                // Si no existe notificación, crear una nueva marcada como cerrada
                $popup = RecompensaPopup::find($popupId);
                if (!$popup) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Popup no encontrado'
                    ], 404);
                }

                $notificacion = RecompensaNotificacionCliente::create([
                    'recompensa_id' => $popup->recompensa_id,
                    'cliente_id' => $cliente->id,
                    'popup_id' => $popupId,
                    'fecha_notificacion' => now(),
                    'fecha_cierre' => now(),
                    'estado' => RecompensaNotificacionCliente::ESTADO_CERRADA
                ]);

                return response()->json([
                    'success' => true,
                    'message' => 'Popup cerrado exitosamente',
                    'data' => $notificacion->getEstadisticas()
                ]);
            }

            // Actualizar notificación existente
            $notificacion->marcarComoCerrada();

            return response()->json([
                'success' => true,
                'message' => 'Popup cerrado exitosamente',
                'data' => $notificacion->getEstadisticas()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al cerrar el popup',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener historial de notificaciones del cliente
     */
    public function historialNotificaciones(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Usuario no autenticado'
                ], 401);
            }
            
            $cliente = \App\Models\UserCliente::find($user->id);
            if (!$cliente) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cliente no autenticado'
                ], 401);
            }

            $query = RecompensaNotificacionCliente::where('cliente_id', $cliente->id)
                ->with(['recompensa:id,nombre,tipo', 'popup:id,titulo'])
                ->orderBy('fecha_notificacion', 'desc');

            // Filtros opcionales
            if ($request->has('estado') && !empty($request->estado)) {
                $query->where('estado', $request->estado);
            }

            if ($request->has('recompensa_id') && !empty($request->estado)) {
                $query->where('recompensa_id', $request->recompensa_id);
            }

            $notificaciones = $query->paginate($request->get('per_page', 15));

            $notificaciones->getCollection()->transform(function($notificacion) {
                return [
                    'id' => $notificacion->id,
                    'recompensa' => [
                        'id' => $notificacion->recompensa->id,
                        'nombre' => $notificacion->recompensa->nombre,
                        'tipo' => $notificacion->recompensa->tipo
                    ],
                    'popup' => [
                        'id' => $notificacion->popup->id,
                        'titulo' => $notificacion->popup->titulo
                    ],
                    'estado' => $notificacion->estado,
                    'fecha_notificacion' => $notificacion->fecha_notificacion,
                    'fecha_visualizacion' => $notificacion->fecha_visualizacion,
                    'fecha_cierre' => $notificacion->fecha_cierre,
                    'tiempo_transcurrido' => $notificacion->tiempo_transcurrido,
                    'fue_vista' => $notificacion->fueVista(),
                    'fue_cerrada' => $notificacion->fueCerrada(),
                    'esta_activa' => $notificacion->estaActiva()
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Historial de notificaciones obtenido exitosamente',
                'data' => $notificaciones
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener el historial de notificaciones',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar notificación a clientes (Admin)
     */
    public function enviarNotificacion(Request $request, $recompensaId): JsonResponse
    {
        try {
            $recompensa = Recompensa::find($recompensaId);
            if (!$recompensa) {
                return response()->json([
                    'success' => false,
                    'message' => 'Recompensa no encontrada'
                ], 404);
            }

            $popup = $recompensa->popup;
            if (!$popup) {
                return response()->json([
                    'success' => false,
                    'message' => 'No hay popup configurado para esta recompensa'
                ], 422);
            }

            $validator = Validator::make($request->all(), [
                'cliente_ids' => 'required|array',
                'cliente_ids.*' => 'exists:user_clientes,id'
            ], [
                'cliente_ids.required' => 'Debe seleccionar al menos un cliente',
                'cliente_ids.array' => 'Los clientes deben ser un array',
                'cliente_ids.*.exists' => 'Uno o más clientes no existen'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            $notificacionesCreadas = [];
            $fechaNotificacion = now();

            foreach ($request->cliente_ids as $clienteId) {
                // Verificar si ya existe una notificación activa
                $existeNotificacion = RecompensaNotificacionCliente::where('recompensa_id', $recompensaId)
                    ->where('cliente_id', $clienteId)
                    ->where('popup_id', $popup->id)
                    ->where('estado', '!=', RecompensaNotificacionCliente::ESTADO_EXPIRADA)
                    ->exists();

                if (!$existeNotificacion) {
                    $notificacion = RecompensaNotificacionCliente::create([
                        'recompensa_id' => $recompensaId,
                        'cliente_id' => $clienteId,
                        'popup_id' => $popup->id,
                        'fecha_notificacion' => $fechaNotificacion,
                        'estado' => RecompensaNotificacionCliente::ESTADO_ENVIADA
                    ]);

                    $notificacionesCreadas[] = $notificacion;
                }
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Notificaciones enviadas exitosamente',
                'data' => [
                    'total_enviadas' => count($notificacionesCreadas),
                    'total_solicitadas' => count($request->cliente_ids),
                    'notificaciones_duplicadas' => count($request->cliente_ids) - count($notificacionesCreadas)
                ]
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar las notificaciones',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener estadísticas de notificaciones (Admin)
     */
    public function estadisticasNotificaciones($recompensaId): JsonResponse
    {
        try {
            $recompensa = Recompensa::find($recompensaId);
            if (!$recompensa) {
                return response()->json([
                    'success' => false,
                    'message' => 'Recompensa no encontrada'
                ], 404);
            }

            $notificaciones = RecompensaNotificacionCliente::where('recompensa_id', $recompensaId)
                ->get();

            $estadisticas = [
                'total_notificaciones' => $notificaciones->count(),
                'por_estado' => [
                    'enviadas' => $notificaciones->where('estado', RecompensaNotificacionCliente::ESTADO_ENVIADA)->count(),
                    'vistas' => $notificaciones->where('estado', RecompensaNotificacionCliente::ESTADO_VISTA)->count(),
                    'cerradas' => $notificaciones->where('estado', RecompensaNotificacionCliente::ESTADO_CERRADA)->count(),
                    'expiradas' => $notificaciones->where('estado', RecompensaNotificacionCliente::ESTADO_EXPIRADA)->count()
                ],
                'tasa_apertura' => $notificaciones->count() > 0 
                    ? round(($notificaciones->where('estado', '!=', RecompensaNotificacionCliente::ESTADO_ENVIADA)->count() / $notificaciones->count()) * 100, 2)
                    : 0,
                'tasa_cierre' => $notificaciones->count() > 0 
                    ? round(($notificaciones->where('estado', RecompensaNotificacionCliente::ESTADO_CERRADA)->count() / $notificaciones->count()) * 100, 2)
                    : 0,
                'clientes_unicos' => $notificaciones->pluck('cliente_id')->unique()->count(),
                'distribucion_temporal' => $notificaciones->groupBy(function($notificacion) {
                    return $notificacion->fecha_notificacion->format('Y-m-d');
                })->map(function($grupo, $fecha) {
                    return [
                        'fecha' => $fecha,
                        'total' => $grupo->count(),
                        'vistas' => $grupo->where('estado', '!=', RecompensaNotificacionCliente::ESTADO_ENVIADA)->count()
                    ];
                })->values()
            ];

            return response()->json([
                'success' => true,
                'message' => 'Estadísticas de notificaciones obtenidas exitosamente',
                'data' => $estadisticas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener las estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener recompensas que califican para el cliente
     */
    private function obtenerRecompensasAplicables($cliente)
    {
        $segmentoCliente = method_exists($cliente, 'getSegmentoCliente')
            ? $cliente->getSegmentoCliente()
            : 'todos';

        // Filtrar por segmentos directamente en base de datos
        return Recompensa::with(['popup'])
            ->activas()
            ->vigentes()
            ->whereHas('clientes', function ($q) use ($segmentoCliente) {
                // Solo segmentos para clientes autenticados (excluir 'no_registrados')
                $q->where(function($qq) use ($segmentoCliente) {
                    $qq->where('segmento', $segmentoCliente)
                       ->orWhere('segmento', 'todos');
                })->where('segmento', '!=', 'no_registrados');
            })
            ->get();
    }

    /**
     * Verificar si una recompensa aplica al cliente
     */
    private function recompensaAplicaAlCliente($recompensa, $cliente)
    {
        foreach ($recompensa->clientes as $segmento) {
            if ($segmento->clienteCumpleSegmento($cliente)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Endpoint de prueba para verificar envío automático
     */
    public function probarEnvioAutomatico(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Usuario no autenticado'
                ], 401);
            }
            
            $cliente = \App\Models\UserCliente::find($user->id);
            if (!$cliente) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cliente no autenticado'
                ], 401);
            }

            // Obtener estadísticas del envío automático
            $recompensasAplicables = $this->obtenerRecompensasAplicables($cliente);
            $popupsEnviados = 0;
            $detallesEnvio = [];

            foreach ($recompensasAplicables as $recompensa) {
                $popup = $recompensa->popup;
                if ($popup && $popup->estaActivo()) {
                    $notificacion = $this->enviarPopupAutomaticamente($cliente, $recompensa, $popup);
                    if ($notificacion) {
                        $popupsEnviados++;
                    $detallesEnvio[] = [
                            'recompensa_id' => $recompensa->id,
                            'recompensa_nombre' => $recompensa->nombre,
                            'popup_id' => $popup->id,
                            'popup_titulo' => $popup->titulo,
                            'notificacion_id' => $notificacion->id,
                            'fecha_envio' => $notificacion->fecha_notificacion,
                            'segmento_cliente' => $cliente->getSegmentoCliente()
                        ];
                    }
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Prueba de envío automático completada',
                'data' => [
                    'cliente' => [
                        'id' => $cliente->id,
                        'nombre' => $cliente->nombres . ' ' . $cliente->apellidos,
                        'segmento_actual' => $cliente->getSegmentoCliente()
                    ],
                    'popups_enviados' => $popupsEnviados,
                    'total_recompensas_aplicables' => $recompensasAplicables->count(),
                    'detalles_envio' => $detallesEnvio
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error en la prueba de envío automático',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar popup automáticamente a un cliente
     */
    private function enviarPopupAutomaticamente($cliente, $recompensa, $popup)
    {
        try {
            // Verificar si ya existe una notificación activa para evitar duplicados
            $notificacionExistente = RecompensaNotificacionCliente::where('recompensa_id', $recompensa->id)
                ->where('cliente_id', $cliente->id)
                ->where('popup_id', $popup->id)
                ->where('estado', '!=', RecompensaNotificacionCliente::ESTADO_EXPIRADA)
                ->first();

            if ($notificacionExistente) {
                // Si ya existe, actualizar la fecha de notificación
                $notificacionExistente->fecha_notificacion = now();
                $notificacionExistente->save();
                return $notificacionExistente;
            }

            // Crear nueva notificación automática
            $notificacion = RecompensaNotificacionCliente::create([
                'recompensa_id' => $recompensa->id,
                'cliente_id' => $cliente->id,
                'popup_id' => $popup->id,
                'fecha_notificacion' => now(),
                'estado' => RecompensaNotificacionCliente::ESTADO_ENVIADA
            ]);

            // Log del envío automático
            Log::info("Popup enviado automáticamente", [
                'cliente_id' => $cliente->id,
                'recompensa_id' => $recompensa->id,
                'popup_id' => $popup->id,
                'segmento_cliente' => $cliente->getSegmentoCliente(),
                'fecha_envio' => now()
            ]);

            return $notificacion;

        } catch (\Exception $e) {
            Log::error("Error enviando popup automáticamente", [
                'cliente_id' => $cliente->id,
                'recompensa_id' => $recompensa->id,
                'popup_id' => $popup->id,
                'error' => $e->getMessage()
            ]);
            return null;
        }
    }

    /**
     * Determinar segmentos del cliente basado en su comportamiento
     */
    private function obtenerSegmentosCliente($user): array
    {
        $segmentos = [];

        // Si no hay usuario autenticado, solo mostrar 'no_registrados'
        if (!$user) {
            return ['no_registrados']; // Visitantes solo ven popups de 'no_registrados'
        }

        // Verificar que NO sea un usuario motorizado
        $userMotorizado = \App\Models\UserMotorizado::find($user->id);
        if ($userMotorizado) {
            // Los motorizados NO deben ver popups de recompensas
            return []; // Retornar array vacío para que no vean ningún popup
        }

        // Obtener cliente de user_clientes
        $cliente = \App\Models\UserCliente::find($user->id);
        if (!$cliente) {
            // Si no es cliente ni motorizado, es un admin - NO mostrar popups
            return [];
        }
        
        // IMPORTANTE: Los clientes autenticados NUNCA deben ver popups de 'no_registrados'
        // Solo visitantes no autenticados deben ver ese segmento
        
        // Lógica de segmentación basada en comportamiento del cliente
        $fechaRegistro = $cliente->created_at;
        $diasDesdeRegistro = $fechaRegistro->diffInDays(now());
        
        // 1. Cliente nuevo (menos de 30 días registrado)
        if ($diasDesdeRegistro <= 30) {
            $segmentos[] = 'nuevos';
        }
        
        // 2. Verificar si es cliente recurrente (tiene pedidos)
        $totalPedidos = \App\Models\Pedido::where('user_cliente_id', $cliente->id)
            ->where('estado_pedido', '!=', 'cancelado')
            ->count();
            
        if ($totalPedidos >= 3) {
            $segmentos[] = 'recurrentes';
        }
        
        // 3. Verificar si es VIP (gasto acumulado alto)
        $gastoAcumulado = \App\Models\Pedido::where('user_cliente_id', $cliente->id)
            ->where('estado_pedido', '!=', 'cancelado')
            ->sum('total');
            
        if ($gastoAcumulado >= 1000) { // 1000 soles o más
            $segmentos[] = 'vip';
        }
        
        // Siempre incluir 'todos' como fallback
        $segmentos[] = 'todos';
        
        // NUNCA incluir 'no_registrados' para usuarios autenticados
        return array_unique($segmentos);
    }

    /**
     * Endpoint de diagnóstico para verificar pop-ups
     */
    public function diagnosticarPopups(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $diagnostico = [
                'usuario_autenticado' => $user ? true : false,
                'tipo_usuario' => 'no_autenticado',
                'es_cliente' => false,
                'es_motorizado' => false,
                'es_admin' => false,
                'segmentos_aplicables' => [],
                'popups_disponibles' => 0
            ];
            
            if ($user) {
                // Verificar tipo de usuario
                $cliente = \App\Models\UserCliente::find($user->id);
                $userMotorizado = \App\Models\UserMotorizado::find($user->id);
                
                if ($cliente) {
                    $diagnostico['tipo_usuario'] = 'cliente';
                    $diagnostico['es_cliente'] = true;
                    $diagnostico['segmentos_aplicables'] = $this->obtenerSegmentosCliente($user);
                } elseif ($userMotorizado) {
                    $diagnostico['tipo_usuario'] = 'motorizado';
                    $diagnostico['es_motorizado'] = true;
                    $diagnostico['segmentos_aplicables'] = [];
                } else {
                    $diagnostico['tipo_usuario'] = 'admin';
                    $diagnostico['es_admin'] = true;
                    $diagnostico['segmentos_aplicables'] = [];
                }
            } else {
                $diagnostico['segmentos_aplicables'] = ['todos'];
            }
            
            // Contar popups disponibles según el tipo de usuario
            if ($diagnostico['es_motorizado'] || $diagnostico['es_admin']) {
                $diagnostico['popups_disponibles'] = 0;
                $diagnostico['mensaje'] = 'Los motorizados y administradores no deben ver popups de recompensas';
            } else {
                $segmentos = $diagnostico['segmentos_aplicables'];
                if (!empty($segmentos)) {
                    $popupsQuery = \App\Models\RecompensaPopup::query()
                        ->activos()
                        ->deRecompensasActivas();
                    
                    if ($diagnostico['es_cliente']) {
                        // Clientes autenticados: segmentos específicos + todos, EXCLUYENDO no_registrados
                        $popupsQuery->whereHas('recompensa.clientes', function($q) use ($segmentos) {
                            $q->where(function($qq) use ($segmentos) {
                                $qq->where('segmento', 'todos');
                                if (!empty($segmentos)) {
                                    $qq->orWhereIn('segmento', $segmentos);
                                }
                            })
                            ->where('segmento', '!=', 'no_registrados');
                        });
                    } else {
                        // Usuario no autenticado - solo segmento 'no_registrados'
                        $popupsQuery->whereHas('recompensa.clientes', function($q) {
                            $q->where('segmento', 'no_registrados');
                        });
                    }
                    
                    $diagnostico['popups_disponibles'] = $popupsQuery->count();
                }
            }
            
            // Agregar información adicional al diagnóstico
            $diagnostico['timestamp'] = now()->toISOString();
            $diagnostico['popups_totales'] = RecompensaPopup::count();
            $diagnostico['popups_activos'] = RecompensaPopup::where('popup_activo', true)->count();
            $diagnostico['recompensas_totales'] = Recompensa::count();
            $diagnostico['recompensas_activas'] = Recompensa::where('estado', 'activa')->count();
            $diagnostico['recompensas_vigentes'] = Recompensa::where('estado', 'activa')
                ->where('fecha_inicio', '<=', now())
                ->where('fecha_fin', '>=', now())
                ->count();

            // Verificar pop-ups por segmento
            $segmentos = ['todos', 'no_registrados', 'nuevos', 'recurrentes', 'vip'];
            $diagnostico['popups_por_segmento'] = [];
            foreach ($segmentos as $segmento) {
                $count = RecompensaPopup::whereHas('recompensa.clientes', function($q) use ($segmento) {
                    $q->where('segmento', $segmento);
                })->where('popup_activo', true)->count();
                
                $diagnostico['popups_por_segmento'][$segmento] = $count;
            }

            return response()->json([
                'success' => true,
                'message' => 'Diagnóstico de pop-ups completado',
                'data' => $diagnostico
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error en el diagnóstico',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
