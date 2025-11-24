<?php

namespace App\Http\Controllers;

use App\Models\Cupon;
use App\Models\CuponUso;
use App\Models\UserCliente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

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

     /**
     * Obtener cupones activos para mostrar públicamente en la tienda
     */
    
    public function cuponesActivos()
    {
        try {
            
            $cupones = Cupon::where('activo', true)
                ->where('fecha_inicio', '<=', now())
                ->where('fecha_fin', '>=', now())
                ->where(function($query) {
                    $query->whereNull('limite_uso')
                        ->orWhereRaw('usos_actuales < limite_uso');
                })
                ->orderBy('created_at', 'desc')
                ->get();

            

            return response()->json($cupones);
            
        } catch (\Exception $e) {
            
            
            return response()->json([
                'error' => 'Error al obtener cupones',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener cupones disponibles para el usuario autenticado
     * Excluye los cupones que el usuario ya ha usado
     */
    public function cuponesDisponiblesUsuario(Request $request)
    {
        try {
            $authenticatedUser = $request->user();

            // Obtener todos los cupones activos
            $cuponesQuery = Cupon::where('activo', true)
                ->where('fecha_inicio', '<=', now())
                ->where('fecha_fin', '>=', now())
                ->where(function($query) {
                    $query->whereNull('limite_uso')
                        ->orWhereRaw('usos_actuales < limite_uso');
                });

            // Si el usuario está autenticado, excluir los cupones que ya usó
            if ($authenticatedUser && $authenticatedUser instanceof UserCliente) {
                $cuponesUsados = CuponUso::where('user_cliente_id', $authenticatedUser->id)
                    ->pluck('cupon_id')
                    ->toArray();

                if (!empty($cuponesUsados)) {
                    $cuponesQuery->whereNotIn('id', $cuponesUsados);
                }
            }

            $cupones = $cuponesQuery->orderBy('created_at', 'desc')->get();

            return response()->json($cupones);

        } catch (\Exception $e) {
            Log::error('Error al obtener cupones disponibles para usuario: ' . $e->getMessage());

            return response()->json([
                'error' => 'Error al obtener cupones',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Registrar el uso de un cupón cuando se completa una venta
     */
    public function registrarUsoCupon(Request $request)
    {
        $request->validate([
            'cupon_id' => 'required|exists:cupones,id',
            'descuento_aplicado' => 'required|numeric|min:0',
            'total_compra' => 'required|numeric|min:0',
            'venta_id' => 'nullable|exists:ventas,id'
        ]);

        try {
            $authenticatedUser = $request->user();

            if (!$authenticatedUser || !($authenticatedUser instanceof UserCliente)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Usuario no autenticado o no es cliente'
                ], 401);
            }

            $cuponId = $request->input('cupon_id');
            $userClienteId = $authenticatedUser->id;

            // Verificar que no haya usado el cupón antes
            if (CuponUso::clienteYaUsoCupon($cuponId, $userClienteId)) {
                return response()->json([
                    'success' => false,
                    'message' => 'El cliente ya ha usado este cupón'
                ], 400);
            }

            // Registrar el uso
            $cuponUso = CuponUso::registrarUso(
                $cuponId,
                $userClienteId,
                $request->input('descuento_aplicado'),
                $request->input('total_compra'),
                $request->input('venta_id')
            );

            // Incrementar el contador de usos del cupón
            $cupon = Cupon::find($cuponId);
            if ($cupon) {
                $cupon->incrementarUso();
            }

            return response()->json([
                'success' => true,
                'message' => 'Uso de cupón registrado correctamente',
                'cupon_uso' => $cuponUso
            ]);

        } catch (\Exception $e) {
            Log::error('Error al registrar uso de cupón: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Error al registrar el uso del cupón'
            ], 500);
        }
    }
}