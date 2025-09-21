use ecommerce_bak_magus;
-- 1. Tabla principal de recompensas (configuración general)

CREATE TABLE recompensas (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT DEFAULT NULL,
  tipo ENUM('puntos','descuento','envio_gratis','regalo') NOT NULL
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  estado ENUM('programada', 'activa', 'pausada', 'expirada', 'cancelada') NOT NULL DEFAULT 'programada',
  creado_por BIGINT UNSIGNED DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Reglas de segmentación (a qué clientes va dirigido)
CREATE TABLE recompensas_clientes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recompensa_id BIGINT UNSIGNED NOT NULL,
  segmento ENUM('todos','nuevos','recurrentes','vip','rango_fechas') NOT NULL,
  cliente_id BIGINT UNSIGNED DEFAULT NULL, -- si se quiere 1 cliente específico
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
