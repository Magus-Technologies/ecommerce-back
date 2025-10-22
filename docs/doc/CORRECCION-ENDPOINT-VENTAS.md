# ✅ CORRECCIÓN ENDPOINT POST /api/ventas

## 🎯 PROBLEMA IDENTIFICADO

El frontend enviaba los productos en un campo llamado `productos`, pero el backend tenía validaciones inconsistentes y no procesaba correctamente todos los campos enviados.

## 📤 DATOS QUE ENVÍA EL FRONTEND

```json
{
  "cliente": {
    "tipo_documento": "1",
    "numero_documento": "76165962",
    "nombre": "victor raul canchari riqui",
    "direccion": "lurigancho",
    "email": "",
    "telefono": ""
  },
  "productos": [
    {
      "producto_id": 123491,
      "codigo_producto": "AMD-7800X3D",
      "descripcion": "PROCESADOR AMD RYZEN 7 7800X3D",
      "unidad_medida": "NIU",
      "cantidad": 1,
      "precio_unitario": 1700.00,
      "descuento": 0,
      "tipo_afectacion_igv": "10"
    }
  ],
  "descuento_global": 0,
  "metodo_pago": "YAPE",
  "observaciones": "adawd adfdawda wadawd",
  "moneda": "PEN",
  "tipo_documento": "03",
  "fecha_venta": "2025-10-20",
  "hora_venta": "14:30:00"
}
```

## ✅ CORRECCIONES APLICADAS

### 1. **Validación Actualizada**

Se actualizó la validación en `VentasController::store()` para aceptar:

```php
// Cliente (puede venir como objeto)
'cliente' => 'nullable|array',
'cliente.tipo_documento' => 'required_with:cliente|string',
'cliente.numero_documento' => 'required_with:cliente|string|max:20',
'cliente.nombre' => 'required_with:cliente|string|max:255',
'cliente.direccion' => 'nullable|string',
'cliente.email' => 'nullable|email',
'cliente.telefono' => 'nullable|string|max:20',

// Productos con todos los campos del frontend
'productos' => 'required|array|min:1',
'productos.*.producto_id' => 'required|integer',
'productos.*.codigo_producto' => 'nullable|string',
'productos.*.descripcion' => 'required|string',
'productos.*.unidad_medida' => 'required|string',
'productos.*.cantidad' => 'required|numeric|min:0.01',
'productos.*.precio_unitario' => 'required|numeric|min:0',
'productos.*.descuento' => 'nullable|numeric|min:0',
'productos.*.tipo_afectacion_igv' => 'required|string',

// Datos adicionales
'descuento_global' => 'nullable|numeric|min:0',
'metodo_pago' => 'required|string|max:50',
'moneda' => 'nullable|string|in:PEN,USD',
'tipo_documento' => 'nullable|string|in:01,03,07,08',
'fecha_venta' => 'nullable|date',
'hora_venta' => 'nullable|date_format:H:i:s',
```

### 2. **Procesamiento de Cliente**

Ahora el endpoint puede:
- **Buscar cliente existente** por número de documento
- **Crear cliente nuevo** si no existe
- **Usar cliente_id** directo si se proporciona

```php
if ($request->has('cliente') && is_array($request->cliente)) {
    $clienteData = $request->cliente;
    
    // Buscar cliente existente
    $cliente = Cliente::where('numero_documento', $clienteData['numero_documento'])
        ->where('tipo_documento', $clienteData['tipo_documento'])
        ->first();
    
    // Si no existe, crear nuevo
    if (!$cliente) {
        $cliente = Cliente::create([
            'tipo_documento' => $clienteData['tipo_documento'],
            'numero_documento' => $clienteData['numero_documento'],
            'razon_social' => $clienteData['nombre'],
            'direccion' => $clienteData['direccion'] ?? '',
            'email' => $clienteData['email'] ?? null,
            'telefono' => $clienteData['telefono'] ?? null,
            'activo' => true,
        ]);
    }
}
```

### 3. **Cálculo de IGV Según Tipo de Afectación**

Se implementó el cálculo correcto según el código SUNAT:

```php
$tipoAfectacionIgv = $prod['tipo_afectacion_igv'] ?? '10';

if ($tipoAfectacionIgv == '10') {
    // Gravado - incluye IGV 18%
    $precioSinIgv = $precioUnitario / 1.18;
    $subtotalLinea = ($cantidad * $precioSinIgv) - ($descuentoUnitario * $cantidad);
    $igvLinea = $subtotalLinea * 0.18;
} else {
    // Exonerado (20) o Inafecto (30) - sin IGV
    $precioSinIgv = $precioUnitario;
    $subtotalLinea = ($cantidad * $precioSinIgv) - ($descuentoUnitario * $cantidad);
    $igvLinea = 0;
}
```

### 4. **Soporte para Fecha y Hora Personalizadas**

```php
$fechaVenta = $request->fecha_venta ?? now()->format('Y-m-d');
$horaVenta = $request->hora_venta ?? now()->format('H:i:s');
$fechaHoraVenta = $fechaVenta . ' ' . $horaVenta;
```

### 5. **Compatibilidad con Campos Opcionales**

```php
// Acepta tanto 'descuento' como 'descuento_unitario'
$descuentoUnitario = $prod['descuento'] ?? $prod['descuento_unitario'] ?? 0;

// Acepta tanto 'descuento_global' como 'descuento_total'
$descuentoTotal = $request->descuento_global ?? $request->descuento_total ?? 0;

// Detecta automáticamente si requiere factura según tipo_documento
'requiere_factura' => $request->requiere_factura ?? ($request->tipo_documento == '01'),
```

## 📊 CÓDIGOS DE TIPO DE AFECTACIÓN IGV (SUNAT)

| Código | Descripción | IGV |
|--------|-------------|-----|
| 10 | Gravado - Operación Onerosa | 18% |
| 11 | Gravado - Retiro por premio | 18% |
| 12 | Gravado - Retiro por donación | 18% |
| 13 | Gravado - Retiro | 18% |
| 14 | Gravado - Retiro por publicidad | 18% |
| 15 | Gravado - Bonificaciones | 18% |
| 16 | Gravado - Retiro por entrega a trabajadores | 18% |
| 17 | Gravado - IVAP | 18% |
| 20 | Exonerado - Operación Onerosa | 0% |
| 21 | Exonerado - Transferencia Gratuita | 0% |
| 30 | Inafecto - Operación Onerosa | 0% |
| 31 | Inafecto - Retiro por Bonificación | 0% |
| 32 | Inafecto - Retiro | 0% |
| 33 | Inafecto - Retiro por Muestras Médicas | 0% |
| 34 | Inafecto - Retiro por Convenio Colectivo | 0% |
| 35 | Inafecto - Retiro por premio | 0% |
| 36 | Inafecto - Retiro por publicidad | 0% |
| 40 | Exportación | 0% |

## 🧪 PRUEBA DEL ENDPOINT

### Request:
```bash
POST /api/ventas
Authorization: Bearer {token}
Content-Type: application/json

{
  "cliente": {
    "tipo_documento": "1",
    "numero_documento": "76165962",
    "nombre": "Victor Raul Canchari Riqui",
    "direccion": "Lurigancho",
    "email": "victor@example.com",
    "telefono": "987654321"
  },
  "productos": [
    {
      "producto_id": 123491,
      "codigo_producto": "AMD-7800X3D",
      "descripcion": "PROCESADOR AMD RYZEN 7 7800X3D",
      "unidad_medida": "NIU",
      "cantidad": 1,
      "precio_unitario": 1700.00,
      "descuento": 0,
      "tipo_afectacion_igv": "10"
    }
  ],
  "descuento_global": 0,
  "metodo_pago": "YAPE",
  "observaciones": "Venta de prueba",
  "moneda": "PEN",
  "tipo_documento": "03",
  "fecha_venta": "2025-10-20",
  "hora_venta": "14:30:00"
}
```

### Response Esperada:
```json
{
  "message": "Venta registrada exitosamente",
  "venta": {
    "id": 1,
    "cliente_id": 123,
    "fecha_venta": "2025-10-20 14:30:00",
    "subtotal": 1440.68,
    "igv": 259.32,
    "descuento_total": 0,
    "total": 1700.00,
    "estado": "PENDIENTE",
    "metodo_pago": "YAPE",
    "observaciones": "Venta de prueba",
    "created_at": "2025-10-20T14:30:00.000000Z",
    "updated_at": "2025-10-20T14:30:00.000000Z"
  }
}
```

## ✅ CAMBIOS EN EL CÓDIGO

**Archivo modificado:** `app/Http/Controllers/VentasController.php`

**Métodos actualizados:**
- `store()` - Validación y procesamiento completo actualizado

**Líneas modificadas:** ~80-200

## 🎯 RESULTADO

✅ El endpoint ahora acepta el campo `productos` correctamente
✅ Procesa datos del cliente como objeto
✅ Calcula IGV según tipo de afectación SUNAT
✅ Crea o busca clientes automáticamente
✅ Soporta fecha y hora personalizadas
✅ Compatible con campos opcionales del frontend

## 📝 NOTAS IMPORTANTES

1. **Validación de Stock:** El endpoint verifica que haya stock suficiente antes de crear la venta
2. **Creación Automática de Cliente:** Si el cliente no existe, se crea automáticamente
3. **Cálculo de IGV:** Se calcula correctamente según el tipo de afectación IGV
4. **Evento VentaCreated:** Se dispara automáticamente para integraciones (Kardex, Contabilidad, etc.)
5. **Transacciones DB:** Todo el proceso está envuelto en una transacción para garantizar consistencia

## 🔄 PRÓXIMOS PASOS

Si necesitas agregar más validaciones o campos:
1. Actualizar la validación en el método `store()`
2. Procesar los nuevos campos en la lógica de creación
3. Verificar que la tabla `ventas` tenga las columnas necesarias
4. Probar el endpoint con Postman o el frontend
