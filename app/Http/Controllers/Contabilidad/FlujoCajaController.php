<?php

namespace App\Http\Controllers\Contabilidad;

use App\Http\Controllers\Controller;
use App\Models\FlujoCajaProyeccion;
use Illuminate\Http\Request;
use Carbon\Carbon;

class FlujoCajaController extends Controller
{
    public function index(Request $request)
    {
        $fechaInicio = $request->fecha_inicio ?? now()->startOfMonth()->toDateString();
        $fechaFin = $request->fecha_fin ?? now()->endOfMonth()->toDateString();

        $proyecciones = FlujoCajaProyeccion::whereBetween('fecha', [$fechaInicio, $fechaFin])
            ->orderBy('fecha')
            ->get();

        $ingresos = $proyecciones->where('tipo', 'INGRESO');
        $egresos = $proyecciones->where('tipo', 'EGRESO');

        return response()->json([
            'proyecciones' => $proyecciones,
            'resumen' => [
                'total_ingresos_proyectados' => $ingresos->sum('monto_proyectado'),
                'total_egresos_proyectados' => $egresos->sum('monto_proyectado'),
                'total_ingresos_reales' => $ingresos->sum('monto_real'),
                'total_egresos_reales' => $egresos->sum('monto_real'),
                'saldo_proyectado' => $ingresos->sum('monto_proyectado') - $egresos->sum('monto_proyectado'),
                'saldo_real' => $ingresos->sum('monto_real') - $egresos->sum('monto_real')
            ]
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'fecha' => 'required|date',
            'tipo' => 'required|in:INGRESO,EGRESO',
            'concepto' => 'required|string',
            'monto_proyectado' => 'required|numeric|min:0',
            'categoria' => 'required|string',
            'recurrente' => 'boolean',
            'frecuencia' => 'nullable|string'
        ]);

        $proyeccion = FlujoCajaProyeccion::create([
            ...$request->all(),
            'user_id' => auth()->id()
        ]);

        return response()->json($proyeccion, 201);
    }

    public function registrarReal(Request $request, $id)
    {
        $request->validate([
            'monto_real' => 'required|numeric|min:0'
        ]);

        $proyeccion = FlujoCajaProyeccion::findOrFail($id);
        $proyeccion->update([
            'monto_real' => $request->monto_real,
            'estado' => 'REALIZADO'
        ]);

        return response()->json($proyeccion);
    }

    public function proyeccionMensual(Request $request)
    {
        $mes = $request->mes ?? now()->month;
        $anio = $request->anio ?? now()->year;

        $fechaInicio = Carbon::create($anio, $mes, 1)->startOfMonth();
        $fechaFin = Carbon::create($anio, $mes, 1)->endOfMonth();

        $proyecciones = FlujoCajaProyeccion::whereBetween('fecha', [$fechaInicio, $fechaFin])
            ->orderBy('fecha')
            ->get();

        $saldoInicial = 0; // Aquí podrías obtener el saldo real de caja
        $saldoAcumulado = $saldoInicial;

        $flujo = $proyecciones->map(function ($p) use (&$saldoAcumulado) {
            $monto = $p->tipo === 'INGRESO' ? $p->monto_proyectado : -$p->monto_proyectado;
            $saldoAcumulado += $monto;

            return [
                'fecha' => $p->fecha,
                'concepto' => $p->concepto,
                'tipo' => $p->tipo,
                'monto' => abs($monto),
                'saldo_acumulado' => $saldoAcumulado
            ];
        });

        return response()->json([
            'saldo_inicial' => $saldoInicial,
            'flujo' => $flujo,
            'saldo_final' => $saldoAcumulado
        ]);
    }
}
