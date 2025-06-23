<?php

namespace App\Http\Controllers;

use App\Models\Producto;
use App\Models\Categoria;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProductosController extends Controller
{
    /**
     * Obtener todos los productos
     */
    public function index(Request $request)
    {
        try {
            $query = Producto::with(['categoria.seccion', 'marca'])->orderBy('nombre');
            
            // Filtrar por sección si se proporciona
            if ($request->has('seccion') && $request->seccion !== '') {
                $query->whereHas('categoria', function($q) use ($request) {
                    $q->where('id_seccion', $request->seccion);
                });
            }
            
            $productos = $query->get();

            // Agregar URL completa de imagen
            $productos->transform(function ($producto) {
                if ($producto->imagen) {
                    $producto->imagen_url = asset('storage/productos/' . $producto->imagen);
                }
                return $producto;
            });

            return response()->json($productos);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener productos',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear nuevo producto
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'codigo_producto' => 'required|string|max:100|unique:productos,codigo_producto',
            'categoria_id' => 'required|exists:categorias,id',
            'precio_compra' => 'required|numeric|min:0',
            'precio_venta' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'stock_minimo' => 'required|integer|min:0',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'activo' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $data = $request->only([
                'nombre',
                'descripcion',
                'codigo_producto',
                'categoria_id',
                'precio_compra',
                'precio_venta',
                'stock',
                'stock_minimo',
                'activo'
            ]);

            $data['activo'] = $request->has('activo') ? (bool) $request->activo : true;

            // MÉTODO MANUAL - Manejar imagen directamente en public/storage
            if ($request->hasFile('imagen')) {
                $imagen = $request->file('imagen');
                $nombreImagen = time() . '_' . uniqid() . '.' . $imagen->getClientOriginalExtension();

                // Crear directorio si no existe
                $directorioDestino = public_path('storage/productos');
                if (!file_exists($directorioDestino)) {
                    mkdir($directorioDestino, 0755, true);
                }

                // Mover imagen directamente a public/storage/productos
                $imagen->move($directorioDestino, $nombreImagen);
                $data['imagen'] = $nombreImagen;
            }

            $producto = Producto::create($data);
            $producto->load('categoria');

            // Agregar URL completa de imagen para la respuesta
            if ($producto->imagen) {
                $producto->imagen_url = asset('storage/productos/' . $producto->imagen);
            }

            return response()->json([
                'message' => 'Producto creado exitosamente',
                'producto' => $producto
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al crear producto',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener producto específico
     */
    public function show($id)
    {
        try {
            $producto = Producto::with('categoria')->findOrFail($id);

            if ($producto->imagen) {
                $producto->imagen_url = asset('storage/productos/' . $producto->imagen);
            }

            return response()->json($producto);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Producto no encontrado',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Actualizar producto
     */
   public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'codigo_producto' => 'required|string|max:100|unique:productos,codigo_producto,' . $id,
            'categoria_id' => 'required|exists:categorias,id',
            'marca_id' => 'nullable|exists:marcas_productos,id',
            'precio_compra' => 'required|numeric|min:0',
            'precio_venta' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'stock_minimo' => 'required|integer|min:0',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'activo' => 'required|in:true,false,1,0'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $producto = Producto::findOrFail($id);
            $data = $request->only([
                'nombre', 'descripcion', 'codigo_producto', 'categoria_id', 'marca_id',
                'precio_compra', 'precio_venta', 'stock', 'stock_minimo'
            ]);
            
            $data['activo'] = filter_var($request->activo, FILTER_VALIDATE_BOOLEAN);

            // MÉTODO MANUAL - Manejar imagen
            if ($request->hasFile('imagen')) {
                // Eliminar imagen anterior si existe
                if ($producto->imagen) {
                    $rutaImagenAnterior = public_path('storage/productos/' . $producto->imagen);
                    if (file_exists($rutaImagenAnterior)) {
                        unlink($rutaImagenAnterior);
                    }
                }

                $imagen = $request->file('imagen');
                $nombreImagen = time() . '_' . uniqid() . '.' . $imagen->getClientOriginalExtension();
                
                // Crear directorio si no existe
                $directorioDestino = public_path('storage/productos');
                if (!file_exists($directorioDestino)) {
                    mkdir($directorioDestino, 0755, true);
                }
                
                // Mover imagen directamente a public/storage/productos
                $imagen->move($directorioDestino, $nombreImagen);
                $data['imagen'] = $nombreImagen;
            }

            $producto->update($data);
            $producto->load(['categoria', 'marca']);

            // Agregar URL completa de imagen para la respuesta
            if ($producto->imagen) {
                $producto->imagen_url = asset('storage/productos/' . $producto->imagen);
            }

            return response()->json([
                'message' => 'Producto actualizado exitosamente',
                'producto' => $producto
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al actualizar producto',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cambiar estado del producto (NUEVO ENDPOINT ESPECÍFICO)
     */
    public function toggleEstado(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'activo' => 'required|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $producto = Producto::findOrFail($id);
            $producto->update(['activo' => (bool) $request->activo]);
            $producto->load('categoria');

            // Agregar URL completa de imagen para la respuesta
            if ($producto->imagen) {
                $producto->imagen_url = asset('storage/productos/' . $producto->imagen);
            }

            return response()->json([
                'message' => 'Estado del producto actualizado exitosamente',
                'producto' => $producto
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al actualizar estado del producto',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar producto
     */
    public function destroy($id)
    {
        try {
            $producto = Producto::findOrFail($id);

            // MÉTODO MANUAL - Eliminar imagen si existe
            if ($producto->imagen) {
                $rutaImagen = public_path('storage/productos/' . $producto->imagen);
                if (file_exists($rutaImagen)) {
                    unlink($rutaImagen);
                }
            }

            $producto->delete();

            return response()->json([
                'message' => 'Producto eliminado exitosamente'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al eliminar producto',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener productos con stock bajo
     */
    public function stockBajo()
    {
        try {
            $productos = Producto::with('categoria')
                ->stockBajo()
                ->activos()
                ->get();

            // Agregar URL completa de imagen
            $productos->transform(function ($producto) {
                if ($producto->imagen) {
                    $producto->imagen_url = asset('storage/productos/' . $producto->imagen);
                }
                return $producto;
            });

            return response()->json($productos);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener productos con stock bajo',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function productosPublicos(Request $request)
    {
        $query = Producto::with(['categoria.seccion'])  
            ->where('activo', true)
            ->where('stock', '>', 0);

        // Filtrar por categoría si se proporciona
        if ($request->has('categoria')) {
            $query->where('categoria_id', $request->categoria);
        }

        // Filtrar por búsqueda si se proporciona
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('nombre', 'LIKE', "%{$search}%")
                    ->orWhere('descripcion', 'LIKE', "%{$search}%");
            });
        }

        $productos = $query->paginate(20);

        // Agregar campos calculados para el frontend
        $productos->getCollection()->transform(function ($producto) {
            return [
                'id' => $producto->id,
                'nombre' => $producto->nombre,
                'descripcion' => $producto->descripcion,
                'precio' => $producto->precio_venta, // ✅ CORREGIR: usar precio_venta
                'precio_oferta' => null, // Por ahora null, luego puedes agregar este campo
                'stock' => $producto->stock,
                'imagen_principal' => $producto->imagen ? asset('storage/productos/' . $producto->imagen) : '/placeholder-product.jpg', // ✅ CORREGIR
                'categoria' => $producto->categoria?->nombre,
                'categoria_id' => $producto->categoria_id,

                // ✅ CAMPOS DE RATING (valores fijos por ahora)
                'rating' => 4.8,
                'total_reviews' => rand(15, 25) . 'k',
                'reviews_count' => rand(150, 250),

                // ✅ CAMPOS ADICIONALES PARA EL FRONTEND
                'sold_count' => rand(10, 30),
                'total_stock' => $producto->stock + rand(10, 30),
                'is_on_sale' => false, // Por ahora false, luego puedes implementar ofertas
                'discount_percentage' => 0
            ];
        });

        return response()->json([
            'productos' => $productos->items(),
            'pagination' => [
                'current_page' => $productos->currentPage(),
                'last_page' => $productos->lastPage(),
                'per_page' => $productos->perPage(),
                'total' => $productos->total()
            ]
        ]);
    }

    // ✅ NUEVO MÉTODO PARA OBTENER CATEGORÍAS PARA EL SIDEBAR
    public function categoriasParaSidebar()
    {
        $categorias = Categoria::withCount([
            'productos' => function ($query) {
                $query->where('activo', true)->where('stock', '>', 0);
            }
        ])
            ->where('activo', true)
            ->orderBy('nombre')
            ->get()
            ->map(function ($categoria) {
                return [
                    'id' => $categoria->id,
                    'nombre' => $categoria->nombre,
                    'productos_count' => $categoria->productos_count
                ];
            });

        return response()->json($categorias);
    }

    /**
     * Obtener estadísticas de productos para dashboard
     */
    public function estadisticasDashboard()
    {
        try {
            $totalProductos = Producto::count();

            return response()->json([
                'total_productos' => $totalProductos
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener productos con stock crítico
     */
    public function productosStockCritico()
    {
        try {
            $productosStockCritico = Producto::with('categoria')
                ->whereRaw('stock <= stock_minimo')
                ->select('id', 'nombre', 'stock', 'stock_minimo', 'categoria_id')
                ->orderBy('stock', 'asc')
                ->get();

            return response()->json($productosStockCritico);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener productos con stock crítico',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}