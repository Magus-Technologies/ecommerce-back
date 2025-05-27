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
    public function index()
    {
        try {
            $productos = Producto::with('categoria')
                ->orderBy('nombre')
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
                'nombre', 'descripcion', 'codigo_producto', 'categoria_id',
                'precio_compra', 'precio_venta', 'stock', 'stock_minimo', 'activo'
            ]);
            
            $data['activo'] = $request->has('activo') ? (bool)$request->activo : true;

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
            $producto = Producto::findOrFail($id);
            $data = $request->only([
                'nombre', 'descripcion', 'codigo_producto', 'categoria_id',
                'precio_compra', 'precio_venta', 'stock', 'stock_minimo', 'activo'
            ]);
            
            if ($request->has('activo')) {
                $data['activo'] = (bool)$request->activo;
            }

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
            $producto->load('categoria');

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
}