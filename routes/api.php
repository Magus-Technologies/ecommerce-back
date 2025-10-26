<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Estructura Modular
|--------------------------------------------------------------------------
|
| Las rutas están organizadas en módulos por dominio de negocio.
| Cada módulo se encuentra en routes/api/{modulo}.php
|
| Estructura:
| - public.php: Rutas sin autenticación
| - admin.php: Administración y autenticación
| - facturacion.php: Facturación electrónica y SUNAT
| - contabilidad.php: Módulo contable
| - productos.php: Gestión de inventario
| - recompensas.php: Sistema de gamificación
| - ecommerce.php: Pedidos y carrito
| - marketing.php: Banners y promociones
|
*/

// Rutas públicas (sin autenticación)
require __DIR__.'/api/public.php';

// Rutas de administración y autenticación
require __DIR__.'/api/admin.php';

// Módulos de negocio (requieren autenticación)
require __DIR__.'/api/facturacion.php';
require __DIR__.'/api/contabilidad.php';
require __DIR__.'/api/productos.php';
require __DIR__.'/api/recompensas.php';
require __DIR__.'/api/ecommerce.php';
require __DIR__.'/api/marketing.php';
