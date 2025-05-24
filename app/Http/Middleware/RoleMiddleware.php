<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        // Asegurarse que el usuario esté autenticado y tenga el rol cargado
        $user = $request->user(); // // MODIFICADO: guardamos usuario

        if (!$user || !$user->role) { // MODIFICADO: verificamos que role exista
            return response()->json(['message' => 'No autorizado'], 403);
        }

        // Compara el nombre del rol en la relación con los roles permitidos
        if (!in_array($user->role->nombre, $roles)) { // MODIFICADO: acceso a $user->role->nombre
            return response()->json(['message' => 'No autorizado'], 403);
        }

        return $next($request);
    }
}
