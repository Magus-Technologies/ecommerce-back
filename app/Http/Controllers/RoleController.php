<?php

namespace App\Http\Controllers;

use App\Models\Role;
use Illuminate\Http\Request;

class RoleController extends Controller
{
    public function getRoles()
    {
        try {
            $roles = Role::select('id', 'nombre')->get();
            return response()->json($roles);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al cargar roles'], 500);
        }
    }
}
