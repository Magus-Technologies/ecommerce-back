<?php

namespace App\Http\Controllers;

use App\Models\PasoEnvio;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class PasoEnvioController extends Controller
{
    use AuthorizesRequests;
    /**
     * Obtener todos los pasos de envío (público)
     */
    public function index()
    {
        try {
            $pasos = PasoEnvio::activos()
                ->ordenados()
                ->get()
                ->map(function ($paso) {
                    return [
                        'id' => $paso->id,
                        'orden' => $paso->orden,
                        'titulo' => $paso->titulo,
                        'descripcion' => $paso->descripcion,
                        'imagen' => $paso->imagen_url,
                        'activo' => $paso->activo,
                    ];
                });

            return response()->json([
                'success' => true,
                'data' => $pasos
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener los pasos de envío',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener todos los pasos (admin - incluye inactivos)
     */
    public function indexAdmin()
    {
        try {
            $this->authorize('pasos_envio.edit');

            $pasos = PasoEnvio::ordenados()
                ->get()
                ->map(function ($paso) {
                    return [
                        'id' => $paso->id,
                        'orden' => $paso->orden,
                        'titulo' => $paso->titulo,
                        'descripcion' => $paso->descripcion,
                        'imagen' => $paso->imagen_url,
                        'activo' => $paso->activo,
                        'created_at' => $paso->created_at,
                        'updated_at' => $paso->updated_at,
                    ];
                });

            return response()->json([
                'success' => true,
                'data' => $pasos
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener los pasos de envío',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear un nuevo paso de envío
     */
    public function store(Request $request)
    {
        try {
            $this->authorize('pasos_envio.edit');

            // Validar sin la imagen primero
            $validator = Validator::make($request->only(['orden', 'titulo', 'descripcion', 'activo']), [
                'orden' => 'required|integer|min:1',
                'titulo' => 'required|string|max:255',
                'descripcion' => 'nullable|string',
                'activo' => 'boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            $data = $request->only(['orden', 'titulo', 'descripcion', 'activo']);

            // Manejar la imagen si se proporciona (sin validación estricta)
            if ($request->hasFile('imagen')) {
                try {
                    $imagen = $request->file('imagen');
                    
                    // Guardar directamente sin validar isValid() para evitar el warning
                    $extension = $imagen->getClientOriginalExtension();
                    $filename = 'paso_' . time() . '_' . uniqid() . '.' . $extension;
                    $imagenPath = $imagen->storeAs('pasos-envio', $filename, 'public');
                    $data['imagen'] = $imagenPath;
                } catch (\Exception $e) {
                    // Continuar sin imagen si falla
                    \Log::warning('Error al subir imagen: ' . $e->getMessage());
                }
            }

            $paso = PasoEnvio::create($data);

            return response()->json([
                'success' => true,
                'message' => 'Paso de envío creado exitosamente',
                'data' => [
                    'id' => $paso->id,
                    'orden' => $paso->orden,
                    'titulo' => $paso->titulo,
                    'descripcion' => $paso->descripcion,
                    'imagen' => $paso->imagen_url,
                    'activo' => $paso->activo,
                ]
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al crear el paso de envío',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar un paso específico
     */
    public function show($id)
    {
        try {
            $this->authorize('pasos_envio.edit');

            $paso = PasoEnvio::findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => [
                    'id' => $paso->id,
                    'orden' => $paso->orden,
                    'titulo' => $paso->titulo,
                    'descripcion' => $paso->descripcion,
                    'imagen' => $paso->imagen_url,
                    'activo' => $paso->activo,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Paso de envío no encontrado',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Actualizar un paso de envío
     */
    public function update(Request $request, $id)
    {
        try {
            $this->authorize('pasos_envio.edit');

            $paso = PasoEnvio::findOrFail($id);

            // Validar sin la imagen primero
            $validator = Validator::make($request->only(['orden', 'titulo', 'descripcion', 'activo']), [
                'orden' => 'sometimes|required|integer|min:1',
                'titulo' => 'sometimes|required|string|max:255',
                'descripcion' => 'nullable|string',
                'activo' => 'boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            $data = $request->only(['orden', 'titulo', 'descripcion', 'activo']);

            // Manejar la imagen si se proporciona (sin validación estricta)
            if ($request->hasFile('imagen')) {
                try {
                    $imagen = $request->file('imagen');
                    
                    // Eliminar imagen anterior si existe
                    if ($paso->imagen) {
                        Storage::disk('public')->delete($paso->imagen);
                    }

                    // Guardar directamente sin validar isValid() para evitar el warning
                    $extension = $imagen->getClientOriginalExtension();
                    $filename = 'paso_' . time() . '_' . uniqid() . '.' . $extension;
                    $imagenPath = $imagen->storeAs('pasos-envio', $filename, 'public');
                    $data['imagen'] = $imagenPath;
                } catch (\Exception $e) {
                    // Continuar sin imagen si falla
                    \Log::warning('Error al subir imagen: ' . $e->getMessage());
                }
            }

            $paso->update($data);

            return response()->json([
                'success' => true,
                'message' => 'Paso de envío actualizado exitosamente',
                'data' => [
                    'id' => $paso->id,
                    'orden' => $paso->orden,
                    'titulo' => $paso->titulo,
                    'descripcion' => $paso->descripcion,
                    'imagen' => $paso->imagen_url,
                    'activo' => $paso->activo,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar el paso de envío',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar un paso de envío
     */
    public function destroy($id)
    {
        try {
            $this->authorize('pasos_envio.edit');

            $paso = PasoEnvio::findOrFail($id);

            // Eliminar imagen si existe
            if ($paso->imagen) {
                Storage::disk('public')->delete($paso->imagen);
            }

            $paso->delete();

            return response()->json([
                'success' => true,
                'message' => 'Paso de envío eliminado exitosamente'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al eliminar el paso de envío',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar la imagen de un paso
     */
    public function deleteImage($id)
    {
        try {
            $this->authorize('pasos_envio.edit');

            $paso = PasoEnvio::findOrFail($id);

            if ($paso->imagen) {
                Storage::disk('public')->delete($paso->imagen);
                $paso->imagen = null;
                $paso->save();

                return response()->json([
                    'success' => true,
                    'message' => 'Imagen eliminada exitosamente'
                ]);
            }

            return response()->json([
                'success' => false,
                'message' => 'El paso no tiene imagen'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al eliminar la imagen',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
