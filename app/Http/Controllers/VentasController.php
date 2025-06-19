<?php

namespace App\Http\Controllers;

use App\Models\Venta;
use App\Models\VentaDetalle;
use App\Models\Cliente;
use App\Models\UserCliente;
use App\Models\Producto;
use App\Services\GreenterService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class VentasController extends Controller
{
    protected $greenterService;

    public function __construct(GreenterService $greenterService)
    {
        $this->greenterService = $greenterService;
    }

    public function index(Request $request)
    {
        try {
            $query = Venta::with(['cliente', 'userCliente', 'comprobante', 'user']);

            // Filtros
            if ($request->has('estado')) {
                $query->where('estado', $request->estado);
            }

            if ($request->has('cliente_id')) {
                $query->where('cliente_id', $request->cliente_id);
            }

            if ($request->has('user_cliente_id')) {
                $query->where('user_cliente_id', $request->user_cliente_id);
            }

            if ($request->has('fecha_inicio') && $request->has('fecha_fin')) {
                $query->whereBetween('fecha_venta', [$request->fecha_inicio, $request->fecha_fin]);
            }

            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('codigo_venta', 'LIKE', "%{$search}%")
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

            $ventas = $query->orderBy('fecha_venta', 'desc')->paginate(20);

            return response()->json($ventas);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener ventas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'cliente_id' => 'nullable|exists:clientes,id',
            'user_cliente_id' => 'nullable|exists:user_clientes,id',
            'productos' => 'required|array|min:1',
            'productos.*.producto_id' => 'required|exists:productos,id',
            'productos.*.cantidad' => 'required|numeric|min:0.01',
            'productos.*.precio_unitario' => 'required|numeric|min:0',
            'productos.*.descuento_unitario' => 'nullable|numeric|min:0',
            'descuento_total' => 'nullable|numeric|min:0',
            'requiere_factura' => 'boolean',
            'metodo_pago' => 'nullable|string|max:50',
            'observaciones' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        // Validar que se proporcione al menos un tipo de cliente
        if (!$request->cliente_id && !$request->user_cliente_id) {
            return response()->json([
                'message' => 'Debe especificar un cliente_id o user_cliente_id',
                'errors' => ['cliente' => ['Debe especificar un cliente']]
            ], 422);
        }

        DB::beginTransaction();
        try {
            // Obtener cliente si se proporciona
            $cliente = null;
            $userCliente = null;

            if ($request->cliente_id) {
                $cliente = Cliente::findOrFail($request->cliente_id);
            }

            if ($request->user_cliente_id) {
                $userCliente = UserCliente::findOrFail($request->user_cliente_id);
                
                // Si el user_cliente tiene cliente de facturación, usarlo
                if ($userCliente->cliente_facturacion_id && !$cliente) {
                    $cliente = $userCliente->clienteFacturacion;
                }
            }
            
            // Calcular totales
            $subtotal = 0;
            $igvTotal = 0;

            $productosVenta = [];
            foreach ($request->productos as $prod) {
                $producto = Producto::findOrFail($prod['producto_id']);
                
                // Verificar stock
                if ($producto->stock < $prod['cantidad']) {
                    throw new \Exception("Stock insuficiente para el producto: {$producto->nombre}");
                }

                $cantidad = $prod['cantidad'];
                $precioUnitario = $prod['precio_unitario'];
                $descuentoUnitario = $prod['descuento_unitario'] ?? 0;
                
                $precioSinIgv = $precioUnitario / 1.18;
                $subtotalLinea = ($cantidad * $precioSinIgv) - ($descuentoUnitario * $cantidad);
                $igvLinea = $subtotalLinea * 0.18;
                $totalLinea = $subtotalLinea + $igvLinea;

                $subtotal += $subtotalLinea;
                $igvTotal += $igvLinea;

                $productosVenta[] = [
                    'producto' => $producto,
                    'cantidad' => $cantidad,
                    'precio_unitario' => $precioUnitario,
                    'precio_sin_igv' => $precioSinIgv,
                    'descuento_unitario' => $descuentoUnitario,
                    'subtotal_linea' => $subtotalLinea,
                    'igv_linea' => $igvLinea,
                    'total_linea' => $totalLinea
                ];
            }

            $descuentoTotal = $request->descuento_total ?? 0;
            $total = $subtotal + $igvTotal - $descuentoTotal;

            // Crear venta
            $venta = Venta::create([
                'cliente_id' => $cliente?->id,
                'user_cliente_id' => $userCliente?->id,
                'fecha_venta' => now(),
                'subtotal' => $subtotal,
                'igv' => $igvTotal,
                'descuento_total' => $descuentoTotal,
                'total' => $total,
                'estado' => 'PENDIENTE',
                'requiere_factura' => $request->requiere_factura ?? false,
                'metodo_pago' => $request->metodo_pago,
                'observaciones' => $request->observaciones,
                'user_id' => auth()->id()
            ]);

            // Crear detalles y actualizar stock
            foreach ($productosVenta as $prod) {
                VentaDetalle::create([
                    'venta_id' => $venta->id,
                    'producto_id' => $prod['producto']->id,
                    'codigo_producto' => $prod['producto']->codigo_producto,
                    'nombre_producto' => $prod['producto']->nombre,
                    'descripcion_producto' => $prod['producto']->descripcion,
                    'cantidad' => $prod['cantidad'],
                    'precio_unitario' => $prod['precio_unitario'],
                    'precio_sin_igv' => $prod['precio_sin_igv'],
                    'descuento_unitario' => $prod['descuento_unitario'],
                    'subtotal_linea' => $prod['subtotal_linea'],
                    'igv_linea' => $prod['igv_linea'],
                    'total_linea' => $prod['total_linea']
                ]);

                // Actualizar stock
                $prod['producto']->decrement('stock', $prod['cantidad']);
            }

            DB::commit();

            return response()->json([
                'message' => 'Venta registrada exitosamente',
                'venta' => $venta->load(['cliente', 'userCliente', 'detalles'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollback();
            return response()->json([
                'message' => 'Error al registrar venta',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $venta = Venta::with([
                'cliente', 
                'userCliente',
                'detalles.producto', 
                'comprobante', 
                'user'
            ])->findOrFail($id);

            return response()->json($venta);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Venta no encontrada',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function facturar(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'cliente_datos.tipo_documento' => 'sometimes|required|in:1,4,6,7,0',
            'cliente_datos.numero_documento' => 'sometimes|required|string|max:20',
            'cliente_datos.razon_social' => 'sometimes|required|string|max:255',
            'cliente_datos.direccion' => 'sometimes|required|string',
            'cliente_datos.email' => 'sometimes|nullable|email',
            'cliente_datos.telefono' => 'sometimes|nullable|string|max:20'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $venta = Venta::findOrFail($id);

            if (!$venta->puedeFacturar()) {
                return response()->json([
                    'message' => 'La venta no puede ser facturada'
                ], 400);
            }

            $clienteData = $request->has('cliente_datos') ? $request->cliente_datos : null;
            $resultado = $this->greenterService->generarFactura($id, $clienteData);

            if ($resultado['success']) {
                return response()->json([
                    'message' => $resultado['mensaje'],
                    'comprobante' => $resultado['comprobante']
                ]);
            } else {
                return response()->json([
                    'message' => 'Error al generar comprobante',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al facturar venta',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function anular($id)
    {
        try {
            $venta = Venta::findOrFail($id);

            if (!$venta->puedeAnular()) {
                return response()->json([
                    'message' => 'La venta no puede ser anulada'
                ], 400);
            }

            DB::beginTransaction();

            // Restaurar stock
            foreach ($venta->detalles as $detalle) {
                $detalle->producto->increment('stock', $detalle->cantidad);
            }

            $venta->update(['estado' => 'ANULADO']);

            DB::commit();

            return response()->json([
                'message' => 'Venta anulada exitosamente',
                'venta' => $venta->fresh()
            ]);

        } catch (\Exception $e) {
            DB::rollback();
            return response()->json([
                'message' => 'Error al anular venta',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function estadisticas(Request $request)
    {
        try {
            $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->format('Y-m-d');
            $fechaFin = $request->fecha_fin ?? now()->format('Y-m-d');

            $totalVentas = Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])->count();
            $montoTotal = Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])->sum('total');
            $ventasPendientes = Venta::where('estado', 'PENDIENTE')->count();
            $ventasFacturadas = Venta::where('estado', 'FACTURADO')->count();
            $ventasEcommerce = Venta::whereNotNull('user_cliente_id')->count();

            return response()->json([
                'total_ventas' => $totalVentas,
                'monto_total' => $montoTotal,
                'ventas_pendientes' => $ventasPendientes,
                'ventas_facturadas' => $ventasFacturadas,
                'ventas_ecommerce' => $ventasEcommerce,
                'periodo' => ['inicio' => $fechaInicio, 'fin' => $fechaFin]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener ventas del cliente autenticado (para e-commerce)
     */
    public function misVentas(Request $request)
    {
        try {
            $userCliente = $request->user();
            
            if (!$userCliente instanceof UserCliente) {
                return response()->json(['message' => 'Acceso no autorizado'], 403);
            }

            $ventas = Venta::with(['detalles.producto', 'comprobante'])
                          ->where('user_cliente_id', $userCliente->id)
                          ->orderBy('fecha_venta', 'desc')
                          ->paginate(10);

            return response()->json($ventas);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener ventas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear venta desde el e-commerce (carrito de compras)
     */
    public function crearVentaEcommerce(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'productos' => 'required|array|min:1',
            'productos.*.producto_id' => 'required|exists:productos,id',
            'productos.*.cantidad' => 'required|numeric|min:1',
            'metodo_pago' => 'required|string|max:50',
            'requiere_factura' => 'boolean',
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

            // Preparar datos para crear venta
            $productosConPrecios = [];
            foreach ($request->productos as $prod) {
                $producto = Producto::findOrFail($prod['producto_id']);
                $productosConPrecios[] = [
                    'producto_id' => $producto->id,
                    'cantidad' => $prod['cantidad'],
                    'precio_unitario' => $producto->precio_venta,
                    'descuento_unitario' => 0
                ];
            }

            // Crear venta usando el método store existente
            $ventaRequest = new Request([
                'user_cliente_id' => $userCliente->id,
                'productos' => $productosConPrecios,
                'requiere_factura' => $request->requiere_factura ?? false,
                'metodo_pago' => $request->metodo_pago,
                'observaciones' => $request->observaciones
            ]);

            return $this->store($ventaRequest);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al crear venta desde e-commerce',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}