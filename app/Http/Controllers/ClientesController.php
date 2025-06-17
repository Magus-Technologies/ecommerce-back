<?php

namespace App\Http\Controllers;

use App\Models\Cliente;
use App\Models\ClienteDireccion;
use App\Models\DocumentType;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;

class ClientesController extends Controller
{
     public function index(Request $request): JsonResponse
    {
        try {
            $query = Cliente::with(['tipoDocumento', 'direccionPrincipal.ubigeo']);

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

            if ($request->filled('tipo_login')) {
                $query->where('tipo_login', $request->tipo_login);
            }

            if ($request->filled('fecha_desde')) {
                $query->whereDate('fecha_registro', '>=', $request->fecha_desde);
            }

            if ($request->filled('fecha_hasta')) {
                $query->whereDate('fecha_registro', '<=', $request->fecha_hasta);
            }

            $perPage = $request->get('per_page', 10);
            $clientes = $query->orderBy('fecha_registro', 'desc')->paginate($perPage);

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
            $cliente = Cliente::with(['tipoDocumento', 'direcciones.ubigeo'])
                             ->findOrFail($id);

            // Datos ficticios para estadísticas (ya que no tienes módulo de pedidos)
            $estadisticas = [
                'total_pedidos' => rand(0, 20),
                'total_gastado' => rand(0, 5000),
                'ultima_compra' => now()->subDays(rand(1, 180))->format('Y-m-d'),
                'productos_favoritos' => ['Audífonos', 'Polo Nike'],
                'porcentaje_entregados' => rand(80, 100)
            ];

            // Datos ficticios para historial de pedidos
            $pedidos = collect([
                [
                    'id' => 12,
                    'fecha' => '2024-05-01',
                    'estado' => 'Entregado',
                    'monto' => 189.90,
                    'metodo_pago' => 'Tarjeta'
                ],
                [
                    'id' => 10,
                    'fecha' => '2024-04-10',
                    'estado' => 'Cancelado',
                    'monto' => 65.00,
                    'metodo_pago' => 'Yape'
                ]
            ]);

            // Datos ficticios para cupones
            $cupones = collect([
                [
                    'codigo' => 'WELCOME10',
                    'descuento' => '10%',
                    'fecha_uso' => '2024-05-01',
                    'pedido_id' => 12
                ]
            ]);

            return response()->json([
                'status' => 'success',
                'data' => [
                    'cliente' => $cliente,
                    'estadisticas' => $estadisticas,
                    'pedidos' => $pedidos,
                    'cupones' => $cupones
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Cliente no encontrado'
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $cliente = Cliente::findOrFail($id);

            $request->validate([
                'nombres' => 'required|string|max:100',
                'apellidos' => 'required|string|max:100',
                'email' => 'required|email|max:150|unique:clientes,email,' . $id . ',id_cliente',
                'telefono' => 'nullable|string|max:20',
                'fecha_nacimiento' => 'nullable|date',
                'genero' => 'nullable|in:M,F,Otro',
                'estado' => 'required|boolean'
            ]);

            $cliente->update($request->all());

            return response()->json([
                'status' => 'success',
                'message' => 'Cliente actualizado correctamente',
                'data' => $cliente->load(['tipoDocumento'])
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
            $cliente = Cliente::findOrFail($id);
            
            // Soft delete - cambiar estado a inactivo
            $cliente->update(['estado' => 0]);

            return response()->json([
                'status' => 'success',
                'message' => 'Cliente desactivado correctamente'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al desactivar cliente'
            ], 500);
        }
    }

    public function toggleEstado($id): JsonResponse
    {
        try {
            $cliente = Cliente::findOrFail($id);
            $cliente->update(['estado' => !$cliente->estado]);

            return response()->json([
                'status' => 'success',
                'message' => 'Estado actualizado correctamente',
                'data' => $cliente
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al cambiar estado'
            ], 500);
        }
    }

    public function estadisticas(): JsonResponse
    {
        try {
            $totalClientes = Cliente::count();
            $clientesActivos = Cliente::where('estado', 1)->count();
            $clientesNuevos = Cliente::whereMonth('fecha_registro', now()->month)->count();

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
                'message' => 'Error al obtener estadísticas'
            ], 500);
        }
    }
}
