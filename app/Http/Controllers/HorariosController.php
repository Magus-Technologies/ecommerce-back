<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserHorario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class HorariosController extends Controller
{
    public function index(Request $request)
    {
        $query = User::with(['horarios' => function($q) {
            $q->where('activo', true)
              ->whereNull('fecha_especial')
              ->orderBy('dia_semana')
              ->orderBy('hora_inicio');
        }, 'roles', 'profile']);

        // Filtrar por rol si se especifica
        if ($request->has('rol')) {
            $query->whereHas('roles', function($q) use ($request) {
                $q->where('name', $request->rol);
            });
        }

        // Solo usuarios activos
        $query->where('is_enabled', true);

        $usuarios = $query->get();

        return response()->json([
            'usuarios' => $usuarios,
            'disponibles_ahora' => $usuarios->map(function($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'disponible' => $user->isDisponibleAhora()
                ];
            })
        ]);
    }

    public function show($userId)
    {
        try {
            $usuario = User::with(['horarios' => function($q) {
                $q->where('activo', true)
                  ->orderBy('fecha_especial', 'desc')
                  ->orderBy('dia_semana')
                  ->orderBy('hora_inicio');
            }, 'roles', 'profile'])->findOrFail($userId);

            $horariosAgrupados = [
                'regulares' => $usuario->horarios->whereNull('fecha_especial')->groupBy('dia_semana'),
                'excepciones' => $usuario->horarios->whereNotNull('fecha_especial')
            ];

            return response()->json([
                'usuario' => $usuario,
                'horarios' => $horariosAgrupados,
                'disponible_ahora' => $usuario->isDisponibleAhora()
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Usuario no encontrado'], 404);
        }
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'dia_semana' => 'required|in:lunes,martes,miercoles,jueves,viernes,sabado,domingo',
            'hora_inicio' => 'required|date_format:H:i',
            'hora_fin' => 'required|date_format:H:i|after:hora_inicio',
            'es_descanso' => 'boolean',
            'fecha_especial' => 'nullable|date|after_or_equal:today',
            'comentarios' => 'nullable|string|max:500'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Datos inválidos',
                'details' => $validator->errors()
            ], 422);
        }

        // Validar solapamiento solo si no es descanso
        if (!$request->get('es_descanso', false)) {
            $haysolapamiento = UserHorario::validarSolapamiento(
                $request->user_id,
                $request->dia_semana,
                $request->hora_inicio,
                $request->hora_fin,
                null,
                $request->fecha_especial
            );

            if ($haysolapamiento) {
                return response()->json([
                    'error' => 'Hay solapamiento con otro horario existente'
                ], 422);
            }
        }

        try {
            $horario = UserHorario::create($request->all());
            
            return response()->json([
                'message' => 'Horario creado exitosamente',
                'horario' => $horario->load('user')
            ], 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al crear horario'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $horario = UserHorario::findOrFail($id);
            
            $validator = Validator::make($request->all(), [
                'dia_semana' => 'required|in:lunes,martes,miercoles,jueves,viernes,sabado,domingo',
                'hora_inicio' => 'required|date_format:H:i',
                'hora_fin' => 'required|date_format:H:i|after:hora_inicio',
                'es_descanso' => 'boolean',
                'fecha_especial' => 'nullable|date',
                'comentarios' => 'nullable|string|max:500',
                'activo' => 'boolean'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'error' => 'Datos inválidos',
                    'details' => $validator->errors()
                ], 422);
            }

            // Validar solapamiento solo si no es descanso
            if (!$request->get('es_descanso', false)) {
                $haysolapamiento = UserHorario::validarSolapamiento(
                    $horario->user_id,
                    $request->dia_semana,
                    $request->hora_inicio,
                    $request->hora_fin,
                    $horario->id,
                    $request->fecha_especial
                );

                if ($haysolapamiento) {
                    return response()->json([
                        'error' => 'Hay solapamiento con otro horario existente'
                    ], 422);
                }
            }

            $horario->update($request->all());
            
            return response()->json([
                'message' => 'Horario actualizado exitosamente',
                'horario' => $horario->load('user')
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al actualizar horario'], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $horario = UserHorario::findOrFail($id);
            $horario->delete();
            
            return response()->json(['message' => 'Horario eliminado exitosamente']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al eliminar horario'], 500);
        }
    }

    /**
     * Copiar horarios de un usuario a otro
     */
    public function copiarHorarios(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'usuario_origen_id' => 'required|exists:users,id',
            'usuario_destino_id' => 'required|exists:users,id|different:usuario_origen_id',
            'sobrescribir' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Datos inválidos',
                'details' => $validator->errors()
            ], 422);
        }

        try {
            DB::beginTransaction();

            // Si se debe sobrescribir, eliminar horarios existentes
            if ($request->get('sobrescribir', false)) {
                UserHorario::where('user_id', $request->usuario_destino_id)
                    ->whereNull('fecha_especial')
                    ->delete();
            }

            // Obtener horarios regulares del usuario origen
            $horariosOrigen = UserHorario::where('user_id', $request->usuario_origen_id)
                ->whereNull('fecha_especial')
                ->where('activo', true)
                ->get();

            $horariosCopiados = 0;
            foreach ($horariosOrigen as $horarioOrigen) {
                // Verificar si ya existe un horario similar
                $existe = UserHorario::where('user_id', $request->usuario_destino_id)
                    ->where('dia_semana', $horarioOrigen->dia_semana)
                    ->where('hora_inicio', $horarioOrigen->hora_inicio)
                    ->where('hora_fin', $horarioOrigen->hora_fin)
                    ->whereNull('fecha_especial')
                    ->exists();

                if (!$existe) {
                    UserHorario::create([
                        'user_id' => $request->usuario_destino_id,
                        'dia_semana' => $horarioOrigen->dia_semana,
                        'hora_inicio' => $horarioOrigen->hora_inicio,
                        'hora_fin' => $horarioOrigen->hora_fin,
                        'es_descanso' => $horarioOrigen->es_descanso,
                        'comentarios' => $horarioOrigen->comentarios,
                        'activo' => true
                    ]);
                    $horariosCopiados++;
                }
            }

            DB::commit();

            return response()->json([
                'message' => "Se copiaron {$horariosCopiados} horarios exitosamente"
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Error al copiar horarios'], 500);
        }
    }

  public function asesorDisponibles()
    {
        // Usar zona horaria de Lima
        $ahora = Carbon::now('America/Lima');
        
        Log::info('=== VERIFICANDO ASESORES DISPONIBLES ===');
        Log::info('Hora actual Lima: ' . $ahora->format('Y-m-d H:i:s T'));
        Log::info('Día de la semana: ' . $ahora->dayOfWeek . ' (' . $ahora->format('l') . ')');
        
        $usuarios = User::whereHas('roles', function($query) {
            $query->where('name', 'vendedor');
        })
        ->where('is_enabled', true)
        ->with(['profile', 'horarios' => function($q) {
            $q->where('activo', true);
        }])
        ->get();

        Log::info('Usuarios vendedor encontrados: ' . $usuarios->count());

        $asesorDisponibles = [];
        
        foreach ($usuarios as $usuario) {
            // Pasar la hora de Lima al método
            $disponible = UserHorario::estaDisponible($usuario->id, $ahora);
            
            Log::info("Usuario {$usuario->id} ({$usuario->name}): " . ($disponible ? 'DISPONIBLE' : 'NO DISPONIBLE'));
            Log::info("Horarios del usuario: " . $usuario->horarios->toJson());
            
            if ($disponible) {
                $asesorDisponibles[] = [
                    'id' => $usuario->id,
                    'name' => $usuario->name,
                    'email' => $usuario->email,
                    'telefono' => $usuario->profile->phone ?? null,
                    'avatar' => $usuario->profile->avatar_url ?? null,
                    'disponible' => true
                ];
            }
        }

        Log::info('Asesores disponibles finales: ' . count($asesorDisponibles));
        
        return response()->json([
            'asesores_disponibles' => $asesorDisponibles,
            'debug_info' => [
                'hora_servidor' => $ahora->format('Y-m-d H:i:s T'),
                'timezone' => config('app.timezone')
            ]
        ]);
    }



    /**
     * Obtener plantillas de horarios
     */
    public function plantillasHorarios()
    {
        $plantillas = [
            'full_time' => [
                'nombre' => 'Tiempo Completo',
                'horarios' => [
                    ['dia_semana' => 'lunes', 'hora_inicio' => '08:00', 'hora_fin' => '17:00'],
                    ['dia_semana' => 'martes', 'hora_inicio' => '08:00', 'hora_fin' => '17:00'],
                    ['dia_semana' => 'miercoles', 'hora_inicio' => '08:00', 'hora_fin' => '17:00'],
                    ['dia_semana' => 'jueves', 'hora_inicio' => '08:00', 'hora_fin' => '17:00'],
                    ['dia_semana' => 'viernes', 'hora_inicio' => '08:00', 'hora_fin' => '17:00']
                ]
            ],
            'medio_tiempo' => [
                'nombre' => 'Medio Tiempo',
                'horarios' => [
                    ['dia_semana' => 'lunes', 'hora_inicio' => '08:00', 'hora_fin' => '12:00'],
                    ['dia_semana' => 'martes', 'hora_inicio' => '08:00', 'hora_fin' => '12:00'],
                    ['dia_semana' => 'miercoles', 'hora_inicio' => '08:00', 'hora_fin' => '12:00'],
                    ['dia_semana' => 'jueves', 'hora_inicio' => '08:00', 'hora_fin' => '12:00'],
                    ['dia_semana' => 'viernes', 'hora_inicio' => '08:00', 'hora_fin' => '12:00']
                ]
            ],
            'noche' => [
                'nombre' => 'Turno Noche',
                'horarios' => [
                    ['dia_semana' => 'lunes', 'hora_inicio' => '18:00', 'hora_fin' => '02:00'],
                    ['dia_semana' => 'martes', 'hora_inicio' => '18:00', 'hora_fin' => '02:00'],
                    ['dia_semana' => 'miercoles', 'hora_inicio' => '18:00', 'hora_fin' => '02:00'],
                    ['dia_semana' => 'jueves', 'hora_inicio' => '18:00', 'hora_fin' => '02:00'],
                    ['dia_semana' => 'viernes', 'hora_inicio' => '18:00', 'hora_fin' => '02:00']
                ]
            ]
        ];

        return response()->json(['plantillas' => $plantillas]);
    }
}
