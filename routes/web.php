<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController; 

Route::get('/', function () {
    return view('welcome');
});


// Agrupamos rutas con middleware de autenticación y rol (editado)
Route::middleware(['auth:sanctum', 'role:superadmin,admin'])->group(function () { // <-- agregado grupo middleware
    Route::get('/usuarios', [UsuarioController::class, 'index']); // <-- ruta protegida de usuarios (editado)
});

