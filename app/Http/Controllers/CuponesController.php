<?php

namespace App\Http\Controllers;

use App\Models\Cupon;
use Illuminate\Http\Request;

class CuponesController extends Controller
{
    public function index()
    {
        $cupones = Cupon::orderBy('created_at', 'desc')->get();
        return response()->json($cupones);
    }

    public function store(Request $request)
    {
        $request->validate([
            'codigo' => 'required|string|max:50|unique:cupones,codigo',
            'titulo' => 'required|string|max:255',
            'tipo_descuento' => 'required|in:porcentaje,cantidad_fija',
            'valor_descuento' => 'required|numeric|min:0',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'compra_minima' => 'nullable|numeric|min:0',
            'limite_uso' => 'nullable|integer|min:1'
        ]);

        $cupon = Cupon::create($request->all());

        return response()->json($cupon, 201);
    }

    public function show($id)
    {
        $cupon = Cupon::findOrFail($id);
        return response()->json($cupon);
    }

    public function update(Request $request, $id)
    {
        $cupon = Cupon::findOrFail($id);

        $request->validate([
            'codigo' => 'required|string|max:50|unique:cupones,codigo,' . $id,
            'titulo' => 'required|string|max:255',
            'tipo_descuento' => 'required|in:porcentaje,cantidad_fija',
            'valor_descuento' => 'required|numeric|min:0',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'compra_minima' => 'nullable|numeric|min:0',
            'limite_uso' => 'nullable|integer|min:1'
        ]);

        $cupon->update($request->all());

        return response()->json($cupon);
    }

    public function destroy($id)
    {
        $cupon = Cupon::findOrFail($id);
        $cupon->delete();

        return response()->json(['message' => 'Cupón eliminado correctamente']);
    }
}