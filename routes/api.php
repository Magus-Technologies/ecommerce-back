<?php
// routes/api.php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\BannersController;
use App\Http\Controllers\BannersPromocionalesController;
use App\Http\Controllers\MarcaProductoController;
use App\Http\Controllers\UsuariosController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\DocumentTypeController;
use App\Http\Controllers\UbigeoController;
use App\Http\Controllers\UserRegistrationController;
use App\Http\Controllers\CategoriasController;
use App\Http\Controllers\ProductosController;
use App\Http\Controllers\VentasController;
use App\Http\Middleware\CheckPermission;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ReniecController;
use App\Http\Controllers\ClientesController;

Route::aliasMiddleware('permission', CheckPermission::class);

Route::post('/login', [AdminController::class, 'login']);
Route::post('/register', [AdminController::class, 'register']); 

// Rutas para tipos de documentos
Route::get('/document-types', [DocumentTypeController::class, 'getDocumentTypes']);

Route::get('/reniec/buscar/{doc}', [ReniecController::class, 'buscar']);
// Rutas para ubigeo
Route::get('/departamentos', [UbigeoController::class, 'getDepartamentos']);
Route::get('/categorias/publicas', [CategoriasController::class, 'categoriasPublicas']);
Route::get('provincias/{departamentoId}', [UbigeoController::class, 'getProvincias']);
Route::get('distritos/{deparatamentoId}/{provinciaId}', [UbigeoController::class, 'getDistritos']);

Route::get('/productos-publicos', [ProductosController::class, 'productosPublicos']);
Route::get('/categorias-sidebar', [ProductosController::class, 'categoriasParaSidebar']);
Route::get('/banners/publicos', [BannersController::class, 'bannersPublicos']);
Route::get('/banners-promocionales/publicos', [BannersPromocionalesController::class, 'bannersPromocionalesPublicos']);
Route::get('/marcas/publicas', [MarcaProductoController::class, 'marcasPublicas']);


Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user', [AdminController::class, 'user']);
    Route::get('/refresh-permissions', [AdminController::class, 'refreshPermissions']); // ← NUEVO
    Route::post('/logout', [AdminController::class, 'logout']);

      // NUEVAS RUTAS DE VENTAS
    Route::prefix('ventas')->group(function () {
        Route::get('/', [VentasController::class, 'index']);
        Route::post('/', [VentasController::class, 'store']);
        Route::get('/estadisticas', [VentasController::class, 'estadisticas']);
        Route::get('/mis-ventas', [VentasController::class, 'misVentas']); // Para clientes e-commerce
        Route::post('/ecommerce', [VentasController::class, 'crearVentaEcommerce']); // Para carrito
        Route::get('/{id}', [VentasController::class, 'show']);
        Route::post('/{id}/facturar', [VentasController::class, 'facturar']);
        Route::patch('/{id}/anular', [VentasController::class, 'anular']);
    });


    // Rutas de usuarios protegidas con permiso usuarios.ver
    Route::middleware('permission:usuarios.ver')->group(function () {
        Route::get('/usuarios', [UsuariosController::class, 'index']);
        Route::get('/usuarios/{id}', [UsuariosController::class, 'show'])->middleware('permission:usuarios.show');
        Route::put('/usuarios/{id}', [UsuariosController::class, 'update'])->middleware('permission:usuarios.edit');
        Route::delete('/usuarios/{id}', [UsuariosController::class, 'destroy'])->middleware('permission:usuarios.delete');
        Route::post('/usuarios/register', [UserRegistrationController::class, 'store'])->middleware('permission:usuarios.create');
    });

    
    Route::get('/permissions', [RoleController::class, 'getPermissions']);
    Route::get('/roles/{id}/permissions', [RoleController::class, 'getRolePermissions']);
    Route::put('/roles/{id}/permissions', [RoleController::class, 'updateRolePermissions']);
    Route::post('/roles', [RoleController::class, 'store']);
    Route::delete('/roles/{id}', [RoleController::class, 'destroy']);



    Route::get('/roles', [RoleController::class, 'getRoles']);

    // Rutas para categorías
    Route::get('/categorias', [CategoriasController::class, 'index']);
    Route::post('/categorias', [CategoriasController::class, 'store']);
    Route::get('/categorias/{id}', [CategoriasController::class, 'show']);
    Route::put('/categorias/{id}', [CategoriasController::class, 'update']); // POST para manejar archivos
    Route::delete('/categorias/{id}', [CategoriasController::class, 'destroy']);
     Route::patch('/categorias/{id}/toggle-estado', [CategoriasController::class, 'toggleEstado']);

   // Rutas para marcas
Route::get('/marcas', [MarcaProductoController::class, 'index']);
Route::get('/marcas/activas', [MarcaProductoController::class, 'marcasActivas']); // ← MOVER ANTES
Route::post('/marcas', [MarcaProductoController::class, 'store']);
Route::get('/marcas/{id}', [MarcaProductoController::class, 'show']); // ← DESPUÉS
Route::put('/marcas/{id}', [MarcaProductoController::class, 'update']);
Route::delete('/marcas/{id}', [MarcaProductoController::class, 'destroy']);
Route::patch('/marcas/{id}/toggle-estado', [MarcaProductoController::class, 'toggleEstado']);


    // Rutas para productos

    Route::get('/productos/stock/bajo', [ProductosController::class, 'stockBajo']);
    Route::get('/productos/estadisticas', [ProductosController::class, 'estadisticasDashboard']);
    Route::get('/productos/stock-critico', [ProductosController::class, 'productosStockCritico']);

    Route::get('/productos', [ProductosController::class, 'index']);
    Route::post('/productos', [ProductosController::class, 'store']);
    Route::get('/productos/{id}', [ProductosController::class, 'show']);
    Route::put('/productos/{id}', [ProductosController::class, 'update']); // POST para manejar archivos
    Route::delete('/productos/{id}', [ProductosController::class, 'destroy']);
    Route::patch('/productos/{id}/toggle-estado', [ProductosController::class, 'toggleEstado']);


    // Protección de rutas del módulo banners con sus respectivos permisos
    Route::middleware('permission:banners.ver')->group(function () {
        Route::get('/banners', [BannersController::class, 'index']);
        Route::get('/banners/{id}', [BannersController::class, 'show']);
    });

    Route::middleware('permission:banners.create')->group(function () {
        Route::post('/banners', [BannersController::class, 'store']);
    });

    Route::middleware('permission:banners.edit')->group(function () {
        Route::post('/banners/{id}', [BannersController::class, 'update']); // POST para manejar archivos
        Route::patch('/banners/{id}/toggle-estado', [BannersController::class, 'toggleEstado']);
    });

    Route::middleware('permission:banners.delete')->group(function () {
        Route::delete('/banners/{id}', [BannersController::class, 'destroy']);
    });

    // Reordenar no tiene un permiso específico, se asume que está incluido en banners.edit o se deja sin protección
    Route::post('/banners/reordenar', [BannersController::class, 'reordenar']);


    
    // Protección de rutas del módulo banners promocionales con sus respectivos permisos
    Route::middleware('permission:banners_promocionales.ver')->group(function () {
        Route::get('/banners-promocionales', [BannersPromocionalesController::class, 'index']);
        Route::get('/banners-promocionales/{id}', [BannersPromocionalesController::class, 'show']); // Sin permiso específico, queda dentro de .ver
    });

    Route::middleware('permission:banners_promocionales.create')->group(function () {
        Route::post('/banners-promocionales', [BannersPromocionalesController::class, 'store']);
    });

    Route::middleware('permission:banners_promocionales.edit')->group(function () {
        Route::post('/banners-promocionales/{id}', [BannersPromocionalesController::class, 'update']);
        Route::patch('/banners-promocionales/{id}/toggle-estado', [BannersPromocionalesController::class, 'toggleEstado']);
    });

    Route::middleware('permission:banners_promocionales.delete')->group(function () {
        Route::delete('/banners-promocionales/{id}', [BannersPromocionalesController::class, 'destroy']);
    });

    // Rutas de clientes protegidas con permisos
    Route::middleware('permission:clientes.ver')->group(function () {
        Route::get('/clientes', [ClientesController::class, 'index']);
        Route::get('/clientes/estadisticas', [ClientesController::class, 'estadisticas']);
        
    });

    Route::middleware('permission:clientes.show')->group(function(){
        Route::get('/clientes/{id}', [ClientesController::class, 'show']);
    });

    Route::middleware('permission:clientes.edit')->group(function () {
        Route::put('/clientes/{id}', [ClientesController::class, 'update']);
        Route::patch('/clientes/{id}/toggle-estado', [ClientesController::class, 'toggleEstado']);
    });

    Route::middleware('permission:clientes.delete')->group(function () {
        Route::delete('/clientes/{id}', [ClientesController::class, 'destroy']);
    });
});

