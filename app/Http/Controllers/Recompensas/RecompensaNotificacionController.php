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

class RecompensaNotificacionController extends Controller
{
    /**
     * Obtener popups activos para el cliente autenticado
     */
    public function popupsActivos(Request $request): JsonResponse
    {
        try {
            $cliente = Auth::guard('cliente')->user();
            if (!$cliente) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cliente no autenticado'
                ], 401);
            }

            // Obtener recompensas que califican para el cliente
            $recompensasAplicables = $this->obtenerRecompensasAplicables($cliente);
            
            $popupsActivos = [];
            
            foreach ($recompensasAplicables as $recompensa) {
                $popup = $recompensa->popup;
                if ($popup && $popup->estaActivo()) {
                    $configuracion = $popup->getConfiguracionFrontend();
                    // Agregar URL de imagen si existe
                    if ($popup->imagen_popup) {
                        $configuracion['imagen_popup_url'] = asset('storage/popups/' . $popup->imagen_popup);
                    }
                    $popupsActivos[] = $configuracion;
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Popups activos obtenidos exitosamente',
                'data' => [
                    'cliente' => [
                        'id' => $cliente->id,
                        'nombre' => $cliente->nombres . ' ' . $cliente->apellidos,
                        'segmento_actual' => $cliente->getSegmentoCliente()
                    ],
                    'popups_activos' => $popupsActivos,
                    'total_popups' => count($popupsActivos)
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
            $cliente = Auth::guard('cliente')->user();
            if (!$cliente) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cliente no autenticado'
                ], 401);
            }

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
            $cliente = Auth::guard('cliente')->user();
            if (!$cliente) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cliente no autenticado'
                ], 401);
            }

            $notificacion = RecompensaNotificacionCliente::where('popup_id', $popupId)
                ->where('cliente_id', $cliente->id)
                ->first();

            if (!$notificacion) {
                return response()->json([
                    'success' => false,
                    'message' => 'Notificación no encontrada'
                ], 404);
            }

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
            $cliente = Auth::guard('cliente')->user();
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
        return Recompensa::with(['popup', 'clientes'])
            ->activas()
            ->vigentes()
            ->get()
            ->filter(function($recompensa) use ($cliente) {
                return $this->recompensaAplicaAlCliente($recompensa, $cliente);
            });
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
}
