<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class MenuController extends Controller
{
    // ============================================
    // MÉTODOS PÚBLICOS (sin autenticación)
    // ============================================

    /**
     * Obtener menús públicos (solo visibles) para el header
     */
    public function menusPublicos(Request $request)
    {
        try {
            $tipo = $request->query('tipo', 'header');

            $menus = Menu::obtenerMenusJerarquicos($tipo, true);

            return response()->json([
                'success' => true,
                'menus' => $menus
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener menús',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // ============================================
    // MÉTODOS ADMIN (requieren autenticación)
    // ============================================

    /**
     * Listar todos los menús (admin)
     */
    public function index(Request $request)
    {
        try {
            $tipo = $request->query('tipo', 'header');

            // Obtener todos los menús (incluyendo no visibles)
            $menus = Menu::obtenerMenusJerarquicos($tipo, false);

            // También obtener lista plana para la tabla
            $menusPlanos = Menu::porTipo($tipo)
                ->with('padre')
                ->ordenado()
                ->get()
                ->map(function ($menu) {
                    return [
                        'id' => $menu->id,
                        'nombre' => $menu->nombre,
                        'url' => $menu->url,
                        'icono' => $menu->icono,
                        'orden' => $menu->orden,
                        'padre_id' => $menu->padre_id,
                        'padre_nombre' => $menu->padre ? $menu->padre->nombre : null,
                        'tipo' => $menu->tipo,
                        'target' => $menu->target,
                        'visible' => $menu->visible,
                        'tiene_hijos' => $menu->tieneHijos(),
                        'es_submenu' => $menu->esSubmenu(),
                        'created_at' => $menu->created_at,
                        'updated_at' => $menu->updated_at,
                    ];
                });

            return response()->json([
                'success' => true,
                'menus' => $menusPlanos,
                'menus_jerarquicos' => $menus
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al listar menús',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear un nuevo menú
     */
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nombre' => 'required|string|max:100',
                'url' => 'required|string|max:255',
                'icono' => 'nullable|string|max:100',
                'orden' => 'required|integer|min:0',
                'padre_id' => 'nullable|exists:menus,id',
                'tipo' => 'required|in:header,footer,sidebar',
                'target' => 'required|in:_self,_blank',
                'visible' => 'required|boolean',
            ], [
                'nombre.required' => 'El nombre es requerido',
                'url.required' => 'La URL es requerida',
                'orden.required' => 'El orden es requerido',
                'orden.min' => 'El orden debe ser mayor o igual a 0',
                'padre_id.exists' => 'El menú padre no existe',
                'tipo.required' => 'El tipo es requerido',
                'tipo.in' => 'El tipo debe ser header, footer o sidebar',
                'target.required' => 'El target es requerido',
                'target.in' => 'El target debe ser _self o _blank',
                'visible.required' => 'El estado visible es requerido',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Error de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            $menu = Menu::create($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Menú creado exitosamente',
                'menu' => $menu
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al crear el menú',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar un menú específico
     */
    public function show($id)
    {
        try {
            $menu = Menu::with(['padre', 'hijos'])->findOrFail($id);

            return response()->json([
                'success' => true,
                'menu' => $menu
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Menú no encontrado',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Actualizar un menú
     */
    public function update(Request $request, $id)
    {
        try {
            $menu = Menu::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'nombre' => 'required|string|max:100',
                'url' => 'required|string|max:255',
                'icono' => 'nullable|string|max:100',
                'orden' => 'required|integer|min:0',
                'padre_id' => [
                    'nullable',
                    'exists:menus,id',
                    function ($attribute, $value, $fail) use ($id) {
                        // Evitar que un menú sea padre de sí mismo
                        if ($value == $id) {
                            $fail('Un menú no puede ser padre de sí mismo');
                        }
                    }
                ],
                'tipo' => 'required|in:header,footer,sidebar',
                'target' => 'required|in:_self,_blank',
                'visible' => 'required|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Error de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            $menu->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Menú actualizado exitosamente',
                'menu' => $menu
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar el menú',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Eliminar un menú
     */
    public function destroy($id)
    {
        try {
            $menu = Menu::findOrFail($id);

            // Verificar si tiene submenús
            if ($menu->tieneHijos()) {
                return response()->json([
                    'success' => false,
                    'message' => 'No se puede eliminar un menú que tiene submenús. Elimine los submenús primero.'
                ], 400);
            }

            $menu->delete();

            return response()->json([
                'success' => true,
                'message' => 'Menú eliminado exitosamente'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al eliminar el menú',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cambiar visibilidad de un menú
     */
    public function toggleVisibilidad($id)
    {
        try {
            $menu = Menu::findOrFail($id);
            $menu->visible = !$menu->visible;
            $menu->save();

            return response()->json([
                'success' => true,
                'message' => $menu->visible ? 'Menú activado' : 'Menú desactivado',
                'menu' => $menu
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al cambiar visibilidad',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Actualizar orden de múltiples menús
     */
    public function actualizarOrden(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'menus' => 'required|array',
                'menus.*.id' => 'required|exists:menus,id',
                'menus.*.orden' => 'required|integer|min:0',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Error de validación',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            foreach ($request->menus as $menuData) {
                Menu::where('id', $menuData['id'])->update(['orden' => $menuData['orden']]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Orden actualizado exitosamente'
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar el orden',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener menús para select (dropdown)
     */
    public function menusParaSelect(Request $request)
    {
        try {
            $tipo = $request->query('tipo', 'header');

            $menus = Menu::principales()
                ->porTipo($tipo)
                ->ordenado()
                ->get(['id', 'nombre']);

            return response()->json([
                'success' => true,
                'menus' => $menus
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener menús',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
