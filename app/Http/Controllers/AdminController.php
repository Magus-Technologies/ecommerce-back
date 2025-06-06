<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AdminController extends Controller
{
    /**
     * Login del usuario y generación de token
     */
 // AdminController.php - método login
  // In App\Http\Controllers\AdminController.php - Replace the login method
public function login(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
    ]);

    if (Auth::attempt($request->only('email', 'password'))) {
        $user = Auth::user();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Login exitoso',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'roles' => $user->getRoleNames(), // Obtener roles usando Spatie
                'permissions' => $user->getAllPermissions()->pluck('name'), // Obtener permisos usando Spatie
            ],
            'token' => $token,
        ]);
    }

    throw ValidationException::withMessages([
        'email' => ['Las credenciales proporcionadas son incorrectas.'],
    ]);
}



    /**
     * Obtener información del usuario autenticado
     */
    // In App\Http\Controllers\AdminController.php - Replace the user method
    public function user(Request $request)
    {
        $user = $request->user();

        // Cargar relaciones de roles y permisos para evitar consultas múltiples
        $user->load('roles.permissions');

        return response()->json([
            'status' => 'success',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'roles' => $user->getRoleNames(), // Obtener roles usando Spatie
                'permissions' => $user->getAllPermissions()->pluck('name'), // Obtener permisos usando Spatie
            ],
        ]);
    }


    /**
     * Cerrar sesión (revocar token)
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Logout exitoso',
        ]);
    }
}


