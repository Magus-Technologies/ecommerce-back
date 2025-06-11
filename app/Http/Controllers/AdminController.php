<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AdminController extends Controller
{
    /**
     * Login del usuario y generación de token (versión segura)
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Intentar autenticación
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
                    'roles' => $user->getRoleNames(),
                    'permissions' => $user->getAllPermissions()->pluck('name'),
                ],
                'token' => $token,
            ]);
        }

        // Mensaje genérico para cualquier error de credenciales
        // No distinguimos entre usuario inexistente o contraseña incorrecta
        return response()->json([
            'message' => 'Las credenciales proporcionadas son incorrectas.',
            'errors' => [
                'email' => ['Las credenciales proporcionadas son incorrectas.']
            ]
        ], 401);
    }

    /**
     * Obtener información del usuario autenticado
     */
    public function user(Request $request)
    {
        $user = $request->user();
        $user->load('roles.permissions');

        return response()->json([
            'status' => 'success',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'roles' => $user->getRoleNames(),
                'permissions' => $user->getAllPermissions()->pluck('name'),
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
