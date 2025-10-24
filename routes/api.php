<?php

// routes/api.php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\BannersController;
use App\Http\Controllers\BannersPromocionalesController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\CategoriasController;
use App\Http\Controllers\ClientesController;
use App\Http\Controllers\ComprasController;
use App\Http\Controllers\CotizacionesController;
use App\Http\Controllers\CuponesController;
use App\Http\Controllers\DocumentTypeController;
use App\Http\Controllers\EmailVerificationController;
use App\Http\Controllers\EmpresaInfoController;
use App\Http\Controllers\Facturacion\AuditoriaSunatController;
use App\Http\Controllers\Facturacion\BajasController;
use App\Http\Controllers\Facturacion\CatalogosSunatController;
use App\Http\Controllers\Facturacion\CertificadosController;
use App\Http\Controllers\Facturacion\ComprobantesArchivosController;
use App\Http\Controllers\Facturacion\ComprobantesController;
use App\Http\Controllers\Facturacion\ConfiguracionTributariaController;
use App\Http\Controllers\Facturacion\EmpresaEmisoraController;
use App\Http\Controllers\Facturacion\FacturacionManualController;
use App\Http\Controllers\Facturacion\FacturacionStatusController;
use App\Http\Controllers\Facturacion\GuiasRemisionController;
use App\Http\Controllers\Facturacion\HistorialEnviosController;
use App\Http\Controllers\Facturacion\IntegracionesController;
use App\Http\Controllers\Facturacion\LogsController;
use App\Http\Controllers\Facturacion\NotaCreditoController;
use App\Http\Controllers\Facturacion\NotaDebitoController;
use App\Http\Controllers\Facturacion\PagosController;
use App\Http\Controllers\Facturacion\ReintentosController;
use App\Http\Controllers\Facturacion\ReportesController;
use App\Http\Controllers\Facturacion\ResumenesController;
use App\Http\Controllers\Facturacion\SerieController;
use App\Http\Controllers\Facturacion\SunatErrorController;
use App\Http\Controllers\Facturacion\WebhookController;
use App\Http\Controllers\HorariosController;
use App\Http\Controllers\MarcaProductoController;
use App\Http\Controllers\OfertasController;
use App\Http\Controllers\PasswordResetController;
use App\Http\Controllers\PedidosController;
use App\Http\Controllers\ProductoDetallesController;
use App\Http\Controllers\ProductosController;
use App\Http\Controllers\ReclamosController;
use App\Http\Controllers\Recompensas\RecompensaAnalyticsController;
use App\Http\Controllers\Recompensas\RecompensaClienteController;
use App\Http\Controllers\Recompensas\RecompensaController;
use App\Http\Controllers\Recompensas\RecompensaDescuentosController;
use App\Http\Controllers\Recompensas\RecompensaEnviosController;
use App\Http\Controllers\Recompensas\RecompensaEstadisticaController;
use App\Http\Controllers\Recompensas\RecompensaNotificacionController;
use App\Http\Controllers\Recompensas\RecompensaPopupController;
use App\Http\Controllers\Recompensas\RecompensaProductoController;
use App\Http\Controllers\Recompensas\RecompensaPuntosController;
use App\Http\Controllers\Recompensas\RecompensaRegalosController;
use App\Http\Controllers\Recompensas\RecompensaSegmentoController;
use App\Http\Controllers\ReniecController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\SeccionController;
use App\Http\Controllers\UbigeoController;
use App\Http\Controllers\UserRegistrationController;
use App\Http\Controllers\UsuariosController;
use App\Http\Controllers\VentasController;
use Illuminate\Support\Facades\Route;

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
Route::get('/banners-horizontales/publicos', [BannersController::class, 'bannersHorizontalesPublicos']);
Route::get('/banners-sidebar-shop/publico', [BannersController::class, 'bannerSidebarShopPublico']);
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

// Rutas públicas para banners de ofertas
Route::get('/banners-ofertas/activo', [BannersController::class, 'bannerOfertaActivo']);
Route::get('/banners-flash-sales/activos', [BannersController::class, 'bannersFlashSalesActivos']);

// Rutas públicas de recompensas (popups)
Route::get('/publico/recompensas/popups-activos', [RecompensaNotificacionController::class, 'popupsActivosPublico']);

// Rutas públicas para formas de envío y tipos de pago
// Route::get('/formas-envio/activas', [FormaEnvioController::class, 'activas']); // TODO: Crear controller
// Route::get('/tipos-pago/activos', [TipoPagoController::class, 'activos']); // TODO: Crear controller

// Rutas públicas de reclamos
Route::post('/reclamos/crear', [ReclamosController::class, 'crear']);
Route::get('/reclamos/buscar/{numeroReclamo}', [ReclamosController::class, 'buscarPorNumero']);

// ✅ NUEVAS RUTAS PÚBLICAS - Arma tu PC
Route::get('/arma-pc/categorias', [CategoriasController::class, 'categoriasArmaPc']);
Route::get('/categorias/{id}/compatibles', [CategoriasController::class, 'getCategoriasCompatibles']);

// =====================================================
// ✅ SISTEMA DE GESTIÓN DE COOKIES - RUTAS PÚBLICAS
// =====================================================
// TODO: Crear CookieConsentController
/*
Route::prefix('cookies')->group(function () {
    // Obtener configuración pública del banner (sin autenticación)
    Route::get('/configuracion/publica', [CookieConsentController::class, 'obtenerConfiguracionPublica']);

    // Obtener preferencias del usuario actual (con o sin autenticación)
    Route::get('/preferencias', [CookieConsentController::class, 'obtenerPreferencias']);

    // Guardar preferencias personalizadas
    Route::post('/preferencias', [CookieConsentController::class, 'guardarPreferencias']);

    // Aceptar todas las cookies
    Route::post('/aceptar-todo', [CookieConsentController::class, 'aceptarTodo']);

    // Rechazar todas las cookies opcionales
    Route::post('/rechazar-todo', [CookieConsentController::class, 'rechazarTodo']);

    // Revocar consentimiento
    Route::delete('/revocar', [CookieConsentController::class, 'revocarConsentimiento']);
});
*/
// ============================================
Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user', [AdminController::class, 'user']);
    Route::get('/refresh-permissions', [AdminController::class, 'refreshPermissions']); // ← NUEVO
    Route::post('/logout', [AdminController::class, 'logout']);

    // NUEVAS RUTAS DE VENTAS
    // RUTAS DE VENTAS
    Route::prefix('ventas')->middleware('permission:ventas.ver')->group(function () {
        Route::get('/', [VentasController::class, 'index']); // Listar ventas
        Route::get('/estadisticas', [VentasController::class, 'estadisticas']); // Estadísticas
        Route::get('/estadisticas-sunat', [VentasController::class, 'estadisticasSunat']); // Estadísticas SUNAT
        Route::get('/pendientes-facturar', [VentasController::class, 'pendientesFacturar']); // Pendientes de facturar
        Route::get('/mis-ventas', [VentasController::class, 'misVentas']); // Mis ventas (cliente e-commerce)
        Route::get('/{id}', [VentasController::class, 'show'])->middleware('permission:ventas.show'); // Ver detalle
        Route::get('/{id}/pdf', [VentasController::class, 'descargarPdf']); // Descargar PDF
        Route::get('/{id}/xml', [VentasController::class, 'descargarXml']); // Descargar XML
        Route::get('/{id}/cdr', [VentasController::class, 'descargarCdr']); // Descargar CDR
        Route::get('/{id}/qr', [VentasController::class, 'descargarQr']); // Descargar QR
        Route::get('/{id}/historial-sunat', [VentasController::class, 'historialSunat']); // Historial SUNAT
        Route::get('/{id}/whatsapp-datos', [VentasController::class, 'obtenerDatosWhatsApp']); // Datos prellenados WhatsApp
        Route::get('/{id}/email-datos', [VentasController::class, 'obtenerDatosEmail']); // Datos prellenados Email

        Route::post('/', [VentasController::class, 'store'])->middleware('permission:ventas.create'); // Crear venta
        Route::post('/ecommerce', [VentasController::class, 'crearVentaEcommerce'])->middleware('permission:ventas.create'); // Crear venta e-commerce
        Route::post('/{id}/facturar', [VentasController::class, 'facturar'])->middleware('permission:ventas.facturar'); // Facturar venta
        Route::post('/{id}/enviar-sunat', [VentasController::class, 'enviarSunat'])->middleware('permission:ventas.facturar'); // Enviar comprobante a SUNAT (MANUAL)
        Route::post('/{id}/reenviar-sunat', [VentasController::class, 'reenviarSunat'])->middleware('permission:ventas.facturar'); // Reenviar comprobante a SUNAT
        Route::post('/{id}/consultar-sunat', [VentasController::class, 'consultarSunat'])->middleware('permission:ventas.facturar'); // Consultar estado en SUNAT
        Route::post('/{id}/generar-pdf', [VentasController::class, 'generarPdf'])->middleware('permission:ventas.facturar'); // Generar PDF manualmente
        Route::post('/{id}/email', [VentasController::class, 'enviarEmail'])->middleware('permission:ventas.edit'); // Enviar por email
        Route::post('/{id}/whatsapp', [VentasController::class, 'enviarWhatsApp'])->middleware('permission:ventas.edit'); // Enviar por WhatsApp
        Route::patch('/{id}/anular', [VentasController::class, 'anular'])->middleware('permission:ventas.delete'); // Anular venta
    });

    // RUTAS DE UTILIDADES PARA VENTAS
    Route::prefix('utilidades')->middleware('permission:ventas.ver')->group(function () {
        Route::get('/clientes/buscar', [VentasController::class, 'buscarCliente']); // Buscar cliente
        Route::post('/validar-ruc/{ruc}', [VentasController::class, 'validarRuc']); // Validar RUC
        Route::get('/buscar-empresa/{ruc}', [VentasController::class, 'buscarEmpresa']); // Buscar empresa por RUC
    });

    // RUTAS DE COMPROBANTES (FACTURACIÓN ELECTRÓNICA)
    Route::prefix('comprobantes')->middleware('permission:facturacion.comprobantes.ver')->group(function () {
        Route::get('/', [ComprobantesController::class, 'index']);
        Route::get('/estadisticas', [ComprobantesController::class, 'estadisticas']);
        Route::get('/pendientes-envio', [ComprobantesController::class, 'pendientesEnvio']); // Pendientes de enviar
        Route::get('/rechazados', [ComprobantesController::class, 'rechazados']); // Rechazados por SUNAT
        Route::get('/{id}', [ComprobantesController::class, 'show'])->middleware('permission:facturacion.comprobantes.show');
        Route::get('/{id}/pdf', [ComprobantesController::class, 'descargarPdf']);
        Route::get('/{id}/xml', [ComprobantesController::class, 'descargarXml']);
        Route::get('/{id}/cdr', [ComprobantesController::class, 'descargarCdr']);

        Route::post('/{id}/enviar-sunat', [ComprobantesController::class, 'enviarSunat'])->middleware('permission:facturacion.comprobantes.edit'); // Enviar a SUNAT
        Route::post('/{id}/consultar-estado', [ComprobantesController::class, 'consultarEstado'])->middleware('permission:facturacion.comprobantes.edit'); // Consultar estado
        Route::post('/{id}/regenerar', [ComprobantesController::class, 'regenerar'])->middleware('permission:facturacion.comprobantes.edit'); // Regenerar XML/PDF
        Route::post('/{id}/generar-nota-credito', [ComprobantesController::class, 'generarNotaCredito'])->middleware('permission:facturacion.notas_credito.create'); // Generar NC
        Route::post('/{id}/generar-nota-debito', [ComprobantesController::class, 'generarNotaDebito'])->middleware('permission:facturacion.notas_debito.create'); // Generar ND
        Route::post('/envio-masivo', [ComprobantesController::class, 'envioMasivo'])->middleware('permission:facturacion.comprobantes.edit'); // Envío masivo
        Route::post('/{id}/reenviar', [ComprobantesController::class, 'reenviar'])->middleware('permission:facturacion.comprobantes.edit');
        Route::post('/{id}/consultar', [ComprobantesController::class, 'consultar'])->middleware('permission:facturacion.comprobantes.edit');
        Route::post('/{id}/email', [ComprobantesController::class, 'enviarEmail'])->middleware('permission:facturacion.comprobantes.edit');
        Route::post('/{id}/whatsapp', [ComprobantesController::class, 'enviarWhatsApp'])->middleware('permission:facturacion.comprobantes.edit');
        Route::patch('/{id}/anular', [ComprobantesController::class, 'anular'])->middleware('permission:facturacion.comprobantes.delete');
    });

    // RUTAS PARA SERIES (Facturación)
    Route::prefix('series')->middleware('permission:facturacion.series.ver')->group(function () {
        Route::get('/', [SerieController::class, 'index']); // Listar series
        Route::get('/estadisticas', [SerieController::class, 'estadisticas']); // Estadísticas

        Route::post('/', [SerieController::class, 'store'])->middleware('permission:facturacion.series.create'); // Crear serie
        Route::patch('/{id}', [SerieController::class, 'update'])->middleware('permission:facturacion.series.edit'); // Actualizar serie
        Route::post('/reservar-correlativo', [SerieController::class, 'reservarCorrelativo'])->middleware('permission:facturacion.series.edit'); // Reservar correlativo
    });

    // API RUTAS PARA FACTURACIÓN ELECTRÓNICA (SEMANA 2)
    Route::prefix('facturas')->middleware('permission:facturacion.facturas.ver')->group(function () {
        // Comprobantes principales
        Route::get('/', [FacturacionManualController::class, 'index']); // Listar facturas
        Route::get('/{id}', [FacturacionManualController::class, 'show'])->middleware('permission:facturacion.facturas.show'); // Ver factura
        Route::get('/{id}/pdf', [FacturacionManualController::class, 'descargarPdf']); // Descargar PDF
        Route::get('/{id}/xml', [FacturacionManualController::class, 'descargarXml']); // Descargar XML

        // Utilidades
        Route::get('/buscar-productos', [FacturacionManualController::class, 'buscarProductos']); // Buscar productos
        Route::get('/clientes', [FacturacionManualController::class, 'getClientes']); // Listar clientes
        Route::get('/series', [FacturacionManualController::class, 'getSeries']); // Listar series
        Route::get('/estadisticas', [FacturacionManualController::class, 'estadisticas']); // Estadísticas

        Route::post('/', [FacturacionManualController::class, 'store'])->middleware('permission:facturacion.facturas.create'); // Crear factura
        Route::post('/{id}/enviar-sunat', [FacturacionManualController::class, 'enviarSUNAT'])->middleware('permission:facturacion.facturas.edit'); // Enviar a SUNAT
    });

    // WEBHOOKS PARA INTEGRACIÓN AUTOMÁTICA (SEMANA 3)
    Route::prefix('webhook')->group(function () {
        Route::post('/pago', [WebhookController::class, 'webhookPago']); // Webhook genérico de pago
        Route::post('/culqi', [WebhookController::class, 'webhookCulqi']); // Webhook específico de Culqi
    });

    // CÓDIGOS DE ERROR SUNAT (REQUERIMIENTO DEL INGENIERO)
    Route::prefix('sunat-errores')->group(function () {
        Route::get('/', [SunatErrorController::class, 'index']); // Listar todos los códigos
        Route::get('/categorias', [SunatErrorController::class, 'categorias']); // Listar categorías
        Route::get('/estadisticas', [SunatErrorController::class, 'estadisticas']); // Estadísticas
        Route::get('/buscar', [SunatErrorController::class, 'buscar']); // Buscar por texto
        Route::post('/parsear', [SunatErrorController::class, 'parsear']); // Parsear mensaje SUNAT
        Route::get('/categoria/{categoria}', [SunatErrorController::class, 'porCategoria']); // Por categoría
        Route::get('/{codigo}', [SunatErrorController::class, 'show']); // Ver código específico
    });

    // ==============================
    // FACTURACIÓN ELECTRÓNICA - API
    // ==============================
    Route::prefix('facturacion')->group(function () {

        // Certificados
        Route::prefix('certificados')->middleware('permission:facturacion.certificados.ver')->group(function () {
            Route::get('/', [CertificadosController::class, 'index']);
            Route::get('/{id}', [CertificadosController::class, 'show']);
            Route::get('/{id}/validar', [CertificadosController::class, 'validar']);

            Route::post('/', [CertificadosController::class, 'store'])->middleware('permission:facturacion.certificados.create');
            Route::put('/{id}', [CertificadosController::class, 'update'])->middleware('permission:facturacion.certificados.edit');
            Route::post('/{id}/activar', [CertificadosController::class, 'activar'])->middleware('permission:facturacion.certificados.edit');
            Route::delete('/{id}', [CertificadosController::class, 'destroy'])->middleware('permission:facturacion.certificados.delete');
        });

        // Resúmenes (RC)
        Route::prefix('resumenes')->middleware('permission:facturacion.resumenes.ver')->group(function () {
            Route::get('/', [ResumenesController::class, 'index']);
            Route::get('/{id}', [ResumenesController::class, 'show']);
            Route::get('/{id}/xml', [ResumenesController::class, 'xml']);
            Route::get('/{id}/cdr', [ResumenesController::class, 'cdr']);
            Route::get('/{id}/ticket', [ResumenesController::class, 'consultarTicket']);

            Route::post('/', [ResumenesController::class, 'store'])->middleware('permission:facturacion.resumenes.create');
            Route::post('/{id}/enviar', [ResumenesController::class, 'enviar'])->middleware('permission:facturacion.resumenes.edit');
        });

        // Bajas (RA)
        Route::prefix('bajas')->middleware('permission:facturacion.bajas.ver')->group(function () {
            Route::get('/', [BajasController::class, 'index']);
            Route::get('/{id}', [BajasController::class, 'show']);
            Route::get('/{id}/xml', [BajasController::class, 'xml']);
            Route::get('/{id}/cdr', [BajasController::class, 'cdr']);
            Route::get('/{id}/ticket', [BajasController::class, 'consultarTicket']);

            Route::post('/', [BajasController::class, 'store'])->middleware('permission:facturacion.bajas.create');
            Route::post('/{id}/enviar', [BajasController::class, 'enviar'])->middleware('permission:facturacion.bajas.edit');
        });

        // Auditoría
        Route::prefix('auditoria')->middleware('permission:facturacion.auditoria.ver')->group(function () {
            Route::get('/', [AuditoriaSunatController::class, 'index']);
            Route::get('/{id}', [AuditoriaSunatController::class, 'show']);
        });

        // Reintentos
        Route::prefix('reintentos')->middleware('permission:facturacion.reintentos.ver')->group(function () {
            Route::get('/', [ReintentosController::class, 'index']);

            Route::post('/{id}/reintentar', [ReintentosController::class, 'reintentar'])->middleware('permission:facturacion.reintentos.edit');
            Route::post('/reintentar-todo', [ReintentosController::class, 'reintentarTodo'])->middleware('permission:facturacion.reintentos.edit');
            Route::put('/{id}/cancelar', [ReintentosController::class, 'cancelar'])->middleware('permission:facturacion.reintentos.edit');
        });

        // Catálogos SUNAT (solo lectura, no requiere permisos especiales)
        Route::prefix('catalogos')->group(function () {
            Route::get('/', [CatalogosSunatController::class, 'catalogos']);
            Route::get('/principales', [CatalogosSunatController::class, 'catalogosPrincipales']);
            Route::get('/buscar', [CatalogosSunatController::class, 'buscar']);
            Route::get('/estadisticas', [CatalogosSunatController::class, 'estadisticas']);
            Route::get('/{catalogo}', [CatalogosSunatController::class, 'index']);
            Route::get('/{catalogo}/{codigo}', [CatalogosSunatController::class, 'show']);
        });

        // Empresa emisora
        Route::middleware('permission:facturacion.empresa.ver')->group(function () {
            Route::get('/empresa', [EmpresaEmisoraController::class, 'show']);
            Route::get('/empresa/validar', [EmpresaEmisoraController::class, 'validar']);
            Route::get('/empresa/info-publica', [EmpresaEmisoraController::class, 'infoPublica']);

            Route::put('/empresa', [EmpresaEmisoraController::class, 'update'])->middleware('permission:facturacion.empresa.edit');
        });

        // Archivos de comprobantes
        Route::prefix('comprobantes')->middleware('permission:facturacion.comprobantes.ver')->group(function () {
            Route::get('/{id}/xml', [ComprobantesArchivosController::class, 'xml']);
            Route::get('/{id}/cdr', [ComprobantesArchivosController::class, 'cdr']);
            Route::get('/{id}/qr', [ComprobantesArchivosController::class, 'qr']);
        });

        // Salud del servicio (sin permisos, es público para admins)
        Route::get('/status', [FacturacionStatusController::class, 'status']);

        // Sistema de Contingencia
        Route::prefix('contingencia')->middleware('permission:facturacion.contingencia.ver')->group(function () {
            Route::get('/info', [App\Http\Controllers\Facturacion\ContingenciaController::class, 'info']);
            Route::get('/estadisticas', [App\Http\Controllers\Facturacion\ContingenciaController::class, 'estadisticas']);

            Route::post('/activar', [App\Http\Controllers\Facturacion\ContingenciaController::class, 'activar'])->middleware('permission:facturacion.contingencia.edit');
            Route::post('/desactivar', [App\Http\Controllers\Facturacion\ContingenciaController::class, 'desactivar'])->middleware('permission:facturacion.contingencia.edit');
            Route::post('/regularizar', [App\Http\Controllers\Facturacion\ContingenciaController::class, 'regularizar'])->middleware('permission:facturacion.contingencia.edit');
            Route::post('/verificar', [App\Http\Controllers\Facturacion\ContingenciaController::class, 'verificar'])->middleware('permission:facturacion.contingencia.edit');
        });
    });

    // RUTAS PARA NOTAS DE CRÉDITO Y DÉBITO
    Route::prefix('notas-credito')->middleware('permission:facturacion.notas_credito.ver')->group(function () {
        Route::get('/', [NotaCreditoController::class, 'index']);
        Route::get('/estadisticas', [NotaCreditoController::class, 'estadisticas']);
        Route::get('/{id}', [NotaCreditoController::class, 'show'])->middleware('permission:facturacion.notas_credito.show');

        Route::post('/', [NotaCreditoController::class, 'store'])->middleware('permission:facturacion.notas_credito.create');
        Route::post('/{id}/enviar-sunat', [NotaCreditoController::class, 'enviarSunat'])->middleware('permission:facturacion.notas_credito.edit');
    });

    Route::prefix('notas-debito')->middleware('permission:facturacion.notas_debito.ver')->group(function () {
        Route::get('/', [NotaDebitoController::class, 'index']);
        Route::get('/estadisticas', [NotaDebitoController::class, 'estadisticas']);
        Route::get('/{id}', [NotaDebitoController::class, 'show'])->middleware('permission:facturacion.notas_debito.show');

        Route::post('/', [NotaDebitoController::class, 'store'])->middleware('permission:facturacion.notas_debito.create');
        Route::post('/{id}/enviar-sunat', [NotaDebitoController::class, 'enviarSunat'])->middleware('permission:facturacion.notas_debito.edit');
    });

    // RUTAS PARA GUÍAS DE REMISIÓN
    Route::prefix('guias-remision')->middleware('permission:facturacion.guias_remision.ver')->group(function () {
        Route::get('/', [GuiasRemisionController::class, 'index']);
        Route::get('/estadisticas/resumen', [GuiasRemisionController::class, 'estadisticas']);
        Route::get('/{id}', [GuiasRemisionController::class, 'show'])->middleware('permission:facturacion.guias_remision.show');
        Route::get('/{id}/xml', [GuiasRemisionController::class, 'descargarXml']);

        Route::post('/', [GuiasRemisionController::class, 'store'])->middleware('permission:facturacion.guias_remision.create');
        Route::post('/{id}/enviar-sunat', [GuiasRemisionController::class, 'enviarSunat'])->middleware('permission:facturacion.guias_remision.edit');
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

    // RUTAS DE ROLES Y PERMISOS
    Route::middleware('permission:roles.ver')->group(function () {
        Route::get('/permissions', [RoleController::class, 'getPermissions']); // Listar todos los permisos
        Route::get('/roles', [RoleController::class, 'getRoles']); // Listar roles
        Route::get('/roles/{id}/permissions', [RoleController::class, 'getRolePermissions']); // Ver permisos de un rol

        Route::post('/roles', [RoleController::class, 'store'])->middleware('permission:roles.create'); // Crear rol
        Route::put('/roles/{id}/permissions', [RoleController::class, 'updateRolePermissions'])->middleware('permission:roles.edit'); // Actualizar permisos
        Route::delete('/roles/{id}', [RoleController::class, 'destroy'])->middleware('permission:roles.delete'); // Eliminar rol
    });

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
        Route::get('/clientes/buscar-por-documento', [ClientesController::class, 'buscarPorDocumento']);

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

    // RUTAS DE PEDIDOS
    Route::prefix('pedidos')->middleware('permission:pedidos.ver')->group(function () {
        Route::get('/', [PedidosController::class, 'index']); // Listar pedidos
        Route::get('/estados', [PedidosController::class, 'getEstados']); // Obtener estados disponibles
        Route::get('/metodos-pago', [PedidosController::class, 'getMetodosPago']); // Obtener métodos de pago
        Route::get('/estadisticas', [PedidosController::class, 'estadisticas']); // Estadísticas de pedidos
        Route::get('/mis-pedidos', [PedidosController::class, 'misPedidos']); // Mis pedidos (cliente)
        Route::get('/{id}', [PedidosController::class, 'show'])->middleware('permission:pedidos.show'); // Ver detalle
        Route::get('/{id}/tracking', [PedidosController::class, 'getTrackingPedido']); // Ver tracking
        Route::get('/usuario/{userId}', [PedidosController::class, 'pedidosPorUsuario']); // Pedidos por usuario

        Route::post('/ecommerce', [PedidosController::class, 'crearPedidoEcommerce'])->middleware('permission:pedidos.create'); // Crear pedido e-commerce
        Route::put('/{id}/estado', [PedidosController::class, 'updateEstado'])->middleware('permission:pedidos.edit'); // Actualizar estado
        Route::patch('/{id}/estado', [PedidosController::class, 'actualizarEstado'])->middleware('permission:pedidos.edit'); // Actualizar estado (alt)
        Route::post('/{id}/cambiar-estado', [PedidosController::class, 'cambiarEstado'])->middleware('permission:pedidos.edit'); // Cambiar estado con tracking
        Route::delete('/{id}', [PedidosController::class, 'destroy'])->middleware('permission:pedidos.delete'); // Eliminar pedido
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
        Route::get('/popups', [RecompensaController::class, 'indexPopups']); // Listar recompensas para popups (solo activas, programadas y pausadas)
        Route::get('/estadisticas', [RecompensaEstadisticaController::class, 'estadisticas']); // Estadísticas del sistema
        Route::get('/tipos', [RecompensaEstadisticaController::class, 'tipos']); // Tipos disponibles
        Route::get('/estados-disponibles', [RecompensaController::class, 'estadosDisponibles']); // Estados disponibles según fecha
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

        // Submódulo de Popups
        Route::prefix('{recompensaId}/popups')->middleware('permission:recompensas.popups')->group(function () {
            Route::get('/', [RecompensaPopupController::class, 'index']); // Listar popups de la recompensa
            Route::get('/{popupId}', [RecompensaPopupController::class, 'show']); // Ver detalle de popup
            Route::post('/', [RecompensaPopupController::class, 'store']); // Crear popup
            Route::put('/{popupId}', [RecompensaPopupController::class, 'update']); // Actualizar popup
            Route::delete('/{popupId}', [RecompensaPopupController::class, 'destroy']); // Eliminar popup
            Route::patch('/{popupId}/toggle', [RecompensaPopupController::class, 'toggleActivo']); // Activar/desactivar popup
            Route::get('/estadisticas-popups', [RecompensaPopupController::class, 'estadisticas']); // Estadísticas de popups
        });

        // Gestión de Notificaciones (Admin)
        Route::prefix('{recompensaId}/notificaciones')->middleware('permission:recompensas.notificaciones')->group(function () {
            Route::post('/enviar', [RecompensaNotificacionController::class, 'enviarNotificacion']); // Enviar notificación a clientes
            Route::get('/estadisticas', [RecompensaNotificacionController::class, 'estadisticasNotificaciones']); // Estadísticas de notificaciones
        });
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

        // Popups y Notificaciones para el cliente
        Route::get('/popups-activos', [RecompensaNotificacionController::class, 'popupsActivos'])->withoutMiddleware(['auth:sanctum']); // Ver popups activos para el cliente (sin autenticación)
        Route::get('/popups-probar-envio', [RecompensaNotificacionController::class, 'probarEnvioAutomatico']); // Probar envío automático de popups
        Route::patch('/popups/{popupId}/marcar-visto', [RecompensaNotificacionController::class, 'marcarVisto'])->withoutMiddleware(['auth:sanctum']); // Marcar popup como visto
        Route::patch('/popups/{popupId}/cerrar', [RecompensaNotificacionController::class, 'cerrarPopup'])->withoutMiddleware(['auth:sanctum']); // Cerrar popup
        Route::get('/notificaciones/historial', [RecompensaNotificacionController::class, 'historialNotificaciones']); // Historial de notificaciones
        Route::get('/popups-diagnostico', [RecompensaNotificacionController::class, 'diagnosticarPopups'])->withoutMiddleware(['auth:sanctum']); // Diagnóstico de popups
    });

    // Nota: Las rutas públicas de recompensas están definidas al inicio del archivo (fuera de auth:sanctum)

    // 🔹 ENDPOINT DE DIAGNÓSTICO - Para verificar pop-ups
    Route::get('/popups/diagnostico', [RecompensaNotificacionController::class, 'diagnosticarPopups'])
        ->name('popups.diagnostico');

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

    // ========================================
    // MÓDULOS ADICIONALES DE FACTURACIÓN
    // ========================================

    // RUTAS DE PAGOS
    Route::prefix('pagos')->middleware('permission:facturacion.pagos.ver')->group(function () {
        Route::get('/', [PagosController::class, 'index']); // Listar pagos
        Route::get('/{id}', [PagosController::class, 'show'])->middleware('permission:facturacion.pagos.show'); // Ver detalle de pago
        Route::get('/comprobante/{comprobanteId}', [PagosController::class, 'pagosPorComprobante']); // Pagos por comprobante
        Route::get('/estadisticas/resumen', [PagosController::class, 'estadisticas']); // Estadísticas

        Route::post('/', [PagosController::class, 'store'])->middleware('permission:facturacion.pagos.create'); // Registrar pago
        Route::put('/{id}', [PagosController::class, 'update'])->middleware('permission:facturacion.pagos.edit'); // Actualizar pago
        Route::post('/{id}/anular', [PagosController::class, 'anular'])->middleware('permission:facturacion.pagos.delete'); // Anular pago
        Route::post('/registro-externo', [PagosController::class, 'registrarPagoExterno'])->middleware('permission:facturacion.pagos.create'); // Registro de pago externo
    });

    // RUTAS DE REPORTES
    Route::prefix('reportes')->middleware('permission:facturacion.reportes.ver')->group(function () {
        Route::get('/ventas', [ReportesController::class, 'reporteVentas']); // Reporte de ventas
        Route::get('/anulaciones', [ReportesController::class, 'reporteAnulaciones']); // Reporte de anulaciones
        Route::get('/impuestos', [ReportesController::class, 'reporteImpuestos']); // Reporte de impuestos
        Route::get('/notas-credito', [ReportesController::class, 'reporteNotasCredito']); // Reporte notas de crédito
        Route::get('/notas-debito', [ReportesController::class, 'reporteNotasDebito']); // Reporte notas de débito
        Route::get('/pagos', [ReportesController::class, 'reportePagos']); // Reporte de pagos
        Route::get('/consolidado', [ReportesController::class, 'reporteConsolidado']); // Reporte consolidado
    });

    // RUTAS DE HISTORIAL DE ENVÍOS
    Route::prefix('historial-envios')->middleware('permission:facturacion.historial_envios.ver')->group(function () {
        Route::get('/', [HistorialEnviosController::class, 'index']); // Listar historial
        Route::get('/{id}', [HistorialEnviosController::class, 'show']); // Ver detalle de envío
        Route::get('/comprobante/{comprobanteId}', [HistorialEnviosController::class, 'historialPorComprobante']); // Historial por comprobante
        Route::get('/estadisticas/resumen', [HistorialEnviosController::class, 'estadisticas']); // Estadísticas
        Route::get('/{id}/xml', [HistorialEnviosController::class, 'obtenerXml']); // Obtener XML
        Route::get('/{id}/cdr', [HistorialEnviosController::class, 'obtenerCdr']); // Obtener CDR

        Route::post('/{comprobanteId}/reenviar', [HistorialEnviosController::class, 'reenviar'])->middleware('permission:facturacion.historial_envios.edit'); // Reenviar
        Route::post('/ticket/consultar', [HistorialEnviosController::class, 'consultarTicket'])->middleware('permission:facturacion.historial_envios.edit'); // Consultar ticket
        Route::delete('/limpiar', [HistorialEnviosController::class, 'limpiarLogsAntiguos'])->middleware('permission:facturacion.historial_envios.delete'); // Limpiar logs antiguos
    });

    // RUTAS DE LOGS
    Route::prefix('logs')->middleware('permission:facturacion.logs.ver')->group(function () {
        Route::get('/', [LogsController::class, 'index']); // Listar logs
        Route::get('/{id}', [LogsController::class, 'show']); // Ver detalle de log
        Route::get('/estadisticas/resumen', [LogsController::class, 'estadisticas']); // Estadísticas
        Route::get('/laravel/archivo', [LogsController::class, 'laravelLogs']); // Logs de Laravel
        Route::get('/exportar/csv', [LogsController::class, 'exportarCsv']); // Exportar a CSV
        Route::get('/modulo/{modulo}', [LogsController::class, 'logsPorModulo']); // Logs por módulo

        Route::post('/', [LogsController::class, 'store'])->middleware('permission:facturacion.logs.create'); // Registrar log
        Route::patch('/{id}/resolver', [LogsController::class, 'marcarResuelto'])->middleware('permission:facturacion.logs.edit'); // Marcar como resuelto
        Route::delete('/limpiar', [LogsController::class, 'limpiarLogsAntiguos'])->middleware('permission:facturacion.logs.delete'); // Limpiar logs antiguos
        Route::post('/alerta/crear', [LogsController::class, 'crearAlerta'])->middleware('permission:facturacion.logs.create'); // Crear alerta
    });

    // RUTAS DE CONFIGURACIÓN TRIBUTARIA
    Route::prefix('configuracion-tributaria')->middleware('permission:facturacion.configuracion.ver')->group(function () {
        Route::get('/', [ConfiguracionTributariaController::class, 'index']); // Obtener configuración
        Route::get('/endpoints', [ConfiguracionTributariaController::class, 'obtenerEndpoints']); // Obtener endpoints
        Route::get('/probar-conexion', [ConfiguracionTributariaController::class, 'probarConexion']); // Probar conexión

        Route::put('/', [ConfiguracionTributariaController::class, 'update'])->middleware('permission:facturacion.configuracion.edit'); // Actualizar configuración
        Route::post('/validar-sol', [ConfiguracionTributariaController::class, 'validarCredencialesSol'])->middleware('permission:facturacion.configuracion.edit'); // Validar SOL
        Route::post('/validar-certificado', [ConfiguracionTributariaController::class, 'validarCertificado'])->middleware('permission:facturacion.configuracion.edit'); // Validar certificado
        Route::post('/cambiar-ambiente', [ConfiguracionTributariaController::class, 'cambiarAmbiente'])->middleware('permission:facturacion.configuracion.edit'); // Cambiar ambiente
    });

    // RUTAS DE INTEGRACIONES
    Route::prefix('integraciones')->middleware('permission:facturacion.integraciones.ver')->group(function () {
        Route::get('/', [IntegracionesController::class, 'index']); // Listar integraciones
        Route::get('/{id}', [IntegracionesController::class, 'show'])->middleware('permission:facturacion.integraciones.show'); // Ver detalle
        Route::get('/{id}/probar', [IntegracionesController::class, 'probarConexion']); // Probar conexión

        Route::post('/', [IntegracionesController::class, 'store'])->middleware('permission:facturacion.integraciones.create'); // Crear integración
        Route::put('/{id}', [IntegracionesController::class, 'update'])->middleware('permission:facturacion.integraciones.edit'); // Actualizar integración
        Route::delete('/{id}', [IntegracionesController::class, 'destroy'])->middleware('permission:facturacion.integraciones.delete'); // Eliminar integración
        Route::post('/culqi', [IntegracionesController::class, 'culqi'])->middleware('permission:facturacion.integraciones.edit'); // Integración Culqi
        Route::post('/contabilidad', [IntegracionesController::class, 'contabilidad'])->middleware('permission:facturacion.integraciones.edit'); // Integración contable
        Route::post('/sincronizar', [IntegracionesController::class, 'sincronizarTodas'])->middleware('permission:facturacion.integraciones.edit'); // Sincronizar todas
    });

    // WEBHOOK PARA INTEGRACIONES
    Route::post('/integraciones/{integracionId}/webhook', [IntegracionesController::class, 'webhook']); // Webhook genérico

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

    // RUTAS DE COTIZACIONES
    Route::prefix('cotizaciones')->middleware('permission:cotizaciones.ver')->group(function () {
        // Rutas administrativas de lectura
        Route::get('/', [CotizacionesController::class, 'index']); // Listar todas
        Route::get('/estadisticas', [CotizacionesController::class, 'estadisticas']); // Estadísticas
        Route::get('/estados/lista', [CotizacionesController::class, 'getEstados']); // Obtener estados
        Route::get('/{id}', [CotizacionesController::class, 'show'])->middleware('permission:cotizaciones.show'); // Ver detalle
        Route::get('/{id}/pdf', [CotizacionesController::class, 'generarPDF']); // Generar PDF
        Route::get('/{id}/tracking', [CotizacionesController::class, 'getTracking']); // Ver tracking

        // Rutas de cliente (autogestión)
        Route::get('/mis-cotizaciones', [CotizacionesController::class, 'misCotizaciones']); // Ver mis cotizaciones

        // Rutas de creación y modificación
        Route::post('/ecommerce', [CotizacionesController::class, 'crearCotizacionEcommerce'])->middleware('permission:cotizaciones.create'); // Crear cotización desde checkout
        Route::post('/{id}/convertir-compra', [CotizacionesController::class, 'convertirACompra'])->middleware('permission:cotizaciones.convertir'); // Convertir a compra
        Route::patch('/{id}/estado', [CotizacionesController::class, 'cambiarEstado'])->middleware('permission:cotizaciones.edit'); // Cambiar estado
    });

    // RUTAS DE COMPRAS
    Route::prefix('compras')->middleware('permission:compras.ver')->group(function () {
        // Rutas administrativas de lectura
        Route::get('/', [ComprasController::class, 'index']); // Listar todas
        Route::get('/estadisticas', [ComprasController::class, 'estadisticas']); // Estadísticas
        Route::get('/estados/lista', [ComprasController::class, 'getEstados']); // Obtener estados
        Route::get('/{id}', [ComprasController::class, 'show'])->middleware('permission:compras.show'); // Ver detalle
        Route::get('/{id}/tracking', [ComprasController::class, 'getTracking']); // Ver tracking

        // Rutas de cliente (autogestión)
        Route::get('/mis-compras', [ComprasController::class, 'misCompras']); // Ver mis compras

        // Rutas de creación
        Route::post('/', [ComprasController::class, 'store'])->middleware('permission:compras.create'); // Crear compra desde ecommerce

        // Rutas de modificación
        Route::post('/{id}/cancelar', [ComprasController::class, 'cancelar'])->middleware('permission:compras.cancelar'); // Cancelar compra
        Route::post('/{id}/aprobar', [ComprasController::class, 'aprobar'])->middleware('permission:compras.aprobar'); // Aprobar compra
        Route::post('/{id}/rechazar', [ComprasController::class, 'rechazar'])->middleware('permission:compras.aprobar'); // Rechazar compra
        Route::patch('/{id}/estado', [ComprasController::class, 'cambiarEstado'])->middleware('permission:compras.edit'); // Cambiar estado
        Route::post('/{id}/procesar-pago', [ComprasController::class, 'procesarPago'])->middleware('permission:compras.edit'); // Procesar pago
    });

});

// ========================================
// RUTAS DE PRUEBA - FACTURACIÓN ELECTRÓNICA
// ========================================
use App\Http\Controllers\Facturacion\TestFacturacionController;

Route::prefix('facturacion/test')->group(function () {
    Route::get('/generar-factura-prueba', [TestFacturacionController::class, 'generarFacturaPrueba']);
    Route::get('/verificar-configuracion', [TestFacturacionController::class, 'verificarConfiguracion']);
    Route::get('/estado-sunat', [TestFacturacionController::class, 'estadoSunat']);
});

// ============================================
// RUTAS DE CONTABILIDAD
// ============================================

use App\Http\Controllers\Cliente\MisDocumentosController;
use App\Http\Controllers\Contabilidad\CajaChicaController;
use App\Http\Controllers\Contabilidad\CajasController;
use App\Http\Controllers\Contabilidad\CuentasPorCobrarController;
use App\Http\Controllers\Contabilidad\CuentasPorPagarController;
use App\Http\Controllers\Contabilidad\ExportacionesController;
use App\Http\Controllers\Contabilidad\FlujoCajaController;
use App\Http\Controllers\Contabilidad\KardexController;
use App\Http\Controllers\Contabilidad\ProveedoresController;
use App\Http\Controllers\Contabilidad\ReportesContablesController;
use App\Http\Controllers\Contabilidad\UtilidadesController;
use App\Http\Controllers\Contabilidad\VouchersController;

Route::middleware(['auth:sanctum'])->prefix('contabilidad')->group(function () {

    // ============================================
    // CAJAS - Control de efectivo diario
    // ============================================
    Route::middleware('permission:contabilidad.cajas.ver')->group(function () {
        Route::get('/cajas', [CajasController::class, 'index']);
        Route::get('/cajas/{id}/reporte', [CajasController::class, 'reporte']);
    });

    Route::middleware('permission:contabilidad.cajas.create')->group(function () {
        Route::post('/cajas', [CajasController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.cajas.edit')->group(function () {
        Route::post('/cajas/aperturar', [CajasController::class, 'aperturar']);
        Route::post('/cajas/{id}/cerrar', [CajasController::class, 'cerrar']);
        Route::post('/cajas/transaccion', [CajasController::class, 'registrarTransaccion']);
    });

    // ============================================
    // KARDEX - Control de inventario
    // ============================================
    Route::middleware('permission:contabilidad.kardex.ver')->group(function () {
        Route::get('/kardex/producto/{productoId}', [KardexController::class, 'show']);
        Route::get('/kardex/inventario-valorizado', [KardexController::class, 'inventarioValorizado']);
    });

    Route::middleware('permission:contabilidad.kardex.edit')->group(function () {
        Route::post('/kardex/ajuste', [KardexController::class, 'ajuste']);
    });

    // ============================================
    // CUENTAS POR COBRAR - Créditos a clientes
    // ============================================
    Route::middleware('permission:contabilidad.cxc.ver')->group(function () {
        Route::get('/cuentas-por-cobrar', [CuentasPorCobrarController::class, 'index']);
        Route::get('/cuentas-por-cobrar/antiguedad-saldos', [CuentasPorCobrarController::class, 'antiguedadSaldos']);
    });

    Route::middleware('permission:contabilidad.cxc.create')->group(function () {
        Route::post('/cuentas-por-cobrar', [CuentasPorCobrarController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.cxc.edit')->group(function () {
        Route::post('/cuentas-por-cobrar/{id}/pago', [CuentasPorCobrarController::class, 'registrarPago']);
    });

    // ============================================
    // CUENTAS POR PAGAR - Deudas con proveedores
    // ============================================
    Route::middleware('permission:contabilidad.cxp.ver')->group(function () {
        Route::get('/cuentas-por-pagar', [CuentasPorPagarController::class, 'index']);
        Route::get('/cuentas-por-pagar/antiguedad-saldos', [CuentasPorPagarController::class, 'antiguedadSaldos']);
    });

    Route::middleware('permission:contabilidad.cxp.create')->group(function () {
        Route::post('/cuentas-por-pagar', [CuentasPorPagarController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.cxp.edit')->group(function () {
        Route::post('/cuentas-por-pagar/{id}/pago', [CuentasPorPagarController::class, 'registrarPago']);
    });

    // ============================================
    // PROVEEDORES
    // ============================================
    Route::middleware('permission:contabilidad.proveedores.ver')->group(function () {
        Route::get('/proveedores', [ProveedoresController::class, 'index']);
        Route::get('/proveedores/{id}', [ProveedoresController::class, 'show']);
    });

    Route::middleware('permission:contabilidad.proveedores.create')->group(function () {
        Route::post('/proveedores', [ProveedoresController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.proveedores.edit')->group(function () {
        Route::put('/proveedores/{id}', [ProveedoresController::class, 'update']);
    });

    // ============================================
    // CAJA CHICA - Gastos menores
    // ============================================
    Route::middleware('permission:contabilidad.caja_chica.ver')->group(function () {
        Route::get('/caja-chica', [CajaChicaController::class, 'index']);
        Route::get('/caja-chica/{id}/rendicion', [CajaChicaController::class, 'rendicion']);
    });

    Route::middleware('permission:contabilidad.caja_chica.create')->group(function () {
        Route::post('/caja-chica', [CajaChicaController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.caja_chica.edit')->group(function () {
        Route::post('/caja-chica/gasto', [CajaChicaController::class, 'registrarGasto']);
        Route::post('/caja-chica/{id}/reposicion', [CajaChicaController::class, 'reposicion']);
    });

    // ============================================
    // FLUJO DE CAJA - Proyecciones
    // ============================================
    Route::middleware('permission:contabilidad.flujo_caja.ver')->group(function () {
        Route::get('/flujo-caja', [FlujoCajaController::class, 'index']);
        Route::get('/flujo-caja/proyeccion-mensual', [FlujoCajaController::class, 'proyeccionMensual']);
    });

    Route::middleware('permission:contabilidad.flujo_caja.create')->group(function () {
        Route::post('/flujo-caja', [FlujoCajaController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.flujo_caja.edit')->group(function () {
        Route::post('/flujo-caja/{id}/registrar-real', [FlujoCajaController::class, 'registrarReal']);
    });

    // ============================================
    // REPORTES CONTABLES
    // ============================================
    Route::middleware('permission:contabilidad.reportes.ver')->group(function () {
        Route::get('/reportes/ventas-diarias', [ReportesContablesController::class, 'ventasDiarias']);
        Route::get('/reportes/ventas-mensuales', [ReportesContablesController::class, 'ventasMensuales']);
        Route::get('/reportes/productos-mas-vendidos', [ReportesContablesController::class, 'productosMasVendidos']);
        Route::get('/reportes/rentabilidad-productos', [ReportesContablesController::class, 'rentabilidadProductos']);
        Route::get('/reportes/dashboard-financiero', [ReportesContablesController::class, 'dashboardFinanciero']);
    });

    // ============================================
    // UTILIDADES Y RENTABILIDAD
    // ============================================
    Route::middleware('permission:contabilidad.utilidades.ver')->group(function () {
        // Consultas de utilidad
        Route::get('/utilidades/venta/{ventaId}', [UtilidadesController::class, 'calcularUtilidadVenta']);
        Route::get('/utilidades/reporte', [UtilidadesController::class, 'reporteUtilidades']);
        Route::get('/utilidades/por-producto', [UtilidadesController::class, 'utilidadPorProducto']);
        Route::get('/utilidades/gastos', [UtilidadesController::class, 'listarGastos']);
        Route::get('/utilidades/gastos/por-categoria', [UtilidadesController::class, 'gastosPorCategoria']);
        Route::get('/utilidades/comparativa/{anio}', [UtilidadesController::class, 'comparativaMensual']);
        Route::get('/utilidades/punto-equilibrio', [UtilidadesController::class, 'puntoEquilibrio']);
    });

    Route::middleware('permission:contabilidad.utilidades.create')->group(function () {
        // Registro de gastos
        Route::post('/utilidades/gastos', [UtilidadesController::class, 'registrarGasto']);
    });

    Route::middleware('permission:contabilidad.utilidades.edit')->group(function () {
        // Cálculos y actualizaciones
        Route::post('/utilidades/mensual/{mes}/{anio}', [UtilidadesController::class, 'calcularUtilidadMensual']);
    });

    // ============================================
    // EXPORTACIONES - PDF y Excel
    // ============================================
    Route::middleware('permission:contabilidad.reportes.ver')->group(function () {
        // Exportar Caja
        Route::get('/exportar/caja/{id}/pdf', [ExportacionesController::class, 'exportarCajaPDF']);
        Route::get('/exportar/caja/{id}/excel', [ExportacionesController::class, 'exportarCajaExcel']);

        // Exportar Kardex
        Route::get('/exportar/kardex/{productoId}/pdf', [ExportacionesController::class, 'exportarKardexPDF']);
        Route::get('/exportar/kardex/{productoId}/excel', [ExportacionesController::class, 'exportarKardexExcel']);

        // Exportar Cuentas por Cobrar
        Route::get('/exportar/cxc/pdf', [ExportacionesController::class, 'exportarCxCPDF']);
        Route::get('/exportar/cxc/excel', [ExportacionesController::class, 'exportarCxCExcel']);

        // Exportar Utilidades
        Route::get('/exportar/utilidades/pdf', [ExportacionesController::class, 'exportarUtilidadesPDF']);
        Route::get('/exportar/utilidades/excel', [ExportacionesController::class, 'exportarUtilidadesExcel']);

        // Exportar TXT - Formato PLE SUNAT
        Route::post('/exportar/ple/registro-ventas', [ExportacionesController::class, 'exportarRegistroVentasTXT']);
        Route::post('/exportar/ple/registro-compras', [ExportacionesController::class, 'exportarRegistroComprasTXT']);

        // Exportar TXT - Reportes simples
        Route::get('/exportar/ventas/txt', [ExportacionesController::class, 'exportarVentasTXT']);
        Route::get('/exportar/kardex/{productoId}/txt', [ExportacionesController::class, 'exportarKardexTXT']);
    });

    // ============================================
    // VOUCHERS / BAUCHERS - Comprobantes de pago
    // ============================================
    Route::middleware('permission:contabilidad.vouchers.ver')->group(function () {
        Route::get('/vouchers', [VouchersController::class, 'index']);
        Route::get('/vouchers/pendientes', [VouchersController::class, 'pendientes']);
        Route::get('/vouchers/{id}', [VouchersController::class, 'show']);
        Route::get('/vouchers/{id}/descargar', [VouchersController::class, 'descargarArchivo']);
    });

    Route::middleware('permission:contabilidad.vouchers.create')->group(function () {
        Route::post('/vouchers', [VouchersController::class, 'store']);
    });

    Route::middleware('permission:contabilidad.vouchers.edit')->group(function () {
        Route::post('/vouchers/{id}', [VouchersController::class, 'update']);
        Route::post('/vouchers/{id}/verificar', [VouchersController::class, 'verificar']);
    });

    Route::middleware('permission:contabilidad.vouchers.delete')->group(function () {
        Route::delete('/vouchers/{id}', [VouchersController::class, 'destroy']);
    });
});

// ============================================
// RUTAS PARA CLIENTES - Mis Documentos
// ============================================
Route::middleware(['auth:sanctum'])->prefix('cliente')->group(function () {
    // Mis comprobantes
    Route::get('/mis-comprobantes', [MisDocumentosController::class, 'misComprobantes']);
    Route::get('/mis-comprobantes/{id}', [MisDocumentosController::class, 'verComprobante']);
    Route::get('/mis-comprobantes/{id}/pdf', [MisDocumentosController::class, 'descargarComprobantePDF'])->name('api.cliente.descargar-comprobante');
    Route::get('/mis-comprobantes/{id}/xml', [MisDocumentosController::class, 'descargarComprobanteXML']);
    Route::post('/mis-comprobantes/{id}/reenviar', [MisDocumentosController::class, 'reenviarComprobante']);

    // Mis ventas
    Route::get('/mis-ventas', [MisDocumentosController::class, 'misVentas']);

    // Mis cuentas por cobrar
    Route::get('/mis-cuentas', [MisDocumentosController::class, 'misCuentasPorCobrar']);
    Route::get('/estado-cuenta/pdf', [MisDocumentosController::class, 'descargarEstadoCuenta']);
});
