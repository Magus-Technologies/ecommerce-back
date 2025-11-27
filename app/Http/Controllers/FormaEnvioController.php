<?php

namespace App\Http\Controllers;

use App\Models\FormaEnvio;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class FormaEnvioController extends Controller
{
    // Listar todas las formas de envío con información de ubicación (admin)
    public function index()
    {
        try {
            $formasEnvio = DB::table('v_formas_envio_detalle')
                ->orderBy('departamento_nombre')
                ->orderBy('provincia_nombre')
                ->orderBy('distrito_nombre')
                ->get()
                ->map(function ($forma) {
                    $forma->costo = (float) $forma->costo;
                    return $forma;
                });

            return response()->json([
                'success' => true,
                'formas_envio' => $formasEnvio
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener formas de envío: ' . $e->getMessage()
            ], 500);
        }
    }

    // Listar solo formas de envío activas (público)
    public function activas()
    {
        try {
            $formasEnvio = DB::table('v_formas_envio_detalle')
                ->where('activo', 1)
                ->orderBy('departamento_nombre')
                ->orderBy('provincia_nombre')
                ->orderBy('distrito_nombre')
                ->get()
                ->map(function ($forma) {
                    $forma->costo = (float) $forma->costo;
                    return $forma;
                });

            return response()->json([
                'success' => true,
                'formas_envio' => $formasEnvio
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener formas de envío activas: ' . $e->getMessage()
            ], 500);
        }
    }

    // Calcular costo de envío según ubicación
    public function calcularCosto(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'departamento_id' => 'required|string',
            'provincia_id' => 'nullable|string',
            'distrito_id' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $departamentoId = $request->departamento_id;
            $provinciaId = $request->provincia_id;
            $distritoId = $request->distrito_id;

            $formaEnvio = null;

            // 1. Buscar por distrito específico
            if ($distritoId) {
                $formaEnvio = FormaEnvio::where('departamento_id', $departamentoId)
                    ->where('provincia_id', $provinciaId)
                    ->where('distrito_id', $distritoId)
                    ->where('activo', 1)
                    ->first();
            }

            // 2. Buscar por provincia
            if (!$formaEnvio && $provinciaId) {
                $formaEnvio = FormaEnvio::where('departamento_id', $departamentoId)
                    ->where('provincia_id', $provinciaId)
                    ->whereNull('distrito_id')
                    ->where('activo', 1)
                    ->first();
            }

            // 3. Buscar por departamento
            if (!$formaEnvio) {
                $formaEnvio = FormaEnvio::where('departamento_id', $departamentoId)
                    ->whereNull('provincia_id')
                    ->whereNull('distrito_id')
                    ->where('activo', 1)
                    ->first();
            }

            if (!$formaEnvio) {
                return response()->json([
                    'success' => false,
                    'message' => 'No hay servicio de envío disponible para esta ubicación',
                    'costo' => 0
                ], 404);
            }

            // Obtener información completa
            $formaEnvioDetalle = DB::table('v_formas_envio_detalle')
                ->where('id', $formaEnvio->id)
                ->first();

            return response()->json([
                'success' => true,
                'costo' => $formaEnvio->costo,
                'forma_envio' => $formaEnvioDetalle,
                'message' => 'Costo de envío calculado correctamente'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al calcular costo de envío: ' . $e->getMessage(),
                'costo' => 0
            ], 500);
        }
    }

    // Crear nueva forma de envío
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'departamento_id' => 'required|string',
            'provincia_id' => 'nullable|string',
            'distrito_id' => 'nullable|string',
            'costo' => 'required|numeric|min:0',
            'activo' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Verificar que no exista la misma combinación
            $existe = FormaEnvio::where('departamento_id', $request->departamento_id)
                ->where('provincia_id', $request->provincia_id)
                ->where('distrito_id', $request->distrito_id)
                ->exists();

            if ($existe) {
                return response()->json([
                    'success' => false,
                    'message' => 'Ya existe una forma de envío para esta ubicación'
                ], 422);
            }

            $formaEnvio = FormaEnvio::create($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Forma de envío creada correctamente',
                'forma_envio' => $formaEnvio
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al crear forma de envío: ' . $e->getMessage()
            ], 500);
        }
    }

    // Actualizar forma de envío
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'departamento_id' => 'required|string',
            'provincia_id' => 'nullable|string',
            'distrito_id' => 'nullable|string',
            'costo' => 'required|numeric|min:0',
            'activo' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $formaEnvio = FormaEnvio::findOrFail($id);

            // Verificar que no exista otra con la misma ubicación
            $existe = FormaEnvio::where('id', '!=', $id)
                ->where('departamento_id', $request->departamento_id)
                ->where('provincia_id', $request->provincia_id)
                ->where('distrito_id', $request->distrito_id)
                ->exists();

            if ($existe) {
                return response()->json([
                    'success' => false,
                    'message' => 'Ya existe otra forma de envío para esta ubicación'
                ], 422);
            }

            $formaEnvio->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Forma de envío actualizada correctamente',
                'forma_envio' => $formaEnvio
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar forma de envío: ' . $e->getMessage()
            ], 500);
        }
    }

    // Toggle activo/inactivo
    public function toggleEstado($id)
    {
        try {
            $formaEnvio = FormaEnvio::findOrFail($id);
            $formaEnvio->activo = !$formaEnvio->activo;
            $formaEnvio->save();

            return response()->json([
                'success' => true,
                'message' => 'Estado actualizado correctamente',
                'forma_envio' => $formaEnvio
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al cambiar estado: ' . $e->getMessage()
            ], 500);
        }
    }

    // Eliminar forma de envío
    public function destroy($id)
    {
        try {
            $formaEnvio = FormaEnvio::findOrFail($id);
            $formaEnvio->delete();

            return response()->json([
                'success' => true,
                'message' => 'Forma de envío eliminada correctamente'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al eliminar forma de envío: ' . $e->getMessage()
            ], 500);
        }
    }
}
