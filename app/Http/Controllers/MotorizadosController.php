<?php

namespace App\Http\Controllers;

use App\Models\Motorizado;
use App\Models\DocumentType;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class MotorizadosController extends Controller
{
    public function index()
    {
        try {
            $motorizados = Motorizado::with(['tipoDocumento', 'registradoPor', 'ubicacion'])
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json($motorizados);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al cargar motorizados'], 500);
        }
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nombre_completo' => 'required|string|max:255',
            'foto_perfil' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            'tipo_documento_id' => 'required|exists:document_types,id',
            'numero_documento' => 'required|string|max:20|unique:motorizados',
            'licencia_numero' => 'required|string|max:50',
            'licencia_categoria' => 'required|in:A1,A2a,A2b,A3a,A3b,A3c',
            'telefono' => 'required|string|max:20',
            'correo' => 'required|email|unique:motorizados',
            'direccion_detalle' => 'required|string',
            'ubigeo' => 'required|string|exists:ubigeo_inei,id_ubigeo',
            'vehiculo_marca' => 'required|string|max:100',
            'vehiculo_modelo' => 'required|string|max:100',
            'vehiculo_ano' => 'required|integer|min:1950|max:' . (date('Y') + 1),
            'vehiculo_cilindraje' => 'required|string|max:50',
            'vehiculo_color_principal' => 'required|string|max:50',
            'vehiculo_color_secundario' => 'nullable|string|max:50',
            'vehiculo_placa' => 'required|string|max:20|unique:motorizados',
            'vehiculo_motor' => 'required|string|max:100',
            'vehiculo_chasis' => 'required|string|max:100',
            'comentario' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Error de validación',
                'details' => $validator->errors()
            ], 422);
        }

        try {
            $motorizado = new Motorizado();
            
            // Generar número de unidad
            $motorizado->numero_unidad = Motorizado::getProximoNumeroUnidad();
            
            // Llenar datos básicos
            $motorizado->fill($request->except(['foto_perfil']));
            $motorizado->registrado_por = auth()->id();

            // Manejar foto de perfil
            if ($request->hasFile('foto_perfil')) {
                $foto = $request->file('foto_perfil');
                $nombreFoto = time() . '_' . $foto->getClientOriginalName();
                $rutaFoto = $foto->storeAs('motorizados/fotos', $nombreFoto, 'public');
                $motorizado->foto_perfil = config('app.url') . '/storage/' . $rutaFoto;
            }

            $motorizado->save();

            return response()->json([
                'message' => 'Motorizado registrado exitosamente',
                'motorizado' => $motorizado->load(['tipoDocumento', 'registradoPor', 'ubicacion'])
            ], 201);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al registrar motorizado'], 500);
        }
    }

    public function show($id)
    {
        try {
            $motorizado = Motorizado::with(['tipoDocumento', 'registradoPor', 'ubicacion'])
                ->findOrFail($id);
            
            return response()->json($motorizado);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Motorizado no encontrado'], 404);
        }
    }

    public function update(Request $request, $id)
    {
        // Debug inicial
        Log::info('=== INICIO UPDATE MOTORIZADO ===');
        Log::info('ID recibido: ' . $id);
        Log::info('Método HTTP: ' . $request->method());
        Log::info('Content-Type: ' . $request->header('Content-Type'));
        
        // NUEVO: Verificar si Laravel está interpretando correctamente el _method
        if ($request->has('_method')) {
            Log::info('_method encontrado: ' . $request->get('_method'));
        }
        
        Log::info('Todos los datos del request:', $request->all());
        Log::info('Archivos recibidos:', $request->allFiles());
        Log::info('Request tiene datos?', ['empty' => empty($request->all())]);

        $validator = Validator::make($request->all(), [
            'nombre_completo' => 'required|string|max:255',
            'foto_perfil' => 'nullable|sometimes|image|mimes:jpeg,png,jpg|max:2048',
            'tipo_documento_id' => 'required|exists:document_types,id',
            'numero_documento' => 'required|string|max:20|unique:motorizados,numero_documento,' . $id,
            'licencia_numero' => 'required|string|max:50',
            'licencia_categoria' => 'required|in:A1,A2a,A2b,A3a,A3b,A3c',
            'telefono' => 'required|string|max:20',
            'correo' => 'required|email|unique:motorizados,correo,' . $id,
            'direccion_detalle' => 'required|string',
            'ubigeo' => 'required|string|exists:ubigeo_inei,id_ubigeo',
            'vehiculo_marca' => 'required|string|max:100',
            'vehiculo_modelo' => 'required|string|max:100',
            'vehiculo_ano' => 'required|integer|min:1950|max:' . (date('Y') + 1),
            'vehiculo_cilindraje' => 'required|string|max:50',
            'vehiculo_color_principal' => 'required|string|max:50',
            'vehiculo_color_secundario' => 'nullable|string|max:50',
            'vehiculo_placa' => 'required|string|max:20|unique:motorizados,vehiculo_placa,' . $id,
            'vehiculo_motor' => 'required|string|max:100',
            'vehiculo_chasis' => 'required|string|max:100',
            'comentario' => 'nullable|string',
            'eliminar_foto' => 'nullable|string',            
        ]);

        // NUEVO: Verificar si hay archivo válido antes de validar
        if ($request->has('foto_perfil') && !$request->hasFile('foto_perfil')) {
            // Si existe el campo pero no es un archivo válido, removerlo del request
            $request->request->remove('foto_perfil');
            
            // Volver a validar sin el campo foto_perfil problemático
            $validator = Validator::make($request->all(), [
                'nombre_completo' => 'required|string|max:255',
                'tipo_documento_id' => 'required|exists:document_types,id',
                'numero_documento' => 'required|string|max:20|unique:motorizados,numero_documento,' . $id,
                'licencia_numero' => 'required|string|max:50',
                'licencia_categoria' => 'required|in:A1,A2a,A2b,A3a,A3b,A3c',
                'telefono' => 'required|string|max:20',
                'correo' => 'required|email|unique:motorizados,correo,' . $id,
                'direccion_detalle' => 'required|string',
                'ubigeo' => 'required|string|exists:ubigeo_inei,id_ubigeo',
                'vehiculo_marca' => 'required|string|max:100',
                'vehiculo_modelo' => 'required|string|max:100',
                'vehiculo_ano' => 'required|integer|min:1950|max:' . (date('Y') + 1),
                'vehiculo_cilindraje' => 'required|string|max:50',
                'vehiculo_color_principal' => 'required|string|max:50',
                'vehiculo_color_secundario' => 'nullable|string|max:50',
                'vehiculo_placa' => 'required|string|max:20|unique:motorizados,vehiculo_placa,' . $id,
                'vehiculo_motor' => 'required|string|max:100',
                'vehiculo_chasis' => 'required|string|max:100',
                'comentario' => 'nullable|string',
                'eliminar_foto' => 'nullable|string',            
            ]);
        }
        
        if ($validator->fails()) {
            Log::error('Validación falló:', $validator->errors()->toArray());
            return response()->json([
                'error' => 'Error de validación',
                'details' => $validator->errors(),
                'received_data' => $request->all()
            ], 422);
        }

        try {
             $motorizado = Motorizado::findOrFail($id);
    
            Log::info('Datos recibidos en update:', $request->all());

            // Debug: verificar qué datos llegan
            Log::info('FormData recibida:', $request->all());
            Log::info('Archivos recibidos:', $request->allFiles());
            // AGREGAR ESTA LÓGICA NUEVA AQUÍ:
            // Manejar eliminación de foto
            if ($request->has('eliminar_foto') && $request->eliminar_foto === 'true') {
                // Eliminar foto actual del storage
                if ($motorizado->foto_perfil) {
                    $rutaAnterior = str_replace('/storage/', '', $motorizado->foto_perfil);
                    Storage::disk('public')->delete($rutaAnterior);
                }
                $motorizado->foto_perfil = null;
            }
            
            // Manejar nueva foto (código existente)
            if ($request->hasFile('foto_perfil')) {
                // Eliminar foto anterior
                if ($motorizado->foto_perfil) {
                    $rutaAnterior = str_replace('/storage/', '', $motorizado->foto_perfil);
                    Storage::disk('public')->delete($rutaAnterior);
                }
                
                $foto = $request->file('foto_perfil');
                $nombreFoto = time() . '_' . $foto->getClientOriginalName();
                $rutaFoto = $foto->storeAs('motorizados/fotos', $nombreFoto, 'public');
                $motorizado->foto_perfil = config('app.url') . '/storage/' . $rutaFoto;
            }

            // Actualizar datos (excluir foto_perfil y eliminar_foto de mass assignment)
            $motorizado->fill($request->except(['foto_perfil', 'eliminar_foto']));
            $motorizado->save();

            return response()->json([
                'message' => 'Motorizado actualizado exitosamente',
                'motorizado' => $motorizado->load(['tipoDocumento', 'registradoPor', 'ubicacion'])
            ]);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al actualizar motorizado'], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $motorizado = Motorizado::findOrFail($id);
            
            // Eliminar foto si existe
            if ($motorizado->foto_perfil) {
                $rutaFoto = str_replace('/storage/', '', $motorizado->foto_perfil);
                Storage::disk('public')->delete($rutaFoto);
            }
            
            $motorizado->delete();
            
            return response()->json(['message' => 'Motorizado eliminado exitosamente']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al eliminar motorizado'], 500);
        }
    }

    public function toggleEstado($id)
    {
        try {
            $motorizado = Motorizado::findOrFail($id);
            $motorizado->estado = !$motorizado->estado;
            $motorizado->save();
            
            return response()->json([
                'message' => 'Estado actualizado exitosamente',
                'estado' => $motorizado->estado
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al actualizar estado'], 500);
        }
    }

    public function getCategoriasLicencia()
    {
        $motorizado = new Motorizado();
        return response()->json($motorizado->getCategoriasLicencia());
    }
}
