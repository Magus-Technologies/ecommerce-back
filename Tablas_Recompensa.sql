use ecommerce_bak_magus;
-- 1. Tabla principal de recompensas (configuración general)

CREATE TABLE recompensas (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  tipo ENUM('puntos','descuento','envio_gratis','regalo') NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  estado ENUM('programada','activa','pausada','expirada','cancelada') NOT NULL DEFAULT 'programada',
  creado_por BIGINT UNSIGNED DEFAULT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_activo_vigencia (fecha_inicio, fecha_fin),
  INDEX idx_tipo_activo (tipo)
);


-- 2. Reglas de segmentación (a qué clientes va dirigido)
CREATE TABLE recompensas_clientes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  segmento ENUM('todos','nuevos','recurrentes','vip','no_registrados') NOT NULL,
  cliente_id BIGINT UNSIGNED DEFAULT NULL,
  INDEX idx_recompensa_segmento (recompensa_id, segmento),
  INDEX idx_cliente_especifico (cliente_id),
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE,
  FOREIGN KEY (cliente_id) REFERENCES user_clientes(id) ON DELETE CASCADE
);

-- 3. Relación con productos/categorías
CREATE TABLE recompensas_productos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED DEFAULT NULL,
  categoria_id BIGINT UNSIGNED DEFAULT NULL,
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
);

-- 4. Submódulo: configuración de puntos
CREATE TABLE recompensas_puntos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  puntos_por_compra DECIMAL(10,2) DEFAULT 0, -- puntos por compra
  puntos_por_monto DECIMAL(10,2) DEFAULT 0,  -- puntos por cada X soles
  puntos_registro DECIMAL(10,2) DEFAULT 0,   -- puntos al registrarse
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE
);

-- 5. Submódulo: configuración de descuentos
CREATE TABLE recompensas_descuentos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  tipo_descuento ENUM('porcentaje','cantidad_fija') NOT NULL,
  valor_descuento DECIMAL(10,2) NOT NULL,
  compra_minima DECIMAL(10,2) DEFAULT NULL,
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE
);

-- 6. Submódulo: configuración de envío gratis
CREATE TABLE recompensas_envios (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  minimo_compra DECIMAL(10,2) DEFAULT 0,
  zonas_aplicables JSON DEFAULT NULL, -- lista de ubigeos si se necesita
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE
);

-- 7. Submódulo: recompensas de regalo
CREATE TABLE recompensas_regalos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  cantidad INT DEFAULT 1,
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- 8. Registro histórico de recompensas aplicadas
CREATE TABLE recompensas_historial (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  cliente_id BIGINT UNSIGNED NOT NULL,
  pedido_id BIGINT UNSIGNED DEFAULT NULL,
  puntos_otorgados DECIMAL(10,2) DEFAULT 0,
  beneficio_aplicado TEXT DEFAULT NULL,
  fecha_aplicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE,
  FOREIGN KEY (cliente_id) REFERENCES user_clientes(id) ON DELETE CASCADE,
  FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE SET NULL
);
CREATE TABLE recompensas_popups (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  descripcion TEXT,
  imagen_popup VARCHAR(255) DEFAULT NULL,
  texto_boton VARCHAR(100) DEFAULT 'Ver más',
  url_destino VARCHAR(500) DEFAULT NULL,
  mostrar_cerrar TINYINT(1) DEFAULT 1,
  auto_cerrar_segundos INT DEFAULT NULL,
  popup_activo TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_recompensa_id (recompensa_id),
  INDEX idx_popup_activo (popup_activo),
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE
);

CREATE TABLE recompensas_notificaciones_clientes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  cliente_id BIGINT UNSIGNED NOT NULL,
  popup_id BIGINT UNSIGNED NOT NULL,
  fecha_notificacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_visualizacion TIMESTAMP NULL DEFAULT NULL,
  fecha_cierre TIMESTAMP NULL DEFAULT NULL,
  estado ENUM('enviada','vista','cerrada','expirada') DEFAULT 'enviada',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_recompensa_id (recompensa_id),
  INDEX idx_cliente_id (cliente_id),
  INDEX idx_popup_id (popup_id),
  FOREIGN KEY (recompensa_id) REFERENCES recompensas(id) ON DELETE CASCADE,
  FOREIGN KEY (cliente_id) REFERENCES user_clientes(id) ON DELETE CASCADE,
  FOREIGN KEY (popup_id) REFERENCES recompensas_popups(id) ON DELETE CASCADE
);
-- SOLUCIÓN: Generar token para el admin y corregir pop-ups

-- 1. Generar token para el usuario admin (ID: 1)
INSERT INTO personal_access_tokens (
    tokenable_type, 
    tokenable_id, 
    name, 
    token, 
    abilities, 
    last_used_at, 
    expires_at, 
    created_at, 
    updated_at
) VALUES (
    'App\\Models\\User',
    1,
    'admin_token_directo',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    '["*"]',
    NULL,
    NULL,
    NOW(),
    NOW()
);

