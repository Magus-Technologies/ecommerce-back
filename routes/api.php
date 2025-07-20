<?php
// routes/api.php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\BannersController;
use App\Http\Controllers\BannersPromocionalesController;
use App\Http\Controllers\CuponesController;
use App\Http\Controllers\MarcaProductoController;
use App\Http\Controllers\OfertasController;
use App\Http\Controllers\ProductoDetallesController;
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
use App\Http\Controllers\PedidosController;
use App\Http\Controllers\PasswordResetController;
use App\Http\Controllers\HorariosController;
use App\Http\Controllers\EmailVerificationController;


Route::aliasMiddleware('permission', CheckPermission::class);

Route::post('/login', [AdminController::class, 'login']);
Route::post('/register', [AdminController::class, 'register']); 
Route::post('/check-email', [AdminController::class, 'checkEmail']);
Route::post('/check-documento', [AdminController::class, 'checkDocumento']);
// Rutas para tipos de documentos
Route::get('/document-types', [DocumentTypeController::class, 'getDocumentTypes']);

Route::get('/reniec/buscar/{doc}', [ReniecController::class, 'buscar']);
// Rutas para ubigeo
Route::get('/departamentos', [UbigeoController::class, 'getDepartamentos']);
Route::get('/categorias/publicas', [CategoriasController::class, 'categoriasPublicas']);
Route::get('provincias/{departamentoId}', [UbigeoController::class, 'getProvincias']);
Route::get('distritos/{deparatamentoId}/{provinciaId}', [UbigeoController::class, 'getDistritos']);

Route::get('/productos-publicos', [ProductosController::class, 'productosPublicos']);
Route::get('/productos-publicos/{id}', [ProductosController::class, 'showPublico']);
Route::get('/productos/buscar', [ProductosController::class, 'buscarProductos']);
Route::get('/categorias-sidebar', [ProductosController::class, 'categoriasParaSidebar']);
Route::get('/banners/publicos', [BannersController::class, 'bannersPublicos']);
Route::get('/banners-promocionales/publicos', [BannersPromocionalesController::class, 'bannersPromocionalesPublicos']);
Route::get('/marcas/publicas', [MarcaProductoController::class, 'marcasPublicas']);

// Rutas públicas para ofertas
Route::get('/ofertas/publicas', [OfertasController::class, 'ofertasPublicas']);
Route::get('/ofertas/flash-sales', [OfertasController::class, 'flashSales']);
Route::get('/ofertas/productos', [OfertasController::class, 'productosEnOferta']);
// ✅ NUEVA RUTA: Oferta principal del día
Route::get('/ofertas/principal-del-dia', [OfertasController::class, 'ofertaPrincipalDelDia']);
Route::post('/cupones/validar', [OfertasController::class, 'validarCupon']);
Route::get('/cupones/activos', [CuponesController::class, 'cuponesActivos']); // NUEVA LÍNEA


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

  // Productos - Protección con permisos
    Route::middleware('permission:productos.ver')->group(function () {
        Route::get('/productos', [ProductosController::class, 'index']);
        Route::get('/productos/stock/bajo', [ProductosController::class, 'stockBajo']);
        Route::get('/productos/estadisticas', [ProductosController::class, 'estadisticasDashboard']);
        Route::get('/productos/stock-critico', [ProductosController::class, 'productosStockCritico']);
        Route::get('/productos/{id}', [ProductosController::class, 'show']);
        Route::get('/productos/{id}/detalles', [ProductoDetallesController::class, 'show']);
    });

    Route::middleware('permission:productos.create')->group(function () {
        Route::post('/productos', [ProductosController::class, 'store']);
    });

    Route::middleware('permission:productos.edit')->group(function () {
        Route::put('/productos/{id}', [ProductosController::class, 'update']);
        Route::patch('/productos/{id}/toggle-estado', [ProductosController::class, 'toggleEstado']);

         Route::post('/productos/{id}/detalles', [ProductoDetallesController::class, 'store']);
        Route::post('/productos/{id}/detalles/imagenes', [ProductoDetallesController::class, 'agregarImagenes']);
        Route::delete('/productos/{id}/detalles/imagenes', [ProductoDetallesController::class, 'eliminarImagen']);
    });

    Route::middleware('permission:productos.delete')->group(function () {
        Route::delete('/productos/{id}', [ProductosController::class, 'destroy']);
    });

    // Categorías - Protección con permisos
    Route::middleware('permission:categorias.ver')->group(function () {
        Route::get('/categorias', [CategoriasController::class, 'index']);
        Route::get('/categorias/{id}', [CategoriasController::class, 'show']);
    });

    Route::middleware('permission:categorias.create')->group(function () {
        Route::post('/categorias', [CategoriasController::class, 'store']);
    });

    // ✅ RUTAS PROTEGIDAS PARA OFERTAS Y CUPONES
    Route::middleware('permission:ofertas.ver')->group(function () {
        Route::resource('ofertas', OfertasController::class);
        Route::get('/tipos-ofertas', [OfertasController::class, 'tiposOfertas']);
        
        // ✅ NUEVAS RUTAS PARA GESTIÓN DE PRODUCTOS EN OFERTAS
        Route::get('/productos-disponibles', [OfertasController::class, 'productosDisponibles']);
        Route::get('/ofertas/{oferta}/productos', [OfertasController::class, 'productosOferta']);
        Route::post('/ofertas/{oferta}/productos', [OfertasController::class, 'agregarProducto']);
        Route::put('/ofertas/{oferta}/productos/{productoOferta}', [OfertasController::class, 'actualizarProducto']);
        Route::delete('/ofertas/{oferta}/productos/{productoOferta}', [OfertasController::class, 'eliminarProducto']);
        
        // ✅ NUEVA RUTA: Toggle oferta principal
        Route::patch('/ofertas/{id}/toggle-principal', [OfertasController::class, 'toggleOfertaPrincipal']);
    });

    Route::middleware('permission:cupones.ver')->group(function () {
        Route::resource('cupones', CuponesController::class);
    });

    Route::middleware('permission:categorias.edit')->group(function () {
        Route::put('/categorias/{id}', [CategoriasController::class, 'update']);
        Route::patch('/categorias/{id}/toggle-estado', [CategoriasController::class, 'toggleEstado']);
        Route::patch('/categorias/{id}/migrar-seccion', [App\Http\Controllers\SeccionController::class, 'migrarCategoria']);
    });

    Route::middleware('permission:categorias.delete')->group(function () {
        Route::delete('/categorias/{id}', [CategoriasController::class, 'destroy']);
    });

    // Marcas - Protección con permisos
    Route::middleware('permission:marcas.ver')->group(function () {
        Route::get('/marcas', [MarcaProductoController::class, 'index']);
        Route::get('/marcas/activas', [MarcaProductoController::class, 'marcasActivas']);
        Route::get('/marcas/{id}', [MarcaProductoController::class, 'show']);
    });

    Route::middleware('permission:marcas.create')->group(function () {
        Route::post('/marcas', [MarcaProductoController::class, 'store']);
    });

    Route::middleware('permission:marcas.edit')->group(function () {
        Route::put('/marcas/{id}', [MarcaProductoController::class, 'update']);
        Route::patch('/marcas/{id}/toggle-estado', [MarcaProductoController::class, 'toggleEstado']);
    });

    Route::middleware('permission:marcas.delete')->group(function () {
        Route::delete('/marcas/{id}', [MarcaProductoController::class, 'destroy']);
    });

    // Secciones - Protección con permisos
    Route::middleware('permission:secciones.ver')->group(function () {
        Route::get('/secciones', [App\Http\Controllers\SeccionController::class, 'index']);
        Route::get('/secciones/{id}', [App\Http\Controllers\SeccionController::class, 'show']);
    });

    Route::middleware('permission:secciones.create')->group(function () {
        Route::post('/secciones', [App\Http\Controllers\SeccionController::class, 'store']);
    });

    Route::middleware('permission:secciones.edit')->group(function () {
        Route::put('/secciones/{id}', [App\Http\Controllers\SeccionController::class, 'update']);
    });

    Route::middleware('permission:secciones.delete')->group(function () {
        Route::delete('/secciones/{id}', [App\Http\Controllers\SeccionController::class, 'destroy']);
    });
   
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

    // Rutas de Pedidos
    Route::prefix('pedidos')->group(function () {
        Route::get('/', [PedidosController::class, 'index'])->middleware('permission:pedidos.ver');
        Route::get('/estados', [PedidosController::class, 'getEstados']);
        Route::get('/metodos-pago', [PedidosController::class, 'getMetodosPago']);
        Route::get('/{id}', [PedidosController::class, 'show'])->middleware('permission:pedidos.show');
        Route::put('/{id}/estado', [PedidosController::class, 'updateEstado'])->middleware('permission:pedidos.edit');
        Route::delete('/{id}', [PedidosController::class, 'destroy'])->middleware('permission:pedidos.delete');
    });

    // Rutas de horarios protegidas con permisos
    Route::middleware('permission:horarios.ver')->group(function () {
        Route::get('/horarios', [HorariosController::class, 'index']);
        Route::get('/horarios/plantillas', [HorariosController::class, 'plantillasHorarios']);
        Route::get('/horarios/{userId}/usuario', [HorariosController::class, 'show'])->middleware('permission:horarios.show');
    });

    Route::middleware('permission:horarios.create')->group(function () {
        Route::post('/horarios', [HorariosController::class, 'store']);
        Route::post('/horarios/copiar', [HorariosController::class, 'copiarHorarios']);
    });

    Route::middleware('permission:horarios.edit')->group(function () {
        Route::put('/horarios/{id}', [HorariosController::class, 'update']);
    });

    Route::middleware('permission:horarios.delete')->group(function () {
        Route::delete('/horarios/{id}', [HorariosController::class, 'destroy']);
        Route::post('/horarios/eliminar-usuario', [HorariosController::class, 'eliminarHorariosUsuario']);
    });

    // Ruta pública para obtener asesores disponibles
    Route::get('/asesores/disponibles', [HorariosController::class, 'asesorDisponibles']);

});

// Rutas de recuperación de contraseña
Route::post('/forgot-password', [PasswordResetController::class, 'forgotPassword']);
Route::post('/reset-password', [PasswordResetController::class, 'resetPassword']);
Route::post('/verify-reset-token', [PasswordResetController::class, 'verifyResetToken']);

// Rutas de verificación de email
Route::post('/verify-email', [EmailVerificationController::class, 'verify']);
Route::post('/resend-verification', [EmailVerificationController::class, 'resendVerification']);
