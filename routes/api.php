<?php
// routes/api.php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\BannersController;
use App\Http\Controllers\BannersPromocionalesController;
use App\Http\Controllers\UsuariosController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\DocumentTypeController;
use App\Http\Controllers\UbigeoController;
use App\Http\Controllers\UserRegistrationController;
use App\Http\Controllers\CategoriasController;
use App\Http\Controllers\ProductosController;
use App\Http\Middleware\CheckPermission;
use Illuminate\Support\Facades\Route;

Route::aliasMiddleware('permission', CheckPermission::class);

Route::post('/login', [AdminController::class, 'login']);

// Rutas para tipos de documentos
Route::get('/document-types', [DocumentTypeController::class, 'getDocumentTypes']);

// Rutas para ubigeo
Route::get('/departamentos', [UbigeoController::class, 'getDepartamentos']);
Route::get('/categorias/publicas', [CategoriasController::class, 'categoriasPublicas']);
Route::get('provincias/{departamentoId}', [UbigeoController::class, 'getProvincias']);
Route::get('distritos/{deparatamentoId}/{provinciaId}', [UbigeoController::class, 'getDistritos']);

Route::get('/productos-publicos', [ProductosController::class, 'productosPublicos']);
Route::get('/categorias-sidebar', [ProductosController::class, 'categoriasParaSidebar']);
Route::get('/banners/publicos', [BannersController::class, 'bannersPublicos']);
Route::get('/banners-promocionales/publicos', [BannersPromocionalesController::class, 'bannersPromocionalesPublicos']);
Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user', [AdminController::class, 'user']);
    Route::get('/refresh-permissions', [AdminController::class, 'refreshPermissions']); // ← NUEVO
    Route::post('/logout', [AdminController::class, 'logout']);

    // Rutas de usuarios protegidas con permiso usuarios.ver
    Route::middleware('permission:usuarios.ver')->group(function () {
        Route::get('/usuarios', [UsuariosController::class, 'index']);
        Route::get('/usuarios/{id}', [UsuariosController::class, 'show']);
        Route::put('/usuarios/{id}', [UsuariosController::class, 'update']);
        Route::delete('/usuarios/{id}', [UsuariosController::class, 'destroy']);
        Route::post('/usuarios/register', [UserRegistrationController::class, 'store']);
    });
    Route::get('/permissions', [RoleController::class, 'getPermissions']);
    Route::get('/roles/{id}/permissions', [RoleController::class, 'getRolePermissions']);
    Route::put('/roles/{id}/permissions', [RoleController::class, 'updateRolePermissions']);
    Route::post('/roles', [RoleController::class, 'store']);
    Route::delete('/roles/{id}', [RoleController::class, 'destroy']);



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

    Route::get('/banners', [BannersController::class, 'index']);
    Route::post('/banners', [BannersController::class, 'store']);
    Route::get('/banners/{id}', [BannersController::class, 'show']);
    Route::post('/banners/{id}', [BannersController::class, 'update']); // POST para manejar archivos
    Route::delete('/banners/{id}', [BannersController::class, 'destroy']);
    Route::patch('/banners/{id}/toggle-estado', [BannersController::class, 'toggleEstado']);
    Route::post('/banners/reordenar', [BannersController::class, 'reordenar']);

    Route::get('/banners-promocionales', [BannersPromocionalesController::class, 'index']);
    Route::post('/banners-promocionales', [BannersPromocionalesController::class, 'store']);
    Route::get('/banners-promocionales/{id}', [BannersPromocionalesController::class, 'show']);
    Route::post('/banners-promocionales/{id}', [BannersPromocionalesController::class, 'update']);
    Route::delete('/banners-promocionales/{id}', [BannersPromocionalesController::class, 'destroy']);
    Route::patch('/banners-promocionales/{id}/toggle-estado', [BannersPromocionalesController::class, 'toggleEstado']);
});

