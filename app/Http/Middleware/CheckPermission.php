<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckPermission
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $permission): Response
    {
        if (!$request->user() || !$request->user()->hasPermissionTo($permission)) {
            return response()->json([
                'status' => 'error',
                'message' => 'No tiene permiso para acceder a este recurso',
                'required_permission' => $permission,
            ], 403);
        }

        return $next($request);
    }
}
