<?php

namespace App\Http\Controllers;

use App\Models\Banner;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class BannersController extends Controller
{
    /**
     * Obtener todos los banners (para dashboard)
     */
    public function index()
    {
        try {
            $banners = Banner::ordenados()->get();
            
            return response()->json([
                'status' => 'success',
                'data' => $banners
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al obtener banners: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener banners activos para el público
     */
    public function bannersPublicos()
    {
        try {
            $banners = Banner::activos()->ordenados()->get()->map(function ($banner) {
                return [
                    'id' => $banner->id,
                    'titulo' => $banner->titulo,
                    'subtitulo' => $banner->subtitulo,
                    'descripcion' => $banner->descripcion,
                    'texto_boton' => $banner->texto_boton,
                    'enlace_url' => $banner->enlace_boton, // ✅ MAPEAR CORRECTAMENTE
                    'precio_desde' => $banner->precio_desde,
                    'imagen_url' => $banner->imagen_completa,
                    'orden' => $banner->orden
                ];
            });
            
            return response()->json([
                'status' => 'success',
                'data' => $banners
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al obtener banners públicos: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear un nuevo banner
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'titulo' => 'required|string|max:255',
            'subtitulo' => 'nullable|string|max:255', // ✅ CAMBIAR A NULLABLE
            'descripcion' => 'nullable|string',
            'texto_boton' => 'required|string|max:100',
            'enlace_url' => 'required|string|max:255', // ✅ CAMBIAR NOMBRE DEL CAMPO
            'precio_desde' => 'nullable|numeric|min:0',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'orden' => 'nullable|integer|min:0',
            'activo' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $data = $request->all();
            
            // ✅ MAPEAR EL CAMPO CORRECTAMENTE
            if (isset($data['enlace_url'])) {
                $data['enlace_boton'] = $data['enlace_url'];
                unset($data['enlace_url']);
            }
            
            // Manejar la subida de imagen
            if ($request->hasFile('imagen')) {
                $imagen = $request->file('imagen');
                $nombreImagen = time() . '_' . uniqid() . '.' . $imagen->getClientOriginalExtension();
                $rutaImagen = $imagen->storeAs('banners', $nombreImagen, 'public');
                $data['imagen_url'] = $rutaImagen;
            }

            // Si no se especifica orden, usar el siguiente disponible
            if (!isset($data['orden'])) {
                $data['orden'] = Banner::max('orden') + 1;
            }

            $banner = Banner::create($data);
            
            return response()->json([
                'status' => 'success',
                'message' => 'Banner creado exitosamente',
                'data' => $banner
            ], 201);
            
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al crear banner: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar un banner específico
     */
    public function show($id)
    {
        try {
            $banner = Banner::findOrFail($id);
            
            return response()->json([
                'status' => 'success',
                'data' => $banner
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Banner no encontrado'
            ], 404);
        }
    }

    /**
     * Actualizar un banner
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'titulo' => 'sometimes|required|string|max:255', // ✅ AGREGAR SOMETIMES
            'subtitulo' => 'nullable|string|max:255',
            'descripcion' => 'nullable|string',
            'texto_boton' => 'sometimes|required|string|max:100', // ✅ AGREGAR SOMETIMES
            'enlace_url' => 'sometimes|required|string|max:255', // ✅ CAMBIAR NOMBRE
            'precio_desde' => 'nullable|numeric|min:0',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'orden' => 'nullable|integer|min:0',
            'activo' => 'sometimes|boolean' // ✅ AGREGAR SOMETIMES
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $banner = Banner::findOrFail($id);
            $data = $request->all();
            
            // ✅ MAPEAR EL CAMPO CORRECTAMENTE
            if (isset($data['enlace_url'])) {
                $data['enlace_boton'] = $data['enlace_url'];
                unset($data['enlace_url']);
            }
            
            // Manejar la subida de nueva imagen
            if ($request->hasFile('imagen')) {
                // Eliminar imagen anterior
                $banner->eliminarImagenAnterior();
                
                // Subir nueva imagen
                $imagen = $request->file('imagen');
                $nombreImagen = time() . '_' . uniqid() . '.' . $imagen->getClientOriginalExtension();
                $rutaImagen = $imagen->storeAs('banners', $nombreImagen, 'public');
                $data['imagen_url'] = $rutaImagen;
            }

            $banner->update($data);
            
            return response()->json([
                'status' => 'success',
                'message' => 'Banner actualizado exitosamente',
                'data' => $banner
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al actualizar banner: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar un banner
     */
    public function destroy($id)
    {
        try {
            $banner = Banner::findOrFail($id);
            
            // Eliminar imagen asociada
            $banner->eliminarImagenAnterior();
            
            $banner->delete();
            
            return response()->json([
                'status' => 'success',
                'message' => 'Banner eliminado exitosamente'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al eliminar banner: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cambiar el estado activo/inactivo de un banner
     */
    public function toggleEstado($id)
    {
        try {
            $banner = Banner::findOrFail($id);
            $banner->activo = !$banner->activo;
            $banner->save();
            
            return response()->json([
                'status' => 'success',
                'message' => 'Estado del banner actualizado',
                'data' => $banner
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al cambiar estado del banner: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reordenar banners
     */
    public function reordenar(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'banners' => 'required|array',
            'banners.*.id' => 'required|exists:banners,id',
            'banners.*.orden' => 'required|integer|min:0'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            foreach ($request->banners as $bannerData) {
                Banner::where('id', $bannerData['id'])
                    ->update(['orden' => $bannerData['orden']]);
            }
            
            return response()->json([
                'status' => 'success',
                'message' => 'Orden de banners actualizado exitosamente'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al reordenar banners: ' . $e->getMessage()
            ], 500);
        }
    }
}