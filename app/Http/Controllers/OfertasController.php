<?php

namespace App\Http\Controllers;

use App\Models\Oferta;
use App\Models\TipoOferta;
use App\Models\Cupon;
use App\Models\OfertaProducto;
use App\Models\Producto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class OfertasController extends Controller
{
    // ==================== MÉTODOS PÚBLICOS ====================
    
    public function ofertasPublicas()
    {
        $ofertas = Oferta::with(['tipoOferta', 'productos.producto'])
            ->activas()
            ->orderBy('prioridad', 'desc')
            ->get()
            ->map(function ($oferta) {
                return [
                    'id' => $oferta->id,
                    'titulo' => $oferta->titulo,
                    'subtitulo' => $oferta->subtitulo,
                    'descripcion' => $oferta->descripcion,
                    'tipo_descuento' => $oferta->tipo_descuento,
                    'valor_descuento' => $oferta->valor_descuento,
                    'fecha_inicio' => $oferta->fecha_inicio ? Carbon::parse($oferta->fecha_inicio)->toISOString() : null,
                    'fecha_fin' => $oferta->fecha_fin ? Carbon::parse($oferta->fecha_fin)->toISOString() : null,
                    'imagen_url' => $oferta->imagen_url,
                    'banner_imagen_url' => $oferta->banner_imagen_url,
                    'color_fondo' => $oferta->color_fondo,
                    'texto_boton' => $oferta->texto_boton,
                    'enlace_url' => $oferta->enlace_url,
                    'mostrar_countdown' => $oferta->mostrar_countdown,
                    'es_oferta_principal' => $oferta->es_oferta_principal,
                    'timestamp_servidor' => Carbon::now()->toISOString(),
                    'productos' => $oferta->productos->map(function ($productoOferta) use ($oferta) {
                        $producto = $productoOferta->producto;
                        return [
                            'id' => $producto->id,
                            'nombre' => $producto->nombre,
                            'precio_original' => $producto->precio_venta,
                            'precio_oferta' => $productoOferta->precio_oferta ?? $oferta->calcularPrecioOferta($producto->precio_venta),
                            'stock_oferta' => $productoOferta->stock_oferta,
                            'vendidos_oferta' => $productoOferta->vendidos_oferta,
                            'imagen_url' => $producto->imagen_url,
                        ];
                    })
                ];
            });

        return response()->json($ofertas);
    }

    // ✅ NUEVO ENDPOINT: Obtener oferta principal del día
    public function ofertaPrincipalDelDia()
    {
        $ofertaPrincipal = Oferta::obtenerOfertaPrincipalActiva();

        if (!$ofertaPrincipal) {
            return response()->json([
                'oferta_principal' => null,
                'productos' => [],
                'mensaje' => 'No hay oferta principal activa'
            ]);
        }

        $productos = $ofertaPrincipal->productos->map(function ($productoOferta) use ($ofertaPrincipal) {
            $producto = $productoOferta->producto;
            $precioOferta = $productoOferta->precio_oferta ?? $ofertaPrincipal->calcularPrecioOferta($producto->precio_venta);
            $descuentoPorcentaje = round((($producto->precio_venta - $precioOferta) / $producto->precio_venta) * 100);

            return [
                'id' => $producto->id,
                'nombre' => $producto->nombre,
                'precio_original' => $producto->precio_venta,
                'precio_oferta' => $precioOferta,
                'descuento_porcentaje' => $descuentoPorcentaje,
                'stock_oferta' => $productoOferta->stock_oferta,
                'vendidos_oferta' => $productoOferta->vendidos_oferta,
                'stock_disponible' => $productoOferta->stock_oferta - $productoOferta->vendidos_oferta,
                'imagen_url' => $producto->imagen_url,
                'categoria' => $producto->categoria->nombre ?? null,
                'marca' => $producto->marca->nombre ?? null,
            ];
        });

        return response()->json([
            'oferta_principal' => [
                'id' => $ofertaPrincipal->id,
                'titulo' => $ofertaPrincipal->titulo,
                'subtitulo' => $ofertaPrincipal->subtitulo,
                'descripcion' => $ofertaPrincipal->descripcion,
                'tipo_descuento' => $ofertaPrincipal->tipo_descuento,
                'valor_descuento' => $ofertaPrincipal->valor_descuento,
                'fecha_inicio' => $ofertaPrincipal->fecha_inicio ? Carbon::parse($ofertaPrincipal->fecha_inicio)->toISOString() : null,
                'fecha_fin' => $ofertaPrincipal->fecha_fin ? Carbon::parse($ofertaPrincipal->fecha_fin)->toISOString() : null,
                'imagen_url' => $ofertaPrincipal->imagen_url,
                'banner_imagen_url' => $ofertaPrincipal->banner_imagen_url,
                'color_fondo' => $ofertaPrincipal->color_fondo,
                'texto_boton' => $ofertaPrincipal->texto_boton,
                'enlace_url' => $ofertaPrincipal->enlace_url,
                'mostrar_countdown' => $ofertaPrincipal->mostrar_countdown,
                'timestamp_servidor' => Carbon::now()->toISOString(),
            ],
            'productos' => $productos
        ]);
    }

    public function flashSales()
    {
        $flashSales = Oferta::with(['productos.producto'])
            ->activas()
            ->flashSales()
            ->orderBy('prioridad', 'desc')
            ->get()
            ->map(function ($oferta) {
                return [
                    'id' => $oferta->id,
                    'titulo' => $oferta->titulo,
                    'descripcion' => $oferta->descripcion,
                    'fecha_fin' => $oferta->fecha_fin ? Carbon::parse($oferta->fecha_fin)->toISOString() : null,
                    'banner_imagen_url' => $oferta->banner_imagen_url,
                    'color_fondo' => $oferta->color_fondo,
                    'texto_boton' => $oferta->texto_boton,
                    'enlace_url' => $oferta->enlace_url,
                    'mostrar_countdown' => $oferta->mostrar_countdown,
                    'timestamp_servidor' => Carbon::now()->toISOString(),
                ];
            });

        return response()->json($flashSales);
    }

    public function productosEnOferta()
    {
        $productos = OfertaProducto::with(['producto.categoria', 'producto.marca', 'oferta'])
            ->whereHas('oferta', function ($query) {
                $query->activas();
            })
            ->get()
            ->map(function ($productoOferta) {
                $producto = $productoOferta->producto;
                $oferta = $productoOferta->oferta;
                
                $precioOferta = $productoOferta->precio_oferta ?? $oferta->calcularPrecioOferta($producto->precio_venta);
                $descuentoPorcentaje = round((($producto->precio_venta - $precioOferta) / $producto->precio_venta) * 100);

                return [
                    'id' => $producto->id,
                    'nombre' => $producto->nombre,
                    'precio_original' => $producto->precio_venta,
                    'precio_oferta' => $precioOferta,
                    'descuento_porcentaje' => $descuentoPorcentaje,
                    'stock_oferta' => $productoOferta->stock_oferta,
                    'vendidos_oferta' => $productoOferta->vendidos_oferta,
                    'imagen_url' => $producto->imagen_url,
                    'fecha_fin_oferta' => $oferta->fecha_fin ? Carbon::parse($oferta->fecha_fin)->toISOString() : null,
                    'es_flash_sale' => $oferta->mostrar_countdown,
                    'categoria' => $producto->categoria->nombre ?? null,
                    'marca' => $producto->marca->nombre ?? null,
                    'timestamp_servidor' => Carbon::now()->toISOString(),
                ];
            });

        return response()->json($productos);
    }

    public function validarCupon(Request $request)
    {
        $request->validate([
            'codigo' => 'required|string',
            'total' => 'required|numeric|min:0'
        ]);

        $codigo = $request->input('codigo');
        $total = $request->input('total', 0);

        $cupon = Cupon::where('codigo', $codigo)
            ->disponibles()
            ->first();

        if (!$cupon) {
            return response()->json([
                'valido' => false, 
                'mensaje' => 'Cupón no válido o expirado'
            ]);
        }

        if (!$cupon->puedeUsarse($total)) {
            if ($cupon->compra_minima && $total < $cupon->compra_minima) {
                return response()->json([
                    'valido' => false, 
                    'mensaje' => "Compra mínima requerida: $" . number_format($cupon->compra_minima, 2)
                ]);
            }

            return response()->json([
                'valido' => false, 
                'mensaje' => 'Cupón no disponible'
            ]);
        }

        $descuento = $cupon->calcularDescuento($total);

        return response()->json([
            'valido' => true,
            'cupon' => [
                'id' => $cupon->id,
                'codigo' => $cupon->codigo,
                'titulo' => $cupon->titulo,
                'tipo_descuento' => $cupon->tipo_descuento,
                'valor_descuento' => $cupon->valor_descuento
            ],
            'descuento' => $descuento,
            'total_con_descuento' => $total - $descuento
        ]);
    }

    // ==================== MÉTODOS ADMINISTRATIVOS ====================

    public function index()
    {
        $ofertas = Oferta::with(['tipoOferta', 'productos'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($ofertas);
    }

    public function store(Request $request)
    {
        $request->validate([
            'titulo' => 'required|string|max:255',
            'tipo_descuento' => 'required|in:porcentaje,cantidad_fija',
            'valor_descuento' => 'required|numeric|min:0',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'banner_imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'es_oferta_principal' => 'boolean'
        ]);

        $data = $request->all();

        // Manejar subida de imágenes
        if ($request->hasFile('imagen')) {
            $data['imagen'] = $request->file('imagen')->store('ofertas', 'public');
        }

        if ($request->hasFile('banner_imagen')) {
            $data['banner_imagen'] = $request->file('banner_imagen')->store('ofertas/banners', 'public');
        }

        $oferta = Oferta::create($data);

        // ✅ Si se marca como oferta principal, quitar el estado de las demás
        if ($request->boolean('es_oferta_principal')) {
            $oferta->marcarComoPrincipal();
        }

        return response()->json($oferta->load('tipoOferta'), 201);
    }

    public function show($id)
    {
        $oferta = Oferta::with(['tipoOferta', 'productos.producto'])
            ->findOrFail($id);

        return response()->json($oferta);
    }

    public function update(Request $request, $id)
    {
        $oferta = Oferta::findOrFail($id);

        $request->validate([
            'titulo' => 'required|string|max:255',
            'tipo_descuento' => 'required|in:porcentaje,cantidad_fija',
            'valor_descuento' => 'required|numeric|min:0',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'banner_imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'es_oferta_principal' => 'boolean'
        ]);

        $data = $request->all();

        // Manejar subida de imágenes
        if ($request->hasFile('imagen')) {
            // Eliminar imagen anterior
            if ($oferta->imagen) {
                Storage::disk('public')->delete($oferta->imagen);
            }
            $data['imagen'] = $request->file('imagen')->store('ofertas', 'public');
        }

        if ($request->hasFile('banner_imagen')) {
            // Eliminar imagen anterior
            if ($oferta->banner_imagen) {
                Storage::disk('public')->delete($oferta->banner_imagen);
            }
            $data['banner_imagen'] = $request->file('banner_imagen')->store('ofertas/banners', 'public');
        }

        $oferta->update($data);

        // ✅ Manejar estado de oferta principal
        if ($request->boolean('es_oferta_principal')) {
            $oferta->marcarComoPrincipal();
        } elseif ($request->has('es_oferta_principal') && !$request->boolean('es_oferta_principal')) {
            $oferta->quitarEstadoPrincipal();
        }

        return response()->json($oferta->load('tipoOferta'));
    }

    // ✅ NUEVO ENDPOINT: Marcar/desmarcar como oferta principal
    public function toggleOfertaPrincipal($id)
    {
        $oferta = Oferta::findOrFail($id);

        if ($oferta->es_oferta_principal) {
            $oferta->quitarEstadoPrincipal();
            $mensaje = 'Oferta desmarcada como principal';
        } else {
            $oferta->marcarComoPrincipal();
            $mensaje = 'Oferta marcada como principal del día';
        }

        return response()->json([
            'message' => $mensaje,
            'oferta' => $oferta->fresh()
        ]);
    }

    public function destroy($id)
    {
        $oferta = Oferta::findOrFail($id);

        // Eliminar imágenes
        if ($oferta->imagen) {
            Storage::disk('public')->delete($oferta->imagen);
        }
        if ($oferta->banner_imagen) {
            Storage::disk('public')->delete($oferta->banner_imagen);
        }

        $oferta->delete();

        return response()->json(['message' => 'Oferta eliminada correctamente']);
    }

    public function tiposOfertas()
    {
        $tipos = TipoOferta::activos()->get();
        return response()->json($tipos);
    }

    // ==================== GESTIÓN DE PRODUCTOS EN OFERTAS ====================

    /**
     * Obtener productos disponibles para agregar a una oferta
     */
    public function productosDisponibles(Request $request)
    {
        $query = Producto::where('activo', true);

        // Filtrar por búsqueda
        if ($request->has('search')) {
            $search = $request->get('search');
            $query->where(function($q) use ($search) {
                $q->where('nombre', 'like', "%{$search}%")
                  ->orWhere('codigo_producto', 'like', "%{$search}%");
            });
        }

        // Filtrar por categoría
        if ($request->has('categoria_id')) {
            $query->where('categoria_id', $request->get('categoria_id'));
        }

        $productos = $query->with(['categoria', 'marca'])
            ->select('id', 'nombre', 'codigo_producto', 'precio_venta', 'stock', 'imagen', 'categoria_id', 'marca_id')
            ->paginate(20);

        // Transformar los datos para incluir imagen_url
        $productos->getCollection()->transform(function ($producto) {
            return [
                'id' => $producto->id,
                'nombre' => $producto->nombre,
                'codigo' => $producto->codigo_producto, // Mapear para el frontend
                'precio_venta' => $producto->precio_venta,
                'stock' => $producto->stock,
                'imagen_url' => $producto->imagen_url, // Usar el accessor del modelo
                'categoria' => $producto->categoria,
                'marca' => $producto->marca,
            ];
        });

        return response()->json($productos);
    }

    /**
     * Obtener productos de una oferta específica
     */
    public function productosOferta($ofertaId)
    {
        $productos = OfertaProducto::with(['producto.categoria', 'producto.marca'])
            ->where('oferta_id', $ofertaId)
            ->get()
            ->map(function ($productoOferta) {
                $producto = $productoOferta->producto;
                return [
                    'id' => $productoOferta->id,
                    'producto_id' => $producto->id,
                    'nombre' => $producto->nombre,
                    'codigo' => $producto->codigo_producto, // Mapear para el frontend
                    'precio_original' => $producto->precio_venta,
                    'precio_oferta' => $productoOferta->precio_oferta,
                    'stock_original' => $producto->stock,
                    'stock_oferta' => $productoOferta->stock_oferta,
                    'vendidos_oferta' => $productoOferta->vendidos_oferta,
                    'imagen_url' => $producto->imagen_url, // Usar el accessor del modelo
                    'categoria' => $producto->categoria->nombre ?? null,
                    'marca' => $producto->marca->nombre ?? null,
                ];
            });

        return response()->json($productos);
    }

    /**
     * Agregar producto a una oferta
     */
    public function agregarProducto(Request $request, $ofertaId)
    {
        $request->validate([
            'producto_id' => 'required|exists:productos,id',
            'precio_oferta' => 'nullable|numeric|min:0',
            'stock_oferta' => 'required|integer|min:1'
        ]);

        $oferta = Oferta::findOrFail($ofertaId);
        $producto = Producto::findOrFail($request->producto_id);

        // Verificar que el producto no esté ya en la oferta
        $existe = OfertaProducto::where('oferta_id', $ofertaId)
            ->where('producto_id', $request->producto_id)
            ->exists();

        if ($existe) {
            return response()->json([
                'message' => 'El producto ya está en esta oferta'
            ], 422);
        }

        // Calcular precio de oferta si no se proporciona
        $precioOferta = $request->precio_oferta ?? $oferta->calcularPrecioOferta($producto->precio_venta);

        // Verificar que el stock de oferta no exceda el stock del producto
        if ($request->stock_oferta > $producto->stock) {
            return response()->json([
                'message' => 'El stock de oferta no puede ser mayor al stock disponible del producto'
            ], 422);
        }

        $productoOferta = OfertaProducto::create([
            'oferta_id' => $ofertaId,
            'producto_id' => $request->producto_id,
            'precio_oferta' => $precioOferta,
            'stock_oferta' => $request->stock_oferta,
            'vendidos_oferta' => 0
        ]);

        return response()->json([
            'message' => 'Producto agregado a la oferta correctamente',
            'producto_oferta' => $productoOferta->load('producto')
        ], 201);
    }

    /**
     * Actualizar producto en oferta
     */
    public function actualizarProducto(Request $request, $ofertaId, $productoOfertaId)
    {
        $request->validate([
            'precio_oferta' => 'required|numeric|min:0',
            'stock_oferta' => 'required|integer|min:1'
        ]);

        $productoOferta = OfertaProducto::where('oferta_id', $ofertaId)
            ->where('id', $productoOfertaId)
            ->firstOrFail();

        // Verificar que el stock de oferta no exceda el stock del producto
        if ($request->stock_oferta > $productoOferta->producto->stock) {
            return response()->json([
                'message' => 'El stock de oferta no puede ser mayor al stock disponible del producto'
            ], 422);
        }

        $productoOferta->update([
            'precio_oferta' => $request->precio_oferta,
            'stock_oferta' => $request->stock_oferta
        ]);

        return response()->json([
            'message' => 'Producto actualizado correctamente',
            'producto_oferta' => $productoOferta->load('producto')
        ]);
    }

    /**
     * Eliminar producto de oferta
     */
    public function eliminarProducto($ofertaId, $productoOfertaId)
    {
        $productoOferta = OfertaProducto::where('oferta_id', $ofertaId)
            ->where('id', $productoOfertaId)
            ->firstOrFail();

        $productoOferta->delete();

        return response()->json([
            'message' => 'Producto eliminado de la oferta correctamente'
        ]);
    }
}