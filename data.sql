/*
php artisan tinker
use Spatie\Permission\Models\Permission;
collect(['ver', 'create', 'show', 'edit', 'delete'])->each(function ($accion) {
    \Spatie\Permission\Models\Permission::create([
        'name' => "ofertas.$accion",
        'guard_name' => 'web',
    ]);
});
  # Crear tabla de clientes para facturación

  1. Nueva Tabla
    - `clientes`
      - `id` (bigint, primary key, auto increment)
      - `tipo_documento` (varchar 2) - 1=DNI, 6=RUC, 4=CE, etc
      - `numero_documento` (varchar 20, unique)
      - `razon_social` (varchar 255) - nombre completo o razón social
      - `nombre_comercial` (varchar 255, nullable)
      - `direccion` (text)  
      - `ubigeo` (varchar 6, nullable)
      - `distrito` (varchar 100, nullable)
      - `provincia` (varchar 100, nullable)
      - `departamento` (varchar 100, nullable)
      - `telefono` (varchar 20, nullable)
      - `email` (varchar 255, nullable)
      - `activo` (boolean, default true)
      - `user_id` (bigint, nullable, foreign key a users)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Seguridad
    - Enable RLS en `clientes` table
    - Add policy para usuarios autenticados
    
  3. Índices
    - Índice único en numero_documento  
    - Índice en tipo_documento
    - Índice en user_id
*/

CREATE TABLE IF NOT EXISTS clientes (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    tipo_documento VARCHAR(2) NOT NULL COMMENT '1=DNI, 6=RUC, 4=CE, 7=PASAPORTE',
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    razon_social VARCHAR(255) NOT NULL COMMENT 'Nombre completo o razón social',
    nombre_comercial VARCHAR(255) NULL,
    direccion TEXT NOT NULL,
    ubigeo VARCHAR(6) NULL COMMENT 'Código UBIGEO INEI',
    distrito VARCHAR(100) NULL,
    provincia VARCHAR(100) NULL,
    departamento VARCHAR(100) NULL,
    telefono VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    user_id BIGINT UNSIGNED NULL COMMENT 'Referencia a usuario registrado',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_tipo_documento (tipo_documento),
    INDEX idx_numero_documento (numero_documento),
    INDEX idx_user_id (user_id),
    INDEX idx_activo (activo),
    
    CONSTRAINT fk_clientes_user_id 
        FOREIGN KEY (user_id) REFERENCES users(id) 
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*
  # Crear tabla de series de comprobantes

  1. Nueva Tabla
    - `series_comprobantes`
      - `id` (bigint, primary key)
      - `tipo_comprobante` (varchar 2) - 01=Factura, 03=Boleta, etc
      - `serie` (varchar 4) - F001, B001, etc
      - `correlativo` (int) - numeración actual
      - `activo` (boolean)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Datos iniciales
    - Serie F001 para facturas
    - Serie B001 para boletas
*/

CREATE TABLE IF NOT EXISTS series_comprobantes (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    tipo_comprobante VARCHAR(2) NOT NULL COMMENT '01=Factura, 03=Boleta, 07=Nota Crédito, 08=Nota Débito',
    serie VARCHAR(4) NOT NULL,
    correlativo INT UNSIGNED NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uk_tipo_serie (tipo_comprobante, serie),
    INDEX idx_tipo_comprobante (tipo_comprobante),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar series por defecto
INSERT INTO series_comprobantes (tipo_comprobante, serie, correlativo) VALUES
('01', 'F001', 0),
('03', 'B001', 0),
('07', 'FC01', 0),
('07', 'BC01', 0),
('08', 'FD01', 0),
('08', 'BD01', 0);

/*
  # Crear tabla principal de comprobantes

  1. Nueva Tabla
    - `comprobantes`
      - Información básica del comprobante
      - Datos del cliente
      - Importes y totales
      - Estado SUNAT
      - Archivos XML y PDF

  2. Estados
    - PENDIENTE: Creado pero no enviado
    - ENVIADO: Enviado a SUNAT
    - ACEPTADO: Aceptado por SUNAT
    - RECHAZADO: Rechazado por SUNAT
    - ANULADO: Anulado
*/

CREATE TABLE IF NOT EXISTS comprobantes (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    
    -- Identificación del comprobante
    tipo_comprobante VARCHAR(2) NOT NULL COMMENT '01=Factura, 03=Boleta, 07=NC, 08=ND',
    serie VARCHAR(4) NOT NULL,
    correlativo INT UNSIGNED NOT NULL,
    numero_completo VARCHAR(20) GENERATED ALWAYS AS (CONCAT(serie, '-', LPAD(correlativo, 8, '0'))) STORED,
    
    -- Fechas
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    
    -- Cliente
    cliente_id BIGINT UNSIGNED NOT NULL,
    cliente_tipo_documento VARCHAR(2) NOT NULL,
    cliente_numero_documento VARCHAR(20) NOT NULL,
    cliente_razon_social VARCHAR(255) NOT NULL,
    cliente_direccion TEXT NOT NULL,
    
    -- Moneda y totales
    moneda VARCHAR(3) NOT NULL DEFAULT 'PEN',
    operacion_gravada DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    operacion_exonerada DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    operacion_inafecta DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    operacion_gratuita DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_igv DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_descuentos DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_otros_cargos DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    importe_total DECIMAL(12,2) NOT NULL,
    
    -- Observaciones
    observaciones TEXT NULL,
    
    -- Referencias (para notas de crédito/débito)
    comprobante_referencia_id BIGINT UNSIGNED NULL,
    tipo_nota VARCHAR(2) NULL COMMENT 'Código de tipo de nota de crédito/débito',
    motivo_nota TEXT NULL,
    
    -- Estado SUNAT
    estado ENUM('PENDIENTE', 'ENVIADO', 'ACEPTADO', 'RECHAZADO', 'ANULADO') NOT NULL DEFAULT 'PENDIENTE',
    codigo_hash VARCHAR(100) NULL,
    xml_firmado LONGTEXT NULL,
    xml_respuesta_sunat LONGTEXT NULL,
    pdf_base64 LONGTEXT NULL,
    mensaje_sunat TEXT NULL,
    
    -- Auditoría
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'Usuario que creó el comprobante',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices
    UNIQUE KEY uk_serie_correlativo (serie, correlativo),
    INDEX idx_numero_completo (numero_completo),
    INDEX idx_cliente_id (cliente_id),
    INDEX idx_fecha_emision (fecha_emision),
    INDEX idx_estado (estado),
    INDEX idx_tipo_comprobante (tipo_comprobante),
    INDEX idx_user_id (user_id),
    
    -- Foreign Keys
    CONSTRAINT fk_comprobantes_cliente_id 
        FOREIGN KEY (cliente_id) REFERENCES clientes(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    CONSTRAINT fk_comprobantes_user_id 
        FOREIGN KEY (user_id) REFERENCES users(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    CONSTRAINT fk_comprobantes_referencia_id 
        FOREIGN KEY (comprobante_referencia_id) REFERENCES comprobantes(id) 
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*
  # Crear tabla de detalles de comprobantes

  1. Nueva Tabla
    - `comprobante_detalles`
      - Líneas de detalle de cada comprobante
      - Productos, cantidades, precios
      - Códigos SUNAT requeridos
      - Impuestos por línea

  2. Campos requeridos por SUNAT
    - Código de producto
    - Descripción
    - Unidad de medida
    - Cantidad
    - Valor unitario
    - Precio unitario
    - Impuestos
*/

CREATE TABLE IF NOT EXISTS comprobante_detalles (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    comprobante_id BIGINT UNSIGNED NOT NULL,
    
    -- Información del producto/servicio
    item INT UNSIGNED NOT NULL COMMENT 'Número de línea',
    producto_id BIGINT UNSIGNED NULL COMMENT 'Referencia al producto',
    codigo_producto VARCHAR(30) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    
    -- Unidad de medida (códigos SUNAT)
    unidad_medida VARCHAR(10) NOT NULL DEFAULT 'NIU' COMMENT 'NIU=Número de unidades',
    
    -- Cantidades y precios
    cantidad DECIMAL(12,4) NOT NULL,
    valor_unitario DECIMAL(12,4) NOT NULL COMMENT 'Precio sin IGV',
    precio_unitario DECIMAL(12,4) NOT NULL COMMENT 'Precio con IGV',
    
    -- Descuentos
    descuento DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    
    -- Valores por línea (sin IGV)
    valor_venta DECIMAL(12,2) NOT NULL COMMENT 'cantidad * valor_unitario - descuento',
    
    -- IGV por línea
    porcentaje_igv DECIMAL(5,2) NOT NULL DEFAULT 18.00,
    igv DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    
    -- Códigos de afectación IGV SUNAT
    tipo_afectacion_igv VARCHAR(2) NOT NULL DEFAULT '10' COMMENT '10=Gravado, 20=Exonerado, 30=Inafecto',
    
    -- Total de la línea (con IGV)
    importe_total DECIMAL(12,2) NOT NULL,
    
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices
    INDEX idx_comprobante_id (comprobante_id),
    INDEX idx_producto_id (producto_id),
    INDEX idx_item (comprobante_id, item),
    
    -- Foreign Keys
    CONSTRAINT fk_detalles_comprobante_id 
        FOREIGN KEY (comprobante_id) REFERENCES comprobantes(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_detalles_producto_id 
        FOREIGN KEY (producto_id) REFERENCES productos(id) 
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*
  # Crear tabla de ventas integradas con facturación

  1. Nueva Tabla
    - `ventas`
      - Registro de ventas del e-commerce
      - Integración con comprobantes
      - Estados de venta y facturación
      - Relación con productos vendidos

  2. Estados de venta
    - PENDIENTE: Venta registrada, sin comprobante
    - FACTURADO: Venta con comprobante generado
    - ANULADO: Venta anulada
*/

CREATE TABLE IF NOT EXISTS ventas (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    
    -- Código de venta
    codigo_venta VARCHAR(20) NOT NULL UNIQUE,
    
    -- Cliente
    cliente_id BIGINT UNSIGNED NOT NULL,
    
    -- Fechas
    fecha_venta DATETIME NOT NULL,
    
    -- Totales
    subtotal DECIMAL(12,2) NOT NULL COMMENT 'Sin IGV',
    igv DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    descuento_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(12,2) NOT NULL,
    
    -- Estado
    estado ENUM('PENDIENTE', 'FACTURADO', 'ANULADO') NOT NULL DEFAULT 'PENDIENTE',
    
    -- Facturación
    comprobante_id BIGINT UNSIGNED NULL COMMENT 'Comprobante generado',
    requiere_factura BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Cliente pidió factura',
    
    -- Método de pago
    metodo_pago VARCHAR(50) NULL,
    
    -- Observaciones
    observaciones TEXT NULL,
    
    -- Auditoría
    user_id BIGINT UNSIGNED NULL COMMENT 'Usuario que registró (puede ser null para ventas web)',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices
    INDEX idx_codigo_venta (codigo_venta),
    INDEX idx_cliente_id (cliente_id),
    INDEX idx_fecha_venta (fecha_venta),
    INDEX idx_estado (estado),
    INDEX idx_comprobante_id (comprobante_id),
    INDEX idx_user_id (user_id),
    
    -- Foreign Keys
    CONSTRAINT fk_ventas_cliente_id 
        FOREIGN KEY (cliente_id) REFERENCES clientes(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    CONSTRAINT fk_ventas_comprobante_id 
        FOREIGN KEY (comprobante_id) REFERENCES comprobantes(id) 
        ON DELETE SET NULL ON UPDATE CASCADE,
        
    CONSTRAINT fk_ventas_user_id 
        FOREIGN KEY (user_id) REFERENCES users(id) 
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*
  # Crear tabla de detalles de ventas

  1. Nueva Tabla
    - `venta_detalles`
      - Productos vendidos en cada venta
      - Cantidades, precios y totales
      - Relación con productos del catálogo
*/

CREATE TABLE IF NOT EXISTS venta_detalles (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    venta_id BIGINT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NOT NULL,
    
    -- Información del producto al momento de la venta
    codigo_producto VARCHAR(100) NOT NULL,
    nombre_producto VARCHAR(255) NOT NULL,
    descripcion_producto TEXT NULL,
    
    -- Cantidades y precios
    cantidad DECIMAL(12,4) NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL COMMENT 'Precio unitario con IGV',
    precio_sin_igv DECIMAL(12,2) NOT NULL COMMENT 'Precio unitario sin IGV',
    
    -- Descuentos
    descuento_unitario DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    
    -- Totales de la línea
    subtotal_linea DECIMAL(12,2) NOT NULL COMMENT 'cantidad * precio_sin_igv - descuento',
    igv_linea DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_linea DECIMAL(12,2) NOT NULL,
    
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices
    INDEX idx_venta_id (venta_id),
    INDEX idx_producto_id (producto_id),
    
    -- Foreign Keys
    CONSTRAINT fk_venta_detalles_venta_id 
        FOREIGN KEY (venta_id) REFERENCES ventas(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_venta_detalles_producto_id 
        FOREIGN KEY (producto_id) REFERENCES productos(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*
  # Crear tabla de clientes del e-commerce con login

  1. Nueva Tabla
    - `user_clientes`
      - Clientes que pueden hacer login en el e-commerce
      - Se relaciona con la tabla `clientes` para facturación
      - Maneja autenticación y datos personales

  2. Relaciones
    - Relación opcional con tabla `clientes` para facturación
    - Relación con `document_types` existente
*/

CREATE TABLE IF NOT EXISTS user_clientes (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    
    -- Datos personales
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20) NULL,
    fecha_nacimiento DATE NULL,
    genero ENUM('masculino', 'femenino', 'otro') NULL,
    
    -- Documento de identidad
    tipo_documento_id BIGINT UNSIGNED NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    
    -- Autenticación
    password VARCHAR(255) NOT NULL,
    email_verified_at TIMESTAMP NULL,
    remember_token VARCHAR(100) NULL,
    
    -- Datos adicionales
    foto VARCHAR(255) NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Relación con facturación (opcional)
    cliente_facturacion_id BIGINT UNSIGNED NULL COMMENT 'Referencia a tabla clientes para facturación',
    
    -- Timestamps
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices
    INDEX idx_email (email),
    INDEX idx_numero_documento (numero_documento),
    INDEX idx_tipo_documento (tipo_documento_id),
    INDEX idx_estado (estado),
    INDEX idx_cliente_facturacion (cliente_facturacion_id),
    
    -- Foreign Keys
    CONSTRAINT fk_user_clientes_tipo_documento 
        FOREIGN KEY (tipo_documento_id) REFERENCES document_types(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    CONSTRAINT fk_user_clientes_cliente_facturacion 
        FOREIGN KEY (cliente_facturacion_id) REFERENCES clientes(id) 
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*
  # Crear tabla de direcciones para clientes del e-commerce

  1. Nueva Tabla
    - `user_cliente_direcciones`
      - Direcciones de entrega para clientes del e-commerce
      - Múltiples direcciones por cliente
      - Dirección predeterminada
*/

CREATE TABLE IF NOT EXISTS user_cliente_direcciones (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_cliente_id BIGINT UNSIGNED NOT NULL,
    
    -- Datos de la dirección
    nombre_destinatario VARCHAR(255) NOT NULL,
    direccion_completa TEXT NOT NULL,
    referencia VARCHAR(255) NULL,
    
    -- Ubicación
    departamento VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    distrito VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NULL,
    
    -- Configuración
    predeterminada BOOLEAN NOT NULL DEFAULT FALSE,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices
    INDEX idx_user_cliente_id (user_cliente_id),
    INDEX idx_predeterminada (predeterminada),
    INDEX idx_activa (activa),
    
    -- Foreign Keys
    CONSTRAINT fk_user_cliente_direcciones_user_cliente 
        FOREIGN KEY (user_cliente_id) REFERENCES user_clientes(id) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*
  # Actualizar tabla ventas para soportar clientes del e-commerce

  1. Cambios en tabla ventas
    - Hacer cliente_id nullable
    - Agregar user_cliente_id nullable
    - Agregar índices necesarios
*/

-- Hacer cliente_id nullable
ALTER TABLE ventas MODIFY COLUMN cliente_id BIGINT UNSIGNED NULL;

-- Agregar columna user_cliente_id
ALTER TABLE ventas ADD COLUMN user_cliente_id BIGINT UNSIGNED NULL COMMENT 'Cliente del e-commerce' AFTER cliente_id;

-- Agregar índice para user_cliente_id
ALTER TABLE ventas ADD INDEX idx_user_cliente_id (user_cliente_id);

-- Agregar foreign key para user_cliente_id
ALTER TABLE ventas ADD CONSTRAINT fk_ventas_user_cliente_id 
    FOREIGN KEY (user_cliente_id) REFERENCES user_clientes(id) 
    ON DELETE SET NULL ON UPDATE CASCADE;

-- Agregar constraint para asegurar que al menos uno de los dos clientes esté presente
ALTER TABLE ventas ADD CONSTRAINT chk_ventas_cliente 
    CHECK (cliente_id IS NOT NULL OR user_cliente_id IS NOT NULL);


-- primero tipoo de ofertas
 CREATE TABLE tipos_ofertas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    icono VARCHAR(100),
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ofertas
CREATE TABLE ofertas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    subtitulo VARCHAR(255),
    descripcion TEXT,
    tipo_oferta_id INT UNSIGNED,
    tipo_descuento ENUM('porcentaje', 'cantidad_fija') NOT NULL,
    valor_descuento DECIMAL(10, 2) NOT NULL,
    precio_minimo DECIMAL(10, 2),
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    imagen VARCHAR(255),
    banner_imagen VARCHAR(255),
    color_fondo VARCHAR(20) DEFAULT '#3B82F6',
    texto_boton VARCHAR(100) DEFAULT 'Compra ahora',
    enlace_url VARCHAR(255) DEFAULT '/shop',
    limite_uso INT,
    usos_actuales INT DEFAULT 0,
    activo TINYINT(1) DEFAULT 1,
    mostrar_countdown TINYINT(1) DEFAULT 0,
    mostrar_en_slider TINYINT(1) DEFAULT 0,
    mostrar_en_banner TINYINT(1) DEFAULT 0,
    prioridad INT DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (tipo_oferta_id) REFERENCES tipos_ofertas(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ofertas_productos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    oferta_id INT UNSIGNED NOT NULL,
    producto_id INT UNSIGNED NOT NULL,
    precio_oferta DECIMAL(10, 2),
    stock_oferta INT,
    vendidos_oferta INT DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    UNIQUE KEY (oferta_id, producto_id),
    FOREIGN KEY (oferta_id) REFERENCES ofertas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cupones (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo_descuento ENUM('porcentaje', 'cantidad_fija') NOT NULL,
    valor_descuento DECIMAL(10, 2) NOT NULL,
    compra_minima DECIMAL(10, 2),
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    limite_uso INT,
    usos_actuales INT DEFAULT 0,
    solo_primera_compra TINYINT(1) DEFAULT 0,
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;