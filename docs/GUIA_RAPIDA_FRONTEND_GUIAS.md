# Guía Rápida - Frontend Guías de Remisión

## ⚠️ IMPORTANTE - Cambios Recientes

### ❌ Eliminar del Frontend
El sistema **YA NO soporta** el tipo `TRANSPORTISTA`. Debes eliminar:
- Cualquier referencia a "GRE Transportista"
- El endpoint `/api/guias-remision/transportista` (ya no existe)
- Formularios o vistas específicas para transportista
- Validaciones relacionadas con transportista

### ✅ Tipos Disponibles (Solo 2)

El sistema ahora solo maneja **2 tipos de guías**:

#### 1. GRE Remitente (REMITENTE)
- **Código SUNAT:** 09
- **Propósito:** La emite el dueño de la mercancía cuando traslada sus productos
- **Requiere SUNAT:** Sí (envío electrónico obligatorio)
- **Uso en ecommerce:** Ventas, envíos a clientes, exportaciones
- **Transporte:** Puede ser propio (tu vehículo) o contratado (Olva, Shalom, etc.)

#### 2. Traslado Interno (INTERNO)
- **Código SUNAT:** 09 (pero no se envía a SUNAT)
- **Propósito:** Para movimientos internos entre almacenes o sucursales de la misma empresa
- **Requiere SUNAT:** No (solo control interno)
- **Uso en ecommerce:** Reposición de stock, redistribución de inventario
- **Transporte:** Interno de la empresa

---

## 📋 Tipos de Guías de Remisión

### GET `/api/guias-remision/tipos`

Obtiene los tipos de guías disponibles.

**Respuesta:**
```json
{
  "success": true,
  "data": [
    {
      "codigo": "REMITENTE",
      "nombre": "GRE Remitente",
      "tipo_comprobante": "09",
      "requiere_sunat": true,
      "descripcion": "Guías de remisión para ventas (transporte propio o contratado)"
    },
    {
      "codigo": "INTERNO",
      "nombre": "Traslado Interno",
      "tipo_comprobante": "09",
      "requiere_sunat": false,
      "descripcion": "Traslados entre almacenes de la misma empresa (no requiere SUNAT)"
    }
  ]
}
```

---

## 🚚 1. GRE Remitente (REMITENTE)

**Propósito:** Documentar el traslado de mercancías cuando TÚ eres el dueño de los productos.

**Cuándo usar:**
- Vendes productos y los envías al cliente
- Trasladas mercancía a un punto de venta
- Exportas productos
- Envías productos en consignación

**Transporte:**
- ✅ Contratado (Olva, Shalom, Cruz del Sur, etc.) - `modalidad_traslado: "01"`
- ✅ Propio (tu vehículo y conductor) - `modalidad_traslado: "02"`

**Importante:** Se envía electrónicamente a SUNAT antes del traslado.

### POST `/api/guias-remision/remitente`

**Campos Requeridos (Siempre):**
```json
{
  "motivo_traslado": "01",                      // 01=Venta, 02=Compra, 04=Traslado, etc.
  "modalidad_traslado": "01",                   // 01=Público (contratado), 02=Privado (propio)
  "fecha_inicio_traslado": "2025-11-02",
  
  // Punto de partida (tu almacén)
  "punto_partida_ubigeo": "150101",
  "punto_partida_direccion": "Av. Principal 123",
  
  // Punto de llegada (destino)
  "punto_llegada_ubigeo": "150101",
  "punto_llegada_direccion": "Jr. Destino 456",
  
  // Productos
  "productos": [
    {
      "producto_id": 1,
      "cantidad": 10,
      "peso_unitario": 2.5,
      "observaciones": "Frágil"
    }
  ],
  
  "numero_bultos": 2,
  "observaciones": "Entregar en horario de oficina"
}
```

**Destinatario (Requerido - Elige una opción):**

**Opción 1: Usar cliente como destinatario**
```json
{
  "cliente_id": 1,                              // Requerido
  "usar_cliente_como_destinatario": true
}
```
⚠️ **Requisito:** El cliente debe tener RUC (tipo_documento = '6')

**Opción 2: Ingresar destinatario manualmente**
```json
{
  "cliente_id": 1,                              // Opcional (para referencia/trazabilidad)
  "usar_cliente_como_destinatario": false,      // O no enviar este campo
  "destinatario_tipo_documento": "1",           // 1=DNI, 6=RUC (puede ser cualquiera)
  "destinatario_numero_documento": "76165962",  // DNI o RUC
  "destinatario_razon_social": "Victor Raul Canchari Riqui",
  "destinatario_direccion": "Av. Lo Herores 231, Lima",
  "destinatario_ubigeo": "150101"
}
```
✅ **Ventaja:** El destinatario puede tener DNI o RUC
✅ **Ventaja:** No requiere cliente_id (útil para envíos a personas sin registro)

**Campos Condicionales - Transporte Privado:**

Solo si `modalidad_traslado: "02"` (transporte propio):
```json
{
  "modo_transporte": "01",                      // 01=Terrestre, 02=Fluvial, 03=Aéreo, 04=Marítimo
  "numero_placa": "ABC-123",
  "conductor_dni": "12345678",
  "conductor_nombres": "Juan Pérez García"
}
```

**Ejemplo 1 - Transporte Contratado + Cliente como Destinatario:**
```json
{
  "cliente_id": 5,
  "usar_cliente_como_destinatario": true,
  "motivo_traslado": "01",
  "modalidad_traslado": "01",
  "fecha_inicio_traslado": "2025-11-02",
  "punto_partida_ubigeo": "150101",
  "punto_partida_direccion": "Av. Los Olivos 123, Lima",
  "punto_llegada_ubigeo": "150131",
  "punto_llegada_direccion": "Jr. Las Flores 456, San Isidro",
  "productos": [
    {
      "producto_id": 10,
      "cantidad": 5,
      "peso_unitario": 1.5
    }
  ],
  "numero_bultos": 1,
  "observaciones": "Envío por Olva Courier"
}
```

**Ejemplo 2 - Transporte Contratado + Destinatario Manual (DNI):**
```json
{
  "motivo_traslado": "01",
  "modalidad_traslado": "01",
  "fecha_inicio_traslado": "2025-11-02",
  "destinatario_tipo_documento": "1",
  "destinatario_numero_documento": "76165962",
  "destinatario_razon_social": "Victor Raul Canchari Riqui",
  "destinatario_direccion": "Av. Lo Herores 231, Lima",
  "destinatario_ubigeo": "150101",
  "punto_partida_ubigeo": "150101",
  "punto_partida_direccion": "Av. Los Olivos 123, Lima",
  "punto_llegada_ubigeo": "150101",
  "punto_llegada_direccion": "Av. Lo Herores 231, Lima",
  "productos": [
    {
      "producto_id": 10,
      "cantidad": 5,
      "peso_unitario": 1.5
    }
  ],
  "numero_bultos": 1,
  "observaciones": "Envío por Olva Courier"
}
```

**Ejemplo 3 - Transporte Propio:**
```json
{
  "cliente_id": 5,
  "usar_cliente_como_destinatario": true,
  "motivo_traslado": "01",
  "modalidad_traslado": "02",
  "fecha_inicio_traslado": "2025-11-02",
  "punto_partida_ubigeo": "150101",
  "punto_partida_direccion": "Av. Los Olivos 123, Lima",
  "punto_llegada_ubigeo": "150131",
  "punto_llegada_direccion": "Jr. Las Flores 456, San Isidro",
  "modo_transporte": "01",
  "numero_placa": "ABC-123",
  "conductor_dni": "12345678",
  "conductor_nombres": "Juan Pérez García",
  "productos": [
    {
      "producto_id": 10,
      "cantidad": 5,
      "peso_unitario": 1.5
    }
  ],
  "numero_bultos": 1
}
```

---

## 📦 2. Traslado Interno (INTERNO)

**Propósito:** Documentar movimientos de mercancías entre tus propias instalaciones.

**Cuándo usar:**
- Trasladas productos de almacén central a sucursal
- Redistribuyes inventario entre tiendas
- Mueves stock entre almacenes de la misma empresa
- Reposición de inventario interno

**Importante:** 
- NO se envía a SUNAT (solo para control interno)
- No requiere datos de conductor/vehículo
- Más simple que GRE Remitente

### POST `/api/guias-remision/interno`

**Campos Requeridos:**
```json
{
  "motivo_traslado": "04",                      // 04=Traslado entre establecimientos
  "fecha_inicio_traslado": "2025-11-02",
  
  // Punto de partida (almacén origen)
  "punto_partida_ubigeo": "150101",
  "punto_partida_direccion": "Almacén Central - Av. Principal 123",
  
  // Punto de llegada (almacén destino)
  "punto_llegada_ubigeo": "150131",
  "punto_llegada_direccion": "Almacén Sucursal - Jr. Secundaria 456",
  
  // Productos
  "productos": [
    {
      "producto_id": 1,
      "cantidad": 20,
      "peso_unitario": 1.0
    }
  ],
  
  "numero_bultos": 4,
  "observaciones": "Reposición de stock"
}
```

**Campos Opcionales:**
```json
{
  "destinatario_tipo_documento": "6",
  "destinatario_numero_documento": "20123456789",
  "destinatario_razon_social": "Mi Empresa SAC - Sucursal",
  "destinatario_direccion": "Jr. Secundaria 456",
  "destinatario_ubigeo": "150131"
}
```

---

## 📄 Listar Guías de Remisión

### GET `/api/guias-remision`

**Query Parameters:**
- `tipo_guia` - Filtrar por tipo: `REMITENTE` o `INTERNO`
- `estado` - Filtrar por estado: `PENDIENTE`, `ENVIADO`, `ACEPTADO`, `RECHAZADO`, `ANULADO`
- `fecha_inicio` - Fecha desde (YYYY-MM-DD)
- `fecha_fin` - Fecha hasta (YYYY-MM-DD)
- `cliente_id` - Filtrar por cliente
- `serie` - Filtrar por serie
- `per_page` - Registros por página (default: 15)

**Ejemplo:**
```
GET /api/guias-remision?tipo_guia=REMITENTE&estado=ACEPTADO&per_page=20
```

**Respuesta:**
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "tipo_guia": "REMITENTE",
        "serie": "T001",
        "correlativo": "00000001",
        "numero_completo": "T001-00000001",
        "fecha_emision": "2025-11-02",
        "fecha_inicio_traslado": "2025-11-02",
        "estado": "ACEPTADO",
        "requiere_sunat": true,
        "cliente": {
          "id": 5,
          "razon_social": "Cliente SAC"
        },
        "detalles": [
          {
            "producto_id": 10,
            "descripcion": "Producto A",
            "cantidad": 5,
            "peso_unitario": 1.5,
            "peso_total": 7.5
          }
        ]
      }
    ],
    "total": 50,
    "per_page": 15
  }
}
```

---

## 📤 Enviar a SUNAT

### POST `/api/guias-remision/{id}/enviar-sunat`

Envía la guía a SUNAT (solo para tipo `REMITENTE`).

**Respuesta Exitosa:**
```json
{
  "success": true,
  "message": "Guía de remisión enviada a SUNAT exitosamente",
  "data": {
    "id": 1,
    "estado": "ACEPTADO",
    "mensaje_sunat": "La Guía de Remisión ha sido aceptada",
    "codigo_hash": "abc123..."
  }
}
```

**Respuesta Error:**
```json
{
  "success": false,
  "message": "Error al enviar guía de remisión a SUNAT",
  "error": "El RUC del destinatario no es válido"
}
```

**Nota:** Las guías tipo `INTERNO` no se pueden enviar a SUNAT y retornarán error.

---

## 📊 Ver Detalle de Guía

### GET `/api/guias-remision/{id}`

**Respuesta:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "tipo_guia": "REMITENTE",
    "tipo_comprobante": "09",
    "serie": "T001",
    "correlativo": "00000001",
    "numero_completo": "T001-00000001",
    "fecha_emision": "2025-11-02",
    "fecha_inicio_traslado": "2025-11-02",
    "estado": "ACEPTADO",
    "requiere_sunat": true,
    
    "cliente": {
      "id": 5,
      "razon_social": "Cliente SAC",
      "numero_documento": "20123456789"
    },
    
    "destinatario_razon_social": "Cliente SAC",
    "destinatario_direccion": "Jr. Las Flores 456",
    
    "motivo_traslado": "01",
    "modalidad_traslado": "01",
    "peso_total": 7.50,
    "numero_bultos": 1,
    
    "punto_partida_direccion": "Av. Los Olivos 123",
    "punto_llegada_direccion": "Jr. Las Flores 456",
    
    "detalles": [
      {
        "item": 1,
        "producto_id": 10,
        "descripcion": "Producto A",
        "cantidad": 5,
        "peso_unitario": 1.5,
        "peso_total": 7.5
      }
    ],
    
    "xml_firmado": "<?xml...",
    "pdf_base64": "JVBERi0xLjQ...",
    "codigo_hash": "abc123...",
    "mensaje_sunat": "La Guía de Remisión ha sido aceptada"
  }
}
```

---

## 📥 Descargar XML

### GET `/api/guias-remision/{id}/xml`

**Respuesta:**
```json
{
  "success": true,
  "data": {
    "xml": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...",
    "filename": "T001-00000001.xml"
  }
}
```

---

## 📈 Estadísticas

### GET `/api/guias-remision/estadisticas`

**Query Parameters:**
- `fecha_inicio` - Fecha desde (default: inicio del mes actual)
- `fecha_fin` - Fecha hasta (default: fin del mes actual)

**Respuesta:**
```json
{
  "success": true,
  "data": {
    "total_guias": 150,
    "guias_pendientes": 10,
    "guias_enviadas": 5,
    "guias_aceptadas": 130,
    "guias_rechazadas": 5,
    "peso_total_transportado": 1250.50,
    "por_tipo": {
      "remitente": 120,
      "interno": 30
    }
  }
}
```

---

## 🔑 Catálogos SUNAT

### Motivos de Traslado
```javascript
const motivosTraslado = {
  '01': 'Venta',
  '02': 'Compra',
  '04': 'Traslado entre establecimientos de la misma empresa',
  '08': 'Importación',
  '09': 'Exportación',
  '13': 'Otros'
}
```

### Modalidades de Traslado
```javascript
const modalidadesTraslado = {
  '01': 'Transporte público',      // Contratado (Olva, Shalom, etc.)
  '02': 'Transporte privado'        // Propio
}
```

### Modos de Transporte
```javascript
const modosTransporte = {
  '01': 'Transporte terrestre',
  '02': 'Transporte fluvial',
  '03': 'Transporte aéreo',
  '04': 'Transporte marítimo'
}
```

### Tipos de Documento
```javascript
const tiposDocumento = {
  '1': 'DNI',
  '6': 'RUC'
}
```

---

## 🎯 Flujo Recomendado para Ecommerce

### Escenario 1: Venta con Transporte Contratado (Más Común)

1. Cliente realiza compra
2. Se genera Factura/Boleta
3. Se crea GRE Remitente con:
   - `modalidad_traslado: "01"` (público)
   - `usar_cliente_como_destinatario: true`
   - NO requiere datos de conductor/vehículo
4. Se envía a SUNAT
5. Se entrega paquete a courier (Olva, Shalom, etc.)

### Escenario 2: Venta con Transporte Propio

1. Cliente realiza compra
2. Se genera Factura/Boleta
3. Se crea GRE Remitente con:
   - `modalidad_traslado: "02"` (privado)
   - `usar_cliente_como_destinatario: true`
   - **SÍ requiere** datos de conductor/vehículo
4. Se envía a SUNAT
5. Tu personal entrega el pedido

### Escenario 3: Reposición de Stock entre Almacenes

1. Se crea Traslado Interno con:
   - `motivo_traslado: "04"`
   - Direcciones de ambos almacenes
2. **NO se envía a SUNAT**
3. Solo para control interno

---

## ⚠️ Validaciones Importantes

### Cliente vs Destinatario (GRE Remitente)

**IMPORTANTE - Cambio Reciente:**

Ahora `cliente_id` es **opcional** cuando ingresas el destinatario manualmente.

**Dos escenarios:**

#### Escenario A: Cliente es el destinatario (`usar_cliente_como_destinatario: true`)
- `cliente_id` es **REQUERIDO**
- El **cliente** debe tener RUC (tipo_documento = '6')
- Los datos del destinatario se copian automáticamente del cliente
- Validación: Si el cliente tiene DNI, fallará

#### Escenario B: Destinatario manual (`usar_cliente_como_destinatario: false` o no enviado)
- `cliente_id` es **OPCIONAL** (puedes enviarlo para trazabilidad o no enviarlo)
- El **destinatario** puede tener DNI o RUC (tipo_documento: '1' o '6')
- Debes enviar manualmente todos los datos del destinatario

**Recomendación para el frontend:**
- Agregar checkbox "El cliente es el destinatario"
- Si está marcado: Requerir cliente con RUC, ocultar campos de destinatario
- Si NO está marcado: Hacer cliente_id opcional, mostrar campos de destinatario
- Permitir destinatarios con DNI o RUC cuando se ingresa manualmente

### Ubigeo
- Debe ser exactamente 6 dígitos numéricos
- Ejemplo válido: `"150101"` (Lima - Lima - Lima)
- Ejemplo inválido: `"15101"` o `"1501"` o `"abc123"`

### Productos
- Mínimo 1 producto
- `cantidad` y `peso_unitario` deben ser mayores a 0
- El `peso_total` se calcula automáticamente

### Estados
- `PENDIENTE` - Recién creada, puede enviarse a SUNAT
- `ENVIADO` - En proceso de envío
- `ACEPTADO` - Aceptada por SUNAT
- `RECHAZADO` - Rechazada por SUNAT, puede reenviarse
- `ANULADO` - Anulada, no puede modificarse

---

## 🚨 Errores Comunes

### Error: "No hay series activas para guías de remisión tipo 09"
**Solución:** Crear una serie activa para tipo de comprobante '09' en la tabla `series_comprobantes`

### Error: "El cliente debe tener RUC para ser usado como destinatario"
**Causa:** Intentaste usar `usar_cliente_como_destinatario: true` pero el cliente tiene DNI

**Soluciones:**
1. Desmarcar "El cliente es el destinatario" y enviar datos del destinatario manualmente (puede tener DNI)
2. Seleccionar un cliente que tenga RUC
3. Actualizar el cliente para que tenga RUC en lugar de DNI

### Error: "Debes seleccionar un cliente cuando usas 'El cliente es el destinatario'"
**Causa:** Marcaste `usar_cliente_como_destinatario: true` pero no enviaste `cliente_id`

**Solución:** Enviar el `cliente_id` o desmarcar el checkbox

### Error: "Esta guía de remisión no requiere envío a SUNAT"
**Solución:** Las guías tipo `INTERNO` no se envían a SUNAT, solo son para control interno

### Error: "La guía de remisión no puede ser enviada en su estado actual"
**Solución:** Solo se pueden enviar guías en estado `PENDIENTE` o `RECHAZADO`

### Error: Validación de ubigeo
**Solución:** Asegurarse que el ubigeo tenga exactamente 6 dígitos: `"150101"` no `"15101"`

---

## 💡 Tips para el Frontend

1. **Formulario Dinámico:** Mostrar/ocultar campos según:
   - `tipo_guia` seleccionado
   - `modalidad_traslado` seleccionado
   - `usar_cliente_como_destinatario` checkbox

2. **Validación de Cliente:** Antes de crear GRE Remitente, verificar que el cliente tenga RUC

3. **Autocompletado:** Al seleccionar cliente, autocompletar datos de destinatario si `usar_cliente_como_destinatario = true`

4. **Cálculo Automático:** Calcular `peso_total` multiplicando cantidad × peso_unitario de cada producto

5. **Estados Visuales:** Usar colores/badges para diferenciar estados:
   - PENDIENTE: amarillo
   - ACEPTADO: verde
   - RECHAZADO: rojo
   - ANULADO: gris

6. **Botones Condicionales:**
   - Mostrar "Enviar a SUNAT" solo si `estado = PENDIENTE` y `requiere_sunat = true`
   - Mostrar "Descargar XML" solo si existe `xml_firmado`
   - Mostrar "Descargar PDF" solo si existe `pdf_base64`

7. **Selector de Ubigeo:** Implementar un selector de departamento/provincia/distrito que genere el código de 6 dígitos

8. **Validación de Placa:** Para Perú, formato típico: `ABC-123` o `ABC-1234`

9. **Validación de DNI:** Exactamente 8 dígitos numéricos

10. **Mensajes Claros:** Mostrar mensajes de error de SUNAT al usuario cuando una guía sea rechazada
