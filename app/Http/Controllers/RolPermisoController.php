<?php

namespace App\Http\Controllers;

use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Illuminate\Http\Request;

class RolPermisoController extends Controller
{
    
    public function index()
    {
        return response()->json([
            'roles' => Role::all(),
            'permisos' => Permission::all()
        ]);
    }

    public function update(Request $request, $roleId)
    {
        $role = Role::findOrFail($roleId);
        $role->syncPermissions($request->permisos); // array de permisos desde el front

        return response()->json(['message' => 'Permisos actualizados']);
    }
}
