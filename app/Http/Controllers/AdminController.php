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
                'user' => $user->load('role'), // Agregamos el usuario con su rol
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
    public function user(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'status' => 'success',
            'user' => $user->load('role'), // CARGA relación role para que venga con el usuario // MODIFICADO
            'role' => $user->role->nombre ?? null, 
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


