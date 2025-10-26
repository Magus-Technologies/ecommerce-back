# DOCUMENTACIÓN COMPLETA DEL BACKEND - SISTEMA DE FACTURACIÓN ELECTRÓNICA

## ÍNDICE

1. [Flujo Correcto de Facturación](#flujo-correcto-de-facturación)
2. [Estados del Comprobante](#estados-del-comprobante)
3. [Estructura de Base de Datos](#estructura-de-base-de-datos)
4. [Endpoints Actuales](#endpoints-actuales)
5. [Endpoints Faltantes](#endpoints-faltantes)
6. [Problemas Actuales y Correcciones](#problemas-actuales-y-correcciones)
7. [Validaciones Requeridas](#validaciones-requeridas)
8. [Respuestas Esperadas de SUNAT](#respuestas-esperadas-de-sunat)
9. [Listado de Ventas para la Tabla](#listado-de-ventas-para-la-tabla)

---

## FLUJO CORRECTO DE FACTURACIÓN

### Diagrama de Flujo

```
1. CREAR VENTA
   ↓
2. GENERAR COMPROBANTE (Estado: PENDIENTE)
   ↓
3. CONSTRUIR DOCUMENTO XML (Greenter)
   ↓
4. FIRMAR XML DIGITALMENTE
   ↓
5. ENVIAR A SUNAT (Estado: ENVIADO) [MANUAL]
   ↓
6. RECIBIR RESPUESTA SUNAT
   ↓
   ├─→ ÉXITO: Estado = ACEPTADO
   │   ├─→ Guardar CDR (XML Respuesta)
   │   ├─→ Guardar Hash
   │   └─→ Generar PDF
   │
   └─→ ERROR: Estado = RECHAZADO
       └─→ Guardar mensaje de error
7. ✅ ENVÍO DE COMPROBANTES (Email/WhatsApp)
   ├─→ ✅ Email: POST /api/ventas/{id}/email
   └─→ ✅ WhatsApp: POST /api/ventas/{id}/whatsapp
```

### Pasos Detallados

#### 1. Crear Venta
- Se registra la venta en la tabla `ventas`
- Se crean los detalles en `venta_detalles`
- Estado inicial: `PENDIENTE`
- **NUEVO**: Se guardan datos de clientes registrados y no registrados

#### 2. Generar Comprobante
- Determinar tipo de comprobante según tipo de documento del cliente:
  - RUC (tipo_documento = '6') → Factura (tipo_comprobante = '01')
  - DNI (tipo_documento = '1') → Boleta (tipo_comprobante = '03')
- Obtener serie activa para el tipo de comprobante
- Generar correlativo automático
- Crear registro en tabla `comprobantes` con estado `PENDIENTE`
- Crear detalles en `comprobante_detalles`
- **NUEVO**: NO se envía automáticamente a SUNAT

#### 3. Construir Documento XML
- Usar Greenter para construir el objeto Invoice/Note
- Configurar datos de la empresa (Company)
- Configurar datos del cliente (Client)
- Agregar items/detalles (SaleDetail)
- Calcular totales con precisión decimal (2 decimales)
- Agregar leyendas (monto en letras)

#### 4. Firmar XML
- Greenter firma automáticamente con el certificado digital
- Se genera el XML firmado
- Se calcula el hash del documento

#### 5. Enviar a SUNAT (MANUAL)
- **NUEVO**: Endpoint `POST /api/ventas/{id}/enviar-sunat`
- Método: `$see->send($invoice)`
- Endpoint BETA: `https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService`
- Endpoint PRODUCCIÓN: `https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService`
- Actualizar estado a `ENVIADO`

#### 6. Procesar Respuesta
**Si es exitoso:**
- Actualizar estado a `ACEPTADO`
- Guardar CDR (Constancia de Recepción)
- Guardar hash del CDR
- Generar PDF del comprobante
- Actualizar venta a estado `FACTURADO`
- **NUEVO**: Actualizar flags `tiene_xml`, `tiene_pdf`, `tiene_cdr`

**Si hay error:**
- Actualizar estado a `RECHAZADO`
- Guardar mensaje de error de SUNAT
- Registrar en logs para análisis

#### 7. Envío de Comprobantes
- **Email**: `POST /api/ventas/{id}/email`
- **WhatsApp**: `POST /api/ventas/{id}/whatsapp`
- **NUEVO**: Datos prellenados desde la venta
- **NUEVO**: Mensajes personalizables

---

## ESTADOS DEL COMPROBANTE

### Estados Válidos

| Estado | Descripción | Puede Reenviar | Puede Anular |
|--------|-------------|----------------|--------------|
| `PENDIENTE` | Comprobante generado, no enviado a SUNAT | ✅ | ✅ |
| `ENVIADO` | Enviado a SUNAT, esperando respuesta | ❌ | ❌ |
| `ACEPTADO` | Aceptado por SUNAT | ❌ | ❌ |
| `RECHAZADO` | Rechazado por SUNAT | ✅ | ✅ |
| `ANULADO` | Anulado por el usuario | ❌ | ❌ |

### Estados de Venta

| Estado | Descripción |
|--------|-------------|
| `PENDIENTE` | Venta creada, sin comprobante |
| `FACTURADO` | Venta con comprobante aceptado por SUNAT |

---

## ESTRUCTURA DE BASE DE DATOS

### Tabla `ventas`
- `id`: Primary key
- `cliente_id`: ID del cliente (opcional)
- `user_cliente_id`: ID del cliente e-commerce (opcional)
- `total`: Total de la venta
- `estado`: PENDIENTE, FACTURADO
- `metodo_pago`: efectivo, tarjeta, transferencia
- `observaciones`: Observaciones adicionales
- `user_id`: Usuario que creó la venta
- `created_at`, `updated_at`: Timestamps

### Tabla `comprobantes`
- `id`: Primary key
- `venta_id`: ID de la venta
- `tipo_comprobante`: 01 (Factura), 03 (Boleta)
- `serie`: Serie del comprobante
- `correlativo`: Correlativo del comprobante
- `numero_completo`: Serie-correlativo
- `fecha_emision`: Fecha de emisión
- `cliente_id`: ID del cliente
- `operacion_gravada`: Monto gravado
- `total_igv`: Total IGV
- `importe_total`: Importe total
- `estado`: PENDIENTE, ENVIADO, ACEPTADO, RECHAZADO, ANULADO
- `xml_firmado`: XML firmado (base64)
- `xml_respuesta_sunat`: CDR de SUNAT (base64)
- `codigo_hash`: Hash del documento
- `mensaje_sunat`: Mensaje de SUNAT
- `errores_sunat`: Errores de SUNAT
- `fecha_envio_sunat`: Fecha de envío a SUNAT
- `fecha_respuesta_sunat`: Fecha de respuesta de SUNAT
- `fecha_aceptacion`: Fecha de aceptación
- `tiene_xml`: Flag si tiene XML
- `tiene_pdf`: Flag si tiene PDF
- `tiene_cdr`: Flag si tiene CDR
- `created_at`, `updated_at`: Timestamps

### Tabla `comprobante_detalles`
- `id`: Primary key
- `comprobante_id`: ID del comprobante
- `producto_id`: ID del producto
- `descripcion`: Descripción del producto
- `cantidad`: Cantidad
- `precio_unitario`: Precio unitario
- `valor_venta`: Valor de venta
- `igv`: IGV
- `total`: Total del detalle

### Tabla `clientes`
- `id`: Primary key
- `tipo_documento`: Tipo de documento (1=DNI, 6=RUC)
- `numero_documento`: Número de documento
- `razon_social`: Razón social
- `nombre_comercial`: Nombre comercial
- `direccion`: Dirección
- `email`: Email
- `telefono`: Teléfono
- `activo`: Si está activo

---

## ENDPOINTS ACTUALES

### Ventas
- `GET /api/ventas` - Listar ventas
- `POST /api/ventas` - Crear venta
- `GET /api/ventas/{id}` - Ver detalle de venta
- `POST /api/ventas/{id}/facturar` - Generar comprobante
- `POST /api/ventas/{id}/enviar-sunat` - Enviar a SUNAT
- `POST /api/ventas/{id}/email` - Enviar por email
- `POST /api/ventas/{id}/whatsapp` - Enviar por WhatsApp
- `GET /api/ventas/{id}/pdf` - Descargar PDF
- `GET /api/ventas/{id}/xml` - Descargar XML
- `GET /api/ventas/{id}/cdr` - Descargar CDR

### Comprobantes
- `GET /api/comprobantes` - Listar comprobantes
- `GET /api/comprobantes/{id}` - Ver detalle de comprobante
- `POST /api/comprobantes/{id}/enviar-sunat` - Enviar a SUNAT
- `POST /api/comprobantes/{id}/consultar-estado` - Consultar estado
- `POST /api/comprobantes/{id}/anular` - Anular comprobante

---

## ENDPOINTS FALTANTES

### ✅ IMPLEMENTADOS
- `POST /api/ventas/{id}/enviar-sunat` - Envío manual a SUNAT
- `POST /api/ventas/{id}/email` - Envío por email
- `POST /api/ventas/{id}/whatsapp` - Envío por WhatsApp
- `GET /api/ventas/{id}/email-datos` - Datos prellenados email
- `GET /api/ventas/{id}/whatsapp-datos` - Datos prellenados WhatsApp

---

## PROBLEMAS ACTUALES Y CORRECCIONES

### ✅ PROBLEMAS RESUELTOS

1. **Envío automático a SUNAT**
   - **Problema**: Se enviaba automáticamente al crear comprobante
   - **Solución**: Modificado para envío manual con `POST /api/ventas/{id}/enviar-sunat`

2. **Datos de clientes no registrados**
   - **Problema**: No se guardaban datos de clientes no registrados
   - **Solución**: Agregado campo `cliente_datos` en validación y lógica de guardado

3. **Flags incorrectos**
   - **Problema**: Flags `tiene_xml`, `tiene_pdf`, `tiene_cdr` no se actualizaban
   - **Solución**: Actualización correcta de flags según estado del comprobante

4. **Envío por email y WhatsApp**
   - **Problema**: No había endpoints para envío
   - **Solución**: Implementados endpoints con datos prellenados y personalizables

### 🔧 CORRECCIONES ADICIONALES IMPLEMENTADAS

5. **Logging para debug de clientes**
   - **Problema**: Difícil identificar errores en el guardado de clientes
   - **Solución**: Agregado logging detallado en:
     - Inicio de gestión de cliente
     - Creación de cliente nuevo
     - Creación de venta con información del cliente

6. **Gestión robusta de clientes**
   - **Problema**: Errores al guardar datos de clientes registrados y no registrados
   - **Solución**: Implementada lógica completa:
     - Cliente registrado existente (`cliente_id`)
     - Usuario cliente e-commerce (`user_cliente_id`)
     - Cliente no registrado (`cliente_datos`)
     - Fallback a "CLIENTE GENERAL"

7. **Estructura de respuesta mejorada**
   - **Problema**: Información incompleta en la tabla de ventas
   - **Solución**: Respuesta enriquecida con:
     - Información completa del cliente
     - Datos de comprobante con flags
     - Acciones disponibles según estado

### 🐛 PROBLEMAS IDENTIFICADOS Y SOLUCIONADOS

| **Problema** | **Causa** | **Solución Implementada** |
|--------------|------------|---------------------------|
| **Datos de clientes no se guardan** | Error en validación o creación | Logging detallado + validación robusta |
| **Errores en comprobantes** | Flags no se actualizan | Lógica corregida en GreenterService |
| **Errores en ver detalles** | Relaciones no cargadas | Método show con todas las relaciones |
| **Tabla no muestra datos** | Estructura de respuesta incorrecta | Respuesta enriquecida implementada |

### 📋 LOGGING IMPLEMENTADO

```php
// Log de inicio de gestión de cliente
Log::info('Iniciando gestión de cliente', [
    'cliente_id' => $request->cliente_id,
    'user_cliente_id' => $request->user_cliente_id,
    'cliente_datos' => $request->cliente_datos
]);

// Log de creación de cliente nuevo
Log::info('Cliente creado', [
    'cliente_id' => $cliente->id,
    'numero_documento' => $cliente->numero_documento,
    'razon_social' => $cliente->razon_social
]);

// Log de creación de venta
Log::info('Venta creada', [
    'venta_id' => $venta->id,
    'cliente_id' => $cliente?->id,
    'user_cliente_id' => $userCliente?->id,
    'cliente_nombre' => $cliente?->razon_social ?? $cliente?->nombre_comercial,
    'user_cliente_nombre' => $userCliente ? trim(($userCliente->nombres ?? '') . ' ' . ($userCliente->apellidos ?? '')) : null
]);
```

### 🎯 ENDPOINTS PARA TESTING

```bash
# Crear venta con cliente registrado
POST /api/ventas
{
  "cliente_id": 123,
  "productos": [
    {
      "producto_id": 1,
      "cantidad": 2,
      "precio_unitario": 100.00
    }
  ],
  "metodo_pago": "efectivo"
}

# Crear venta con cliente no registrado
POST /api/ventas
{
  "cliente_datos": {
    "tipo_documento": "1",
    "numero_documento": "12345678",
    "razon_social": "Juan Pérez",
    "email": "juan@email.com",
    "telefono": "987654321"
  },
  "productos": [
    {
      "producto_id": 1,
      "cantidad": 2,
      "precio_unitario": 100.00
    }
  ],
  "metodo_pago": "efectivo"
}

# Listar ventas (para tabla)
GET /api/ventas

# Ver detalles de venta
GET /api/ventas/{id}
```

---

## VALIDACIONES REQUERIDAS

### Crear Venta
- `cliente_id` o `user_cliente_id` o `cliente_datos` (al menos uno)
- `detalles` (array de productos)
- `metodo_pago` (obligatorio)
- `total` (calculado automáticamente)

### Generar Comprobante
- Venta debe existir
- Venta no debe estar ya facturada
- Cliente debe tener datos completos
- Serie debe estar activa

### Enviar a SUNAT
- Comprobante debe tener estado `PENDIENTE` o `RECHAZADO`
- Debe tener XML generado
- Certificado digital debe ser válido

### Envío por Email/WhatsApp
- Comprobante debe estar `ACEPTADO` por SUNAT
- Debe tener PDF generado
- Email/teléfono debe ser válido

---

## RESPUESTAS ESPERADAS DE SUNAT

### Éxito (ACEPTADO)
- Estado: `ACEPTADO`
- CDR: XML de respuesta
- Hash: Código hash del documento
- Mensaje: "El comprobante ha sido aceptado"

### Error (RECHAZADO)
- Estado: `RECHAZADO`
- Errores: Array de errores de SUNAT
- Códigos: Códigos de error específicos
- Mensaje: "El comprobante fue rechazado por SUNAT"

---

## LISTADO DE VENTAS PARA LA TABLA

### Estructura de Respuesta para GET /api/ventas

```json
{
  "success": true,
  "data": {
    "ventas": [
      {
        "id": 1,
        "numero_completo": "BT | B001 - 4465",
        "fecha_emision": "2025-10-23",
  "cliente": {
          "id": 73200847,
          "nombre": "ALESSANDRO ALBERTO BIANCHI NEGRON",
          "tipo_documento": "1",
          "numero_documento": "12345678"
        },
        "subtotal": 3135.59,
        "igv": 564.41,
        "total": 3700.00,
        "estado_venta": "FACTURADO",
        "estado_sunat": "PENDIENTE",
    "comprobante": {
      "id": 1,
          "tipo_comprobante": "03",
          "numero_completo": "BT | B001 - 4465",
        "estado": "PENDIENTE",
          "tiene_xml": true,
          "tiene_pdf": false,
          "tiene_cdr": false,
          "fecha_emision": "2025-10-23"
        },
        "acciones": {
          "puede_enviar_sunat": true,
          "puede_descargar_xml": true,
          "puede_descargar_pdf": false,
          "puede_enviar_email": false,
          "puede_enviar_whatsapp": false,
          "puede_anular": true
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 10,
      "total": 13765,
      "last_page": 1377,
      "from": 1,
      "to": 10
    }
  }
}
```

### Filtros Disponibles

- `estado`: PENDIENTE, FACTURADO, ANULADO
- `estado_sunat`: PENDIENTE, ENVIADO, ACEPTADO, RECHAZADO
- `tipo_comprobante`: 01 (Factura), 03 (Boleta)
- `fecha_desde`: Fecha inicio (YYYY-MM-DD)
- `fecha_hasta`: Fecha fin (YYYY-MM-DD)
- `cliente_id`: ID del cliente
- `numero_documento`: Número de documento del cliente

### Ejemplo de Consulta

```bash
GET /api/ventas?estado=FACTURADO&estado_sunat=PENDIENTE&page=1&per_page=10
```

### Acciones Disponibles en la Tabla

| **Acción** | **Endpoint** | **Condición** | **Descripción** |
|------------|--------------|---------------|-----------------|
| **Facturar** | `POST /api/ventas/{id}/facturar` | `estado = PENDIENTE` | Generar comprobante |
| **Enviar SUNAT** | `POST /api/ventas/{id}/enviar-sunat` | `comprobante.estado = PENDIENTE` | Enviar a SUNAT |
| **Descargar XML** | `GET /api/ventas/{id}/xml` | `comprobante.tiene_xml = true` | Descargar XML |
| **Descargar PDF** | `GET /api/ventas/{id}/pdf` | `comprobante.tiene_pdf = true` | Descargar PDF |
| **Enviar Email** | `POST /api/ventas/{id}/email` | `comprobante.estado = ACEPTADO` | Enviar por email |
| **Enviar WhatsApp** | `POST /api/ventas/{id}/whatsapp` | `comprobante.estado = ACEPTADO` | Enviar por WhatsApp |
| **Ver Detalle** | `GET /api/ventas/{id}` | Siempre | Ver detalles de la venta |
| **Anular** | `PATCH /api/ventas/{id}/anular` | `estado = PENDIENTE` | Anular venta |

### Estados y Acciones Disponibles

| **Estado de Venta** | **Estado Comprobante** | **Acciones Disponibles** |
|---------------------|------------------------|---------------------------|
| `PENDIENTE` | Sin comprobante | Facturar, Ver Detalle, Anular |
| `FACTURADO` | `PENDIENTE` | Enviar SUNAT, Descargar XML, Ver Detalle |
| `FACTURADO` | `ENVIADO` | Ver Detalle |
| `FACTURADO` | `ACEPTADO` | Descargar XML, Descargar PDF, Enviar Email, Enviar WhatsApp, Ver Detalle |
| `FACTURADO` | `RECHAZADO` | Enviar SUNAT, Descargar XML, Ver Detalle |
| `ANULADO` | Cualquiera | Ver Detalle |

### Correspondencia con la Tabla Actual

| **Columna de la Tabla** | **Campo del Backend** | **Descripción** |
|-------------------------|----------------------|-----------------|
| **Código** | `id` | ID único de la venta |
| **Cliente** | `cliente.nombre` | Nombre del cliente |
| **Fecha** | `created_at` | Fecha de creación de la venta |
| **Total** | `total` | Total de la venta |
| **Estado** | `estado` | Estado de la venta (PENDIENTE, FACTURADO) |
| **Comprobante** | `comprobante.numero_completo` | Número del comprobante (si existe) |
| **Acciones** | `acciones` | Botones disponibles según estado |

### Estructura de Respuesta Actualizada

```json
{
  "success": true,
  "data": {
    "ventas": [
    {
      "id": 1,
        "codigo": "V001-000001",
        "cliente": {
          "id": 123,
          "nombre": "ALESSANDRO ALBERTO BIANCHI NEGRON",
          "tipo_documento": "1",
          "numero_documento": "12345678"
        },
        "fecha": "2025-10-23",
        "total": 3700.00,
        "estado": "FACTURADO",
        "comprobante": {
        "id": 1,
          "numero_completo": "BT | B001 - 4465",
          "tipo_comprobante": "03",
          "estado": "PENDIENTE",
          "tiene_xml": true,
          "tiene_pdf": false,
          "tiene_cdr": false
        },
        "acciones": {
          "puede_facturar": false,
          "puede_enviar_sunat": true,
          "puede_descargar_xml": true,
          "puede_descargar_pdf": false,
          "puede_enviar_email": false,
          "puede_enviar_whatsapp": false,
          "puede_anular": true,
          "puede_ver_detalle": true
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 10,
      "total": 13765,
      "last_page": 1377,
      "from": 1,
      "to": 10
    }
  }
}
```

---

## DEBUGGING Y TROUBLESHOOTING

### 🔍 CÓMO IDENTIFICAR PROBLEMAS

1. **Revisar logs de Laravel**:
   ```bash
   tail -f storage/logs/laravel.log
   ```

2. **Buscar logs específicos**:
   - `Iniciando gestión de cliente` - Verifica datos de entrada
   - `Cliente creado` - Confirma creación de cliente nuevo
   - `Venta creada` - Verifica asociación cliente-venta

3. **Verificar base de datos**:
   ```sql
   -- Verificar clientes creados
   SELECT * FROM clientes ORDER BY created_at DESC LIMIT 10;
   
   -- Verificar ventas con clientes
   SELECT v.id, v.cliente_id, v.user_cliente_id, c.razon_social 
   FROM ventas v 
   LEFT JOIN clientes c ON v.cliente_id = c.id 
   ORDER BY v.created_at DESC LIMIT 10;
   ```

### 🐛 PROBLEMAS COMUNES Y SOLUCIONES

| **Problema** | **Síntoma** | **Solución** |
|--------------|-------------|--------------|
| **Cliente no aparece en tabla** | `cliente_info` vacío | Verificar que `cliente_id` o `user_cliente_id` se asigne correctamente |
| **Datos de cliente incompletos** | Campos null en respuesta | Verificar validación de `cliente_datos` |
| **Error al crear venta** | Exception en logs | Revisar transacción DB y rollback |
| **Comprobante no se genera** | `comprobante_info` null | Verificar que `POST /api/ventas/{id}/facturar` se ejecute |

### 📊 VERIFICACIÓN DE DATOS

```bash
# 1. Crear venta con cliente registrado
curl -X POST /api/ventas \
  -H "Content-Type: application/json" \
  -d '{
    "cliente_id": 123,
    "productos": [{"producto_id": 1, "cantidad": 2, "precio_unitario": 100}],
    "metodo_pago": "efectivo"
  }'

# 2. Crear venta con cliente no registrado
curl -X POST /api/ventas \
  -H "Content-Type: application/json" \
  -d '{
    "cliente_datos": {
      "tipo_documento": "1",
      "numero_documento": "12345678",
      "razon_social": "Juan Pérez"
    },
    "productos": [{"producto_id": 1, "cantidad": 2, "precio_unitario": 100}],
    "metodo_pago": "efectivo"
  }'

# 3. Verificar respuesta de tabla
curl -X GET /api/ventas
```

### ✅ CHECKLIST DE VERIFICACIÓN

- [ ] **Cliente registrado**: `cliente_id` se asigna correctamente
- [ ] **Cliente no registrado**: Se crea nuevo cliente en BD
- [ ] **Usuario cliente**: `user_cliente_id` se asigna correctamente
- [ ] **Fallback**: Se usa "CLIENTE GENERAL" si no hay datos
- [ ] **Logs**: Aparecen logs de debug en `laravel.log`
- [ ] **Tabla**: Datos aparecen en `GET /api/ventas`
- [ ] **Detalles**: `GET /api/ventas/{id}` muestra información completa

---

## CONFIGURACIÓN REQUERIDA

### Variables de Entorno (.env)

- `GREENTER_MODE`: BETA o PRODUCCION
- `GREENTER_CERT_PATH`: Ruta del certificado digital
- `GREENTER_FE_USER`: Usuario FE de SUNAT
- `GREENTER_FE_PASSWORD`: Contraseña FE de SUNAT
- `GREENTER_CLAVE_SOL`: Clave SOL de SUNAT
- `COMPANY_RUC`: RUC de la empresa
- `COMPANY_NAME`: Razón social de la empresa
- `COMPANY_ADDRESS`: Dirección de la empresa

### Endpoints Principales

- `GET /api/ventas` - Listar ventas con filtros
- `POST /api/ventas` - Crear venta
- `POST /api/ventas/{id}/facturar` - Generar comprobante
- `POST /api/ventas/{id}/enviar-sunat` - Enviar a SUNAT
- `POST /api/ventas/{id}/email` - Enviar por email
- `POST /api/ventas/{id}/whatsapp` - Enviar por WhatsApp

---

## FIN DEL DOCUMENTO

Este documento cubre todos los aspectos del sistema de facturación electrónica del backend.