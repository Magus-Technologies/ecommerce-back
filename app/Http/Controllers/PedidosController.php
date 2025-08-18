<?php

namespace App\Http\Controllers;

use App\Models\Pedido;
use App\Models\PedidoDetalle;
use App\Models\EstadoPedido;
use App\Models\UserCliente;
use App\Models\Producto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PedidosController extends Controller
{
    public function index(Request $request)
    {
        try {
            $query = Pedido::with(['cliente', 'estadoPedido']);

            // Filtros
            if ($request->has('estado_pedido_id') && $request->estado_pedido_id !== '') {
                $query->where('estado_pedido_id', $request->estado_pedido_id);
            }

            if ($request->has('cliente_id') && $request->cliente_id !== '') {
                $query->where('cliente_id', $request->cliente_id);
            }

            if ($request->has('user_cliente_id') && $request->user_cliente_id !== '') {
                $query->where('user_cliente_id', $request->user_cliente_id);
            }

            if ($request->has('fecha_inicio') && $request->has('fecha_fin')) {
                $query->whereBetween('fecha_pedido', [$request->fecha_inicio, $request->fecha_fin]);
            }

            if ($request->has('search') && $request->search !== '') {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('codigo_pedido', 'LIKE', "%{$search}%")
                      ->orWhereHas('cliente', function ($clienteQuery) use ($search) {
                          $clienteQuery->where('razon_social', 'LIKE', "%{$search}%")
                                      ->orWhere('numero_documento', 'LIKE', "%{$search}%");
                      })
                      ->orWhereHas('userCliente', function ($userClienteQuery) use ($search) {
                          $userClienteQuery->where('nombres', 'LIKE', "%{$search}%")
                                          ->orWhere('apellidos', 'LIKE', "%{$search}%")
                                          ->orWhere('email', 'LIKE', "%{$search}%");
                      });
                });
            }

            $pedidos = $query->orderBy('fecha_pedido', 'desc')->paginate(20);

            return response()->json($pedidos);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener pedidos',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $pedido = Pedido::with([
                'cliente', 
                'userCliente',
                'detalles.producto', 
                'estadoPedido'
            ])->findOrFail($id);

            return response()->json($pedido);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Pedido no encontrado',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function crearPedidoEcommerce(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'productos' => 'required|array|min:1',
            'productos.*.producto_id' => 'required|exists:productos,id',
            'productos.*.cantidad' => 'required|numeric|min:1',
            'metodo_pago' => 'required|string|max:50',
            'direccion_envio' => 'required|string',
            'telefono_contacto' => 'required|string|max:20',
            'observaciones' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $userCliente = $request->user();
            
            if (!$userCliente instanceof UserCliente) {
                return response()->json(['message' => 'Acceso no autorizado'], 403);
            }

            DB::beginTransaction();

            // Calcular totales
            $subtotal = 0;
            $productosValidados = [];

            foreach ($request->productos as $prod) {
                $producto = Producto::findOrFail($prod['producto_id']);
                
                // Verificar stock
                if ($producto->stock < $prod['cantidad']) {
                    throw new \Exception("Stock insuficiente para el producto: {$producto->nombre}");
                }

                $cantidad = $prod['cantidad'];
                $precioUnitario = $producto->precio_venta;
                $subtotalLinea = $cantidad * $precioUnitario;
                
                $subtotal += $subtotalLinea;

                $productosValidados[] = [
                    'producto' => $producto,
                    'cantidad' => $cantidad,
                    'precio_unitario' => $precioUnitario,
                    'subtotal_linea' => $subtotalLinea
                ];
            }

            $igv = $subtotal * 0.18;
            $total = $subtotal + $igv;

            // Crear pedido
            $pedido = Pedido::create([
                'codigo_pedido' => 'PED-' . date('Ymd') . '-' . str_pad(Pedido::count() + 1, 4, '0', STR_PAD_LEFT),
                'cliente_id' => null, // Para e-commerce usamos user_cliente_id
                'user_cliente_id' => $userCliente->id,
                'fecha_pedido' => now(),
                'subtotal' => $subtotal,
                'igv' => $igv,
                'descuento_total' => 0,
                'total' => $total,
                'estado_pedido_id' => 1, // Estado inicial "Pendiente"
                'metodo_pago' => $request->metodo_pago,
                'direccion_envio' => $request->direccion_envio,
                'telefono_contacto' => $request->telefono_contacto,
                'observaciones' => $request->observaciones,
                'user_id' => 1 // ID del sistema para pedidos de e-commerce
            ]);

            // Crear detalles y actualizar stock
            foreach ($productosValidados as $prod) {
                PedidoDetalle::create([
                    'pedido_id' => $pedido->id,
                    'producto_id' => $prod['producto']->id,
                    'codigo_producto' => $prod['producto']->codigo_producto,
                    'nombre_producto' => $prod['producto']->nombre,
                    'cantidad' => $prod['cantidad'],
                    'precio_unitario' => $prod['precio_unitario'],
                    'subtotal_linea' => $prod['subtotal_linea']
                ]);

                // Actualizar stock
                $prod['producto']->decrement('stock', $prod['cantidad']);
            }

            DB::commit();

            return response()->json([
                'message' => 'Pedido creado exitosamente',
                'pedido' => $pedido->load(['detalles', 'estadoPedido']),
                'codigo_pedido' => $pedido->codigo_pedido
            ], 201);

        } catch (\Exception $e) {
            DB::rollback();
            return response()->json([
                'message' => 'Error al crear pedido',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function actualizarEstado(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'estado_pedido_id' => 'required|exists:estados_pedido,id'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $pedido = Pedido::findOrFail($id);
            $pedido->update([
                'estado_pedido_id' => $request->estado_pedido_id
            ]);

            return response()->json([
                'message' => 'Estado del pedido actualizado correctamente',
                'pedido' => $pedido->load('estadoPedido')
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al actualizar estado del pedido',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getEstados()
    {
        try {
            $estados = EstadoPedido::all();
            return response()->json($estados);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener estados',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function estadisticas(Request $request)
    {
        try {
            $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->format('Y-m-d');
            $fechaFin = $request->fecha_fin ?? now()->format('Y-m-d');

            $pendientes = Pedido::where('estado_pedido_id', 1)->count();
            $preparacion = Pedido::where('estado_pedido_id', 3)->count();
            $enviados = Pedido::where('estado_pedido_id', 4)->count();
            $entregados = Pedido::where('estado_pedido_id', 5)->count();

            return response()->json([
                'pendientes' => $pendientes,
                'preparacion' => $preparacion,
                'enviados' => $enviados,
                'entregados' => $entregados,
                'periodo' => ['inicio' => $fechaInicio, 'fin' => $fechaFin]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function misPedidos(Request $request)
    {
        try {
            $userCliente = $request->user();
            
            if (!$userCliente instanceof UserCliente) {
                return response()->json(['message' => 'Acceso no autorizado'], 403);
            }

            $pedidos = Pedido::with(['detalles.producto', 'estadoPedido'])
                          ->where('user_cliente_id', $userCliente->id)
                          ->orderBy('fecha_pedido', 'desc')
                          ->paginate(10);

            return response()->json($pedidos);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener pedidos',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $pedido = Pedido::findOrFail($id);
            
            // Restaurar stock antes de eliminar
            foreach ($pedido->detalles as $detalle) {
                $detalle->producto->increment('stock', $detalle->cantidad);
            }
            
            $pedido->delete();

            return response()->json([
                'message' => 'Pedido eliminado correctamente'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al eliminar pedido',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}