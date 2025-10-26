<?php

namespace App\Http\Controllers\Contabilidad;

use App\Http\Controllers\Controller;
use App\Models\CajaChica;
use App\Models\CajaChicaMovimiento;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CajaChicaController extends Controller
{
    public function index()
    {
        $cajas = CajaChica::with('responsable')->get();
        return response()->json($cajas);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nombre' => 'required|string|max:100',
            'codigo' => 'required|string|max:20|unique:caja_chica',
            'fondo_fijo' => 'required|numeric|min:0',
            'responsable_id' => 'required|exists:users,id'
        ]);

        $caja = CajaChica::create([
            ...$request->all(),
            'saldo_actual' => $request->fondo_fijo
        ]);

        return response()->json($caja, 201);
    }

    public function registrarGasto(Request $request)
    {
        $request->validate([
            'caja_chica_id' => 'required|exists:caja_chica,id',
            'fecha' => 'required|date',
            'monto' => 'required|numeric|min:0',
            'categoria' => 'required|string',
            'descripcion' => 'required|string',
            'comprobante_tipo' => 'nullable|string',
            'comprobante_numero' => 'nullable|string',
            'proveedor' => 'nullable|string'
        ]);

        DB::beginTransaction();
        try {
            $caja = CajaChica::findOrFail($request->caja_chica_id);

            if ($request->monto > $caja->saldo_actual) {
                return response()->json(['error' => 'Saldo insuficiente en caja chica'], 400);
            }

            $movimiento = CajaChicaMovimiento::create([
                ...$request->all(),
                'tipo' => 'GASTO',
                'user_id' => auth()->id()
            ]);

            $caja->decrement('saldo_actual', $request->monto);

            DB::commit();
            return response()->json($movimiento, 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function reposicion(Request $request, $id)
    {
        $request->validate([
            'monto' => 'required|numeric|min:0'
        ]);

        DB::beginTransaction();
        try {
            $caja = CajaChica::findOrFail($id);

            CajaChicaMovimiento::create([
                'caja_chica_id' => $caja->id,
                'tipo' => 'REPOSICION',
                'fecha' => now()->toDateString(),
                'monto' => $request->monto,
                'categoria' => 'REPOSICION',
                'descripcion' => 'Reposición de fondo de caja chica',
                'estado' => 'APROBADO',
                'user_id' => auth()->id(),
                'aprobado_por' => auth()->id(),
                'aprobado_at' => now()
            ]);

            $caja->increment('saldo_actual', $request->monto);

            DB::commit();
            return response()->json(['message' => 'Reposición registrada correctamente']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function rendicion($id, Request $request)
    {
        $caja = CajaChica::findOrFail($id);

        $query = CajaChicaMovimiento::where('caja_chica_id', $id);

        if ($request->fecha_inicio) {
            $query->where('fecha', '>=', $request->fecha_inicio);
        }

        if ($request->fecha_fin) {
            $query->where('fecha', '<=', $request->fecha_fin);
        }

        $movimientos = $query->orderBy('fecha')->get();

        $gastos = $movimientos->where('tipo', 'GASTO')->sum('monto');
        $reposiciones = $movimientos->where('tipo', 'REPOSICION')->sum('monto');

        return response()->json([
            'caja' => $caja,
            'movimientos' => $movimientos,
            'resumen' => [
                'fondo_fijo' => $caja->fondo_fijo,
                'total_gastos' => $gastos,
                'total_reposiciones' => $reposiciones,
                'saldo_actual' => $caja->saldo_actual
            ]
        ]);
    }
}
