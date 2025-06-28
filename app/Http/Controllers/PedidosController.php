<?php

namespace App\Http\Controllers;

use App\Models\Pedido;
use App\Models\EstadoPedido;
use App\Models\MetodoPago;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PedidosController extends Controller
{
    

    public function index(Request $request)
    {
        try {
            $query = Pedido::with([
                'cliente.tipoDocumento',
                'direccion',
                'estadoPedido',
                'metodoPago',
                'tienda'
            ])->orderBy('created_at', 'desc');

            // Filtros
            if ($request->has('cliente') && $request->cliente !== '') {
                $query->whereHas('cliente', function($q) use ($request) {
                    $q->where('nombres', 'like', '%' . $request->cliente . '%')
                      ->orWhere('apellidos', 'like', '%' . $request->cliente . '%')
                      ->orWhere('numero_documento', 'like', '%' . $request->cliente . '%');
                });
            }

            if ($request->has('estado') && $request->estado !== '') {
                $query->where('estado_pedido_id', $request->estado);
            }

            if ($request->has('tienda') && $request->tienda !== '') {
                $query->where('tienda_id', $request->tienda);
            }

            if ($request->has('fecha_desde') && $request->fecha_desde !== '') {
                $query->whereDate('created_at', '>=', $request->fecha_desde);
            }

            if ($request->has('fecha_hasta') && $request->fecha_hasta !== '') {
                $query->whereDate('created_at', '<=', $request->fecha_hasta);
            }

            $pedidos = $query->paginate(15);

            // Transformar datos para el frontend
            $pedidos->getCollection()->transform(function ($pedido) {
                return [
                    'id' => $pedido->id,
                    'codigo_pedido' => $pedido->codigo_pedido,
                    'cliente' => [
                        'nombre_completo' => $pedido->cliente->nombres . ' ' . $pedido->cliente->apellidos,
                        'tipo_documento' => $pedido->cliente->tipoDocumento->nombre ?? '',
                        'numero_documento' => $pedido->cliente->numero_documento
                    ],
                    'fecha' => $pedido->created_at->format('Y-m-d'),
                    'total' => $pedido->total,
                    'estado' => [
                        'id' => $pedido->estadoPedido->id,
                        'nombre' => $pedido->estadoPedido->nombre_estado
                    ],
                    'metodo_pago' => $pedido->metodoPago->nombre ?? '',
                    'tienda' => $pedido->tienda->nombre ?? '',
                    'moneda' => $pedido->moneda ?? 'S/.'
                ];
            });

            return response()->json([
                'pedidos' => $pedidos->items(),
                'pagination' => [
                    'current_page' => $pedidos->currentPage(),
                    'last_page' => $pedidos->lastPage(),
                    'per_page' => $pedidos->perPage(),
                    'total' => $pedidos->total()
                ]
            ]);

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
                'cliente.tipoDocumento',
                'direccion',
                'estadoPedido',
                'metodoPago',
                'tienda',
                'detalles.producto'
            ])->findOrFail($id);

            $pedidoDetalle = [
                'id' => $pedido->id,
                'codigo_pedido' => $pedido->codigo_pedido,
                'cliente' => [
                    'nombre_completo' => $pedido->cliente->nombres . ' ' . $pedido->cliente->apellidos,
                    'tipo_documento' => $pedido->cliente->tipoDocumento->nombre ?? '',
                    'numero_documento' => $pedido->cliente->numero_documento
                ],
                'fecha' => $pedido->created_at->format('Y-m-d'),
                'estado' => [
                    'id' => $pedido->estadoPedido->id,
                    'nombre' => $pedido->estadoPedido->nombre_estado
                ],
                'metodo_pago' => $pedido->metodoPago->nombre ?? '',
                'direccion' => $pedido->direccion->direccion_completa ?? '',
                'tienda' => $pedido->tienda->nombre ?? '',
                'subtotal' => $pedido->subtotal,
                'igv' => $pedido->igv,
                'descuento_total' => $pedido->descuento_total,
                'total' => $pedido->total,
                'moneda' => $pedido->moneda ?? 'S/.',
                'observaciones' => $pedido->observaciones,
                'productos' => $pedido->detalles->map(function($detalle) {
                    return [
                        'nombre' => $detalle->producto->nombre ?? 'Producto no encontrado',
                        'cantidad' => $detalle->cantidad,
                        'precio_unitario' => $detalle->precio_unitario,
                        'subtotal' => $detalle->cantidad * $detalle->precio_unitario
                    ];
                })
            ];

            return response()->json($pedidoDetalle);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Pedido no encontrado',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function updateEstado(Request $request, $id)
    {
        $request->validate([
            'estado_pedido_id' => 'required|exists:estados_pedido,id'
        ]);

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
        $estados = EstadoPedido::all();
        return response()->json($estados);
    }

    public function getMetodosPago()
    {
        $metodos = MetodoPago::where('activo', true)->get();
        return response()->json($metodos);
    }

    public function destroy($id)
    {
        try {
            $pedido = Pedido::findOrFail($id);
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
