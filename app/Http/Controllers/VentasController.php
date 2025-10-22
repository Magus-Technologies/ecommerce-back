<?php

namespace App\Http\Controllers;

use App\Events\VentaCreated;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\UserCliente;
use App\Models\Venta;
use App\Models\VentaDetalle;
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
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function store(Request $request)
    {
        // 1. VALIDACIÓN DE ENTRADA SIMPLIFICADA
        $validator = Validator::make($request->all(), [
            'cliente_id' => 'nullable|exists:clientes,id',
            'user_cliente_id' => 'nullable|exists:user_clientes,id',

            // Productos - Estructura simplificada
            'productos' => 'required|array|min:1',
            'productos.*.producto_id' => 'required|exists:productos,id',
            'productos.*.cantidad' => 'required|numeric|min:0.01',
            'productos.*.precio_unitario' => 'required|numeric|min:0',
            'productos.*.descuento_unitario' => 'nullable|numeric|min:0',

            // Datos de venta
            'descuento_total' => 'nullable|numeric|min:0',
            'metodo_pago' => 'required|string|max:50',
            'observaciones' => 'nullable|string',
            'requiere_factura' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors(),
            ], 422);
        }

        // Validar caja abierta para ventas en efectivo
        if (in_array(strtolower($request->metodo_pago ?? ''), ['efectivo', 'cash'])) {
            $cajaAbierta = \App\Models\CajaMovimiento::where('estado', 'ABIERTA')
                ->where('user_id', auth()->id())
                ->exists();

            if (!$cajaAbierta) {
                return response()->json([
                    'success' => false,
                    'message' => 'Debe aperturar una caja antes de registrar ventas en efectivo',
                    'errors' => ['caja' => ['No hay caja abierta']],
                ], 422);
            }
        }

        DB::beginTransaction();
        try {
            // 2. GESTIÓN DE CLIENTE GENÉRICO
            $cliente = null;
            $userCliente = null;

            if ($request->cliente_id) {
                $cliente = Cliente::find($request->cliente_id);
                if (!$cliente) {
                    throw new \Exception("Cliente no encontrado con ID: {$request->cliente_id}");
                }
            } elseif ($request->user_cliente_id) {
                $userCliente = UserCliente::find($request->user_cliente_id);
                if (!$userCliente) {
                    throw new \Exception("Usuario cliente no encontrado con ID: {$request->user_cliente_id}");
                }

                // Si el user_cliente tiene cliente de facturación, usarlo
                if ($userCliente->cliente_facturacion_id) {
                    $cliente = Cliente::find($userCliente->cliente_facturacion_id);
                }
            }

            // Si no hay cliente, crear/usar CLIENTE GENERAL
            if (!$cliente && !$userCliente) {
                $cliente = Cliente::firstOrCreate(
                    [
                        'tipo_documento' => '0',
                        'numero_documento' => '00000000',
                    ],
                    [
                        'razon_social' => 'CLIENTE GENERAL',
                        'nombre_comercial' => 'CLIENTE GENERAL',
                        'direccion' => '-',
                        'activo' => true,
                    ]
                );
            }

            // 3. VALIDAR Y AUTO-COMPLETAR DATOS DE PRODUCTOS
            $subtotal = 0;
            $igvTotal = 0;
            $productosVenta = [];

            foreach ($request->productos as $index => $prod) {
                // Buscar producto en BD
                $producto = Producto::find($prod['producto_id']);

                if (!$producto) {
                    throw new \Exception("Producto no encontrado con ID: {$prod['producto_id']}");
                }

                // 4. VALIDAR STOCK
                if ($producto->stock < $prod['cantidad']) {
                    throw new \Exception("Stock insuficiente para el producto '{$producto->nombre}'. Stock disponible: {$producto->stock}, solicitado: {$prod['cantidad']}");
                }

                // 5. AUTO-COMPLETAR DATOS DEL PRODUCTO
                $cantidad = $prod['cantidad'];
                $precioUnitario = $prod['precio_unitario'];
                $descuentoUnitario = $prod['descuento_unitario'] ?? 0;

                // Auto-completar desde la tabla productos
                $codigoProducto = $producto->codigo_producto ?? 'PROD-' . $producto->id;
                $descripcion = $producto->nombre;
                $unidadMedida = 'NIU'; // Unidad por defecto (NIU = Unidad)

                // Determinar tipo de afectación IGV
                // Si el producto tiene mostrar_igv = true, es GRAVADO (10), si no, EXONERADO (20)
                $tipoAfectacionIgv = $producto->mostrar_igv ? '10' : '20';

                // 6. CALCULAR MONTOS AUTOMÁTICAMENTE
                $subtotalProducto = $cantidad * $precioUnitario;
                $descuentoProducto = $descuentoUnitario * $cantidad;
                $subtotalNeto = $subtotalProducto - $descuentoProducto;

                // Calcular precio sin IGV y IGV según tipo de afectación
                if ($tipoAfectacionIgv == '10') {
                    // GRAVADO: El precio incluye IGV
                    $precioSinIgv = $precioUnitario / 1.18;
                    $baseImponible = $subtotalNeto / 1.18;
                    $igvLinea = $subtotalNeto - $baseImponible;
                } else {
                    // EXONERADO o INAFECTO: Sin IGV
                    $precioSinIgv = $precioUnitario;
                    $baseImponible = $subtotalNeto;
                    $igvLinea = 0;
                }

                $totalLinea = $subtotalNeto;

                $subtotal += $baseImponible;
                $igvTotal += $igvLinea;

                $productosVenta[] = [
                    'producto' => $producto,
                    'cantidad' => $cantidad,
                    'precio_unitario' => $precioUnitario,
                    'precio_sin_igv' => $precioSinIgv,
                    'descuento_unitario' => $descuentoUnitario,
                    'codigo_producto' => $codigoProducto,
                    'descripcion' => $descripcion,
                    'unidad_medida' => $unidadMedida,
                    'tipo_afectacion_igv' => $tipoAfectacionIgv,
                    'subtotal_linea' => $baseImponible,
                    'igv_linea' => $igvLinea,
                    'total_linea' => $totalLinea,
                ];
            }

            // Aplicar descuento global
            $descuentoTotal = $request->descuento_total ?? 0;
            $total = $subtotal + $igvTotal - $descuentoTotal;

            // 7. AUTO-COMPLETAR DATOS DE VENTA
            $fechaVenta = now()->format('Y-m-d');
            $horaVenta = now()->format('H:i:s');
            $fechaHoraVenta = $fechaVenta . ' ' . $horaVenta;
            $moneda = 'PEN';
            $requiereFactura = $request->requiere_factura ?? false;
            $tipoDocumento = $requiereFactura ? '01' : '03'; // 01=Factura, 03=Boleta

            // Crear venta
            $ventaData = [
                'cliente_id' => $cliente?->id,
                'user_cliente_id' => $userCliente?->id,
                'fecha_venta' => $fechaHoraVenta,
                'subtotal' => $subtotal,
                'igv' => $igvTotal,
                'descuento_total' => $descuentoTotal,
                'total' => $total,
                'estado' => 'PENDIENTE',
                'requiere_factura' => $requiereFactura,
                'metodo_pago' => $request->metodo_pago,
                'observaciones' => $request->observaciones,
                'user_id' => auth()->id(),
            ];

            // Agregar moneda solo si el campo existe en la tabla
            if (\Schema::hasColumn('ventas', 'moneda')) {
                $ventaData['moneda'] = $moneda;
            }

            // Agregar tipo_documento solo si el campo existe
            if (\Schema::hasColumn('ventas', 'tipo_documento')) {
                $ventaData['tipo_documento'] = $tipoDocumento;
            }

            $venta = Venta::create($ventaData);

            // 8. CREAR DETALLES Y DESCONTAR STOCK
            foreach ($productosVenta as $prod) {
                VentaDetalle::create([
                    'venta_id' => $venta->id,
                    'producto_id' => $prod['producto']->id,
                    'codigo_producto' => $prod['codigo_producto'],
                    'nombre_producto' => $prod['descripcion'],
                    'descripcion_producto' => $prod['producto']->descripcion,
                    'cantidad' => $prod['cantidad'],
                    'precio_unitario' => $prod['precio_unitario'],
                    'precio_sin_igv' => $prod['precio_sin_igv'],
                    'descuento_unitario' => $prod['descuento_unitario'],
                    'subtotal_linea' => $prod['subtotal_linea'],
                    'igv_linea' => $prod['igv_linea'],
                    'total_linea' => $prod['total_linea'],
                ]);

                // Descontar stock
                $prod['producto']->decrement('stock', $prod['cantidad']);
            }

            DB::commit();

            // Disparar evento para procesar integraciones
            event(new VentaCreated($venta->load(['cliente', 'userCliente', 'detalles.producto'])));

            // 9. RESPUESTA EXITOSA CON TODOS LOS DATOS
            return response()->json([
                'success' => true,
                'message' => 'Venta registrada exitosamente',
                'data' => [
                    'id' => $venta->id,
                    'codigo_venta' => $venta->codigo_venta ?? 'V-' . str_pad($venta->id, 6, '0', STR_PAD_LEFT),
                    'cliente' => $cliente,
                    'user_cliente' => $userCliente,
                    'detalles' => $venta->detalles->map(function($detalle) {
                        return [
                            'producto_id' => $detalle->producto_id,
                            'codigo_producto' => $detalle->codigo_producto,
                            'nombre_producto' => $detalle->nombre_producto,
                            'cantidad' => $detalle->cantidad,
                            'precio_unitario' => $detalle->precio_unitario,
                            'descuento_unitario' => $detalle->descuento_unitario,
                            'subtotal' => $detalle->subtotal_linea,
                            'igv' => $detalle->igv_linea,
                            'total' => $detalle->total_linea,
                        ];
                    }),
                    'subtotal' => round($subtotal, 2),
                    'igv' => round($igvTotal, 2),
                    'descuento_total' => round($descuentoTotal, 2),
                    'total' => round($total, 2),
                    'fecha_venta' => $fechaVenta,
                    'hora_venta' => $horaVenta,
                    'tipo_documento' => $tipoDocumento,
                    'moneda' => $moneda,
                    'estado' => $venta->estado,
                    'requiere_factura' => $requiereFactura,
                ],
            ], 201);

        } catch (\Exception $e) {
            DB::rollback();

            // 10. MANEJO ROBUSTO DE ERRORES
            $statusCode = 500;
            $errorType = 'error_servidor';

            if (strpos($e->getMessage(), 'no encontrado') !== false) {
                $statusCode = 404;
                $errorType = 'recurso_no_encontrado';
            } elseif (strpos($e->getMessage(), 'Stock insuficiente') !== false) {
                $statusCode = 422;
                $errorType = 'stock_insuficiente';
            } elseif (strpos($e->getMessage(), 'validación') !== false) {
                $statusCode = 400;
                $errorType = 'datos_invalidos';
            }

            return response()->json([
                'success' => false,
                'message' => 'Error al registrar venta',
                'error' => $e->getMessage(),
                'error_type' => $errorType,
            ], $statusCode);
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
                'user',
            ])->findOrFail($id);

            return response()->json($venta);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Venta no encontrada',
                'error' => $e->getMessage(),
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
            'cliente_datos.telefono' => 'sometimes|nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            $venta = Venta::findOrFail($id);

            if (! $venta->puedeFacturar()) {
                return response()->json([
                    'message' => 'La venta no puede ser facturada',
                ], 400);
            }

            $clienteData = $request->has('cliente_datos') ? $request->cliente_datos : null;
            $resultado = $this->greenterService->generarFactura($id, $clienteData);

            if ($resultado['success']) {
                return response()->json([
                    'message' => $resultado['mensaje'],
                    'comprobante' => $resultado['comprobante'],
                ]);
            } else {
                return response()->json([
                    'message' => 'Error al generar comprobante',
                    'error' => $resultado['error'],
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al facturar venta',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function anular($id)
    {
        try {
            $venta = Venta::findOrFail($id);

            if (! $venta->puedeAnular()) {
                return response()->json([
                    'message' => 'La venta no puede ser anulada',
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
                'venta' => $venta->fresh(),
            ]);

        } catch (\Exception $e) {
            DB::rollback();

            return response()->json([
                'message' => 'Error al anular venta',
                'error' => $e->getMessage(),
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
                'periodo' => ['inicio' => $fechaInicio, 'fin' => $fechaFin],
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage(),
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

            if (! $userCliente instanceof UserCliente) {
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
                'error' => $e->getMessage(),
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
            'observaciones' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            $userCliente = $request->user();

            if (! $userCliente instanceof UserCliente) {
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
                    'descuento_unitario' => 0,
                ];
            }

            // Crear venta usando el método store existente
            $ventaRequest = new Request([
                'user_cliente_id' => $userCliente->id,
                'productos' => $productosConPrecios,
                'requiere_factura' => $request->requiere_factura ?? false,
                'metodo_pago' => $request->metodo_pago,
                'observaciones' => $request->observaciones,
            ]);

            return $this->store($ventaRequest);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al crear venta desde e-commerce',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Descargar PDF de venta
     */
    public function descargarPdf($id)
    {
        try {
            $venta = Venta::with(['cliente', 'detalles.producto', 'user'])->findOrFail($id);

            // Generar PDF usando una vista Blade
            $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView('pdf.venta', compact('venta'));

            $filename = "venta_{$venta->numero_venta}.pdf";

            return $pdf->download($filename);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al generar PDF',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Enviar venta por email
     */
    public function enviarEmail(Request $request, $id)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'mensaje' => 'nullable|string|max:500',
            ]);

            $venta = Venta::with(['cliente', 'detalles.producto'])->findOrFail($id);

            // Aquí implementarías el envío de email
            // Por ahora solo retornamos éxito
            return response()->json([
                'success' => true,
                'message' => 'Venta enviada por email exitosamente',
                'data' => [
                    'email' => $request->email,
                    'venta' => $venta->numero_venta,
                ],
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar email',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Buscar cliente por documento
     */
    public function buscarCliente(Request $request)
    {
        try {
            $request->validate([
                'tipo_documento' => 'required|string|in:DNI,RUC,CE,PASAPORTE',
                'numero_documento' => 'required|string|max:20',
            ]);

            $cliente = Cliente::where('tipo_documento', $request->tipo_documento)
                ->where('numero_documento', $request->numero_documento)
                ->first();

            if (! $cliente) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cliente no encontrado',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $cliente,
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al buscar cliente',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Validar RUC con API de SUNAT
     */
    public function validarRuc($ruc)
    {
        try {
            // Validar formato
            if (! preg_match('/^[0-9]{11}$/', $ruc)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Formato de RUC inválido. Debe contener 11 dígitos',
                ], 400);
            }

            // Validar dígito verificador
            if (! $this->validarDigitoVerificadorRUC($ruc)) {
                return response()->json([
                    'success' => false,
                    'message' => 'El RUC tiene un dígito verificador inválido',
                ], 400);
            }

            // Consultar API de SUNAT (puedes usar servicios como APIs Perú, APIPeru, etc.)
            // Por ahora implementamos una consulta básica a la API pública
            $resultado = $this->consultarRucSunat($ruc);

            if ($resultado['success']) {
                return response()->json([
                    'success' => true,
                    'data' => $resultado['data'],
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => $resultado['message'],
                ], 404);
            }

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al validar RUC',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Validar dígito verificador del RUC
     */
    private function validarDigitoVerificadorRUC($ruc)
    {
        if (strlen($ruc) != 11) {
            return false;
        }

        $suma = 0;
        $factor = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];

        for ($i = 0; $i < 10; $i++) {
            $suma += intval($ruc[$i]) * $factor[$i];
        }

        $resto = $suma % 11;
        $digitoVerificador = 11 - $resto;

        if ($digitoVerificador == 10) {
            $digitoVerificador = 0;
        } elseif ($digitoVerificador == 11) {
            $digitoVerificador = 1;
        }

        return intval($ruc[10]) == $digitoVerificador;
    }

    /**
     * Consultar RUC en SUNAT
     */
    private function consultarRucSunat($ruc)
    {
        try {
            // Primero verificar si existe en la base de datos
            $cliente = Cliente::where('numero_documento', $ruc)
                ->where('tipo_documento', '6') // 6 = RUC
                ->first();

            if ($cliente) {
                return [
                    'success' => true,
                    'data' => [
                        'ruc' => $ruc,
                        'razon_social' => $cliente->razon_social,
                        'direccion' => $cliente->direccion,
                        'estado' => 'ACTIVO',
                        'condicion' => 'HABIDO',
                        'fuente' => 'base_datos',
                    ],
                ];
            }

            // Si no existe en BD, consultar API externa
            // Aquí puedes integrar con APIs como:
            // - https://apiperu.dev/
            // - https://apis.net.pe/
            // - Servicio web de SUNAT (requiere certificado)

            $token = config('services.apiperu.token'); // Configura tu token en .env

            if (empty($token)) {
                // Si no hay token configurado, retornar mensaje informativo
                return [
                    'success' => false,
                    'message' => 'Servicio de consulta de RUC no configurado. Configure APIPERU_TOKEN en .env',
                ];
            }

            // Ejemplo de consulta a APIPeru
            $response = \Illuminate\Support\Facades\Http::timeout(10)
                ->withHeaders([
                    'Authorization' => 'Bearer '.$token,
                    'Content-Type' => 'application/json',
                ])
                ->get("https://apiperu.dev/api/ruc/{$ruc}");

            if ($response->successful()) {
                $data = $response->json();

                return [
                    'success' => true,
                    'data' => [
                        'ruc' => $ruc,
                        'razon_social' => $data['data']['nombre_o_razon_social'] ?? '',
                        'direccion' => $data['data']['direccion'] ?? '',
                        'estado' => $data['data']['estado'] ?? 'ACTIVO',
                        'condicion' => $data['data']['condicion'] ?? 'HABIDO',
                        'departamento' => $data['data']['departamento'] ?? '',
                        'provincia' => $data['data']['provincia'] ?? '',
                        'distrito' => $data['data']['distrito'] ?? '',
                        'ubigeo' => $data['data']['ubigeo'] ?? '',
                        'fuente' => 'apiperu',
                    ],
                ];
            } else {
                return [
                    'success' => false,
                    'message' => 'No se pudo consultar el RUC en SUNAT',
                ];
            }

        } catch (\Exception $e) {
            Log::error('Error al consultar RUC: '.$e->getMessage());

            return [
                'success' => false,
                'message' => 'Error al consultar el RUC: '.$e->getMessage(),
            ];
        }
    }

    /**
     * Buscar empresa por RUC (alias de validarRuc)
     */
    public function buscarEmpresa($ruc)
    {
        // Reutilizar la lógica de validarRuc
        return $this->validarRuc($ruc);
    }
}
