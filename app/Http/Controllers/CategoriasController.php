<?php

namespace App\Http\Controllers;

use App\Models\Categoria;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CategoriasController extends Controller
{
    /**
     * Obtener todas las categorías
     */
    public function index(Request $request)
    {
        try {
            $query = Categoria::with('seccion')->orderBy('nombre');
            
            if ($request->has('seccion') && $request->seccion !== '' && $request->seccion !== null) {
                $query->where('id_seccion', $request->seccion);
            }
            
            $categorias = $query->get();
            
            // Agregar ruta completa de imagen
            $categorias->transform(function ($categoria) {
                if ($categoria->imagen) {
                    $categoria->imagen_url = asset('storage/categorias/' . $categoria->imagen);
                }
                return $categoria;
            });

            return response()->json($categorias);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener categorías',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Crear nueva categoría
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'required|string|max:255|unique:categorias,nombre',
            'id_seccion' => 'required|exists:secciones,id',
            'descripcion' => 'nullable|string',
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
            $data = $request->only(['nombre', 'id_seccion', 'descripcion', 'activo']);
            $data['activo'] = $request->has('activo') ? (bool)$request->activo : true;

           // Manejar imagen directamente en public/storage
            if ($request->hasFile('imagen')) {
                $imagen = $request->file('imagen');
                $nombreImagen = time() . '_' . uniqid() . '.' . $imagen->getClientOriginalExtension();
                
                // Crear directorio si no existe
                $directorioDestino = public_path('storage/categorias');
                if (!file_exists($directorioDestino)) {
                    mkdir($directorioDestino, 0755, true);
                }
                
                // Mover imagen directamente a public/storage/categorias
                $imagen->move($directorioDestino, $nombreImagen);
                $data['imagen'] = $nombreImagen;
            }

            $categoria = Categoria::create($data);

            // Agregar URL completa de imagen para la respuesta
            if ($categoria->imagen) {
                $categoria->imagen_url = asset('storage/categorias/' . $categoria->imagen);
            }

            return response()->json([
                'message' => 'Categoría creada exitosamente',
                'categoria' => $categoria
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al crear categoría',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener categoría específica
     */
    public function show($id)
    {
        try {
            $categoria = Categoria::findOrFail($id);
            
            if ($categoria->imagen) {
                $categoria->imagen_url = asset('storage/categorias/' . $categoria->imagen);
            }

            return response()->json($categoria);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Categoría no encontrada',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Actualizar categoría
     */
   public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'required|string|max:255|unique:categorias,nombre,' . $id,
            'descripcion' => 'nullable|string',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'activo' => 'required|in:true,false,1,0',
            'id_seccion' => 'required|exists:secciones,id'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $categoria = Categoria::findOrFail($id);
            $data = $request->only(['nombre', 'descripcion']);
            $data['activo'] = filter_var($request->activo, FILTER_VALIDATE_BOOLEAN);

            // MÉTODO MANUAL - Manejar imagen
            if ($request->hasFile('imagen')) {
                // Eliminar imagen anterior si existe
                if ($categoria->imagen) {
                    $rutaImagenAnterior = public_path('storage/categorias/' . $categoria->imagen);
                    if (file_exists($rutaImagenAnterior)) {
                        unlink($rutaImagenAnterior);
                    }
                }

                $imagen = $request->file('imagen');
                $nombreImagen = time() . '_' . uniqid() . '.' . $imagen->getClientOriginalExtension();
                
                // Crear directorio si no existe
                $directorioDestino = public_path('storage/categorias');
                if (!file_exists($directorioDestino)) {
                    mkdir($directorioDestino, 0755, true);
                }
                
                // Mover imagen directamente a public/storage/categorias
                $imagen->move($directorioDestino, $nombreImagen);
                $data['imagen'] = $nombreImagen;
            }

            $categoria->update($data);

            // Agregar URL completa de imagen para la respuesta
            if ($categoria->imagen) {
                $categoria->imagen_url = asset('storage/categorias/' . $categoria->imagen);
            }

            return response()->json([
                'message' => 'Categoría actualizada exitosamente',
                'categoria' => $categoria
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al actualizar categoría',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    /**
     * Cambiar estado de la categoría (NUEVO ENDPOINT ESPECÍFICO)
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
            $categoria = Categoria::findOrFail($id);
            $categoria->update(['activo' => (bool)$request->activo]);

            // Agregar URL completa de imagen para la respuesta
            if ($categoria->imagen) {
                $categoria->imagen_url = asset('storage/categorias/' . $categoria->imagen);
            }

            return response()->json([
                'message' => 'Estado de la categoría actualizado exitosamente',
                'categoria' => $categoria
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al actualizar estado de la categoría',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar categoría
     */
    public function destroy($id)
    {
        try {
            $categoria = Categoria::findOrFail($id);

            // Verificar si tiene productos asociados
            if ($categoria->productos()->count() > 0) {
                return response()->json([
                    'message' => 'No se puede eliminar la categoría porque tiene productos asociados'
                ], 400);
            }

            // MÉTODO MANUAL - Eliminar imagen si existe
            if ($categoria->imagen) {
                $rutaImagen = public_path('storage/categorias/' . $categoria->imagen);
                if (file_exists($rutaImagen)) {
                    unlink($rutaImagen);
                }
            }

            $categoria->delete();

            return response()->json([
                'message' => 'Categoría eliminada exitosamente'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al eliminar categoría',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function categoriasPublicas()
    {
        try {
            $categorias = Categoria::activas()
            ->withCount('productos')
                ->orderBy('nombre')
                ->get(['id', 'nombre', 'descripcion', 'imagen']);
            
            // Agregar ruta completa de imagen
            $categorias->transform(function ($categoria) {
                if ($categoria->imagen) {
                    $categoria->imagen_url = asset('storage/categorias/' . $categoria->imagen);
                }
                return $categoria;
            });

            return response()->json($categorias);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al obtener categorías públicas',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}