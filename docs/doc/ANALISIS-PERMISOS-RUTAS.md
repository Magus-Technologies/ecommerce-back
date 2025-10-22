# 🔍 ANÁLISIS DE PERMISOS Y RUTAS - MÓDULOS CONTABILIDAD, CLIENTE Y FACTURACIÓN

## ❌ PROBLEMAS IDENTIFICADOS

### 1. **MÓDULO CONTABILIDAD**
**Problema:** Las rutas usan `auth:api` en lugar de `auth:sanctum`

```php
// ❌ INCORRECTO (línea actual)
Route::middleware(['auth:api'])->prefix('contabilidad')->group(function () {

// ✅ CORRECTO (debe ser)
Route::middleware(['auth:sanctum'])->prefix('contabilidad')->group(function () {
```

**Impacto:** Los usuarios autenticados con Sanctum NO pueden acceder a ninguna ruta de contabilidad, incluyendo:
- Kardex
- Cajas
- Cuentas por Cobrar/Pagar
- Reportes
- Utilidades
- Vouchers

---

### 2. **MÓDULO CLIENTE (MisDocumentosController)**
**Problema:** Las rutas usan `auth:api` en lugar de `auth:sanctum`

```php
// ❌ INCORRECTO (línea actual)
Route::middleware(['auth:api'])->prefix('cliente')->group(function () {

// ✅ CORRECTO (debe ser)
Route::middleware(['auth:sanctum'])->prefix('cliente')->group(function () {
```

**Impacto:** Los clientes NO pueden acceder a:
- Mis comprobantes
- Descargar PDF/XML
- Mis ventas
- Mis cuentas por cobrar
- Estado de cuenta

---

### 3. **MÓDULO FACTURACIÓN**
**Estado:** ✅ Las rutas de facturación SÍ están correctamente configuradas con `auth:sanctum`

```php
// ✅ CORRECTO
Route::middleware('auth:sanctum')->group(function () {
    Route::prefix('comprobantes')->group(function () {
        // Rutas de comprobantes
    });
    
    Route::prefix('facturacion')->group(function () {
        // Rutas de facturación
    });
});
```

**Pero falta:** Agregar permisos específicos a las rutas de facturación

---

## 📋 COMPARACIÓN CON MÓDULO RECOMPENSAS (REFERENCIA)

### ✅ Patrón Correcto de Recompensas:
```php
Route::prefix('admin/recompensas')
    ->middleware('permission:recompensas.ver')
    ->group(function () {
        
        // Listar
        Route::get('/', [RecompensaController::class, 'index']);
        
        // Ver detalle
        Route::get('/{id}', [RecompensaController::class, 'show'])
            ->middleware('permission:recompensas.show');
        
        // Crear
        Route::post('/', [RecompensaController::class, 'store'])
            ->middleware('permission:recompensas.create');
        
        // Editar
        Route::put('/{id}', [RecompensaController::class, 'update'])
            ->middleware('permission:recompensas.edit');
        
        // Eliminar
        Route::delete('/{id}', [RecompensaController::class, 'destroy'])
            ->middleware('permission:recompensas.delete');
    });
```

---

## 🔧 SOLUCIONES REQUERIDAS

### Solución 1: Corregir Middleware de Contabilidad
**Archivo:** `routes/api.php`
**Línea aproximada:** ~1050

```php
// CAMBIAR ESTO:
Route::middleware(['auth:api'])->prefix('contabilidad')->group(function () {

// POR ESTO:
Route::middleware(['auth:sanctum'])->prefix('contabilidad')->group(function () {
```

---

### Solución 2: Corregir Middleware de Cliente
**Archivo:** `routes/api.php`
**Línea aproximada:** ~1200

```php
// CAMBIAR ESTO:
Route::middleware(['auth:api'])->prefix('cliente')->group(function () {

// POR ESTO:
Route::middleware(['auth:sanctum'])->prefix('cliente')->group(function () {
```

---

### Solución 3: Agregar Permisos a Facturación
**Archivo:** `routes/api.php`

Las rutas de facturación necesitan permisos específicos. Actualmente están dentro de `auth:sanctum` pero sin permisos granulares.

**Ejemplo de cómo deberían estar:**

```php
// Comprobantes
Route::prefix('comprobantes')->group(function () {
    Route::middleware('permission:facturacion.comprobantes.ver')->group(function () {
        Route::get('/', [ComprobantesController::class, 'index']);
        Route::get('/{id}', [ComprobantesController::class, 'show']);
    });
    
    Route::post('/{id}/reenviar', [ComprobantesController::class, 'reenviar'])
        ->middleware('permission:facturacion.comprobantes.edit');
});

// Facturas
Route::prefix('facturas')->group(function () {
    Route::middleware('permission:facturacion.facturas.ver')->group(function () {
        Route::get('/', [FacturacionManualController::class, 'index']);
        Route::get('/{id}', [FacturacionManualController::class, 'show']);
    });
    
    Route::post('/', [FacturacionManualController::class, 'store'])
        ->middleware('permission:facturacion.facturas.create');
});
```

---

## 📊 PERMISOS NECESARIOS EN LA BASE DE DATOS

### Verificar que existan estos permisos en el seeder:

#### Facturación:
```php
'facturacion.comprobantes.ver',
'facturacion.comprobantes.create',
'facturacion.comprobantes.edit',
'facturacion.comprobantes.delete',
'facturacion.facturas.ver',
'facturacion.facturas.create',
'facturacion.facturas.edit',
'facturacion.series.ver',
'facturacion.series.create',
'facturacion.series.edit',
'facturacion.notas_credito.ver',
'facturacion.notas_credito.create',
'facturacion.notas_debito.ver',
'facturacion.notas_debito.create',
'facturacion.guias_remision.ver',
'facturacion.guias_remision.create',
```

#### Contabilidad (ya existen):
```php
'contabilidad.cajas.ver',
'contabilidad.cajas.create',
'contabilidad.cajas.edit',
'contabilidad.kardex.ver',
'contabilidad.kardex.edit',
'contabilidad.cxc.ver',
'contabilidad.cxc.create',
'contabilidad.cxc.edit',
// ... etc
```

---

## 🎯 RESUMEN DE ACCIONES

### ✅ Acción 1: Cambiar `auth:api` por `auth:sanctum`
- **Módulo Contabilidad:** 1 cambio
- **Módulo Cliente:** 1 cambio

### ✅ Acción 2: Agregar permisos a Facturación
- Envolver rutas de comprobantes con permisos
- Envolver rutas de facturas con permisos
- Envolver rutas de series con permisos
- Envolver rutas de notas de crédito/débito con permisos

### ✅ Acción 3: Crear/Actualizar Seeder de Permisos de Facturación
- Crear `FacturacionPermissionsSeeder.php`
- Agregar permisos de facturación
- Ejecutar seeder

---

## 🔍 VERIFICACIÓN POST-CORRECCIÓN

### Comandos para verificar:
```bash
# 1. Verificar permisos en BD
php artisan tinker
>>> \Spatie\Permission\Models\Permission::where('name', 'like', 'contabilidad%')->pluck('name');
>>> \Spatie\Permission\Models\Permission::where('name', 'like', 'facturacion%')->pluck('name');

# 2. Refrescar permisos del usuario
POST /api/refresh-permissions

# 3. Probar acceso a Kardex
GET /api/contabilidad/kardex/producto/1

# 4. Probar acceso a Mis Documentos
GET /api/cliente/mis-comprobantes
```

---

## 📝 NOTAS IMPORTANTES

1. **auth:api vs auth:sanctum:**
   - `auth:api` es para autenticación con tokens de Laravel Passport
   - `auth:sanctum` es para autenticación con tokens de Laravel Sanctum
   - Tu aplicación usa Sanctum, por eso las rutas con `auth:api` no funcionan

2. **Permisos granulares:**
   - Recompensas tiene permisos muy bien estructurados
   - Contabilidad tiene permisos pero con middleware incorrecto
   - Facturación NO tiene permisos, solo autenticación

3. **Prioridad de corrección:**
   - 🔴 **CRÍTICO:** Cambiar `auth:api` a `auth:sanctum` (Contabilidad y Cliente)
   - 🟡 **IMPORTANTE:** Agregar permisos a Facturación
   - 🟢 **OPCIONAL:** Refactorizar estructura de rutas para mayor claridad
