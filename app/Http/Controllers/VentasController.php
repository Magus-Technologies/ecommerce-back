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

            // Filtros básicos
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

            // Filtros nuevos
            if ($request->has('metodo_pago')) {
                $query->where('metodo_pago', $request->metodo_pago);
            }

            if ($request->has('tiene_comprobante')) {
                if ($request->tiene_comprobante === 'true' || $request->tiene_comprobante === '1') {
                    $query->whereHas('comprobante');
                } else {
                    $query->whereDoesntHave('comprobante');
                }
            }

            if ($request->has('estado_sunat')) {
                $query->whereHas('comprobante', function($q) use ($request) {
                    $q->where('estado', $request->estado_sunat);
                });
            }

            if ($request->has('origen')) {
                $query->whereHas('comprobante', function($q) use ($request) {
                    $q->where('origen', $request->origen);
                });
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
                        })
                        ->orWhereHas('comprobante', function ($comprobanteQuery) use ($search) {
                            $comprobanteQuery->where('numero_completo', 'LIKE', "%{$search}%");
                        });
                });
            }

            $ventas = $query->orderBy('fecha_venta', 'desc')->paginate(20);

            // Enriquecer respuesta con información del comprobante
            $ventas->getCollection()->transform(function ($venta) {
                $ventaArray = $venta->toArray();

                // Agregar información del cliente (con validaciones seguras)
                $numeroDocumento = '00000000';
                $nombreCompleto = 'CLIENTE GENERAL';

                if ($venta->cliente) {
                    $numeroDocumento = $venta->cliente->numero_documento ?? '00000000';
                    $nombreCompleto = $venta->cliente->razon_social ?? $venta->cliente->nombre_comercial ?? 'CLIENTE GENERAL';
                } elseif ($venta->userCliente) {
                    $numeroDocumento = $venta->userCliente->numero_documento ?? '00000000';
                    $nombres = $venta->userCliente->nombres ?? '';
                    $apellidos = $venta->userCliente->apellidos ?? '';
                    $nombreCompleto = trim($nombres . ' ' . $apellidos) ?: 'CLIENTE GENERAL';
                }

                $ventaArray['cliente_info'] = [
                    'numero_documento' => $numeroDocumento,
                    'nombre_completo' => $nombreCompleto
                ];

                // Agregar información del comprobante si existe
                if ($venta->comprobante) {
                    $ventaArray['comprobante_info'] = [
                        'id' => $venta->comprobante->id,
                        'tipo_comprobante' => $venta->comprobante->tipo_comprobante ?? '03',
                        'serie' => $venta->comprobante->serie ?? '',
                        'correlativo' => $venta->comprobante->correlativo ?? 0,
                        'numero_completo' => $venta->comprobante->numero_completo ?? 'N/A',
                        'estado' => $venta->comprobante->estado ?? 'PENDIENTE',
                        'estado_sunat' => $venta->comprobante->estado ?? 'PENDIENTE',
                        'origen' => $venta->comprobante->origen ?? 'MANUAL',
                        'fecha_emision' => $venta->comprobante->fecha_emision,
                        'fecha_envio_sunat' => $venta->comprobante->fecha_envio_sunat,
                        'fecha_respuesta_sunat' => $venta->comprobante->fecha_respuesta_sunat,
                        'tiene_xml' => !empty($venta->comprobante->xml_firmado),
                        'tiene_pdf' => !empty($venta->comprobante->pdf_base64),
                        'tiene_cdr' => !empty($venta->comprobante->xml_respuesta_sunat),
                        'tiene_qr' => !empty($venta->comprobante->qr_path),
                        'mensaje_sunat' => $venta->comprobante->mensaje_sunat ?? null,
                        'codigo_error_sunat' => $venta->comprobante->codigo_error_sunat ?? null,
                        'operacion_gravada' => $venta->comprobante->operacion_gravada ?? '0.00',
                        'operacion_exonerada' => $venta->comprobante->operacion_exonerada ?? '0.00',
                        'total_igv' => $venta->comprobante->total_igv ?? '0.00',
                        'importe_total' => $venta->comprobante->importe_total ?? '0.00',
                    ];
                } else {
                    $ventaArray['comprobante_info'] = null;
                }

                return $ventaArray;
            });

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

            // Datos de cliente no registrado
            'cliente_datos' => 'nullable|array',
            'cliente_datos.tipo_documento' => 'nullable|in:1,4,6,7,0',
            'cliente_datos.numero_documento' => 'nullable|string|max:20',
            'cliente_datos.razon_social' => 'nullable|string|max:255',
            'cliente_datos.nombre_comercial' => 'nullable|string|max:255',
            'cliente_datos.direccion' => 'nullable|string|max:500',
            'cliente_datos.email' => 'nullable|email|max:255',
            'cliente_datos.telefono' => 'nullable|string|max:20',

            // Productos - Estructura simplificada
            'productos' => 'required|array|min:1',
            'productos.*.producto_id' => 'required|exists:productos,id',
            'productos.*.cantidad' => 'required|numeric|min:0.01',
            'productos.*.precio_unitario' => 'required|numeric|min:0',
            'productos.*.descuento_unitario' => 'nullable|numeric|min:0',

            // Datos de venta
            'descuento_total' => 'nullable|numeric|min:0',
            'metodo_pago' => 'nullable|string|max:50',
            'observaciones' => 'nullable|string',
            'requiere_factura' => 'nullable|boolean',

            // Pagos mixtos (opcional)
            'pagos' => 'nullable|array|min:1',
            'pagos.*.metodo_pago' => 'required_with:pagos|string|max:50',
            'pagos.*.monto' => 'required_with:pagos|numeric|min:0.01',
            'pagos.*.referencia' => 'nullable|string|max:100',
            'pagos.*.observaciones' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors(),
            ], 422);
        }

        // Validar que exista al menos un método de pago
        if (!$request->has('pagos') && !$request->has('metodo_pago')) {
            return response()->json([
                'success' => false,
                'message' => 'Debe especificar al menos un método de pago',
                'errors' => ['pagos' => ['El campo pagos o metodo_pago es requerido']],
            ], 422);
        }

        // Validar caja abierta para ventas en efectivo
        $tieneEfectivo = false;
        
        // Verificar si hay efectivo en pago simple
        if ($request->has('metodo_pago') && in_array(strtolower($request->metodo_pago), ['efectivo', 'cash'])) {
            $tieneEfectivo = true;
        }
        
        // Verificar si hay efectivo en pagos mixtos
        if ($request->has('pagos') && is_array($request->pagos)) {
            foreach ($request->pagos as $pago) {
                if (isset($pago['metodo_pago']) && in_array(strtolower($pago['metodo_pago']), ['efectivo', 'cash'])) {
                    $tieneEfectivo = true;
                    break;
                }
            }
        }
        
        // Si hay efectivo, validar caja abierta
        if ($tieneEfectivo) {
            $cajaAbierta = \App\Models\CajaMovimiento::where('estado', 'ABIERTA')
                ->where('user_id', \Illuminate\Support\Facades\Auth::id() ?? 1)
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
            // 2. GESTIÓN DE CLIENTE
            $cliente = null;
            $userCliente = null;
            
            \Illuminate\Support\Facades\Log::info('Iniciando gestión de cliente', [
                'cliente_id' => $request->cliente_id,
                'user_cliente_id' => $request->user_cliente_id,
                'cliente_datos' => $request->cliente_datos,
                'has_cliente_datos' => $request->has('cliente_datos'),
                'filled_cliente_datos' => $request->filled('cliente_datos')
            ]);

            // CORRECCIÓN: Verificar que cliente_id no sea null o vacío
            if ($request->filled('cliente_id') && $request->cliente_id) {
                // Cliente registrado existente
                $cliente = Cliente::find($request->cliente_id);
                if (!$cliente) {
                    throw new \Exception("Cliente no encontrado con ID: {$request->cliente_id}");
                }
            } elseif ($request->filled('user_cliente_id') && $request->user_cliente_id) {
                // Usuario cliente del e-commerce
                $userCliente = UserCliente::find($request->user_cliente_id);
                if (!$userCliente) {
                    throw new \Exception("Usuario cliente no encontrado con ID: {$request->user_cliente_id}");
                }

                // Si el user_cliente tiene cliente de facturación, usarlo
                if ($userCliente->cliente_facturacion_id) {
                    $cliente = Cliente::find($userCliente->cliente_facturacion_id);
                }
            } elseif ($request->has('cliente_datos') && !empty($request->cliente_datos)) {
                // Cliente no registrado - crear o buscar por documento
                $clienteData = $request->cliente_datos;
                
                if (!empty($clienteData['numero_documento'])) {
                    // Buscar cliente existente por documento
                    $cliente = Cliente::where('numero_documento', $clienteData['numero_documento'])->first();
                    
                    if (!$cliente) {
                        // Crear nuevo cliente
                        $cliente = Cliente::create([
                            'tipo_documento' => $clienteData['tipo_documento'] ?? '0',
                            'numero_documento' => $clienteData['numero_documento'],
                            'razon_social' => $clienteData['razon_social'] ?? 'Cliente',
                            'nombre_comercial' => $clienteData['nombre_comercial'] ?? $clienteData['razon_social'] ?? 'Cliente',
                            'direccion' => $clienteData['direccion'] ?? 'Sin dirección',
                            'email' => $clienteData['email'] ?? null,
                            'telefono' => $clienteData['telefono'] ?? null,
                            'activo' => true
                        ]);
                        
                        \Illuminate\Support\Facades\Log::info('Cliente creado', [
                            'cliente_id' => $cliente->id,
                            'numero_documento' => $cliente->numero_documento,
                            'razon_social' => $cliente->razon_social
                        ]);
                    } else {
                        // Actualizar datos del cliente existente si se proporcionan
                        $updateData = [];
                        if (!empty($clienteData['razon_social'])) $updateData['razon_social'] = $clienteData['razon_social'];
                        if (!empty($clienteData['nombre_comercial'])) $updateData['nombre_comercial'] = $clienteData['nombre_comercial'];
                        if (!empty($clienteData['direccion'])) $updateData['direccion'] = $clienteData['direccion'];
                        if (!empty($clienteData['email'])) $updateData['email'] = $clienteData['email'];
                        if (!empty($clienteData['telefono'])) $updateData['telefono'] = $clienteData['telefono'];
                        
                        if (!empty($updateData)) {
                            $cliente->update($updateData);
                        }
                    }
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

            // 6.5. VALIDAR PAGOS MIXTOS
            $pagosMixtos = [];
            $metodoPagoSimple = null;

            if ($request->has('pagos') && is_array($request->pagos) && count($request->pagos) > 0) {
                // Modo pagos mixtos
                $sumaPagos = 0;
                foreach ($request->pagos as $pago) {
                    $sumaPagos += $pago['monto'];
                    $pagosMixtos[] = [
                        'metodo_pago' => $pago['metodo_pago'],
                        'monto' => $pago['monto'],
                        'referencia' => $pago['referencia'] ?? null,
                    ];
                }

                // Validar que la suma de pagos sea igual al total
                if (abs($sumaPagos - $total) > 0.01) { // Tolerancia de 1 centavo por redondeo
                    throw new \Exception("La suma de pagos (" . number_format($sumaPagos, 2) . ") debe ser igual al total de la venta (" . number_format($total, 2) . ")");
                }

                $metodoPagoSimple = 'MIXTO'; // Indicador de pago mixto
            } else {
                // Modo pago simple (retrocompatibilidad)
                $metodoPagoSimple = $request->metodo_pago;
            }

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
                'metodo_pago' => $metodoPagoSimple,
                'observaciones' => $request->observaciones,
                'user_id' => \Illuminate\Support\Facades\Auth::id() ?? 1,
            ];

            // Agregar moneda solo si el campo existe en la tabla
            if (\Illuminate\Support\Facades\Schema::hasColumn('ventas', 'moneda')) {
                $ventaData['moneda'] = $moneda;
            }

            // Agregar tipo_documento solo si el campo existe
            if (\Illuminate\Support\Facades\Schema::hasColumn('ventas', 'tipo_documento')) {
                $ventaData['tipo_documento'] = $tipoDocumento;
            }

            $venta = Venta::create($ventaData);
            
            // Log para debug
            \Illuminate\Support\Facades\Log::info('Venta creada', [
                'venta_id' => $venta->id,
                'cliente_id' => $cliente?->id,
                'user_cliente_id' => $userCliente?->id,
                'cliente_nombre' => $cliente?->razon_social ?? $cliente?->nombre_comercial,
                'user_cliente_nombre' => $userCliente ? trim(($userCliente->nombres ?? '') . ' ' . ($userCliente->apellidos ?? '')) : null
            ]);

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

            // 8.5. GUARDAR MÉTODOS DE PAGO (si es pago mixto)
            if (!empty($pagosMixtos)) {
                foreach ($pagosMixtos as $pago) {
                    \App\Models\VentaMetodoPago::create([
                        'venta_id' => $venta->id,
                        'metodo' => $pago['metodo_pago'],
                        'monto' => $pago['monto'],
                        'referencia' => $pago['referencia'],
                    ]);
                }

                \Illuminate\Support\Facades\Log::info('Pagos mixtos registrados', [
                    'venta_id' => $venta->id,
                    'cantidad_pagos' => count($pagosMixtos),
                    'metodos' => array_column($pagosMixtos, 'metodo_pago')
                ]);
            }

            DB::commit();

            // Disparar evento para procesar integraciones
            event(new VentaCreated($venta->load(['cliente', 'userCliente', 'detalles.producto'])));

            // 9. RESPUESTA EXITOSA CON TODOS LOS DATOS
            $responseData = [
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
                'metodo_pago' => $metodoPagoSimple,
            ];

            // Incluir métodos de pago si es pago mixto
            if (!empty($pagosMixtos)) {
                $responseData['metodos_pago'] = $venta->metodosPago->map(function($mp) {
                    return [
                        'metodo' => $mp->metodo,
                        'monto' => $mp->monto,
                        'referencia' => $mp->referencia,
                    ];
                });
            }

            return response()->json([
                'success' => true,
                'message' => 'Venta registrada exitosamente',
                'data' => $responseData,
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

            // Enriquecer con información del comprobante
            $ventaArray = $venta->toArray();
            
            if ($venta->comprobante) {
                $ventaArray['comprobante_info'] = [
                    'id' => $venta->comprobante->id,
                    'tipo_comprobante' => $venta->comprobante->tipo_comprobante ?? '03',
                    'serie' => $venta->comprobante->serie ?? '',
                    'correlativo' => $venta->comprobante->correlativo ?? 0,
                    'numero_completo' => $venta->comprobante->numero_completo ?? 'N/A',
                    'estado' => $venta->comprobante->estado ?? 'PENDIENTE',
                    'estado_sunat' => $venta->comprobante->estado ?? 'PENDIENTE',
                    'origen' => $venta->comprobante->origen ?? 'MANUAL',
                    'fecha_emision' => $venta->comprobante->fecha_emision,
                    'fecha_envio_sunat' => $venta->comprobante->fecha_envio_sunat,
                    'fecha_respuesta_sunat' => $venta->comprobante->fecha_respuesta_sunat,
                    'tiene_xml' => !empty($venta->comprobante->xml_firmado),
                    'tiene_pdf' => !empty($venta->comprobante->pdf_base64),
                    'tiene_cdr' => !empty($venta->comprobante->xml_respuesta_sunat),
                    'tiene_qr' => !empty($venta->comprobante->qr_path),
                    'mensaje_sunat' => $venta->comprobante->mensaje_sunat ?? null,
                    'codigo_error_sunat' => $venta->comprobante->codigo_error_sunat ?? null,
                    'operacion_gravada' => $venta->comprobante->operacion_gravada ?? '0.00',
                    'operacion_exonerada' => $venta->comprobante->operacion_exonerada ?? '0.00',
                    'total_igv' => $venta->comprobante->total_igv ?? '0.00',
                    'importe_total' => $venta->comprobante->importe_total ?? '0.00',
                ];
            } else {
                $ventaArray['comprobante_info'] = null;
            }

            return response()->json($ventaArray);
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
            'cliente_datos.direccion' => 'sometimes|nullable|string|max:500',
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

    /**
     * Enviar comprobante a SUNAT (para comprobantes ya generados)
     * POST /api/ventas/{id}/enviar-sunat
     */
    public function enviarSunat($id)
    {
        try {
            $venta = Venta::with(['comprobante', 'cliente', 'userCliente'])->findOrFail($id);

            // Validar que tenga comprobante
            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado. Debe facturar primero.'
                ], 400);
            }

            $comprobante = $venta->comprobante;
            
            // Cargar la relación cliente si no está cargada
            if (!$comprobante->relationLoaded('cliente')) {
                $comprobante->load('cliente');
            }

            // Validar que el comprobante esté en estado PENDIENTE
            if ($comprobante->estado !== 'PENDIENTE') {
                return response()->json([
                    'success' => false,
                    'message' => "El comprobante no puede ser enviado. Estado actual: {$comprobante->estado}",
                    'data' => [
                        'estado_actual' => $comprobante->estado,
                        'puede_reenviar' => in_array($comprobante->estado, ['RECHAZADO', 'ERROR'])
                    ]
                ], 400);
            }

            // Enviar a SUNAT usando el servicio Greenter
            $resultado = $this->greenterService->enviarComprobante($comprobante);

            if ($resultado['success']) {
                // Actualizar estado de la venta
                $venta->update(['estado' => 'FACTURADO']);

                // Recargar comprobante con datos actualizados
                $comprobanteActualizado = $comprobante->fresh();

                return response()->json([
                    'success' => true,
                    'message' => $resultado['mensaje'] ?? 'Comprobante enviado a SUNAT exitosamente',
                    'data' => [
                        // Campos directos para el frontend
                        'estado' => $comprobanteActualizado->estado ?? 'ACEPTADO',
                        'mensaje_sunat' => $comprobanteActualizado->mensaje_sunat ?? 'Comprobante enviado exitosamente',
                        'numero_completo' => $comprobanteActualizado->numero_completo,
                        'tiene_pdf' => !empty($comprobanteActualizado->pdf_base64),
                        'tiene_cdr' => !empty($comprobanteActualizado->xml_respuesta_sunat),
                        
                        // Objetos completos para compatibilidad
                        'comprobante' => [
                            'id' => $comprobanteActualizado->id,
                            'numero_completo' => $comprobanteActualizado->numero_completo,
                            'estado' => $comprobanteActualizado->estado ?? 'ACEPTADO',
                            'mensaje_sunat' => $comprobanteActualizado->mensaje_sunat ?? 'Enviado exitosamente',
                            'tiene_xml' => !empty($comprobanteActualizado->xml_firmado),
                            'tiene_pdf' => !empty($comprobanteActualizado->pdf_base64),
                            'tiene_cdr' => !empty($comprobanteActualizado->xml_respuesta_sunat),
                            'fecha_envio_sunat' => $comprobanteActualizado->fecha_envio_sunat,
                            'fecha_respuesta_sunat' => $comprobanteActualizado->fecha_respuesta_sunat
                        ],
                        'venta' => $venta->fresh()
                    ]
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al enviar comprobante a SUNAT',
                    'error' => $resultado['error'],
                    'codigo_error' => $resultado['codigo_error'] ?? null
                ], 500);
            }

        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('Error en enviarSunat', [
                'venta_id' => $id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error al enviar comprobante a SUNAT',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reenviar comprobante a SUNAT (para comprobantes rechazados o con error)
     * POST /api/ventas/{id}/reenviar-sunat
     */
    public function reenviarSunat($id)
    {
        try {
            $venta = Venta::with(['comprobante'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 400);
            }

            $comprobante = $venta->comprobante;

            // Validar que el comprobante pueda ser reenviado
            if (!in_array($comprobante->estado, ['RECHAZADO', 'ERROR', 'PENDIENTE'])) {
                return response()->json([
                    'success' => false,
                    'message' => "El comprobante no puede ser reenviado. Estado actual: {$comprobante->estado}"
                ], 400);
            }

            // Reenviar a SUNAT
            $resultado = $this->greenterService->enviarComprobante($comprobante);

            if ($resultado['success']) {
                $venta->update(['estado' => 'FACTURADO']);

                return response()->json([
                    'success' => true,
                    'message' => 'Comprobante reenviado exitosamente',
                    'data' => [
                        'comprobante' => $comprobante->fresh()
                    ]
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al reenviar comprobante',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al reenviar comprobante',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Consultar estado del comprobante en SUNAT
     * POST /api/ventas/{id}/consultar-sunat
     */
    public function consultarSunat($id)
    {
        try {
            $venta = Venta::with(['comprobante'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 400);
            }

            $resultado = $this->greenterService->consultarComprobante($venta->comprobante);

            return response()->json($resultado);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al consultar estado en SUNAT',
                'error' => $e->getMessage()
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
     * Obtener datos prellenados para enviar por email
     * GET /api/ventas/{id}/email-datos
     */
    public function obtenerDatosEmail($id)
    {
        try {
            $venta = Venta::with(['comprobante', 'cliente', 'userCliente'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico'
                ], 404);
            }

            $comprobante = $venta->comprobante;

            // Obtener email del cliente
            $email = null;
            if ($venta->cliente && !empty($venta->cliente->email)) {
                $email = $venta->cliente->email;
            } elseif ($venta->userCliente && !empty($venta->userCliente->email)) {
                $email = $venta->userCliente->email;
            }

            // Obtener nombre del cliente
            $nombreCliente = 'Cliente';
            if ($venta->cliente) {
                $nombreCliente = $venta->cliente->razon_social ?? $venta->cliente->nombre_comercial ?? 'Cliente';
            } elseif ($venta->userCliente) {
                $nombreCliente = trim(($venta->userCliente->nombres ?? '') . ' ' . ($venta->userCliente->apellidos ?? '')) ?: 'Cliente';
            }

            // Mensaje sugerido
            $mensajeSugerido = "Estimado(a) {$nombreCliente}, adjuntamos su comprobante electrónico {$comprobante->numero_completo}.";

            // Verificar si puede enviarse
            $puedeEnviar = !empty($comprobante->pdf_base64) && $comprobante->estado === 'ACEPTADO';
            $razonNoEnviar = null;

            if (empty($comprobante->pdf_base64)) {
                $razonNoEnviar = "El comprobante no tiene PDF generado. Debe enviarse a SUNAT primero.";
            } elseif ($comprobante->estado !== 'ACEPTADO') {
                $razonNoEnviar = "El comprobante debe estar aceptado por SUNAT (estado actual: {$comprobante->estado})";
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'venta_id' => $venta->id,
                    'comprobante' => [
                        'numero_completo' => $comprobante->numero_completo,
                        'estado' => $comprobante->estado,
                        'tiene_pdf' => !empty($comprobante->pdf_base64),
                        'tiene_xml' => !empty($comprobante->xml_firmado),
                    ],
                    'cliente' => [
                        'nombre' => $nombreCliente,
                        'email' => $email,
                    ],
                    'datos_prellenados' => [
                        'email' => $email,
                        'mensaje' => $mensajeSugerido
                    ],
                    'puede_enviar' => $puedeEnviar,
                    'razon_no_enviar' => $razonNoEnviar,
                    'urls' => [
                        'pdf' => $puedeEnviar ? url("/api/ventas/{$id}/pdf") : null,
                        'xml' => $puedeEnviar ? url("/api/ventas/{$id}/xml") : null,
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener datos de email',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar comprobante por email
     * POST /api/ventas/{id}/email
     */
    public function enviarEmail(Request $request, $id)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'mensaje' => 'nullable|string|max:500',
            ]);

            $venta = Venta::with(['comprobante', 'cliente', 'userCliente', 'detalles.producto'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico'
                ], 404);
            }

            $comprobante = $venta->comprobante;

            // Validar que tenga PDF generado
            if (empty($comprobante->pdf_base64)) {
                return response()->json([
                    'success' => false,
                    'message' => 'El comprobante no tiene PDF generado. Debe enviarse a SUNAT primero.'
                ], 400);
            }

            // Validar que esté aceptado por SUNAT
            if ($comprobante->estado !== 'ACEPTADO') {
                return response()->json([
                    'success' => false,
                    'message' => 'El comprobante debe estar aceptado por SUNAT antes de enviarlo',
                    'data' => [
                        'estado_actual' => $comprobante->estado
                    ]
                ], 400);
            }

            // Obtener nombre del cliente
            $nombreCliente = 'Cliente';
            if ($venta->cliente) {
                $nombreCliente = $venta->cliente->razon_social ?? $venta->cliente->nombre_comercial ?? 'Cliente';
            } elseif ($venta->userCliente) {
                $nombreCliente = trim(($venta->userCliente->nombres ?? '') . ' ' . ($venta->userCliente->apellidos ?? '')) ?: 'Cliente';
            }

            // Mensaje personalizado
            $mensajeTexto = $request->mensaje ?? "Estimado(a) {$nombreCliente}, adjuntamos su comprobante electrónico {$comprobante->numero_completo}.";

            try {
                // Regenerar PDF con QR actualizado antes de enviar
                try {
                    $pdfService = app(\App\Services\PdfGeneratorService::class);
                    $pdfService->generarPdfSunat($comprobante->fresh());
                    $comprobante = $comprobante->fresh(); // Recargar con PDF actualizado
                    
                    \Illuminate\Support\Facades\Log::info('PDF regenerado con QR para email', [
                        'comprobante_id' => $comprobante->id
                    ]);
                } catch (\Exception $pdfError) {
                    // Si falla la regeneración, usar el PDF existente
                    \Illuminate\Support\Facades\Log::warning('No se pudo regenerar PDF, usando existente', [
                        'comprobante_id' => $comprobante->id,
                        'error' => $pdfError->getMessage()
                    ]);
                }

                // Enviar email con el comprobante adjunto
                \Illuminate\Support\Facades\Mail::to($request->email)->send(
                    new \App\Mail\ComprobanteEmail($comprobante, $mensajeTexto)
                );

                \Illuminate\Support\Facades\Log::info('Email enviado exitosamente', [
                    'venta_id' => $venta->id,
                    'email' => $request->email,
                    'comprobante' => $comprobante->numero_completo
                ]);

                // Registrar envío exitoso (opcional, no falla si hay error)
                try {
                    \App\Models\NotificacionEnviada::registrarEnvio(
                        $venta->id,
                        'email',
                        $request->email,
                        $mensajeTexto,
                        $comprobante->id
                    );
                } catch (\Exception $e) {
                    // No fallar si el registro falla
                    \Illuminate\Support\Facades\Log::warning('No se pudo registrar el envío de email', [
                        'error' => $e->getMessage()
                    ]);
                }

                return response()->json([
                    'success' => true,
                    'message' => 'Comprobante enviado por email exitosamente',
                    'data' => [
                        'email' => $request->email,
                        'comprobante' => $comprobante->numero_completo,
                        'fecha_envio' => now()->format('Y-m-d H:i:s')
                    ]
                ]);

            } catch (\Exception $e) {
                \Illuminate\Support\Facades\Log::error('Error al enviar email', [
                    'venta_id' => $venta->id,
                    'email' => $request->email,
                    'error' => $e->getMessage(),
                    'trace' => $e->getTraceAsString()
                ]);

                // Registrar error en el envío (opcional)
                try {
                    \App\Models\NotificacionEnviada::registrarError(
                        $venta->id,
                        'email',
                        $request->email,
                        $e->getMessage(),
                        $mensajeTexto,
                        $comprobante->id ?? null
                    );
                } catch (\Exception $regError) {
                    // No fallar si el registro falla
                    \Illuminate\Support\Facades\Log::warning('No se pudo registrar el error de envío', [
                        'error' => $regError->getMessage()
                    ]);
                }

                return response()->json([
                    'success' => false,
                    'message' => 'Error al enviar email',
                    'error' => $e->getMessage()
                ], 500);
            }

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
            \Illuminate\Support\Facades\Log::error('Error al consultar RUC: '.$e->getMessage());

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

    /**
     * Descargar XML de una venta
     * GET /api/ventas/{id}/xml
     */
    public function descargarXml($id)
    {
        try {
            $venta = Venta::with('comprobante')->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 404);
            }

            if (!$venta->comprobante->xml_firmado) {
                return response()->json([
                    'success' => false,
                    'message' => 'El XML no está disponible para este comprobante'
                ], 404);
            }

            $filename = "comprobante_{$venta->comprobante->numero_completo}.xml";

            return response($venta->comprobante->xml_firmado, 200, [
                'Content-Type' => 'application/xml',
                'Content-Disposition' => "attachment; filename=\"{$filename}\""
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al descargar XML',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Descargar CDR (Constancia de Recepción) de una venta
     * GET /api/ventas/{id}/cdr
     */
    public function descargarCdr($id)
    {
        try {
            $venta = Venta::with('comprobante')->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 404);
            }

            if (!$venta->comprobante->xml_respuesta_sunat) {
                return response()->json([
                    'success' => false,
                    'message' => 'El CDR no está disponible. El comprobante puede no haber sido enviado a SUNAT aún.'
                ], 404);
            }

            $filename = "R-{$venta->comprobante->numero_completo}.zip";
            
            // Decodificar el CDR desde base64
            $cdrContent = base64_decode($venta->comprobante->xml_respuesta_sunat);

            return response($cdrContent, 200, [
                'Content-Type' => 'application/zip',
                'Content-Disposition' => "attachment; filename=\"{$filename}\""
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al descargar CDR',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Descargar PDF de una venta
     * GET /api/ventas/{id}/pdf
     */
    public function descargarPdf($id)
    {
        try {
            $venta = Venta::with('comprobante')->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 404);
            }

            if (!$venta->comprobante->pdf_base64) {
                return response()->json([
                    'success' => false,
                    'message' => 'El PDF no está disponible para este comprobante'
                ], 404);
            }

            $pdf = base64_decode($venta->comprobante->pdf_base64);
            $filename = "comprobante_{$venta->comprobante->numero_completo}.pdf";

            return response($pdf, 200, [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => "attachment; filename=\"{$filename}\""
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al descargar PDF',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener código QR de un comprobante
     * GET /api/ventas/{id}/qr
     */
    public function descargarQr($id)
    {
        try {
            $venta = Venta::with('comprobante')->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 404);
            }

            if (!$venta->comprobante->qr_path) {
                return response()->json([
                    'success' => false,
                    'message' => 'El código QR no está disponible para este comprobante'
                ], 404);
            }

            // Si el QR está en base64
            if (strpos($venta->comprobante->qr_path, 'data:image') === 0) {
                $qrData = $venta->comprobante->qr_path;
                return response()->json([
                    'success' => true,
                    'data' => [
                        'qr_base64' => $qrData
                    ]
                ]);
            }

            // Si el QR está en archivo
            $qrPath = storage_path('app/' . $venta->comprobante->qr_path);
            if (file_exists($qrPath)) {
                return response()->file($qrPath, [
                    'Content-Type' => 'image/png'
                ]);
            }

            return response()->json([
                'success' => false,
                'message' => 'Archivo QR no encontrado'
            ], 404);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener código QR',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener datos prellenados para enviar por WhatsApp
     * GET /api/ventas/{id}/whatsapp-datos
     */
    public function obtenerDatosWhatsApp($id)
    {
        try {
            $venta = Venta::with(['comprobante', 'cliente', 'userCliente'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico'
                ], 404);
            }

            $comprobante = $venta->comprobante;

            // Obtener teléfono del cliente
            $telefono = null;
            if ($venta->cliente && !empty($venta->cliente->telefono)) {
                $telefono = $venta->cliente->telefono;
            } elseif ($venta->userCliente && !empty($venta->userCliente->telefono)) {
                $telefono = $venta->userCliente->telefono;
            }

            // Limpiar y formatear teléfono si existe
            if ($telefono) {
                $telefono = preg_replace('/[^0-9]/', '', $telefono);
                // Añadir +51 si es necesario
                if (!str_starts_with($telefono, '51') && strlen($telefono) === 9) {
                    $telefono = '51' . $telefono;
                }
                $telefono = '+' . $telefono;
            }

            // Obtener nombre del cliente
            $nombreCliente = 'Cliente';
            if ($venta->cliente) {
                $nombreCliente = $venta->cliente->razon_social ?? $venta->cliente->nombre_comercial ?? 'Cliente';
            } elseif ($venta->userCliente) {
                $nombreCliente = trim(($venta->userCliente->nombres ?? '') . ' ' . ($venta->userCliente->apellidos ?? '')) ?: 'Cliente';
            }

            // Mensaje sugerido
            $mensajeSugerido = "Hola {$nombreCliente}, adjunto tu comprobante electrónico {$comprobante->numero_completo}";

            // Verificar si puede enviarse
            $puedeEnviar = !empty($comprobante->pdf_base64) && $comprobante->estado === 'ACEPTADO';
            $razonNoEnviar = null;

            if (empty($comprobante->pdf_base64)) {
                $razonNoEnviar = "El comprobante no tiene PDF generado. Debe enviarse a SUNAT primero.";
            } elseif ($comprobante->estado !== 'ACEPTADO') {
                $razonNoEnviar = "El comprobante debe estar aceptado por SUNAT (estado actual: {$comprobante->estado})";
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'venta_id' => $venta->id,
                    'comprobante' => [
                        'numero_completo' => $comprobante->numero_completo,
                        'estado' => $comprobante->estado,
                        'tiene_pdf' => !empty($comprobante->pdf_base64),
                        'tiene_xml' => !empty($comprobante->xml_firmado),
                    ],
                    'cliente' => [
                        'nombre' => $nombreCliente,
                        'telefono' => $telefono,
                    ],
                    'datos_prellenados' => [
                        'telefono' => $telefono,
                        'mensaje' => $mensajeSugerido
                    ],
                    'puede_enviar' => $puedeEnviar,
                    'razon_no_enviar' => $razonNoEnviar,
                    'urls' => [
                        'pdf' => $puedeEnviar ? url("/api/ventas/{$id}/pdf") : null,
                        'xml' => $puedeEnviar ? url("/api/ventas/{$id}/xml") : null,
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener datos de WhatsApp',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar comprobante por WhatsApp
     * POST /api/ventas/{id}/whatsapp
     */
    public function enviarWhatsApp(Request $request, $id)
    {
        try {
            $request->validate([
                'telefono' => 'required|string|max:20',
                'mensaje' => 'nullable|string|max:500',
            ]);

            $venta = Venta::with(['comprobante', 'cliente', 'userCliente'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico'
                ], 404);
            }

            $comprobante = $venta->comprobante;

            // Validar que tenga PDF generado
            if (empty($comprobante->pdf_base64)) {
                return response()->json([
                    'success' => false,
                    'message' => 'El comprobante no tiene PDF generado. Debe enviarse a SUNAT primero.'
                ], 400);
            }

            // Validar que esté aceptado por SUNAT
            if ($comprobante->estado !== 'ACEPTADO') {
                return response()->json([
                    'success' => false,
                    'message' => 'El comprobante debe estar aceptado por SUNAT antes de enviarlo',
                    'data' => [
                        'estado_actual' => $comprobante->estado
                    ]
                ], 400);
            }

            // Limpiar número de teléfono
            $telefono = preg_replace('/[^0-9]/', '', $request->telefono);

            // Asegurar que tenga código de país (Perú: +51)
            if (!str_starts_with($telefono, '51') && strlen($telefono) === 9) {
                $telefono = '51' . $telefono;
            }

            // Obtener nombre del cliente
            $nombreCliente = 'Cliente';
            if ($venta->cliente) {
                $nombreCliente = $venta->cliente->razon_social ?? $venta->cliente->nombre_comercial ?? 'Cliente';
            } elseif ($venta->userCliente) {
                $nombreCliente = trim(($venta->userCliente->nombres ?? '') . ' ' . ($venta->userCliente->apellidos ?? '')) ?: 'Cliente';
            }

            // Mensaje personalizado o por defecto
            $mensajeTexto = $request->mensaje ?? "Hola {$nombreCliente}, adjunto tu comprobante electrónico {$comprobante->numero_completo}";

            try {
                // URLs de descarga
                $pdfUrl = url("/api/ventas/{$id}/pdf");
                $xmlUrl = url("/api/ventas/{$id}/xml");

                // Generar link de WhatsApp
                $mensajeCompleto = $mensajeTexto . "\n\n📄 PDF: " . $pdfUrl . "\n📋 XML: " . $xmlUrl;
                $whatsappUrl = "https://wa.me/{$telefono}?text=" . urlencode($mensajeCompleto);

                // OPCIÓN: Si tienes API de WhatsApp Business configurada, úsala aquí
                // Ejemplo con servicio hipotético:
                // TODO: Implementar envío real de WhatsApp
                // $whatsappService = app(\App\Services\WhatsAppService::class);
                // $resultado = $whatsappService->enviarMensaje($telefono, $mensajeTexto, [$pdfUrl, $xmlUrl]);

                // Por ahora simulamos el envío exitoso
                \Log::info('WhatsApp simulado enviado', [
                    'venta_id' => $venta->id,
                    'telefono' => $telefono,
                    'comprobante' => $comprobante->numero_completo
                ]);

                // Registrar envío exitoso (opcional, no falla si hay error)
                \App\Models\NotificacionEnviada::registrarEnvio(
                    $venta->id,
                    'whatsapp',
                    $telefono,
                    $mensajeTexto,
                    $comprobante->id
                );

                return response()->json([
                    'success' => true,
                    'message' => 'Comprobante enviado por WhatsApp exitosamente',
                    'data' => [
                        'whatsapp_url' => $whatsappUrl,
                        'telefono' => $telefono,
                        'mensaje' => $mensajeCompleto,
                        'comprobante' => $comprobante->numero_completo,
                        'pdf_url' => $pdfUrl,
                        'xml_url' => $xmlUrl,
                        'fecha_envio' => now()->format('Y-m-d H:i:s')
                    ]
                ]);

            } catch (\Exception $e) {
                \Log::error('Error al enviar WhatsApp', [
                    'venta_id' => $venta->id,
                    'telefono' => $telefono,
                    'error' => $e->getMessage()
                ]);

                // Registrar error en el envío (opcional)
                \App\Models\NotificacionEnviada::registrarError(
                    $venta->id,
                    'whatsapp',
                    $telefono,
                    $e->getMessage(),
                    $mensajeTexto,
                    $comprobante->id ?? null
                );

                throw $e;
            }

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar por WhatsApp',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener historial de envíos a SUNAT
     * GET /api/ventas/{id}/historial-sunat
     */
    public function historialSunat($id)
    {
        try {
            $venta = Venta::with('comprobante')->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico'
                ], 404);
            }

            // Obtener logs de SUNAT
            $logs = \App\Models\SunatLog::where('comprobante_id', $venta->comprobante->id)
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => [
                    'comprobante' => [
                        'numero_completo' => $venta->comprobante->numero_completo,
                        'estado_actual' => $venta->comprobante->estado,
                        'fecha_emision' => $venta->comprobante->fecha_emision,
                        'fecha_envio_sunat' => $venta->comprobante->fecha_envio_sunat,
                        'fecha_respuesta_sunat' => $venta->comprobante->fecha_respuesta_sunat,
                    ],
                    'historial' => $logs->map(function($log) {
                        return [
                            'fecha' => $log->created_at,
                            'accion' => $log->accion,
                            'estado' => $log->estado,
                            'mensaje' => $log->mensaje,
                            'codigo_error' => $log->codigo_error,
                            'request' => $log->request_data,
                            'response' => $log->response_data,
                        ];
                    })
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener historial',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Listar ventas pendientes de facturar
     * GET /api/ventas/pendientes-facturar
     */
    public function pendientesFacturar(Request $request)
    {
        try {
            $query = Venta::with(['cliente', 'userCliente'])
                ->where('estado', 'PENDIENTE')
                ->whereDoesntHave('comprobante')
                ->orderBy('fecha_venta', 'desc');

            // Filtros adicionales
            if ($request->has('fecha_desde')) {
                $query->where('fecha_venta', '>=', $request->fecha_desde);
            }

            if ($request->has('fecha_hasta')) {
                $query->where('fecha_venta', '<=', $request->fecha_hasta);
            }

            $ventas = $query->paginate(20);

            return response()->json([
                'success' => true,
                'data' => $ventas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener ventas pendientes',
                'error' => $e->getMessage()
            ], 500);
        }
    }



    /**
     * Estadísticas por estado SUNAT
     * GET /api/ventas/estadisticas-sunat
     */
    public function estadisticasSunat(Request $request)
    {
        try {
            $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->format('Y-m-d');
            $fechaFin = $request->fecha_fin ?? now()->format('Y-m-d');

            $estadisticas = [
                'periodo' => ['inicio' => $fechaInicio, 'fin' => $fechaFin],
                'total_ventas' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])->count(),
                'sin_comprobante' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                    ->whereDoesntHave('comprobante')->count(),
                'con_comprobante' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                    ->whereHas('comprobante')->count(),
                'por_estado_sunat' => [
                    'PENDIENTE' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                        ->whereHas('comprobante', function($q) {
                            $q->where('estado', 'PENDIENTE');
                        })->count(),
                    'ENVIADO' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                        ->whereHas('comprobante', function($q) {
                            $q->where('estado', 'ENVIADO');
                        })->count(),
                    'ACEPTADO' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                        ->whereHas('comprobante', function($q) {
                            $q->where('estado', 'ACEPTADO');
                        })->count(),
                    'RECHAZADO' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                        ->whereHas('comprobante', function($q) {
                            $q->where('estado', 'RECHAZADO');
                        })->count(),
                    'ANULADO' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                        ->whereHas('comprobante', function($q) {
                            $q->where('estado', 'ANULADO');
                        })->count(),
                ],
                'monto_total' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])->sum('total'),
                'monto_aceptado' => Venta::whereBetween('fecha_venta', [$fechaInicio, $fechaFin])
                    ->whereHas('comprobante', function($q) {
                        $q->where('estado', 'ACEPTADO');
                    })->sum('total'),
            ];

            return response()->json([
                'success' => true,
                'data' => $estadisticas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Generar PDF manualmente para un comprobante
     * POST /api/ventas/{id}/generar-pdf
     */
    public function generarPdf($id)
    {
        try {
            $venta = Venta::with(['comprobante.cliente', 'comprobante.detalles'])->findOrFail($id);

            if (!$venta->comprobante) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta venta no tiene un comprobante electrónico asociado'
                ], 422);
            }

            $comprobante = $venta->comprobante;

            // Usar el nuevo servicio PDF SUNAT compliant
            $pdfService = new \App\Services\PdfGeneratorService();
            $resultado = $pdfService->generarPdfSunat($comprobante);

            return response()->json([
                'success' => true,
                'message' => 'PDF generado exitosamente con todos los parámetros SUNAT',
                'data' => [
                    'comprobante_id' => $comprobante->id,
                    'numero_completo' => $comprobante->serie . '-' . str_pad($comprobante->correlativo, 8, '0', STR_PAD_LEFT),
                    'tiene_pdf' => true,
                    'template_usado' => $resultado['template_usado'],
                    'elementos_incluidos' => $resultado['elementos_incluidos'],
                    'pdf_size_bytes' => $resultado['pdf_size_bytes'] ?? 0,
                    'generacion_info' => [
                        'timestamp' => now()->toISOString(),
                        'version' => '2.0-sunat-compliant'
                    ]
                ]
            ]);

        } catch (\App\Services\PdfGenerationException $e) {
            \Log::error('Error específico de PDF', [
                'venta_id' => $id,
                'error_code' => $e->errorCode,
                'context' => $e->context,
                'suggested_action' => $e->suggestedAction
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error al generar PDF: ' . $e->getMessage(),
                'error_code' => $e->errorCode,
                'suggested_action' => $e->suggestedAction
            ], 500);

        } catch (\Exception $e) {
            \Log::error('Error general generando PDF', [
                'venta_id' => $id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error al generar PDF: ' . $e->getMessage(),
                'error_details' => [
                    'type' => get_class($e),
                    'file' => $e->getFile(),
                    'line' => $e->getLine()
                ]
            ], 500);
        }
    }
}
