<?php

namespace App\Http\Controllers;

use App\Models\UbigeoInei;
use Illuminate\Http\Request;

class UbigeoController extends Controller
{
    // Busca esta función y reemplázala completamente:
    public function getDepartamentos()
    {
        try {
            $departamentos = UbigeoInei::where('provincia', '00')
                ->where('distrito', '00')
                ->select('departamento as id', 'nombre', 'id_ubigeo') // ← AGREGADO id_ubigeo
                ->orderBy('nombre')
                ->get();
                        
            return response()->json($departamentos);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al cargar departamentos'], 500);
        }
    }

    // Busca esta función y reemplázala completamente:
    public function getProvincias($departamentoId)
    {
        try {
            $provincias = UbigeoInei::where('departamento', $departamentoId)
                ->where('distrito', '00')
                ->where('provincia', '!=', '00')
                ->select('provincia as id', 'nombre', 'id_ubigeo') // ← AGREGADO id_ubigeo
                ->orderBy('nombre')
                ->get();
                        
            return response()->json($provincias);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al cargar provincias'], 500);
        }
    }

    // Busca esta función y reemplázala completamente:
    public function getDistritos($departamentoId, $provinciaId) 
    {
        try {
            $distritos = UbigeoInei::where('departamento', $departamentoId)
                ->where('provincia', $provinciaId)
                ->where('distrito', '!=', '00')
                ->select('distrito as id', 'nombre', 'id_ubigeo') // ← AGREGADO id_ubigeo
                ->orderBy('nombre')
                ->get();
                    
            return response()->json($distritos);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al cargar distritos'], 500);
        }
    }
}
