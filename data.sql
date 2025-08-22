-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-08-2025 a las 18:33:10
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ecommerce_bak_magus`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banners`
--

CREATE TABLE `banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `subtitulo` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `texto_boton` varchar(100) DEFAULT 'Explorar Tienda',
  `precio_desde` decimal(10,2) DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `enlace_url` varchar(500) DEFAULT '/shop',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `banners`
--

INSERT INTO `banners` (`id`, `titulo`, `subtitulo`, `descripcion`, `texto_boton`, `precio_desde`, `imagen_url`, `enlace_url`, `activo`, `orden`, `created_at`, `updated_at`) VALUES
(1, 'Ordenaws tus productos diarios y recibe Express Delivery', 'Ahorre hasta un 50% en su primer pedido', 'Obtén los mejores productos con entrega rápida', 'Explorar Tienda', '60.99', 'banners/1752004814_686d78ce2c6b2.png', '/shop', 1, 1, '2025-06-03 21:43:25', '2025-07-09 01:00:14'),
(2, 'Pedido diario de comestibles y Express Delivery', 'Save up to 50% off on your first order', 'Los mejores productos frescos a tu puerta', 'Explore Shop', '60.99', 'banners/1749215478_6842e8f616490.jpg', '/shop', 0, 2, '2025-06-03 21:43:25', '2025-06-06 20:51:36'),
(3, 'Pedido diario de comestibles y Express Delivery', 'Pedido diario de comestibles y Express Delivery', 'Pedido diario de comestibles y Express Delivery', 'Explorar Tienda', NULL, 'banners/1749216033_6842eb21d4b48.webp', '/shop', 1, 1, '2025-06-06 18:20:33', '2025-06-11 19:19:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banners_promocionales`
--

CREATE TABLE `banners_promocionales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `precio` decimal(8,2) DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `enlace_url` varchar(255) NOT NULL DEFAULT '/shop',
  `orden` int(11) NOT NULL DEFAULT 1,
  `animacion_delay` int(11) NOT NULL DEFAULT 400,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `banners_promocionales`
--

INSERT INTO `banners_promocionales` (`id`, `titulo`, `precio`, `imagen_url`, `enlace_url`, `orden`, `animacion_delay`, `activo`, `created_at`, `updated_at`) VALUES
(2, 'Pan calientito', '20.00', 'banners_promocionales/1751656966_68682a06a03e3.png', '/shop', 1, 400, 0, '2025-07-05 00:21:17', '2025-07-16 23:03:38'),
(3, 'Moras frescas', '10.00', 'banners_promocionales/1751656899_686829c3ac07a.png', '/shop', 1, 400, 1, '2025-07-05 00:21:39', '2025-07-05 00:22:56'),
(4, 'Bebidas frescas', NULL, 'banners_promocionales/1751656957_686829fd98e87.png', '/shop', 1, 400, 1, '2025-07-05 00:22:37', '2025-07-05 00:22:37'),
(5, 'Yogurt Fresa', '16.00', 'banners_promocionales/1751657034_68682a4a8b27a.png', '/shop', 1, 400, 1, '2025-07-05 00:23:54', '2025-07-05 00:23:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel_cache_spatie.permission.cache', 'a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:55:{i:0;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:12:\"usuarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:1;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:15:\"usuarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:2;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:13:\"usuarios.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:3;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:13:\"usuarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:4;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:15:\"usuarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:5;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:13:\"productos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:6;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:16:\"productos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:7;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:14:\"productos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:8;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:14:\"productos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:9;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:16:\"productos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:10;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:14:\"categorias.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:11;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:17:\"categorias.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:12;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:15:\"categorias.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:13;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:15:\"categorias.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:14;a:4:{s:1:\"a\";i:29;s:1:\"b\";s:17:\"categorias.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:15;a:4:{s:1:\"a\";i:30;s:1:\"b\";s:11:\"banners.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:16;a:4:{s:1:\"a\";i:31;s:1:\"b\";s:14:\"banners.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:17;a:4:{s:1:\"a\";i:32;s:1:\"b\";s:12:\"banners.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:18;a:4:{s:1:\"a\";i:33;s:1:\"b\";s:14:\"banners.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:19;a:4:{s:1:\"a\";i:39;s:1:\"b\";s:25:\"banners_promocionales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:20;a:4:{s:1:\"a\";i:40;s:1:\"b\";s:28:\"banners_promocionales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:21;a:4:{s:1:\"a\";i:41;s:1:\"b\";s:26:\"banners_promocionales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:22;a:4:{s:1:\"a\";i:42;s:1:\"b\";s:28:\"banners_promocionales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:23;a:4:{s:1:\"a\";i:43;s:1:\"b\";s:12:\"clientes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:24;a:4:{s:1:\"a\";i:44;s:1:\"b\";s:15:\"clientes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:25;a:4:{s:1:\"a\";i:45;s:1:\"b\";s:13:\"clientes.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:26;a:4:{s:1:\"a\";i:46;s:1:\"b\";s:13:\"clientes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:27;a:4:{s:1:\"a\";i:47;s:1:\"b\";s:15:\"clientes.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:28;a:4:{s:1:\"a\";i:57;s:1:\"b\";s:11:\"ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:29;a:4:{s:1:\"a\";i:58;s:1:\"b\";s:14:\"ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:30;a:4:{s:1:\"a\";i:59;s:1:\"b\";s:12:\"ofertas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:31;a:4:{s:1:\"a\";i:60;s:1:\"b\";s:12:\"ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:32;a:4:{s:1:\"a\";i:61;s:1:\"b\";s:14:\"ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:33;a:4:{s:1:\"a\";i:62;s:1:\"b\";s:11:\"cupones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:34;a:4:{s:1:\"a\";i:63;s:1:\"b\";s:14:\"cupones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:35;a:4:{s:1:\"a\";i:64;s:1:\"b\";s:12:\"cupones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:36;a:4:{s:1:\"a\";i:65;s:1:\"b\";s:14:\"cupones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:37;a:4:{s:1:\"a\";i:66;s:1:\"b\";s:10:\"marcas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:38;a:4:{s:1:\"a\";i:67;s:1:\"b\";s:13:\"marcas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:39;a:4:{s:1:\"a\";i:68;s:1:\"b\";s:11:\"marcas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:40;a:4:{s:1:\"a\";i:69;s:1:\"b\";s:13:\"marcas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:41;a:4:{s:1:\"a\";i:70;s:1:\"b\";s:13:\"secciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:42;a:4:{s:1:\"a\";i:71;s:1:\"b\";s:16:\"secciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:43;a:4:{s:1:\"a\";i:72;s:1:\"b\";s:14:\"secciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:44;a:4:{s:1:\"a\";i:73;s:1:\"b\";s:16:\"secciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:45;a:4:{s:1:\"a\";i:74;s:1:\"b\";s:11:\"pedidos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:46;a:4:{s:1:\"a\";i:75;s:1:\"b\";s:12:\"pedidos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:47;a:4:{s:1:\"a\";i:76;s:1:\"b\";s:12:\"pedidos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:48;a:4:{s:1:\"a\";i:77;s:1:\"b\";s:14:\"pedidos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:49;a:4:{s:1:\"a\";i:78;s:1:\"b\";s:12:\"horarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:50;a:4:{s:1:\"a\";i:79;s:1:\"b\";s:15:\"horarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:51;a:4:{s:1:\"a\";i:80;s:1:\"b\";s:13:\"horarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:52;a:4:{s:1:\"a\";i:81;s:1:\"b\";s:15:\"horarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:53;a:4:{s:1:\"a\";i:82;s:1:\"b\";s:16:\"empresa_info.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:54;a:4:{s:1:\"a\";i:83;s:1:\"b\";s:17:\"empresa_info.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}}s:5:\"roles\";a:2:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:10:\"superadmin\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:5:\"admin\";s:1:\"c\";s:3:\"web\";}}}', 1755948654);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ID del usuario del sistema (admin, vendedor)',
  `user_cliente_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ID del cliente del e-commerce',
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `cantidad` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `cart_items`
--

INSERT INTO `cart_items` (`id`, `user_id`, `user_cliente_id`, `producto_id`, `cantidad`, `created_at`, `updated_at`) VALUES
(4, NULL, 2, 9, 2, '2025-08-22 11:40:41', '2025-08-22 11:43:27'),
(5, NULL, 2, 8, 2, '2025-08-22 11:44:43', '2025-08-22 11:48:36'),
(6, NULL, 2, 7, 1, '2025-08-22 11:46:07', '2025-08-22 11:46:07'),
(7, NULL, 2, 6, 3, '2025-08-22 16:07:58', '2025-08-22 16:07:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_seccion` int(11) DEFAULT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `id_seccion`, `nombre`, `descripcion`, `imagen`, `activo`, `created_at`, `updated_at`) VALUES
(7, 1, 'helllo', 'sdvsd', '1748383589_683637652bd47.jpeg', 1, '2025-05-28 03:06:29', '2025-05-28 03:06:29'),
(9, 1, 'Refigeracion', 'dzfvsdx', '1752768043_68791e2b714de.webp', 1, '2025-05-28 09:29:32', '2025-07-17 16:00:43'),
(10, 1, 'Discos', 'frescos', '1752767786_68791d2a2be52.jpg', 1, '2025-05-28 18:54:06', '2025-07-17 15:56:26'),
(11, 1, 'Mouse', 'frescos', '1752767910_68791da67f26f.jpg', 1, '2025-05-28 18:55:10', '2025-07-17 15:58:30'),
(12, 1, 'Teclados', NULL, '1752767887_68791d8f36a9b.jpg', 1, '2025-05-31 01:22:25', '2025-07-17 15:58:07'),
(13, NULL, 'pescados', NULL, '1748636593_683a13b1d0b26.webp', 1, '2025-05-31 01:23:13', '2025-05-31 01:23:13'),
(14, NULL, 'leche y derivados', NULL, '1748636641_683a13e1c593a.jpg', 1, '2025-05-31 01:24:01', '2025-05-31 01:24:01'),
(15, NULL, 'Postres', NULL, '1748636692_683a1414b32ab.jpg', 1, '2025-05-31 01:24:52', '2025-05-31 01:24:52'),
(16, 1, 'Fuente', NULL, '1752767979_68791deb01432.jpg', 1, '2025-05-31 01:26:36', '2025-07-17 15:59:39'),
(17, 1, 'Gaseosasws', NULL, '1748636980_683a15340c95d.jpg', 1, '2025-05-31 01:29:40', '2025-06-24 02:18:40'),
(18, 1, 'Procesadores', 'dsfvsda', '1752767692_68791cccb040a.webp', 1, '2025-06-11 19:14:50', '2025-07-17 15:54:52'),
(19, 1, 'hardware', 'sadvd', '1750713395_6859c433a4ce8.png', 1, '2025-06-24 02:16:35', '2025-07-17 03:25:13'),
(20, 1, 'Monitores', NULL, '1752767708_68791cdc6bbf8.jpg', 1, '2025-07-17 15:55:08', '2025-07-17 15:55:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tipo_documento` varchar(2) NOT NULL COMMENT '1=DNI, 6=RUC, 4=CE, 7=PASAPORTE',
  `numero_documento` varchar(20) NOT NULL,
  `razon_social` varchar(255) NOT NULL COMMENT 'Nombre completo o razón social',
  `nombre_comercial` varchar(255) DEFAULT NULL,
  `direccion` text NOT NULL,
  `ubigeo` varchar(6) DEFAULT NULL COMMENT 'Código UBIGEO INEI',
  `distrito` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `departamento` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Referencia a usuario registrado',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobantes`
--

CREATE TABLE `comprobantes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tipo_comprobante` varchar(2) NOT NULL COMMENT '01=Factura, 03=Boleta, 07=NC, 08=ND',
  `serie` varchar(4) NOT NULL,
  `correlativo` int(10) UNSIGNED NOT NULL,
  `numero_completo` varchar(20) GENERATED ALWAYS AS (concat(`serie`,'-',lpad(`correlativo`,8,'0'))) STORED,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `cliente_id` bigint(20) UNSIGNED NOT NULL,
  `cliente_tipo_documento` varchar(2) NOT NULL,
  `cliente_numero_documento` varchar(20) NOT NULL,
  `cliente_razon_social` varchar(255) NOT NULL,
  `cliente_direccion` text NOT NULL,
  `moneda` varchar(3) NOT NULL DEFAULT 'PEN',
  `operacion_gravada` decimal(12,2) NOT NULL DEFAULT 0.00,
  `operacion_exonerada` decimal(12,2) NOT NULL DEFAULT 0.00,
  `operacion_inafecta` decimal(12,2) NOT NULL DEFAULT 0.00,
  `operacion_gratuita` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_igv` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_descuentos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_otros_cargos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `importe_total` decimal(12,2) NOT NULL,
  `observaciones` text DEFAULT NULL,
  `comprobante_referencia_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tipo_nota` varchar(2) DEFAULT NULL COMMENT 'Código de tipo de nota de crédito/débito',
  `motivo_nota` text DEFAULT NULL,
  `estado` enum('PENDIENTE','ENVIADO','ACEPTADO','RECHAZADO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `codigo_hash` varchar(100) DEFAULT NULL,
  `xml_firmado` longtext DEFAULT NULL,
  `xml_respuesta_sunat` longtext DEFAULT NULL,
  `pdf_base64` longtext DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT 'Usuario que creó el comprobante',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobante_detalles`
--

CREATE TABLE `comprobante_detalles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `comprobante_id` bigint(20) UNSIGNED NOT NULL,
  `item` int(10) UNSIGNED NOT NULL COMMENT 'Número de línea',
  `producto_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Referencia al producto',
  `codigo_producto` varchar(30) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  `unidad_medida` varchar(10) NOT NULL DEFAULT 'NIU' COMMENT 'NIU=Número de unidades',
  `cantidad` decimal(12,4) NOT NULL,
  `valor_unitario` decimal(12,4) NOT NULL COMMENT 'Precio sin IGV',
  `precio_unitario` decimal(12,4) NOT NULL COMMENT 'Precio con IGV',
  `descuento` decimal(12,2) NOT NULL DEFAULT 0.00,
  `valor_venta` decimal(12,2) NOT NULL COMMENT 'cantidad * valor_unitario - descuento',
  `porcentaje_igv` decimal(5,2) NOT NULL DEFAULT 18.00,
  `igv` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tipo_afectacion_igv` varchar(2) NOT NULL DEFAULT '10' COMMENT '10=Gravado, 20=Exonerado, 30=Inafecto',
  `importe_total` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cupones`
--

CREATE TABLE `cupones` (
  `id` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo_descuento` enum('porcentaje','cantidad_fija') NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `compra_minima` decimal(10,2) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `limite_uso` int(11) DEFAULT NULL,
  `usos_actuales` int(11) DEFAULT 0,
  `solo_primera_compra` tinyint(1) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cupones`
--

INSERT INTO `cupones` (`id`, `codigo`, `titulo`, `descripcion`, `tipo_descuento`, `valor_descuento`, `compra_minima`, `fecha_inicio`, `fecha_fin`, `limite_uso`, `usos_actuales`, `solo_primera_compra`, `activo`, `created_at`, `updated_at`) VALUES
(2, 'hnb213', 'Descuento de bienvenida', 'hello', 'porcentaje', '12.00', '300.00', '2025-07-05 13:17:00', '2025-08-01 13:17:00', 1, 0, 1, 1, '2025-07-05 18:17:53', '2025-07-16 19:00:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `document_types`
--

CREATE TABLE `document_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `document_types`
--

INSERT INTO `document_types` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'DNI', '2025-05-26 17:18:30', '2025-05-26 17:18:30'),
(2, 'Pasaporte', '2025-05-26 17:18:30', '2025-05-26 17:18:30'),
(3, 'Carnet de Extranjería', '2025-05-26 17:18:30', '2025-05-26 17:18:30'),
(4, 'RUC', '2025-05-26 17:18:30', '2025-05-26 17:18:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa_info`
--

CREATE TABLE `empresa_info` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre_empresa` varchar(255) NOT NULL,
  `ruc` varchar(11) NOT NULL,
  `razon_social` varchar(255) NOT NULL,
  `direccion` text NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `twitter` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `horario_atencion` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `empresa_info`
--

INSERT INTO `empresa_info` (`id`, `nombre_empresa`, `ruc`, `razon_social`, `direccion`, `telefono`, `celular`, `email`, `website`, `logo`, `descripcion`, `facebook`, `instagram`, `twitter`, `youtube`, `whatsapp`, `horario_atencion`, `created_at`, `updated_at`) VALUES
(3, 'magus tecnolopgies', '97754764565', 'Magus tecnologies', 'cvbcxbvfvc', '9123423432423', NULL, 'empresa@gmailcom', 'https://magus-ecommerce.com/', 'empresa/logos/WJTpXNpjXn9gB2ut7wVcW5Zr7gbt4kk2BjXCWKAv.png', 'sdvsdvd', NULL, NULL, NULL, NULL, NULL, NULL, '2025-08-22 14:29:16', '2025-08-22 14:29:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados_pedido`
--

CREATE TABLE `estados_pedido` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `color` varchar(7) DEFAULT '#6c757d',
  `orden` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `estados_pedido`
--

INSERT INTO `estados_pedido` (`id`, `nombre`, `descripcion`, `color`, `orden`, `created_at`, `updated_at`) VALUES
(1, 'Pendiente', 'Pedido recibido, pendiente de confirmación', '#ffc107', 1, NULL, NULL),
(2, 'Confirmado', 'Pedido confirmado por el cliente', '#17a2b8', 2, NULL, NULL),
(3, 'En Preparación', 'Pedido en proceso de preparación', '#007bff', 3, NULL, NULL),
(4, 'Enviado', 'Pedido enviado al cliente', '#6f42c1', 4, NULL, NULL),
(5, 'Entregado', 'Pedido entregado exitosamente', '#28a745', 5, NULL, NULL),
(6, 'Cancelado', 'Pedido cancelado', '#dc3545', 6, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas_productos`
--

CREATE TABLE `marcas_productos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `marcas_productos`
--

INSERT INTO `marcas_productos` (`id`, `nombre`, `descripcion`, `imagen`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Samsung', 'Marca líder en tecnología y electrónicos', '1750259890_6852d8b2772df.png', 1, '2025-06-18 14:22:05', '2025-06-18 20:18:10'),
(2, 'Apple', 'Innovación en dispositivos móviles y computadoras', '1750260275_6852da339cab0.png', 1, '2025-06-18 14:22:05', '2025-06-18 20:24:35'),
(3, 'Sony', 'Electrónicos de alta calidad y entretenimiento', '1750260159_6852d9bf64226.png', 1, '2025-06-18 14:22:05', '2025-06-18 20:22:39'),
(4, 'LG', 'Electrodomésticos y tecnología para el hogar', '1750260284_6852da3c72ac7.png', 1, '2025-06-18 14:22:05', '2025-06-18 20:24:44'),
(5, 'Xiaomi', 'Tecnología accesible e innovadora', '1750260107_6852d98b67dfc.png', 1, '2025-06-18 14:22:05', '2025-06-18 20:21:47'),
(6, 'ASUS', 'Innovación en dispositivos móviles y computadoras', '1750260502_6852db1606f46.png', 1, '2025-06-18 20:28:22', '2025-06-18 20:28:22'),
(7, 'LENOVO', 'Innovación en dispositivos móviles y computadoras', '1750260517_6852db252808d.png', 1, '2025-06-18 20:28:37', '2025-06-18 20:28:37'),
(8, 'RYZEN', 'Innovación en dispositivos móviles y computadoras', '1750260530_6852db320b5f2.png', 1, '2025-06-18 20:28:50', '2025-06-18 20:28:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_05_21_141516_create_personal_access_tokens_table', 2),
(5, '2025_05_23_212502_create_user_profiles_table', 3),
(6, '2025_05_23_212626_create_user_addresses_table', 3),
(7, '2025_05_23_223135_add_last_names_to_user_profiles_table', 3),
(8, '2025_05_24_135354_create_roles_table', 4),
(9, '2025_05_24_224316_add_is_enabled_to_users_table', 5),
(10, '2025_05_25_040524_create_ubigeo_inei_table', 5),
(11, '2025_05_26_120602_create_document_types_table', 5),
(12, '2025_05_26_225958_remove_address_line_from_user_addresses_table', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(1, 'App\\Models\\User', 31),
(1, 'App\\Models\\User', 32),
(2, 'App\\Models\\User', 28),
(3, 'App\\Models\\User', 29);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ofertas`
--

CREATE TABLE `ofertas` (
  `id` int(10) UNSIGNED NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `subtitulo` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo_oferta_id` int(10) UNSIGNED DEFAULT NULL,
  `tipo_descuento` enum('porcentaje','cantidad_fija') NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `precio_minimo` decimal(10,2) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `banner_imagen` varchar(255) DEFAULT NULL,
  `color_fondo` varchar(20) DEFAULT '#3B82F6',
  `texto_boton` varchar(100) DEFAULT 'Compra ahora',
  `enlace_url` varchar(255) DEFAULT '/shop',
  `limite_uso` int(11) DEFAULT NULL,
  `usos_actuales` int(11) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `mostrar_countdown` tinyint(1) DEFAULT 0,
  `mostrar_en_slider` tinyint(1) DEFAULT 0,
  `mostrar_en_banner` tinyint(1) DEFAULT 0,
  `prioridad` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `es_oferta_principal` tinyint(1) DEFAULT 0,
  `es_oferta_semana` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ofertas`
--

INSERT INTO `ofertas` (`id`, `titulo`, `subtitulo`, `descripcion`, `tipo_oferta_id`, `tipo_descuento`, `valor_descuento`, `precio_minimo`, `fecha_inicio`, `fecha_fin`, `imagen`, `banner_imagen`, `color_fondo`, `texto_boton`, `enlace_url`, `limite_uso`, `usos_actuales`, `activo`, `mostrar_countdown`, `mostrar_en_slider`, `mostrar_en_banner`, `prioridad`, `created_at`, `updated_at`, `es_oferta_principal`, `es_oferta_semana`) VALUES
(2, 'super oferta', 'sdacsad', 'sadcdscsd', NULL, 'porcentaje', '12.00', '21.00', '2025-06-11 04:18:00', '2025-08-21 06:20:00', 'ofertas/bC6DLEynwH7KwOOHAizqy2V9Vq0xqFLlSY9XiE4U.png', 'ofertas/banners/8VoBZSXRFXusS9z2FA5dqke6GNFDoQaX8IcL1kQ6.png', '#96b8ee', 'Compra ahora', '/shop', 3, 0, 1, 1, 1, 1, 2, '2025-06-28 01:16:19', '2025-07-19 00:55:22', 1, 0),
(3, 'super oferton', '50 %de descuentop', 'dsacvsdaa', NULL, 'porcentaje', '50.00', '2.00', '2025-07-30 03:53:00', '2025-08-07 04:54:00', 'ofertas/6HJCCLFlhCksAplVeAmbq6Iw2FLq5Das5EiDAoNB.jpg', 'ofertas/banners/d36RokBVbFVukbIfVQxwYvBsNlKC0Ny5eqAR9GhO.png', '#5ddfd6', 'Compra ahora', '/shop', 2, 0, 1, 1, 1, 1, 1, '2025-06-28 01:51:55', '2025-07-30 15:55:47', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ofertas_productos`
--

CREATE TABLE `ofertas_productos` (
  `id` int(10) UNSIGNED NOT NULL,
  `oferta_id` int(10) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `precio_oferta` decimal(10,2) DEFAULT NULL,
  `stock_oferta` int(11) DEFAULT NULL,
  `vendidos_oferta` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ofertas_productos`
--

INSERT INTO `ofertas_productos` (`id`, `oferta_id`, `producto_id`, `precio_oferta`, `stock_oferta`, `vendidos_oferta`, `created_at`, `updated_at`) VALUES
(9, 2, 3, '16.80', 4, 0, '2025-07-18 23:05:36', '2025-07-18 23:05:36'),
(10, 2, 6, '4000.00', 10, 0, '2025-07-18 23:06:15', '2025-07-18 23:06:15'),
(11, 2, 4, '9.60', 10, 0, '2025-07-18 23:06:23', '2025-07-18 23:06:23'),
(12, 2, 8, '98.40', 10, 0, '2025-07-18 23:06:49', '2025-07-18 23:06:49'),
(13, 3, 8, '98.40', 10, 0, '2025-07-30 15:46:09', '2025-07-30 15:46:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `codigo_pedido` varchar(255) NOT NULL,
  `cliente_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_cliente_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha_pedido` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado_pedido_id` bigint(20) UNSIGNED NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `direccion_envio` text DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id`, `codigo_pedido`, `cliente_id`, `user_cliente_id`, `fecha_pedido`, `subtotal`, `igv`, `descuento_total`, `total`, `estado_pedido_id`, `metodo_pago`, `observaciones`, `direccion_envio`, `telefono_contacto`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 'PED-20250730-0001', NULL, 6, '2025-07-30 17:16:51', '123.00', '22.14', '0.00', '145.14', 1, 'efectivo', 'saddavsd', 'dsfvds', '993321920', 1, '2025-07-30 22:16:51', '2025-07-30 22:16:51'),
(3, 'PED-20250730-0002', NULL, 6, '2025-07-30 17:24:44', '5000.00', '900.00', '0.00', '5900.00', 1, 'efectivo', 'dsfvds', 'fsdvfsdvdsvdfs', '993321920', 1, '2025-07-30 22:24:44', '2025-07-30 22:24:44'),
(4, 'PED-20250730-0003', NULL, 2, '2025-07-30 18:29:12', '5000.00', '900.00', '0.00', '5900.00', 1, 'efectivo', 'dfsvfsd', 'fdgbgfdb', '993321920', 1, '2025-07-30 23:29:12', '2025-07-30 23:29:12'),
(5, 'PED-20250822-0004', NULL, 2, '2025-08-22 09:22:32', '614.00', '110.52', '0.00', '724.52', 1, 'tarjeta', NULL, 'dwsscs', '993230234', 1, '2025-08-22 14:22:32', '2025-08-22 14:22:32'),
(6, 'PED-20250822-0005', NULL, 2, '2025-08-22 11:27:25', '15614.00', '2810.52', '0.00', '18424.52', 1, 'tarjeta', NULL, '2 de mayo', '993321920', 1, '2025-08-22 16:27:25', '2025-08-22 16:27:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_detalles`
--

CREATE TABLE `pedido_detalles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pedido_id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `codigo_producto` varchar(255) NOT NULL,
  `nombre_producto` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pedido_detalles`
--

INSERT INTO `pedido_detalles` (`id`, `pedido_id`, `producto_id`, `codigo_producto`, `nombre_producto`, `cantidad`, `precio_unitario`, `subtotal_linea`, `created_at`, `updated_at`) VALUES
(1, 1, 8, 'FCS4213', 'iphone 134', 1, '123.00', '123.00', '2025-07-30 22:16:51', '2025-07-30 22:16:51'),
(2, 3, 6, '546428', 'pc asus', 1, '5000.00', '5000.00', '2025-07-30 22:24:44', '2025-07-30 22:24:44'),
(3, 4, 6, '546428', 'pc asus', 1, '5000.00', '5000.00', '2025-07-30 23:29:12', '2025-07-30 23:29:12'),
(4, 5, 9, 'FCS42132', 'iphone 134', 2, '123.00', '246.00', '2025-08-22 14:22:32', '2025-08-22 14:22:32'),
(5, 5, 8, 'FCS4213', 'iphone 134', 2, '123.00', '246.00', '2025-08-22 14:22:32', '2025-08-22 14:22:32'),
(6, 5, 7, '123123', 'iphone', 1, '122.00', '122.00', '2025-08-22 14:22:32', '2025-08-22 14:22:32'),
(7, 6, 9, 'FCS42132', 'iphone 134', 2, '123.00', '246.00', '2025-08-22 16:27:25', '2025-08-22 16:27:25'),
(8, 6, 8, 'FCS4213', 'iphone 134', 2, '123.00', '246.00', '2025-08-22 16:27:25', '2025-08-22 16:27:25'),
(9, 6, 7, '123123', 'iphone', 1, '122.00', '122.00', '2025-08-22 16:27:25', '2025-08-22 16:27:25'),
(10, 6, 6, '546428', 'pc asus', 3, '5000.00', '15000.00', '2025-08-22 16:27:25', '2025-08-22 16:27:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(13, 'usuarios.ver', 'web', '2025-06-01 08:11:16', '2025-06-05 23:59:57'),
(16, 'usuarios.create', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(17, 'usuarios.show', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(18, 'usuarios.edit', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(19, 'usuarios.delete', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(20, 'productos.ver', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(21, 'productos.create', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(22, 'productos.show', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(23, 'productos.edit', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(24, 'productos.delete', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(25, 'categorias.ver', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(26, 'categorias.create', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(27, 'categorias.show', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(28, 'categorias.edit', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(29, 'categorias.delete', 'web', '2025-06-05 23:59:57', '2025-06-05 23:59:57'),
(30, 'banners.ver', 'web', '2025-06-17 23:27:47', '2025-06-17 23:27:47'),
(31, 'banners.create', 'web', '2025-06-17 23:27:47', '2025-06-17 23:27:47'),
(32, 'banners.edit', 'web', '2025-06-17 23:27:47', '2025-06-17 23:27:47'),
(33, 'banners.delete', 'web', '2025-06-17 23:27:47', '2025-06-17 23:27:47'),
(39, 'banners_promocionales.ver', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(40, 'banners_promocionales.create', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(41, 'banners_promocionales.edit', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(42, 'banners_promocionales.delete', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(43, 'clientes.ver', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(44, 'clientes.create', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(45, 'clientes.show', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(46, 'clientes.edit', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(47, 'clientes.delete', 'web', '2025-06-24 01:01:12', '2025-06-24 01:01:12'),
(57, 'ofertas.ver', 'web', '2025-06-27 20:43:25', '2025-06-27 20:43:25'),
(58, 'ofertas.create', 'web', '2025-06-27 20:43:25', '2025-06-27 20:43:25'),
(59, 'ofertas.show', 'web', '2025-06-27 20:43:25', '2025-06-27 20:43:25'),
(60, 'ofertas.edit', 'web', '2025-06-27 20:43:25', '2025-06-27 20:43:25'),
(61, 'ofertas.delete', 'web', '2025-06-27 20:43:25', '2025-06-27 20:43:25'),
(62, 'cupones.ver', 'web', '2025-06-27 20:50:28', '2025-06-27 20:50:28'),
(63, 'cupones.create', 'web', '2025-06-27 20:50:28', '2025-06-27 20:50:28'),
(64, 'cupones.edit', 'web', '2025-06-27 20:50:28', '2025-06-27 20:50:28'),
(65, 'cupones.delete', 'web', '2025-06-27 20:50:28', '2025-06-27 20:50:28'),
(66, 'marcas.ver', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(67, 'marcas.create', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(68, 'marcas.edit', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(69, 'marcas.delete', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(70, 'secciones.ver', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(71, 'secciones.create', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(72, 'secciones.edit', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(73, 'secciones.delete', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(74, 'pedidos.ver', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(75, 'pedidos.show', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(76, 'pedidos.edit', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(77, 'pedidos.delete', 'web', '2025-07-04 03:00:55', '2025-07-04 03:00:55'),
(78, 'horarios.ver', 'web', '2025-07-14 14:39:45', '2025-07-14 14:39:45'),
(79, 'horarios.create', 'web', '2025-07-14 14:39:45', '2025-07-14 14:39:45'),
(80, 'horarios.edit', 'web', '2025-07-14 14:39:45', '2025-07-14 14:39:45'),
(81, 'horarios.delete', 'web', '2025-07-14 14:39:45', '2025-07-14 14:39:45'),
(82, 'empresa_info.ver', 'web', '2025-07-19 04:23:57', '2025-07-19 04:23:57'),
(83, 'empresa_info.edit', 'web', '2025-07-19 04:23:57', '2025-07-19 04:23:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(5, 'App\\Models\\User', 1, 'auth_token', '9d23785cb8607bcd52e2382fc5fe28bedb9a05d13b78dfdb92085750edb38cd3', '[\"*\"]', '2025-05-28 00:32:37', NULL, '2025-05-28 00:24:37', '2025-05-28 00:32:37'),
(6, 'App\\Models\\User', 1, 'auth_token', '093982904784e153caa715bffa150473a731fdf2cf8561af9994dafeceb7ace9', '[\"*\"]', '2025-05-28 00:33:20', NULL, '2025-05-28 00:33:17', '2025-05-28 00:33:20'),
(10, 'App\\Models\\User', 1, 'auth_token', '6e1c2f1dbdad717e682448622a98c673c8ed8782bad81408271f2101faa550f8', '[\"*\"]', NULL, NULL, '2025-05-31 02:34:04', '2025-05-31 02:34:04'),
(14, 'App\\Models\\User', 1, 'auth_token', 'b9a12ece6198a275ebc00ecfbfeedb3090c22820b56a92e6f8e7737c19a5a6c8', '[\"*\"]', '2025-06-04 03:07:25', NULL, '2025-06-04 02:44:16', '2025-06-04 03:07:25'),
(17, 'App\\Models\\User', 1, 'auth_token', 'ddcce5e152a48ec076dc2503087dee31bf591915d502af873e64c832a47ec567', '[\"*\"]', NULL, NULL, '2025-06-06 19:46:03', '2025-06-06 19:46:03'),
(18, 'App\\Models\\User', 1, 'auth_token', '8de995dfd45435502a5380a7365ee39ffa90e8213b61baba725fe3f85e93679b', '[\"*\"]', '2025-06-06 19:56:17', NULL, '2025-06-06 19:46:09', '2025-06-06 19:56:17'),
(25, 'App\\Models\\User', 1, 'auth_token', 'b2baef18be0eb897d0dd7650faa6aa8bc48990552b22b428fb0a289fe1026ae2', '[\"*\"]', '2025-06-11 19:19:38', NULL, '2025-06-11 19:14:14', '2025-06-11 19:19:38'),
(27, 'App\\Models\\UserCliente', 1, 'cliente_token', '3a3491672ca041205cd53ab2eadb7a2eeb00fc6f20a87ab74f2025b24ca0e278', '[\"*\"]', NULL, NULL, '2025-06-19 01:26:49', '2025-06-19 01:26:49'),
(29, 'App\\Models\\UserCliente', 2, 'cliente_token', 'dd057d58a94a0d42172888de78d7a98ba7abb34d92ab959f175032e13d50d9cc', '[\"*\"]', NULL, NULL, '2025-06-19 02:06:06', '2025-06-19 02:06:06'),
(31, 'App\\Models\\User', 1, 'admin_token', '83e906169a0936d77fc0ac55d33032173c67e6d75baa4ed87ecd9926953f1378', '[\"*\"]', '2025-06-19 20:18:12', NULL, '2025-06-19 20:17:58', '2025-06-19 20:18:12'),
(36, 'App\\Models\\UserCliente', 5, 'cliente_token', '22b3036578017729a97e1190fe7a247a87c44985774a55bacf7a2fa999abb0c5', '[\"*\"]', NULL, NULL, '2025-06-24 00:49:03', '2025-06-24 00:49:03'),
(50, 'App\\Models\\User', 1, 'admin_token', 'b5d591142d2095c0a8cb306ec5b617a54092ed00acbdc4286f2c0aa1e30e43bf', '[\"*\"]', '2025-07-04 22:01:31', NULL, '2025-07-04 18:45:04', '2025-07-04 22:01:31'),
(53, 'App\\Models\\User', 1, 'admin_token', '9f5ad3bc4e0064ea9205b930fec9b896850a6c1cf222d9a7ddc1941aec9fe6ce', '[\"*\"]', '2025-07-05 01:31:48', NULL, '2025-07-05 00:19:10', '2025-07-05 01:31:48'),
(57, 'App\\Models\\User', 1, 'admin_token', '797024cc95a5e7a1f33bcbadfe54d53b6333302be43ca41bdec08ea06b4224bd', '[\"*\"]', '2025-07-11 17:29:26', NULL, '2025-07-11 17:28:00', '2025-07-11 17:29:26'),
(58, 'App\\Models\\User', 1, 'admin_token', '7002d34f58e49d6ca23d34bbcabb2b24afd14314d99e5e504be21a76fc5978db', '[\"*\"]', '2025-07-11 17:41:34', NULL, '2025-07-11 17:40:15', '2025-07-11 17:41:34'),
(59, 'App\\Models\\User', 1, 'admin_token', '4f57a1b1c437babf296a74f7d2d26c411ac04e02e96f0c68b78bf19ba14a0874', '[\"*\"]', '2025-07-14 08:07:34', NULL, '2025-07-14 07:43:53', '2025-07-14 08:07:34'),
(61, 'App\\Models\\User', 1, 'admin_token', '8f01cb4e805c5705c5ee7853a82a66aef41892ae64833eb1819c7ca0900ac386', '[\"*\"]', '2025-07-14 14:33:51', NULL, '2025-07-14 14:33:06', '2025-07-14 14:33:51'),
(62, 'App\\Models\\User', 1, 'admin_token', '5df89482c044ba548a64fc15efe7fe67af405a3d58beb2ae3f38bf8519d8a04c', '[\"*\"]', '2025-07-14 14:48:37', NULL, '2025-07-14 14:35:41', '2025-07-14 14:48:37'),
(64, 'App\\Models\\User', 1, 'admin_token', '9f48b044538274cf3c8721613ded5759c28ab80fe69cf3bb55180762bd0534a7', '[\"*\"]', '2025-07-16 21:41:05', NULL, '2025-07-16 21:04:50', '2025-07-16 21:41:05'),
(66, 'App\\Models\\User', 1, 'admin_token', 'b7455222d1eb305d8f9b79a5f30ddc99e5a3d220d49e35a72b9ee293b9af660c', '[\"*\"]', '2025-07-16 22:38:06', NULL, '2025-07-16 22:33:56', '2025-07-16 22:38:06'),
(67, 'App\\Models\\User', 1, 'admin_token', 'e2ca356b4eac2cc8f23718c429eed3985ae18e8c51c5233d4d2a22d6ee9a8a3f', '[\"*\"]', '2025-07-17 02:20:09', NULL, '2025-07-17 00:42:08', '2025-07-17 02:20:09'),
(71, 'App\\Models\\User', 1, 'admin_token', 'fedf8b31c6b8c7520407c36a9adfe5bf53b13c903eeaf94e57ac96aabcb2370b', '[\"*\"]', '2025-07-18 14:02:35', NULL, '2025-07-18 13:59:51', '2025-07-18 14:02:35'),
(72, 'App\\Models\\User', 1, 'admin_token', '280c6fcb63ef892dc052734d927dac2caf669915ea2082f7e356ca135b065764', '[\"*\"]', '2025-07-18 16:20:44', NULL, '2025-07-18 16:20:35', '2025-07-18 16:20:44'),
(76, 'App\\Models\\User', 1, 'admin_token', '78cccd000ba10deb30b2eed358eb2c1b075a7b8620b89315d42714ea8ed17494', '[\"*\"]', '2025-07-19 04:18:43', NULL, '2025-07-19 04:18:42', '2025-07-19 04:18:43'),
(77, 'App\\Models\\User', 1, 'admin_token', 'f06a3c8accba2b09387ef91f917afa295ba3a5e9e34ac8b7ede41e94097d97e0', '[\"*\"]', '2025-07-19 04:21:25', NULL, '2025-07-19 04:21:10', '2025-07-19 04:21:25'),
(78, 'App\\Models\\User', 1, 'admin_token', '8110e367705dc5852472b741b8837a07afb7a86526d75bad4c144752c48e1435', '[\"*\"]', '2025-07-19 04:29:53', NULL, '2025-07-19 04:26:34', '2025-07-19 04:29:53'),
(79, 'App\\Models\\User', 1, 'admin_token', '6c51787e1b09fb70df917bef1498a51d1807c832cd1037132b0b3c8f42e7ec49', '[\"*\"]', '2025-07-19 12:36:35', NULL, '2025-07-19 12:36:30', '2025-07-19 12:36:35'),
(82, 'App\\Models\\User', 1, 'admin_token', '6878cfd2d13daedd1cc54261bbb7317aca5f92479c1d2abd1720dc180415369a', '[\"*\"]', '2025-07-19 16:16:25', NULL, '2025-07-19 15:40:03', '2025-07-19 16:16:25'),
(83, 'App\\Models\\User', 1, 'admin_token', '9e10d387adfc6b9551c5807aa0e918d8080be143d5451662e957727441a0440b', '[\"*\"]', '2025-07-22 04:21:26', NULL, '2025-07-22 03:32:10', '2025-07-22 04:21:26'),
(84, 'App\\Models\\User', 1, 'admin_token', '10bac27af0e5122826defe6c30ba8dbf6fb925a99bea38763ba81a26d5f4dc2c', '[\"*\"]', '2025-07-30 14:29:10', NULL, '2025-07-30 11:37:27', '2025-07-30 14:29:10'),
(87, 'App\\Models\\UserCliente', 6, 'cliente_token', 'c555901a81133357ce972e82769b1742844c40b1f73432c3e3d543a14e425f90', '[\"*\"]', '2025-07-30 22:24:43', NULL, '2025-07-30 22:13:47', '2025-07-30 22:24:43'),
(88, 'App\\Models\\UserCliente', 2, 'cliente_token', 'cb4fd3d0bf2f6a03f87199a04cbb81e5d83f099665d87909fb5d6b47ea161e94', '[\"*\"]', '2025-07-30 23:29:12', NULL, '2025-07-30 23:28:32', '2025-07-30 23:29:12'),
(89, 'App\\Models\\User', 1, 'admin_token', '0f7748db335792040d6ae435881e83363bd273f7459d6820a8757c914b1d8403', '[\"*\"]', '2025-07-30 23:31:23', NULL, '2025-07-30 23:29:55', '2025-07-30 23:31:23'),
(90, 'App\\Models\\UserCliente', 2, 'cliente_token', '24f0623bd0e589b4e274dd60532ad26b8f3ddf2362370b65e079e83dc6f25c7b', '[\"*\"]', '2025-08-01 22:17:33', NULL, '2025-08-01 22:06:14', '2025-08-01 22:17:33'),
(91, 'App\\Models\\User', 1, 'admin_token', '7b689207f3e07ba382831e1811282ac1ca07863c6302ad8467b15d123dfd89fe', '[\"*\"]', '2025-08-01 22:50:11', NULL, '2025-08-01 22:38:26', '2025-08-01 22:50:11'),
(92, 'App\\Models\\User', 1, 'admin_token', '33f29819f8916324a81dd107a595e8e80b548c20a9b509b1d4f31b28d245e505', '[\"*\"]', '2025-08-01 23:16:03', NULL, '2025-08-01 23:16:02', '2025-08-01 23:16:03'),
(93, 'App\\Models\\UserCliente', 2, 'cliente_token', '313e1078bf3b6af4a3c9441c946f6961963997f912aa20bac25500476a7a4bdd', '[\"*\"]', NULL, NULL, '2025-08-02 13:22:02', '2025-08-02 13:22:02'),
(94, 'App\\Models\\UserCliente', 2, 'cliente_token', '309eaf00386be343f4dca03136fdd5c61bd0f0e8a73e479b79d339096a8a6da8', '[\"*\"]', '2025-08-02 15:27:21', NULL, '2025-08-02 14:06:17', '2025-08-02 15:27:21'),
(95, 'App\\Models\\UserCliente', 2, 'cliente_token', 'ccca771a3e227b2dec7f6227ca5b17f2f9807ef60a29771951541d71ac2a32c7', '[\"*\"]', '2025-08-22 03:14:37', NULL, '2025-08-22 03:14:36', '2025-08-22 03:14:37'),
(109, 'App\\Models\\UserCliente', 2, 'cliente_token', '1a52bfa96640b66560e17cf1561ae066c9214fcc73864b669dce27d826c4ea14', '[\"*\"]', '2025-08-22 04:08:55', NULL, '2025-08-22 04:08:08', '2025-08-22 04:08:55'),
(113, 'App\\Models\\UserCliente', 2, 'cliente_token', 'e161368fe49c1ed557b72dc858539ac16106811a1ec5693671e58d35a42e6290', '[\"*\"]', '2025-08-22 04:20:09', NULL, '2025-08-22 04:19:43', '2025-08-22 04:20:09'),
(114, 'App\\Models\\UserCliente', 2, 'cliente_token', '79b4579073fb65ea107d968611e2fce4a6a775999b5ca9a92a9779b767e9ba79', '[\"*\"]', NULL, NULL, '2025-08-22 04:26:54', '2025-08-22 04:26:54'),
(123, 'App\\Models\\UserCliente', 2, 'cliente_token', 'de4d8053a33d23b43723e085186f17a7305178fdc4f3a40565fb6ad3406edc8c', '[\"*\"]', '2025-08-22 12:43:25', NULL, '2025-08-22 12:43:07', '2025-08-22 12:43:25'),
(124, 'App\\Models\\UserCliente', 2, 'cliente_token', 'a7174f0b4eb2188d0560ab234dba291c7a6bb39168a100e88edd88c10f4aef11', '[\"*\"]', '2025-08-22 12:59:56', NULL, '2025-08-22 12:59:14', '2025-08-22 12:59:56'),
(125, 'App\\Models\\UserCliente', 2, 'cliente_token', '10afc2c473328699fe60bdd414d8f3f1066357168bb48a55fd4769409a4bd57a', '[\"*\"]', '2025-08-22 14:22:40', NULL, '2025-08-22 13:19:33', '2025-08-22 14:22:40'),
(126, 'App\\Models\\User', 1, 'admin_token', 'fb92c628170e2b33fb406a7e7ece711cda0fa64c33b0dae4a9bcd7845617a925', '[\"*\"]', '2025-08-22 15:45:47', NULL, '2025-08-22 14:27:34', '2025-08-22 15:45:47'),
(127, 'App\\Models\\UserCliente', 2, 'cliente_token', '3ac9191bac1f35b67d45eb208e9c4a64f8040f461a92e83f0d1cce86aae033a8', '[\"*\"]', '2025-08-22 16:27:26', NULL, '2025-08-22 16:07:57', '2025-08-22 16:27:26'),
(128, 'App\\Models\\User', 1, 'admin_token', 'e4a83c606df0d116d74e0f09d3a03b227e691e3ea9c01c4fc8b8668428babd15', '[\"*\"]', '2025-08-22 16:31:51', NULL, '2025-08-22 16:29:11', '2025-08-22 16:31:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `codigo_producto` varchar(100) NOT NULL,
  `categoria_id` bigint(20) UNSIGNED NOT NULL,
  `marca_id` bigint(20) UNSIGNED DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 5,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `destacado` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `codigo_producto`, `categoria_id`, `marca_id`, `precio_compra`, `precio_venta`, `stock`, `stock_minimo`, `imagen`, `activo`, `destacado`, `created_at`, `updated_at`) VALUES
(3, 'Procesadores', NULL, 'COCA-123122', 18, 6, '12.00', '21.00', 4, 5, '1752767669_68791cb536c5d.webp', 1, 0, '2025-05-31 01:59:21', '2025-07-17 18:15:31'),
(4, 'FANTA', NULL, 'FAN-024', 18, 1, '12.00', '12.00', 111, 5, '1748638813_683a1c5d58e2f.png', 1, 1, '2025-05-31 02:00:13', '2025-07-18 14:31:32'),
(6, 'pc asus', 'ewdsfqwfewq', '546428', 18, 5, '4000.00', '5000.00', 95, 5, '1749651503_6849902fc362b.png', 1, 0, '2025-06-11 19:18:23', '2025-08-22 16:27:25'),
(7, 'iphone', 'scdsacsd', '123123', 18, 8, '122.00', '122.00', 19, 5, '1751580203_6866fe2ba0504.png', 1, 1, '2025-07-04 03:03:23', '2025-08-22 16:27:25'),
(8, 'iphone 134', 'SJNVCIODS', 'FCS4213', 18, 8, '1212.00', '123.00', 7, 5, '1752701618_68781ab225120.png', 1, 0, '2025-07-16 21:33:38', '2025-08-22 16:27:25'),
(9, 'iphone 134', 'SJNVCIODS', 'FCS42132', 18, 7, '1212.00', '123.00', 8, 5, '1752701638_68781ac676010.jpg', 1, 0, '2025-07-16 21:33:58', '2025-08-22 16:27:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_detalles`
--

CREATE TABLE `producto_detalles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `descripcion_detallada` longtext DEFAULT NULL,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`especificaciones`)),
  `caracteristicas_tecnicas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`caracteristicas_tecnicas`)),
  `instrucciones_uso` text DEFAULT NULL,
  `garantia` text DEFAULT NULL,
  `politicas_devolucion` text DEFAULT NULL,
  `dimensiones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`dimensiones`)),
  `imagenes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`imagenes`)),
  `videos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`videos`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `producto_detalles`
--

INSERT INTO `producto_detalles` (`id`, `producto_id`, `descripcion_detallada`, `especificaciones`, `caracteristicas_tecnicas`, `instrucciones_uso`, `garantia`, `politicas_devolucion`, `dimensiones`, `imagenes`, `videos`, `created_at`, `updated_at`) VALUES
(1, 3, '<p><span style=\"background-color: rgb(255, 255, 255); color: rgb(130, 130, 130);\">Dondequiera&nbsp;que&nbsp;haya&nbsp;celebraciones&nbsp;y&nbsp;buenos&nbsp;momentos,&nbsp;la&nbsp;marca&nbsp;LAY&#39;S&nbsp;estará&nbsp;presente,&nbsp;como&nbsp;lo&nbsp;ha&nbsp;estado&nbsp;durante&nbsp;más&nbsp;de&nbsp;75&nbsp;años.&nbsp;Con&nbsp;sabores&nbsp;casi&nbsp;tan&nbsp;ricos&nbsp;como&nbsp;nuestra&nbsp;historia,&nbsp;tenemos&nbsp;un&nbsp;sabor&nbsp;a&nbsp;papas&nbsp;fritas&nbsp;o&nbsp;crujientes&nbsp;que&nbsp;te&nbsp;hará&nbsp;sonreír.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(130, 130, 130);\">Morbi&nbsp;ut&nbsp;sapien&nbsp;vitae&nbsp;odio&nbsp;accumsan&nbsp;gravida.&nbsp;Morbi&nbsp;vitae&nbsp;erat&nbsp;auctor,&nbsp;eleifend&nbsp;nunc&nbsp;a,&nbsp;lobortis&nbsp;neque.&nbsp;Praesent&nbsp;aliquam&nbsp;dignissim&nbsp;viverra.&nbsp;Maecenas&nbsp;lacus&nbsp;odio,&nbsp;feugiat&nbsp;eu&nbsp;nunc&nbsp;sit&nbsp;amet,&nbsp;maximus&nbsp;sagittis&nbsp;dolor.&nbsp;Vivamus&nbsp;nisi&nbsp;sapien,&nbsp;elementum&nbsp;sit&nbsp;amet&nbsp;eros&nbsp;sit&nbsp;amet,&nbsp;ultricies&nbsp;cursus&nbsp;ipsum.&nbsp;Sed&nbsp;consequat&nbsp;luctus&nbsp;ligula.&nbsp;Curabitur&nbsp;laoreet&nbsp;rhoncus&nbsp;blandit.&nbsp;Aenean&nbsp;vel&nbsp;diam&nbsp;ut&nbsp;arcu&nbsp;pharetra&nbsp;dignissim&nbsp;ut&nbsp;sed&nbsp;leo.&nbsp;Vivamus&nbsp;faucibus,&nbsp;ipsum&nbsp;in&nbsp;vestibulum&nbsp;vulputate,&nbsp;lorem&nbsp;orci&nbsp;convallis&nbsp;quam,&nbsp;sit&nbsp;amet&nbsp;consequat&nbsp;nulla&nbsp;felis&nbsp;pharetra&nbsp;lacus.&nbsp;Duis&nbsp;semper&nbsp;erat&nbsp;mauris,&nbsp;sed&nbsp;egestas&nbsp;purus&nbsp;commodo&nbsp;vel.</span></p><ul><li><span style=\"background-color: rgb(255, 255, 255); color: rgb(153, 153, 153);\">Bolsa&nbsp;de&nbsp;8.0&nbsp;oz&nbsp;de&nbsp;papas&nbsp;fritas&nbsp;clásicas&nbsp;LAY&#39;S</span></li><li><span style=\"background-color: rgb(255, 255, 255); color: rgb(153, 153, 153);\">Las&nbsp;papas&nbsp;fritas&nbsp;LAY&#39;S&nbsp;son&nbsp;un&nbsp;gran&nbsp;refrigerio</span></li><li><span style=\"background-color: rgb(255, 255, 255); color: rgb(153, 153, 153);\">Incluye&nbsp;tres&nbsp;ingredientes:&nbsp;papas,&nbsp;aceite&nbsp;y&nbsp;sal</span></li><li><span style=\"background-color: rgb(255, 255, 255); color: rgb(153, 153, 153);\">Producto&nbsp;sin&nbsp;gluten</span></li></ul><p></p>', '\"[{\\\"nombre\\\":\\\"helo \\\",\\\"valor\\\":\\\"dscvds\\\"}]\"', '\"[{\\\"caracteristica\\\":\\\"procesador asd\\\",\\\"detalle\\\":\\\"CORE I9 \\\"}]\"', 'sdfvdsfvdsvfds', '1|sfdvdsfv', 'dfsvdsvfdsdsfv', '\"[2131,213,123,213]\"', '\"[\\\"1752240509_6871117d1a9cc.webp\\\",\\\"1752240510_6871117e094e0.webp\\\",\\\"1752240510_6871117e09d6c.jpg\\\"]\"', '\"[\\\"https:\\\\\\/\\\\\\/www.youtube.com\\\\\\/watch?v=7ly7Mhle-4M&list=RD9o-8ZS53_yY&index=27\\\"]\"', '2025-07-11 18:28:30', '2025-07-11 18:28:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL DEFAULT 'web',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'web', '2025-05-31 10:49:45', '2025-05-31 10:49:45'),
(2, 'admin', 'web', '2025-05-31 10:49:45', '2025-05-31 10:49:45'),
(3, 'vendedor', 'web', '2025-05-31 10:49:45', '2025-05-31 10:49:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(13, 1),
(16, 1),
(17, 1),
(17, 2),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(43, 1),
(44, 1),
(45, 1),
(46, 1),
(47, 1),
(57, 1),
(58, 1),
(59, 1),
(60, 1),
(61, 1),
(62, 1),
(63, 1),
(64, 1),
(65, 1),
(66, 1),
(67, 1),
(68, 1),
(69, 1),
(70, 1),
(71, 1),
(72, 1),
(73, 1),
(74, 1),
(75, 1),
(76, 1),
(77, 1),
(78, 1),
(79, 1),
(80, 1),
(81, 1),
(82, 1),
(83, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `secciones`
--

CREATE TABLE `secciones` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `secciones`
--

INSERT INTO `secciones` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'Computadoras', NULL, '2025-06-24 02:15:06', '2025-07-17 00:42:31'),
(2, 'Laptos', NULL, '2025-07-17 00:42:41', '2025-07-17 00:42:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `series_comprobantes`
--

CREATE TABLE `series_comprobantes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tipo_comprobante` varchar(2) NOT NULL COMMENT '01=Factura, 03=Boleta, 07=Nota Crédito, 08=Nota Débito',
  `serie` varchar(4) NOT NULL,
  `correlativo` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `series_comprobantes`
--

INSERT INTO `series_comprobantes` (`id`, `tipo_comprobante`, `serie`, `correlativo`, `activo`, `created_at`, `updated_at`) VALUES
(1, '01', 'F001', 0, 1, '2025-06-18 20:25:55', '2025-06-18 20:25:55'),
(2, '03', 'B001', 0, 1, '2025-06-18 20:25:55', '2025-06-18 20:25:55'),
(3, '07', 'FC01', 0, 1, '2025-06-18 20:25:55', '2025-06-18 20:25:55'),
(4, '07', 'BC01', 0, 1, '2025-06-18 20:25:55', '2025-06-18 20:25:55'),
(5, '08', 'FD01', 0, 1, '2025-06-18 20:25:55', '2025-06-18 20:25:55'),
(6, '08', 'BD01', 0, 1, '2025-06-18 20:25:55', '2025-06-18 20:25:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('95ZWVhGtNYBN3KNK7QHcUftFki0NCfmrC2pZTQVQ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlBmYUhMRnlwdDhCWUNSS2ZMWksyTmJpVnlPYlFONVl5aG9YSzZMRyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1753064179),
('gdUalb3FVqm2dPnAzuvuVU6oVnc6JS9jli3iEz50', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiWTNPTDNGd2lMWXhyYlJLR2FhVGRsV01jTURNQ2xKaGs5TmR5T2p6YyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hdXRoL2dvb2dsZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NToic3RhdGUiO3M6NDA6IkFpVTRxZUZ3R05yUkhTWVBYNWZTMzhIVkFyMkE4SEw5bDNaUzFaUHkiO30=', 1751667503),
('kSihQziGgoHvLdVOAJzxOJnLGmpbo8t5OkdraVo0', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUZmU3lPOTVoQm15bjRsQjNsRDdsb2N1U3l5R1R1bk9YQlFGZVczWCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvaG9sYSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747782161),
('QIpDDHRiHxaPUu9VDUPxC2vnV3CZ3bw7aLFUMV2e', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiakFEd1NZM2lrcnhsQTBiVVZrTXlHalNvdEdCWERZNUhDRHptSDJkcSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747753007),
('YmMhuCMeWlrB56Efd3N4lczZ5BPKXvc5UWVFxlcs', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOVBKUnA2cUFXczg0VnB2dXl6UUlNM3E4Q21Pb0lRY1VNR2c0Vnl2TiI7czo1OiJzdGF0ZSI7czo0MDoiMFpzUVJnQVFuZEo3VTFFbFl2QUxPT3NSQVdCeDZpUHNlU0FnREVBTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hdXRoL2dvb2dsZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1753913068);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_ofertas`
--

CREATE TABLE `tipos_ofertas` (
  `id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_ofertas`
--

INSERT INTO `tipos_ofertas` (`id`, `nombre`, `descripcion`, `icono`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'flash_sale', 'Ventas flash con tiempo limitado', NULL, 1, '2025-06-27 04:49:47', '2025-06-27 04:49:47'),
(2, 'oferta_dia', 'Ofertas especiales del día', NULL, 1, '2025-06-27 04:49:47', '2025-06-27 04:49:47'),
(3, 'primera_compra', 'Descuentos para primera compra', NULL, 1, '2025-06-27 04:49:47', '2025-06-27 04:49:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubigeo_inei`
--

CREATE TABLE `ubigeo_inei` (
  `id_ubigeo` int(11) NOT NULL,
  `departamento` varchar(2) NOT NULL,
  `provincia` varchar(2) NOT NULL,
  `distrito` varchar(2) NOT NULL,
  `nombre` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `ubigeo_inei`
--

INSERT INTO `ubigeo_inei` (`id_ubigeo`, `departamento`, `provincia`, `distrito`, `nombre`) VALUES
(1, '01', '00', '00', 'AMAZONAS'),
(2, '01', '01', '00', 'CHACHAPOYAS'),
(3, '01', '01', '01', 'CHACHAPOYAS'),
(4, '01', '01', '02', 'ASUNCION'),
(5, '01', '01', '03', 'BALSAS'),
(6, '01', '01', '04', 'CHETO'),
(7, '01', '01', '05', 'CHILIQUIN'),
(8, '01', '01', '06', 'CHUQUIBAMBA'),
(9, '01', '01', '07', 'GRANADA'),
(10, '01', '01', '08', 'HUANCAS'),
(11, '01', '01', '09', 'LA JALCA'),
(12, '01', '01', '10', 'LEIMEBAMBA'),
(13, '01', '01', '11', 'LEVANTO'),
(14, '01', '01', '12', 'MAGDALENA'),
(15, '01', '01', '13', 'MARISCAL CASTILLA'),
(16, '01', '01', '14', 'MOLINOPAMPA'),
(17, '01', '01', '15', 'MONTEVIDEO'),
(18, '01', '01', '16', 'OLLEROS'),
(19, '01', '01', '17', 'QUINJALCA'),
(20, '01', '01', '18', 'SAN FRANCISCO DE DAGUAS'),
(21, '01', '01', '19', 'SAN ISIDRO DE MAINO'),
(22, '01', '01', '20', 'SOLOCO'),
(23, '01', '01', '21', 'SONCHE'),
(24, '01', '02', '00', 'BAGUA'),
(25, '01', '02', '01', 'BAGUA'),
(26, '01', '02', '02', 'ARAMANGO'),
(27, '01', '02', '03', 'COPALLIN'),
(28, '01', '02', '04', 'EL PARCO'),
(29, '01', '02', '05', 'IMAZA'),
(30, '01', '02', '06', 'LA PECA'),
(31, '01', '03', '00', 'BONGARA'),
(32, '01', '03', '01', 'JUMBILLA'),
(33, '01', '03', '02', 'CHISQUILLA'),
(34, '01', '03', '03', 'CHURUJA'),
(35, '01', '03', '04', 'COROSHA'),
(36, '01', '03', '05', 'CUISPES'),
(37, '01', '03', '06', 'FLORIDA'),
(38, '01', '03', '07', 'JAZÁN'),
(39, '01', '03', '08', 'RECTA'),
(40, '01', '03', '09', 'SAN CARLOS'),
(41, '01', '03', '10', 'SHIPASBAMBA'),
(42, '01', '03', '11', 'VALERA'),
(43, '01', '03', '12', 'YAMBRASBAMBA'),
(44, '01', '04', '00', 'CONDORCANQUI'),
(45, '01', '04', '01', 'NIEVA'),
(46, '01', '04', '02', 'EL CENEPA'),
(47, '01', '04', '03', 'RIO SANTIAGO'),
(48, '01', '05', '00', 'LUYA'),
(49, '01', '05', '01', 'LAMUD'),
(50, '01', '05', '02', 'CAMPORREDONDO'),
(51, '01', '05', '03', 'COCABAMBA'),
(52, '01', '05', '04', 'COLCAMAR'),
(53, '01', '05', '05', 'CONILA'),
(54, '01', '05', '06', 'INGUILPATA'),
(55, '01', '05', '07', 'LONGUITA'),
(56, '01', '05', '08', 'LONYA CHICO'),
(57, '01', '05', '09', 'LUYA'),
(58, '01', '05', '10', 'LUYA VIEJO'),
(59, '01', '05', '11', 'MARIA'),
(60, '01', '05', '12', 'OCALLI'),
(61, '01', '05', '13', 'OCUMAL'),
(62, '01', '05', '14', 'PISUQUIA'),
(63, '01', '05', '15', 'PROVIDENCIA'),
(64, '01', '05', '16', 'SAN CRISTOBAL'),
(65, '01', '05', '17', 'SAN FRANCISCO DEL YESO'),
(66, '01', '05', '18', 'SAN JERONIMO'),
(67, '01', '05', '19', 'SAN JUAN DE LOPECANCHA'),
(68, '01', '05', '20', 'SANTA CATALINA'),
(69, '01', '05', '21', 'SANTO TOMAS'),
(70, '01', '05', '22', 'TINGO'),
(71, '01', '05', '23', 'TRITA'),
(72, '01', '06', '00', 'RODRIGUEZ DE MENDOZA'),
(73, '01', '06', '01', 'SAN NICOLAS'),
(74, '01', '06', '02', 'CHIRIMOTO'),
(75, '01', '06', '03', 'COCHAMAL'),
(76, '01', '06', '04', 'HUAMBO'),
(77, '01', '06', '05', 'LIMABAMBA'),
(78, '01', '06', '06', 'LONGAR'),
(79, '01', '06', '07', 'MARISCAL BENAVIDES'),
(80, '01', '06', '08', 'MILPUC'),
(81, '01', '06', '09', 'OMIA'),
(82, '01', '06', '10', 'SANTA ROSA'),
(83, '01', '06', '11', 'TOTORA'),
(84, '01', '06', '12', 'VISTA ALEGRE'),
(85, '01', '07', '00', 'UTCUBAMBA'),
(86, '01', '07', '01', 'BAGUA GRANDE'),
(87, '01', '07', '02', 'CAJARURO'),
(88, '01', '07', '03', 'CUMBA'),
(89, '01', '07', '04', 'EL MILAGRO'),
(90, '01', '07', '05', 'JAMALCA'),
(91, '01', '07', '06', 'LONYA GRANDE'),
(92, '01', '07', '07', 'YAMON'),
(93, '02', '00', '00', 'ANCASH'),
(94, '02', '01', '00', 'HUARAZ'),
(95, '02', '01', '01', 'HUARAZ'),
(96, '02', '01', '02', 'COCHABAMBA'),
(97, '02', '01', '03', 'COLCABAMBA'),
(98, '02', '01', '04', 'HUANCHAY'),
(99, '02', '01', '05', 'INDEPENDENCIA'),
(100, '02', '01', '06', 'JANGAS'),
(101, '02', '01', '07', 'LA LIBERTAD'),
(102, '02', '01', '08', 'OLLEROS'),
(103, '02', '01', '09', 'PAMPAS'),
(104, '02', '01', '10', 'PARIACOTO'),
(105, '02', '01', '11', 'PIRA'),
(106, '02', '01', '12', 'TARICA'),
(107, '02', '02', '00', 'AIJA'),
(108, '02', '02', '01', 'AIJA'),
(109, '02', '02', '02', 'CORIS'),
(110, '02', '02', '03', 'HUACLLAN'),
(111, '02', '02', '04', 'LA MERCED'),
(112, '02', '02', '05', 'SUCCHA'),
(113, '02', '03', '00', 'ANTONIO RAYMONDI'),
(114, '02', '03', '01', 'LLAMELLIN'),
(115, '02', '03', '02', 'ACZO'),
(116, '02', '03', '03', 'CHACCHO'),
(117, '02', '03', '04', 'CHINGAS'),
(118, '02', '03', '05', 'MIRGAS'),
(119, '02', '03', '06', 'SAN JUAN DE RONTOY'),
(120, '02', '04', '00', 'ASUNCION'),
(121, '02', '04', '01', 'CHACAS'),
(122, '02', '04', '02', 'ACOCHACA'),
(123, '02', '05', '00', 'BOLOGNESI'),
(124, '02', '05', '01', 'CHIQUIAN'),
(125, '02', '05', '02', 'ABELARDO PARDO LEZAMETA'),
(126, '02', '05', '03', 'ANTONIO RAYMONDI'),
(127, '02', '05', '04', 'AQUIA'),
(128, '02', '05', '05', 'CAJACAY'),
(129, '02', '05', '06', 'CANIS'),
(130, '02', '05', '07', 'COLQUIOC'),
(131, '02', '05', '08', 'HUALLANCA'),
(132, '02', '05', '09', 'HUASTA'),
(133, '02', '05', '10', 'HUAYLLACAYAN'),
(134, '02', '05', '11', 'LA PRIMAVERA'),
(135, '02', '05', '12', 'MANGAS'),
(136, '02', '05', '13', 'PACLLON'),
(137, '02', '05', '14', 'SAN MIGUEL DE CORPANQUI'),
(138, '02', '05', '15', 'TICLLOS'),
(139, '02', '06', '00', 'CARHUAZ'),
(140, '02', '06', '01', 'CARHUAZ'),
(141, '02', '06', '02', 'ACOPAMPA'),
(142, '02', '06', '03', 'AMASHCA'),
(143, '02', '06', '04', 'ANTA'),
(144, '02', '06', '05', 'ATAQUERO'),
(145, '02', '06', '06', 'MARCARA'),
(146, '02', '06', '07', 'PARIAHUANCA'),
(147, '02', '06', '08', 'SAN MIGUEL DE ACO'),
(148, '02', '06', '09', 'SHILLA'),
(149, '02', '06', '10', 'TINCO'),
(150, '02', '06', '11', 'YUNGAR'),
(151, '02', '07', '00', 'CARLOS FERMIN FITZCARRALD'),
(152, '02', '07', '01', 'SAN LUIS'),
(153, '02', '07', '02', 'SAN NICOLAS'),
(154, '02', '07', '03', 'YAUYA'),
(155, '02', '08', '00', 'CASMA'),
(156, '02', '08', '01', 'CASMA'),
(157, '02', '08', '02', 'BUENA VISTA ALTA'),
(158, '02', '08', '03', 'COMANDANTE NOEL'),
(159, '02', '08', '04', 'YAUTAN'),
(160, '02', '09', '00', 'CORONGO'),
(161, '02', '09', '01', 'CORONGO'),
(162, '02', '09', '02', 'ACO'),
(163, '02', '09', '03', 'BAMBAS'),
(164, '02', '09', '04', 'CUSCA'),
(165, '02', '09', '05', 'LA PAMPA'),
(166, '02', '09', '06', 'YANAC'),
(167, '02', '09', '07', 'YUPAN'),
(168, '02', '10', '00', 'HUARI'),
(169, '02', '10', '01', 'HUARI'),
(170, '02', '10', '02', 'ANRA'),
(171, '02', '10', '03', 'CAJAY'),
(172, '02', '10', '04', 'CHAVIN DE HUANTAR'),
(173, '02', '10', '05', 'HUACACHI'),
(174, '02', '10', '06', 'HUACCHIS'),
(175, '02', '10', '07', 'HUACHIS'),
(176, '02', '10', '08', 'HUANTAR'),
(177, '02', '10', '09', 'MASIN'),
(178, '02', '10', '10', 'PAUCAS'),
(179, '02', '10', '11', 'PONTO'),
(180, '02', '10', '12', 'RAHUAPAMPA'),
(181, '02', '10', '13', 'RAPAYAN'),
(182, '02', '10', '14', 'SAN MARCOS'),
(183, '02', '10', '15', 'SAN PEDRO DE CHANA'),
(184, '02', '10', '16', 'UCO'),
(185, '02', '11', '00', 'HUARMEY'),
(186, '02', '11', '01', 'HUARMEY'),
(187, '02', '11', '02', 'COCHAPETI'),
(188, '02', '11', '03', 'CULEBRAS'),
(189, '02', '11', '04', 'HUAYAN'),
(190, '02', '11', '05', 'MALVAS'),
(191, '02', '12', '00', 'HUAYLAS'),
(192, '02', '12', '01', 'CARAZ'),
(193, '02', '12', '02', 'HUALLANCA'),
(194, '02', '12', '03', 'HUATA'),
(195, '02', '12', '04', 'HUAYLAS'),
(196, '02', '12', '05', 'MATO'),
(197, '02', '12', '06', 'PAMPAROMAS'),
(198, '02', '12', '07', 'PUEBLO LIBRE'),
(199, '02', '12', '08', 'SANTA CRUZ'),
(200, '02', '12', '09', 'SANTO TORIBIO'),
(201, '02', '12', '10', 'YURACMARCA'),
(202, '02', '13', '00', 'MARISCAL LUZURIAGA'),
(203, '02', '13', '01', 'PISCOBAMBA'),
(204, '02', '13', '02', 'CASCA'),
(205, '02', '13', '03', 'ELEAZAR GUZMAN BARRON'),
(206, '02', '13', '04', 'FIDEL OLIVAS ESCUDERO'),
(207, '02', '13', '05', 'LLAMA'),
(208, '02', '13', '06', 'LLUMPA'),
(209, '02', '13', '07', 'LUCMA'),
(210, '02', '13', '08', 'MUSGA'),
(211, '02', '14', '00', 'OCROS'),
(212, '02', '14', '01', 'OCROS'),
(213, '02', '14', '02', 'ACAS'),
(214, '02', '14', '03', 'CAJAMARQUILLA'),
(215, '02', '14', '04', 'CARHUAPAMPA'),
(216, '02', '14', '05', 'COCHAS'),
(217, '02', '14', '06', 'CONGAS'),
(218, '02', '14', '07', 'LLIPA'),
(219, '02', '14', '08', 'SAN CRISTOBAL DE RAJAN'),
(220, '02', '14', '09', 'SAN PEDRO'),
(221, '02', '14', '10', 'SANTIAGO DE CHILCAS'),
(222, '02', '15', '00', 'PALLASCA'),
(223, '02', '15', '01', 'CABANA'),
(224, '02', '15', '02', 'BOLOGNESI'),
(225, '02', '15', '03', 'CONCHUCOS'),
(226, '02', '15', '04', 'HUACASCHUQUE'),
(227, '02', '15', '05', 'HUANDOVAL'),
(228, '02', '15', '06', 'LACABAMBA'),
(229, '02', '15', '07', 'LLAPO'),
(230, '02', '15', '08', 'PALLASCA'),
(231, '02', '15', '09', 'PAMPAS'),
(232, '02', '15', '10', 'SANTA ROSA'),
(233, '02', '15', '11', 'TAUCA'),
(234, '02', '16', '00', 'POMABAMBA'),
(235, '02', '16', '01', 'POMABAMBA'),
(236, '02', '16', '02', 'HUAYLLAN'),
(237, '02', '16', '03', 'PAROBAMBA'),
(238, '02', '16', '04', 'QUINUABAMBA'),
(239, '02', '17', '00', 'RECUAY'),
(240, '02', '17', '01', 'RECUAY'),
(241, '02', '17', '02', 'CATAC'),
(242, '02', '17', '03', 'COTAPARACO'),
(243, '02', '17', '04', 'HUAYLLAPAMPA'),
(244, '02', '17', '05', 'LLACLLIN'),
(245, '02', '17', '06', 'MARCA'),
(246, '02', '17', '07', 'PAMPAS CHICO'),
(247, '02', '17', '08', 'PARARIN'),
(248, '02', '17', '09', 'TAPACOCHA'),
(249, '02', '17', '10', 'TICAPAMPA'),
(250, '02', '18', '00', 'SANTA'),
(251, '02', '18', '01', 'CHIMBOTE'),
(252, '02', '18', '02', 'CACERES DEL PERU'),
(253, '02', '18', '03', 'COISHCO'),
(254, '02', '18', '04', 'MACATE'),
(255, '02', '18', '05', 'MORO'),
(256, '02', '18', '06', 'NEPEÑA'),
(257, '02', '18', '07', 'SAMANCO'),
(258, '02', '18', '08', 'SANTA'),
(259, '02', '18', '09', 'NUEVO CHIMBOTE'),
(260, '02', '19', '00', 'SIHUAS'),
(261, '02', '19', '01', 'SIHUAS'),
(262, '02', '19', '02', 'ACOBAMBA'),
(263, '02', '19', '03', 'ALFONSO UGARTE'),
(264, '02', '19', '04', 'CASHAPAMPA'),
(265, '02', '19', '05', 'CHINGALPO'),
(266, '02', '19', '06', 'HUAYLLABAMBA'),
(267, '02', '19', '07', 'QUICHES'),
(268, '02', '19', '08', 'RAGASH'),
(269, '02', '19', '09', 'SAN JUAN'),
(270, '02', '19', '10', 'SICSIBAMBA'),
(271, '02', '20', '00', 'YUNGAY'),
(272, '02', '20', '01', 'YUNGAY'),
(273, '02', '20', '02', 'CASCAPARA'),
(274, '02', '20', '03', 'MANCOS'),
(275, '02', '20', '04', 'MATACOTO'),
(276, '02', '20', '05', 'QUILLO'),
(277, '02', '20', '06', 'RANRAHIRCA'),
(278, '02', '20', '07', 'SHUPLUY'),
(279, '02', '20', '08', 'YANAMA'),
(280, '03', '00', '00', 'APURIMAC'),
(281, '03', '01', '00', 'ABANCAY'),
(282, '03', '01', '01', 'ABANCAY'),
(283, '03', '01', '02', 'CHACOCHE'),
(284, '03', '01', '03', 'CIRCA'),
(285, '03', '01', '04', 'CURAHUASI'),
(286, '03', '01', '05', 'HUANIPACA'),
(287, '03', '01', '06', 'LAMBRAMA'),
(288, '03', '01', '07', 'PICHIRHUA'),
(289, '03', '01', '08', 'SAN PEDRO DE CACHORA'),
(290, '03', '01', '09', 'TAMBURCO'),
(291, '03', '02', '00', 'ANDAHUAYLAS'),
(292, '03', '02', '01', 'ANDAHUAYLAS'),
(293, '03', '02', '02', 'ANDARAPA'),
(294, '03', '02', '03', 'CHIARA'),
(295, '03', '02', '04', 'HUANCARAMA'),
(296, '03', '02', '05', 'HUANCARAY'),
(297, '03', '02', '06', 'HUAYANA'),
(298, '03', '02', '07', 'KISHUARA'),
(299, '03', '02', '08', 'PACOBAMBA'),
(300, '03', '02', '09', 'PACUCHA'),
(301, '03', '02', '10', 'PAMPACHIRI'),
(302, '03', '02', '11', 'POMACOCHA'),
(303, '03', '02', '12', 'SAN ANTONIO DE CACHI'),
(304, '03', '02', '13', 'SAN JERONIMO'),
(305, '03', '02', '14', 'SAN MIGUEL DE CHACCRAMPA'),
(306, '03', '02', '15', 'SANTA MARIA DE CHICMO'),
(307, '03', '02', '16', 'TALAVERA'),
(308, '03', '02', '17', 'TUMAY HUARACA'),
(309, '03', '02', '18', 'TURPO'),
(310, '03', '02', '19', 'KAQUIABAMBA'),
(311, '03', '03', '00', 'ANTABAMBA'),
(312, '03', '03', '01', 'ANTABAMBA'),
(313, '03', '03', '02', 'EL ORO'),
(314, '03', '03', '03', 'HUAQUIRCA'),
(315, '03', '03', '04', 'JUAN ESPINOZA MEDRANO'),
(316, '03', '03', '05', 'OROPESA'),
(317, '03', '03', '06', 'PACHACONAS'),
(318, '03', '03', '07', 'SABAINO'),
(319, '03', '04', '00', 'AYMARAES'),
(320, '03', '04', '01', 'CHALHUANCA'),
(321, '03', '04', '02', 'CAPAYA'),
(322, '03', '04', '03', 'CARAYBAMBA'),
(323, '03', '04', '04', 'CHAPIMARCA'),
(324, '03', '04', '05', 'COLCABAMBA'),
(325, '03', '04', '06', 'COTARUSE'),
(326, '03', '04', '07', 'HUAYLLO'),
(327, '03', '04', '08', 'JUSTO APU SAHUARAURA'),
(328, '03', '04', '09', 'LUCRE'),
(329, '03', '04', '10', 'POCOHUANCA'),
(330, '03', '04', '11', 'SAN JUAN DE CHACÑA'),
(331, '03', '04', '12', 'SAÑAYCA'),
(332, '03', '04', '13', 'SORAYA'),
(333, '03', '04', '14', 'TAPAIRIHUA'),
(334, '03', '04', '15', 'TINTAY'),
(335, '03', '04', '16', 'TORAYA'),
(336, '03', '04', '17', 'YANACA'),
(337, '03', '05', '00', 'COTABAMBAS'),
(338, '03', '05', '01', 'TAMBOBAMBA'),
(339, '03', '05', '02', 'COTABAMBAS'),
(340, '03', '05', '03', 'COYLLURQUI'),
(341, '03', '05', '04', 'HAQUIRA'),
(342, '03', '05', '05', 'MARA'),
(343, '03', '05', '06', 'CHALLHUAHUACHO'),
(344, '03', '06', '00', 'CHINCHEROS'),
(345, '03', '06', '01', 'CHINCHEROS'),
(346, '03', '06', '02', 'ANCO-HUALLO'),
(347, '03', '06', '03', 'COCHARCAS'),
(348, '03', '06', '04', 'HUACCANA'),
(349, '03', '06', '05', 'OCOBAMBA'),
(350, '03', '06', '06', 'ONGOY'),
(351, '03', '06', '07', 'URANMARCA'),
(352, '03', '06', '08', 'RANRACANCHA'),
(353, '03', '07', '00', 'GRAU'),
(354, '03', '07', '01', 'CHUQUIBAMBILLA'),
(355, '03', '07', '02', 'CURPAHUASI'),
(356, '03', '07', '03', 'GAMARRA'),
(357, '03', '07', '04', 'HUAYLLATI'),
(358, '03', '07', '05', 'MAMARA'),
(359, '03', '07', '06', 'MICAELA BASTIDAS'),
(360, '03', '07', '07', 'PATAYPAMPA'),
(361, '03', '07', '08', 'PROGRESO'),
(362, '03', '07', '09', 'SAN ANTONIO'),
(363, '03', '07', '10', 'SANTA ROSA'),
(364, '03', '07', '11', 'TURPAY'),
(365, '03', '07', '12', 'VILCABAMBA'),
(366, '03', '07', '13', 'VIRUNDO'),
(367, '03', '07', '14', 'CURASCO'),
(368, '04', '00', '00', 'AREQUIPA'),
(369, '04', '01', '00', 'AREQUIPA'),
(370, '04', '01', '01', 'AREQUIPA'),
(371, '04', '01', '02', 'ALTO SELVA ALEGRE'),
(372, '04', '01', '03', 'CAYMA'),
(373, '04', '01', '04', 'CERRO COLORADO'),
(374, '04', '01', '05', 'CHARACATO'),
(375, '04', '01', '06', 'CHIGUATA'),
(376, '04', '01', '07', 'JACOBO HUNTER'),
(377, '04', '01', '08', 'LA JOYA'),
(378, '04', '01', '09', 'MARIANO MELGAR'),
(379, '04', '01', '10', 'MIRAFLORES'),
(380, '04', '01', '11', 'MOLLEBAYA'),
(381, '04', '01', '12', 'PAUCARPATA'),
(382, '04', '01', '13', 'POCSI'),
(383, '04', '01', '14', 'POLOBAYA'),
(384, '04', '01', '15', 'QUEQUEÑA'),
(385, '04', '01', '16', 'SABANDIA'),
(386, '04', '01', '17', 'SACHACA'),
(387, '04', '01', '18', 'SAN JUAN DE SIGUAS'),
(388, '04', '01', '19', 'SAN JUAN DE TARUCANI'),
(389, '04', '01', '20', 'SANTA ISABEL DE SIGUAS'),
(390, '04', '01', '21', 'SANTA RITA DE SIGUAS'),
(391, '04', '01', '22', 'SOCABAYA'),
(392, '04', '01', '23', 'TIABAYA'),
(393, '04', '01', '24', 'UCHUMAYO'),
(394, '04', '01', '25', 'VITOR'),
(395, '04', '01', '26', 'YANAHUARA'),
(396, '04', '01', '27', 'YARABAMBA'),
(397, '04', '01', '28', 'YURA'),
(398, '04', '01', '29', 'JOSE LUIS BUSTAMANTE Y RIVERO'),
(399, '04', '02', '00', 'CAMANA'),
(400, '04', '02', '01', 'CAMANA'),
(401, '04', '02', '02', 'JOSE MARIA QUIMPER'),
(402, '04', '02', '03', 'MARIANO NICOLAS VALCARCEL'),
(403, '04', '02', '04', 'MARISCAL CACERES'),
(404, '04', '02', '05', 'NICOLAS DE PIEROLA'),
(405, '04', '02', '06', 'OCOÑA'),
(406, '04', '02', '07', 'QUILCA'),
(407, '04', '02', '08', 'SAMUEL PASTOR'),
(408, '04', '03', '00', 'CARAVELI'),
(409, '04', '03', '01', 'CARAVELI'),
(410, '04', '03', '02', 'ACARI'),
(411, '04', '03', '03', 'ATICO'),
(412, '04', '03', '04', 'ATIQUIPA'),
(413, '04', '03', '05', 'BELLA UNION'),
(414, '04', '03', '06', 'CAHUACHO'),
(415, '04', '03', '07', 'CHALA'),
(416, '04', '03', '08', 'CHAPARRA'),
(417, '04', '03', '09', 'HUANUHUANU'),
(418, '04', '03', '10', 'JAQUI'),
(419, '04', '03', '11', 'LOMAS'),
(420, '04', '03', '12', 'QUICACHA'),
(421, '04', '03', '13', 'YAUCA'),
(422, '04', '04', '00', 'CASTILLA'),
(423, '04', '04', '01', 'APLAO'),
(424, '04', '04', '02', 'ANDAGUA'),
(425, '04', '04', '03', 'AYO'),
(426, '04', '04', '04', 'CHACHAS'),
(427, '04', '04', '05', 'CHILCAYMARCA'),
(428, '04', '04', '06', 'CHOCO'),
(429, '04', '04', '07', 'HUANCARQUI'),
(430, '04', '04', '08', 'MACHAGUAY'),
(431, '04', '04', '09', 'ORCOPAMPA'),
(432, '04', '04', '10', 'PAMPACOLCA'),
(433, '04', '04', '11', 'TIPAN'),
(434, '04', '04', '12', 'UÑON'),
(435, '04', '04', '13', 'URACA'),
(436, '04', '04', '14', 'VIRACO'),
(437, '04', '05', '00', 'CAYLLOMA'),
(438, '04', '05', '01', 'CHIVAY'),
(439, '04', '05', '02', 'ACHOMA'),
(440, '04', '05', '03', 'CABANACONDE'),
(441, '04', '05', '04', 'CALLALLI'),
(442, '04', '05', '05', 'CAYLLOMA'),
(443, '04', '05', '06', 'COPORAQUE'),
(444, '04', '05', '07', 'HUAMBO'),
(445, '04', '05', '08', 'HUANCA'),
(446, '04', '05', '09', 'ICHUPAMPA'),
(447, '04', '05', '10', 'LARI'),
(448, '04', '05', '11', 'LLUTA'),
(449, '04', '05', '12', 'MACA'),
(450, '04', '05', '13', 'MADRIGAL'),
(451, '04', '05', '14', 'SAN ANTONIO DE CHUCA'),
(452, '04', '05', '15', 'SIBAYO'),
(453, '04', '05', '16', 'TAPAY'),
(454, '04', '05', '17', 'TISCO'),
(455, '04', '05', '18', 'TUTI'),
(456, '04', '05', '19', 'YANQUE'),
(457, '04', '05', '20', 'MAJES'),
(458, '04', '06', '00', 'CONDESUYOS'),
(459, '04', '06', '01', 'CHUQUIBAMBA'),
(460, '04', '06', '02', 'ANDARAY'),
(461, '04', '06', '03', 'CAYARANI'),
(462, '04', '06', '04', 'CHICHAS'),
(463, '04', '06', '05', 'IRAY'),
(464, '04', '06', '06', 'RIO GRANDE'),
(465, '04', '06', '07', 'SALAMANCA'),
(466, '04', '06', '08', 'YANAQUIHUA'),
(467, '04', '07', '00', 'ISLAY'),
(468, '04', '07', '01', 'MOLLENDO'),
(469, '04', '07', '02', 'COCACHACRA'),
(470, '04', '07', '03', 'DEAN VALDIVIA'),
(471, '04', '07', '04', 'ISLAY'),
(472, '04', '07', '05', 'MEJIA'),
(473, '04', '07', '06', 'PUNTA DE BOMBON'),
(474, '04', '08', '00', 'LA UNION'),
(475, '04', '08', '01', 'COTAHUASI'),
(476, '04', '08', '02', 'ALCA'),
(477, '04', '08', '03', 'CHARCANA'),
(478, '04', '08', '04', 'HUAYNACOTAS'),
(479, '04', '08', '05', 'PAMPAMARCA'),
(480, '04', '08', '06', 'PUYCA'),
(481, '04', '08', '07', 'QUECHUALLA'),
(482, '04', '08', '08', 'SAYLA'),
(483, '04', '08', '09', 'TAURIA'),
(484, '04', '08', '10', 'TOMEPAMPA'),
(485, '04', '08', '11', 'TORO'),
(486, '05', '00', '00', 'AYACUCHO'),
(487, '05', '01', '00', 'HUAMANGA'),
(488, '05', '01', '01', 'AYACUCHO'),
(489, '05', '01', '02', 'ACOCRO'),
(490, '05', '01', '03', 'ACOS VINCHOS'),
(491, '05', '01', '04', 'CARMEN ALTO'),
(492, '05', '01', '05', 'CHIARA'),
(493, '05', '01', '06', 'OCROS'),
(494, '05', '01', '07', 'PACAYCASA'),
(495, '05', '01', '08', 'QUINUA'),
(496, '05', '01', '09', 'SAN JOSE DE TICLLAS'),
(497, '05', '01', '10', 'SAN JUAN BAUTISTA'),
(498, '05', '01', '11', 'SANTIAGO DE PISCHA'),
(499, '05', '01', '12', 'SOCOS'),
(500, '05', '01', '13', 'TAMBILLO'),
(501, '05', '01', '14', 'VINCHOS'),
(502, '05', '01', '15', 'JESÚS NAZARENO'),
(503, '05', '01', '16', 'ANDRÉS AVELINO CÁCERES DORREGAY'),
(504, '05', '02', '00', 'CANGALLO'),
(505, '05', '02', '01', 'CANGALLO'),
(506, '05', '02', '02', 'CHUSCHI'),
(507, '05', '02', '03', 'LOS MOROCHUCOS'),
(508, '05', '02', '04', 'MARIA PARADO DE BELLIDO'),
(509, '05', '02', '05', 'PARAS'),
(510, '05', '02', '06', 'TOTOS'),
(511, '05', '03', '00', 'HUANCA SANCOS'),
(512, '05', '03', '01', 'SANCOS'),
(513, '05', '03', '02', 'CARAPO'),
(514, '05', '03', '03', 'SACSAMARCA'),
(515, '05', '03', '04', 'SANTIAGO DE LUCANAMARCA'),
(516, '05', '04', '00', 'HUANTA'),
(517, '05', '04', '01', 'HUANTA'),
(518, '05', '04', '02', 'AYAHUANCO'),
(519, '05', '04', '03', 'HUAMANGUILLA'),
(520, '05', '04', '04', 'IGUAIN'),
(521, '05', '04', '05', 'LURICOCHA'),
(522, '05', '04', '06', 'SANTILLANA'),
(523, '05', '04', '07', 'SIVIA'),
(524, '05', '04', '08', 'LLOCHEGUA'),
(525, '05', '04', '09', 'CANAYRE'),
(526, '05', '04', '10', 'UCHURACCAY'),
(527, '05', '04', '11', 'PUCACOLPA'),
(528, '05', '05', '00', 'LA MAR'),
(529, '05', '05', '01', 'SAN MIGUEL'),
(530, '05', '05', '02', 'ANCO'),
(531, '05', '05', '03', 'AYNA'),
(532, '05', '05', '04', 'CHILCAS'),
(533, '05', '05', '05', 'CHUNGUI'),
(534, '05', '05', '06', 'LUIS CARRANZA'),
(535, '05', '05', '07', 'SANTA ROSA'),
(536, '05', '05', '08', 'TAMBO'),
(537, '05', '05', '09', 'SAMUGARI'),
(538, '05', '05', '10', 'ANCHIHUAY'),
(539, '05', '06', '00', 'LUCANAS'),
(540, '05', '06', '01', 'PUQUIO'),
(541, '05', '06', '02', 'AUCARA'),
(542, '05', '06', '03', 'CABANA'),
(543, '05', '06', '04', 'CARMEN SALCEDO'),
(544, '05', '06', '05', 'CHAVIÑA'),
(545, '05', '06', '06', 'CHIPAO'),
(546, '05', '06', '07', 'HUAC-HUAS'),
(547, '05', '06', '08', 'LARAMATE'),
(548, '05', '06', '09', 'LEONCIO PRADO'),
(549, '05', '06', '10', 'LLAUTA'),
(550, '05', '06', '11', 'LUCANAS'),
(551, '05', '06', '12', 'OCAÑA'),
(552, '05', '06', '13', 'OTOCA'),
(553, '05', '06', '14', 'SAISA'),
(554, '05', '06', '15', 'SAN CRISTOBAL'),
(555, '05', '06', '16', 'SAN JUAN'),
(556, '05', '06', '17', 'SAN PEDRO'),
(557, '05', '06', '18', 'SAN PEDRO DE PALCO'),
(558, '05', '06', '19', 'SANCOS'),
(559, '05', '06', '20', 'SANTA ANA DE HUAYCAHUACHO'),
(560, '05', '06', '21', 'SANTA LUCIA'),
(561, '05', '07', '00', 'PARINACOCHAS'),
(562, '05', '07', '01', 'CORACORA'),
(563, '05', '07', '02', 'CHUMPI'),
(564, '05', '07', '03', 'CORONEL CASTAÑEDA'),
(565, '05', '07', '04', 'PACAPAUSA'),
(566, '05', '07', '05', 'PULLO'),
(567, '05', '07', '06', 'PUYUSCA'),
(568, '05', '07', '07', 'SAN FRANCISCO DE RAVACAYCO'),
(569, '05', '07', '08', 'UPAHUACHO'),
(570, '05', '08', '00', 'PAUCAR DEL SARA SARA'),
(571, '05', '08', '01', 'PAUSA'),
(572, '05', '08', '02', 'COLTA'),
(573, '05', '08', '03', 'CORCULLA'),
(574, '05', '08', '04', 'LAMPA'),
(575, '05', '08', '05', 'MARCABAMBA'),
(576, '05', '08', '06', 'OYOLO'),
(577, '05', '08', '07', 'PARARCA'),
(578, '05', '08', '08', 'SAN JAVIER DE ALPABAMBA'),
(579, '05', '08', '09', 'SAN JOSE DE USHUA'),
(580, '05', '08', '10', 'SARA SARA'),
(581, '05', '09', '00', 'SUCRE'),
(582, '05', '09', '01', 'QUEROBAMBA'),
(583, '05', '09', '02', 'BELEN'),
(584, '05', '09', '03', 'CHALCOS'),
(585, '05', '09', '04', 'CHILCAYOC'),
(586, '05', '09', '05', 'HUACAÑA'),
(587, '05', '09', '06', 'MORCOLLA'),
(588, '05', '09', '07', 'PAICO'),
(589, '05', '09', '08', 'SAN PEDRO DE LARCAY'),
(590, '05', '09', '09', 'SAN SALVADOR DE QUIJE'),
(591, '05', '09', '10', 'SANTIAGO DE PAUCARAY'),
(592, '05', '09', '11', 'SORAS'),
(593, '05', '10', '00', 'VICTOR FAJARDO'),
(594, '05', '10', '01', 'HUANCAPI'),
(595, '05', '10', '02', 'ALCAMENCA'),
(596, '05', '10', '03', 'APONGO'),
(597, '05', '10', '04', 'ASQUIPATA'),
(598, '05', '10', '05', 'CANARIA'),
(599, '05', '10', '06', 'CAYARA'),
(600, '05', '10', '07', 'COLCA'),
(601, '05', '10', '08', 'HUAMANQUIQUIA'),
(602, '05', '10', '09', 'HUANCARAYLLA'),
(603, '05', '10', '10', 'HUAYA'),
(604, '05', '10', '11', 'SARHUA'),
(605, '05', '10', '12', 'VILCANCHOS'),
(606, '05', '11', '00', 'VILCAS HUAMAN'),
(607, '05', '11', '01', 'VILCAS HUAMAN'),
(608, '05', '11', '02', 'ACCOMARCA'),
(609, '05', '11', '03', 'CARHUANCA'),
(610, '05', '11', '04', 'CONCEPCION'),
(611, '05', '11', '05', 'HUAMBALPA'),
(612, '05', '11', '06', 'INDEPENDENCIA'),
(613, '05', '11', '07', 'SAURAMA'),
(614, '05', '11', '08', 'VISCHONGO'),
(615, '06', '00', '00', 'CAJAMARCA'),
(616, '06', '01', '00', 'CAJAMARCA'),
(617, '06', '01', '01', 'CAJAMARCA'),
(618, '06', '01', '02', 'ASUNCION'),
(619, '06', '01', '03', 'CHETILLA'),
(620, '06', '01', '04', 'COSPAN'),
(621, '06', '01', '05', 'ENCAÑADA'),
(622, '06', '01', '06', 'JESUS'),
(623, '06', '01', '07', 'LLACANORA'),
(624, '06', '01', '08', 'LOS BAÑOS DEL INCA'),
(625, '06', '01', '09', 'MAGDALENA'),
(626, '06', '01', '10', 'MATARA'),
(627, '06', '01', '11', 'NAMORA'),
(628, '06', '01', '12', 'SAN JUAN'),
(629, '06', '02', '00', 'CAJABAMBA'),
(630, '06', '02', '01', 'CAJABAMBA'),
(631, '06', '02', '02', 'CACHACHI'),
(632, '06', '02', '03', 'CONDEBAMBA'),
(633, '06', '02', '04', 'SITACOCHA'),
(634, '06', '03', '00', 'CELENDIN'),
(635, '06', '03', '01', 'CELENDIN'),
(636, '06', '03', '02', 'CHUMUCH'),
(637, '06', '03', '03', 'CORTEGANA'),
(638, '06', '03', '04', 'HUASMIN'),
(639, '06', '03', '05', 'JORGE CHAVEZ'),
(640, '06', '03', '06', 'JOSE GALVEZ'),
(641, '06', '03', '07', 'MIGUEL IGLESIAS'),
(642, '06', '03', '08', 'OXAMARCA'),
(643, '06', '03', '09', 'SOROCHUCO'),
(644, '06', '03', '10', 'SUCRE'),
(645, '06', '03', '11', 'UTCO'),
(646, '06', '03', '12', 'LA LIBERTAD DE PALLAN'),
(647, '06', '04', '00', 'CHOTA'),
(648, '06', '04', '01', 'CHOTA'),
(649, '06', '04', '02', 'ANGUIA'),
(650, '06', '04', '03', 'CHADIN'),
(651, '06', '04', '04', 'CHIGUIRIP'),
(652, '06', '04', '05', 'CHIMBAN'),
(653, '06', '04', '06', 'CHOROPAMPA'),
(654, '06', '04', '07', 'COCHABAMBA'),
(655, '06', '04', '08', 'CONCHAN'),
(656, '06', '04', '09', 'HUAMBOS'),
(657, '06', '04', '10', 'LAJAS'),
(658, '06', '04', '11', 'LLAMA'),
(659, '06', '04', '12', 'MIRACOSTA'),
(660, '06', '04', '13', 'PACCHA'),
(661, '06', '04', '14', 'PION'),
(662, '06', '04', '15', 'QUEROCOTO'),
(663, '06', '04', '16', 'SAN JUAN DE LICUPIS'),
(664, '06', '04', '17', 'TACABAMBA'),
(665, '06', '04', '18', 'TOCMOCHE'),
(666, '06', '04', '19', 'CHALAMARCA'),
(667, '06', '05', '00', 'CONTUMAZA'),
(668, '06', '05', '01', 'CONTUMAZA'),
(669, '06', '05', '02', 'CHILETE'),
(670, '06', '05', '03', 'CUPISNIQUE'),
(671, '06', '05', '04', 'GUZMANGO'),
(672, '06', '05', '05', 'SAN BENITO'),
(673, '06', '05', '06', 'SANTA CRUZ DE TOLED'),
(674, '06', '05', '07', 'TANTARICA'),
(675, '06', '05', '08', 'YONAN'),
(676, '06', '06', '00', 'CUTERVO'),
(677, '06', '06', '01', 'CUTERVO'),
(678, '06', '06', '02', 'CALLAYUC'),
(679, '06', '06', '03', 'CHOROS'),
(680, '06', '06', '04', 'CUJILLO'),
(681, '06', '06', '05', 'LA RAMADA'),
(682, '06', '06', '06', 'PIMPINGOS'),
(683, '06', '06', '07', 'QUEROCOTILLO'),
(684, '06', '06', '08', 'SAN ANDRES DE CUTERVO'),
(685, '06', '06', '09', 'SAN JUAN DE CUTERVO'),
(686, '06', '06', '10', 'SAN LUIS DE LUCMA'),
(687, '06', '06', '11', 'SANTA CRUZ'),
(688, '06', '06', '12', 'SANTO DOMINGO DE LA CAPILLA'),
(689, '06', '06', '13', 'SANTO TOMAS'),
(690, '06', '06', '14', 'SOCOTA'),
(691, '06', '06', '15', 'TORIBIO CASANOVA'),
(692, '06', '07', '00', 'HUALGAYOC'),
(693, '06', '07', '01', 'BAMBAMARCA'),
(694, '06', '07', '02', 'CHUGUR'),
(695, '06', '07', '03', 'HUALGAYOC'),
(696, '06', '08', '00', 'JAEN'),
(697, '06', '08', '01', 'JAEN'),
(698, '06', '08', '02', 'BELLAVISTA'),
(699, '06', '08', '03', 'CHONTALI'),
(700, '06', '08', '04', 'COLASAY'),
(701, '06', '08', '05', 'HUABAL'),
(702, '06', '08', '06', 'LAS PIRIAS'),
(703, '06', '08', '07', 'POMAHUACA'),
(704, '06', '08', '08', 'PUCARA'),
(705, '06', '08', '09', 'SALLIQUE'),
(706, '06', '08', '10', 'SAN FELIPE'),
(707, '06', '08', '11', 'SAN JOSE DEL ALTO'),
(708, '06', '08', '12', 'SANTA ROSA'),
(709, '06', '09', '00', 'SAN IGNACIO'),
(710, '06', '09', '01', 'SAN IGNACIO'),
(711, '06', '09', '02', 'CHIRINOS'),
(712, '06', '09', '03', 'HUARANGO'),
(713, '06', '09', '04', 'LA COIPA'),
(714, '06', '09', '05', 'NAMBALLE'),
(715, '06', '09', '06', 'SAN JOSE DE LOURDES'),
(716, '06', '09', '07', 'TABACONAS'),
(717, '06', '10', '00', 'SAN MARCOS'),
(718, '06', '10', '01', 'PEDRO GALVEZ'),
(719, '06', '10', '02', 'CHANCAY'),
(720, '06', '10', '03', 'EDUARDO VILLANUEVA'),
(721, '06', '10', '04', 'GREGORIO PITA'),
(722, '06', '10', '05', 'ICHOCAN'),
(723, '06', '10', '06', 'JOSE MANUEL QUIROZ'),
(724, '06', '10', '07', 'JOSE SABOGAL'),
(725, '06', '11', '00', 'SAN MIGUEL'),
(726, '06', '11', '01', 'SAN MIGUEL'),
(727, '06', '11', '02', 'BOLIVAR'),
(728, '06', '11', '03', 'CALQUIS'),
(729, '06', '11', '04', 'CATILLUC'),
(730, '06', '11', '05', 'EL PRADO'),
(731, '06', '11', '06', 'LA FLORIDA'),
(732, '06', '11', '07', 'LLAPA'),
(733, '06', '11', '08', 'NANCHOC'),
(734, '06', '11', '09', 'NIEPOS'),
(735, '06', '11', '10', 'SAN GREGORIO'),
(736, '06', '11', '11', 'SAN SILVESTRE DE COCHAN'),
(737, '06', '11', '12', 'TONGOD'),
(738, '06', '11', '13', 'UNION AGUA BLANCA'),
(739, '06', '12', '00', 'SAN PABLO'),
(740, '06', '12', '01', 'SAN PABLO'),
(741, '06', '12', '02', 'SAN BERNARDINO'),
(742, '06', '12', '03', 'SAN LUIS'),
(743, '06', '12', '04', 'TUMBADEN'),
(744, '06', '13', '00', 'SANTA CRUZ'),
(745, '06', '13', '01', 'SANTA CRUZ'),
(746, '06', '13', '02', 'ANDABAMBA'),
(747, '06', '13', '03', 'CATACHE'),
(748, '06', '13', '04', 'CHANCAYBAÑOS'),
(749, '06', '13', '05', 'LA ESPERANZA'),
(750, '06', '13', '06', 'NINABAMBA'),
(751, '06', '13', '07', 'PULAN'),
(752, '06', '13', '08', 'SAUCEPAMPA'),
(753, '06', '13', '09', 'SEXI'),
(754, '06', '13', '10', 'UTICYACU'),
(755, '06', '13', '11', 'YAUYUCAN'),
(756, '07', '00', '00', 'CALLAO'),
(757, '07', '01', '00', 'PROV. CONST. DEL CALLAO'),
(758, '07', '01', '01', 'CALLAO'),
(759, '07', '01', '02', 'BELLAVISTA'),
(760, '07', '01', '03', 'CARMEN DE LA LEGUA REYNOSO'),
(761, '07', '01', '04', 'LA PERLA'),
(762, '07', '01', '05', 'LA PUNTA'),
(763, '07', '01', '06', 'VENTANILLA'),
(764, '07', '01', '07', 'MI PERÚ'),
(765, '08', '00', '00', 'CUSCO'),
(766, '08', '01', '00', 'CUSCO'),
(767, '08', '01', '01', 'CUSCO'),
(768, '08', '01', '02', 'CCORCA'),
(769, '08', '01', '03', 'POROY'),
(770, '08', '01', '04', 'SAN JERONIMO'),
(771, '08', '01', '05', 'SAN SEBASTIAN'),
(772, '08', '01', '06', 'SANTIAGO'),
(773, '08', '01', '07', 'SAYLLA'),
(774, '08', '01', '08', 'WANCHAQ'),
(775, '08', '02', '00', 'ACOMAYO'),
(776, '08', '02', '01', 'ACOMAYO'),
(777, '08', '02', '02', 'ACOPIA'),
(778, '08', '02', '03', 'ACOS'),
(779, '08', '02', '04', 'MOSOC LLACTA'),
(780, '08', '02', '05', 'POMACANCHI'),
(781, '08', '02', '06', 'RONDOCAN'),
(782, '08', '02', '07', 'SANGARARA'),
(783, '08', '03', '00', 'ANTA'),
(784, '08', '03', '01', 'ANTA'),
(785, '08', '03', '02', 'ANCAHUASI'),
(786, '08', '03', '03', 'CACHIMAYO'),
(787, '08', '03', '04', 'CHINCHAYPUJIO'),
(788, '08', '03', '05', 'HUAROCONDO'),
(789, '08', '03', '06', 'LIMATAMBO'),
(790, '08', '03', '07', 'MOLLEPATA'),
(791, '08', '03', '08', 'PUCYURA'),
(792, '08', '03', '09', 'ZURITE'),
(793, '08', '04', '00', 'CALCA'),
(794, '08', '04', '01', 'CALCA'),
(795, '08', '04', '02', 'COYA'),
(796, '08', '04', '03', 'LAMAY'),
(797, '08', '04', '04', 'LARES'),
(798, '08', '04', '05', 'PISAC'),
(799, '08', '04', '06', 'SAN SALVADOR'),
(800, '08', '04', '07', 'TARAY'),
(801, '08', '04', '08', 'YANATILE'),
(802, '08', '05', '00', 'CANAS'),
(803, '08', '05', '01', 'YANAOCA'),
(804, '08', '05', '02', 'CHECCA'),
(805, '08', '05', '03', 'KUNTURKANKI'),
(806, '08', '05', '04', 'LANGUI'),
(807, '08', '05', '05', 'LAYO'),
(808, '08', '05', '06', 'PAMPAMARCA'),
(809, '08', '05', '07', 'QUEHUE'),
(810, '08', '05', '08', 'TUPAC AMARU'),
(811, '08', '06', '00', 'CANCHIS'),
(812, '08', '06', '01', 'SICUANI'),
(813, '08', '06', '02', 'CHECACUPE'),
(814, '08', '06', '03', 'COMBAPATA'),
(815, '08', '06', '04', 'MARANGANI'),
(816, '08', '06', '05', 'PITUMARCA'),
(817, '08', '06', '06', 'SAN PABLO'),
(818, '08', '06', '07', 'SAN PEDRO'),
(819, '08', '06', '08', 'TINTA'),
(820, '08', '07', '00', 'CHUMBIVILCAS'),
(821, '08', '07', '01', 'SANTO TOMAS'),
(822, '08', '07', '02', 'CAPACMARCA'),
(823, '08', '07', '03', 'CHAMACA'),
(824, '08', '07', '04', 'COLQUEMARCA'),
(825, '08', '07', '05', 'LIVITACA'),
(826, '08', '07', '06', 'LLUSCO'),
(827, '08', '07', '07', 'QUIÑOTA'),
(828, '08', '07', '08', 'VELILLE'),
(829, '08', '08', '00', 'ESPINAR'),
(830, '08', '08', '01', 'ESPINAR'),
(831, '08', '08', '02', 'CONDOROMA'),
(832, '08', '08', '03', 'COPORAQUE'),
(833, '08', '08', '04', 'OCORURO'),
(834, '08', '08', '05', 'PALLPATA'),
(835, '08', '08', '06', 'PICHIGUA'),
(836, '08', '08', '07', 'SUYCKUTAMBO'),
(837, '08', '08', '08', 'ALTO PICHIGUA'),
(838, '08', '09', '00', 'LA CONVENCION'),
(839, '08', '09', '01', 'SANTA ANA'),
(840, '08', '09', '02', 'ECHARATE'),
(841, '08', '09', '03', 'HUAYOPATA'),
(842, '08', '09', '04', 'MARANURA'),
(843, '08', '09', '05', 'OCOBAMBA'),
(844, '08', '09', '06', 'QUELLOUNO'),
(845, '08', '09', '07', 'KIMBIRI'),
(846, '08', '09', '08', 'SANTA TERESA'),
(847, '08', '09', '09', 'VILCABAMBA'),
(848, '08', '09', '10', 'PICHARI'),
(849, '08', '09', '11', 'INKAWASI'),
(850, '08', '09', '12', 'VILLA VIRGEN'),
(851, '08', '10', '00', 'PARURO'),
(852, '08', '10', '01', 'PARURO'),
(853, '08', '10', '02', 'ACCHA'),
(854, '08', '10', '03', 'CCAPI'),
(855, '08', '10', '04', 'COLCHA'),
(856, '08', '10', '05', 'HUANOQUITE'),
(857, '08', '10', '06', 'OMACHA'),
(858, '08', '10', '07', 'PACCARITAMBO'),
(859, '08', '10', '08', 'PILLPINTO'),
(860, '08', '10', '09', 'YAURISQUE'),
(861, '08', '11', '00', 'PAUCARTAMBO'),
(862, '08', '11', '01', 'PAUCARTAMBO'),
(863, '08', '11', '02', 'CAICAY'),
(864, '08', '11', '03', 'CHALLABAMBA'),
(865, '08', '11', '04', 'COLQUEPATA'),
(866, '08', '11', '05', 'HUANCARANI'),
(867, '08', '11', '06', 'KOSÑIPATA'),
(868, '08', '12', '00', 'QUISPICANCHI'),
(869, '08', '12', '01', 'URCOS'),
(870, '08', '12', '02', 'ANDAHUAYLILLAS'),
(871, '08', '12', '03', 'CAMANTI'),
(872, '08', '12', '04', 'CCARHUAYO'),
(873, '08', '12', '05', 'CCATCA'),
(874, '08', '12', '06', 'CUSIPATA'),
(875, '08', '12', '07', 'HUARO'),
(876, '08', '12', '08', 'LUCRE'),
(877, '08', '12', '09', 'MARCAPATA'),
(878, '08', '12', '10', 'OCONGATE'),
(879, '08', '12', '11', 'OROPESA'),
(880, '08', '12', '12', 'QUIQUIJANA'),
(881, '08', '13', '00', 'URUBAMBA'),
(882, '08', '13', '01', 'URUBAMBA'),
(883, '08', '13', '02', 'CHINCHERO'),
(884, '08', '13', '03', 'HUAYLLABAMBA'),
(885, '08', '13', '04', 'MACHUPICCHU'),
(886, '08', '13', '05', 'MARAS'),
(887, '08', '13', '06', 'OLLANTAYTAMBO'),
(888, '08', '13', '07', 'YUCAY'),
(889, '09', '00', '00', 'HUANCAVELICA'),
(890, '09', '01', '00', 'HUANCAVELICA'),
(891, '09', '01', '01', 'HUANCAVELICA'),
(892, '09', '01', '02', 'ACOBAMBILLA'),
(893, '09', '01', '03', 'ACORIA'),
(894, '09', '01', '04', 'CONAYCA'),
(895, '09', '01', '05', 'CUENCA'),
(896, '09', '01', '06', 'HUACHOCOLPA'),
(897, '09', '01', '07', 'HUAYLLAHUARA'),
(898, '09', '01', '08', 'IZCUCHACA'),
(899, '09', '01', '09', 'LARIA'),
(900, '09', '01', '10', 'MANTA'),
(901, '09', '01', '11', 'MARISCAL CACERES'),
(902, '09', '01', '12', 'MOYA'),
(903, '09', '01', '13', 'NUEVO OCCORO'),
(904, '09', '01', '14', 'PALCA'),
(905, '09', '01', '15', 'PILCHACA'),
(906, '09', '01', '16', 'VILCA'),
(907, '09', '01', '17', 'YAULI'),
(908, '09', '01', '18', 'ASCENSIÓN'),
(909, '09', '01', '19', 'HUANDO'),
(910, '09', '02', '00', 'ACOBAMBA'),
(911, '09', '02', '01', 'ACOBAMBA'),
(912, '09', '02', '02', 'ANDABAMBA'),
(913, '09', '02', '03', 'ANTA'),
(914, '09', '02', '04', 'CAJA'),
(915, '09', '02', '05', 'MARCAS'),
(916, '09', '02', '06', 'PAUCARA'),
(917, '09', '02', '07', 'POMACOCHA'),
(918, '09', '02', '08', 'ROSARIO'),
(919, '09', '03', '00', 'ANGARAES'),
(920, '09', '03', '01', 'LIRCAY'),
(921, '09', '03', '02', 'ANCHONGA'),
(922, '09', '03', '03', 'CALLANMARCA'),
(923, '09', '03', '04', 'CCOCHACCASA'),
(924, '09', '03', '05', 'CHINCHO'),
(925, '09', '03', '06', 'CONGALLA'),
(926, '09', '03', '07', 'HUANCA-HUANCA'),
(927, '09', '03', '08', 'HUAYLLAY GRANDE'),
(928, '09', '03', '09', 'JULCAMARCA'),
(929, '09', '03', '10', 'SAN ANTONIO DE ANTAPARCO'),
(930, '09', '03', '11', 'SANTO TOMAS DE PATA'),
(931, '09', '03', '12', 'SECCLLA'),
(932, '09', '04', '00', 'CASTROVIRREYNA'),
(933, '09', '04', '01', 'CASTROVIRREYNA'),
(934, '09', '04', '02', 'ARMA'),
(935, '09', '04', '03', 'AURAHUA'),
(936, '09', '04', '04', 'CAPILLAS'),
(937, '09', '04', '05', 'CHUPAMARCA'),
(938, '09', '04', '06', 'COCAS'),
(939, '09', '04', '07', 'HUACHOS'),
(940, '09', '04', '08', 'HUAMATAMBO'),
(941, '09', '04', '09', 'MOLLEPAMPA'),
(942, '09', '04', '10', 'SAN JUAN'),
(943, '09', '04', '11', 'SANTA ANA'),
(944, '09', '04', '12', 'TANTARA'),
(945, '09', '04', '13', 'TICRAPO'),
(946, '09', '05', '00', 'CHURCAMPA'),
(947, '09', '05', '01', 'CHURCAMPA'),
(948, '09', '05', '02', 'ANCO'),
(949, '09', '05', '03', 'CHINCHIHUASI'),
(950, '09', '05', '04', 'EL CARMEN'),
(951, '09', '05', '05', 'LA MERCED'),
(952, '09', '05', '06', 'LOCROJA'),
(953, '09', '05', '07', 'PAUCARBAMBA'),
(954, '09', '05', '08', 'SAN MIGUEL DE MAYOCC'),
(955, '09', '05', '09', 'SAN PEDRO DE CORIS'),
(956, '09', '05', '10', 'PACHAMARCA'),
(957, '09', '05', '11', 'COSME'),
(958, '09', '06', '00', 'HUAYTARA'),
(959, '09', '06', '01', 'HUAYTARA'),
(960, '09', '06', '02', 'AYAVI'),
(961, '09', '06', '03', 'CORDOVA'),
(962, '09', '06', '04', 'HUAYACUNDO ARMA'),
(963, '09', '06', '05', 'LARAMARCA'),
(964, '09', '06', '06', 'OCOYO'),
(965, '09', '06', '07', 'PILPICHACA'),
(966, '09', '06', '08', 'QUERCO'),
(967, '09', '06', '09', 'QUITO-ARMA'),
(968, '09', '06', '10', 'SAN ANTONIO DE CUSICANCHA'),
(969, '09', '06', '11', 'SAN FRANCISCO DE SANGAYAICO'),
(970, '09', '06', '12', 'SAN ISIDRO'),
(971, '09', '06', '13', 'SANTIAGO DE CHOCORVOS'),
(972, '09', '06', '14', 'SANTIAGO DE QUIRAHUARA'),
(973, '09', '06', '15', 'SANTO DOMINGO DE CAPILLAS'),
(974, '09', '06', '16', 'TAMBO'),
(975, '09', '07', '00', 'TAYACAJA'),
(976, '09', '07', '01', 'PAMPAS'),
(977, '09', '07', '02', 'ACOSTAMBO'),
(978, '09', '07', '03', 'ACRAQUIA'),
(979, '09', '07', '04', 'AHUAYCHA'),
(980, '09', '07', '05', 'COLCABAMBA'),
(981, '09', '07', '06', 'DANIEL HERNANDEZ'),
(982, '09', '07', '07', 'HUACHOCOLPA'),
(983, '09', '07', '09', 'HUARIBAMBA'),
(984, '09', '07', '10', 'ÑAHUIMPUQUIO'),
(985, '09', '07', '11', 'PAZOS'),
(986, '09', '07', '13', 'QUISHUAR'),
(987, '09', '07', '14', 'SALCABAMBA'),
(988, '09', '07', '15', 'SALCAHUASI'),
(989, '09', '07', '16', 'SAN MARCOS DE ROCCHAC'),
(990, '09', '07', '17', 'SURCUBAMBA'),
(991, '09', '07', '18', 'TINTAY PUNCU'),
(992, '10', '00', '00', 'HUANUCO'),
(993, '10', '01', '00', 'HUANUCO'),
(994, '10', '01', '01', 'HUANUCO'),
(995, '10', '01', '02', 'AMARILIS'),
(996, '10', '01', '03', 'CHINCHAO'),
(997, '10', '01', '04', 'CHURUBAMBA'),
(998, '10', '01', '05', 'MARGOS'),
(999, '10', '01', '06', 'QUISQUI'),
(1000, '10', '01', '07', 'SAN FRANCISCO DE CAYRAN'),
(1001, '10', '01', '08', 'SAN PEDRO DE CHAULAN'),
(1002, '10', '01', '09', 'SANTA MARIA DEL VALLE'),
(1003, '10', '01', '10', 'YARUMAYO'),
(1004, '10', '01', '11', 'PILLCO MARCA'),
(1005, '10', '01', '12', 'YACUS'),
(1006, '10', '02', '00', 'AMBO'),
(1007, '10', '02', '01', 'AMBO'),
(1008, '10', '02', '02', 'CAYNA'),
(1009, '10', '02', '03', 'COLPAS'),
(1010, '10', '02', '04', 'CONCHAMARCA'),
(1011, '10', '02', '05', 'HUACAR'),
(1012, '10', '02', '06', 'SAN FRANCISCO'),
(1013, '10', '02', '07', 'SAN RAFAEL'),
(1014, '10', '02', '08', 'TOMAY KICHWA'),
(1015, '10', '03', '00', 'DOS DE MAYO'),
(1016, '10', '03', '01', 'LA UNION'),
(1017, '10', '03', '07', 'CHUQUIS'),
(1018, '10', '03', '11', 'MARIAS'),
(1019, '10', '03', '13', 'PACHAS'),
(1020, '10', '03', '16', 'QUIVILLA'),
(1021, '10', '03', '17', 'RIPAN'),
(1022, '10', '03', '21', 'SHUNQUI'),
(1023, '10', '03', '22', 'SILLAPATA'),
(1024, '10', '03', '23', 'YANAS'),
(1025, '10', '04', '00', 'HUACAYBAMBA'),
(1026, '10', '04', '01', 'HUACAYBAMBA'),
(1027, '10', '04', '02', 'CANCHABAMBA'),
(1028, '10', '04', '03', 'COCHABAMBA'),
(1029, '10', '04', '04', 'PINRA'),
(1030, '10', '05', '00', 'HUAMALIES'),
(1031, '10', '05', '01', 'LLATA'),
(1032, '10', '05', '02', 'ARANCAY'),
(1033, '10', '05', '03', 'CHAVIN DE PARIARCA'),
(1034, '10', '05', '04', 'JACAS GRANDE'),
(1035, '10', '05', '05', 'JIRCAN'),
(1036, '10', '05', '06', 'MIRAFLORES'),
(1037, '10', '05', '07', 'MONZON'),
(1038, '10', '05', '08', 'PUNCHAO'),
(1039, '10', '05', '09', 'PUÑOS'),
(1040, '10', '05', '10', 'SINGA'),
(1041, '10', '05', '11', 'TANTAMAYO'),
(1042, '10', '06', '00', 'LEONCIO PRADO'),
(1043, '10', '06', '01', 'RUPA-RUPA'),
(1044, '10', '06', '02', 'DANIEL ALOMIAS ROBLES'),
(1045, '10', '06', '03', 'HERMILIO VALDIZAN'),
(1046, '10', '06', '04', 'JOSE CRESPO Y CASTILLO'),
(1047, '10', '06', '05', 'LUYANDO'),
(1048, '10', '06', '06', 'MARIANO DAMASO BERAUN'),
(1049, '10', '07', '00', 'MARAÑON'),
(1050, '10', '07', '01', 'HUACRACHUCO'),
(1051, '10', '07', '02', 'CHOLON'),
(1052, '10', '07', '03', 'SAN BUENAVENTURA'),
(1053, '10', '08', '00', 'PACHITEA'),
(1054, '10', '08', '01', 'PANAO'),
(1055, '10', '08', '02', 'CHAGLLA'),
(1056, '10', '08', '03', 'MOLINO'),
(1057, '10', '08', '04', 'UMARI'),
(1058, '10', '09', '00', 'PUERTO INCA'),
(1059, '10', '09', '01', 'PUERTO INCA'),
(1060, '10', '09', '02', 'CODO DEL POZUZO'),
(1061, '10', '09', '03', 'HONORIA'),
(1062, '10', '09', '04', 'TOURNAVISTA'),
(1063, '10', '09', '05', 'YUYAPICHIS'),
(1064, '10', '10', '00', 'LAURICOCHA'),
(1065, '10', '10', '01', 'JESUS'),
(1066, '10', '10', '02', 'BAÑOS'),
(1067, '10', '10', '03', 'JIVIA'),
(1068, '10', '10', '04', 'QUEROPALCA'),
(1069, '10', '10', '05', 'RONDOS'),
(1070, '10', '10', '06', 'SAN FRANCISCO DE ASIS'),
(1071, '10', '10', '07', 'SAN MIGUEL DE CAURI'),
(1072, '10', '11', '00', 'YAROWILCA'),
(1073, '10', '11', '01', 'CHAVINILLO'),
(1074, '10', '11', '02', 'CAHUAC'),
(1075, '10', '11', '03', 'CHACABAMBA'),
(1076, '10', '11', '04', 'CHUPAN'),
(1077, '10', '11', '05', 'JACAS CHICO'),
(1078, '10', '11', '06', 'OBAS'),
(1079, '10', '11', '07', 'PAMPAMARCA'),
(1080, '10', '11', '08', 'CHORAS'),
(1081, '11', '00', '00', 'ICA'),
(1082, '11', '01', '00', 'ICA'),
(1083, '11', '01', '01', 'ICA'),
(1084, '11', '01', '02', 'LA TINGUIÑA'),
(1085, '11', '01', '03', 'LOS AQUIJES'),
(1086, '11', '01', '04', 'OCUCAJE'),
(1087, '11', '01', '05', 'PACHACUTEC'),
(1088, '11', '01', '06', 'PARCONA'),
(1089, '11', '01', '07', 'PUEBLO NUEVO'),
(1090, '11', '01', '08', 'SALAS'),
(1091, '11', '01', '09', 'SAN JOSE DE LOS MOLINOS'),
(1092, '11', '01', '10', 'SAN JUAN BAUTISTA'),
(1093, '11', '01', '11', 'SANTIAGO'),
(1094, '11', '01', '12', 'SUBTANJALLA'),
(1095, '11', '01', '13', 'TATE'),
(1096, '11', '01', '14', 'YAUCA DEL ROSARIO'),
(1097, '11', '02', '00', 'CHINCHA'),
(1098, '11', '02', '01', 'CHINCHA ALTA'),
(1099, '11', '02', '02', 'ALTO LARAN'),
(1100, '11', '02', '03', 'CHAVIN'),
(1101, '11', '02', '04', 'CHINCHA BAJA'),
(1102, '11', '02', '05', 'EL CARMEN'),
(1103, '11', '02', '06', 'GROCIO PRADO'),
(1104, '11', '02', '07', 'PUEBLO NUEVO'),
(1105, '11', '02', '08', 'SAN JUAN DE YANAC'),
(1106, '11', '02', '09', 'SAN PEDRO DE HUACARPANA'),
(1107, '11', '02', '10', 'SUNAMPE'),
(1108, '11', '02', '11', 'TAMBO DE MORA'),
(1109, '11', '03', '00', 'NAZCA'),
(1110, '11', '03', '01', 'NAZCA'),
(1111, '11', '03', '02', 'CHANGUILLO'),
(1112, '11', '03', '03', 'EL INGENIO'),
(1113, '11', '03', '04', 'MARCONA'),
(1114, '11', '03', '05', 'VISTA ALEGRE'),
(1115, '11', '04', '00', 'PALPA'),
(1116, '11', '04', '01', 'PALPA'),
(1117, '11', '04', '02', 'LLIPATA'),
(1118, '11', '04', '03', 'RIO GRANDE'),
(1119, '11', '04', '04', 'SANTA CRUZ'),
(1120, '11', '04', '05', 'TIBILLO'),
(1121, '11', '05', '00', 'PISCO'),
(1122, '11', '05', '01', 'PISCO'),
(1123, '11', '05', '02', 'HUANCANO'),
(1124, '11', '05', '03', 'HUMAY'),
(1125, '11', '05', '04', 'INDEPENDENCIA'),
(1126, '11', '05', '05', 'PARACAS'),
(1127, '11', '05', '06', 'SAN ANDRES'),
(1128, '11', '05', '07', 'SAN CLEMENTE'),
(1129, '11', '05', '08', 'TUPAC AMARU INCA'),
(1130, '12', '00', '00', 'JUNIN'),
(1131, '12', '01', '00', 'HUANCAYO'),
(1132, '12', '01', '01', 'HUANCAYO'),
(1133, '12', '01', '04', 'CARHUACALLANGA'),
(1134, '12', '01', '05', 'CHACAPAMPA'),
(1135, '12', '01', '06', 'CHICCHE'),
(1136, '12', '01', '07', 'CHILCA'),
(1137, '12', '01', '08', 'CHONGOS ALTO'),
(1138, '12', '01', '11', 'CHUPURO'),
(1139, '12', '01', '12', 'COLCA'),
(1140, '12', '01', '13', 'CULLHUAS'),
(1141, '12', '01', '14', 'EL TAMBO'),
(1142, '12', '01', '16', 'HUACRAPUQUIO'),
(1143, '12', '01', '17', 'HUALHUAS'),
(1144, '12', '01', '19', 'HUANCAN'),
(1145, '12', '01', '20', 'HUASICANCHA'),
(1146, '12', '01', '21', 'HUAYUCACHI'),
(1147, '12', '01', '22', 'INGENIO'),
(1148, '12', '01', '24', 'PARIAHUANCA'),
(1149, '12', '01', '25', 'PILCOMAYO'),
(1150, '12', '01', '26', 'PUCARA'),
(1151, '12', '01', '27', 'QUICHUAY'),
(1152, '12', '01', '28', 'QUILCAS'),
(1153, '12', '01', '29', 'SAN AGUSTIN'),
(1154, '12', '01', '30', 'SAN JERONIMO DE TUNAN'),
(1155, '12', '01', '32', 'SAÑO'),
(1156, '12', '01', '33', 'SAPALLANGA'),
(1157, '12', '01', '34', 'SICAYA'),
(1158, '12', '01', '35', 'SANTO DOMINGO DE ACOBAMBA'),
(1159, '12', '01', '36', 'VIQUES'),
(1160, '12', '02', '00', 'CONCEPCION'),
(1161, '12', '02', '01', 'CONCEPCION'),
(1162, '12', '02', '02', 'ACO'),
(1163, '12', '02', '03', 'ANDAMARCA'),
(1164, '12', '02', '04', 'CHAMBARA'),
(1165, '12', '02', '05', 'COCHAS'),
(1166, '12', '02', '06', 'COMAS'),
(1167, '12', '02', '07', 'HEROINAS TOLEDO'),
(1168, '12', '02', '08', 'MANZANARES'),
(1169, '12', '02', '09', 'MARISCAL CASTILLA'),
(1170, '12', '02', '10', 'MATAHUASI'),
(1171, '12', '02', '11', 'MITO'),
(1172, '12', '02', '12', 'NUEVE DE JULIO'),
(1173, '12', '02', '13', 'ORCOTUNA'),
(1174, '12', '02', '14', 'SAN JOSE DE QUERO'),
(1175, '12', '02', '15', 'SANTA ROSA DE OCOPA'),
(1176, '12', '03', '00', 'CHANCHAMAYO'),
(1177, '12', '03', '01', 'CHANCHAMAYO'),
(1178, '12', '03', '02', 'PERENE'),
(1179, '12', '03', '03', 'PICHANAQUI'),
(1180, '12', '03', '04', 'SAN LUIS DE SHUARO'),
(1181, '12', '03', '05', 'SAN RAMON'),
(1182, '12', '03', '06', 'VITOC'),
(1183, '12', '04', '00', 'JAUJA'),
(1184, '12', '04', '01', 'JAUJA'),
(1185, '12', '04', '02', 'ACOLLA'),
(1186, '12', '04', '03', 'APATA'),
(1187, '12', '04', '04', 'ATAURA'),
(1188, '12', '04', '05', 'CANCHAYLLO'),
(1189, '12', '04', '06', 'CURICACA'),
(1190, '12', '04', '07', 'EL MANTARO'),
(1191, '12', '04', '08', 'HUAMALI'),
(1192, '12', '04', '09', 'HUARIPAMPA'),
(1193, '12', '04', '10', 'HUERTAS'),
(1194, '12', '04', '11', 'JANJAILLO'),
(1195, '12', '04', '12', 'JULCAN'),
(1196, '12', '04', '13', 'LEONOR ORDOÑEZ'),
(1197, '12', '04', '14', 'LLOCLLAPAMPA'),
(1198, '12', '04', '15', 'MARCO'),
(1199, '12', '04', '16', 'MASMA'),
(1200, '12', '04', '17', 'MASMA CHICCHE'),
(1201, '12', '04', '18', 'MOLINOS'),
(1202, '12', '04', '19', 'MONOBAMBA'),
(1203, '12', '04', '20', 'MUQUI'),
(1204, '12', '04', '21', 'MUQUIYAUYO'),
(1205, '12', '04', '22', 'PACA'),
(1206, '12', '04', '23', 'PACCHA'),
(1207, '12', '04', '24', 'PANCAN'),
(1208, '12', '04', '25', 'PARCO'),
(1209, '12', '04', '26', 'POMACANCHA'),
(1210, '12', '04', '27', 'RICRAN'),
(1211, '12', '04', '28', 'SAN LORENZO'),
(1212, '12', '04', '29', 'SAN PEDRO DE CHUNAN'),
(1213, '12', '04', '30', 'SAUSA'),
(1214, '12', '04', '31', 'SINCOS'),
(1215, '12', '04', '32', 'TUNAN MARCA'),
(1216, '12', '04', '33', 'YAULI'),
(1217, '12', '04', '34', 'YAUYOS'),
(1218, '12', '05', '00', 'JUNIN'),
(1219, '12', '05', '01', 'JUNIN'),
(1220, '12', '05', '02', 'CARHUAMAYO'),
(1221, '12', '05', '03', 'ONDORES'),
(1222, '12', '05', '04', 'ULCUMAYO'),
(1223, '12', '06', '00', 'SATIPO'),
(1224, '12', '06', '01', 'SATIPO'),
(1225, '12', '06', '02', 'COVIRIALI'),
(1226, '12', '06', '03', 'LLAYLLA'),
(1227, '12', '06', '04', 'MAZAMARI'),
(1228, '12', '06', '05', 'PAMPA HERMOSA'),
(1229, '12', '06', '06', 'PANGOA'),
(1230, '12', '06', '07', 'RIO NEGRO'),
(1231, '12', '06', '08', 'RIO TAMBO'),
(1232, '12', '06', '99', 'MAZAMARI-PANGOA'),
(1233, '12', '07', '00', 'TARMA'),
(1234, '12', '07', '01', 'TARMA'),
(1235, '12', '07', '02', 'ACOBAMBA'),
(1236, '12', '07', '03', 'HUARICOLCA'),
(1237, '12', '07', '04', 'HUASAHUASI'),
(1238, '12', '07', '05', 'LA UNION'),
(1239, '12', '07', '06', 'PALCA'),
(1240, '12', '07', '07', 'PALCAMAYO'),
(1241, '12', '07', '08', 'SAN PEDRO DE CAJAS'),
(1242, '12', '07', '09', 'TAPO'),
(1243, '12', '08', '00', 'YAULI'),
(1244, '12', '08', '01', 'LA OROYA'),
(1245, '12', '08', '02', 'CHACAPALPA'),
(1246, '12', '08', '03', 'HUAY-HUAY'),
(1247, '12', '08', '04', 'MARCAPOMACOCHA'),
(1248, '12', '08', '05', 'MOROCOCHA'),
(1249, '12', '08', '06', 'PACCHA'),
(1250, '12', '08', '07', 'SANTA BARBARA DE CARHUACAYAN'),
(1251, '12', '08', '08', 'SANTA ROSA DE SACCO'),
(1252, '12', '08', '09', 'SUITUCANCHA'),
(1253, '12', '08', '10', 'YAULI'),
(1254, '12', '09', '00', 'CHUPACA'),
(1255, '12', '09', '01', 'CHUPACA'),
(1256, '12', '09', '02', 'AHUAC'),
(1257, '12', '09', '03', 'CHONGOS BAJO'),
(1258, '12', '09', '04', 'HUACHAC'),
(1259, '12', '09', '05', 'HUAMANCACA CHICO'),
(1260, '12', '09', '06', 'SAN JUAN DE ISCOS'),
(1261, '12', '09', '07', 'SAN JUAN DE JARPA'),
(1262, '12', '09', '08', '3 DE DICIEMBRE'),
(1263, '12', '09', '09', 'YANACANCHA'),
(1264, '13', '00', '00', 'LA LIBERTAD'),
(1265, '13', '01', '00', 'TRUJILLO'),
(1266, '13', '01', '01', 'TRUJILLO'),
(1267, '13', '01', '02', 'EL PORVENIR'),
(1268, '13', '01', '03', 'FLORENCIA DE MORA'),
(1269, '13', '01', '04', 'HUANCHACO'),
(1270, '13', '01', '05', 'LA ESPERANZA'),
(1271, '13', '01', '06', 'LAREDO'),
(1272, '13', '01', '07', 'MOCHE'),
(1273, '13', '01', '08', 'POROTO'),
(1274, '13', '01', '09', 'SALAVERRY'),
(1275, '13', '01', '10', 'SIMBAL'),
(1276, '13', '01', '11', 'VICTOR LARCO HERRERA'),
(1277, '13', '02', '00', 'ASCOPE'),
(1278, '13', '02', '01', 'ASCOPE'),
(1279, '13', '02', '02', 'CHICAMA'),
(1280, '13', '02', '03', 'CHOCOPE'),
(1281, '13', '02', '04', 'MAGDALENA DE CAO'),
(1282, '13', '02', '05', 'PAIJAN'),
(1283, '13', '02', '06', 'RAZURI'),
(1284, '13', '02', '07', 'SANTIAGO DE CAO'),
(1285, '13', '02', '08', 'CASA GRANDE'),
(1286, '13', '03', '00', 'BOLIVAR'),
(1287, '13', '03', '01', 'BOLIVAR'),
(1288, '13', '03', '02', 'BAMBAMARCA'),
(1289, '13', '03', '03', 'CONDORMARCA'),
(1290, '13', '03', '04', 'LONGOTEA'),
(1291, '13', '03', '05', 'UCHUMARCA'),
(1292, '13', '03', '06', 'UCUNCHA'),
(1293, '13', '04', '00', 'CHEPEN'),
(1294, '13', '04', '01', 'CHEPEN'),
(1295, '13', '04', '02', 'PACANGA'),
(1296, '13', '04', '03', 'PUEBLO NUEVO'),
(1297, '13', '05', '00', 'JULCAN'),
(1298, '13', '05', '01', 'JULCAN'),
(1299, '13', '05', '02', 'CALAMARCA'),
(1300, '13', '05', '03', 'CARABAMBA'),
(1301, '13', '05', '04', 'HUASO'),
(1302, '13', '06', '00', 'OTUZCO'),
(1303, '13', '06', '01', 'OTUZCO'),
(1304, '13', '06', '02', 'AGALLPAMPA'),
(1305, '13', '06', '04', 'CHARAT'),
(1306, '13', '06', '05', 'HUARANCHAL'),
(1307, '13', '06', '06', 'LA CUESTA'),
(1308, '13', '06', '08', 'MACHE'),
(1309, '13', '06', '10', 'PARANDAY'),
(1310, '13', '06', '11', 'SALPO'),
(1311, '13', '06', '13', 'SINSICAP'),
(1312, '13', '06', '14', 'USQUIL'),
(1313, '13', '07', '00', 'PACASMAYO'),
(1314, '13', '07', '01', 'SAN PEDRO DE LLOC'),
(1315, '13', '07', '02', 'GUADALUPE'),
(1316, '13', '07', '03', 'JEQUETEPEQUE'),
(1317, '13', '07', '04', 'PACASMAYO'),
(1318, '13', '07', '05', 'SAN JOSE'),
(1319, '13', '08', '00', 'PATAZ'),
(1320, '13', '08', '01', 'TAYABAMBA'),
(1321, '13', '08', '02', 'BULDIBUYO'),
(1322, '13', '08', '03', 'CHILLIA'),
(1323, '13', '08', '04', 'HUANCASPATA'),
(1324, '13', '08', '05', 'HUAYLILLAS'),
(1325, '13', '08', '06', 'HUAYO'),
(1326, '13', '08', '07', 'ONGON'),
(1327, '13', '08', '08', 'PARCOY'),
(1328, '13', '08', '09', 'PATAZ'),
(1329, '13', '08', '10', 'PIAS'),
(1330, '13', '08', '11', 'SANTIAGO DE CHALLAS'),
(1331, '13', '08', '12', 'TAURIJA'),
(1332, '13', '08', '13', 'URPAY'),
(1333, '13', '09', '00', 'SANCHEZ CARRION'),
(1334, '13', '09', '01', 'HUAMACHUCO'),
(1335, '13', '09', '02', 'CHUGAY'),
(1336, '13', '09', '03', 'COCHORCO'),
(1337, '13', '09', '04', 'CURGOS'),
(1338, '13', '09', '05', 'MARCABAL'),
(1339, '13', '09', '06', 'SANAGORAN'),
(1340, '13', '09', '07', 'SARIN'),
(1341, '13', '09', '08', 'SARTIMBAMBA'),
(1342, '13', '10', '00', 'SANTIAGO DE CHUCO'),
(1343, '13', '10', '01', 'SANTIAGO DE CHUCO'),
(1344, '13', '10', '02', 'ANGASMARCA'),
(1345, '13', '10', '03', 'CACHICADAN'),
(1346, '13', '10', '04', 'MOLLEBAMBA'),
(1347, '13', '10', '05', 'MOLLEPATA'),
(1348, '13', '10', '06', 'QUIRUVILCA'),
(1349, '13', '10', '07', 'SANTA CRUZ DE CHUCA'),
(1350, '13', '10', '08', 'SITABAMBA'),
(1351, '13', '11', '00', 'GRAN CHIMU'),
(1352, '13', '11', '01', 'CASCAS'),
(1353, '13', '11', '02', 'LUCMA'),
(1354, '13', '11', '03', 'MARMOT'),
(1355, '13', '11', '04', 'SAYAPULLO'),
(1356, '13', '12', '00', 'VIRU'),
(1357, '13', '12', '01', 'VIRU'),
(1358, '13', '12', '02', 'CHAO'),
(1359, '13', '12', '03', 'GUADALUPITO'),
(1360, '14', '00', '00', 'LAMBAYEQUE'),
(1361, '14', '01', '00', 'CHICLAYO'),
(1362, '14', '01', '01', 'CHICLAYO'),
(1363, '14', '01', '02', 'CHONGOYAPE'),
(1364, '14', '01', '03', 'ETEN'),
(1365, '14', '01', '04', 'ETEN PUERTO'),
(1366, '14', '01', '05', 'JOSE LEONARDO ORTIZ'),
(1367, '14', '01', '06', 'LA VICTORIA'),
(1368, '14', '01', '07', 'LAGUNAS'),
(1369, '14', '01', '08', 'MONSEFU'),
(1370, '14', '01', '09', 'NUEVA ARICA'),
(1371, '14', '01', '10', 'OYOTUN'),
(1372, '14', '01', '11', 'PICSI'),
(1373, '14', '01', '12', 'PIMENTEL'),
(1374, '14', '01', '13', 'REQUE'),
(1375, '14', '01', '14', 'SANTA ROSA'),
(1376, '14', '01', '15', 'SAÑA');
INSERT INTO `ubigeo_inei` (`id_ubigeo`, `departamento`, `provincia`, `distrito`, `nombre`) VALUES
(1377, '14', '01', '16', 'CAYALTÍ'),
(1378, '14', '01', '17', 'PATAPO'),
(1379, '14', '01', '18', 'POMALCA'),
(1380, '14', '01', '19', 'PUCALÁ'),
(1381, '14', '01', '20', 'TUMÁN'),
(1382, '14', '02', '00', 'FERREÑAFE'),
(1383, '14', '02', '01', 'FERREÑAFE'),
(1384, '14', '02', '02', 'CAÑARIS'),
(1385, '14', '02', '03', 'INCAHUASI'),
(1386, '14', '02', '04', 'MANUEL ANTONIO MESONES MURO'),
(1387, '14', '02', '05', 'PITIPO'),
(1388, '14', '02', '06', 'PUEBLO NUEVO'),
(1389, '14', '03', '00', 'LAMBAYEQUE'),
(1390, '14', '03', '01', 'LAMBAYEQUE'),
(1391, '14', '03', '02', 'CHOCHOPE'),
(1392, '14', '03', '03', 'ILLIMO'),
(1393, '14', '03', '04', 'JAYANCA'),
(1394, '14', '03', '05', 'MOCHUMI'),
(1395, '14', '03', '06', 'MORROPE'),
(1396, '14', '03', '07', 'MOTUPE'),
(1397, '14', '03', '08', 'OLMOS'),
(1398, '14', '03', '09', 'PACORA'),
(1399, '14', '03', '10', 'SALAS'),
(1400, '14', '03', '11', 'SAN JOSE'),
(1401, '14', '03', '12', 'TUCUME'),
(1402, '15', '00', '00', 'LIMA'),
(1403, '15', '01', '00', 'LIMA'),
(1404, '15', '01', '01', 'LIMA'),
(1405, '15', '01', '02', 'ANCON'),
(1406, '15', '01', '03', 'ATE'),
(1407, '15', '01', '04', 'BARRANCO'),
(1408, '15', '01', '05', 'BREÑA'),
(1409, '15', '01', '06', 'CARABAYLLO'),
(1410, '15', '01', '07', 'CHACLACAYO'),
(1411, '15', '01', '08', 'CHORRILLOS'),
(1412, '15', '01', '09', 'CIENEGUILLA'),
(1413, '15', '01', '10', 'COMAS'),
(1414, '15', '01', '11', 'EL AGUSTINO'),
(1415, '15', '01', '12', 'INDEPENDENCIA'),
(1416, '15', '01', '13', 'JESUS MARIA'),
(1417, '15', '01', '14', 'LA MOLINA'),
(1418, '15', '01', '15', 'LA VICTORIA'),
(1419, '15', '01', '16', 'LINCE'),
(1420, '15', '01', '17', 'LOS OLIVOS'),
(1421, '15', '01', '18', 'LURIGANCHO'),
(1422, '15', '01', '19', 'LURIN'),
(1423, '15', '01', '20', 'MAGDALENA DEL MAR'),
(1424, '15', '01', '21', 'PUEBLO LIBRE (MAGDALENA VIEJA)'),
(1425, '15', '01', '22', 'MIRAFLORES'),
(1426, '15', '01', '23', 'PACHACAMAC'),
(1427, '15', '01', '24', 'PUCUSANA'),
(1428, '15', '01', '25', 'PUENTE PIEDRA'),
(1429, '15', '01', '26', 'PUNTA HERMOSA'),
(1430, '15', '01', '27', 'PUNTA NEGRA'),
(1431, '15', '01', '28', 'RIMAC'),
(1432, '15', '01', '29', 'SAN BARTOLO'),
(1433, '15', '01', '30', 'SAN BORJA'),
(1434, '15', '01', '31', 'SAN ISIDRO'),
(1435, '15', '01', '32', 'SAN JUAN DE LURIGANCHO'),
(1436, '15', '01', '33', 'SAN JUAN DE MIRAFLORES'),
(1437, '15', '01', '34', 'SAN LUIS'),
(1438, '15', '01', '35', 'SAN MARTIN DE PORRES'),
(1439, '15', '01', '36', 'SAN MIGUEL'),
(1440, '15', '01', '37', 'SANTA ANITA'),
(1441, '15', '01', '38', 'SANTA MARIA DEL MAR'),
(1442, '15', '01', '39', 'SANTA ROSA'),
(1443, '15', '01', '40', 'SANTIAGO DE SURCO'),
(1444, '15', '01', '41', 'SURQUILLO'),
(1445, '15', '01', '42', 'VILLA EL SALVADOR'),
(1446, '15', '01', '43', 'VILLA MARIA DEL TRIUNFO'),
(1447, '15', '02', '00', 'BARRANCA'),
(1448, '15', '02', '01', 'BARRANCA'),
(1449, '15', '02', '02', 'PARAMONGA'),
(1450, '15', '02', '03', 'PATIVILCA'),
(1451, '15', '02', '04', 'SUPE'),
(1452, '15', '02', '05', 'SUPE PUERTO'),
(1453, '15', '03', '00', 'CAJATAMBO'),
(1454, '15', '03', '01', 'CAJATAMBO'),
(1455, '15', '03', '02', 'COPA'),
(1456, '15', '03', '03', 'GORGOR'),
(1457, '15', '03', '04', 'HUANCAPON'),
(1458, '15', '03', '05', 'MANAS'),
(1459, '15', '04', '00', 'CANTA'),
(1460, '15', '04', '01', 'CANTA'),
(1461, '15', '04', '02', 'ARAHUAY'),
(1462, '15', '04', '03', 'HUAMANTANGA'),
(1463, '15', '04', '04', 'HUAROS'),
(1464, '15', '04', '05', 'LACHAQUI'),
(1465, '15', '04', '06', 'SAN BUENAVENTURA'),
(1466, '15', '04', '07', 'SANTA ROSA DE QUIVES'),
(1467, '15', '05', '00', 'CAÑETE'),
(1468, '15', '05', '01', 'SAN VICENTE DE CAÑETE'),
(1469, '15', '05', '02', 'ASIA'),
(1470, '15', '05', '03', 'CALANGO'),
(1471, '15', '05', '04', 'CERRO AZUL'),
(1472, '15', '05', '05', 'CHILCA'),
(1473, '15', '05', '06', 'COAYLLO'),
(1474, '15', '05', '07', 'IMPERIAL'),
(1475, '15', '05', '08', 'LUNAHUANA'),
(1476, '15', '05', '09', 'MALA'),
(1477, '15', '05', '10', 'NUEVO IMPERIAL'),
(1478, '15', '05', '11', 'PACARAN'),
(1479, '15', '05', '12', 'QUILMANA'),
(1480, '15', '05', '13', 'SAN ANTONIO'),
(1481, '15', '05', '14', 'SAN LUIS'),
(1482, '15', '05', '15', 'SANTA CRUZ DE FLORES'),
(1483, '15', '05', '16', 'ZUÑIGA'),
(1484, '15', '06', '00', 'HUARAL'),
(1485, '15', '06', '01', 'HUARAL'),
(1486, '15', '06', '02', 'ATAVILLOS ALTO'),
(1487, '15', '06', '03', 'ATAVILLOS BAJO'),
(1488, '15', '06', '04', 'AUCALLAMA'),
(1489, '15', '06', '05', 'CHANCAY'),
(1490, '15', '06', '06', 'IHUARI'),
(1491, '15', '06', '07', 'LAMPIAN'),
(1492, '15', '06', '08', 'PACARAOS'),
(1493, '15', '06', '09', 'SAN MIGUEL DE ACOS'),
(1494, '15', '06', '10', 'SANTA CRUZ DE ANDAMARCA'),
(1495, '15', '06', '11', 'SUMBILCA'),
(1496, '15', '06', '12', 'VEINTISIETE DE NOVIEMBRE'),
(1497, '15', '07', '00', 'HUAROCHIRI'),
(1498, '15', '07', '01', 'MATUCANA'),
(1499, '15', '07', '02', 'ANTIOQUIA'),
(1500, '15', '07', '03', 'CALLAHUANCA'),
(1501, '15', '07', '04', 'CARAMPOMA'),
(1502, '15', '07', '05', 'CHICLA'),
(1503, '15', '07', '06', 'CUENCA'),
(1504, '15', '07', '07', 'HUACHUPAMPA'),
(1505, '15', '07', '08', 'HUANZA'),
(1506, '15', '07', '09', 'HUAROCHIRI'),
(1507, '15', '07', '10', 'LAHUAYTAMBO'),
(1508, '15', '07', '11', 'LANGA'),
(1509, '15', '07', '12', 'LARAOS'),
(1510, '15', '07', '13', 'MARIATANA'),
(1511, '15', '07', '14', 'RICARDO PALMA'),
(1512, '15', '07', '15', 'SAN ANDRES DE TUPICOCHA'),
(1513, '15', '07', '16', 'SAN ANTONIO'),
(1514, '15', '07', '17', 'SAN BARTOLOME'),
(1515, '15', '07', '18', 'SAN DAMIAN'),
(1516, '15', '07', '19', 'SAN JUAN DE IRIS'),
(1517, '15', '07', '20', 'SAN JUAN DE TANTARANCHE'),
(1518, '15', '07', '21', 'SAN LORENZO DE QUINTI'),
(1519, '15', '07', '22', 'SAN MATEO'),
(1520, '15', '07', '23', 'SAN MATEO DE OTAO'),
(1521, '15', '07', '24', 'SAN PEDRO DE CASTA'),
(1522, '15', '07', '25', 'SAN PEDRO DE HUANCAYRE'),
(1523, '15', '07', '26', 'SANGALLAYA'),
(1524, '15', '07', '27', 'SANTA CRUZ DE COCACHACRA'),
(1525, '15', '07', '28', 'SANTA EULALIA'),
(1526, '15', '07', '29', 'SANTIAGO DE ANCHUCAYA'),
(1527, '15', '07', '30', 'SANTIAGO DE TUNA'),
(1528, '15', '07', '31', 'SANTO DOMINGO DE LOS OLLEROS'),
(1529, '15', '07', '32', 'SURCO'),
(1530, '15', '08', '00', 'HUAURA'),
(1531, '15', '08', '01', 'HUACHO'),
(1532, '15', '08', '02', 'AMBAR'),
(1533, '15', '08', '03', 'CALETA DE CARQUIN'),
(1534, '15', '08', '04', 'CHECRAS'),
(1535, '15', '08', '05', 'HUALMAY'),
(1536, '15', '08', '06', 'HUAURA'),
(1537, '15', '08', '07', 'LEONCIO PRADO'),
(1538, '15', '08', '08', 'PACCHO'),
(1539, '15', '08', '09', 'SANTA LEONOR'),
(1540, '15', '08', '10', 'SANTA MARIA'),
(1541, '15', '08', '11', 'SAYAN'),
(1542, '15', '08', '12', 'VEGUETA'),
(1543, '15', '09', '00', 'OYON'),
(1544, '15', '09', '01', 'OYON'),
(1545, '15', '09', '02', 'ANDAJES'),
(1546, '15', '09', '03', 'CAUJUL'),
(1547, '15', '09', '04', 'COCHAMARCA'),
(1548, '15', '09', '05', 'NAVAN'),
(1549, '15', '09', '06', 'PACHANGARA'),
(1550, '15', '10', '00', 'YAUYOS'),
(1551, '15', '10', '01', 'YAUYOS'),
(1552, '15', '10', '02', 'ALIS'),
(1553, '15', '10', '03', 'AYAUCA'),
(1554, '15', '10', '04', 'AYAVIRI'),
(1555, '15', '10', '05', 'AZANGARO'),
(1556, '15', '10', '06', 'CACRA'),
(1557, '15', '10', '07', 'CARANIA'),
(1558, '15', '10', '08', 'CATAHUASI'),
(1559, '15', '10', '09', 'CHOCOS'),
(1560, '15', '10', '10', 'COCHAS'),
(1561, '15', '10', '11', 'COLONIA'),
(1562, '15', '10', '12', 'HONGOS'),
(1563, '15', '10', '13', 'HUAMPARA'),
(1564, '15', '10', '14', 'HUANCAYA'),
(1565, '15', '10', '15', 'HUANGASCAR'),
(1566, '15', '10', '16', 'HUANTAN'),
(1567, '15', '10', '17', 'HUAÑEC'),
(1568, '15', '10', '18', 'LARAOS'),
(1569, '15', '10', '19', 'LINCHA'),
(1570, '15', '10', '20', 'MADEAN'),
(1571, '15', '10', '21', 'MIRAFLORES'),
(1572, '15', '10', '22', 'OMAS'),
(1573, '15', '10', '23', 'PUTINZA'),
(1574, '15', '10', '24', 'QUINCHES'),
(1575, '15', '10', '25', 'QUINOCAY'),
(1576, '15', '10', '26', 'SAN JOAQUIN'),
(1577, '15', '10', '27', 'SAN PEDRO DE PILAS'),
(1578, '15', '10', '28', 'TANTA'),
(1579, '15', '10', '29', 'TAURIPAMPA'),
(1580, '15', '10', '30', 'TOMAS'),
(1581, '15', '10', '31', 'TUPE'),
(1582, '15', '10', '32', 'VIÑAC'),
(1583, '15', '10', '33', 'VITIS'),
(1584, '16', '00', '00', 'LORETO'),
(1585, '16', '01', '00', 'MAYNAS'),
(1586, '16', '01', '01', 'IQUITOS'),
(1587, '16', '01', '02', 'ALTO NANAY'),
(1588, '16', '01', '03', 'FERNANDO LORES'),
(1589, '16', '01', '04', 'INDIANA'),
(1590, '16', '01', '05', 'LAS AMAZONAS'),
(1591, '16', '01', '06', 'MAZAN'),
(1592, '16', '01', '07', 'NAPO'),
(1593, '16', '01', '08', 'PUNCHANA'),
(1594, '16', '01', '09', 'PUTUMAYO'),
(1595, '16', '01', '10', 'TORRES CAUSANA'),
(1596, '16', '01', '12', 'BELÉN'),
(1597, '16', '01', '13', 'SAN JUAN BAUTISTA'),
(1598, '16', '01', '14', 'TENIENTE MANUEL CLAVERO'),
(1599, '16', '02', '00', 'ALTO AMAZONAS'),
(1600, '16', '02', '01', 'YURIMAGUAS'),
(1601, '16', '02', '02', 'BALSAPUERTO'),
(1602, '16', '02', '05', 'JEBEROS'),
(1603, '16', '02', '06', 'LAGUNAS'),
(1604, '16', '02', '10', 'SANTA CRUZ'),
(1605, '16', '02', '11', 'TENIENTE CESAR LOPEZ ROJAS'),
(1606, '16', '03', '00', 'LORETO'),
(1607, '16', '03', '01', 'NAUTA'),
(1608, '16', '03', '02', 'PARINARI'),
(1609, '16', '03', '03', 'TIGRE'),
(1610, '16', '03', '04', 'TROMPETEROS'),
(1611, '16', '03', '05', 'URARINAS'),
(1612, '16', '04', '00', 'MARISCAL RAMON CASTILLA'),
(1613, '16', '04', '01', 'RAMON CASTILLA'),
(1614, '16', '04', '02', 'PEBAS'),
(1615, '16', '04', '03', 'YAVARI'),
(1616, '16', '04', '04', 'SAN PABLO'),
(1617, '16', '05', '00', 'REQUENA'),
(1618, '16', '05', '01', 'REQUENA'),
(1619, '16', '05', '02', 'ALTO TAPICHE'),
(1620, '16', '05', '03', 'CAPELO'),
(1621, '16', '05', '04', 'EMILIO SAN MARTIN'),
(1622, '16', '05', '05', 'MAQUIA'),
(1623, '16', '05', '06', 'PUINAHUA'),
(1624, '16', '05', '07', 'SAQUENA'),
(1625, '16', '05', '08', 'SOPLIN'),
(1626, '16', '05', '09', 'TAPICHE'),
(1627, '16', '05', '10', 'JENARO HERRERA'),
(1628, '16', '05', '11', 'YAQUERANA'),
(1629, '16', '06', '00', 'UCAYALI'),
(1630, '16', '06', '01', 'CONTAMANA'),
(1631, '16', '06', '02', 'INAHUAYA'),
(1632, '16', '06', '03', 'PADRE MARQUEZ'),
(1633, '16', '06', '04', 'PAMPA HERMOSA'),
(1634, '16', '06', '05', 'SARAYACU'),
(1635, '16', '06', '06', 'VARGAS GUERRA'),
(1636, '16', '07', '00', 'DATEM DEL MARAÑÓN'),
(1637, '16', '07', '01', 'BARRANCA'),
(1638, '16', '07', '02', 'CAHUAPANAS'),
(1639, '16', '07', '03', 'MANSERICHE'),
(1640, '16', '07', '04', 'MORONA'),
(1641, '16', '07', '05', 'PASTAZA'),
(1642, '16', '07', '06', 'ANDOAS'),
(1643, '16', '08', '00', 'PUTUMAYO'),
(1644, '16', '08', '01', 'PUTUMAYO'),
(1645, '16', '08', '02', 'ROSA PANDURO'),
(1646, '16', '08', '03', 'TENIENTE MANUEL CLAVERO'),
(1647, '16', '08', '04', 'YAGUAS'),
(1648, '17', '00', '00', 'MADRE DE DIOS'),
(1649, '17', '01', '00', 'TAMBOPATA'),
(1650, '17', '01', '01', 'TAMBOPATA'),
(1651, '17', '01', '02', 'INAMBARI'),
(1652, '17', '01', '03', 'LAS PIEDRAS'),
(1653, '17', '01', '04', 'LABERINTO'),
(1654, '17', '02', '00', 'MANU'),
(1655, '17', '02', '01', 'MANU'),
(1656, '17', '02', '02', 'FITZCARRALD'),
(1657, '17', '02', '03', 'MADRE DE DIOS'),
(1658, '17', '02', '04', 'HUEPETUHE'),
(1659, '17', '03', '00', 'TAHUAMANU'),
(1660, '17', '03', '01', 'IÑAPARI'),
(1661, '17', '03', '02', 'IBERIA'),
(1662, '17', '03', '03', 'TAHUAMANU'),
(1663, '18', '00', '00', 'MOQUEGUA'),
(1664, '18', '01', '00', 'MARISCAL NIETO'),
(1665, '18', '01', '01', 'MOQUEGUA'),
(1666, '18', '01', '02', 'CARUMAS'),
(1667, '18', '01', '03', 'CUCHUMBAYA'),
(1668, '18', '01', '04', 'SAMEGUA'),
(1669, '18', '01', '05', 'SAN CRISTOBAL'),
(1670, '18', '01', '06', 'TORATA'),
(1671, '18', '02', '00', 'GENERAL SANCHEZ CERRO'),
(1672, '18', '02', '01', 'OMATE'),
(1673, '18', '02', '02', 'CHOJATA'),
(1674, '18', '02', '03', 'COALAQUE'),
(1675, '18', '02', '04', 'ICHUÑA'),
(1676, '18', '02', '05', 'LA CAPILLA'),
(1677, '18', '02', '06', 'LLOQUE'),
(1678, '18', '02', '07', 'MATALAQUE'),
(1679, '18', '02', '08', 'PUQUINA'),
(1680, '18', '02', '09', 'QUINISTAQUILLAS'),
(1681, '18', '02', '10', 'UBINAS'),
(1682, '18', '02', '11', 'YUNGA'),
(1683, '18', '03', '00', 'ILO'),
(1684, '18', '03', '01', 'ILO'),
(1685, '18', '03', '02', 'EL ALGARROBAL'),
(1686, '18', '03', '03', 'PACOCHA'),
(1687, '19', '00', '00', 'PASCO'),
(1688, '19', '01', '00', 'PASCO'),
(1689, '19', '01', '01', 'CHAUPIMARCA'),
(1690, '19', '01', '02', 'HUACHON'),
(1691, '19', '01', '03', 'HUARIACA'),
(1692, '19', '01', '04', 'HUAYLLAY'),
(1693, '19', '01', '05', 'NINACACA'),
(1694, '19', '01', '06', 'PALLANCHACRA'),
(1695, '19', '01', '07', 'PAUCARTAMBO'),
(1696, '19', '01', '08', 'SAN FCO. DE ASÍS DE YARUSYACÁN'),
(1697, '19', '01', '09', 'SIMON BOLIVAR'),
(1698, '19', '01', '10', 'TICLACAYAN'),
(1699, '19', '01', '11', 'TINYAHUARCO'),
(1700, '19', '01', '12', 'VICCO'),
(1701, '19', '01', '13', 'YANACANCHA'),
(1702, '19', '02', '00', 'DANIEL ALCIDES CARRION'),
(1703, '19', '02', '01', 'YANAHUANCA'),
(1704, '19', '02', '02', 'CHACAYAN'),
(1705, '19', '02', '03', 'GOYLLARISQUIZGA'),
(1706, '19', '02', '04', 'PAUCAR'),
(1707, '19', '02', '05', 'SAN PEDRO DE PILLAO'),
(1708, '19', '02', '06', 'SANTA ANA DE TUSI'),
(1709, '19', '02', '07', 'TAPUC'),
(1710, '19', '02', '08', 'VILCABAMBA'),
(1711, '19', '03', '00', 'OXAPAMPA'),
(1712, '19', '03', '01', 'OXAPAMPA'),
(1713, '19', '03', '02', 'CHONTABAMBA'),
(1714, '19', '03', '03', 'HUANCABAMBA'),
(1715, '19', '03', '04', 'PALCAZU'),
(1716, '19', '03', '05', 'POZUZO'),
(1717, '19', '03', '06', 'PUERTO BERMUDEZ'),
(1718, '19', '03', '07', 'VILLA RICA'),
(1719, '19', '03', '08', 'CONSTITUCION'),
(1720, '20', '00', '00', 'PIURA'),
(1721, '20', '01', '00', 'PIURA'),
(1722, '20', '01', '01', 'PIURA'),
(1723, '20', '01', '04', 'CASTILLA'),
(1724, '20', '01', '05', 'CATACAOS'),
(1725, '20', '01', '07', 'CURA MORI'),
(1726, '20', '01', '08', 'EL TALLAN'),
(1727, '20', '01', '09', 'LA ARENA'),
(1728, '20', '01', '10', 'LA UNION'),
(1729, '20', '01', '11', 'LAS LOMAS'),
(1730, '20', '01', '14', 'TAMBO GRANDE'),
(1731, '20', '01', '15', 'VEINTISÉIS DE OCTUBRE'),
(1732, '20', '02', '00', 'AYABACA'),
(1733, '20', '02', '01', 'AYABACA'),
(1734, '20', '02', '02', 'FRIAS'),
(1735, '20', '02', '03', 'JILILI'),
(1736, '20', '02', '04', 'LAGUNAS'),
(1737, '20', '02', '05', 'MONTERO'),
(1738, '20', '02', '06', 'PACAIPAMPA'),
(1739, '20', '02', '07', 'PAIMAS'),
(1740, '20', '02', '08', 'SAPILLICA'),
(1741, '20', '02', '09', 'SICCHEZ'),
(1742, '20', '02', '10', 'SUYO'),
(1743, '20', '03', '00', 'HUANCABAMBA'),
(1744, '20', '03', '01', 'HUANCABAMBA'),
(1745, '20', '03', '02', 'CANCHAQUE'),
(1746, '20', '03', '03', 'EL CARMEN DE LA FRONTERA'),
(1747, '20', '03', '04', 'HUARMACA'),
(1748, '20', '03', '05', 'LALAQUIZ'),
(1749, '20', '03', '06', 'SAN MIGUEL DE EL FAIQUE'),
(1750, '20', '03', '07', 'SONDOR'),
(1751, '20', '03', '08', 'SONDORILLO'),
(1752, '20', '04', '00', 'MORROPON'),
(1753, '20', '04', '01', 'CHULUCANAS'),
(1754, '20', '04', '02', 'BUENOS AIRES'),
(1755, '20', '04', '03', 'CHALACO'),
(1756, '20', '04', '04', 'LA MATANZA'),
(1757, '20', '04', '05', 'MORROPON'),
(1758, '20', '04', '06', 'SALITRAL'),
(1759, '20', '04', '07', 'SAN JUAN DE BIGOTE'),
(1760, '20', '04', '08', 'SANTA CATALINA DE MOSSA'),
(1761, '20', '04', '09', 'SANTO DOMINGO'),
(1762, '20', '04', '10', 'YAMANGO'),
(1763, '20', '05', '00', 'PAITA'),
(1764, '20', '05', '01', 'PAITA'),
(1765, '20', '05', '02', 'AMOTAPE'),
(1766, '20', '05', '03', 'ARENAL'),
(1767, '20', '05', '04', 'COLAN'),
(1768, '20', '05', '05', 'LA HUACA'),
(1769, '20', '05', '06', 'TAMARINDO'),
(1770, '20', '05', '07', 'VICHAYAL'),
(1771, '20', '06', '00', 'SULLANA'),
(1772, '20', '06', '01', 'SULLANA'),
(1773, '20', '06', '02', 'BELLAVISTA'),
(1774, '20', '06', '03', 'IGNACIO ESCUDERO'),
(1775, '20', '06', '04', 'LANCONES'),
(1776, '20', '06', '05', 'MARCAVELICA'),
(1777, '20', '06', '06', 'MIGUEL CHECA'),
(1778, '20', '06', '07', 'QUERECOTILLO'),
(1779, '20', '06', '08', 'SALITRAL'),
(1780, '20', '07', '00', 'TALARA'),
(1781, '20', '07', '01', 'PARIÑAS'),
(1782, '20', '07', '02', 'EL ALTO'),
(1783, '20', '07', '03', 'LA BREA'),
(1784, '20', '07', '04', 'LOBITOS'),
(1785, '20', '07', '05', 'LOS ORGANOS'),
(1786, '20', '07', '06', 'MANCORA'),
(1787, '20', '08', '00', 'SECHURA'),
(1788, '20', '08', '01', 'SECHURA'),
(1789, '20', '08', '02', 'BELLAVISTA DE LA UNION'),
(1790, '20', '08', '03', 'BERNAL'),
(1791, '20', '08', '04', 'CRISTO NOS VALGA'),
(1792, '20', '08', '05', 'VICE'),
(1793, '20', '08', '06', 'RINCONADA LLICUAR'),
(1794, '21', '00', '00', 'PUNO'),
(1795, '21', '01', '00', 'PUNO'),
(1796, '21', '01', '01', 'PUNO'),
(1797, '21', '01', '02', 'ACORA'),
(1798, '21', '01', '03', 'AMANTANI'),
(1799, '21', '01', '04', 'ATUNCOLLA'),
(1800, '21', '01', '05', 'CAPACHICA'),
(1801, '21', '01', '06', 'CHUCUITO'),
(1802, '21', '01', '07', 'COATA'),
(1803, '21', '01', '08', 'HUATA'),
(1804, '21', '01', '09', 'MAÑAZO'),
(1805, '21', '01', '10', 'PAUCARCOLLA'),
(1806, '21', '01', '11', 'PICHACANI'),
(1807, '21', '01', '12', 'PLATERIA'),
(1808, '21', '01', '13', 'SAN ANTONIO'),
(1809, '21', '01', '14', 'TIQUILLACA'),
(1810, '21', '01', '15', 'VILQUE'),
(1811, '21', '02', '00', 'AZANGARO'),
(1812, '21', '02', '01', 'AZANGARO'),
(1813, '21', '02', '02', 'ACHAYA'),
(1814, '21', '02', '03', 'ARAPA'),
(1815, '21', '02', '04', 'ASILLO'),
(1816, '21', '02', '05', 'CAMINACA'),
(1817, '21', '02', '06', 'CHUPA'),
(1818, '21', '02', '07', 'JOSE DOMINGO CHOQUEHUANCA'),
(1819, '21', '02', '08', 'MUÑANI'),
(1820, '21', '02', '09', 'POTONI'),
(1821, '21', '02', '10', 'SAMAN'),
(1822, '21', '02', '11', 'SAN ANTON'),
(1823, '21', '02', '12', 'SAN JOSE'),
(1824, '21', '02', '13', 'SAN JUAN DE SALINAS'),
(1825, '21', '02', '14', 'SANTIAGO DE PUPUJA'),
(1826, '21', '02', '15', 'TIRAPATA'),
(1827, '21', '03', '00', 'CARABAYA'),
(1828, '21', '03', '01', 'MACUSANI'),
(1829, '21', '03', '02', 'AJOYANI'),
(1830, '21', '03', '03', 'AYAPATA'),
(1831, '21', '03', '04', 'COASA'),
(1832, '21', '03', '05', 'CORANI'),
(1833, '21', '03', '06', 'CRUCERO'),
(1834, '21', '03', '07', 'ITUATA'),
(1835, '21', '03', '08', 'OLLACHEA'),
(1836, '21', '03', '09', 'SAN GABAN'),
(1837, '21', '03', '10', 'USICAYOS'),
(1838, '21', '04', '00', 'CHUCUITO'),
(1839, '21', '04', '01', 'JULI'),
(1840, '21', '04', '02', 'DESAGUADERO'),
(1841, '21', '04', '03', 'HUACULLANI'),
(1842, '21', '04', '04', 'KELLUYO'),
(1843, '21', '04', '05', 'PISACOMA'),
(1844, '21', '04', '06', 'POMATA'),
(1845, '21', '04', '07', 'ZEPITA'),
(1846, '21', '05', '00', 'EL COLLAO'),
(1847, '21', '05', '01', 'ILAVE'),
(1848, '21', '05', '02', 'CAPASO'),
(1849, '21', '05', '03', 'PILCUYO'),
(1850, '21', '05', '04', 'SANTA ROSA'),
(1851, '21', '05', '05', 'CONDURIRI'),
(1852, '21', '06', '00', 'HUANCANE'),
(1853, '21', '06', '01', 'HUANCANE'),
(1854, '21', '06', '02', 'COJATA'),
(1855, '21', '06', '03', 'HUATASANI'),
(1856, '21', '06', '04', 'INCHUPALLA'),
(1857, '21', '06', '05', 'PUSI'),
(1858, '21', '06', '06', 'ROSASPATA'),
(1859, '21', '06', '07', 'TARACO'),
(1860, '21', '06', '08', 'VILQUE CHICO'),
(1861, '21', '07', '00', 'LAMPA'),
(1862, '21', '07', '01', 'LAMPA'),
(1863, '21', '07', '02', 'CABANILLA'),
(1864, '21', '07', '03', 'CALAPUJA'),
(1865, '21', '07', '04', 'NICASIO'),
(1866, '21', '07', '05', 'OCUVIRI'),
(1867, '21', '07', '06', 'PALCA'),
(1868, '21', '07', '07', 'PARATIA'),
(1869, '21', '07', '08', 'PUCARA'),
(1870, '21', '07', '09', 'SANTA LUCIA'),
(1871, '21', '07', '10', 'VILAVILA'),
(1872, '21', '08', '00', 'MELGAR'),
(1873, '21', '08', '01', 'AYAVIRI'),
(1874, '21', '08', '02', 'ANTAUTA'),
(1875, '21', '08', '03', 'CUPI'),
(1876, '21', '08', '04', 'LLALLI'),
(1877, '21', '08', '05', 'MACARI'),
(1878, '21', '08', '06', 'NUÑOA'),
(1879, '21', '08', '07', 'ORURILLO'),
(1880, '21', '08', '08', 'SANTA ROSA'),
(1881, '21', '08', '09', 'UMACHIRI'),
(1882, '21', '09', '00', 'MOHO'),
(1883, '21', '09', '01', 'MOHO'),
(1884, '21', '09', '02', 'CONIMA'),
(1885, '21', '09', '03', 'HUAYRAPATA'),
(1886, '21', '09', '04', 'TILALI'),
(1887, '21', '10', '00', 'SAN ANTONIO DE PUTINA'),
(1888, '21', '10', '01', 'PUTINA'),
(1889, '21', '10', '02', 'ANANEA'),
(1890, '21', '10', '03', 'PEDRO VILCA APAZA'),
(1891, '21', '10', '04', 'QUILCAPUNCU'),
(1892, '21', '10', '05', 'SINA'),
(1893, '21', '11', '00', 'SAN ROMAN'),
(1894, '21', '11', '01', 'JULIACA'),
(1895, '21', '11', '02', 'CABANA'),
(1896, '21', '11', '03', 'CABANILLAS'),
(1897, '21', '11', '04', 'CARACOTO'),
(1898, '21', '12', '00', 'SANDIA'),
(1899, '21', '12', '01', 'SANDIA'),
(1900, '21', '12', '02', 'CUYOCUYO'),
(1901, '21', '12', '03', 'LIMBANI'),
(1902, '21', '12', '04', 'PATAMBUCO'),
(1903, '21', '12', '05', 'PHARA'),
(1904, '21', '12', '06', 'QUIACA'),
(1905, '21', '12', '07', 'SAN JUAN DEL ORO'),
(1906, '21', '12', '08', 'YANAHUAYA'),
(1907, '21', '12', '09', 'ALTO INAMBARI'),
(1908, '21', '12', '10', 'SAN PEDRO DE PUTINA PUNCO'),
(1909, '21', '13', '00', 'YUNGUYO'),
(1910, '21', '13', '01', 'YUNGUYO'),
(1911, '21', '13', '02', 'ANAPIA'),
(1912, '21', '13', '03', 'COPANI'),
(1913, '21', '13', '04', 'CUTURAPI'),
(1914, '21', '13', '05', 'OLLARAYA'),
(1915, '21', '13', '06', 'TINICACHI'),
(1916, '21', '13', '07', 'UNICACHI'),
(1917, '22', '00', '00', 'SAN MARTIN'),
(1918, '22', '01', '00', 'MOYOBAMBA'),
(1919, '22', '01', '01', 'MOYOBAMBA'),
(1920, '22', '01', '02', 'CALZADA'),
(1921, '22', '01', '03', 'HABANA'),
(1922, '22', '01', '04', 'JEPELACIO'),
(1923, '22', '01', '05', 'SORITOR'),
(1924, '22', '01', '06', 'YANTALO'),
(1925, '22', '02', '00', 'BELLAVISTA'),
(1926, '22', '02', '01', 'BELLAVISTA'),
(1927, '22', '02', '02', 'ALTO BIAVO'),
(1928, '22', '02', '03', 'BAJO BIAVO'),
(1929, '22', '02', '04', 'HUALLAGA'),
(1930, '22', '02', '05', 'SAN PABLO'),
(1931, '22', '02', '06', 'SAN RAFAEL'),
(1932, '22', '03', '00', 'EL DORADO'),
(1933, '22', '03', '01', 'SAN JOSE DE SISA'),
(1934, '22', '03', '02', 'AGUA BLANCA'),
(1935, '22', '03', '03', 'SAN MARTIN'),
(1936, '22', '03', '04', 'SANTA ROSA'),
(1937, '22', '03', '05', 'SHATOJA'),
(1938, '22', '04', '00', 'HUALLAGA'),
(1939, '22', '04', '01', 'SAPOSOA'),
(1940, '22', '04', '02', 'ALTO SAPOSOA'),
(1941, '22', '04', '03', 'EL ESLABON'),
(1942, '22', '04', '04', 'PISCOYACU'),
(1943, '22', '04', '05', 'SACANCHE'),
(1944, '22', '04', '06', 'TINGO DE SAPOSOA'),
(1945, '22', '05', '00', 'LAMAS'),
(1946, '22', '05', '01', 'LAMAS'),
(1947, '22', '05', '02', 'ALONSO DE ALVARADO'),
(1948, '22', '05', '03', 'BARRANQUITA'),
(1949, '22', '05', '04', 'CAYNARACHI'),
(1950, '22', '05', '05', 'CUÑUMBUQUI'),
(1951, '22', '05', '06', 'PINTO RECODO'),
(1952, '22', '05', '07', 'RUMISAPA'),
(1953, '22', '05', '08', 'SAN ROQUE DE CUMBAZA'),
(1954, '22', '05', '09', 'SHANAO'),
(1955, '22', '05', '10', 'TABALOSOS'),
(1956, '22', '05', '11', 'ZAPATERO'),
(1957, '22', '06', '00', 'MARISCAL CACERES'),
(1958, '22', '06', '01', 'JUANJUI'),
(1959, '22', '06', '02', 'CAMPANILLA'),
(1960, '22', '06', '03', 'HUICUNGO'),
(1961, '22', '06', '04', 'PACHIZA'),
(1962, '22', '06', '05', 'PAJARILLO'),
(1963, '22', '07', '00', 'PICOTA'),
(1964, '22', '07', '01', 'PICOTA'),
(1965, '22', '07', '02', 'BUENOS AIRES'),
(1966, '22', '07', '03', 'CASPISAPA'),
(1967, '22', '07', '04', 'PILLUANA'),
(1968, '22', '07', '05', 'PUCACACA'),
(1969, '22', '07', '06', 'SAN CRISTOBAL'),
(1970, '22', '07', '07', 'SAN HILARION'),
(1971, '22', '07', '08', 'SHAMBOYACU'),
(1972, '22', '07', '09', 'TINGO DE PONASA'),
(1973, '22', '07', '10', 'TRES UNIDOS'),
(1974, '22', '08', '00', 'RIOJA'),
(1975, '22', '08', '01', 'RIOJA'),
(1976, '22', '08', '02', 'AWAJUN'),
(1977, '22', '08', '03', 'ELIAS SOPLIN VARGAS'),
(1978, '22', '08', '04', 'NUEVA CAJAMARCA'),
(1979, '22', '08', '05', 'PARDO MIGUEL'),
(1980, '22', '08', '06', 'POSIC'),
(1981, '22', '08', '07', 'SAN FERNANDO'),
(1982, '22', '08', '08', 'YORONGOS'),
(1983, '22', '08', '09', 'YURACYACU'),
(1984, '22', '09', '00', 'SAN MARTIN'),
(1985, '22', '09', '01', 'TARAPOTO'),
(1986, '22', '09', '02', 'ALBERTO LEVEAU'),
(1987, '22', '09', '03', 'CACATACHI'),
(1988, '22', '09', '04', 'CHAZUTA'),
(1989, '22', '09', '05', 'CHIPURANA'),
(1990, '22', '09', '06', 'EL PORVENIR'),
(1991, '22', '09', '07', 'HUIMBAYOC'),
(1992, '22', '09', '08', 'JUAN GUERRA'),
(1993, '22', '09', '09', 'LA BANDA DE SHILCAYO'),
(1994, '22', '09', '10', 'MORALES'),
(1995, '22', '09', '11', 'PAPAPLAYA'),
(1996, '22', '09', '12', 'SAN ANTONIO'),
(1997, '22', '09', '13', 'SAUCE'),
(1998, '22', '09', '14', 'SHAPAJA'),
(1999, '22', '10', '00', 'TOCACHE'),
(2000, '22', '10', '01', 'TOCACHE'),
(2001, '22', '10', '02', 'NUEVO PROGRESO'),
(2002, '22', '10', '03', 'POLVORA'),
(2003, '22', '10', '04', 'SHUNTE'),
(2004, '22', '10', '05', 'UCHIZA'),
(2005, '23', '00', '00', 'TACNA'),
(2006, '23', '01', '00', 'TACNA'),
(2007, '23', '01', '01', 'TACNA'),
(2008, '23', '01', '02', 'ALTO DE LA ALIANZA'),
(2009, '23', '01', '03', 'CALANA'),
(2010, '23', '01', '04', 'CIUDAD NUEVA'),
(2011, '23', '01', '05', 'INCLAN'),
(2012, '23', '01', '06', 'PACHIA'),
(2013, '23', '01', '07', 'PALCA'),
(2014, '23', '01', '08', 'POCOLLAY'),
(2015, '23', '01', '09', 'SAMA'),
(2016, '23', '01', '10', 'CORONEL GREGORIO ALBARRACÍN L'),
(2017, '23', '02', '00', 'CANDARAVE'),
(2018, '23', '02', '01', 'CANDARAVE'),
(2019, '23', '02', '02', 'CAIRANI'),
(2020, '23', '02', '03', 'CAMILACA'),
(2021, '23', '02', '04', 'CURIBAYA'),
(2022, '23', '02', '05', 'HUANUARA'),
(2023, '23', '02', '06', 'QUILAHUANI'),
(2024, '23', '03', '00', 'JORGE BASADRE'),
(2025, '23', '03', '01', 'LOCUMBA'),
(2026, '23', '03', '02', 'ILABAYA'),
(2027, '23', '03', '03', 'ITE'),
(2028, '23', '04', '00', 'TARATA'),
(2029, '23', '04', '01', 'TARATA'),
(2030, '23', '04', '02', 'CHUCATAMANI'),
(2031, '23', '04', '03', 'ESTIQUE'),
(2032, '23', '04', '04', 'ESTIQUE-PAMPA'),
(2033, '23', '04', '05', 'SITAJARA'),
(2034, '23', '04', '06', 'SUSAPAYA'),
(2035, '23', '04', '07', 'TARUCACHI'),
(2036, '23', '04', '08', 'TICACO'),
(2037, '24', '00', '00', 'TUMBES'),
(2038, '24', '01', '00', 'TUMBES'),
(2039, '24', '01', '01', 'TUMBES'),
(2040, '24', '01', '02', 'CORRALES'),
(2041, '24', '01', '03', 'LA CRUZ'),
(2042, '24', '01', '04', 'PAMPAS DE HOSPITAL'),
(2043, '24', '01', '05', 'SAN JACINTO'),
(2044, '24', '01', '06', 'SAN JUAN DE LA VIRGEN'),
(2045, '24', '02', '00', 'CONTRALMIRANTE VILLAR'),
(2046, '24', '02', '01', 'ZORRITOS'),
(2047, '24', '02', '02', 'CASITAS'),
(2048, '24', '02', '03', 'CANOAS DE PUNTA SAL'),
(2049, '24', '03', '00', 'ZARUMILLA'),
(2050, '24', '03', '01', 'ZARUMILLA'),
(2051, '24', '03', '02', 'AGUAS VERDES'),
(2052, '24', '03', '03', 'MATAPALO'),
(2053, '24', '03', '04', 'PAPAYAL'),
(2054, '25', '00', '00', 'UCAYALI'),
(2055, '25', '01', '00', 'CORONEL PORTILLO'),
(2056, '25', '01', '01', 'CALLARIA'),
(2057, '25', '01', '02', 'CAMPOVERDE'),
(2058, '25', '01', '03', 'IPARIA'),
(2059, '25', '01', '04', 'MASISEA'),
(2060, '25', '01', '05', 'YARINACOCHA'),
(2061, '25', '01', '06', 'NUEVA REQUENA'),
(2062, '25', '01', '07', 'MANANTAY'),
(2063, '25', '02', '00', 'ATALAYA'),
(2064, '25', '02', '01', 'RAYMONDI'),
(2065, '25', '02', '02', 'SEPAHUA'),
(2066, '25', '02', '03', 'TAHUANIA'),
(2067, '25', '02', '04', 'YURUA'),
(2068, '25', '03', '00', 'PADRE ABAD'),
(2069, '25', '03', '01', 'PADRE ABAD'),
(2070, '25', '03', '02', 'IRAZOLA'),
(2071, '25', '03', '03', 'CURIMANA'),
(2072, '25', '04', '00', 'PURUS'),
(2073, '25', '04', '01', 'PURUS'),
(2074, '99', '00', '00', 'EXTRANJERO'),
(2075, '99', '99', '00', 'EXTRANJERO'),
(2076, '99', '99', '99', 'EXTRANJERO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `is_enabled`, `created_at`, `updated_at`) VALUES
(1, 'Admin Usuario', 'admin@example.com', NULL, '$2y$12$1HlGmMzDtit03XChNUfyh.2V1gpHtzwN/BdsJX4XRBvg/b0BGECd2', NULL, 1, '2025-05-21 20:07:04', '2025-05-22 01:08:35'),
(28, 'Usuario Admin', 'admin2@example.com', NULL, '$2y$12$8ePhhpuzwlybMUr9v18TgecUtCNW4N.1w5521aFJxSwBfK1dO34Oe', NULL, 1, '2025-06-04 03:00:25', '2025-06-04 03:00:25'),
(29, 'AlexanderFitgh', 'shinji@gmail.com', NULL, '$2y$12$GmHHsqbKf5SzTFsy.FKIVObmV1iy6H9mhUJH3gg6jvrs0OJrXFBee', NULL, 1, '2025-06-04 06:05:50', '2025-06-04 06:05:50'),
(31, 'Jonas', 'akdkre@gmail.com', NULL, '$2y$12$kUGXM6nNttS56LTXuWv6DeYko29OKB4ljrUIlLanp7PNqug4bSXnq', NULL, 1, '2025-06-04 06:18:50', '2025-06-04 06:18:50'),
(32, 'Test User', 'test@example.com', '2025-06-05 23:59:56', '$2y$12$LSvxM6fDnM5sPphz02V7F.f9lMK9HHPnio9Ky1TMxWK7K1X3lhMYm', 'u0CJ3CuGQu', 1, '2025-06-05 23:59:56', '2025-06-05 23:59:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_addresses`
--

CREATE TABLE `user_addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(255) NOT NULL DEFAULT 'Casa',
  `city` varchar(255) NOT NULL,
  `province` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) NOT NULL DEFAULT 'Perú',
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_addresses`
--

INSERT INTO `user_addresses` (`id`, `user_id`, `label`, `city`, `province`, `department`, `postal_code`, `country`, `is_default`, `created_at`, `updated_at`) VALUES
(1, 32, 'dfb vdfsbvfds', '1337', '1333', '1264', '32142345', 'Perú', 1, '2025-06-06 20:48:07', '2025-06-06 20:48:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_clientes`
--

CREATE TABLE `user_clientes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombres` varchar(255) NOT NULL,
  `apellidos` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('masculino','femenino','otro') DEFAULT NULL,
  `tipo_documento_id` bigint(20) UNSIGNED NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `cliente_facturacion_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Referencia a tabla clientes para facturación',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `verification_token` text DEFAULT NULL,
  `verification_code` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_clientes`
--

INSERT INTO `user_clientes` (`id`, `nombres`, `apellidos`, `email`, `telefono`, `fecha_nacimiento`, `genero`, `tipo_documento_id`, `numero_documento`, `password`, `email_verified_at`, `remember_token`, `foto`, `estado`, `cliente_facturacion_id`, `created_at`, `updated_at`, `verification_token`, `verification_code`) VALUES
(1, 'sdvc', 'sacd', 'yarlquerodrigo9@gmail.com', '993321920', NULL, NULL, 1, '77425200', '$2y$12$sW9HbRC8MkPJuvVTTEGriefLX9vnXrYGa3gNwUz4EmGDgKAoHcuNy', NULL, NULL, NULL, 1, NULL, '2025-06-19 01:26:49', '2025-06-19 01:26:49', NULL, NULL),
(2, 'EMER RODRIGO', 'YARLEQUE ZAPATA', 'rodrigoyarleque7@gmail.com', '+51 993 321 920', NULL, NULL, 1, '77426200', '$2y$12$Glm8qCfKZW7c0jZFcEpMNe0Db7ghLij15bXGveNwS/sRgWUgnM3oe', '2025-07-30 23:25:50', NULL, NULL, 1, NULL, '2025-06-19 02:06:06', '2025-08-01 22:06:03', NULL, NULL),
(5, 'PAOLO ANDRE', 'RABANAL ACUÑA', 'kiyotakahitori@gmail.com', '+51 993 321 920', NULL, NULL, 1, '72426200', '$2y$12$8ZhQ2Ja9Rk2FmzKcKsj6huAV4GnT/1PAZZjPsc4KHUqodH.jtRebS', NULL, NULL, NULL, 1, NULL, '2025-06-24 00:49:03', '2025-06-24 00:49:03', NULL, NULL),
(6, 'ROSMERY', 'ALMONTE QUISPE', 'shin53sakamo@gmail.com', '993321920', NULL, NULL, 1, '77430029', '$2y$12$hAqmjLgTzWa1fYNCDuqdyOStAA7V6XubnzWlYRvcXKJqwoC7OSWMC', '2025-07-30 22:13:33', NULL, NULL, 1, NULL, '2025-07-30 22:12:25', '2025-07-30 22:13:33', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_cliente_direcciones`
--

CREATE TABLE `user_cliente_direcciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_cliente_id` bigint(20) UNSIGNED NOT NULL,
  `nombre_destinatario` varchar(255) NOT NULL,
  `direccion_completa` text NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_ubigeo` varchar(6) DEFAULT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `predeterminada` tinyint(1) NOT NULL DEFAULT 0,
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_cliente_direcciones`
--

INSERT INTO `user_cliente_direcciones` (`id`, `user_cliente_id`, `nombre_destinatario`, `direccion_completa`, `telefono`, `id_ubigeo`, `referencia`, `codigo_postal`, `predeterminada`, `activa`, `created_at`, `updated_at`) VALUES
(1, 1, 'sdvc sacd', 'sax', NULL, NULL, NULL, NULL, 1, 1, '2025-06-19 01:26:49', '2025-06-19 01:26:49'),
(2, 2, 'EMER RODRIGO YARLEQUE ZAPATA', 'asdcx<zx<', NULL, '1', NULL, NULL, 0, 1, '2025-06-19 02:06:06', '2025-08-22 14:18:18'),
(3, 5, 'PAOLO ANDRE RABANAL ACUÑA', 'vdsbfbfsbgf', NULL, '830', NULL, NULL, 1, 1, '2025-06-24 00:49:03', '2025-06-24 00:49:03'),
(4, 6, 'ROSMERY ALMONTE QUISPE', 'zcsxvs', NULL, '1316', NULL, NULL, 1, 1, '2025-07-30 22:12:25', '2025-07-30 22:12:25'),
(6, 2, 'emer', '2 de mayo', '993321920', '1316', NULL, NULL, 1, 1, '2025-08-02 15:27:20', '2025-08-22 12:33:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_horarios`
--

CREATE TABLE `user_horarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `dia_semana` enum('lunes','martes','miercoles','jueves','viernes','sabado','domingo') NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `es_descanso` tinyint(1) DEFAULT 0,
  `fecha_especial` date DEFAULT NULL,
  `comentarios` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name_father` varchar(255) DEFAULT NULL,
  `last_name_mother` varchar(255) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `document_type` varchar(10) NOT NULL,
  `document_number` varchar(20) NOT NULL,
  `birth_date` date NOT NULL,
  `genero` enum('masculino','femenino','otro') NOT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `first_name`, `last_name_father`, `last_name_mother`, `phone`, `document_type`, `document_number`, `birth_date`, `genero`, `avatar_url`, `created_at`, `updated_at`) VALUES
(1, 32, 'dfgvdsv', 'sdfvfsdvdf', 'vdfvdfs', '464536456', '3', '+652165', '2025-06-06', 'masculino', '/storage/avatars/avatar_32_1749224885.jpg', '2025-06-06 20:48:07', '2025-06-06 20:48:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `codigo_venta` varchar(20) NOT NULL,
  `cliente_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_cliente_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Cliente del e-commerce',
  `fecha_venta` datetime NOT NULL,
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Sin IGV',
  `igv` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','FACTURADO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `comprobante_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Comprobante generado',
  `requiere_factura` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cliente pidió factura',
  `metodo_pago` varchar(50) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Usuario que registró (puede ser null para ventas web)',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_detalles`
--

CREATE TABLE `venta_detalles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `venta_id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `codigo_producto` varchar(100) NOT NULL,
  `nombre_producto` varchar(255) NOT NULL,
  `descripcion_producto` text DEFAULT NULL,
  `cantidad` decimal(12,4) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL COMMENT 'Precio unitario con IGV',
  `precio_sin_igv` decimal(12,2) NOT NULL COMMENT 'Precio unitario sin IGV',
  `descuento_unitario` decimal(12,2) NOT NULL DEFAULT 0.00,
  `subtotal_linea` decimal(12,2) NOT NULL COMMENT 'cantidad * precio_sin_igv - descuento',
  `igv_linea` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_linea` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banners_activo_orden_index` (`activo`,`orden`);

--
-- Indices de la tabla `banners_promocionales`
--
ALTER TABLE `banners_promocionales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activo_orden` (`activo`,`orden`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_user_id_foreign` (`user_id`),
  ADD KEY `cart_items_user_cliente_id_foreign` (`user_cliente_id`),
  ADD KEY `cart_items_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_categoria_seccion` (`id_seccion`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_documento` (`numero_documento`),
  ADD KEY `idx_tipo_documento` (`tipo_documento`),
  ADD KEY `idx_numero_documento` (`numero_documento`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_activo` (`activo`);

--
-- Indices de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_serie_correlativo` (`serie`,`correlativo`),
  ADD KEY `idx_numero_completo` (`numero_completo`),
  ADD KEY `idx_cliente_id` (`cliente_id`),
  ADD KEY `idx_fecha_emision` (`fecha_emision`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_tipo_comprobante` (`tipo_comprobante`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `fk_comprobantes_referencia_id` (`comprobante_referencia_id`);

--
-- Indices de la tabla `comprobante_detalles`
--
ALTER TABLE `comprobante_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_comprobante_id` (`comprobante_id`),
  ADD KEY `idx_producto_id` (`producto_id`),
  ADD KEY `idx_item` (`comprobante_id`,`item`);

--
-- Indices de la tabla `cupones`
--
ALTER TABLE `cupones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `document_types`
--
ALTER TABLE `document_types`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empresa_info`
--
ALTER TABLE `empresa_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ruc` (`ruc`);

--
-- Indices de la tabla `estados_pedido`
--
ALTER TABLE `estados_pedido`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `marcas_productos`
--
ALTER TABLE `marcas_productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `marcas_productos_nombre_unique` (`nombre`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indices de la tabla `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indices de la tabla `ofertas`
--
ALTER TABLE `ofertas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tipo_oferta_id` (`tipo_oferta_id`),
  ADD KEY `idx_ofertas_principal` (`es_oferta_principal`,`activo`,`fecha_inicio`,`fecha_fin`);

--
-- Indices de la tabla `ofertas_productos`
--
ALTER TABLE `ofertas_productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `oferta_producto_unique` (`oferta_id`,`producto_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pedidos_codigo_pedido_unique` (`codigo_pedido`),
  ADD KEY `pedidos_cliente_id_index` (`cliente_id`),
  ADD KEY `pedidos_user_cliente_id_index` (`user_cliente_id`),
  ADD KEY `pedidos_estado_pedido_id_index` (`estado_pedido_id`),
  ADD KEY `pedidos_fecha_pedido_index` (`fecha_pedido`),
  ADD KEY `pedidos_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pedido_detalles_pedido_id_index` (`pedido_id`),
  ADD KEY `pedido_detalles_producto_id_index` (`producto_id`);

--
-- Indices de la tabla `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_producto` (`codigo_producto`),
  ADD KEY `categoria_id` (`categoria_id`),
  ADD KEY `productos_marca_id_index` (`marca_id`);

--
-- Indices de la tabla `producto_detalles`
--
ALTER TABLE `producto_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_detalles_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_nombre_unique` (`name`);

--
-- Indices de la tabla `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indices de la tabla `secciones`
--
ALTER TABLE `secciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `series_comprobantes`
--
ALTER TABLE `series_comprobantes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_tipo_serie` (`tipo_comprobante`,`serie`),
  ADD KEY `idx_tipo_comprobante` (`tipo_comprobante`),
  ADD KEY `idx_activo` (`activo`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `tipos_ofertas`
--
ALTER TABLE `tipos_ofertas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ubigeo_inei`
--
ALTER TABLE `ubigeo_inei`
  ADD PRIMARY KEY (`id_ubigeo`) USING BTREE;

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indices de la tabla `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_addresses_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `user_clientes`
--
ALTER TABLE `user_clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `numero_documento` (`numero_documento`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_numero_documento` (`numero_documento`),
  ADD KEY `idx_tipo_documento` (`tipo_documento_id`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_cliente_facturacion` (`cliente_facturacion_id`);

--
-- Indices de la tabla `user_cliente_direcciones`
--
ALTER TABLE `user_cliente_direcciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_cliente_id` (`user_cliente_id`),
  ADD KEY `idx_predeterminada` (`predeterminada`),
  ADD KEY `idx_activa` (`activa`),
  ADD KEY `idx_ubigeo` (`id_ubigeo`);

--
-- Indices de la tabla `user_horarios`
--
ALTER TABLE `user_horarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_horarios_user_dia` (`user_id`,`dia_semana`),
  ADD KEY `idx_user_horarios_fecha_especial` (`fecha_especial`),
  ADD KEY `idx_user_horarios_activo` (`activo`),
  ADD KEY `idx_user_horarios_disponibilidad` (`user_id`,`dia_semana`,`activo`);

--
-- Indices de la tabla `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_profiles_document_number_unique` (`document_number`),
  ADD KEY `user_profiles_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_venta` (`codigo_venta`),
  ADD KEY `idx_codigo_venta` (`codigo_venta`),
  ADD KEY `idx_cliente_id` (`cliente_id`),
  ADD KEY `idx_fecha_venta` (`fecha_venta`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_comprobante_id` (`comprobante_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_user_cliente_id` (`user_cliente_id`);

--
-- Indices de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_venta_id` (`venta_id`),
  ADD KEY `idx_producto_id` (`producto_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `banners`
--
ALTER TABLE `banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `banners_promocionales`
--
ALTER TABLE `banners_promocionales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comprobante_detalles`
--
ALTER TABLE `comprobante_detalles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cupones`
--
ALTER TABLE `cupones`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `document_types`
--
ALTER TABLE `document_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `empresa_info`
--
ALTER TABLE `empresa_info`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `estados_pedido`
--
ALTER TABLE `estados_pedido`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcas_productos`
--
ALTER TABLE `marcas_productos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `ofertas`
--
ALTER TABLE `ofertas`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ofertas_productos`
--
ALTER TABLE `ofertas_productos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `producto_detalles`
--
ALTER TABLE `producto_detalles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `secciones`
--
ALTER TABLE `secciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `series_comprobantes`
--
ALTER TABLE `series_comprobantes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tipos_ofertas`
--
ALTER TABLE `tipos_ofertas`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `user_clientes`
--
ALTER TABLE `user_clientes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `user_cliente_direcciones`
--
ALTER TABLE `user_cliente_direcciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `user_horarios`
--
ALTER TABLE `user_horarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD CONSTRAINT `fk_categoria_seccion` FOREIGN KEY (`id_seccion`) REFERENCES `secciones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `fk_clientes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD CONSTRAINT `fk_comprobantes_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_comprobantes_referencia_id` FOREIGN KEY (`comprobante_referencia_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_comprobantes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `comprobante_detalles`
--
ALTER TABLE `comprobante_detalles`
  ADD CONSTRAINT `fk_detalles_comprobante_id` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ofertas`
--
ALTER TABLE `ofertas`
  ADD CONSTRAINT `ofertas_ibfk_1` FOREIGN KEY (`tipo_oferta_id`) REFERENCES `tipos_ofertas` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `ofertas_productos`
--
ALTER TABLE `ofertas_productos`
  ADD CONSTRAINT `ofertas_productos_ibfk_1` FOREIGN KEY (`oferta_id`) REFERENCES `ofertas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ofertas_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_estado_pedido_id_foreign` FOREIGN KEY (`estado_pedido_id`) REFERENCES `estados_pedido` (`id`),
  ADD CONSTRAINT `pedidos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  ADD CONSTRAINT `pedido_detalles_pedido_id_foreign` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pedido_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `productos_marca_id_foreign` FOREIGN KEY (`marca_id`) REFERENCES `marcas_productos` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `producto_detalles`
--
ALTER TABLE `producto_detalles`
  ADD CONSTRAINT `producto_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD CONSTRAINT `user_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `user_clientes`
--
ALTER TABLE `user_clientes`
  ADD CONSTRAINT `fk_user_clientes_cliente_facturacion` FOREIGN KEY (`cliente_facturacion_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_clientes_tipo_documento` FOREIGN KEY (`tipo_documento_id`) REFERENCES `document_types` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `user_cliente_direcciones`
--
ALTER TABLE `user_cliente_direcciones`
  ADD CONSTRAINT `fk_user_cliente_direcciones_user_cliente` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `user_horarios`
--
ALTER TABLE `user_horarios`
  ADD CONSTRAINT `fk_user_horarios_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `user_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_ventas_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ventas_comprobante_id` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ventas_user_cliente_id` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ventas_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD CONSTRAINT `fk_venta_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_venta_detalles_venta_id` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
