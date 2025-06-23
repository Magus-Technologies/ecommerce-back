<?php

namespace App\Http\Controllers;

use App\Models\UserCliente;
use App\Models\UserClienteDireccion;
use App\Models\DocumentType;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;

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
}