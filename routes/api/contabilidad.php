<?php

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
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Módulo de Contabilidad
|--------------------------------------------------------------------------
|
| Sistema de gestión contable, cajas, cuentas y reportes financieros
|
*/

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
        Route::get('/utilidades/venta/{ventaId}', [UtilidadesController::class, 'calcularUtilidadVenta']);
        Route::get('/utilidades/reporte', [UtilidadesController::class, 'reporteUtilidades']);
        Route::get('/utilidades/por-producto', [UtilidadesController::class, 'utilidadPorProducto']);
        Route::get('/utilidades/gastos', [UtilidadesController::class, 'listarGastos']);
        Route::get('/utilidades/gastos/por-categoria', [UtilidadesController::class, 'gastosPorCategoria']);
        Route::get('/utilidades/comparativa/{anio}', [UtilidadesController::class, 'comparativaMensual']);
        Route::get('/utilidades/punto-equilibrio', [UtilidadesController::class, 'puntoEquilibrio']);
    });

    Route::middleware('permission:contabilidad.utilidades.create')->group(function () {
        Route::post('/utilidades/gastos', [UtilidadesController::class, 'registrarGasto']);
    });

    Route::middleware('permission:contabilidad.utilidades.edit')->group(function () {
        Route::post('/utilidades/mensual/{mes}/{anio}', [UtilidadesController::class, 'calcularUtilidadMensual']);
    });

    // ============================================
    // EXPORTACIONES - PDF y Excel
    // ============================================
    Route::middleware('permission:contabilidad.reportes.ver')->group(function () {
        Route::get('/exportar/caja/{id}/pdf', [ExportacionesController::class, 'exportarCajaPDF']);
        Route::get('/exportar/caja/{id}/excel', [ExportacionesController::class, 'exportarCajaExcel']);
        Route::get('/exportar/kardex/{productoId}/pdf', [ExportacionesController::class, 'exportarKardexPDF']);
        Route::get('/exportar/kardex/{productoId}/excel', [ExportacionesController::class, 'exportarKardexExcel']);
        Route::get('/exportar/cxc/pdf', [ExportacionesController::class, 'exportarCxCPDF']);
        Route::get('/exportar/cxc/excel', [ExportacionesController::class, 'exportarCxCExcel']);
        Route::get('/exportar/utilidades/pdf', [ExportacionesController::class, 'exportarUtilidadesPDF']);
        Route::get('/exportar/utilidades/excel', [ExportacionesController::class, 'exportarUtilidadesExcel']);
        Route::post('/exportar/ple/registro-ventas', [ExportacionesController::class, 'exportarRegistroVentasTXT']);
        Route::post('/exportar/ple/registro-compras', [ExportacionesController::class, 'exportarRegistroComprasTXT']);
        Route::get('/exportar/ventas/txt', [ExportacionesController::class, 'exportarVentasTXT']);
        Route::get('/exportar/kardex/{productoId}/txt', [ExportacionesController::class, 'exportarKardexTXT']);
    });
});
