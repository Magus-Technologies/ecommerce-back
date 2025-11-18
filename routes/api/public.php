<?php

use App\Http\Controllers\Recompensas\RecompensaNotificacionController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\BannerFlashSalesController;
use App\Http\Controllers\BannerOfertaController;
use App\Http\Controllers\BannersController;
use App\Http\Controllers\BannersPromocionalesController;
use App\Http\Controllers\CategoriasController;
use App\Http\Controllers\CuponesController;
use App\Http\Controllers\DocumentTypeController;
use App\Http\Controllers\EmpresaInfoController;
use App\Http\Controllers\FormaEnvioController;
use App\Http\Controllers\HorariosController;
use App\Http\Controllers\MarcaProductoController;
use App\Http\Controllers\OfertasController;
use App\Http\Controllers\ProductosController;
use App\Http\Controllers\ReclamosController;
use App\Http\Controllers\ReniecController;
use App\Http\Controllers\TipoPagoController;
use App\Http\Controllers\UbigeoController;
use Illuminate\Support\Facades\Route;

/*
 * |--------------------------------------------------------------------------
 * | Rutas Públicas
 * |--------------------------------------------------------------------------
 * |
 * | Endpoints accesibles sin autenticación
 * |
 */

// ============================================
// AUTENTICACIÓN
// ============================================
Route::post('/login', [AdminController::class, 'login'])->name('login');
Route::post('/register', [AdminController::class, 'register']);
Route::post('/check-email', [AdminController::class, 'checkEmail']);
Route::post('/check-documento', [AdminController::class, 'checkDocumento']);

// ============================================
// CATÁLOGOS PÚBLICOS
// ============================================
Route::get('/document-types', [DocumentTypeController::class, 'getDocumentTypes']);
Route::get('/reniec/buscar/{doc}', [ReniecController::class, 'buscar']);

// ============================================
// UBIGEO
// ============================================
Route::get('/departamentos', [UbigeoController::class, 'getDepartamentos']);
Route::get('provincias/{departamentoId}', [UbigeoController::class, 'getProvincias']);
Route::get('distritos/{departamentoId}/{provinciaId}', [UbigeoController::class, 'getDistritos']);
Route::get('ubigeo-chain/{ubigeoId}', [UbigeoController::class, 'getUbigeoChain']);

// ============================================
// CATEGORÍAS PÚBLICAS
// ============================================
Route::get('/categorias/publicas', [CategoriasController::class, 'categoriasPublicas']);
Route::get('/categorias-sidebar', [ProductosController::class, 'categoriasParaSidebar']);
Route::get('/arma-pc/categorias', [CategoriasController::class, 'categoriasArmaPc']);
Route::get('/categorias/{id}/compatibles', [CategoriasController::class, 'getCategoriasCompatibles']);

// ============================================
// PRODUCTOS PÚBLICOS
// ============================================
Route::get('/productos-publicos', [ProductosController::class, 'productosPublicos']);
Route::get('/productos-destacados', [ProductosController::class, 'productosDestacados']);
Route::get('/productos-publicos/{id}', [ProductosController::class, 'showPublico'])->name('producto.detalle');
Route::get('/productos/buscar', [ProductosController::class, 'buscarProductos']);

// ============================================
// MARCAS PÚBLICAS
// ============================================
Route::get('/marcas/publicas', [MarcaProductoController::class, 'marcasPublicas']);
Route::get('/marcas/por-categoria', [MarcaProductoController::class, 'marcasPorCategoria']);

// ============================================
// BANNERS PÚBLICOS
// ============================================
Route::get('/banners/publicos', [BannersController::class, 'bannersPublicos']);
Route::get('/banners-horizontales/publicos', [BannersController::class, 'bannersHorizontalesPublicos']);
Route::get('/banners-sidebar-shop/publico', [BannersController::class, 'bannerSidebarShopPublico']);
Route::get('/banners-promocionales/publicos', [BannersPromocionalesController::class, 'bannersPromocionalesPublicos']);
Route::get('/banners-flash-sales/activos', [BannerFlashSalesController::class, 'activos']);
Route::get('/banners-ofertas/activo', [BannerOfertaController::class, 'getBannerActivo']);
// Route::get('/banners-flash-sales/activos', [BannersController::class, 'bannersFlashSalesActivos']);

// ============================================
// OFERTAS PÚBLICAS
// ============================================
Route::get('/ofertas/publicas', [OfertasController::class, 'ofertasPublicas']);
Route::get('/ofertas/flash-sales', [OfertasController::class, 'flashSales']);
Route::get('/ofertas/productos', [OfertasController::class, 'productosEnOferta']);
Route::get('/ofertas/principal-del-dia', [OfertasController::class, 'ofertaPrincipalDelDia']);
Route::get('/ofertas/semana-activa', [OfertasController::class, 'ofertaSemanaActiva']);

// ============================================
// CUPONES
// ============================================
Route::post('/cupones/validar', [OfertasController::class, 'validarCupon']);
Route::get('/cupones/activos', [CuponesController::class, 'cuponesActivos']);

// ============================================
// INFORMACIÓN DE EMPRESA
// ============================================
Route::get('/empresa-info/publica', [EmpresaInfoController::class, 'obtenerInfoPublica']);
Route::get('/asesores/disponibles', [HorariosController::class, 'asesorDisponibles']);

// ============================================
// FORMAS DE ENVÍO Y TIPOS DE PAGO
// ============================================
Route::get('/formas-envio/activas', [FormaEnvioController::class, 'activas']);
Route::get('/tipos-pago/activos', [TipoPagoController::class, 'activos']);

// ============================================
// PASOS DE ENVÍO
// ============================================
Route::get('/pasos-envio', [\App\Http\Controllers\PasoEnvioController::class, 'index']);

// ============================================
// RECOMPENSAS PÚBLICAS
// ============================================
Route::get('/publico/recompensas/popups-activos', [RecompensaNotificacionController::class, 'popupsActivosPublico']);

// ============================================
// RECLAMOS
// ============================================
Route::post('/reclamos/crear', [ReclamosController::class, 'crear']);
Route::get('/reclamos/buscar/{numeroReclamo}', [ReclamosController::class, 'buscarPorNumero']);

// ============================================
// VERIFICACIÓN DE EMAIL Y RECUPERACIÓN DE CONTRASEÑA
// ============================================
Route::post('/verify-email', [\App\Http\Controllers\EmailVerificationController::class, 'verify']);
Route::post('/resend-verification', [\App\Http\Controllers\EmailVerificationController::class, 'resendVerification']);
Route::post('/forgot-password', [\App\Http\Controllers\PasswordResetController::class, 'forgotPassword']);
Route::post('/reset-password', [\App\Http\Controllers\PasswordResetController::class, 'resetPassword']);
Route::post('/verify-reset-token', [\App\Http\Controllers\PasswordResetController::class, 'verifyResetToken']);
// COMPROBANTES PÚBLICOS (para WhatsApp)
// ============================================
Route::get('/venta/comprobante/pdf/{ventaId}/{numeroCompleto}', [\App\Http\Controllers\VentasController::class, 'descargarPdfPublico'])->where('numeroCompleto', '.*');
