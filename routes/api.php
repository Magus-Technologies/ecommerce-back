<?php
// routes/api.php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\BannersController;
use App\Http\Controllers\BannersPromocionalesController;
use App\Http\Controllers\CuponesController;
use App\Http\Controllers\EmpresaInfoController;
use App\Http\Controllers\MarcaProductoController;
use App\Http\Controllers\OfertasController;
use App\Http\Controllers\ProductoDetallesController;
use App\Http\Controllers\SeccionController;
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
use App\Http\Controllers\CartController;
use App\Http\Controllers\ReclamosController;

use App\Http\Controllers\Recompensas\RecompensaController;
use App\Http\Controllers\Recompensas\RecompensaAnalyticsController;
use App\Http\Controllers\Recompensas\RecompensaSegmentoController;
use App\Http\Controllers\Recompensas\RecompensaProductoController;
use App\Http\Controllers\Recompensas\RecompensaPuntosController;
use App\Http\Controllers\Recompensas\RecompensaDescuentosController;
use App\Http\Controllers\Recompensas\RecompensaEnviosController;
use App\Http\Controllers\Recompensas\RecompensaRegalosController;
use App\Http\Controllers\Recompensas\RecompensaClienteController;
use App\Http\Controllers\Recompensas\RecompensaEstadisticaController;

use App\Http\Controllers\CotizacionesController;
use App\Http\Controllers\ComprasController;




Route::post('/login', [AdminController::class, 'login'])->name('login');
Route::post('/register', [AdminController::class, 'register']);
Route::post('/check-email', [AdminController::class, 'checkEmail']);
Route::post('/check-documento', [AdminController::class, 'checkDocumento']);
// Rutas para tipos de documentos
Route::get('/document-types', [DocumentTypeController::class, 'getDocumentTypes']);

Route::get('/reniec/buscar/{doc}', [ReniecController::class, 'buscar']);
// Rutas para ubigeo
Route::get('/departamentos', [UbigeoController::class, 'getDepartamentos']);
Route::get('provincias/{departamentoId}', [UbigeoController::class, 'getProvincias']);
Route::get('distritos/{departamentoId}/{provinciaId}', [UbigeoController::class, 'getDistritos']);
Route::get('ubigeo-chain/{ubigeoId}', [UbigeoController::class, 'getUbigeoChain']);

Route::get('/categorias/publicas', [CategoriasController::class, 'categoriasPublicas']);

Route::get('/productos-publicos', [ProductosController::class, 'productosPublicos']);
Route::get('/productos-destacados', [ProductosController::class, 'productosDestacados']);
Route::get('/productos-publicos/{id}', [ProductosController::class, 'showPublico'])->name('producto.detalle');
Route::get('/productos/buscar', [ProductosController::class, 'buscarProductos']);
Route::get('/categorias-sidebar', [ProductosController::class, 'categoriasParaSidebar']);
Route::get('/banners/publicos', [BannersController::class, 'bannersPublicos']);
Route::get('/banners-promocionales/publicos', [BannersPromocionalesController::class, 'bannersPromocionalesPublicos']);
Route::get('/marcas/publicas', [MarcaProductoController::class, 'marcasPublicas']);
Route::get('/marcas/por-categoria', [MarcaProductoController::class, 'marcasPorCategoria']);


// Rutas públicas para ofertas
Route::get('/ofertas/publicas', [OfertasController::class, 'ofertasPublicas']);
Route::get('/ofertas/flash-sales', [OfertasController::class, 'flashSales']);
Route::get('/ofertas/productos', [OfertasController::class, 'productosEnOferta']);
// ✅ NUEVA RUTA: Oferta principal del día
Route::get('/ofertas/principal-del-dia', [OfertasController::class, 'ofertaPrincipalDelDia']);

Route::get('/ofertas/semana-activa', [OfertasController::class, 'ofertaSemanaActiva']);
Route::post('/cupones/validar', [OfertasController::class, 'validarCupon']);
Route::get('/cupones/activos', [CuponesController::class, 'cuponesActivos']); // NUEVA LÍNEA
Route::get('/asesores/disponibles', [HorariosController::class, 'asesorDisponibles']);
Route::get('/empresa-info/publica', [EmpresaInfoController::class, 'obtenerInfoPublica']);

// Rutas públicas de reclamos
Route::post('/reclamos/crear', [ReclamosController::class, 'crear']);
Route::get('/reclamos/buscar/{numeroReclamo}', [ReclamosController::class, 'buscarPorNumero']);

// ✅ NUEVAS RUTAS PÚBLICAS - Arma tu PC
Route::get('/arma-pc/categorias', [CategoriasController::class, 'categoriasArmaPc']);
Route::get('/categorias/{id}/compatibles', [CategoriasController::class, 'getCategoriasCompatibles']);

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
        Route::patch('/usuarios/{id}/cambiar-estado', [UsuariosController::class, 'cambiarEstado'])->middleware('permission:usuarios.edit');
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
        Route::patch('/productos/{id}/toggle-destacado', [ProductosController::class, 'toggleDestacado']);

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

    Route::middleware('permission:categorias.edit')->group(function () {
        Route::put('/categorias/{id}', [CategoriasController::class, 'update']);
        Route::patch('/categorias/{id}/toggle-estado', [CategoriasController::class, 'toggleEstado']);
    });

    Route::middleware('permission:categorias.delete')->group(function () {
        Route::delete('/categorias/{id}', [CategoriasController::class, 'destroy']);
    });

    // ✅ NUEVAS RUTAS DE ADMIN - Arma tu PC
    Route::middleware('permission:categorias.ver')->group(function () {
        Route::get('/arma-pc/configuracion', [CategoriasController::class, 'configuracionArmaPc']);
    });

    Route::middleware('permission:categorias.edit')->group(function () {
        Route::post('/arma-pc/configuracion', [CategoriasController::class, 'guardarConfiguracionArmaPc']);
        Route::put('/arma-pc/configuracion/orden', [CategoriasController::class, 'actualizarOrdenArmaPc']);
        Route::get('/arma-pc/compatibilidades', [CategoriasController::class, 'obtenerCompatibilidades']);
        Route::post('/arma-pc/compatibilidades', [CategoriasController::class, 'gestionarCompatibilidades']);
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
        // ✅ NUEVA RUTA: Toggle oferta de la semana
        Route::patch('/ofertas/{id}/toggle-semana', [OfertasController::class, 'toggleOfertaSemana']);
    });

    Route::middleware('permission:cupones.ver')->group(function () {
        Route::resource('cupones', CuponesController::class);
    });

    Route::middleware('permission:categorias.edit')->group(function () {
        Route::put('/categorias/{id}', [CategoriasController::class, 'update']);
        Route::patch('/categorias/{id}/toggle-estado', [CategoriasController::class, 'toggleEstado']);
        Route::patch('/categorias/{id}/migrar-seccion', [SeccionController::class, 'migrarCategoria']);
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
        Route::get('/secciones', [SeccionController::class, 'index']);
        Route::get('/secciones/{id}', [SeccionController::class, 'show']);
    });

    Route::middleware('permission:secciones.create')->group(function () {
        Route::post('/secciones', [SeccionController::class, 'store']);
    });

    Route::middleware('permission:secciones.edit')->group(function () {
        Route::put('/secciones/{id}', [SeccionController::class, 'update']);
    });

    Route::middleware('permission:secciones.delete')->group(function () {
        Route::delete('/secciones/{id}', [SeccionController::class, 'destroy']);
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

    Route::middleware('permission:clientes.show')->group(function () {
        Route::get('/clientes/{id}', [ClientesController::class, 'show']);
    });

    Route::middleware('permission:clientes.edit')->group(function () {
        Route::put('/clientes/{id}', [ClientesController::class, 'update']);
        Route::patch('/clientes/{id}/toggle-estado', [ClientesController::class, 'toggleEstado']);
    });

    // Rutas específicas para clientes (sin permisos)
    Route::prefix('cliente')->group(function () {
        Route::post('/upload-foto', [ClientesController::class, 'uploadFoto']);
        Route::delete('/delete-foto', [ClientesController::class, 'deleteFoto']);
    });

    Route::middleware('permission:clientes.delete')->group(function () {
        Route::delete('/clientes/{id}', [ClientesController::class, 'destroy']);
    });

    // Rutas de Pedidos
    Route::prefix('pedidos')->group(function () {
        Route::get('/', [PedidosController::class, 'index'])->middleware('permission:pedidos.ver');
        Route::get('/estados', [PedidosController::class, 'getEstados']);
        Route::get('/metodos-pago', [PedidosController::class, 'getMetodosPago']);
        Route::get('/estadisticas', [PedidosController::class, 'estadisticas']);
        Route::post('/ecommerce', [PedidosController::class, 'crearPedidoEcommerce']); // Para carrito
        Route::get('/mis-pedidos', [PedidosController::class, 'misPedidos']); // Para clientes
        Route::get('/{id}/tracking', [PedidosController::class, 'getTrackingPedido']); // Tracking para clientes
        Route::get('/usuario/{userId}', [PedidosController::class, 'pedidosPorUsuario']); // Para obtener pedidos de un usuario específico
        Route::get('/{id}', [PedidosController::class, 'show'])->middleware('permission:pedidos.show');
        Route::put('/{id}/estado', [PedidosController::class, 'updateEstado'])->middleware('permission:pedidos.edit');
        Route::patch('/{id}/estado', [PedidosController::class, 'actualizarEstado'])->middleware('permission:pedidos.edit');
        Route::post('/{id}/cambiar-estado', [PedidosController::class, 'cambiarEstado'])->middleware('permission:pedidos.edit'); // Nuevo método con tracking
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

    // Rutas de información de empresa
    Route::middleware('permission:empresa_info.ver')->group(function () {
        Route::get('/empresa-info/{id}', [EmpresaInfoController::class, 'show']);
        Route::get('/empresa-info', [EmpresaInfoController::class, 'index']);

    });

    Route::middleware('permission:empresa_info.edit')->group(function () {
        Route::post('/empresa-info', [EmpresaInfoController::class, 'store']);
        Route::put('/empresa-info/{id}', [EmpresaInfoController::class, 'update']); // POST para manejar archivos
    });

    Route::prefix('mis-direcciones')->group(function () {
        Route::get('/', [ClientesController::class, 'misDirecciones']);
        Route::post('/', [ClientesController::class, 'crearDireccion']);
        Route::put('/{id}', [ClientesController::class, 'actualizarDireccion']);
        Route::delete('/{id}', [ClientesController::class, 'eliminarDireccion']);
        Route::patch('/{id}/predeterminada', [ClientesController::class, 'establecerPredeterminada']);
    });

    // ✅ RUTAS DEL CARRITO PROTEGIDAS
    Route::prefix('cart')->group(function () {
        Route::get('/', [CartController::class, 'index']);
        Route::post('/add', [CartController::class, 'add']);
        Route::put('/update/{producto_id}', [CartController::class, 'update']);
        Route::delete('/remove/{producto_id}', [CartController::class, 'remove']);
        Route::delete('/clear', [CartController::class, 'clear']);
        Route::post('/sync', [CartController::class, 'sync']);
    });

    // Rutas de reclamos para usuarios autenticados
    Route::prefix('reclamos')->group(function () {
        Route::get('/mis-reclamos', [ReclamosController::class, 'misReclamos']);
        
        // Rutas para administradores
        Route::middleware('permission:reclamos.ver')->group(function () {
            Route::get('/', [ReclamosController::class, 'index']);
            Route::get('/estadisticas', [ReclamosController::class, 'estadisticas']);
            Route::get('/{id}', [ReclamosController::class, 'show'])->middleware('permission:reclamos.show');
        });
        
        Route::middleware('permission:reclamos.edit')->group(function () {
            Route::patch('/{id}/respuesta', [ReclamosController::class, 'actualizarRespuesta']);
            Route::patch('/{id}/estado', [ReclamosController::class, 'cambiarEstado']);
        });
        
        Route::middleware('permission:reclamos.delete')->group(function () {
            Route::delete('/{id}', [ReclamosController::class, 'destroy']);
        });
    });


    // ========================================
    // MÓDULO DE RECOMPENSAS
    // ========================================

    // GRUPO ADMINISTRACIÓN - Gestión de Recompensas
    Route::prefix('admin/recompensas')->middleware('permission:recompensas.ver')->group(function () {
        
        // Gestión principal de recompensas
        Route::get('/', [RecompensaController::class, 'index']); // Listar recompensas
        Route::get('/estadisticas', [RecompensaEstadisticaController::class, 'estadisticas']); // Estadísticas del sistema
        Route::get('/tipos', [RecompensaEstadisticaController::class, 'tipos']); // Tipos disponibles
        Route::get('/{id}', [RecompensaController::class, 'show'])->middleware('permission:recompensas.show'); // Ver detalle

        // Analytics Avanzados
        Route::prefix('analytics')->middleware('permission:recompensas.analytics')->group(function () {
            Route::get('/dashboard', [RecompensaAnalyticsController::class, 'dashboard']); // Dashboard principal
            Route::get('/tendencias', [RecompensaAnalyticsController::class, 'tendencias']); // Tendencias por período
            Route::get('/rendimiento', [RecompensaAnalyticsController::class, 'rendimiento']); // Métricas de rendimiento
            Route::get('/comparativa', [RecompensaAnalyticsController::class, 'comparativa']); // Comparar períodos
            Route::get('/comportamiento-clientes', [RecompensaAnalyticsController::class, 'comportamientoClientes']); // Análisis de clientes
        });
        
        // Creación y edición (requiere permisos específicos)
        Route::post('/', [RecompensaController::class, 'store'])->middleware('permission:recompensas.create'); // Crear recompensa
        Route::put('/{id}', [RecompensaController::class, 'update'])->middleware('permission:recompensas.edit'); // Editar recompensa (pausa automáticamente si está activa)
        Route::patch('/{id}/pause', [RecompensaController::class, 'pause'])->middleware('permission:recompensas.edit'); // Pausar recompensa
        Route::patch('/{id}/activate', [RecompensaController::class, 'activate'])->middleware('permission:recompensas.activate'); // Activar recompensa
        Route::delete('/{id}', [RecompensaController::class, 'destroy'])->middleware('permission:recompensas.delete'); // Cancelar recompensa
        
        // Gestión de segmentos y clientes
        Route::prefix('{recompensaId}/segmentos')->middleware('permission:recompensas.segmentos')->group(function () {
            Route::get('/', [RecompensaSegmentoController::class, 'index']); // Listar segmentos asignados
            Route::post('/', [RecompensaSegmentoController::class, 'store']); // Asignar segmento/cliente
            Route::delete('/{segmentoId}', [RecompensaSegmentoController::class, 'destroy']); // Eliminar asignación
            Route::get('/disponibles', [RecompensaSegmentoController::class, 'segmentosDisponibles']); // Segmentos disponibles
            Route::get('/estadisticas', [RecompensaSegmentoController::class, 'estadisticasSegmentacion']); // Estadísticas de segmentación
            Route::post('/validar-cliente', [RecompensaSegmentoController::class, 'validarCliente']); // Validar cliente específico
        });
        
        // Búsqueda de clientes para asignación
        Route::get('/clientes/buscar', [RecompensaSegmentoController::class, 'buscarClientes'])->middleware('permission:recompensas.segmentos');
        
        // Gestión de productos y categorías
        Route::prefix('{recompensaId}/productos')->middleware('permission:recompensas.productos')->group(function () {
            Route::get('/', [RecompensaProductoController::class, 'index']); // Listar productos/categorías asignados
            Route::post('/', [RecompensaProductoController::class, 'store']); // Asignar producto/categoría
            Route::delete('/{asignacionId}', [RecompensaProductoController::class, 'destroy']); // Eliminar asignación
            Route::get('/aplicables', [RecompensaProductoController::class, 'productosAplicables']); // Productos que aplican
            Route::get('/estadisticas', [RecompensaProductoController::class, 'estadisticas']); // Estadísticas de productos
            Route::post('/validar-producto', [RecompensaProductoController::class, 'validarProducto']); // Validar producto específico
        });
        
        // Búsqueda de productos y categorías
        Route::get('/productos/buscar', [RecompensaProductoController::class, 'buscarProductos'])->middleware('permission:recompensas.productos');
        Route::get('/categorias/buscar', [RecompensaProductoController::class, 'buscarCategorias'])->middleware('permission:recompensas.productos');
        
        // Configuración de submódulos
        
        // Submódulo de Puntos
        Route::prefix('{recompensaId}/puntos')->middleware('permission:recompensas.puntos')->group(function () {
            Route::get('/', [RecompensaPuntosController::class, 'index']); // Ver configuración
            Route::post('/', [RecompensaPuntosController::class, 'store']); // Crear/actualizar configuración
            Route::put('/{configId}', [RecompensaPuntosController::class, 'update']); // Actualizar configuración
            Route::delete('/{configId}', [RecompensaPuntosController::class, 'destroy']); // Eliminar configuración
            Route::post('/simular', [RecompensaPuntosController::class, 'simular']); // Simular cálculo de puntos
        });
        
        // Utilidades para puntos
        Route::get('/puntos/ejemplos', [RecompensaPuntosController::class, 'ejemplos'])->middleware('permission:recompensas.puntos');
        Route::post('/puntos/validar', [RecompensaPuntosController::class, 'validar'])->middleware('permission:recompensas.puntos');
        
        // Submódulo de Descuentos
        Route::prefix('{recompensaId}/descuentos')->middleware('permission:recompensas.descuentos')->group(function () {
            Route::get('/', [RecompensaDescuentosController::class, 'index']); // Ver configuración
            Route::post('/', [RecompensaDescuentosController::class, 'store']); // Crear configuración
            Route::put('/{configId}', [RecompensaDescuentosController::class, 'update']); // Actualizar configuración
            Route::delete('/{configId}', [RecompensaDescuentosController::class, 'destroy']); // Eliminar configuración
            Route::post('/simular', [RecompensaDescuentosController::class, 'simular']); // Simular descuentos
            Route::post('/calcular', [RecompensaDescuentosController::class, 'calcular']); // Calcular descuento específico
        });
        
        // Utilidades para descuentos
        Route::get('/descuentos/tipos', [RecompensaDescuentosController::class, 'tiposDisponibles'])->middleware('permission:recompensas.descuentos');
        Route::post('/descuentos/validar', [RecompensaDescuentosController::class, 'validar'])->middleware('permission:recompensas.descuentos');
        
        // Submódulo de Envíos
        Route::prefix('{recompensaId}/envios')->middleware('permission:recompensas.envios')->group(function () {
            Route::get('/', [RecompensaEnviosController::class, 'index']); // Ver configuración
            Route::post('/', [RecompensaEnviosController::class, 'store']); // Crear configuración
            Route::put('/{configId}', [RecompensaEnviosController::class, 'update']); // Actualizar configuración
            Route::delete('/{configId}', [RecompensaEnviosController::class, 'destroy']); // Eliminar configuración
            Route::post('/validar', [RecompensaEnviosController::class, 'validar']); // Validar envío gratuito
            Route::get('/estadisticas-cobertura', [RecompensaEnviosController::class, 'estadisticasCobertura']); // Estadísticas de cobertura
        });
        
        // Utilidades para envíos
        Route::get('/envios/zonas/buscar', [RecompensaEnviosController::class, 'buscarZonas'])->middleware('permission:recompensas.envios');
        Route::get('/envios/departamentos', [RecompensaEnviosController::class, 'departamentos'])->middleware('permission:recompensas.envios');
        
        // Submódulo de Regalos
        Route::prefix('{recompensaId}/regalos')->middleware('permission:recompensas.regalos')->group(function () {
            Route::get('/', [RecompensaRegalosController::class, 'index']); // Ver configuración
            Route::post('/', [RecompensaRegalosController::class, 'store']); // Crear configuración
            Route::put('/{configId}', [RecompensaRegalosController::class, 'update']); // Actualizar configuración
            Route::delete('/{configId}', [RecompensaRegalosController::class, 'destroy']); // Eliminar configuración
            Route::post('/{configId}/verificar-disponibilidad', [RecompensaRegalosController::class, 'verificarDisponibilidad']); // Verificar stock
            Route::post('/simular', [RecompensaRegalosController::class, 'simular']); // Simular regalos
            Route::get('/estadisticas', [RecompensaRegalosController::class, 'estadisticas']); // Estadísticas de regalos
        });
        
        // Búsqueda de productos para regalos
        Route::get('/regalos/productos/buscar', [RecompensaRegalosController::class, 'buscarProductos'])->middleware('permission:recompensas.regalos');
    });
    
    // 🔹 GRUPO CLIENTE - Consulta de Recompensas (JWT)
    Route::prefix('cliente/recompensas')->group(function () {
        
        // Recompensas disponibles para el cliente
        Route::get('/activas', [RecompensaClienteController::class, 'recompensasActivas']); // Ver recompensas activas que le aplican
        Route::get('/{id}/detalle', [RecompensaClienteController::class, 'detalleRecompensa']); // Ver detalle de recompensa específica
        
        // Historial del cliente
        Route::get('/historial', [RecompensaClienteController::class, 'historialRecompensas']); // Consultar historial de recompensas recibidas
        
        // Puntos del cliente
        Route::get('/puntos', [RecompensaClienteController::class, 'puntosAcumulados']); // Consultar puntos acumulados
    });

    // Rutas de motorizados protegidas con permisos
    Route::middleware('permission:motorizados.ver')->group(function () {
        Route::get('/motorizados', [App\Http\Controllers\MotorizadosController::class, 'index']);
        Route::get('/motorizados/categorias-licencia', [App\Http\Controllers\MotorizadosController::class, 'getCategoriasLicencia']);
        Route::get('/motorizados/{id}', [App\Http\Controllers\MotorizadosController::class, 'show'])->middleware('permission:motorizados.show');
    });

    Route::middleware('permission:motorizados.create')->group(function () {
        Route::post('/motorizados', [App\Http\Controllers\MotorizadosController::class, 'store']);
    });

    Route::middleware('permission:motorizados.edit')->group(function () {
        Route::post('/motorizados/{id}', [App\Http\Controllers\MotorizadosController::class, 'update']);
        Route::patch('/motorizados/{id}/toggle-estado', [App\Http\Controllers\MotorizadosController::class, 'toggleEstado']);

        // Nuevas rutas para gestión de usuarios de motorizados
        Route::post('/motorizados/{id}/crear-usuario', [App\Http\Controllers\MotorizadosController::class, 'crearUsuario']);
        Route::patch('/motorizados/{id}/toggle-usuario', [App\Http\Controllers\MotorizadosController::class, 'toggleUsuario']);
        Route::post('/motorizados/{id}/resetear-password', [App\Http\Controllers\MotorizadosController::class, 'resetearPassword']);
    });

    Route::middleware('permission:motorizados.delete')->group(function () {
        Route::delete('/motorizados/{id}', [App\Http\Controllers\MotorizadosController::class, 'destroy']);
    });


});


// Rutas de recuperación de contraseña
Route::post('/forgot-password', [PasswordResetController::class, 'forgotPassword']);
Route::post('/reset-password', [PasswordResetController::class, 'resetPassword']);
Route::post('/verify-reset-token', [PasswordResetController::class, 'verifyResetToken']);

// Rutas de verificación de email
Route::post('/verify-email', [EmailVerificationController::class, 'verify']);
Route::post('/resend-verification', [EmailVerificationController::class, 'resendVerification']);
// Ruta para verificación por enlace (GET)
Route::get('/verify-email-link', [EmailVerificationController::class, 'verifyByLink']);

// Rutas para gestión de plantillas de correo
Route::middleware(['auth:sanctum'])->group(function () {
    Route::prefix('email-templates')->group(function () {
        Route::get('/', [App\Http\Controllers\EmailTemplateController::class, 'index']);
        Route::get('/{name}', [App\Http\Controllers\EmailTemplateController::class, 'show']);
        Route::put('/{name}', [App\Http\Controllers\EmailTemplateController::class, 'update']);
        Route::post('/upload-image', [App\Http\Controllers\EmailTemplateController::class, 'uploadImage']);
        Route::get('/{name}/preview', [App\Http\Controllers\EmailTemplateController::class, 'preview']);
        Route::get('/empresa/info', [App\Http\Controllers\EmailTemplateController::class, 'getEmpresaInfo']);
    });
});

// Rutas de cotización (públicas para el checkout)
Route::prefix('cotizacion')->group(function () {
    Route::post('/generar-pdf', [App\Http\Controllers\CotizacionController::class, 'generarPDF']);
    Route::post('/enviar-email', [App\Http\Controllers\CotizacionController::class, 'enviarEmail']);
});

// =============================================================================
// NUEVAS RUTAS DEL SISTEMA DE COTIZACIONES Y COMPRAS
// =============================================================================

Route::middleware('auth:sanctum')->group(function () {

    // ✅ RUTAS DE COTIZACIONES
    Route::prefix('cotizaciones')->group(function () {
        // Ruta para crear cotización desde checkout (requiere autenticación)
        Route::post('/ecommerce', [CotizacionesController::class, 'crearCotizacionEcommerce']); // Crear cotización desde checkout

        // Rutas para clientes
        Route::get('/mis-cotizaciones', [CotizacionesController::class, 'misCotizaciones']); // Ver mis cotizaciones
        Route::get('/{id}/pdf', [CotizacionesController::class, 'generarPDF']); // Generar PDF de cotización
        Route::post('/{id}/convertir-compra', [CotizacionesController::class, 'convertirACompra']); // Convertir a compra
        Route::post('/{id}/pedir', [CotizacionesController::class, 'pedirCotizacion']); // Solicitar procesamiento
        Route::get('/{id}/tracking', [CotizacionesController::class, 'getTracking']); // Ver tracking
        Route::delete('/{id}', [CotizacionesController::class, 'destroy']); // Eliminar cotización

        // Rutas para administradores
        Route::middleware('permission:cotizaciones.ver')->group(function () {
            Route::get('/', [CotizacionesController::class, 'index']); // Listar todas
            Route::get('/estadisticas', [CotizacionesController::class, 'estadisticas']); // Estadísticas
            Route::get('/{id}', [CotizacionesController::class, 'show'])->middleware('permission:cotizaciones.show'); // Ver detalle
        });

        Route::middleware('permission:cotizaciones.edit')->group(function () {
            Route::patch('/{id}/estado', [CotizacionesController::class, 'cambiarEstado']); // Cambiar estado
        });

        // Estados de cotización
        Route::get('/estados/lista', [CotizacionesController::class, 'getEstados']); // Obtener estados
    });

    // ✅ RUTAS DE COMPRAS
    Route::prefix('compras')->group(function () {
        // Rutas para clientes
        Route::post('/', [ComprasController::class, 'store']); // Crear compra desde ecommerce
        Route::get('/mis-compras', [ComprasController::class, 'misCompras']); // Ver mis compras
        Route::post('/{id}/cancelar', [ComprasController::class, 'cancelar']); // Cancelar compra
        Route::get('/{id}/tracking', [ComprasController::class, 'getTracking']); // Ver tracking

        // Rutas para administradores
        Route::middleware('permission:compras.ver')->group(function () {
            Route::get('/', [ComprasController::class, 'index']); // Listar todas
            Route::get('/estadisticas', [ComprasController::class, 'estadisticas']); // Estadísticas
            Route::get('/{id}', [ComprasController::class, 'show'])->middleware('permission:compras.show'); // Ver detalle
        });

        Route::middleware('permission:compras.aprobar')->group(function () {
            Route::post('/{id}/aprobar', [ComprasController::class, 'aprobar']); // Aprobar compra
            Route::post('/{id}/rechazar', [ComprasController::class, 'rechazar']); // Rechazar compra
        });

        Route::middleware('permission:compras.edit')->group(function () {
            Route::patch('/{id}/estado', [ComprasController::class, 'cambiarEstado']); // Cambiar estado
            Route::post('/{id}/procesar-pago', [ComprasController::class, 'procesarPago']); // Procesar pago
        });

        // Estados de compra
        Route::get('/estados/lista', [ComprasController::class, 'getEstados']); // Obtener estados
    });

});

