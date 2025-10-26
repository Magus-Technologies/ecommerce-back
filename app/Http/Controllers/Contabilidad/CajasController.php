<?php

namespace App\Http\Controllers\Contabilidad;

use App\Http\Controllers\Controller;
use App\Models\Caja;
use App\Models\CajaMovimiento;
use App\Models\CajaTransaccion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CajasController extends Controller
{
    // Listar cajas
    public function index()
    {
        $cajas = Caja::with(['tienda', 'movimientoActual'])->get();
        return response()->json($cajas);
    }

    // Crear caja
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'required|string|max:100',
            'codigo' => 'required|string|max:20|unique:cajas',
            'tienda_id' => 'nullable|exists:tiendas,id'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $caja = Caja::create($request->all());
        return response()->json($caja, 201);
    }

    // Aperturar caja
    public function aperturar(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'caja_id' => 'required|exists:cajas,id',
            'monto_inicial' => 'required|numeric|min:0',
            'observaciones' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Verificar que no haya caja abierta
        $cajaAbierta = CajaMovimiento::where('caja_id', $request->caja_id)
            ->where('estado', 'ABIERTA')
            ->exists();

        if ($cajaAbierta) {
            return response()->json(['error' => 'Ya existe una caja abierta'], 400);
        }

        $movimiento = CajaMovimiento::create([
            'caja_id' => $request->caja_id,
            'user_id' => auth()->id(),
            'tipo' => 'APERTURA',
            'fecha' => now()->toDateString(),
            'hora' => now()->toTimeString(),
            'monto_inicial' => $request->monto_inicial,
            'observaciones' => $request->observaciones,
            'estado' => 'ABIERTA'
        ]);

        return response()->json($movimiento, 201);
    }

    // Cerrar caja
    public function cerrar(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'monto_final' => 'required|numeric|min:0',
            'observaciones' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $movimiento = CajaMovimiento::findOrFail($id);

        if ($movimiento->estado !== 'ABIERTA') {
            return response()->json(['error' => 'La caja ya está cerrada'], 400);
        }

        // Calcular monto del sistema
        $ingresos = $movimiento->transacciones()->where('tipo', 'INGRESO')->sum('monto');
        $egresos = $movimiento->transacciones()->where('tipo', 'EGRESO')->sum('monto');
        $montoSistema = $movimiento->monto_inicial + $ingresos - $egresos;

        $movimiento->update([
            'tipo' => 'CIERRE',
            'monto_final' => $request->monto_final,
            'monto_sistema' => $montoSistema,
            'diferencia' => $request->monto_final - $montoSistema,
            'observaciones' => $request->observaciones,
            'estado' => 'CERRADA'
        ]);

        return response()->json($movimiento);
    }

    // Registrar transacción
    public function registrarTransaccion(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'caja_movimiento_id' => 'required|exists:caja_movimientos,id',
            'tipo' => 'required|in:INGRESO,EGRESO',
            'categoria' => 'required|in:VENTA,COBRO,GASTO,RETIRO,OTRO',
            'monto' => 'required|numeric|min:0',
            'metodo_pago' => 'required|string',
            'descripcion' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $transaccion = CajaTransaccion::create([
            ...$request->all(),
            'user_id' => auth()->id()
        ]);

        return response()->json($transaccion, 201);
    }

    // Reporte de caja
    public function reporte($id)
    {
        $movimiento = CajaMovimiento::with(['caja', 'user', 'transacciones'])->findOrFail($id);

        $ingresos = $movimiento->transacciones()->where('tipo', 'INGRESO')->sum('monto');
        $egresos = $movimiento->transacciones()->where('tipo', 'EGRESO')->sum('monto');

        return response()->json([
            'movimiento' => $movimiento,
            'resumen' => [
                'monto_inicial' => $movimiento->monto_inicial,
                'total_ingresos' => $ingresos,
                'total_egresos' => $egresos,
                'monto_sistema' => $movimiento->monto_inicial + $ingresos - $egresos,
                'monto_final' => $movimiento->monto_final,
                'diferencia' => $movimiento->diferencia
            ]
        ]);
    }
}
