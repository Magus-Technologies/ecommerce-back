<?php
// routes/api.php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\UsuariosController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\DocumentTypeController;
use App\Http\Controllers\UbigeoController;
use App\Http\Controllers\UserRegistrationController;
use App\Http\Controllers\CategoriasController;
use App\Http\Controllers\ProductosController;

use Illuminate\Support\Facades\Route;

Route::post('/login', [AdminController::class, 'login']);

// Rutas para tipos de documentos
Route::get('/document-types', [DocumentTypeController::class, 'getDocumentTypes']);

// Rutas para ubigeo
Route::get('/departamentos', [UbigeoController::class, 'getDepartamentos']);
Route::get('/categorias/publicas', [CategoriasController::class, 'categoriasPublicas']);
Route::get('provincias/{departamentoId}', [UbigeoController::class, 'getProvincias']);
Route::get('distritos/{deparatamentoId}/{provinciaId}', [UbigeoController::class, 'getDistritos']);

Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user', [AdminController::class, 'user']);
    Route::post('/logout', [AdminController::class, 'logout']);
    Route::get('/usuarios', [UsuariosController::class, 'index']);
    Route::get('/roles', [RoleController::class, 'getRoles']);
    Route::post('/usuarios/register', [UserRegistrationController::class, 'store']);
    
    // Rutas para categorías
    Route::get('/categorias', [CategoriasController::class, 'index']);
    Route::post('/categorias', [CategoriasController::class, 'store']);
    Route::get('/categorias/{id}', [CategoriasController::class, 'show']);
    Route::post('/categorias/{id}', [CategoriasController::class, 'update']); // POST para manejar archivos
    Route::delete('/categorias/{id}', [CategoriasController::class, 'destroy']);
    
    // Rutas para productos
    Route::get('/productos', [ProductosController::class, 'index']);
    Route::post('/productos', [ProductosController::class, 'store']);
    Route::get('/productos/{id}', [ProductosController::class, 'show']);
    Route::post('/productos/{id}', [ProductosController::class, 'update']); // POST para manejar archivos
    Route::delete('/productos/{id}', [ProductosController::class, 'destroy']);
    Route::get('/productos/stock/bajo', [ProductosController::class, 'stockBajo']);

     Route::get('/usuarios/{id}', [UsuariosController::class, 'show']);
    Route::put('/usuarios/{id}', [UsuariosController::class, 'update']);
    Route::delete('/usuarios/{id}', [UsuariosController::class, 'destroy']);

});

// Buscar datos de RENIEC por DNI
// CORRECTO:
Route::get('reniec/buscar/{dni}', [UserRegistrationController::class, 'buscarDocInfo']); // ✅ corregido
