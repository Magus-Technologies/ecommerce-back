<?php

namespace App\Http\Controllers;

use App\Models\UserCliente;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ClientesController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        try {
            $query = UserCliente::with(['tipoDocumento', 'direccionPredeterminada']);

            // Filtros
            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('nombres', 'like', "%{$search}%")
                      ->orWhere('apellidos', 'like', "%{$search}%")
                      ->orWhere('email', 'like', "%{$search}%")
                      ->orWhere('numero_documento', 'like', "%{$search}%");
                });
            }

            if ($request->filled('estado')) {
                $query->where('estado', $request->estado);
            }

            // Agregar tipo_login si existe en la tabla
            if ($request->filled('tipo_login')) {
                // Si no tienes este campo, puedes comentar esta línea
                // $query->where('tipo_login', $request->tipo_login);
            }

            if ($request->filled('fecha_desde')) {
                $query->whereDate('created_at', '>=', $request->fecha_desde);
            }

            if ($request->filled('fecha_hasta')) {
                $query->whereDate('created_at', '<=', $request->fecha_hasta);
            }

            $perPage = $request->get('per_page', 15);
            $clientes = $query->orderBy('created_at', 'desc')->paginate($perPage);

            // Transformar los datos para que coincidan con el frontend
            $clientesTransformados = $clientes->getCollection()->map(function ($cliente) {
                return [
                    'id_cliente' => $cliente->id,
                    'nombres' => $cliente->nombres,
                    'apellidos' => $cliente->apellidos,
                    'nombre_completo' => $cliente->nombre_completo,
                    'email' => $cliente->email,
                    'telefono' => $cliente->telefono,
                    'numero_documento' => $cliente->numero_documento,
                    'tipo_documento' => $cliente->tipoDocumento ? [
                        'id' => $cliente->tipoDocumento->id,
                        'nombre' => $cliente->tipoDocumento->nombre
                    ] : null,
                    'estado' => $cliente->estado,
                    'fecha_registro' => $cliente->created_at->toISOString(),
                    'foto' => $cliente->foto_url,
                    'tipo_login' => 'manual', // Por defecto manual, ajusta según tu lógica
                    'genero' => $cliente->genero,
                    'fecha_nacimiento' => $cliente->fecha_nacimiento?->format('Y-m-d'),
                ];
            });

            // Reemplazar la colección transformada
            $clientes->setCollection($clientesTransformados);

            return response()->json([
                'status' => 'success',
                'data' => $clientes
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al obtener clientes: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $cliente = UserCliente::with(['tipoDocumento', 'direcciones'])
                                 ->findOrFail($id);

            // Transformar datos del cliente
            $clienteData = [
                'id_cliente' => $cliente->id,
                'nombres' => $cliente->nombres,
                'apellidos' => $cliente->apellidos,
                'nombre_completo' => $cliente->nombre_completo,
                'email' => $cliente->email,
                'telefono' => $cliente->telefono,
                'numero_documento' => $cliente->numero_documento,
                'tipo_documento' => $cliente->tipoDocumento ? [
                    'id' => $cliente->tipoDocumento->id,
                    'nombre' => $cliente->tipoDocumento->nombre
                ] : null,
                'estado' => $cliente->estado,
                'fecha_registro' => $cliente->created_at->toISOString(),
                'foto' => $cliente->foto_url,
                'genero' => $cliente->genero,
                'fecha_nacimiento' => $cliente->fecha_nacimiento?->format('Y-m-d'),
                'direcciones' => $cliente->direcciones->map(function($direccion) {
                    return [
                        'id' => $direccion->id,
                        'nombre_destinatario' => $direccion->nombre_destinatario,
                        'direccion_completa' => $direccion->direccion_completa,
                        'referencia' => $direccion->referencia,
                        'predeterminada' => $direccion->predeterminada,
                        'activa' => $direccion->activa,
                    ];
                })
            ];

            // Estadísticas ficticias (puedes reemplazar con datos reales cuando tengas el módulo de ventas)
            $estadisticas = [
                'total_pedidos' => rand(0, 20),
                'total_gastado' => rand(0, 5000),
                'ultima_compra' => now()->subDays(rand(1, 180))->format('Y-m-d'),
                'productos_favoritos' => ['Producto A', 'Producto B'],
                'porcentaje_entregados' => rand(80, 100)
            ];

            // Historial ficticio
            $pedidos = collect([
                [
                    'id' => 1,
                    'fecha' => now()->subDays(5)->format('Y-m-d'),
                    'estado' => 'Entregado',
                    'monto' => 189.90,
                    'metodo_pago' => 'Tarjeta'
                ],
                [
                    'id' => 2,
                    'fecha' => now()->subDays(15)->format('Y-m-d'),
                    'estado' => 'Pendiente',
                    'monto' => 65.00,
                    'metodo_pago' => 'Yape'
                ]
            ]);

            $cupones = collect([]);

            return response()->json([
                'status' => 'success',
                'data' => [
                    'cliente' => $clienteData,
                    'estadisticas' => $estadisticas,
                    'pedidos' => $pedidos,
                    'cupones' => $cupones
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Cliente no encontrado: ' . $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $cliente = UserCliente::findOrFail($id);

            $request->validate([
                'nombres' => 'required|string|max:255',
                'apellidos' => 'required|string|max:255',
                'email' => 'required|email|max:255|unique:user_clientes,email,' . $id,
                'telefono' => 'nullable|string|max:20',
                'fecha_nacimiento' => 'nullable|date',
                'genero' => 'nullable|in:masculino,femenino,otro',
                'estado' => 'required|boolean'
            ]);

            $cliente->update($request->only([
                'nombres', 'apellidos', 'email', 'telefono', 
                'fecha_nacimiento', 'genero', 'estado'
            ]));

            // Transformar respuesta
            $clienteTransformado = [
                'id_cliente' => $cliente->id,
                'nombres' => $cliente->nombres,
                'apellidos' => $cliente->apellidos,
                'nombre_completo' => $cliente->nombre_completo,
                'email' => $cliente->email,
                'telefono' => $cliente->telefono,
                'numero_documento' => $cliente->numero_documento,
                'tipo_documento' => $cliente->tipoDocumento ? [
                    'id' => $cliente->tipoDocumento->id,
                    'nombre' => $cliente->tipoDocumento->nombre
                ] : null,
                'estado' => $cliente->estado,
                'fecha_registro' => $cliente->created_at->toISOString(),
                'foto' => $cliente->foto_url,
                'genero' => $cliente->genero,
                'fecha_nacimiento' => $cliente->fecha_nacimiento?->format('Y-m-d'),
            ];

            return response()->json([
                'status' => 'success',
                'message' => 'Cliente actualizado correctamente',
                'data' => $clienteTransformado
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al actualizar cliente: ' . $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $cliente = UserCliente::findOrFail($id);
            
            // Soft delete - cambiar estado a inactivo
            $cliente->update(['estado' => false]);

            return response()->json([
                'status' => 'success',
                'message' => 'Cliente desactivado correctamente'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al desactivar cliente: ' . $e->getMessage()
            ], 500);
        }
    }

    public function toggleEstado($id): JsonResponse
    {
        try {
            $cliente = UserCliente::findOrFail($id);
            $cliente->update(['estado' => !$cliente->estado]);

            return response()->json([
                'status' => 'success',
                'message' => 'Estado actualizado correctamente',
                'data' => [
                    'id_cliente' => $cliente->id,
                    'estado' => $cliente->estado
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al cambiar estado: ' . $e->getMessage()
            ], 500);
        }
    }

    public function estadisticas(): JsonResponse
    {
        try {
            $totalClientes = UserCliente::count();
            $clientesActivos = UserCliente::where('estado', true)->count();
            $clientesNuevos = UserCliente::whereMonth('created_at', now()->month)
                                       ->whereYear('created_at', now()->year)
                                       ->count();

            return response()->json([
                'status' => 'success',
                'data' => [
                    'total_clientes' => $totalClientes,
                    'clientes_activos' => $clientesActivos,
                    'clientes_nuevos' => $clientesNuevos
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al obtener estadísticas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
 * Obtener direcciones del cliente autenticado
 */
public function misDirecciones(Request $request)
{
    try {
        $cliente = $request->user();
        \Log::info('Cliente autenticado:', ['id' => $cliente->id, 'email' => $cliente->email]);
        
        $direcciones = $cliente->direcciones()
            ->with(['ubigeo'])
            ->orderBy('predeterminada', 'desc')
            ->orderBy('created_at', 'desc')
            ->get();
        
        \Log::info('Direcciones encontradas:', ['count' => $direcciones->count()]);
        
        // Transformar los datos del ubigeo para mostrar nombres en lugar de códigos
        $direcciones->transform(function ($direccion) {
            if ($direccion->ubigeo) {
                // Obtener el departamento
                $departamento = \App\Models\UbigeoInei::where('departamento', $direccion->ubigeo->departamento)
                    ->where('provincia', '00')
                    ->where('distrito', '00')
                    ->first();
                
                // Obtener la provincia
                $provincia = \App\Models\UbigeoInei::where('departamento', $direccion->ubigeo->departamento)
                    ->where('provincia', $direccion->ubigeo->provincia)
                    ->where('distrito', '00')
                    ->first();
                
                // Asignar los nombres
                $direccion->ubigeo->departamento_nombre = $departamento ? $departamento->nombre : 'N/A';
                $direccion->ubigeo->provincia_nombre = $provincia ? $provincia->nombre : 'N/A';
                $direccion->ubigeo->distrito_nombre = $direccion->ubigeo->nombre; // El distrito ya tiene su nombre correcto
            }
            return $direccion;
        });
        
        // Log de cada dirección para debuggear
        foreach ($direcciones as $index => $direccion) {
            \Log::info("Dirección {$index}:", [
                'id' => $direccion->id,
                'nombre_destinatario' => $direccion->nombre_destinatario,
                'id_ubigeo' => $direccion->id_ubigeo,
                'ubigeo_loaded' => $direccion->relationLoaded('ubigeo'),
                'ubigeo_data' => $direccion->ubigeo
            ]);
        }
        
        return response()->json([
            'status' => 'success',
            'direcciones' => $direcciones
        ]);
    } catch (\Exception $e) {
        \Log::error('Error en misDirecciones:', [
            'message' => $e->getMessage(),
            'trace' => $e->getTraceAsString()
        ]);
        
        return response()->json([
            'status' => 'error',
            'message' => 'Error al obtener direcciones: ' . $e->getMessage()
        ], 500);
    }
}

/**
 * Crear nueva dirección
 */
public function crearDireccion(Request $request)
{
    $request->validate([
        'nombre_destinatario' => 'required|string|max:255',
        'direccion_completa' => 'required|string',
        'id_ubigeo' => 'required|string|exists:ubigeo_inei,id_ubigeo',
        'telefono' => 'nullable|string|max:20',
        'predeterminada' => 'boolean'
    ]);

    $cliente = $request->user();
    
    // Si es predeterminada, quitar predeterminada de las demás
    if ($request->predeterminada) {
        $cliente->direcciones()->update(['predeterminada' => false]);
    }
    
    $direccion = $cliente->direcciones()->create([
        'nombre_destinatario' => $request->nombre_destinatario,
        'direccion_completa' => $request->direccion_completa,
        'id_ubigeo' => $request->id_ubigeo,
        'telefono' => $request->telefono,
        'predeterminada' => $request->predeterminada ?? false,
        'activa' => true
    ]);
    
    $direccion->load('ubigeo');
    
    return response()->json([
        'status' => 'success',
        'message' => 'Dirección creada exitosamente',
        'direccion' => $direccion
    ], 201);
}

/**
 * Actualizar dirección existente
 */
public function actualizarDireccion(Request $request, $id)
{
    $request->validate([
        'nombre_destinatario' => 'required|string|max:255',
        'direccion_completa' => 'required|string',
        'id_ubigeo' => 'required|string|exists:ubigeo_inei,id_ubigeo',
        'telefono' => 'nullable|string|max:20',
        'predeterminada' => 'boolean'
    ]);

    $cliente = $request->user();
    
    // Buscar la dirección que pertenece al cliente autenticado
    $direccion = $cliente->direcciones()->findOrFail($id);
    
    // Si es predeterminada, quitar predeterminada de las demás
    if ($request->predeterminada) {
        $cliente->direcciones()->where('id', '!=', $id)->update(['predeterminada' => false]);
    }
    
    $direccion->update([
        'nombre_destinatario' => $request->nombre_destinatario,
        'direccion_completa' => $request->direccion_completa,
        'id_ubigeo' => $request->id_ubigeo,
        'telefono' => $request->telefono,
        'predeterminada' => $request->predeterminada ?? false
    ]);
    
    // Recargar la dirección con la relación ubigeo
    $direccion->refresh();
    $direccion->load('ubigeo');
    
    return response()->json([
        'status' => 'success',
        'message' => 'Dirección actualizada exitosamente',
        'direccion' => $direccion
    ]);
}

/**
 * Eliminar dirección
 */
public function eliminarDireccion(Request $request, $id)
{
    $cliente = $request->user();
    
    // Buscar la dirección que pertenece al cliente autenticado
    $direccion = $cliente->direcciones()->findOrFail($id);
    
    // No permitir eliminar si es la única dirección
    if ($cliente->direcciones()->count() <= 1) {
        return response()->json([
            'status' => 'error',
            'message' => 'No puedes eliminar tu única dirección'
        ], 400);
    }
    
    $esPredeterminada = $direccion->predeterminada;
    
    $direccion->delete();
    
    // Si era predeterminada, establecer otra como predeterminada
    if ($esPredeterminada) {
        $cliente->direcciones()->first()?->update(['predeterminada' => true]);
    }
    
    return response()->json([
        'status' => 'success',
        'message' => 'Dirección eliminada exitosamente'
    ]);
}

/**
 * Establecer dirección como predeterminada
 */
public function establecerPredeterminada(Request $request, $id)
{
    $cliente = $request->user();
    
    // Buscar la dirección que pertenece al cliente autenticado
    $direccion = $cliente->direcciones()->findOrFail($id);
    
    // Quitar predeterminada de todas las direcciones del cliente
    $cliente->direcciones()->update(['predeterminada' => false]);
    
    // Establecer esta como predeterminada
    $direccion->update(['predeterminada' => true]);
    
    // Recargar la dirección con la relación ubigeo
    $direccion->refresh();
    $direccion->load('ubigeo');
    
    return response()->json([
        'status' => 'success',
        'message' => 'Dirección establecida como predeterminada',
        'direccion' => $direccion
    ]);
}
}