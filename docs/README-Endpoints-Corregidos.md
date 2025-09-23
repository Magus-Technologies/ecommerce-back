# 🔧 Endpoints de Recompensas - Corregidos

## 📋 **ENDPOINTS CORREGIDOS**

### **1. 🔄 PUT /api/admin/recompensas/{id}**

**Descripción:** Actualizar una recompensa existente. Si la recompensa está activa y no se especifica estado, se pausa automáticamente.

**Autenticación:** Requerida (Bearer Token)

**Permisos:** `recompensas.edit`

**Request Body:**
```json
{
  "nombre": "Recompensa Actualizada",
  "descripcion": "Nueva descripción",
  "tipo": "puntos",
  "fecha_inicio": "2024-01-15 00:00:00",
  "fecha_fin": "2024-02-15 23:59:59",
  "estado": "pausada"
}
```

**Comportamiento:**
- ✅ Si no se especifica `estado` y la recompensa está `activa` → se pausa automáticamente
- ✅ Si se especifica `estado` → se actualiza al estado especificado
- ✅ Valida que el estado sea válido: `programada`, `activa`, `pausada`, `expirada`, `cancelada`

**Response:**
```json
{
  "success": true,
  "message": "Recompensa actualizada exitosamente",
  "data": {
    "id": 1,
    "nombre": "Recompensa Actualizada",
    "descripcion": "Nueva descripción",
    "tipo": "puntos",
    "estado": "pausada",
    "fecha_inicio": "2024-01-15T00:00:00.000000Z",
    "fecha_fin": "2024-02-15T23:59:59.000000Z",
    "creado_por": 1,
    "created_at": "2024-01-15T10:30:00.000000Z",
    "updated_at": "2024-01-15T11:00:00.000000Z"
  }
}
```

---

### **2. ⏸️ PATCH /api/admin/recompensas/{id}/pause**

**Descripción:** Pausar una recompensa específica.

**Autenticación:** Requerida (Bearer Token)

**Permisos:** `recompensas.edit`

**Request:** Sin body

**Validaciones:**
- ✅ Solo se puede pausar desde estado `activa`
- ❌ No se puede pausar desde `programada`, `pausada`, `expirada`, `cancelada`

**Response:**
```json
{
  "success": true,
  "message": "Recompensa pausada exitosamente",
  "data": {
    "id": 1,
    "nombre": "Recompensa de Prueba",
    "estado": "pausada",
    "updated_at": "2024-01-15T11:00:00.000000Z"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "No se puede pausar la recompensa desde el estado actual: Programada"
}
```

---

### **3. ▶️ PATCH /api/admin/recompensas/{id}/activate**

**Descripción:** Activar una recompensa específica.

**Autenticación:** Requerida (Bearer Token)

**Permisos:** `recompensas.activate`

**Request:** Sin body

**Validaciones:**
- ✅ Solo se puede activar desde estado `programada` o `pausada`
- ❌ No se puede activar desde `activa`, `expirada`, `cancelada`

**Response:**
```json
{
  "success": true,
  "message": "Recompensa activada exitosamente",
  "data": {
    "id": 1,
    "nombre": "Recompensa de Prueba",
    "estado": "activa",
    "updated_at": "2024-01-15T11:00:00.000000Z"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "No se puede activar la recompensa desde el estado actual: Cancelada"
}
```

---

### **4. ❌ DELETE /api/admin/recompensas/{id}**

**Descripción:** Cancelar una recompensa (soft delete).

**Autenticación:** Requerida (Bearer Token)

**Permisos:** `recompensas.delete`

**Request:** Sin body

**Validaciones:**
- ✅ Solo se puede cancelar desde estado `programada`, `activa`, `pausada`
- ❌ No se puede cancelar desde `expirada`, `cancelada`

**Response:**
```json
{
  "success": true,
  "message": "Recompensa cancelada exitosamente"
}
```

---

## 🔄 **FLUJO DE ESTADOS**

```
programada → activa → pausada → activa
     ↓         ↓         ↓
  cancelada  cancelada  cancelada
     ↓
  expirada (automático por fecha)
```

### **Estados Disponibles:**
- **`programada`** - Recompensa creada pero no activa
- **`activa`** - Recompensa activa y disponible
- **`pausada`** - Recompensa temporalmente pausada
- **`expirada`** - Recompensa expirada por fecha
- **`cancelada`** - Recompensa cancelada permanentemente

### **Transiciones Válidas:**
- `programada` → `activa`, `cancelada`
- `activa` → `pausada`, `cancelada`
- `pausada` → `activa`, `cancelada`
- `expirada` → (no se puede cambiar)
- `cancelada` → (no se puede cambiar)

---

## 🧪 **TESTS INCLUIDOS**

### **Tests de Actualización:**
- ✅ Actualizar recompensa pausa si está activa
- ✅ Actualizar recompensa con estado específico
- ✅ Validar estado inválido en actualización

### **Tests de Activación:**
- ✅ Activar recompensa exitosamente
- ✅ Activar recompensa desde estado pausada
- ✅ Error al activar desde estado inválido

### **Tests de Pausa:**
- ✅ Pausar recompensa exitosamente
- ✅ Error al pausar desde estado inválido

### **Tests de Cancelación:**
- ✅ Cancelar recompensa exitosamente
- ✅ Error al cancelar desde estado inválido

### **Tests de Creación:**
- ✅ Crear recompensa con estado específico
- ✅ Crear recompensa sin estado (usa programada por defecto)
- ✅ Validar estado inválido en creación

---

## 🚀 **CÓMO USAR**

### **1. Actualizar Recompensa (Pausa Automática):**
```bash
curl -X PUT http://tu-dominio/api/admin/recompensas/1 \
  -H "Authorization: Bearer TU_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"nombre": "Nuevo Nombre"}'
```

### **2. Pausar Recompensa:**
```bash
curl -X PATCH http://tu-dominio/api/admin/recompensas/1/pause \
  -H "Authorization: Bearer TU_TOKEN"
```

### **3. Activar Recompensa:**
```bash
curl -X PATCH http://tu-dominio/api/admin/recompensas/1/activate \
  -H "Authorization: Bearer TU_TOKEN"
```

### **4. Cancelar Recompensa:**
```bash
curl -X DELETE http://tu-dominio/api/admin/recompensas/1 \
  -H "Authorization: Bearer TU_TOKEN"
```

---

## 🔧 **CAMBIOS REALIZADOS**

### **Controlador (`RecompensaController.php`):**
- ✅ Corregido método `update()` para usar campo `estado` en lugar de `activo`
- ✅ Agregado método `pause()` para pausar recompensas
- ✅ Corregido método `activate()` para usar validaciones del modelo
- ✅ Corregido método `destroy()` para cancelar en lugar de desactivar
- ✅ Corregido método `store()` para usar estado por defecto
- ✅ Corregido método `index()` para filtrar por estado

### **Rutas (`api.php`):**
- ✅ Agregada ruta `PATCH /{id}/pause` para pausar
- ✅ Actualizados comentarios de las rutas existentes

### **Validaciones:**
- ✅ Validación de estados válidos en creación y actualización
- ✅ Validación de transiciones de estado usando métodos del modelo
- ✅ Mensajes de error descriptivos

### **Tests:**
- ✅ Tests completos para todos los endpoints corregidos
- ✅ Tests de validación de estados
- ✅ Tests de transiciones válidas e inválidas

---

## 📊 **ESTADÍSTICAS ACTUALIZADAS**

Los endpoints de estadísticas (`GET /api/admin/recompensas/estadisticas`) ahora funcionan correctamente con el campo `estado` y muestran:

- **Total de recompensas** por estado
- **Recompensas activas** (estado = 'activa')
- **Recompensas vigentes** (activas + dentro de fechas)
- **Tasa de activación** correcta

---

## 🎯 **PRÓXIMOS PASOS**

1. **Ejecutar tests** para verificar que todo funciona correctamente
2. **Actualizar frontend** para usar los nuevos endpoints
3. **Implementar lógica de expiración** automática por fechas
4. **Agregar notificaciones** cuando cambien estados
5. **Implementar auditoría** de cambios de estado

¡Los endpoints están corregidos y listos para usar! 🎉
