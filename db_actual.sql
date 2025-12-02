-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 173.249.36.119    Database: ecommerce_bak_magus
-- ------------------------------------------------------
-- Server version	5.5.5-10.5.27-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `arma_pc_configuracion`
--

DROP TABLE IF EXISTS `arma_pc_configuracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arma_pc_configuracion` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `categoria_id` bigint(20) unsigned NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 1,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `nombre_paso` varchar(255) NOT NULL DEFAULT '',
  `descripcion_paso` text DEFAULT NULL,
  `es_requerido` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `arma_pc_configuracion_categoria_id_unique` (`categoria_id`) USING BTREE,
  KEY `arma_pc_configuracion_activo_orden_index` (`activo`,`orden`) USING BTREE,
  KEY `arma_pc_configuracion_categoria_id_foreign` (`categoria_id`) USING BTREE,
  CONSTRAINT `arma_pc_configuracion_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arma_pc_configuracion`
--

LOCK TABLES `arma_pc_configuracion` WRITE;
/*!40000 ALTER TABLE `arma_pc_configuracion` DISABLE KEYS */;
INSERT INTO `arma_pc_configuracion` VALUES (7,19,1,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 1','Selecciona un componente de esta categoría',1),(8,18,2,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 2','Selecciona un componente de esta categoría',1),(9,20,3,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 3','Selecciona un componente de esta categoría',1),(10,11,4,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 4','Selecciona un componente de esta categoría',1),(11,13,5,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 5','Selecciona un componente de esta categoría',1),(12,23,6,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 6','Selecciona un componente de esta categoría',1),(13,21,7,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 7','Selecciona un componente de esta categoría',1),(14,17,8,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 8','Selecciona un componente de esta categoría',1),(15,22,9,1,'2025-10-14 07:18:21','2025-10-14 07:18:21','Paso 9','Selecciona un componente de esta categoría',1);
/*!40000 ALTER TABLE `arma_pc_configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_sunat`
--

DROP TABLE IF EXISTS `auditoria_sunat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_sunat` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint(20) unsigned NOT NULL,
  `tipo_operacion` enum('EMISION','CONSULTA','RESUMEN','BAJA') NOT NULL,
  `entidad_tipo` varchar(50) DEFAULT NULL,
  `entidad_id` bigint(20) unsigned DEFAULT NULL,
  `entidad_referencia` varchar(100) DEFAULT NULL,
  `endpoint_url` varchar(500) DEFAULT NULL,
  `request_headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`request_headers`)),
  `request_body` longtext DEFAULT NULL,
  `response_status` int(11) DEFAULT NULL,
  `response_headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response_headers`)),
  `response_body` longtext DEFAULT NULL,
  `response_time_ms` int(10) unsigned DEFAULT NULL,
  `exitoso` tinyint(1) DEFAULT 0,
  `codigo_sunat` varchar(10) DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `intento` tinyint(3) unsigned DEFAULT 1,
  `ip_address` varchar(45) DEFAULT NULL,
  `usuario_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_tipo_operacion` (`tipo_operacion`),
  KEY `idx_entidad` (`entidad_tipo`,`entidad_id`),
  KEY `idx_exitoso` (`exitoso`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_usuario_id` (`usuario_id`),
  CONSTRAINT `auditoria_sunat_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_auditoria_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresa_info` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_sunat`
--

LOCK TABLES `auditoria_sunat` WRITE;
/*!40000 ALTER TABLE `auditoria_sunat` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_sunat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bajas`
--

DROP TABLE IF EXISTS `bajas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bajas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint(20) unsigned NOT NULL,
  `fecha_baja` date NOT NULL,
  `fecha_generacion` date NOT NULL,
  `correlativo` int(10) unsigned NOT NULL,
  `identificador` varchar(30) NOT NULL,
  `ticket` varchar(50) DEFAULT NULL,
  `cantidad_comprobantes` int(10) unsigned DEFAULT NULL,
  `xml_path` varchar(500) DEFAULT NULL,
  `cdr_path` varchar(500) DEFAULT NULL,
  `estado` enum('PENDIENTE','ACEPTADO','RECHAZADO') DEFAULT 'PENDIENTE',
  `codigo_sunat` varchar(10) DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `fecha_procesamiento` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identificador` (`identificador`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_fecha_baja` (`fecha_baja`),
  KEY `idx_ticket` (`ticket`),
  KEY `idx_estado` (`estado`),
  KEY `idx_identificador` (`identificador`),
  CONSTRAINT `fk_bajas_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresa_info` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bajas`
--

LOCK TABLES `bajas` WRITE;
/*!40000 ALTER TABLE `bajas` DISABLE KEYS */;
/*!40000 ALTER TABLE `bajas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bajas_detalle`
--

DROP TABLE IF EXISTS `bajas_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bajas_detalle` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `baja_id` bigint(20) unsigned NOT NULL,
  `comprobante_id` bigint(20) unsigned NOT NULL,
  `tipo_comprobante` varchar(2) DEFAULT NULL,
  `serie` varchar(4) DEFAULT NULL,
  `numero` int(10) unsigned DEFAULT NULL,
  `motivo` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_baja` (`baja_id`),
  KEY `idx_comprobante` (`comprobante_id`),
  CONSTRAINT `bajas_detalle_ibfk_1` FOREIGN KEY (`baja_id`) REFERENCES `bajas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bajas_detalle_ibfk_2` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bajas_detalle`
--

LOCK TABLES `bajas_detalle` WRITE;
/*!40000 ALTER TABLE `bajas_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `bajas_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banner_oferta_producto`
--

DROP TABLE IF EXISTS `banner_oferta_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner_oferta_producto` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `banner_oferta_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `descuento_porcentaje` decimal(5,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_banner_producto` (`banner_oferta_id`,`producto_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `banner_oferta_producto_ibfk_1` FOREIGN KEY (`banner_oferta_id`) REFERENCES `banners_ofertas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `banner_oferta_producto_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner_oferta_producto`
--

LOCK TABLES `banner_oferta_producto` WRITE;
/*!40000 ALTER TABLE `banner_oferta_producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `banner_oferta_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `subtitulo` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `texto_boton` varchar(100) DEFAULT 'Explorar Tienda',
  `precio_desde` decimal(10,2) DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `enlace_url` varchar(500) DEFAULT '/shop',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0,
  `tipo_banner` enum('principal','horizontal','sidebar') NOT NULL DEFAULT 'principal' COMMENT 'Tipo de banner: principal (carrusel), horizontal (banners de página), sidebar (banners laterales verticales)',
  `posicion_horizontal` enum('debajo_ofertas_especiales','debajo_categorias','debajo_ventas_flash','sidebar_shop') DEFAULT NULL COMMENT 'Posición del banner: para horizontales (debajo_*) o para sidebar (sidebar_shop)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `banners_activo_orden_index` (`activo`,`orden`) USING BTREE,
  KEY `idx_banners_tipo_posicion` (`tipo_banner`,`posicion_horizontal`,`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
INSERT INTO `banners` VALUES (9,'Banner 1758895369674',NULL,NULL,'Ver más',NULL,'banners/1758889393_68d685b124ddc.webp','/product-details/15',1,1,'principal',NULL,'2025-09-26 05:23:13','2025-09-26 07:02:48'),(10,'Banner 1758889408145',NULL,NULL,'Ver más',NULL,'banners/1758889407_68d685bfb3406.webp','/shop',1,1,'principal',NULL,'2025-09-26 05:23:27','2025-09-26 05:23:27'),(13,'Banner 1758890742019',NULL,NULL,'Ver más',NULL,'banners/1758890743_68d68af718d53.png','/shop',1,1,'principal',NULL,'2025-09-26 05:45:43','2025-09-26 05:45:43'),(14,'Banner 1758890938835',NULL,NULL,'Ver más',NULL,'banners/1758890939_68d68bbb85b5c.png','/shop',1,1,'principal',NULL,'2025-09-26 05:46:44','2025-09-26 05:48:59'),(16,'Banner Debajo de Ofertas Especiales',NULL,NULL,'Ver más',NULL,'banners/1759616332_68e19d4c517d5.webp','/shop',1,2,'horizontal','debajo_ofertas_especiales','2025-10-04 15:18:52','2025-10-04 15:18:52'),(17,'Banner Debajo de Categorías',NULL,NULL,'Ver más',NULL,'banners/1759616415_68e19d9fb6722.webp','/shop',1,1,'horizontal','debajo_categorias','2025-10-04 15:20:15','2025-10-04 15:20:15'),(19,'Banner Sidebar Shop',NULL,NULL,'Ver más',NULL,'banners/1760324489_68ec6b89e3826.jpg','/shop',0,1,'sidebar','sidebar_shop','2025-10-12 20:01:29','2025-10-12 20:03:24'),(20,'Banner Sidebar Shop',NULL,NULL,'Ver más',NULL,'banners/1760324657_68ec6c3178d85.png','/shop',1,1,'sidebar','sidebar_shop','2025-10-12 20:04:17','2025-10-12 20:04:17');
/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners_flash_sales`
--

DROP TABLE IF EXISTS `banners_flash_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners_flash_sales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL DEFAULT '',
  `color_badge` varchar(7) DEFAULT '#DC2626' COMMENT 'Color hexadecimal del badge del nombre',
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `imagen` varchar(255) DEFAULT NULL COMMENT 'Imagen de fondo del banner flash sale',
  `color_boton` varchar(7) DEFAULT NULL COMMENT 'Color hexadecimal del botón',
  `texto_boton` varchar(100) DEFAULT 'Compra ahora',
  `enlace_url` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_activo_fechas` (`activo`,`fecha_inicio`,`fecha_fin`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners_flash_sales`
--

LOCK TABLES `banners_flash_sales` WRITE;
/*!40000 ALTER TABLE `banners_flash_sales` DISABLE KEYS */;
INSERT INTO `banners_flash_sales` VALUES (1,'POR EL DIA DEL GAMER','#DC2626','2025-11-18 02:08:00','2025-11-28 03:08:00','banners_flash_sales/ijvbgmCVscyBeFF1EL4wnBiO4MzY5Xu5ehezI8xI.png','#3B82F6','Compra ahora','https://magus-ecommerce.com/product-details/86',1,'2025-10-06 09:08:44','2025-11-18 14:05:38');
/*!40000 ALTER TABLE `banners_flash_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners_ofertas`
--

DROP TABLE IF EXISTS `banners_ofertas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners_ofertas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `imagen` varchar(255) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `prioridad` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners_ofertas`
--

LOCK TABLES `banners_ofertas` WRITE;
/*!40000 ALTER TABLE `banners_ofertas` DISABLE KEYS */;
INSERT INTO `banners_ofertas` VALUES (1,'banners-ofertas/cFJxs3BETAwRm9LXTLxiE682DWQrtl2CLFHd92KU.gif',1,1,'2025-10-03 09:18:37','2025-10-03 09:18:37');
/*!40000 ALTER TABLE `banners_ofertas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners_promocionales`
--

DROP TABLE IF EXISTS `banners_promocionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners_promocionales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `precio` decimal(8,2) DEFAULT NULL,
  `texto_boton` varchar(100) NOT NULL DEFAULT 'Comprar ahora',
  `imagen_url` varchar(500) DEFAULT NULL,
  `enlace_url` varchar(255) NOT NULL DEFAULT '/shop',
  `orden` int(11) NOT NULL DEFAULT 1,
  `animacion_delay` int(11) NOT NULL DEFAULT 400,
  `color_fondo` varchar(7) DEFAULT '#ffffff',
  `color_boton` varchar(7) DEFAULT '#0d6efd',
  `color_texto` varchar(7) DEFAULT '#212529',
  `color_badge_nombre` varchar(7) DEFAULT '#0d6efd',
  `color_badge_precio` varchar(7) DEFAULT '#28a745',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_activo_orden` (`activo`,`orden`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners_promocionales`
--

LOCK TABLES `banners_promocionales` WRITE;
/*!40000 ALTER TABLE `banners_promocionales` DISABLE KEYS */;
INSERT INTO `banners_promocionales` VALUES (2,'BARRA SONIDO RAZER',500.00,'Ir a la oferta','banners_promocionales/1758851690_68d5f26aac356.jpg','https://www.plazavea.com.pe/panaderia-y-pasteleria/pan-de-la-casa?srsltid=AfmBOoo9YK35mmSlRKy_JC302mvr-VBURC10nZC2iNz8dcDNSFqBIhL8',1,400,'#ffffff','#ff1100','#ffffff','#0d6efd','#28a745',1,'2025-06-07 11:49:44','2025-10-06 09:06:32'),(3,'LAPTOP ASUS TUF',300.00,'Ir a la oferta','banners_promocionales/1759245539_68dbf4e342d7f.jpg','/shop',1,300,'#ffea00','#fa0000','#000000','#0d6efd','#28a745',1,'2025-06-07 11:51:35','2025-10-06 08:49:08'),(4,'Teclado Razer',300.00,'Comprar ahora','banners_promocionales/1759766465_68e3e7c1ba405.jpg','/shop',1,300,'#ffffff','#0d6efd','#212529','#0d6efd','#28a745',1,'2025-06-07 11:53:48','2025-10-06 09:01:05'),(6,'GPU 4090',600.00,'Comprar ahora','banners_promocionales/1759766731_68e3e8cb034f3.jpg','/shop',1,400,'#ffffff','#0d6efd','#212529','#0d6efd','#28a745',1,'2025-06-07 12:49:36','2025-10-06 09:05:31');
/*!40000 ALTER TABLE `banners_promocionales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel_cache_recompensas_dashboard_2025-12-01-08','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:2;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:13;s:21:\"conversiones_por_tipo\";a:0:{}}}',1764600469),('laravel_cache_recompensas_estadisticas_2025-12-01-08','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:2;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";d:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:2;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:2:{i:0;O:8:\"stdClass\":5:{s:2:\"id\";i:42;s:6:\"nombre\";s:24:\"Descuento de Navidad 20%\";s:4:\"tipo\";s:9:\"descuento\";s:18:\"total_aplicaciones\";i:0;s:15:\"clientes_unicos\";i:0;}i:1;O:8:\"stdClass\":5:{s:2:\"id\";i:41;s:6:\"nombre\";s:24:\"Descuento de Navidad 20%\";s:4:\"tipo\";s:9:\"descuento\";s:18:\"total_aplicaciones\";i:0;s:15:\"clientes_unicos\";i:0;}}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-12-01T13:46:37.801760Z\";s:11:\"cache_hasta\";s:27:\"2025-12-01T15:46:37.802069Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1764603997),('laravel_cache_recompensas_tipos_disponibles','a:2:{s:5:\"tipos\";a:4:{i:0;a:4:{s:5:\"value\";s:6:\"puntos\";s:5:\"label\";s:17:\"Sistema de Puntos\";s:11:\"descripcion\";s:54:\"Acumula puntos por compras y canjéalos por beneficios\";s:20:\"campos_configuracion\";a:3:{i:0;a:6:{s:5:\"campo\";s:17:\"puntos_por_compra\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:32:\"Puntos otorgados por cada compra\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}i:1;a:6:{s:5:\"campo\";s:16:\"puntos_por_monto\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:27:\"Puntos por cada sol gastado\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}i:2;a:6:{s:5:\"campo\";s:15:\"puntos_registro\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:31:\"Puntos otorgados al registrarse\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}}}i:1;a:4:{s:5:\"value\";s:9:\"descuento\";s:5:\"label\";s:10:\"Descuentos\";s:11:\"descripcion\";s:48:\"Aplica descuentos por porcentaje o cantidad fija\";s:20:\"campos_configuracion\";a:3:{i:0;a:5:{s:5:\"campo\";s:14:\"tipo_descuento\";s:4:\"tipo\";s:4:\"enum\";s:8:\"opciones\";a:2:{i:0;s:10:\"porcentaje\";i:1;s:13:\"cantidad_fija\";}s:11:\"descripcion\";s:27:\"Tipo de descuento a aplicar\";s:9:\"requerido\";b:1;}i:1;a:6:{s:5:\"campo\";s:15:\"valor_descuento\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:19:\"Valor del descuento\";s:9:\"requerido\";b:1;s:3:\"min\";d:0.01;s:3:\"max\";d:9999.99;}i:2;a:6:{s:5:\"campo\";s:13:\"compra_minima\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:24:\"Compra mínima requerida\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}}}i:2;a:4:{s:5:\"value\";s:12:\"envio_gratis\";s:5:\"label\";s:15:\"Envío Gratuito\";s:11:\"descripcion\";s:51:\"Ofrece envío gratuito con condiciones específicas\";s:20:\"campos_configuracion\";a:2:{i:0;a:6:{s:5:\"campo\";s:13:\"minimo_compra\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:35:\"Compra mínima para envío gratuito\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}i:1;a:4:{s:5:\"campo\";s:16:\"zonas_aplicables\";s:4:\"tipo\";s:4:\"json\";s:11:\"descripcion\";s:37:\"Zonas donde aplica el envío gratuito\";s:9:\"requerido\";b:0;}}}i:3;a:4:{s:5:\"value\";s:6:\"regalo\";s:5:\"label\";s:19:\"Productos de Regalo\";s:11:\"descripcion\";s:41:\"Otorga productos específicos como regalo\";s:20:\"campos_configuracion\";a:2:{i:0;a:4:{s:5:\"campo\";s:11:\"producto_id\";s:4:\"tipo\";s:7:\"integer\";s:11:\"descripcion\";s:25:\"ID del producto a regalar\";s:9:\"requerido\";b:1;}i:1;a:6:{s:5:\"campo\";s:8:\"cantidad\";s:4:\"tipo\";s:7:\"integer\";s:11:\"descripcion\";s:31:\"Cantidad del producto a regalar\";s:9:\"requerido\";b:1;s:3:\"min\";i:1;s:3:\"max\";i:100;}}}}s:7:\"estados\";a:5:{i:0;a:3:{s:5:\"value\";s:10:\"programada\";s:5:\"label\";s:10:\"Programada\";s:11:\"descripcion\";s:32:\"Recompensa creada pero no activa\";}i:1;a:3:{s:5:\"value\";s:6:\"activa\";s:5:\"label\";s:6:\"Activa\";s:11:\"descripcion\";s:30:\"Recompensa activa y disponible\";}i:2;a:3:{s:5:\"value\";s:7:\"pausada\";s:5:\"label\";s:7:\"Pausada\";s:11:\"descripcion\";s:32:\"Recompensa temporalmente pausada\";}i:3;a:3:{s:5:\"value\";s:8:\"expirada\";s:5:\"label\";s:8:\"Expirada\";s:11:\"descripcion\";s:29:\"Recompensa expirada por fecha\";}i:4;a:3:{s:5:\"value\";s:9:\"cancelada\";s:5:\"label\";s:9:\"Cancelada\";s:11:\"descripcion\";s:36:\"Recompensa cancelada permanentemente\";}}}',1764683253),('laravel_cache_spatie.permission.cache','a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:298:{i:0;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:12:\"usuarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:1;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:15:\"usuarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:2;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:13:\"usuarios.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:3;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:13:\"usuarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:4;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:15:\"usuarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:5;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:13:\"productos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:6;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:16:\"productos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:7;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:14:\"productos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:8;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:14:\"productos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:9;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:16:\"productos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:10;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:14:\"categorias.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:11;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:17:\"categorias.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:12;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:15:\"categorias.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:13;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:15:\"categorias.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:14;a:4:{s:1:\"a\";i:29;s:1:\"b\";s:17:\"categorias.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:15;a:4:{s:1:\"a\";i:30;s:1:\"b\";s:11:\"banners.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:16;a:4:{s:1:\"a\";i:31;s:1:\"b\";s:14:\"banners.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:17;a:4:{s:1:\"a\";i:32;s:1:\"b\";s:12:\"banners.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:18;a:4:{s:1:\"a\";i:33;s:1:\"b\";s:14:\"banners.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:19;a:4:{s:1:\"a\";i:38;s:1:\"b\";s:25:\"banners_promocionales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:20;a:4:{s:1:\"a\";i:39;s:1:\"b\";s:28:\"banners_promocionales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:21;a:4:{s:1:\"a\";i:40;s:1:\"b\";s:26:\"banners_promocionales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:22;a:4:{s:1:\"a\";i:41;s:1:\"b\";s:28:\"banners_promocionales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:23;a:4:{s:1:\"a\";i:42;s:1:\"b\";s:12:\"clientes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:24;a:4:{s:1:\"a\";i:43;s:1:\"b\";s:15:\"clientes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:25;a:4:{s:1:\"a\";i:44;s:1:\"b\";s:13:\"clientes.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:26;a:4:{s:1:\"a\";i:45;s:1:\"b\";s:13:\"clientes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:27;a:4:{s:1:\"a\";i:46;s:1:\"b\";s:15:\"clientes.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:28;a:4:{s:1:\"a\";i:47;s:1:\"b\";s:13:\"marcas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:29;a:4:{s:1:\"a\";i:48;s:1:\"b\";s:13:\"marcas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:30;a:4:{s:1:\"a\";i:49;s:1:\"b\";s:11:\"marcas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:31;a:4:{s:1:\"a\";i:50;s:1:\"b\";s:10:\"marcas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:32;a:4:{s:1:\"a\";i:51;s:1:\"b\";s:14:\"pedidos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:33;a:4:{s:1:\"a\";i:52;s:1:\"b\";s:12:\"pedidos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:34;a:4:{s:1:\"a\";i:53;s:1:\"b\";s:12:\"pedidos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:35;a:4:{s:1:\"a\";i:54;s:1:\"b\";s:11:\"pedidos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:36;a:4:{s:1:\"a\";i:55;s:1:\"b\";s:16:\"secciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:37;a:4:{s:1:\"a\";i:56;s:1:\"b\";s:16:\"secciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:38;a:4:{s:1:\"a\";i:57;s:1:\"b\";s:14:\"secciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:39;a:4:{s:1:\"a\";i:58;s:1:\"b\";s:13:\"secciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:40;a:4:{s:1:\"a\";i:59;s:1:\"b\";s:11:\"cupones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:41;a:4:{s:1:\"a\";i:60;s:1:\"b\";s:12:\"cupones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:42;a:4:{s:1:\"a\";i:61;s:1:\"b\";s:12:\"cupones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:43;a:4:{s:1:\"a\";i:62;s:1:\"b\";s:14:\"cupones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:44;a:4:{s:1:\"a\";i:63;s:1:\"b\";s:14:\"cupones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:45;a:4:{s:1:\"a\";i:64;s:1:\"b\";s:11:\"ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:46;a:4:{s:1:\"a\";i:65;s:1:\"b\";s:12:\"ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:47;a:4:{s:1:\"a\";i:66;s:1:\"b\";s:12:\"ofertas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:48;a:4:{s:1:\"a\";i:67;s:1:\"b\";s:14:\"ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:49;a:4:{s:1:\"a\";i:68;s:1:\"b\";s:14:\"ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:50;a:4:{s:1:\"a\";i:69;s:1:\"b\";s:12:\"horarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:51;a:4:{s:1:\"a\";i:70;s:1:\"b\";s:15:\"horarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:52;a:4:{s:1:\"a\";i:71;s:1:\"b\";s:13:\"horarios.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:53;a:4:{s:1:\"a\";i:72;s:1:\"b\";s:13:\"horarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:54;a:4:{s:1:\"a\";i:73;s:1:\"b\";s:15:\"horarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:55;a:4:{s:1:\"a\";i:74;s:1:\"b\";s:16:\"empresa_info.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:56;a:4:{s:1:\"a\";i:75;s:1:\"b\";s:17:\"empresa_info.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:57;a:4:{s:1:\"a\";i:76;s:1:\"b\";s:17:\"envio_correos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:58;a:4:{s:1:\"a\";i:77;s:1:\"b\";s:18:\"envio_correos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:59;a:4:{s:1:\"a\";i:78;s:1:\"b\";s:12:\"reclamos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:60;a:4:{s:1:\"a\";i:79;s:1:\"b\";s:13:\"reclamos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:61;a:4:{s:1:\"a\";i:80;s:1:\"b\";s:13:\"reclamos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:62;a:4:{s:1:\"a\";i:81;s:1:\"b\";s:15:\"reclamos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:63;a:4:{s:1:\"a\";i:86;s:1:\"b\";s:16:\"cotizaciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:64;a:4:{s:1:\"a\";i:87;s:1:\"b\";s:17:\"cotizaciones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:65;a:4:{s:1:\"a\";i:88;s:1:\"b\";s:19:\"cotizaciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:66;a:4:{s:1:\"a\";i:89;s:1:\"b\";s:17:\"cotizaciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:67;a:4:{s:1:\"a\";i:90;s:1:\"b\";s:19:\"cotizaciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:68;a:4:{s:1:\"a\";i:91;s:1:\"b\";s:20:\"cotizaciones.aprobar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:69;a:4:{s:1:\"a\";i:92;s:1:\"b\";s:11:\"compras.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:70;a:4:{s:1:\"a\";i:93;s:1:\"b\";s:12:\"compras.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:71;a:4:{s:1:\"a\";i:94;s:1:\"b\";s:14:\"compras.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:72;a:4:{s:1:\"a\";i:95;s:1:\"b\";s:12:\"compras.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:73;a:4:{s:1:\"a\";i:96;s:1:\"b\";s:14:\"compras.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:74;a:4:{s:1:\"a\";i:97;s:1:\"b\";s:15:\"compras.aprobar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:75;a:4:{s:1:\"a\";i:98;s:1:\"b\";s:20:\"envio_correos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:76;a:4:{s:1:\"a\";i:99;s:1:\"b\";s:20:\"envio_correos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:77;a:4:{s:1:\"a\";i:100;s:1:\"b\";s:15:\"motorizados.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:78;a:4:{s:1:\"a\";i:101;s:1:\"b\";s:18:\"motorizados.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:79;a:4:{s:1:\"a\";i:102;s:1:\"b\";s:16:\"motorizados.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:80;a:4:{s:1:\"a\";i:103;s:1:\"b\";s:16:\"motorizados.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:81;a:4:{s:1:\"a\";i:104;s:1:\"b\";s:18:\"motorizados.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:82;a:4:{s:1:\"a\";i:105;s:1:\"b\";s:22:\"pedidos.motorizado.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:83;a:4:{s:1:\"a\";i:106;s:1:\"b\";s:22:\"pedidos.motorizado.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:84;a:4:{s:1:\"a\";i:107;s:1:\"b\";s:36:\"pedidos.motorizado.actualizar_estado\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:85;a:4:{s:1:\"a\";i:108;s:1:\"b\";s:36:\"pedidos.motorizado.actualizar_estado\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:86;a:4:{s:1:\"a\";i:109;s:1:\"b\";s:36:\"pedidos.motorizado.confirmar_entrega\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:87;a:4:{s:1:\"a\";i:110;s:1:\"b\";s:36:\"pedidos.motorizado.confirmar_entrega\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:88;a:4:{s:1:\"a\";i:111;s:1:\"b\";s:21:\"motorizado.perfil.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:89;a:4:{s:1:\"a\";i:112;s:1:\"b\";s:21:\"motorizado.perfil.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:90;a:4:{s:1:\"a\";i:113;s:1:\"b\";s:24:\"motorizado.perfil.editar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:91;a:4:{s:1:\"a\";i:114;s:1:\"b\";s:24:\"motorizado.perfil.editar\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:92;a:4:{s:1:\"a\";i:115;s:1:\"b\";s:20:\"motorizado.rutas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:93;a:4:{s:1:\"a\";i:116;s:1:\"b\";s:20:\"motorizado.rutas.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:94;a:4:{s:1:\"a\";i:117;s:1:\"b\";s:31:\"motorizado.ubicacion.actualizar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:95;a:4:{s:1:\"a\";i:118;s:1:\"b\";s:31:\"motorizado.ubicacion.actualizar\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:96;a:4:{s:1:\"a\";i:119;s:1:\"b\";s:27:\"motorizado.estadisticas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:97;a:4:{s:1:\"a\";i:120;s:1:\"b\";s:27:\"motorizado.estadisticas.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:98;a:4:{s:1:\"a\";i:121;s:1:\"b\";s:19:\"motorizado.chat.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:99;a:4:{s:1:\"a\";i:122;s:1:\"b\";s:19:\"motorizado.chat.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:100;a:4:{s:1:\"a\";i:123;s:1:\"b\";s:29:\"motorizado.notificaciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:101;a:4:{s:1:\"a\";i:124;s:1:\"b\";s:29:\"motorizado.notificaciones.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:102;a:4:{s:1:\"a\";i:125;s:1:\"b\";s:19:\"email_templates.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:103;a:4:{s:1:\"a\";i:126;s:1:\"b\";s:20:\"email_templates.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:104;a:4:{s:1:\"a\";i:127;s:1:\"b\";s:22:\"email_templates.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:105;a:4:{s:1:\"a\";i:128;s:1:\"b\";s:20:\"email_templates.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:106;a:4:{s:1:\"a\";i:129;s:1:\"b\";s:22:\"email_templates.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:107;a:4:{s:1:\"a\";i:130;s:1:\"b\";s:10:\"ventas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:108;a:4:{s:1:\"a\";i:131;s:1:\"b\";s:11:\"ventas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:109;a:4:{s:1:\"a\";i:132;s:1:\"b\";s:13:\"ventas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:110;a:4:{s:1:\"a\";i:133;s:1:\"b\";s:11:\"ventas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:111;a:4:{s:1:\"a\";i:134;s:1:\"b\";s:13:\"ventas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:112;a:4:{s:1:\"a\";i:135;s:1:\"b\";s:9:\"roles.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:113;a:4:{s:1:\"a\";i:136;s:1:\"b\";s:12:\"roles.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:114;a:4:{s:1:\"a\";i:137;s:1:\"b\";s:10:\"roles.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:115;a:4:{s:1:\"a\";i:138;s:1:\"b\";s:12:\"roles.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:116;a:4:{s:1:\"a\";i:139;s:1:\"b\";s:15:\"recompensas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:117;a:4:{s:1:\"a\";i:140;s:1:\"b\";s:18:\"recompensas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:118;a:4:{s:1:\"a\";i:141;s:1:\"b\";s:16:\"recompensas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:119;a:4:{s:1:\"a\";i:142;s:1:\"b\";s:16:\"recompensas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:120;a:4:{s:1:\"a\";i:143;s:1:\"b\";s:18:\"recompensas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:121;a:4:{s:1:\"a\";i:144;s:1:\"b\";s:20:\"recompensas.activate\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:122;a:4:{s:1:\"a\";i:145;s:1:\"b\";s:21:\"recompensas.analytics\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:123;a:4:{s:1:\"a\";i:146;s:1:\"b\";s:21:\"recompensas.segmentos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:124;a:4:{s:1:\"a\";i:147;s:1:\"b\";s:21:\"recompensas.productos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:125;a:4:{s:1:\"a\";i:148;s:1:\"b\";s:18:\"recompensas.puntos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:126;a:4:{s:1:\"a\";i:149;s:1:\"b\";s:22:\"recompensas.descuentos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:127;a:4:{s:1:\"a\";i:150;s:1:\"b\";s:18:\"recompensas.envios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:128;a:4:{s:1:\"a\";i:151;s:1:\"b\";s:19:\"recompensas.regalos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:129;a:4:{s:1:\"a\";i:152;s:1:\"b\";s:17:\"configuracion.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:130;a:4:{s:1:\"a\";i:153;s:1:\"b\";s:20:\"configuracion.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:131;a:4:{s:1:\"a\";i:154;s:1:\"b\";s:18:\"configuracion.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:132;a:4:{s:1:\"a\";i:155;s:1:\"b\";s:20:\"configuracion.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:133;a:4:{s:1:\"a\";i:156;s:1:\"b\";s:23:\"banners_flash_sales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:134;a:4:{s:1:\"a\";i:157;s:1:\"b\";s:26:\"banners_flash_sales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:135;a:4:{s:1:\"a\";i:158;s:1:\"b\";s:24:\"banners_flash_sales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:136;a:4:{s:1:\"a\";i:159;s:1:\"b\";s:26:\"banners_flash_sales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:137;a:4:{s:1:\"a\";i:160;s:1:\"b\";s:19:\"banners_ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:138;a:4:{s:1:\"a\";i:161;s:1:\"b\";s:22:\"banners_ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:139;a:4:{s:1:\"a\";i:162;s:1:\"b\";s:20:\"banners_ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:140;a:4:{s:1:\"a\";i:163;s:1:\"b\";s:22:\"banners_ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:141;a:4:{s:1:\"a\";i:164;s:1:\"b\";s:22:\"contabilidad.cajas.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:142;a:4:{s:1:\"a\";i:165;s:1:\"b\";s:25:\"contabilidad.cajas.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:143;a:4:{s:1:\"a\";i:166;s:1:\"b\";s:23:\"contabilidad.cajas.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:144;a:4:{s:1:\"a\";i:167;s:1:\"b\";s:23:\"contabilidad.kardex.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:145;a:4:{s:1:\"a\";i:168;s:1:\"b\";s:24:\"contabilidad.kardex.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:146;a:4:{s:1:\"a\";i:169;s:1:\"b\";s:20:\"contabilidad.cxc.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:147;a:4:{s:1:\"a\";i:170;s:1:\"b\";s:23:\"contabilidad.cxc.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:148;a:4:{s:1:\"a\";i:171;s:1:\"b\";s:21:\"contabilidad.cxc.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:149;a:4:{s:1:\"a\";i:172;s:1:\"b\";s:20:\"contabilidad.cxp.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:150;a:4:{s:1:\"a\";i:173;s:1:\"b\";s:23:\"contabilidad.cxp.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:151;a:4:{s:1:\"a\";i:174;s:1:\"b\";s:21:\"contabilidad.cxp.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:152;a:4:{s:1:\"a\";i:175;s:1:\"b\";s:28:\"contabilidad.proveedores.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:153;a:4:{s:1:\"a\";i:176;s:1:\"b\";s:31:\"contabilidad.proveedores.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:154;a:4:{s:1:\"a\";i:177;s:1:\"b\";s:29:\"contabilidad.proveedores.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:155;a:4:{s:1:\"a\";i:178;s:1:\"b\";s:27:\"contabilidad.caja_chica.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:156;a:4:{s:1:\"a\";i:179;s:1:\"b\";s:30:\"contabilidad.caja_chica.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:157;a:4:{s:1:\"a\";i:180;s:1:\"b\";s:28:\"contabilidad.caja_chica.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:158;a:4:{s:1:\"a\";i:181;s:1:\"b\";s:27:\"contabilidad.flujo_caja.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:159;a:4:{s:1:\"a\";i:182;s:1:\"b\";s:30:\"contabilidad.flujo_caja.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:160;a:4:{s:1:\"a\";i:183;s:1:\"b\";s:28:\"contabilidad.flujo_caja.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:161;a:4:{s:1:\"a\";i:184;s:1:\"b\";s:25:\"contabilidad.reportes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:162;a:4:{s:1:\"a\";i:185;s:1:\"b\";s:27:\"contabilidad.utilidades.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:163;a:4:{s:1:\"a\";i:186;s:1:\"b\";s:30:\"contabilidad.utilidades.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:164;a:4:{s:1:\"a\";i:187;s:1:\"b\";s:28:\"contabilidad.utilidades.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:165;a:4:{s:1:\"a\";i:188;s:1:\"b\";s:25:\"contabilidad.vouchers.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:166;a:4:{s:1:\"a\";i:189;s:1:\"b\";s:28:\"contabilidad.vouchers.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:167;a:4:{s:1:\"a\";i:190;s:1:\"b\";s:26:\"contabilidad.vouchers.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:168;a:4:{s:1:\"a\";i:191;s:1:\"b\";s:28:\"contabilidad.vouchers.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:169;a:4:{s:1:\"a\";i:192;s:1:\"b\";s:28:\"facturacion.comprobantes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:170;a:4:{s:1:\"a\";i:193;s:1:\"b\";s:28:\"facturacion.comprobantes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:171;a:4:{s:1:\"a\";i:194;s:1:\"b\";s:29:\"facturacion.comprobantes.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:172;a:4:{s:1:\"a\";i:195;s:1:\"b\";s:29:\"facturacion.comprobantes.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:173;a:4:{s:1:\"a\";i:196;s:1:\"b\";s:31:\"facturacion.comprobantes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:174;a:4:{s:1:\"a\";i:197;s:1:\"b\";s:31:\"facturacion.comprobantes.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:175;a:4:{s:1:\"a\";i:198;s:1:\"b\";s:29:\"facturacion.comprobantes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:176;a:4:{s:1:\"a\";i:199;s:1:\"b\";s:29:\"facturacion.comprobantes.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:177;a:4:{s:1:\"a\";i:200;s:1:\"b\";s:31:\"facturacion.comprobantes.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:178;a:4:{s:1:\"a\";i:201;s:1:\"b\";s:31:\"facturacion.comprobantes.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:179;a:4:{s:1:\"a\";i:202;s:1:\"b\";s:24:\"facturacion.facturas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:180;a:4:{s:1:\"a\";i:203;s:1:\"b\";s:24:\"facturacion.facturas.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:181;a:4:{s:1:\"a\";i:204;s:1:\"b\";s:25:\"facturacion.facturas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:182;a:4:{s:1:\"a\";i:205;s:1:\"b\";s:25:\"facturacion.facturas.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:183;a:4:{s:1:\"a\";i:206;s:1:\"b\";s:27:\"facturacion.facturas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:184;a:4:{s:1:\"a\";i:207;s:1:\"b\";s:27:\"facturacion.facturas.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:185;a:4:{s:1:\"a\";i:208;s:1:\"b\";s:25:\"facturacion.facturas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:186;a:4:{s:1:\"a\";i:209;s:1:\"b\";s:25:\"facturacion.facturas.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:187;a:4:{s:1:\"a\";i:210;s:1:\"b\";s:22:\"facturacion.series.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:188;a:4:{s:1:\"a\";i:211;s:1:\"b\";s:22:\"facturacion.series.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:189;a:4:{s:1:\"a\";i:212;s:1:\"b\";s:25:\"facturacion.series.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:190;a:4:{s:1:\"a\";i:213;s:1:\"b\";s:25:\"facturacion.series.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:191;a:4:{s:1:\"a\";i:214;s:1:\"b\";s:23:\"facturacion.series.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:192;a:4:{s:1:\"a\";i:215;s:1:\"b\";s:23:\"facturacion.series.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:193;a:4:{s:1:\"a\";i:216;s:1:\"b\";s:29:\"facturacion.notas_credito.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:194;a:4:{s:1:\"a\";i:217;s:1:\"b\";s:29:\"facturacion.notas_credito.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:195;a:4:{s:1:\"a\";i:218;s:1:\"b\";s:30:\"facturacion.notas_credito.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:196;a:4:{s:1:\"a\";i:219;s:1:\"b\";s:30:\"facturacion.notas_credito.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:197;a:4:{s:1:\"a\";i:220;s:1:\"b\";s:32:\"facturacion.notas_credito.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:198;a:4:{s:1:\"a\";i:221;s:1:\"b\";s:32:\"facturacion.notas_credito.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:199;a:4:{s:1:\"a\";i:222;s:1:\"b\";s:30:\"facturacion.notas_credito.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:200;a:4:{s:1:\"a\";i:223;s:1:\"b\";s:30:\"facturacion.notas_credito.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:201;a:4:{s:1:\"a\";i:224;s:1:\"b\";s:28:\"facturacion.notas_debito.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:202;a:4:{s:1:\"a\";i:225;s:1:\"b\";s:28:\"facturacion.notas_debito.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:203;a:4:{s:1:\"a\";i:226;s:1:\"b\";s:29:\"facturacion.notas_debito.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:204;a:4:{s:1:\"a\";i:227;s:1:\"b\";s:29:\"facturacion.notas_debito.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:205;a:4:{s:1:\"a\";i:228;s:1:\"b\";s:31:\"facturacion.notas_debito.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:206;a:4:{s:1:\"a\";i:229;s:1:\"b\";s:31:\"facturacion.notas_debito.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:207;a:4:{s:1:\"a\";i:230;s:1:\"b\";s:29:\"facturacion.notas_debito.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:208;a:4:{s:1:\"a\";i:231;s:1:\"b\";s:29:\"facturacion.notas_debito.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:209;a:4:{s:1:\"a\";i:232;s:1:\"b\";s:30:\"facturacion.guias_remision.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:210;a:4:{s:1:\"a\";i:233;s:1:\"b\";s:30:\"facturacion.guias_remision.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:211;a:4:{s:1:\"a\";i:234;s:1:\"b\";s:31:\"facturacion.guias_remision.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:212;a:4:{s:1:\"a\";i:235;s:1:\"b\";s:31:\"facturacion.guias_remision.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:213;a:4:{s:1:\"a\";i:236;s:1:\"b\";s:33:\"facturacion.guias_remision.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:214;a:4:{s:1:\"a\";i:237;s:1:\"b\";s:33:\"facturacion.guias_remision.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:215;a:4:{s:1:\"a\";i:238;s:1:\"b\";s:31:\"facturacion.guias_remision.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:216;a:4:{s:1:\"a\";i:239;s:1:\"b\";s:31:\"facturacion.guias_remision.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:217;a:4:{s:1:\"a\";i:240;s:1:\"b\";s:28:\"facturacion.certificados.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:218;a:4:{s:1:\"a\";i:241;s:1:\"b\";s:28:\"facturacion.certificados.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:219;a:4:{s:1:\"a\";i:242;s:1:\"b\";s:31:\"facturacion.certificados.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:220;a:4:{s:1:\"a\";i:243;s:1:\"b\";s:31:\"facturacion.certificados.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:221;a:4:{s:1:\"a\";i:244;s:1:\"b\";s:29:\"facturacion.certificados.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:222;a:4:{s:1:\"a\";i:245;s:1:\"b\";s:29:\"facturacion.certificados.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:223;a:4:{s:1:\"a\";i:246;s:1:\"b\";s:31:\"facturacion.certificados.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:224;a:4:{s:1:\"a\";i:247;s:1:\"b\";s:31:\"facturacion.certificados.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:225;a:4:{s:1:\"a\";i:248;s:1:\"b\";s:25:\"facturacion.resumenes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:226;a:4:{s:1:\"a\";i:249;s:1:\"b\";s:25:\"facturacion.resumenes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:227;a:4:{s:1:\"a\";i:250;s:1:\"b\";s:28:\"facturacion.resumenes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:228;a:4:{s:1:\"a\";i:251;s:1:\"b\";s:28:\"facturacion.resumenes.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:229;a:4:{s:1:\"a\";i:252;s:1:\"b\";s:26:\"facturacion.resumenes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:230;a:4:{s:1:\"a\";i:253;s:1:\"b\";s:26:\"facturacion.resumenes.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:231;a:4:{s:1:\"a\";i:254;s:1:\"b\";s:21:\"facturacion.bajas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:232;a:4:{s:1:\"a\";i:255;s:1:\"b\";s:21:\"facturacion.bajas.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:233;a:4:{s:1:\"a\";i:256;s:1:\"b\";s:24:\"facturacion.bajas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:234;a:4:{s:1:\"a\";i:257;s:1:\"b\";s:24:\"facturacion.bajas.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:235;a:4:{s:1:\"a\";i:258;s:1:\"b\";s:22:\"facturacion.bajas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:236;a:4:{s:1:\"a\";i:259;s:1:\"b\";s:22:\"facturacion.bajas.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:237;a:4:{s:1:\"a\";i:260;s:1:\"b\";s:25:\"facturacion.auditoria.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:238;a:4:{s:1:\"a\";i:261;s:1:\"b\";s:25:\"facturacion.auditoria.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:239;a:4:{s:1:\"a\";i:262;s:1:\"b\";s:26:\"facturacion.reintentos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:240;a:4:{s:1:\"a\";i:263;s:1:\"b\";s:26:\"facturacion.reintentos.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:241;a:4:{s:1:\"a\";i:264;s:1:\"b\";s:27:\"facturacion.reintentos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:242;a:4:{s:1:\"a\";i:265;s:1:\"b\";s:27:\"facturacion.reintentos.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:243;a:4:{s:1:\"a\";i:266;s:1:\"b\";s:25:\"facturacion.catalogos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:244;a:4:{s:1:\"a\";i:267;s:1:\"b\";s:25:\"facturacion.catalogos.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:245;a:4:{s:1:\"a\";i:268;s:1:\"b\";s:23:\"facturacion.empresa.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:246;a:4:{s:1:\"a\";i:269;s:1:\"b\";s:23:\"facturacion.empresa.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:247;a:4:{s:1:\"a\";i:270;s:1:\"b\";s:24:\"facturacion.empresa.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:248;a:4:{s:1:\"a\";i:271;s:1:\"b\";s:24:\"facturacion.empresa.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:249;a:4:{s:1:\"a\";i:272;s:1:\"b\";s:28:\"facturacion.contingencia.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:250;a:4:{s:1:\"a\";i:273;s:1:\"b\";s:28:\"facturacion.contingencia.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:251;a:4:{s:1:\"a\";i:274;s:1:\"b\";s:29:\"facturacion.contingencia.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:252;a:4:{s:1:\"a\";i:275;s:1:\"b\";s:29:\"facturacion.contingencia.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:253;a:4:{s:1:\"a\";i:276;s:1:\"b\";s:24:\"facturacion.reportes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:254;a:4:{s:1:\"a\";i:277;s:1:\"b\";s:24:\"facturacion.reportes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:255;a:4:{s:1:\"a\";i:278;s:1:\"b\";s:21:\"facturacion.pagos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:256;a:4:{s:1:\"a\";i:279;s:1:\"b\";s:21:\"facturacion.pagos.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:257;a:4:{s:1:\"a\";i:280;s:1:\"b\";s:22:\"facturacion.pagos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:258;a:4:{s:1:\"a\";i:281;s:1:\"b\";s:22:\"facturacion.pagos.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:259;a:4:{s:1:\"a\";i:282;s:1:\"b\";s:24:\"facturacion.pagos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:260;a:4:{s:1:\"a\";i:283;s:1:\"b\";s:24:\"facturacion.pagos.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:261;a:4:{s:1:\"a\";i:284;s:1:\"b\";s:22:\"facturacion.pagos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:262;a:4:{s:1:\"a\";i:285;s:1:\"b\";s:22:\"facturacion.pagos.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:263;a:4:{s:1:\"a\";i:286;s:1:\"b\";s:24:\"facturacion.pagos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:264;a:4:{s:1:\"a\";i:287;s:1:\"b\";s:24:\"facturacion.pagos.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:265;a:4:{s:1:\"a\";i:288;s:1:\"b\";s:32:\"facturacion.historial_envios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:266;a:4:{s:1:\"a\";i:289;s:1:\"b\";s:32:\"facturacion.historial_envios.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:267;a:4:{s:1:\"a\";i:290;s:1:\"b\";s:33:\"facturacion.historial_envios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:268;a:4:{s:1:\"a\";i:291;s:1:\"b\";s:33:\"facturacion.historial_envios.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:269;a:4:{s:1:\"a\";i:292;s:1:\"b\";s:35:\"facturacion.historial_envios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:270;a:4:{s:1:\"a\";i:293;s:1:\"b\";s:35:\"facturacion.historial_envios.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:271;a:4:{s:1:\"a\";i:294;s:1:\"b\";s:20:\"facturacion.logs.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:272;a:4:{s:1:\"a\";i:295;s:1:\"b\";s:20:\"facturacion.logs.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:273;a:4:{s:1:\"a\";i:296;s:1:\"b\";s:23:\"facturacion.logs.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:274;a:4:{s:1:\"a\";i:297;s:1:\"b\";s:23:\"facturacion.logs.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:275;a:4:{s:1:\"a\";i:298;s:1:\"b\";s:21:\"facturacion.logs.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:276;a:4:{s:1:\"a\";i:299;s:1:\"b\";s:21:\"facturacion.logs.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:277;a:4:{s:1:\"a\";i:300;s:1:\"b\";s:23:\"facturacion.logs.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:278;a:4:{s:1:\"a\";i:301;s:1:\"b\";s:23:\"facturacion.logs.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:279;a:4:{s:1:\"a\";i:302;s:1:\"b\";s:29:\"facturacion.configuracion.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:280;a:4:{s:1:\"a\";i:303;s:1:\"b\";s:29:\"facturacion.configuracion.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:281;a:4:{s:1:\"a\";i:304;s:1:\"b\";s:30:\"facturacion.configuracion.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:282;a:4:{s:1:\"a\";i:305;s:1:\"b\";s:30:\"facturacion.configuracion.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:283;a:4:{s:1:\"a\";i:306;s:1:\"b\";s:29:\"facturacion.integraciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:284;a:4:{s:1:\"a\";i:307;s:1:\"b\";s:29:\"facturacion.integraciones.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:285;a:4:{s:1:\"a\";i:308;s:1:\"b\";s:30:\"facturacion.integraciones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:286;a:4:{s:1:\"a\";i:309;s:1:\"b\";s:30:\"facturacion.integraciones.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:287;a:4:{s:1:\"a\";i:310;s:1:\"b\";s:32:\"facturacion.integraciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:288;a:4:{s:1:\"a\";i:311;s:1:\"b\";s:32:\"facturacion.integraciones.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:289;a:4:{s:1:\"a\";i:312;s:1:\"b\";s:30:\"facturacion.integraciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:290;a:4:{s:1:\"a\";i:313;s:1:\"b\";s:30:\"facturacion.integraciones.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:291;a:4:{s:1:\"a\";i:314;s:1:\"b\";s:32:\"facturacion.integraciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:292;a:4:{s:1:\"a\";i:315;s:1:\"b\";s:32:\"facturacion.integraciones.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:293;a:4:{s:1:\"a\";i:316;s:1:\"b\";s:18:\"recompensas.popups\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:294;a:4:{s:1:\"a\";i:317;s:1:\"b\";s:26:\"recompensas.notificaciones\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:295;a:3:{s:1:\"a\";i:318;s:1:\"b\";s:15:\"ventas.facturar\";s:1:\"c\";s:3:\"api\";}i:296;a:4:{s:1:\"a\";i:319;s:1:\"b\";s:15:\"ventas.facturar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:297;a:4:{s:1:\"a\";i:320;s:1:\"b\";s:16:\"pasos_envio.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}}s:5:\"roles\";a:7:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:10:\"superadmin\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:5:\"admin\";s:1:\"c\";s:3:\"web\";}i:2;a:3:{s:1:\"a\";i:4;s:1:\"b\";s:10:\"motorizado\";s:1:\"c\";s:3:\"web\";}i:3;a:3:{s:1:\"a\";i:5;s:1:\"b\";s:14:\"motorizado-app\";s:1:\"c\";s:7:\"sanctum\";}i:4;a:3:{s:1:\"a\";i:6;s:1:\"b\";s:8:\"Contador\";s:1:\"c\";s:3:\"api\";}i:5;a:3:{s:1:\"a\";i:7;s:1:\"b\";s:6:\"Cajero\";s:1:\"c\";s:3:\"api\";}i:6;a:3:{s:1:\"a\";i:8;s:1:\"b\";s:7:\"Compras\";s:1:\"c\";s:3:\"api\";}}}',1764630443);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caja_chica`
--

DROP TABLE IF EXISTS `caja_chica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caja_chica` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `fondo_fijo` decimal(12,2) NOT NULL,
  `saldo_actual` decimal(12,2) NOT NULL,
  `responsable_id` bigint(20) unsigned NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `caja_chica_codigo_unique` (`codigo`),
  KEY `caja_chica_responsable_id_foreign` (`responsable_id`),
  CONSTRAINT `caja_chica_responsable_id_foreign` FOREIGN KEY (`responsable_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caja_chica`
--

LOCK TABLES `caja_chica` WRITE;
/*!40000 ALTER TABLE `caja_chica` DISABLE KEYS */;
/*!40000 ALTER TABLE `caja_chica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caja_chica_movimientos`
--

DROP TABLE IF EXISTS `caja_chica_movimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caja_chica_movimientos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `caja_chica_id` bigint(20) unsigned NOT NULL,
  `tipo` enum('GASTO','REPOSICION') NOT NULL,
  `fecha` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `comprobante_tipo` varchar(20) DEFAULT NULL,
  `comprobante_numero` varchar(50) DEFAULT NULL,
  `proveedor` varchar(200) DEFAULT NULL,
  `descripcion` text NOT NULL,
  `archivo_adjunto` varchar(255) DEFAULT NULL,
  `estado` enum('PENDIENTE','APROBADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  `user_id` bigint(20) unsigned NOT NULL,
  `aprobado_por` bigint(20) unsigned DEFAULT NULL,
  `aprobado_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_chica_movimientos_user_id_foreign` (`user_id`),
  KEY `caja_chica_movimientos_aprobado_por_foreign` (`aprobado_por`),
  KEY `caja_chica_movimientos_caja_chica_id_fecha_index` (`caja_chica_id`,`fecha`),
  KEY `caja_chica_movimientos_estado_index` (`estado`),
  CONSTRAINT `caja_chica_movimientos_aprobado_por_foreign` FOREIGN KEY (`aprobado_por`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `caja_chica_movimientos_caja_chica_id_foreign` FOREIGN KEY (`caja_chica_id`) REFERENCES `caja_chica` (`id`) ON DELETE CASCADE,
  CONSTRAINT `caja_chica_movimientos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caja_chica_movimientos`
--

LOCK TABLES `caja_chica_movimientos` WRITE;
/*!40000 ALTER TABLE `caja_chica_movimientos` DISABLE KEYS */;
/*!40000 ALTER TABLE `caja_chica_movimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caja_movimientos`
--

DROP TABLE IF EXISTS `caja_movimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caja_movimientos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `caja_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `tipo` enum('APERTURA','CIERRE') NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `monto_inicial` decimal(12,2) NOT NULL DEFAULT 0.00,
  `monto_final` decimal(12,2) DEFAULT NULL,
  `monto_sistema` decimal(12,2) DEFAULT NULL,
  `diferencia` decimal(12,2) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `estado` enum('ABIERTA','CERRADA') NOT NULL DEFAULT 'ABIERTA',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_movimientos_user_id_foreign` (`user_id`),
  KEY `caja_movimientos_caja_id_fecha_index` (`caja_id`,`fecha`),
  KEY `caja_movimientos_estado_index` (`estado`),
  CONSTRAINT `caja_movimientos_caja_id_foreign` FOREIGN KEY (`caja_id`) REFERENCES `cajas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `caja_movimientos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caja_movimientos`
--

LOCK TABLES `caja_movimientos` WRITE;
/*!40000 ALTER TABLE `caja_movimientos` DISABLE KEYS */;
/*!40000 ALTER TABLE `caja_movimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caja_transacciones`
--

DROP TABLE IF EXISTS `caja_transacciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caja_transacciones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `caja_movimiento_id` bigint(20) unsigned NOT NULL,
  `tipo` enum('INGRESO','EGRESO') NOT NULL,
  `categoria` enum('VENTA','COBRO','GASTO','RETIRO','OTRO') NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `comprobante_id` bigint(20) unsigned DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_transacciones_venta_id_foreign` (`venta_id`),
  KEY `caja_transacciones_comprobante_id_foreign` (`comprobante_id`),
  KEY `caja_transacciones_user_id_foreign` (`user_id`),
  KEY `caja_transacciones_caja_movimiento_id_tipo_index` (`caja_movimiento_id`,`tipo`),
  KEY `caja_transacciones_categoria_index` (`categoria`),
  CONSTRAINT `caja_transacciones_caja_movimiento_id_foreign` FOREIGN KEY (`caja_movimiento_id`) REFERENCES `caja_movimientos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `caja_transacciones_comprobante_id_foreign` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `caja_transacciones_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `caja_transacciones_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caja_transacciones`
--

LOCK TABLES `caja_transacciones` WRITE;
/*!40000 ALTER TABLE `caja_transacciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `caja_transacciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cajas`
--

DROP TABLE IF EXISTS `cajas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cajas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `tienda_id` bigint(20) unsigned DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cajas_codigo_unique` (`codigo`),
  KEY `cajas_tienda_id_foreign` (`tienda_id`),
  CONSTRAINT `cajas_tienda_id_foreign` FOREIGN KEY (`tienda_id`) REFERENCES `tiendas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cajas`
--

LOCK TABLES `cajas` WRITE;
/*!40000 ALTER TABLE `cajas` DISABLE KEYS */;
/*!40000 ALTER TABLE `cajas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID del usuario del sistema (admin, vendedor)',
  `user_cliente_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID del cliente del e-commerce',
  `producto_id` bigint(20) unsigned NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL DEFAULT 0.00,
  `descuento_porcentaje` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cart_items_user_id_foreign` (`user_id`) USING BTREE,
  KEY `cart_items_user_cliente_id_foreign` (`user_cliente_id`) USING BTREE,
  KEY `cart_items_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `cart_items_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `check_user_type` CHECK (`user_id` is not null and `user_cliente_id` is null or `user_id` is null and `user_cliente_id` is not null)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogos_sunat`
--

DROP TABLE IF EXISTS `catalogos_sunat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogos_sunat` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `catalogo` varchar(50) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  `descripcion_corta` varchar(100) DEFAULT NULL,
  `metadatos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadatos`)),
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_catalogo_codigo` (`catalogo`,`codigo`),
  KEY `idx_catalogo` (`catalogo`),
  KEY `idx_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogos_sunat`
--

LOCK TABLES `catalogos_sunat` WRITE;
/*!40000 ALTER TABLE `catalogos_sunat` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogos_sunat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria_compatibilidades`
--

DROP TABLE IF EXISTS `categoria_compatibilidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria_compatibilidades` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `categoria_principal_id` bigint(20) unsigned NOT NULL,
  `categoria_compatible_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `categoria_compatibilidades_unique` (`categoria_principal_id`,`categoria_compatible_id`) USING BTREE,
  KEY `categoria_compatible_id` (`categoria_compatible_id`) USING BTREE,
  CONSTRAINT `categoria_compatibilidades_ibfk_1` FOREIGN KEY (`categoria_principal_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categoria_compatibilidades_ibfk_2` FOREIGN KEY (`categoria_compatible_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria_compatibilidades`
--

LOCK TABLES `categoria_compatibilidades` WRITE;
/*!40000 ALTER TABLE `categoria_compatibilidades` DISABLE KEYS */;
INSERT INTO `categoria_compatibilidades` VALUES (1,13,11,'2025-09-09 10:51:22','2025-09-09 10:51:22');
/*!40000 ALTER TABLE `categoria_compatibilidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_seccion` int(11) DEFAULT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_categoria_seccion` (`id_seccion`) USING BTREE,
  CONSTRAINT `fk_categoria_seccion` FOREIGN KEY (`id_seccion`) REFERENCES `secciones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (11,1,'Memoria RAM',NULL,'1758851506_68d5f1b25b941.png',1,'2025-07-18 07:47:49','2025-10-01 12:29:59'),(13,1,'Discos',NULL,'1758851433_68d5f1692d93c.png',1,'2025-07-18 07:48:12','2025-09-25 18:50:33'),(17,3,'Mouse',NULL,'1759185236_68db0954a9998.png',1,'2025-09-29 15:33:56','2025-09-29 15:33:56'),(18,1,'Placa Madre',NULL,'1759185526_68db0a76ca3bc.png',1,'2025-09-29 15:38:46','2025-09-29 15:38:46'),(19,1,'Procesador',NULL,'1759185621_68db0ad576a43.png',1,'2025-09-29 15:40:21','2025-09-29 15:40:21'),(20,1,'Tarjeta Gráfica',NULL,'1759185700_68db0b249fdc6.png',1,'2025-09-29 15:41:40','2025-09-29 15:41:40'),(21,1,'Case Gamer',NULL,'1759185867_68db0bcb6afb3.png',1,'2025-09-29 15:44:27','2025-09-29 15:44:27'),(22,3,'Teclado',NULL,'1759334418_68dd50125b9c2.webp',1,'2025-10-01 09:00:18','2025-10-01 09:00:18'),(23,1,'Refrigeración Liquida',NULL,'1759337230_68dd5b0e93437.jpg',1,'2025-10-01 09:47:10','2025-10-01 09:47:10'),(24,3,'Monitor','Monitores Gaming y de  Hogar.','1760454665_68ee6809ede7d.jpg',1,'2025-10-14 08:11:05','2025-10-14 08:11:05');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificados`
--

DROP TABLE IF EXISTS `certificados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificados` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint(20) unsigned NOT NULL,
  `nombre_archivo` varchar(255) NOT NULL,
  `ruta_archivo` varchar(500) NOT NULL,
  `password_cifrado` text NOT NULL,
  `propietario` varchar(255) DEFAULT NULL,
  `emisor` varchar(255) DEFAULT NULL,
  `numero_serie` varchar(100) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_vencimiento` date NOT NULL,
  `tamanio_bytes` int(10) unsigned DEFAULT NULL,
  `hash_sha256` varchar(64) DEFAULT NULL,
  `estado` enum('activo','vencido','revocado') DEFAULT 'activo',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_vencimiento` (`fecha_vencimiento`),
  CONSTRAINT `fk_certificados_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresa_info` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificados`
--

LOCK TABLES `certificados` WRITE;
/*!40000 ALTER TABLE `certificados` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
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
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Referencia a usuario registrado',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `numero_documento` (`numero_documento`) USING BTREE,
  KEY `idx_tipo_documento` (`tipo_documento`) USING BTREE,
  KEY `idx_numero_documento` (`numero_documento`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_activo` (`activo`) USING BTREE,
  CONSTRAINT `fk_clientes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'6','20000000001','EMPRESA DE PRUEBAS S.A.C.','EMPRESA DE PRUEBAS S.A.C.','AV. FICTICIA 123, LIMA','150101',NULL,NULL,NULL,'987654321','pruebas@test.com',1,NULL,'2025-10-09 08:26:58','2025-11-14 14:14:09'),(8,'1','12345678','Linder Lopez Google',NULL,'Dirección de Prueba',NULL,NULL,NULL,NULL,'987654321','cliente@prueba.com',1,NULL,'2025-10-09 21:45:07','2025-10-09 21:45:07'),(10,'1','87654321','CLIENTE BOLETA 80',NULL,'AV. BOLETA 80, LIMA',NULL,NULL,NULL,NULL,'987654321','boleta80@prueba.com',1,NULL,'2025-10-17 19:14:58','2025-10-17 19:14:58'),(11,'-','76165962','Victor Raul Canchari Riqui',NULL,'Independencia',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'2025-10-20 22:49:12','2025-10-20 22:49:12'),(12,'-','76165963','Braulio Canchari riqui','Braulio Canchari riqui','av. los mártires 231',NULL,NULL,NULL,NULL,'926703231','vcanchari38@gmail.com',1,NULL,'2025-10-20 23:13:34','2025-11-03 19:06:20'),(27,'0','00000000','CLIENTE GENERAL','CLIENTE GENERAL','-',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'2025-10-21 19:49:06','2025-10-21 19:49:06'),(28,'1','74705211','FREDDY ALFONSO VEGA BORDA','FREDDY ALFONSO VEGA BORDA','Sin dirección',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'2025-10-28 20:17:04','2025-10-28 20:17:04'),(31,'1','77425200','EMER RODRIGO YARLEQUE ZAPATA','EMER RODRIGO YARLEQUE ZAPATA','scdsc',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,'2025-10-29 20:28:36','2025-10-29 20:28:36'),(32,'1','42799312','MANUEL HIPOLITO AGUADO SIERRA','MANUEL HIPOLITO AGUADO SIERRA','ate',NULL,NULL,NULL,NULL,'972781904','systemcraft.pe@gmail.com',1,NULL,'2025-11-03 16:18:13','2025-11-03 16:18:13'),(33,'1','44925551','JANETT NILDA RIQUI PIÑAS','JANETT NILDA RIQUI PIÑAS','av. Cahuide 211, Lima',NULL,NULL,NULL,NULL,'926703231','vcanchari38@gmail.com',1,NULL,'2025-11-04 18:30:17','2025-11-04 18:30:17'),(34,'1','99999999','Cliente Prueba Pagos Mixtos','Cliente Prueba','Av. Test 123',NULL,NULL,NULL,NULL,NULL,'test@example.com',1,NULL,'2025-11-04 18:36:34','2025-11-04 18:36:34');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cola_reintentos`
--

DROP TABLE IF EXISTS `cola_reintentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cola_reintentos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `entidad_tipo` enum('comprobante','resumen','baja') NOT NULL,
  `entidad_id` bigint(20) unsigned NOT NULL,
  `intentos` int(10) unsigned DEFAULT 0,
  `max_intentos` int(10) unsigned DEFAULT 3,
  `ultimo_error` text DEFAULT NULL,
  `ultimo_intento_at` timestamp NULL DEFAULT NULL,
  `proximo_reintento_at` timestamp NULL DEFAULT NULL,
  `delay_segundos` int(10) unsigned DEFAULT 300,
  `estado` enum('PENDIENTE','PROCESANDO','COMPLETADO','FALLIDO') DEFAULT 'PENDIENTE',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_estado_proximo` (`estado`,`proximo_reintento_at`),
  KEY `idx_entidad` (`entidad_tipo`,`entidad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cola_reintentos`
--

LOCK TABLES `cola_reintentos` WRITE;
/*!40000 ALTER TABLE `cola_reintentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cola_reintentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compra_detalles`
--

DROP TABLE IF EXISTS `compra_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compra_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compra_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `codigo_producto` varchar(255) NOT NULL,
  `nombre_producto` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `compra_detalles_compra_id_foreign` (`compra_id`) USING BTREE,
  KEY `compra_detalles_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `compra_detalles_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE,
  CONSTRAINT `compra_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compra_detalles`
--

LOCK TABLES `compra_detalles` WRITE;
/*!40000 ALTER TABLE `compra_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `compra_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compra_tracking`
--

DROP TABLE IF EXISTS `compra_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compra_tracking` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compra_id` bigint(20) unsigned NOT NULL,
  `estado_compra_id` bigint(20) unsigned NOT NULL,
  `comentario` text DEFAULT NULL,
  `usuario_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_cambio` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `compra_tracking_compra_id_foreign` (`compra_id`) USING BTREE,
  KEY `compra_tracking_estado_compra_id_foreign` (`estado_compra_id`) USING BTREE,
  KEY `compra_tracking_usuario_id_foreign` (`usuario_id`) USING BTREE,
  KEY `compra_tracking_fecha_cambio` (`fecha_cambio`) USING BTREE,
  CONSTRAINT `compra_tracking_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE,
  CONSTRAINT `compra_tracking_estado_compra_id_foreign` FOREIGN KEY (`estado_compra_id`) REFERENCES `estados_compra` (`id`),
  CONSTRAINT `compra_tracking_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compra_tracking`
--

LOCK TABLES `compra_tracking` WRITE;
/*!40000 ALTER TABLE `compra_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `compra_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras`
--

DROP TABLE IF EXISTS `compras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo_compra` varchar(255) NOT NULL,
  `cotizacion_id` bigint(20) unsigned DEFAULT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `user_cliente_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_compra` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado_compra_id` bigint(20) unsigned NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `requiere_factura` tinyint(1) DEFAULT 0,
  `datos_facturacion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_facturacion`)),
  `comprobante_id` bigint(20) unsigned DEFAULT NULL,
  `facturado_automaticamente` tinyint(1) DEFAULT 0,
  `observaciones` text DEFAULT NULL,
  `direccion_envio` text DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `numero_documento` varchar(20) DEFAULT NULL,
  `cliente_nombre` varchar(255) DEFAULT NULL,
  `cliente_email` varchar(255) DEFAULT NULL,
  `forma_envio` varchar(50) DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT 0.00,
  `departamento_id` varchar(2) DEFAULT NULL,
  `provincia_id` varchar(4) DEFAULT NULL,
  `distrito_id` varchar(6) DEFAULT NULL,
  `departamento_nombre` varchar(255) DEFAULT NULL,
  `provincia_nombre` varchar(255) DEFAULT NULL,
  `distrito_nombre` varchar(255) DEFAULT NULL,
  `ubicacion_completa` text DEFAULT NULL,
  `aprobada_por` bigint(20) unsigned DEFAULT NULL,
  `fecha_aprobacion` datetime DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo_compra` (`codigo_compra`) USING BTREE,
  KEY `compras_cotizacion_id_foreign` (`cotizacion_id`) USING BTREE,
  KEY `compras_cliente_id_foreign` (`cliente_id`) USING BTREE,
  KEY `compras_user_cliente_id_foreign` (`user_cliente_id`) USING BTREE,
  KEY `compras_estado_compra_id_foreign` (`estado_compra_id`) USING BTREE,
  KEY `compras_aprobada_por_foreign` (`aprobada_por`) USING BTREE,
  KEY `compras_user_id_foreign` (`user_id`) USING BTREE,
  KEY `compras_fecha_compra` (`fecha_compra`) USING BTREE,
  KEY `idx_comprobante_id` (`comprobante_id`),
  KEY `idx_requiere_factura` (`requiere_factura`),
  CONSTRAINT `compras_aprobada_por_foreign` FOREIGN KEY (`aprobada_por`) REFERENCES `users` (`id`),
  CONSTRAINT `compras_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `compras_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE SET NULL,
  CONSTRAINT `compras_estado_compra_id_foreign` FOREIGN KEY (`estado_compra_id`) REFERENCES `estados_compra` (`id`),
  CONSTRAINT `compras_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `compras_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_compras_comprobante` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras`
--

LOCK TABLES `compras` WRITE;
/*!40000 ALTER TABLE `compras` DISABLE KEYS */;
INSERT INTO `compras` VALUES (3,'TEST-1760071014',NULL,NULL,24,'2025-10-09 23:36:54',100.00,18.00,0.00,128.00,2,'Culqi',0,NULL,NULL,0,'Compra de prueba para webhook','Dirección de Prueba','987654321','12345678','Cliente de Prueba','cliente@prueba.com','Delivery',10.00,NULL,NULL,NULL,NULL,NULL,NULL,'Lima, Perú',NULL,NULL,NULL,'2025-10-09 21:36:54','2025-10-09 21:36:54');
/*!40000 ALTER TABLE `compras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comprobante_detalles`
--

DROP TABLE IF EXISTS `comprobante_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comprobante_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comprobante_id` bigint(20) unsigned NOT NULL,
  `item` int(10) unsigned NOT NULL COMMENT 'Número de línea',
  `producto_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Referencia al producto',
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
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_comprobante_id` (`comprobante_id`) USING BTREE,
  KEY `idx_producto_id` (`producto_id`) USING BTREE,
  KEY `idx_item` (`comprobante_id`,`item`) USING BTREE,
  CONSTRAINT `fk_detalles_comprobante_id` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comprobante_detalles`
--

LOCK TABLES `comprobante_detalles` WRITE;
/*!40000 ALTER TABLE `comprobante_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `comprobante_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comprobantes`
--

DROP TABLE IF EXISTS `comprobantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comprobantes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_comprobante` varchar(2) NOT NULL COMMENT '01=Factura, 03=Boleta, 07=NC, 08=ND',
  `serie` varchar(4) NOT NULL,
  `correlativo` int(10) unsigned NOT NULL,
  `numero_completo` varchar(20) GENERATED ALWAYS AS (concat(`serie`,_utf8mb4'-',lpad(`correlativo`,8,_utf8mb4'0'))) STORED,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `cliente_id` bigint(20) unsigned NOT NULL,
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
  `comprobante_referencia_id` bigint(20) unsigned DEFAULT NULL,
  `tipo_nota` varchar(2) DEFAULT NULL COMMENT 'Código de tipo de nota de crédito/débito',
  `motivo_nota` text DEFAULT NULL,
  `estado` enum('PENDIENTE','ENVIADO','ACEPTADO','RECHAZADO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_envio_sunat` timestamp NULL DEFAULT NULL,
  `fecha_respuesta_sunat` timestamp NULL DEFAULT NULL,
  `origen` varchar(255) NOT NULL DEFAULT 'MANUAL',
  `compra_id` bigint(20) unsigned DEFAULT NULL,
  `metodo_pago` varchar(255) DEFAULT NULL,
  `referencia_pago` varchar(255) DEFAULT NULL,
  `codigo_hash` varchar(100) DEFAULT NULL,
  `qr_path` varchar(255) DEFAULT NULL,
  `xml_firmado` longtext DEFAULT NULL,
  `xml_path` varchar(500) DEFAULT NULL,
  `xml_respuesta_sunat` longtext DEFAULT NULL,
  `cdr_path` varchar(500) DEFAULT NULL,
  `pdf_base64` longtext DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `errores_sunat` text DEFAULT NULL,
  `codigo_error_sunat` varchar(10) DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'Usuario que creó el comprobante',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `codigos_error_sunat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`codigos_error_sunat`)),
  `informacion_errores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`informacion_errores`)),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_serie_correlativo` (`serie`,`correlativo`) USING BTREE,
  KEY `idx_numero_completo` (`numero_completo`) USING BTREE,
  KEY `idx_cliente_id` (`cliente_id`) USING BTREE,
  KEY `idx_fecha_emision` (`fecha_emision`) USING BTREE,
  KEY `idx_estado` (`estado`) USING BTREE,
  KEY `idx_tipo_comprobante` (`tipo_comprobante`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `fk_comprobantes_referencia_id` (`comprobante_referencia_id`) USING BTREE,
  KEY `comprobantes_origen_index` (`origen`),
  KEY `comprobantes_compra_id_index` (`compra_id`),
  KEY `comprobantes_metodo_pago_index` (`metodo_pago`),
  KEY `idx_codigo_hash` (`codigo_hash`),
  KEY `idx_compra_id` (`compra_id`),
  KEY `idx_origen` (`origen`),
  CONSTRAINT `comprobantes_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_comprobantes_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_comprobantes_compra` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_comprobantes_referencia_id` FOREIGN KEY (`comprobante_referencia_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_comprobantes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comprobantes`
--

LOCK TABLES `comprobantes` WRITE;
/*!40000 ALTER TABLE `comprobantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comprobantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cookies_audit_log`
--

DROP TABLE IF EXISTS `cookies_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cookies_audit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `preference_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID de la preferencia relacionada',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID del usuario',
  `session_id` varchar(100) DEFAULT NULL COMMENT 'ID de sesión',
  `accion` enum('aceptar_todo','rechazar_todo','personalizar','actualizar','revocar') NOT NULL COMMENT 'Acción realizada',
  `cookies_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Estado anterior de las cookies' CHECK (json_valid(`cookies_anteriores`)),
  `cookies_nuevas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Estado nuevo de las cookies' CHECK (json_valid(`cookies_nuevas`)),
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'IP del usuario',
  `user_agent` text DEFAULT NULL COMMENT 'User agent',
  `url_origen` varchar(255) DEFAULT NULL COMMENT 'URL donde se realizó la acción',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_preference_id` (`preference_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_fecha` (`created_at`),
  KEY `idx_accion_fecha` (`accion`,`created_at`),
  CONSTRAINT `cookies_audit_log_preference_id_foreign` FOREIGN KEY (`preference_id`) REFERENCES `cookies_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Auditoría de cambios de consentimiento de cookies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cookies_audit_log`
--

LOCK TABLES `cookies_audit_log` WRITE;
/*!40000 ALTER TABLE `cookies_audit_log` DISABLE KEYS */;
INSERT INTO `cookies_audit_log` VALUES (1,1,NULL,'session_om00vqsg1lmgp4hb3e','aceptar_todo',NULL,'{\"necesarias\": 1, \"analiticas\": 1, \"marketing\": 1, \"funcionales\": 1}','38.56.216.90','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 12:41:49'),(2,2,NULL,'session_gd725psjebkmgp9d40e','aceptar_todo',NULL,'{\"necesarias\": 1, \"analiticas\": 1, \"marketing\": 1, \"funcionales\": 1}','38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 14:58:27'),(3,3,NULL,'session_86emsqliwemgqjnouh','aceptar_todo',NULL,'{\"necesarias\": 1, \"analiticas\": 1, \"marketing\": 1, \"funcionales\": 1}','38.56.216.106','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 12:34:26'),(4,4,NULL,'session_nz3cf8wzt2dmgsml87b','aceptar_todo',NULL,'{\"necesarias\": 1, \"analiticas\": 1, \"marketing\": 1, \"funcionales\": 1}','38.25.18.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 23:32:02'),(5,5,NULL,'session_b9lkk4bg4j9mgypdrqu','rechazar_todo',NULL,'{\"necesarias\": 1, \"analiticas\": 0, \"marketing\": 0, \"funcionales\": 0}','66.249.64.7','Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',NULL,'2025-10-20 05:36:51');
/*!40000 ALTER TABLE `cookies_audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cookies_config`
--

DROP TABLE IF EXISTS `cookies_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cookies_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) NOT NULL COMMENT 'Clave única de configuración (ej: banner_activo, duracion_consentimiento)',
  `valor` text NOT NULL COMMENT 'Valor de la configuración',
  `tipo` enum('boolean','string','integer','json') NOT NULL DEFAULT 'string' COMMENT 'Tipo de dato del valor',
  `descripcion` text DEFAULT NULL COMMENT 'Descripción de la configuración',
  `categoria` varchar(50) DEFAULT 'general' COMMENT 'Categoría de configuración (general, banner, politica, etc)',
  `editable` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Si es editable desde el admin',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `cookies_config_clave_unique` (`clave`),
  KEY `idx_categoria` (`categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configuración global del sistema de cookies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cookies_config`
--

LOCK TABLES `cookies_config` WRITE;
/*!40000 ALTER TABLE `cookies_config` DISABLE KEYS */;
INSERT INTO `cookies_config` VALUES (1,'banner_activo','1','boolean','Activar o desactivar el banner de cookies','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(2,'banner_posicion','bottom','string','Posición del banner (top, bottom, center)','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(3,'banner_tema','light','string','Tema del banner (light, dark)','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(4,'banner_titulo','Valoramos tu privacidad','string','Título del banner de cookies','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(5,'banner_mensaje','Usamos cookies para mejorar su experiencia de navegación, mostrarle anuncios o contenidos personalizados y analizar nuestro tráfico. Al hacer clic en \"Aceptar todo\" usted da su consentimiento a nuestro uso de las cookies.','string','Mensaje del banner','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(6,'banner_boton_aceptar','Aceptar todo','string','Texto del botón aceptar','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(7,'banner_boton_rechazar','Rechazar todo','string','Texto del botón rechazar','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(8,'banner_boton_personalizar','Personalizar','string','Texto del botón personalizar','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(9,'banner_link_politica','Política de cookies','string','Texto del enlace a la política','banner',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(10,'consentimiento_duracion_dias','365','integer','Duración del consentimiento en días (recomendado: 365)','consentimiento',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(11,'consentimiento_version_politica','1.0','string','Versión actual de la política de cookies','consentimiento',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(12,'consentimiento_requerir_explicito','1','boolean','Requiere consentimiento explícito antes de usar cookies','consentimiento',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(13,'consentimiento_modo_estricto','0','boolean','Modo estricto GDPR (no acepta scroll o navegación como consentimiento)','consentimiento',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(14,'cookies_necesarias_activo','1','boolean','Las cookies necesarias siempre están activas','categorias',0,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(15,'cookies_analiticas_activo','1','boolean','Permitir cookies analíticas en el sistema','categorias',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(16,'cookies_marketing_activo','1','boolean','Permitir cookies de marketing en el sistema','categorias',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(17,'cookies_funcionales_activo','1','boolean','Permitir cookies funcionales en el sistema','categorias',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(18,'categoria_necesarias_desc','Estas cookies son esenciales para el funcionamiento del sitio web. Sin ellas, no podrías usar funciones básicas como el carrito de compras o tu sesión.','string','Descripción cookies necesarias','descripciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(19,'categoria_analiticas_desc','Nos ayudan a entender cómo los visitantes interactúan con nuestro sitio web, recopilando y reportando información de forma anónima.','string','Descripción cookies analíticas','descripciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(20,'categoria_marketing_desc','Se utilizan para rastrear a los visitantes en los sitios web con el fin de mostrar anuncios relevantes y atractivos para el usuario individual.','string','Descripción cookies marketing','descripciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(21,'categoria_funcionales_desc','Permiten que el sitio web proporcione funcionalidad y personalización mejoradas, como recordar tus preferencias de idioma o región.','string','Descripción cookies funcionales','descripciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(22,'google_analytics_id','','string','ID de Google Analytics (ej: G-XXXXXXXXXX)','integraciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(23,'google_analytics_activo','0','boolean','Activar integración con Google Analytics','integraciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(24,'google_tag_manager_id','','string','ID de Google Tag Manager (ej: GTM-XXXXXXX)','integraciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(25,'google_tag_manager_activo','0','boolean','Activar Google Tag Manager','integraciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(26,'facebook_pixel_id','','string','ID de Facebook Pixel','integraciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(27,'facebook_pixel_activo','0','boolean','Activar Facebook Pixel','integraciones',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(28,'mostrar_icono_flotante','1','boolean','Mostrar icono flotante para cambiar preferencias','display',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(29,'icono_flotante_posicion','bottom-left','string','Posición del icono flotante (bottom-left, bottom-right)','display',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(30,'empresa_nombre','Magus Ecommerce','string','Nombre de la empresa','legal',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(31,'empresa_url','https://www.tuempresa.com','string','URL de la empresa','legal',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(32,'contacto_email_privacidad','privacidad@tuempresa.com','string','Email de contacto para temas de privacidad','legal',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(33,'cumplimiento_gdpr','1','boolean','Cumplir con GDPR (Europa)','legal',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(34,'cumplimiento_lgpd','1','boolean','Cumplir con LGPD (Brasil)','legal',1,'2025-10-13 12:41:15','2025-10-13 12:41:15'),(35,'cumplimiento_ccpa','1','boolean','Cumplir con CCPA (California)','legal',1,'2025-10-13 12:41:15','2025-10-13 12:41:15');
/*!40000 ALTER TABLE `cookies_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cookies_preferences`
--

DROP TABLE IF EXISTS `cookies_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cookies_preferences` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID del usuario (NULL para usuarios no registrados)',
  `session_id` varchar(100) DEFAULT NULL COMMENT 'ID de sesión para usuarios no registrados',
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'Dirección IP del usuario',
  `user_agent` text DEFAULT NULL COMMENT 'User agent del navegador',
  `cookies_necesarias` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Cookies necesarias (siempre activas)',
  `cookies_analiticas` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cookies de analítica (Google Analytics, etc)',
  `cookies_marketing` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cookies de marketing y publicidad',
  `cookies_funcionales` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cookies funcionales (preferencias, idioma, etc)',
  `consintio_todo` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Si aceptó todas las cookies',
  `rechazo_todo` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Si rechazó todas las opcionales',
  `personalizado` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Si personalizó las preferencias',
  `fecha_consentimiento` timestamp NULL DEFAULT current_timestamp() COMMENT 'Fecha del consentimiento',
  `fecha_expiracion` timestamp NULL DEFAULT NULL COMMENT 'Fecha de expiración del consentimiento (12 meses)',
  `version_politica` varchar(20) DEFAULT '1.0' COMMENT 'Versión de la política aceptada',
  `navegador` varchar(100) DEFAULT NULL COMMENT 'Navegador utilizado',
  `dispositivo` varchar(50) DEFAULT NULL COMMENT 'Tipo de dispositivo (desktop, mobile, tablet)',
  `ultima_actualizacion` timestamp NULL DEFAULT NULL COMMENT 'Última vez que cambió preferencias',
  `numero_actualizaciones` int(11) NOT NULL DEFAULT 1 COMMENT 'Número de veces que cambió preferencias',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_fecha_expiracion` (`fecha_expiracion`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_consentimiento_completo` (`consintio_todo`,`rechazo_todo`,`personalizado`),
  KEY `idx_categorias` (`cookies_analiticas`,`cookies_marketing`,`cookies_funcionales`),
  CONSTRAINT `cookies_preferences_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Preferencias de cookies por usuario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cookies_preferences`
--

LOCK TABLES `cookies_preferences` WRITE;
/*!40000 ALTER TABLE `cookies_preferences` DISABLE KEYS */;
INSERT INTO `cookies_preferences` VALUES (1,NULL,'session_om00vqsg1lmgp4hb3e','38.56.216.90','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',1,1,1,1,1,0,0,'2025-10-13 05:41:49','2026-10-13 05:41:49','1.0','Chrome','desktop','2025-10-13 05:41:49',1,'2025-10-13 05:41:49','2025-10-13 05:41:49'),(2,NULL,'session_gd725psjebkmgp9d40e','38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',1,1,1,1,1,0,0,'2025-10-13 07:58:27','2026-10-13 07:58:27','1.0','Chrome','desktop','2025-10-13 07:58:27',1,'2025-10-13 07:58:27','2025-10-13 07:58:27'),(3,NULL,'session_86emsqliwemgqjnouh','38.56.216.106','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',1,1,1,1,1,0,0,'2025-10-14 05:34:26','2026-10-14 05:34:26','1.0','Chrome','desktop','2025-10-14 05:34:26',1,'2025-10-14 05:34:26','2025-10-14 05:34:26'),(4,NULL,'session_nz3cf8wzt2dmgsml87b','38.25.18.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',1,1,1,1,1,0,0,'2025-10-15 16:32:02','2026-10-15 16:32:02','1.0','Chrome','desktop','2025-10-15 16:32:02',1,'2025-10-15 16:32:02','2025-10-15 16:32:02'),(5,NULL,'session_b9lkk4bg4j9mgypdrqu','66.249.64.7','Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',1,0,0,0,0,1,0,'2025-10-19 22:36:51','2026-10-19 22:36:51','1.0','Otro','desktop','2025-10-19 22:36:51',1,'2025-10-19 22:36:51','2025-10-19 22:36:51');
/*!40000 ALTER TABLE `cookies_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cotizacion_detalles`
--

DROP TABLE IF EXISTS `cotizacion_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cotizacion_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `codigo_producto` varchar(255) NOT NULL,
  `nombre_producto` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cotizacion_detalles_cotizacion_id_foreign` (`cotizacion_id`),
  KEY `cotizacion_detalles_producto_id_foreign` (`producto_id`),
  CONSTRAINT `cotizacion_detalles_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizacion_detalles`
--

LOCK TABLES `cotizacion_detalles` WRITE;
/*!40000 ALTER TABLE `cotizacion_detalles` DISABLE KEYS */;
INSERT INTO `cotizacion_detalles` VALUES (2,2,9,'324adcs','desipiador de aire',1,123.00,123.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(3,2,12,'ajsk21','AJAZZ AK820PRO',1,210.00,210.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(4,2,7,'A10','Astro A10',1,2222.00,2222.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(5,2,2,'ASUS ROG','PLACA ASUS ROG STRIX B860-F GAMING WIFI LGA 1851 INTEL B860 DDR5 HDMI DP M.2 SATA 6GB BLUETOOTH M.2 SATA 6GB ATX',1,45.00,45.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(6,2,3,'AUD-213','AUDIFONOS',1,222.00,222.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(7,3,7,'A10','Astro A10',1,2222.00,2222.00,'2025-09-23 15:50:34','2025-09-23 15:50:34'),(8,3,6,'P2DWFC','IMac double',1,2222.00,2222.00,'2025-09-23 15:50:34','2025-09-23 15:50:34'),(9,4,15,'LOGI346','MOUSE INALAMBRICO/BT LOGITECH M196 WHITE',1,40.00,40.00,'2025-09-27 19:29:33','2025-09-27 19:29:33'),(10,5,15,'LOGI346','MOUSE INALAMBRICO/BT LOGITECH M196 WHITE',1,40.00,40.00,'2025-09-29 08:37:58','2025-09-29 08:37:58'),(11,6,16,'i7','PROCESADOR INTEL CORE i7-14700K, Cache 33 MB, Hasta 5.6 Ghz.',1,100.00,100.00,'2025-09-30 08:35:32','2025-09-30 08:35:32');
/*!40000 ALTER TABLE `cotizacion_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cotizacion_tracking`
--

DROP TABLE IF EXISTS `cotizacion_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cotizacion_tracking` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_id` bigint(20) unsigned NOT NULL,
  `estado_cotizacion_id` bigint(20) unsigned NOT NULL,
  `comentario` text DEFAULT NULL,
  `usuario_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_cambio` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cotizacion_tracking_cotizacion_id_foreign` (`cotizacion_id`),
  KEY `cotizacion_tracking_estado_cotizacion_id_foreign` (`estado_cotizacion_id`),
  KEY `cotizacion_tracking_usuario_id_foreign` (`usuario_id`),
  KEY `cotizacion_tracking_fecha_cambio` (`fecha_cambio`),
  CONSTRAINT `cotizacion_tracking_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cotizacion_tracking_estado_cotizacion_id_foreign` FOREIGN KEY (`estado_cotizacion_id`) REFERENCES `estados_cotizacion` (`id`),
  CONSTRAINT `cotizacion_tracking_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizacion_tracking`
--

LOCK TABLES `cotizacion_tracking` WRITE;
/*!40000 ALTER TABLE `cotizacion_tracking` DISABLE KEYS */;
INSERT INTO `cotizacion_tracking` VALUES (2,2,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-23 16:03:36','2025-09-23 14:03:36','2025-09-23 14:03:36'),(3,3,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-23 17:50:34','2025-09-23 15:50:34','2025-09-23 15:50:34'),(4,4,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-27 21:29:33','2025-09-27 19:29:33','2025-09-27 19:29:33'),(5,5,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-29 10:37:58','2025-09-29 08:37:58','2025-09-29 08:37:58'),(6,6,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-30 10:35:32','2025-09-30 08:35:32','2025-09-30 08:35:32'),(7,6,2,'Cliente solicitó el procesamiento de la cotización',NULL,'2025-09-30 10:38:33','2025-09-30 08:38:33','2025-09-30 08:38:33');
/*!40000 ALTER TABLE `cotizacion_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cotizaciones`
--

DROP TABLE IF EXISTS `cotizaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cotizaciones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo_cotizacion` varchar(255) NOT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `user_cliente_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_cotizacion` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado_cotizacion_id` bigint(20) unsigned NOT NULL,
  `metodo_pago_preferido` varchar(50) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `direccion_envio` text DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `numero_documento` varchar(20) DEFAULT NULL,
  `cliente_nombre` varchar(255) DEFAULT NULL,
  `cliente_email` varchar(255) DEFAULT NULL,
  `forma_envio` varchar(50) DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT 0.00,
  `departamento_id` varchar(2) DEFAULT NULL,
  `provincia_id` varchar(4) DEFAULT NULL,
  `distrito_id` varchar(6) DEFAULT NULL,
  `departamento_nombre` varchar(255) DEFAULT NULL,
  `provincia_nombre` varchar(255) DEFAULT NULL,
  `distrito_nombre` varchar(255) DEFAULT NULL,
  `ubicacion_completa` text DEFAULT NULL,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_cotizacion` (`codigo_cotizacion`),
  KEY `cotizaciones_cliente_id_foreign` (`cliente_id`),
  KEY `cotizaciones_user_cliente_id_foreign` (`user_cliente_id`),
  KEY `cotizaciones_estado_cotizacion_id_foreign` (`estado_cotizacion_id`),
  KEY `cotizaciones_user_id_foreign` (`user_id`),
  KEY `cotizaciones_fecha_cotizacion` (`fecha_cotizacion`),
  KEY `cotizaciones_estado_fecha` (`estado_cotizacion_id`,`fecha_cotizacion`),
  CONSTRAINT `cotizaciones_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cotizaciones_estado_cotizacion_id_foreign` FOREIGN KEY (`estado_cotizacion_id`) REFERENCES `estados_cotizacion` (`id`),
  CONSTRAINT `cotizaciones_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cotizaciones_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizaciones`
--

LOCK TABLES `cotizaciones` WRITE;
/*!40000 ALTER TABLE `cotizaciones` DISABLE KEYS */;
INSERT INTO `cotizaciones` VALUES (2,'COT-20250923-0001',NULL,31,'2025-09-23 16:03:36',2822.00,507.96,0.00,3359.96,1,'tarjeta',NULL,'nbgm nbhmnbm,mnj','993321920',NULL,'kiyotaka hitori Google','kiyotakahitori@gmail.com','delivery',30.00,'05','04','01','AYACUCHO','HUANTA','HUANTA','HUANTA, HUANTA, AYACUCHO','2025-09-30 16:03:36',1,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(3,'COT-20250923-0002',NULL,32,'2025-09-23 17:50:34',4444.00,799.92,0.00,5273.92,1,'efectivo','hola','SJM','972781904',NULL,'SUSAN LADY COBA TORRES','ladysct11@gmail.com','delivery',30.00,'15','01','33','LIMA','LIMA','SAN JUAN DE MIRAFLORES','SAN JUAN DE MIRAFLORES, LIMA, LIMA','2025-09-30 17:50:34',1,'2025-09-23 15:50:34','2025-09-23 15:50:34'),(4,'COT-20250927-0001',NULL,36,'2025-09-27 21:29:33',40.00,7.20,0.00,77.20,1,'efectivo',NULL,'Santa Anita','972781904','42799312','Manuel Aguado Google','systemcraft.pe@gmail.com','delivery',30.00,'15','01','37','LIMA','LIMA','SANTA ANITA','SANTA ANITA, LIMA, LIMA','2025-10-04 21:29:33',1,'2025-09-27 19:29:33','2025-09-27 19:29:33'),(5,'COT-20250929-0001',NULL,30,'2025-09-29 10:37:58',40.00,7.20,0.00,77.20,1,'efectivo',NULL,'santa anita','972781904','42799312','JUAN PÉREZ GARCÍA','umbrellasrl@gmail.com','delivery',30.00,'15','01','13','LIMA','LIMA','JESUS MARIA','JESUS MARIA, LIMA, LIMA','2025-10-06 10:37:58',1,'2025-09-29 08:37:58','2025-09-29 08:37:58'),(6,'COT-20250930-0001',NULL,36,'2025-09-30 10:35:32',100.00,18.00,0.00,148.00,2,'efectivo','con cuidado','Santa Anita','972781904','42799312','Manuel Aguado Google','systemcraft.pe@gmail.com','delivery',30.00,'15','01','03','LIMA','LIMA','ATE','ATE, LIMA, LIMA','2025-10-07 10:35:32',1,'2025-09-30 08:35:32','2025-09-30 08:38:33');
/*!40000 ALTER TABLE `cotizaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuenta_cobrar_pagos`
--

DROP TABLE IF EXISTS `cuenta_cobrar_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuenta_cobrar_pagos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_cobrar_id` bigint(20) unsigned NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` date NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cuenta_cobrar_pagos_cuenta_por_cobrar_id_foreign` (`cuenta_por_cobrar_id`),
  CONSTRAINT `cuenta_cobrar_pagos_cuenta_por_cobrar_id_foreign` FOREIGN KEY (`cuenta_por_cobrar_id`) REFERENCES `cuentas_por_cobrar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuenta_cobrar_pagos`
--

LOCK TABLES `cuenta_cobrar_pagos` WRITE;
/*!40000 ALTER TABLE `cuenta_cobrar_pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuenta_cobrar_pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuenta_pagar_pagos`
--

DROP TABLE IF EXISTS `cuenta_pagar_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuenta_pagar_pagos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_pagar_id` bigint(20) unsigned NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` date NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cuenta_pagar_pagos_cuenta_por_pagar_id_foreign` (`cuenta_por_pagar_id`),
  CONSTRAINT `cuenta_pagar_pagos_cuenta_por_pagar_id_foreign` FOREIGN KEY (`cuenta_por_pagar_id`) REFERENCES `cuentas_por_pagar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuenta_pagar_pagos`
--

LOCK TABLES `cuenta_pagar_pagos` WRITE;
/*!40000 ALTER TABLE `cuenta_pagar_pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuenta_pagar_pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuentas_por_cobrar`
--

DROP TABLE IF EXISTS `cuentas_por_cobrar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuentas_por_cobrar` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cliente_id` bigint(20) unsigned NOT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `comprobante_id` bigint(20) unsigned DEFAULT NULL,
  `numero_documento` varchar(50) NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto_total` decimal(12,2) NOT NULL,
  `monto_pagado` decimal(12,2) NOT NULL DEFAULT 0.00,
  `saldo_pendiente` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PARCIAL','PAGADO','VENCIDO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `dias_credito` int(11) NOT NULL DEFAULT 0,
  `dias_vencidos` int(11) NOT NULL DEFAULT 0,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cuentas_por_cobrar_venta_id_foreign` (`venta_id`),
  KEY `cuentas_por_cobrar_comprobante_id_foreign` (`comprobante_id`),
  KEY `cuentas_por_cobrar_user_id_foreign` (`user_id`),
  KEY `cuentas_por_cobrar_cliente_id_estado_index` (`cliente_id`,`estado`),
  KEY `cuentas_por_cobrar_fecha_vencimiento_index` (`fecha_vencimiento`),
  KEY `cuentas_por_cobrar_estado_index` (`estado`),
  CONSTRAINT `cuentas_por_cobrar_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cuentas_por_cobrar_comprobante_id_foreign` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cuentas_por_cobrar_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cuentas_por_cobrar_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuentas_por_cobrar`
--

LOCK TABLES `cuentas_por_cobrar` WRITE;
/*!40000 ALTER TABLE `cuentas_por_cobrar` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuentas_por_cobrar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuentas_por_pagar`
--

DROP TABLE IF EXISTS `cuentas_por_pagar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuentas_por_pagar` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `proveedor_id` bigint(20) unsigned NOT NULL,
  `compra_id` bigint(20) unsigned DEFAULT NULL,
  `numero_documento` varchar(50) NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto_total` decimal(12,2) NOT NULL,
  `monto_pagado` decimal(12,2) NOT NULL DEFAULT 0.00,
  `saldo_pendiente` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PARCIAL','PAGADO','VENCIDO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `dias_credito` int(11) NOT NULL DEFAULT 0,
  `dias_vencidos` int(11) NOT NULL DEFAULT 0,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cuentas_por_pagar_compra_id_foreign` (`compra_id`),
  KEY `cuentas_por_pagar_user_id_foreign` (`user_id`),
  KEY `cuentas_por_pagar_proveedor_id_estado_index` (`proveedor_id`,`estado`),
  KEY `cuentas_por_pagar_fecha_vencimiento_index` (`fecha_vencimiento`),
  KEY `cuentas_por_pagar_estado_index` (`estado`),
  CONSTRAINT `cuentas_por_pagar_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cuentas_por_pagar_proveedor_id_foreign` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cuentas_por_pagar_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuentas_por_pagar`
--

LOCK TABLES `cuentas_por_pagar` WRITE;
/*!40000 ALTER TABLE `cuentas_por_pagar` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuentas_por_pagar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupon_usos`
--

DROP TABLE IF EXISTS `cupon_usos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupon_usos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cupon_id` int(10) unsigned NOT NULL COMMENT 'Referencia al cupón usado',
  `user_cliente_id` bigint(20) unsigned NOT NULL COMMENT 'Referencia al cliente que usó el cupón',
  `venta_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Referencia a la venta donde se aplicó',
  `descuento_aplicado` decimal(10,2) NOT NULL COMMENT 'Monto del descuento aplicado',
  `total_compra` decimal(10,2) DEFAULT NULL COMMENT 'Total de la compra antes del descuento',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `cupon_cliente_unique` (`cupon_id`,`user_cliente_id`) USING BTREE,
  KEY `cupon_usos_user_cliente_id_index` (`user_cliente_id`) USING BTREE,
  KEY `cupon_usos_venta_id_index` (`venta_id`) USING BTREE,
  KEY `cupon_usos_created_at_index` (`created_at`) USING BTREE,
  CONSTRAINT `cupon_usos_cupon_id_foreign` FOREIGN KEY (`cupon_id`) REFERENCES `cupones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cupon_usos_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cupon_usos_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Registro de uso de cupones por cliente';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupon_usos`
--

LOCK TABLES `cupon_usos` WRITE;
/*!40000 ALTER TABLE `cupon_usos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cupon_usos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupones`
--

DROP TABLE IF EXISTS `cupones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo` (`codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupones`
--

LOCK TABLES `cupones` WRITE;
/*!40000 ALTER TABLE `cupones` DISABLE KEYS */;
INSERT INTO `cupones` VALUES (2,'descuentouser','Decuento de bienvenida','hello','porcentaje',21.00,222.00,'2025-11-30 02:18:00','2025-12-27 03:19:00',1,0,0,1,'2025-07-18 11:15:32','2025-11-30 23:12:09'),(3,'BLACK','POR EL BLACK FRIDAY','EN TODA NUESTRA PAGINA WEB POR COMPRAS MAYORES A 500 SOLES.','porcentaje',10.00,500.00,'2025-10-13 15:03:00','2025-12-31 15:03:00',NULL,0,0,1,'2025-10-13 08:03:54','2025-10-14 08:06:34');
/*!40000 ALTER TABLE `cupones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cxc_pagos`
--

DROP TABLE IF EXISTS `cxc_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cxc_pagos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_cobrar_id` bigint(20) unsigned NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `numero_operacion` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cxc_pagos_user_id_foreign` (`user_id`),
  KEY `cxc_pagos_cuenta_por_cobrar_id_index` (`cuenta_por_cobrar_id`),
  KEY `cxc_pagos_fecha_pago_index` (`fecha_pago`),
  CONSTRAINT `cxc_pagos_cuenta_por_cobrar_id_foreign` FOREIGN KEY (`cuenta_por_cobrar_id`) REFERENCES `cuentas_por_cobrar` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cxc_pagos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cxc_pagos`
--

LOCK TABLES `cxc_pagos` WRITE;
/*!40000 ALTER TABLE `cxc_pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cxc_pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cxp_pagos`
--

DROP TABLE IF EXISTS `cxp_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cxp_pagos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_pagar_id` bigint(20) unsigned NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `numero_operacion` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cxp_pagos_user_id_foreign` (`user_id`),
  KEY `cxp_pagos_cuenta_por_pagar_id_index` (`cuenta_por_pagar_id`),
  KEY `cxp_pagos_fecha_pago_index` (`fecha_pago`),
  CONSTRAINT `cxp_pagos_cuenta_por_pagar_id_foreign` FOREIGN KEY (`cuenta_por_pagar_id`) REFERENCES `cuentas_por_pagar` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cxp_pagos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cxp_pagos`
--

LOCK TABLES `cxp_pagos` WRITE;
/*!40000 ALTER TABLE `cxp_pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cxp_pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_types`
--

DROP TABLE IF EXISTS `document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_types`
--

LOCK TABLES `document_types` WRITE;
/*!40000 ALTER TABLE `document_types` DISABLE KEYS */;
INSERT INTO `document_types` VALUES (1,'DNI','2025-05-26 10:18:30','2025-05-26 10:18:30'),(2,'Pasaporte','2025-05-26 10:18:30','2025-05-26 10:18:30'),(3,'Carnet de Extranjería','2025-05-26 10:18:30','2025-05-26 10:18:30'),(4,'Cédula','2025-05-26 10:18:30','2025-05-26 10:18:30');
/*!40000 ALTER TABLE `document_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates`
--

DROP TABLE IF EXISTS `email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `global_colors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `greeting` text DEFAULT NULL,
  `main_content` text DEFAULT NULL,
  `secondary_content` text DEFAULT NULL,
  `footer_text` text DEFAULT NULL,
  `benefits_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `product_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `button_text` varchar(255) DEFAULT NULL,
  `button_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `use_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email_templates_name_unique` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_templates`
--

LOCK TABLES `email_templates` WRITE;
/*!40000 ALTER TABLE `email_templates` DISABLE KEYS */;
INSERT INTO `email_templates` VALUES (1,'verification','{\"primary\":\"#164a77\",\"secondary\":\"#9467c1\",\"button_hover\":\"#15614e\",\"background\":\"#f4f4f4\",\"content_bg\":\"#ffffff\"}','Verifica tu cuenta en Ecomerce','¡Hola {{nombres}}! ?','<p>Gracias&nbsp;por&nbsp;registrarte&nbsp;en&nbsp;Ecommerce.&nbsp;Para&nbsp;completar&nbsp;tu&nbsp;registro&nbsp;y&nbsp;comenzar&nbsp;a&nbsp;disfrutar&nbsp;de&nbsp;las&nbsp;mejores&nbsp;ofertas&nbsp;en&nbsp;<em>tecnología&nbsp;gaming,&nbsp;necesitamos&nbsp;verificar&nbsp;tu&nbsp;dirección&nbsp;de&nbsp;correo&nbsp;electrónico</em>.</p>',NULL,'Si no solicitaste esta cuenta, simplemente ignora este correo.','[]','[]','✅ Verificar mi cuenta',NULL,1,0,'2025-08-15 01:03:02','2025-08-16 10:04:46'),(2,'welcome','{\"primary\": \"#667eea\", \"secondary\": \"#764ba2\", \"button_hover\": \"#5a67d8\", \"background\": \"#f4f4f4\", \"content_bg\": \"#ffffff\"}','¡Bienvenido a MarketPro!','¡Hola {{nombres}}! ?','¡Bienvenido a <strong>MarketPro</strong>! Nos emociona tenerte como parte de nuestra comunidad de gamers y tech lovers.','? ¿Qué puedes encontrar en MarketPro?',NULL,'[\"? Gaming: Tarjetas gráficas de última generación, periféricos gaming, y accesorios\", \"? Laptops: Equipos de alto rendimiento para gaming y trabajo profesional\", \"?️ Componentes: Procesadores, RAM, almacenamiento y todo para tu build\", \"⚡ Accesorios: Teclados mecánicos, mouse gaming, headsets y más\"]','[{\"url\":\"https:\\/\\/images.pexels.com\\/photos\\/2399840\\/pexels-photo-2399840.jpeg?auto=compress&cs=tinysrgb&w=150\",\"text\":\"Setups Gaming\"},{\"url\":\"https:\\/\\/images.pexels.com\\/photos\\/18105\\/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=150\",\"text\":\"Laptops Gaming\"},{\"url\":\"https:\\/\\/images.pexels.com\\/photos\\/2148217\\/pexels-photo-2148217.jpeg?auto=compress&cs=tinysrgb&w=150\",\"text\":\"Componentes PC\"}]','? Explorar Nuestra Tienda','https://magus-ecommerce.com/',1,1,'2025-08-15 01:03:02','2025-08-16 10:18:56'),(3,'password_reset','{\"primary\":\"#f29040\",\"secondary\":\"#a865ec\",\"button_hover\":\"#9bfdcf\",\"background\":\"#f4f4f4\",\"content_bg\":\"#ffffff\"}','Recuperación de contraseña - Ecommerce','Hola, {{nombres}}','<p>Recibimos&nbsp;una&nbsp;solicitud&nbsp;para&nbsp;restablecer&nbsp;la&nbsp;contraseña&nbsp;de&nbsp;tu&nbsp;cuenta&nbsp;en&nbsp;Ecommerce.&nbsp;Recuperala&nbsp;Ahora!</p>','Para restablecer tu contraseña, haz clic en el siguiente botón:','Si no solicitaste este cambio, puedes ignorar este correo y tu contraseña permanecerá sin cambios.','[]','[]','Cambiar Contraseña',NULL,1,0,'2025-08-15 01:03:02','2025-08-14 19:10:29');
/*!40000 ALTER TABLE `email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresa_info`
--

DROP TABLE IF EXISTS `empresa_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresa_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `ruc` (`ruc`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa_info`
--

LOCK TABLES `empresa_info` WRITE;
/*!40000 ALTER TABLE `empresa_info` DISABLE KEYS */;
INSERT INTO `empresa_info` VALUES (1,'Magus Technologies','12348921372','MAGUS TECHNOLOGIES','santa anita','51 730 9248','972781904','maguado@magustechnologies.com','https://magustechnologies.com/','empresa/logos/AERqD3yJqdYUzae8RYBR5GJ7W7ml4PpyLN4sUaMM.png','Magus E-commerce es una plataforma 100% peruana, diseñada para potenciar las ventas de sus clientes, con una integración óptima en los motores de búsqueda, asegurando un excelente posicionamiento.\r\n\r\nMagus E-commerce no solo está optimizada para el posicionamiento en buscadores, sino que también ofrece una pasarela de pagos segura y una gestión logística integral, asegurando una experiencia completa y sin complicaciones para los clientes.',NULL,NULL,NULL,NULL,NULL,NULL,'2025-07-22 07:25:59','2025-11-27 18:39:51');
/*!40000 ALTER TABLE `empresa_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_logs`
--

DROP TABLE IF EXISTS `error_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) NOT NULL COMMENT 'facturacion, webhook, greenter, etc',
  `origen` varchar(100) NOT NULL COMMENT 'Clase o método origen',
  `mensaje` text NOT NULL,
  `detalles` longtext DEFAULT NULL COMMENT 'Información adicional del error',
  `stack_trace` longtext DEFAULT NULL,
  `entidad_tipo` varchar(50) DEFAULT NULL COMMENT 'compra, comprobante, etc',
  `entidad_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `severidad` enum('DEBUG','INFO','WARNING','ERROR','CRITICAL') DEFAULT 'ERROR',
  `resuelto` tinyint(1) DEFAULT 0,
  `fecha_resolucion` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_origen` (`origen`),
  KEY `idx_severidad` (`severidad`),
  KEY `idx_resuelto` (`resuelto`),
  KEY `idx_entidad` (`entidad_tipo`,`entidad_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Log de errores del sistema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_logs`
--

LOCK TABLES `error_logs` WRITE;
/*!40000 ALTER TABLE `error_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_compra`
--

DROP TABLE IF EXISTS `estados_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_compra` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `color` varchar(7) DEFAULT '#6c757d',
  `orden` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `estados_compra_nombre_unique` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_compra`
--

LOCK TABLES `estados_compra` WRITE;
/*!40000 ALTER TABLE `estados_compra` DISABLE KEYS */;
INSERT INTO `estados_compra` VALUES (1,'Pendiente Aprobación','Compra pendiente de aprobación administrativa','#ffc107',1,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(2,'Aprobada','Compra aprobada, procesando pago','#28a745',2,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(3,'Pagada','Compra pagada exitosamente','#007bff',3,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(4,'En Preparación','Compra en proceso de preparación','#17a2b8',4,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(5,'Enviada','Compra enviada al cliente','#6f42c1',5,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(6,'Entregada','Compra entregada exitosamente','#28a745',6,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(7,'Cancelada','Compra cancelada','#dc3545',7,'2025-09-26 21:28:03','2025-09-26 21:28:03'),(8,'Rechazada','Compra rechazada en aprobación','#dc3545',8,'2025-09-26 21:28:03','2025-09-26 21:28:03');
/*!40000 ALTER TABLE `estados_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_cotizacion`
--

DROP TABLE IF EXISTS `estados_cotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_cotizacion` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `color` varchar(7) DEFAULT '#6c757d',
  `orden` int(11) DEFAULT 0,
  `permite_conversion` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `estados_cotizacion_nombre_unique` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_cotizacion`
--

LOCK TABLES `estados_cotizacion` WRITE;
/*!40000 ALTER TABLE `estados_cotizacion` DISABLE KEYS */;
INSERT INTO `estados_cotizacion` VALUES (1,'Pendiente','Cotizaci�n generada, pendiente de revisi�n','#ffc107',1,0,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(2,'En Revisi�n','Cotizaci�n siendo revisada por el equipo','#17a2b8',2,0,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(3,'Aprobada','Cotizaci�n aprobada, puede convertirse a compra','#28a745',3,1,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(4,'Rechazada','Cotizaci�n rechazada','#dc3545',4,0,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(5,'Enviada para Compra','Cliente solicit� convertir a compra','#6f42c1',5,0,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(6,'Convertida a Compra','Cotizaci�n convertida exitosamente a compra','#007bff',6,0,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(7,'Vencida','Cotizaci�n vencida por tiempo','#6c757d',7,0,'2025-09-17 03:02:26','2025-09-17 03:02:26'),(8,'Cancelada','Cotizaci�n cancelada por el cliente','#dc3545',8,0,'2025-09-17 03:02:26','2025-09-17 03:02:26');
/*!40000 ALTER TABLE `estados_cotizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_pedido`
--

DROP TABLE IF EXISTS `estados_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_pedido` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `orden` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_pedido`
--

LOCK TABLES `estados_pedido` WRITE;
/*!40000 ALTER TABLE `estados_pedido` DISABLE KEYS */;
INSERT INTO `estados_pedido` VALUES (1,'Nuevo','Pedido creado, esperando pago','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(2,'Pendiente','Pedido recibido pero aún no procesado','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(3,'Pagado','El cliente ya realizó el pago','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(4,'En preparación','El pedido está siendo preparado','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(5,'En camino','El pedido ha sido enviado y está en reparto','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(6,'Entregado','El pedido fue entregado al cliente','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(7,'Sin stock','El pedido no puede ser procesado por falta de stock','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(8,'Cancelado','El pedido fue anulado por el cliente o sistema','2025-06-29 02:28:31','2025-06-29 02:28:31',0),(9,'Devuelto','El cliente devolvió el pedido','2025-06-29 02:28:31','2025-06-29 02:28:31',0);
/*!40000 ALTER TABLE `estados_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoritos`
--

DROP TABLE IF EXISTS `favoritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favoritos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_cliente_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `favoritos_user_cliente_producto_unique` (`user_cliente_id`,`producto_id`),
  KEY `favoritos_user_cliente_id_index` (`user_cliente_id`),
  KEY `favoritos_producto_id_index` (`producto_id`),
  CONSTRAINT `favoritos_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favoritos_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoritos`
--

LOCK TABLES `favoritos` WRITE;
/*!40000 ALTER TABLE `favoritos` DISABLE KEYS */;
/*!40000 ALTER TABLE `favoritos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flujo_caja_proyecciones`
--

DROP TABLE IF EXISTS `flujo_caja_proyecciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flujo_caja_proyecciones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `tipo` enum('INGRESO','EGRESO') NOT NULL,
  `concepto` varchar(200) NOT NULL,
  `monto_proyectado` decimal(12,2) NOT NULL,
  `monto_real` decimal(12,2) DEFAULT NULL,
  `categoria` enum('VENTAS','COBROS','PRESTAMOS','OTROS_INGRESOS','COMPRAS','PAGOS_PROVEEDORES','SUELDOS','SERVICIOS','IMPUESTOS','PRESTAMOS_PAGO','OTROS_EGRESOS') NOT NULL,
  `estado` enum('PROYECTADO','REALIZADO','CANCELADO') NOT NULL DEFAULT 'PROYECTADO',
  `recurrente` tinyint(1) NOT NULL DEFAULT 0,
  `frecuencia` varchar(20) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flujo_caja_proyecciones_user_id_foreign` (`user_id`),
  KEY `flujo_caja_proyecciones_fecha_tipo_index` (`fecha`,`tipo`),
  KEY `flujo_caja_proyecciones_estado_index` (`estado`),
  CONSTRAINT `flujo_caja_proyecciones_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flujo_caja_proyecciones`
--

LOCK TABLES `flujo_caja_proyecciones` WRITE;
/*!40000 ALTER TABLE `flujo_caja_proyecciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `flujo_caja_proyecciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forma_envios`
--

DROP TABLE IF EXISTS `forma_envios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forma_envios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `departamento_id` varchar(6) NOT NULL COMMENT 'Código ubigeo del departamento (ej: 150000)',
  `provincia_id` varchar(6) DEFAULT NULL COMMENT 'Código ubigeo de la provincia (ej: 150100, null = todo el departamento)',
  `distrito_id` varchar(6) DEFAULT NULL COMMENT 'Código ubigeo del distrito (ej: 150122, null = toda la provincia)',
  `costo` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Costo de envío para esta ubicación',
  `activo` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = Activo, 0 = Inactivo',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_ubicacion` (`departamento_id`,`provincia_id`,`distrito_id`) USING BTREE,
  KEY `idx_departamento` (`departamento_id`) USING BTREE,
  KEY `idx_provincia` (`provincia_id`) USING BTREE,
  KEY `idx_distrito` (`distrito_id`) USING BTREE,
  KEY `idx_activo` (`activo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Formas de envío basadas en ubicación geográfica';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forma_envios`
--

LOCK TABLES `forma_envios` WRITE;
/*!40000 ALTER TABLE `forma_envios` DISABLE KEYS */;
INSERT INTO `forma_envios` VALUES (1,'150000','150100',NULL,15.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(2,'150000','150100','150122',10.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(3,'150000','150100','150131',10.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(4,'150000','150100','150141',12.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(5,'040000',NULL,NULL,25.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(6,'080000',NULL,NULL,30.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(7,'200000',NULL,NULL,28.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18'),(8,'130000','130100',NULL,22.00,1,'2025-11-29 16:26:18','2025-11-29 16:26:18');
/*!40000 ALTER TABLE `forma_envios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forma_envios_backup`
--

DROP TABLE IF EXISTS `forma_envios_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forma_envios_backup` (
  `id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `nombre` varchar(255) NOT NULL COMMENT 'Ej: Delivery en Lima, Recojo en tienda',
  `codigo` varchar(50) NOT NULL COMMENT 'Ej: delivery, recojo_tienda, envio_provincia',
  `descripcion` text DEFAULT NULL,
  `costo` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Costo de envío',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0 COMMENT 'Para ordenar en el frontend',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forma_envios_backup`
--

LOCK TABLES `forma_envios_backup` WRITE;
/*!40000 ALTER TABLE `forma_envios_backup` DISABLE KEYS */;
INSERT INTO `forma_envios_backup` VALUES (1,'LIMA','LI','ENVIO GRATIS',10.00,1,1,'2025-11-27 12:13:25','2025-11-27 12:13:25');
/*!40000 ALTER TABLE `forma_envios_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gastos_operativos`
--

DROP TABLE IF EXISTS `gastos_operativos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gastos_operativos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `categoria` enum('ALQUILER','SERVICIOS','SUELDOS','MARKETING','TRANSPORTE','MANTENIMIENTO','IMPUESTOS','OTROS') NOT NULL,
  `concepto` varchar(200) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `comprobante_tipo` varchar(20) DEFAULT NULL,
  `comprobante_numero` varchar(50) DEFAULT NULL,
  `proveedor_id` bigint(20) unsigned DEFAULT NULL,
  `es_fijo` tinyint(1) NOT NULL DEFAULT 0,
  `es_recurrente` tinyint(1) NOT NULL DEFAULT 0,
  `descripcion` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gastos_operativos_proveedor_id_foreign` (`proveedor_id`),
  KEY `gastos_operativos_user_id_foreign` (`user_id`),
  KEY `gastos_operativos_fecha_categoria_index` (`fecha`,`categoria`),
  CONSTRAINT `gastos_operativos_proveedor_id_foreign` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE SET NULL,
  CONSTRAINT `gastos_operativos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gastos_operativos`
--

LOCK TABLES `gastos_operativos` WRITE;
/*!40000 ALTER TABLE `gastos_operativos` DISABLE KEYS */;
/*!40000 ALTER TABLE `gastos_operativos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guias_remision`
--

DROP TABLE IF EXISTS `guias_remision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guias_remision` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_comprobante` varchar(2) NOT NULL DEFAULT '09',
  `serie` varchar(4) NOT NULL,
  `correlativo` int(11) NOT NULL,
  `tipo_guia` varchar(20) DEFAULT NULL,
  `requiere_sunat` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_emision` date NOT NULL,
  `fecha_inicio_traslado` date NOT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `comprobante_tipo` varchar(2) DEFAULT NULL COMMENT '01=Factura, 03=Boleta',
  `comprobante_serie` varchar(10) DEFAULT NULL,
  `comprobante_numero` varchar(10) DEFAULT NULL,
  `cliente_tipo_documento` varchar(1) DEFAULT NULL,
  `cliente_numero_documento` varchar(20) DEFAULT NULL,
  `cliente_razon_social` varchar(200) DEFAULT NULL,
  `cliente_direccion` varchar(200) DEFAULT NULL,
  `destinatario_tipo_documento` varchar(1) DEFAULT NULL,
  `destinatario_numero_documento` varchar(20) DEFAULT NULL,
  `destinatario_razon_social` varchar(200) DEFAULT NULL,
  `destinatario_direccion` varchar(200) DEFAULT NULL,
  `destinatario_ubigeo` varchar(6) DEFAULT NULL,
  `motivo_traslado` varchar(2) NOT NULL,
  `modalidad_traslado` varchar(2) NOT NULL,
  `peso_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `numero_bultos` int(11) NOT NULL DEFAULT 1,
  `modo_transporte` varchar(2) NOT NULL DEFAULT '01',
  `numero_placa` varchar(20) DEFAULT NULL,
  `constancia_mtc` varchar(50) DEFAULT NULL COMMENT 'Constancia de inscripción MTC del vehículo',
  `transportista_ruc` varchar(11) DEFAULT NULL,
  `transportista_razon_social` varchar(200) DEFAULT NULL,
  `transportista_numero_mtc` varchar(20) DEFAULT NULL,
  `conductor_tipo_documento` varchar(1) DEFAULT NULL,
  `conductor_numero_documento` varchar(20) DEFAULT NULL,
  `transportista_direccion` varchar(200) DEFAULT NULL,
  `numero_licencia` varchar(20) DEFAULT NULL,
  `conductor_dni` varchar(8) DEFAULT NULL,
  `conductor_nombres` varchar(200) DEFAULT NULL,
  `conductor_apellidos` varchar(200) DEFAULT NULL,
  `conductor_licencia` varchar(20) DEFAULT NULL,
  `vehiculo_placa_principal` varchar(10) DEFAULT NULL,
  `vehiculo_placa_secundaria` varchar(10) DEFAULT NULL,
  `punto_partida_ubigeo` varchar(6) NOT NULL,
  `punto_partida_direccion` varchar(200) NOT NULL,
  `punto_llegada_ubigeo` varchar(6) NOT NULL,
  `punto_llegada_direccion` varchar(200) NOT NULL,
  `observaciones` text DEFAULT NULL,
  `nota_sunat` text DEFAULT NULL,
  `estado` enum('PENDIENTE','ACEPTADO','RECHAZADO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `estado_logistico` enum('pendiente','en_transito','entregado','devuelto','anulado') NOT NULL DEFAULT 'pendiente' COMMENT 'Estado del traslado físico',
  `xml_firmado` longtext DEFAULT NULL,
  `xml_respuesta_sunat` longtext DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `codigo_hash` varchar(100) DEFAULT NULL,
  `pdf_base64` longtext DEFAULT NULL,
  `tiene_xml` tinyint(1) NOT NULL DEFAULT 0,
  `tiene_pdf` tinyint(1) NOT NULL DEFAULT 0,
  `tiene_cdr` tinyint(1) NOT NULL DEFAULT 0,
  `numero_ticket` varchar(50) DEFAULT NULL,
  `fecha_aceptacion` timestamp NULL DEFAULT NULL,
  `errores_sunat` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_serie_correlativo_guia` (`serie`,`correlativo`),
  KEY `guias_remision_user_id_foreign` (`user_id`),
  KEY `guias_remision_serie_correlativo_index` (`serie`,`correlativo`),
  KEY `guias_remision_fecha_emision_index` (`fecha_emision`),
  KEY `guias_remision_estado_index` (`estado`),
  KEY `guias_remision_cliente_id_index` (`cliente_id`),
  KEY `idx_venta_id` (`venta_id`),
  CONSTRAINT `guias_remision_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `guias_remision_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guias_remision`
--

LOCK TABLES `guias_remision` WRITE;
/*!40000 ALTER TABLE `guias_remision` DISABLE KEYS */;
/*!40000 ALTER TABLE `guias_remision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guias_remision_detalle`
--

DROP TABLE IF EXISTS `guias_remision_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guias_remision_detalle` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `guia_remision_id` bigint(20) unsigned NOT NULL,
  `item` int(11) NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `codigo_producto` varchar(50) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `unidad_medida` varchar(3) NOT NULL DEFAULT 'KGM',
  `cantidad` decimal(10,2) NOT NULL,
  `peso_unitario` decimal(10,2) NOT NULL,
  `peso_total` decimal(10,2) NOT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `guias_remision_detalle_guia_remision_id_index` (`guia_remision_id`),
  KEY `guias_remision_detalle_producto_id_index` (`producto_id`),
  KEY `guias_remision_detalle_item_index` (`item`),
  CONSTRAINT `guias_remision_detalle_guia_remision_id_foreign` FOREIGN KEY (`guia_remision_id`) REFERENCES `guias_remision` (`id`) ON DELETE CASCADE,
  CONSTRAINT `guias_remision_detalle_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guias_remision_detalle`
--

LOCK TABLES `guias_remision_detalle` WRITE;
/*!40000 ALTER TABLE `guias_remision_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `guias_remision_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_pedido`
--

DROP TABLE IF EXISTS `historial_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_pedido` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint(20) unsigned NOT NULL,
  `estado_anterior_id` bigint(20) unsigned DEFAULT NULL,
  `nuevo_estado_id` bigint(20) unsigned NOT NULL,
  `observaciones` text DEFAULT NULL,
  `cambiado_por` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pedido_id` (`pedido_id`) USING BTREE,
  KEY `estado_anterior_id` (`estado_anterior_id`) USING BTREE,
  KEY `nuevo_estado_id` (`nuevo_estado_id`) USING BTREE,
  KEY `cambiado_por` (`cambiado_por`) USING BTREE,
  CONSTRAINT `historial_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  CONSTRAINT `historial_pedido_ibfk_2` FOREIGN KEY (`estado_anterior_id`) REFERENCES `estados_pedido` (`id`),
  CONSTRAINT `historial_pedido_ibfk_3` FOREIGN KEY (`nuevo_estado_id`) REFERENCES `estados_pedido` (`id`),
  CONSTRAINT `historial_pedido_ibfk_4` FOREIGN KEY (`cambiado_por`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_pedido`
--

LOCK TABLES `historial_pedido` WRITE;
/*!40000 ALTER TABLE `historial_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `jobs_queue_index` (`queue`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kardex`
--

DROP TABLE IF EXISTS `kardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kardex` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `tipo_movimiento` enum('ENTRADA','SALIDA','AJUSTE') NOT NULL,
  `tipo_operacion` enum('COMPRA','VENTA','DEVOLUCION_COMPRA','DEVOLUCION_VENTA','AJUSTE_POSITIVO','AJUSTE_NEGATIVO','INVENTARIO_INICIAL','TRANSFERENCIA_ENTRADA','TRANSFERENCIA_SALIDA','MERMA','ROBO') NOT NULL,
  `documento_tipo` varchar(20) DEFAULT NULL,
  `documento_numero` varchar(50) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `costo_unitario` decimal(12,2) NOT NULL,
  `costo_total` decimal(12,2) NOT NULL,
  `stock_anterior` int(11) NOT NULL,
  `stock_actual` int(11) NOT NULL,
  `costo_promedio` decimal(12,2) NOT NULL,
  `compra_id` bigint(20) unsigned DEFAULT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kardex_compra_id_foreign` (`compra_id`),
  KEY `kardex_venta_id_foreign` (`venta_id`),
  KEY `kardex_user_id_foreign` (`user_id`),
  KEY `kardex_producto_id_fecha_index` (`producto_id`,`fecha`),
  KEY `kardex_tipo_movimiento_index` (`tipo_movimiento`),
  KEY `kardex_tipo_operacion_index` (`tipo_operacion`),
  CONSTRAINT `kardex_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kardex_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kardex_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kardex_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kardex`
--

LOCK TABLES `kardex` WRITE;
/*!40000 ALTER TABLE `kardex` DISABLE KEYS */;
/*!40000 ALTER TABLE `kardex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marcas_productos`
--

DROP TABLE IF EXISTS `marcas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas_productos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `marcas_productos_nombre_unique` (`nombre`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas_productos`
--

LOCK TABLES `marcas_productos` WRITE;
/*!40000 ALTER TABLE `marcas_productos` DISABLE KEYS */;
INSERT INTO `marcas_productos` VALUES (9,'ASTRO','ASTRO GAMING','1758726183_68d408277dd13.png',1,'2025-09-24 07:51:19','2025-09-24 08:03:03'),(10,'ASUS','ASUS GAMING','1758726367_68d408df54eb9.png',1,'2025-09-24 08:02:39','2025-09-24 08:06:30'),(11,'LOGITECH','LOGITECH GAMING','1758726341_68d408c51586f.png',1,'2025-09-24 08:05:41','2025-09-24 08:05:41'),(12,'RAZER','RAZER GAMING','1758727508_68d40d54ce0af.png',1,'2025-09-24 08:11:22','2025-09-24 08:25:08'),(13,'REDRAGON','REDRAGON GAMING','1758727654_68d40de61ea5c.jpg',1,'2025-09-24 08:27:34','2025-09-24 08:27:34'),(14,'INTEL','INTEL GAMING','1758727972_68d40f244daac.png',1,'2025-09-24 08:32:52','2025-09-24 08:32:52'),(15,'AMD','AMD GAMING','1758728112_68d40fb01ee89.jpg',1,'2025-09-24 08:35:12','2025-09-24 08:35:12'),(16,'NVIDIA','NVIDIA GAMING','1758728434_68d410f25690d.png',1,'2025-09-24 08:40:34','2025-09-24 08:40:34'),(17,'CORSAIR','CORSAIR GAMING','1760450606_68ee582e2f4e6.png',1,'2025-10-01 08:35:08','2025-10-14 07:03:26'),(18,'MSI','MSI GAMING','1760451170_68ee5a621925c.png',1,'2025-10-01 09:05:49','2025-10-14 07:12:50'),(19,'DEEPCOOL','DEEPCOOL GAMING','1760450683_68ee587b5e624.png',1,'2025-10-01 09:48:36','2025-10-14 07:04:43'),(20,'GAMEMAX','GAMEMAX GAMING','1760450840_68ee5918e4d63.png',1,'2025-10-01 13:56:51','2025-10-14 07:07:20'),(21,'LIAN LI','LIAN LI GAMING','1760451112_68ee5a2851632.png',1,'2025-10-01 13:59:20','2025-10-14 07:11:52'),(22,'G. SKILL','G. SKILL GAMING','1760450788_68ee58e4403de.png',1,'2025-10-01 14:00:58','2025-10-14 07:06:28'),(23,'KINGSTON','KINGSTON GAMING','1760451056_68ee59f0a1633.png',1,'2025-10-01 14:02:15','2025-10-14 07:10:56'),(24,'GIGABYTE','GIGABYTE GAMING','1760450956_68ee598c7cff5.png',1,'2025-10-01 14:06:09','2025-10-14 07:09:16'),(25,'ANTRYX','ANTRYX GAMING','1760450518_68ee57d687a4b.png',1,'2025-10-01 14:09:10','2025-10-14 07:01:58'),(26,'Seagate','Seagate Gaming','1759759412_68e3cc348d410.jpg',1,'2025-10-06 07:03:32','2025-10-06 07:03:32'),(27,'AORUS','AORUS GAMING','1759759657_68e3cd291fb66.jpg',1,'2025-10-06 07:07:37','2025-10-06 07:07:37');
/*!40000 ALTER TABLE `marcas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL COMMENT 'Nombre del menú (ej: Hogar, Computadoras)',
  `url` varchar(255) NOT NULL COMMENT 'URL de destino (ej: /shop, /contact)',
  `icono` varchar(100) DEFAULT NULL COMMENT 'Clase CSS del icono (ej: ph-house)',
  `orden` int(11) NOT NULL DEFAULT 0 COMMENT 'Orden de visualización (1, 2, 3...)',
  `padre_id` bigint(20) unsigned DEFAULT NULL COMMENT 'ID del menú padre (para submenús)',
  `tipo` enum('header','footer','sidebar') NOT NULL DEFAULT 'header' COMMENT 'Tipo de menú',
  `target` enum('_self','_blank') NOT NULL DEFAULT '_self' COMMENT 'Target del enlace',
  `visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = Visible, 0 = Oculto',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_padre_id` (`padre_id`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_visible` (`visible`),
  KEY `idx_orden` (`orden`),
  CONSTRAINT `fk_menus_padre` FOREIGN KEY (`padre_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Menús configurables del sistema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'Hogar','javascript:void(0)',NULL,1,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(2,'Productos','/shop',NULL,1,1,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(3,'Ofertas','/ofertas',NULL,2,1,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(4,'Remates','/index-three',NULL,3,1,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(5,'Arma tu PC','/arma-tu-pc',NULL,2,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(6,'Computadoras','/index-two',NULL,3,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(7,'Laptops','/index-laptop',NULL,4,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(8,'Pasos de Envío','/pasos-envio',NULL,5,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(9,'Contáctanos','/contact',NULL,6,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_pago` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodos_pago`
--

LOCK TABLES `metodos_pago` WRITE;
/*!40000 ALTER TABLE `metodos_pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_05_21_141516_create_personal_access_tokens_table',1),(5,'2025_05_23_212502_create_user_profiles_table',1),(6,'2025_05_23_212626_create_user_addresses_table',1),(7,'2025_05_23_223135_add_last_names_to_user_profiles_table',1),(8,'2025_05_24_135354_create_roles_table',1),(9,'2025_05_24_224316_add_is_enabled_to_users_table',1),(10,'2025_05_25_040524_create_ubigeo_inei_table',1),(11,'2025_05_26_120602_create_document_types_table',1),(12,'2025_05_26_225958_remove_address_line_from_user_addresses_table',1),(13,'2025_05_27_223827_create_categorias_table',1),(14,'2025_05_27_223837_create_productos_table',1),(15,'2025_05_28_000008_add_address_line_to_user_addresses_table',2),(16,'2025_11_03_142045_add_sunat_fields_to_guias_remision_table',3),(17,'2024_11_04_000001_create_favoritos_table',4),(18,'2025_11_11_000001_create_nota_creditos_table',5),(19,'2025_11_11_000002_create_nota_debitos_table',6),(20,'2025_11_12_000001_add_sunat_fields_to_notas_tables',7),(21,'2025_11_12_172618_add_pdf_to_notas_tables',8),(22,'2025_11_14_000001_add_generado_estado_to_notas',9),(23,'2025_11_15_140000_change_estado_to_enum_in_guias_remision',10);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`) USING BTREE,
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE,
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
INSERT INTO `model_has_permissions` VALUES (139,'App\\Models\\User',1),(139,'App\\Models\\User',29),(139,'App\\Models\\User',31),(139,'App\\Models\\User',35),(140,'App\\Models\\User',1),(140,'App\\Models\\User',31),(141,'App\\Models\\User',1),(141,'App\\Models\\User',29),(141,'App\\Models\\User',31),(141,'App\\Models\\User',35),(142,'App\\Models\\User',1),(142,'App\\Models\\User',31),(143,'App\\Models\\User',31),(144,'App\\Models\\User',1),(144,'App\\Models\\User',31),(145,'App\\Models\\User',1),(145,'App\\Models\\User',29),(145,'App\\Models\\User',31),(145,'App\\Models\\User',35),(146,'App\\Models\\User',1),(146,'App\\Models\\User',31),(147,'App\\Models\\User',1),(147,'App\\Models\\User',31),(148,'App\\Models\\User',1),(148,'App\\Models\\User',31),(149,'App\\Models\\User',1),(149,'App\\Models\\User',31),(150,'App\\Models\\User',1),(150,'App\\Models\\User',31),(151,'App\\Models\\User',1),(151,'App\\Models\\User',31),(316,'App\\Models\\User',1),(316,'App\\Models\\User',31),(317,'App\\Models\\User',1),(317,'App\\Models\\User',31);
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`) USING BTREE,
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE,
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES (1,'App\\Models\\User',1),(1,'App\\Models\\User',31),(3,'App\\Models\\User',29),(3,'App\\Models\\User',35),(5,'App\\Models\\UserMotorizado',1),(5,'App\\Models\\UserMotorizado',2),(5,'App\\Models\\UserMotorizado',3),(5,'App\\Models\\UserMotorizado',4),(5,'App\\Models\\UserMotorizado',5);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motorizado_estados`
--

DROP TABLE IF EXISTS `motorizado_estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `motorizado_estados` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `motorizado_id` bigint(20) unsigned NOT NULL,
  `estado` enum('disponible','ocupado','en_ruta','descanso','offline') DEFAULT 'offline',
  `latitud` decimal(10,8) DEFAULT NULL COMMENT 'Ubicacion actual',
  `longitud` decimal(11,8) DEFAULT NULL COMMENT 'Ubicacion actual',
  `ultima_actividad` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_motorizado_id` (`motorizado_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_ultima_actividad` (`ultima_actividad`),
  CONSTRAINT `motorizado_estados_ibfk_1` FOREIGN KEY (`motorizado_id`) REFERENCES `motorizados` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Estados y ubicacion en tiempo real de motorizados';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motorizado_estados`
--

LOCK TABLES `motorizado_estados` WRITE;
/*!40000 ALTER TABLE `motorizado_estados` DISABLE KEYS */;
/*!40000 ALTER TABLE `motorizado_estados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motorizados`
--

DROP TABLE IF EXISTS `motorizados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `motorizados` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `numero_unidad` varchar(20) NOT NULL,
  `nombre_completo` varchar(255) NOT NULL,
  `foto_perfil` varchar(500) DEFAULT NULL,
  `tipo_documento_id` bigint(20) unsigned NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `licencia_numero` varchar(50) NOT NULL,
  `licencia_categoria` enum('A1','A2a','A2b','A3a','A3b','A3c') NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `direccion_detalle` text NOT NULL,
  `ubigeo` bigint(20) unsigned NOT NULL,
  `vehiculo_marca` varchar(100) NOT NULL,
  `vehiculo_modelo` varchar(100) NOT NULL,
  `vehiculo_ano` year(4) NOT NULL,
  `vehiculo_cilindraje` varchar(50) NOT NULL,
  `vehiculo_color_principal` varchar(50) NOT NULL,
  `vehiculo_color_secundario` varchar(50) DEFAULT NULL,
  `vehiculo_placa` varchar(20) NOT NULL,
  `vehiculo_motor` varchar(100) NOT NULL,
  `vehiculo_chasis` varchar(100) NOT NULL,
  `comentario` text DEFAULT NULL,
  `registrado_por` bigint(20) unsigned NOT NULL,
  `user_motorizado_id` bigint(20) unsigned DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_documento` (`numero_documento`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `vehiculo_placa` (`vehiculo_placa`),
  KEY `fk_motorizados_tipo_documento` (`tipo_documento_id`),
  KEY `fk_motorizados_registrado_por` (`registrado_por`),
  KEY `fk_motorizados_ubigeo` (`ubigeo`),
  KEY `idx_user_motorizado_id` (`user_motorizado_id`),
  KEY `idx_motorizados_estado` (`estado`),
  KEY `idx_motorizados_numero_unidad` (`numero_unidad`),
  CONSTRAINT `fk_motorizados_registrado_por` FOREIGN KEY (`registrado_por`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_motorizados_tipo_documento` FOREIGN KEY (`tipo_documento_id`) REFERENCES `document_types` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_motorizados_ubigeo` FOREIGN KEY (`ubigeo`) REFERENCES `ubigeo_inei` (`id_ubigeo`) ON UPDATE CASCADE,
  CONSTRAINT `motorizados_ibfk_1` FOREIGN KEY (`user_motorizado_id`) REFERENCES `user_motorizados` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motorizados`
--

LOCK TABLES `motorizados` WRITE;
/*!40000 ALTER TABLE `motorizados` DISABLE KEYS */;
INSERT INTO `motorizados` VALUES (1,'MOT-001','Pablito de los Backyardingas Luján Carrión','http://magus-ecommerce.com/ecommerce-back/public/storage/motorizados/fotos/1758377290_WhatsApp Image 2025-08-15 at 6.41.46 PM.jpeg',1,'73584788','CK - 64545','A2b','968745845','pablito033@gmail.com','Surco',1417,'Yamaha','Crkf3131',2016,'155c','Azul',NULL,'ASE- 45654','LRC - 9165155','VIM - 95485454','No sabe manejar',1,NULL,1,'2025-09-18 13:01:31','2025-09-20 07:08:10'),(5,'MOT-004','SEBASTIAN',NULL,1,'77422200','352432vfd','A1','+51 993 321 920','akame17ga20kill@gmail.com','dfvdsdsfvds',1088,'dfsvds','sdfvds',2002,'dfsvbdfsv','svfds','dvsf','dsfvdsv','dfvs','fvds','dfsvsdfvfd',1,4,1,'2025-09-29 08:56:02','2025-09-29 08:56:03'),(6,'MOT-005','Manuel Aguado',NULL,1,'42799312','47429292','A2a','972781904','magus@gmail.com','Santa Anita',1440,'Susuki','R6',2025,'1500cc','plomo',NULL,'f6f6','877ff6f78','uf7f7f7f','Hola',1,5,1,'2025-11-24 21:28:36','2025-11-24 21:28:37');
/*!40000 ALTER TABLE `motorizados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nota_creditos`
--

DROP TABLE IF EXISTS `nota_creditos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nota_creditos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `serie` varchar(10) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `serie_comprobante_ref` varchar(10) DEFAULT NULL,
  `numero_comprobante_ref` varchar(20) DEFAULT NULL,
  `tipo_comprobante_ref` varchar(10) DEFAULT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `motivo` varchar(255) NOT NULL,
  `tipo_nota_credito` varchar(10) NOT NULL DEFAULT '01',
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `igv` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `moneda` varchar(3) NOT NULL DEFAULT 'PEN',
  `estado` enum('pendiente','generado','enviado','aceptado','rechazado','anulado') DEFAULT 'pendiente',
  `xml` text DEFAULT NULL,
  `cdr` text DEFAULT NULL,
  `pdf` longtext DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `codigo_error_sunat` varchar(50) DEFAULT NULL,
  `fecha_envio_sunat` timestamp NULL DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nota_creditos_venta_id_foreign` (`venta_id`),
  KEY `nota_creditos_cliente_id_foreign` (`cliente_id`),
  KEY `nota_creditos_serie_numero_index` (`serie`,`numero`),
  KEY `nota_creditos_fecha_emision_index` (`fecha_emision`),
  KEY `nota_creditos_estado_index` (`estado`),
  CONSTRAINT `nota_creditos_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `nota_creditos_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nota_creditos`
--

LOCK TABLES `nota_creditos` WRITE;
/*!40000 ALTER TABLE `nota_creditos` DISABLE KEYS */;
/*!40000 ALTER TABLE `nota_creditos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nota_debitos`
--

DROP TABLE IF EXISTS `nota_debitos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nota_debitos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `serie` varchar(10) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `serie_comprobante_ref` varchar(10) DEFAULT NULL,
  `numero_comprobante_ref` varchar(20) DEFAULT NULL,
  `tipo_comprobante_ref` varchar(10) DEFAULT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `motivo` varchar(255) NOT NULL,
  `tipo_nota_debito` varchar(10) NOT NULL DEFAULT '01',
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `igv` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `moneda` varchar(3) NOT NULL DEFAULT 'PEN',
  `estado` enum('pendiente','generado','enviado','aceptado','rechazado','anulado') DEFAULT 'pendiente',
  `xml` text DEFAULT NULL,
  `cdr` text DEFAULT NULL,
  `pdf` longtext DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `codigo_error_sunat` varchar(50) DEFAULT NULL,
  `fecha_envio_sunat` timestamp NULL DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nota_debitos_venta_id_foreign` (`venta_id`),
  KEY `nota_debitos_cliente_id_foreign` (`cliente_id`),
  KEY `nota_debitos_serie_numero_index` (`serie`,`numero`),
  KEY `nota_debitos_fecha_emision_index` (`fecha_emision`),
  KEY `nota_debitos_estado_index` (`estado`),
  CONSTRAINT `nota_debitos_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `nota_debitos_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nota_debitos`
--

LOCK TABLES `nota_debitos` WRITE;
/*!40000 ALTER TABLE `nota_debitos` DISABLE KEYS */;
/*!40000 ALTER TABLE `nota_debitos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `tipo` enum('VENTA_REALIZADA','PAGO_RECIBIDO','COMPROBANTE_GENERADO','CUENTA_POR_COBRAR','RECORDATORIO_PAGO','VOUCHER_VERIFICADO','PEDIDO_ENVIADO','OTRO') NOT NULL,
  `canal` enum('EMAIL','WHATSAPP','SMS','SISTEMA') NOT NULL,
  `asunto` varchar(255) NOT NULL,
  `mensaje` text NOT NULL,
  `datos_adicionales` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_adicionales`)),
  `estado` enum('PENDIENTE','ENVIADO','FALLIDO') NOT NULL DEFAULT 'PENDIENTE',
  `enviado_at` timestamp NULL DEFAULT NULL,
  `error` text DEFAULT NULL,
  `intentos` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notificaciones_user_id_estado_index` (`user_id`,`estado`),
  KEY `notificaciones_tipo_canal_index` (`tipo`,`canal`),
  KEY `notificaciones_estado_index` (`estado`),
  CONSTRAINT `notificaciones_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
INSERT INTO `notificaciones` VALUES (1,NULL,'VICTOR@gmail.com','926703231','VENTA_REALIZADA','EMAIL','Gracias por tu compra #76','Hola YORCHS BRAULIO CANCHARI RIQUI,\n\nGracias por tu compra en Magus.\n\nNúmero de venta: 76\nTotal: S/ 2,030.00\nFecha: 28/10/2025 13:00\n\nEn breve recibirás tu comprobante electrónico.\n\nSaludos,\nEquipo Magus','{\"nombre\":\"YORCHS BRAULIO CANCHARI RIQUI\",\"numero_venta\":76,\"total\":\"S\\/ 2,030.00\",\"fecha\":\"28\\/10\\/2025 13:00\"}','ENVIADO','2025-10-28 12:00:20',NULL,0,'2025-10-28 12:00:17','2025-10-28 12:00:20'),(2,NULL,'vcanchari38@gmail.com','926703231','VENTA_REALIZADA','EMAIL','Gracias por tu compra #80','Hola YORCHS BRAULIO CANCHARI RIQUI,\n\nGracias por tu compra en Magus.\n\nNúmero de venta: 80\nTotal: S/ 830.00\nFecha: 03/11/2025 10:54\n\nEn breve recibirás tu comprobante electrónico.\n\nSaludos,\nEquipo Magus','{\"nombre\":\"YORCHS BRAULIO CANCHARI RIQUI\",\"numero_venta\":80,\"total\":\"S\\/ 830.00\",\"fecha\":\"03\\/11\\/2025 10:54\"}','ENVIADO','2025-11-03 15:54:36',NULL,0,'2025-11-03 15:54:32','2025-11-03 15:54:36'),(3,NULL,'systemcraft.pe@gmail.com','972781904','VENTA_REALIZADA','EMAIL','Gracias por tu compra #81','Hola MANUEL HIPOLITO AGUADO SIERRA,\n\nGracias por tu compra en Magus.\n\nNúmero de venta: 81\nTotal: S/ 700.00\nFecha: 03/11/2025 11:18\n\nEn breve recibirás tu comprobante electrónico.\n\nSaludos,\nEquipo Magus','{\"nombre\":\"MANUEL HIPOLITO AGUADO SIERRA\",\"numero_venta\":81,\"total\":\"S\\/ 700.00\",\"fecha\":\"03\\/11\\/2025 11:18\"}','ENVIADO','2025-11-03 16:18:16',NULL,0,'2025-11-03 16:18:13','2025-11-03 16:18:16');
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones_enviadas`
--

DROP TABLE IF EXISTS `notificaciones_enviadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones_enviadas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) NOT NULL,
  `destinatario` varchar(255) NOT NULL,
  `asunto` varchar(255) DEFAULT NULL,
  `mensaje` text NOT NULL,
  `canal` enum('EMAIL','SMS','PUSH','WHATSAPP') NOT NULL,
  `estado` enum('PENDIENTE','ENVIADO','FALLIDO') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `error_mensaje` text DEFAULT NULL,
  `referencia_tipo` varchar(50) DEFAULT NULL,
  `referencia_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notificaciones_enviadas_estado_index` (`estado`),
  KEY `notificaciones_enviadas_canal_index` (`canal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones_enviadas`
--

LOCK TABLES `notificaciones_enviadas` WRITE;
/*!40000 ALTER TABLE `notificaciones_enviadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones_enviadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofertas`
--

DROP TABLE IF EXISTS `ofertas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ofertas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `subtitulo` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo_oferta_id` int(10) unsigned DEFAULT NULL,
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
  `es_oferta_principal` tinyint(1) NOT NULL DEFAULT 0,
  `es_oferta_semana` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tipo_oferta_id` (`tipo_oferta_id`) USING BTREE,
  CONSTRAINT `ofertas_ibfk_1` FOREIGN KEY (`tipo_oferta_id`) REFERENCES `tipos_ofertas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofertas`
--

LOCK TABLES `ofertas` WRITE;
/*!40000 ALTER TABLE `ofertas` DISABLE KEYS */;
INSERT INTO `ofertas` VALUES (3,'OFERTA POR TIEMPO LIMITADO','10% DE DESCUENTO','Estamos rematando por nuestro aniversario',NULL,'porcentaje',10.00,500.00,'2025-10-01 13:45:00','2025-10-02 13:45:00','ofertas/KwZ0AZXh2SoIzj39WrNVuyuYwBNjsoFpsiajntAH.png','ofertas/banners/tjnfWB8usxrEGEdLcX7sQ3hkxQBh1uR1pDiHRCzm.jpg','#3B82F6','Compra ahora','https://magus-ecommerce.com/product-details/57',3,0,1,0,0,0,0,'2025-10-01 11:49:01','2025-10-02 17:21:13',1,0),(4,'sopa res','dfsvds','sfdvcds',NULL,'porcentaje',12.00,322.00,'2025-10-02 14:53:00','2025-10-25 14:53:00',NULL,'ofertas/banners/nUcf30gpYeFdLlYOYgTi9ZvmXkzT1NMJXdJl5l3j.png','#3B82F6','Compra ahora','/shop',2,0,1,1,1,1,1,'2025-10-02 12:53:43','2025-10-02 12:53:43',0,0);
/*!40000 ALTER TABLE `ofertas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofertas_productos`
--

DROP TABLE IF EXISTS `ofertas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ofertas_productos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `oferta_id` int(10) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `precio_oferta` decimal(10,2) DEFAULT NULL,
  `stock_oferta` int(11) DEFAULT NULL,
  `vendidos_oferta` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `oferta_producto_unique` (`oferta_id`,`producto_id`) USING BTREE,
  KEY `producto_id` (`producto_id`) USING BTREE,
  CONSTRAINT `ofertas_productos_ibfk_1` FOREIGN KEY (`oferta_id`) REFERENCES `ofertas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ofertas_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofertas_productos`
--

LOCK TABLES `ofertas_productos` WRITE;
/*!40000 ALTER TABLE `ofertas_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofertas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compra_id` bigint(20) unsigned DEFAULT NULL,
  `comprobante_id` bigint(20) unsigned DEFAULT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `moneda` varchar(3) DEFAULT 'PEN',
  `referencia_pago` varchar(255) DEFAULT NULL,
  `proveedor_pago` varchar(100) DEFAULT NULL COMMENT 'Culqi, Niubiz, PayPal, etc',
  `estado` enum('PENDIENTE','APROBADO','RECHAZADO','REEMBOLSADO') DEFAULT 'PENDIENTE',
  `fecha_pago` timestamp NULL DEFAULT NULL,
  `fecha_confirmacion` timestamp NULL DEFAULT NULL,
  `datos_adicionales` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Data del webhook o respuesta de pasarela' CHECK (json_valid(`datos_adicionales`)),
  `ip_origen` varchar(45) DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_compra` (`compra_id`),
  KEY `idx_comprobante` (`comprobante_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_metodo_pago` (`metodo_pago`),
  KEY `idx_referencia` (`referencia_pago`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de transacciones de pago';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pasos_envio`
--

DROP TABLE IF EXISTS `pasos_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pasos_envio` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `orden` int(11) NOT NULL DEFAULT 1 COMMENT 'Orden de visualización del paso',
  `titulo` varchar(255) NOT NULL COMMENT 'Título del paso',
  `descripcion` text DEFAULT NULL COMMENT 'Descripción del paso',
  `imagen` varchar(500) DEFAULT NULL COMMENT 'Ruta de la imagen del paso (opcional)',
  `activo` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Si el paso está activo o no',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pasos_envio_activo_orden_index` (`activo`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasos_envio`
--

LOCK TABLES `pasos_envio` WRITE;
/*!40000 ALTER TABLE `pasos_envio` DISABLE KEYS */;
INSERT INTO `pasos_envio` VALUES (1,1,'Realiza el pedido por nuestra web','realizar pedido','pasos-envio/paso_1762293247_690a75ff11632.jpg',1,'2025-11-04 21:54:07','2025-11-04 21:54:07'),(2,2,'Espera su transporte','El pedido pasará al area logistica quien manejara su traslado','pasos-envio/paso_1762293282_690a76229fd0d.png',1,'2025-11-04 21:54:42','2025-11-04 21:54:42'),(3,3,'Recibe en casa','El repartidor final lo dejará en la puerta de tu domicilio.','pasos-envio/paso_1762293330_690a7652604f7.png',1,'2025-11-04 21:55:30','2025-11-04 21:55:30');
/*!40000 ALTER TABLE `pasos_envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `email_index` (`email`) USING BTREE,
  KEY `email_token_index` (`email`,`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES ('koenjisuzune@gmail.com','$2y$12$.48wHwduy1gHPt.UcSR.ROr8J1uPjkS8ozqZwQE9KWRiTNBn6nIDu','2025-07-08 21:20:51'),('chinchayjuan95@gmail.com','$2y$12$l/vz8ZcWMB6O1fiEwCR7fuFpgzgTT0w5t5uHLFbtIdVaYjdJ3tWXO','2025-08-14 19:10:43'),('ladysct11@gmail.com','$2y$12$kpPC/w8wIIpSCXjs3SMGvumU1QPNFvbX.qEdQdQfSIkhA6J2EKK6K','2025-09-29 08:33:15'),('anasilvia123vv@gmail.com','$2y$12$JwBHsFyJ7TdnmRwGsFqv2.0UIZVkgSmqoi2g9udi6LpcH5qlcCqQq','2025-09-29 09:01:31'),('kiyotakahitori@gmail.com','$2y$12$i8zYrlJkLp5d7sgCSaLgN.2fD8l2nU69WtVPwIDU1A98y0bGtGoIK','2025-10-01 10:49:54'),('systemcraft.pe@gmail.com','$2y$12$DsmdAPP52W5wqq.T9WLsQegFz30S4wn.lBtScK8TNhirZTB5CyH56','2025-11-24 14:38:23'),('umbrellasrl@gmail.com','$2y$12$9vpBEuZU.DCij7e9dQXRaeSRBFXWA95DVB7DSWHqL0byo.inPiUcO','2025-11-24 14:59:06'),('manuel.aguado@magustechnologies.com','$2y$12$h.M1rNMFnG9jHp3I2mIdgeoF5RiA1nzB1Z1LP0tCoBxLSiLnOcdZO','2025-11-24 15:00:33'),('emer17rodrigo@gmail.com','$2y$12$xsB8utSd3YQscQcCFT0H4uk4mFDZNmBBWxr9qfv2lYoynvmUB0CBO','2025-11-24 15:01:28');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_detalles`
--

DROP TABLE IF EXISTS `pedido_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `codigo_producto` varchar(255) NOT NULL,
  `nombre_producto` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pedido_detalles_pedido_id_index` (`pedido_id`) USING BTREE,
  KEY `pedido_detalles_producto_id_index` (`producto_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_detalles`
--

LOCK TABLES `pedido_detalles` WRITE;
/*!40000 ALTER TABLE `pedido_detalles` DISABLE KEYS */;
INSERT INTO `pedido_detalles` VALUES (1,1,3,'AUD-213','AUDIFONOS',1,222.00,222.00,'2025-09-01 07:27:54','2025-09-01 07:27:54'),(2,1,9,'324adcs','desipiador de aire',1,123.00,123.00,'2025-09-01 07:27:54','2025-09-01 07:27:54'),(3,2,12,'ajsk21','AJAZZ AK820PRO',1,210.00,210.00,'2025-09-08 05:35:28','2025-09-08 05:35:28'),(4,3,3,'AUD-213','AUDIFONOS',1,222.00,222.00,'2025-09-09 10:56:47','2025-09-09 10:56:47'),(5,3,9,'324adcs','desipiador de aire',1,123.00,123.00,'2025-09-09 10:56:47','2025-09-09 10:56:47');
/*!40000 ALTER TABLE `pedido_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_motorizado`
--

DROP TABLE IF EXISTS `pedido_motorizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_motorizado` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint(20) unsigned NOT NULL,
  `motorizado_id` bigint(20) unsigned NOT NULL,
  `asignado_por` bigint(20) unsigned DEFAULT NULL COMMENT 'Admin que asigno',
  `estado_asignacion` enum('asignado','aceptado','en_camino','entregado','cancelado') DEFAULT 'asignado',
  `fecha_asignacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_aceptacion` timestamp NULL DEFAULT NULL,
  `fecha_inicio` timestamp NULL DEFAULT NULL COMMENT 'Cuando inicia el viaje',
  `fecha_entrega` timestamp NULL DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_pedido_motorizado_activo` (`pedido_id`,`motorizado_id`),
  KEY `idx_pedido_id` (`pedido_id`),
  KEY `idx_motorizado_id` (`motorizado_id`),
  KEY `idx_estado_asignacion` (`estado_asignacion`),
  KEY `idx_fecha_asignacion` (`fecha_asignacion`),
  KEY `asignado_por` (`asignado_por`),
  CONSTRAINT `pedido_motorizado_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pedido_motorizado_ibfk_2` FOREIGN KEY (`motorizado_id`) REFERENCES `motorizados` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pedido_motorizado_ibfk_3` FOREIGN KEY (`asignado_por`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Asignacion de pedidos a motorizados';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_motorizado`
--

LOCK TABLES `pedido_motorizado` WRITE;
/*!40000 ALTER TABLE `pedido_motorizado` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_motorizado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_tracking`
--

DROP TABLE IF EXISTS `pedido_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_tracking` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint(20) unsigned NOT NULL,
  `estado_pedido_id` bigint(20) unsigned NOT NULL,
  `comentario` text DEFAULT NULL,
  `usuario_id` bigint(20) unsigned NOT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pedido_tracking_pedido_id_foreign` (`pedido_id`) USING BTREE,
  KEY `pedido_tracking_estado_pedido_id_foreign` (`estado_pedido_id`) USING BTREE,
  KEY `pedido_tracking_usuario_id_foreign` (`usuario_id`) USING BTREE,
  CONSTRAINT `pedido_tracking_estado_pedido_id_foreign` FOREIGN KEY (`estado_pedido_id`) REFERENCES `estados_pedido` (`id`),
  CONSTRAINT `pedido_tracking_pedido_id_foreign` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pedido_tracking_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_tracking`
--

LOCK TABLES `pedido_tracking` WRITE;
/*!40000 ALTER TABLE `pedido_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo_pedido` varchar(255) NOT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `user_cliente_id` bigint(20) unsigned DEFAULT NULL,
  `cotizacion_id` bigint(20) unsigned DEFAULT NULL,
  `tipo_pedido` enum('directo','desde_cotizacion') DEFAULT 'directo',
  `fecha_pedido` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado_pedido_id` bigint(20) unsigned NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `direccion_envio` text DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `numero_documento` varchar(20) DEFAULT NULL,
  `cliente_nombre` varchar(255) DEFAULT NULL,
  `cliente_email` varchar(255) DEFAULT NULL,
  `forma_envio` varchar(50) DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT 0.00,
  `departamento_id` varchar(2) DEFAULT NULL,
  `provincia_id` varchar(2) DEFAULT NULL,
  `distrito_id` varchar(2) DEFAULT NULL,
  `departamento_nombre` varchar(100) DEFAULT NULL,
  `provincia_nombre` varchar(100) DEFAULT NULL,
  `distrito_nombre` varchar(100) DEFAULT NULL,
  `ubicacion_completa` varchar(500) DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `pedidos_codigo_pedido_unique` (`codigo_pedido`) USING BTREE,
  KEY `pedidos_cliente_id_index` (`cliente_id`) USING BTREE,
  KEY `pedidos_user_cliente_id_index` (`user_cliente_id`) USING BTREE,
  KEY `pedidos_estado_pedido_id_index` (`estado_pedido_id`) USING BTREE,
  KEY `pedidos_fecha_pedido_index` (`fecha_pedido`) USING BTREE,
  KEY `pedidos_user_id_foreign` (`user_id`) USING BTREE,
  KEY `pedidos_cotizacion_id_foreign` (`cotizacion_id`),
  CONSTRAINT `pedidos_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'PED-20250901-0001',NULL,3,NULL,'directo','2025-09-01 09:27:54',345.00,62.10,0.00,407.10,1,'tarjeta','asdfdfsvdfsvdsfvfdsvfedsvdfsvf','asxcxzdcvdfvbgftd','999999999',NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-09-01 07:27:54','2025-09-01 07:27:54'),(2,'PED-20250908-0002',NULL,21,NULL,'directo','2025-09-08 07:35:28',210.00,37.80,0.00,247.80,1,'tarjeta','ssfs fsfsefsefsf','asd adadadawda','926703231',NULL,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-09-08 05:35:28','2025-09-08 05:35:28'),(3,'PED-20250909-0003',NULL,3,NULL,'directo','2025-09-09 12:56:47',345.00,62.10,0.00,407.10,1,'tarjeta',NULL,'dfsbdsfbdsbf','993321920',NULL,'YERA LLOCCLLA ARANGO','rodrigoyarleque7@gmail.com','envio_provincia',7.00,'15','05','04','LIMA','CAÑETE','CERRO AZUL','CERRO AZUL, CAÑETE, LIMA',1,'2025-09-09 10:56:47','2025-09-09 10:56:47');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=321 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (13,'usuarios.ver','web','2025-06-01 01:11:16','2025-06-05 16:59:57'),(16,'usuarios.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(17,'usuarios.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(18,'usuarios.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(19,'usuarios.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(20,'productos.ver','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(21,'productos.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(22,'productos.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(23,'productos.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(24,'productos.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(25,'categorias.ver','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(26,'categorias.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(27,'categorias.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(28,'categorias.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(29,'categorias.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(30,'banners.ver','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(31,'banners.create','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(32,'banners.edit','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(33,'banners.delete','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(38,'banners_promocionales.ver','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(39,'banners_promocionales.create','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(40,'banners_promocionales.edit','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(41,'banners_promocionales.delete','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(42,'clientes.ver','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(43,'clientes.create','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(44,'clientes.show','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(45,'clientes.edit','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(46,'clientes.delete','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(47,'marcas.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(48,'marcas.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(49,'marcas.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(50,'marcas.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(51,'pedidos.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(52,'pedidos.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(53,'pedidos.show','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(54,'pedidos.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(55,'secciones.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(56,'secciones.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(57,'secciones.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(58,'secciones.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(59,'cupones.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(60,'cupones.show','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(61,'cupones.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(62,'cupones.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(63,'cupones.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(64,'ofertas.ver','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(65,'ofertas.edit','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(66,'ofertas.show','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(67,'ofertas.create','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(68,'ofertas.delete','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(69,'horarios.ver','web','2025-07-14 07:28:35','2025-07-14 07:28:35'),(70,'horarios.create','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(71,'horarios.show','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(72,'horarios.edit','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(73,'horarios.delete','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(74,'empresa_info.ver','web','2025-07-19 06:52:57','2025-07-19 06:52:57'),(75,'empresa_info.edit','web','2025-07-19 06:52:57','2025-07-19 06:52:57'),(76,'envio_correos.ver','web','2025-08-14 17:54:08','2025-08-14 17:54:08'),(77,'envio_correos.edit','web','2025-08-14 17:54:19','2025-08-14 17:54:19'),(78,'reclamos.ver','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(79,'reclamos.show','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(80,'reclamos.edit','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(81,'reclamos.delete','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(86,'cotizaciones.ver','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(87,'cotizaciones.show','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(88,'cotizaciones.create','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(89,'cotizaciones.edit','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(90,'cotizaciones.delete','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(91,'cotizaciones.aprobar','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(92,'compras.ver','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(93,'compras.show','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(94,'compras.create','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(95,'compras.edit','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(96,'compras.delete','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(97,'compras.aprobar','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(98,'envio_correos.create','web','2025-09-16 20:07:13','2025-09-16 20:07:13'),(99,'envio_correos.delete','web','2025-09-16 20:07:13','2025-09-16 20:07:13'),(100,'motorizados.ver','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(101,'motorizados.create','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(102,'motorizados.show','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(103,'motorizados.edit','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(104,'motorizados.delete','web','2025-09-16 20:13:05','2025-09-16 20:13:05'),(105,'pedidos.motorizado.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(106,'pedidos.motorizado.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(107,'pedidos.motorizado.actualizar_estado','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(108,'pedidos.motorizado.actualizar_estado','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(109,'pedidos.motorizado.confirmar_entrega','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(110,'pedidos.motorizado.confirmar_entrega','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(111,'motorizado.perfil.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(112,'motorizado.perfil.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(113,'motorizado.perfil.editar','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(114,'motorizado.perfil.editar','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(115,'motorizado.rutas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(116,'motorizado.rutas.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(117,'motorizado.ubicacion.actualizar','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(118,'motorizado.ubicacion.actualizar','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(119,'motorizado.estadisticas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(120,'motorizado.estadisticas.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(121,'motorizado.chat.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(122,'motorizado.chat.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(123,'motorizado.notificaciones.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(124,'motorizado.notificaciones.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(125,'email_templates.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(126,'email_templates.show','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(127,'email_templates.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(128,'email_templates.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(129,'email_templates.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(130,'ventas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(131,'ventas.show','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(132,'ventas.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(133,'ventas.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(134,'ventas.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(135,'roles.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(136,'roles.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(137,'roles.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(138,'roles.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(139,'recompensas.ver','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(140,'recompensas.create','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(141,'recompensas.show','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(142,'recompensas.edit','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(143,'recompensas.delete','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(144,'recompensas.activate','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(145,'recompensas.analytics','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(146,'recompensas.segmentos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(147,'recompensas.productos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(148,'recompensas.puntos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(149,'recompensas.descuentos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(150,'recompensas.envios','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(151,'recompensas.regalos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(152,'configuracion.ver','web','2025-10-01 09:48:34','2025-10-01 09:48:34'),(153,'configuracion.create','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(154,'configuracion.edit','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(155,'configuracion.delete','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(156,'banners_flash_sales.ver','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(157,'banners_flash_sales.create','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(158,'banners_flash_sales.edit','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(159,'banners_flash_sales.delete','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(160,'banners_ofertas.ver','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(161,'banners_ofertas.create','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(162,'banners_ofertas.edit','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(163,'banners_ofertas.delete','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(164,'contabilidad.cajas.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(165,'contabilidad.cajas.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(166,'contabilidad.cajas.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(167,'contabilidad.kardex.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(168,'contabilidad.kardex.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(169,'contabilidad.cxc.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(170,'contabilidad.cxc.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(171,'contabilidad.cxc.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(172,'contabilidad.cxp.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(173,'contabilidad.cxp.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(174,'contabilidad.cxp.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(175,'contabilidad.proveedores.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(176,'contabilidad.proveedores.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(177,'contabilidad.proveedores.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(178,'contabilidad.caja_chica.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(179,'contabilidad.caja_chica.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(180,'contabilidad.caja_chica.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(181,'contabilidad.flujo_caja.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(182,'contabilidad.flujo_caja.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(183,'contabilidad.flujo_caja.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(184,'contabilidad.reportes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(185,'contabilidad.utilidades.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(186,'contabilidad.utilidades.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(187,'contabilidad.utilidades.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(188,'contabilidad.vouchers.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(189,'contabilidad.vouchers.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(190,'contabilidad.vouchers.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(191,'contabilidad.vouchers.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(192,'facturacion.comprobantes.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(193,'facturacion.comprobantes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(194,'facturacion.comprobantes.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(195,'facturacion.comprobantes.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(196,'facturacion.comprobantes.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(197,'facturacion.comprobantes.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(198,'facturacion.comprobantes.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(199,'facturacion.comprobantes.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(200,'facturacion.comprobantes.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(201,'facturacion.comprobantes.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(202,'facturacion.facturas.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(203,'facturacion.facturas.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(204,'facturacion.facturas.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(205,'facturacion.facturas.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(206,'facturacion.facturas.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(207,'facturacion.facturas.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(208,'facturacion.facturas.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(209,'facturacion.facturas.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(210,'facturacion.series.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(211,'facturacion.series.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(212,'facturacion.series.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(213,'facturacion.series.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(214,'facturacion.series.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(215,'facturacion.series.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(216,'facturacion.notas_credito.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(217,'facturacion.notas_credito.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(218,'facturacion.notas_credito.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(219,'facturacion.notas_credito.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(220,'facturacion.notas_credito.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(221,'facturacion.notas_credito.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(222,'facturacion.notas_credito.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(223,'facturacion.notas_credito.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(224,'facturacion.notas_debito.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(225,'facturacion.notas_debito.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(226,'facturacion.notas_debito.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(227,'facturacion.notas_debito.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(228,'facturacion.notas_debito.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(229,'facturacion.notas_debito.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(230,'facturacion.notas_debito.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(231,'facturacion.notas_debito.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(232,'facturacion.guias_remision.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(233,'facturacion.guias_remision.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(234,'facturacion.guias_remision.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(235,'facturacion.guias_remision.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(236,'facturacion.guias_remision.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(237,'facturacion.guias_remision.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(238,'facturacion.guias_remision.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(239,'facturacion.guias_remision.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(240,'facturacion.certificados.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(241,'facturacion.certificados.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(242,'facturacion.certificados.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(243,'facturacion.certificados.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(244,'facturacion.certificados.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(245,'facturacion.certificados.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(246,'facturacion.certificados.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(247,'facturacion.certificados.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(248,'facturacion.resumenes.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(249,'facturacion.resumenes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(250,'facturacion.resumenes.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(251,'facturacion.resumenes.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(252,'facturacion.resumenes.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(253,'facturacion.resumenes.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(254,'facturacion.bajas.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(255,'facturacion.bajas.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(256,'facturacion.bajas.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(257,'facturacion.bajas.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(258,'facturacion.bajas.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(259,'facturacion.bajas.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(260,'facturacion.auditoria.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(261,'facturacion.auditoria.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(262,'facturacion.reintentos.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(263,'facturacion.reintentos.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(264,'facturacion.reintentos.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(265,'facturacion.reintentos.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(266,'facturacion.catalogos.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(267,'facturacion.catalogos.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(268,'facturacion.empresa.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(269,'facturacion.empresa.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(270,'facturacion.empresa.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(271,'facturacion.empresa.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(272,'facturacion.contingencia.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(273,'facturacion.contingencia.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(274,'facturacion.contingencia.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(275,'facturacion.contingencia.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(276,'facturacion.reportes.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(277,'facturacion.reportes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(278,'facturacion.pagos.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(279,'facturacion.pagos.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(280,'facturacion.pagos.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(281,'facturacion.pagos.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(282,'facturacion.pagos.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(283,'facturacion.pagos.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(284,'facturacion.pagos.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(285,'facturacion.pagos.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(286,'facturacion.pagos.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(287,'facturacion.pagos.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(288,'facturacion.historial_envios.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(289,'facturacion.historial_envios.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(290,'facturacion.historial_envios.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(291,'facturacion.historial_envios.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(292,'facturacion.historial_envios.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(293,'facturacion.historial_envios.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(294,'facturacion.logs.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(295,'facturacion.logs.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(296,'facturacion.logs.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(297,'facturacion.logs.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(298,'facturacion.logs.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(299,'facturacion.logs.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(300,'facturacion.logs.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(301,'facturacion.logs.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(302,'facturacion.configuracion.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(303,'facturacion.configuracion.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(304,'facturacion.configuracion.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(305,'facturacion.configuracion.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(306,'facturacion.integraciones.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(307,'facturacion.integraciones.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(308,'facturacion.integraciones.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(309,'facturacion.integraciones.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(310,'facturacion.integraciones.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(311,'facturacion.integraciones.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(312,'facturacion.integraciones.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(313,'facturacion.integraciones.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(314,'facturacion.integraciones.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(315,'facturacion.integraciones.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(316,'recompensas.popups','web','2025-10-28 08:31:24','2025-10-28 08:31:24'),(317,'recompensas.notificaciones','web','2025-10-28 08:31:24','2025-10-28 08:31:24'),(318,'ventas.facturar','api','2025-10-28 16:22:32','2025-10-28 16:22:32'),(319,'ventas.facturar','web','2025-10-28 17:54:42','2025-10-28 17:54:42'),(320,'pasos_envio.edit','web','2025-11-04 19:40:21','2025-11-04 19:40:21');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`) USING BTREE,
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=400 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (4,'App\\Models\\User',1,'auth_token','8f4fcd36aec6e8130083429a06243bc1641af0ecfbd9243dd5e83df7bae1786f','[\"*\"]','2025-06-06 15:08:00',NULL,'2025-06-06 14:53:46','2025-06-06 15:08:00'),(5,'App\\Models\\User',1,'auth_token','74b6c21260891055a70eccb26735e97d57f9f835944352ff62f723421cb5d8dd','[\"*\"]','2025-06-06 16:03:42',NULL,'2025-06-06 14:55:09','2025-06-06 16:03:42'),(6,'App\\Models\\User',1,'auth_token','744ca78aa44496a4ccc50a29ca6a15ac3f8618751a2a696bfce752f1fc062e17','[\"*\"]','2025-06-06 16:25:33',NULL,'2025-06-06 16:05:49','2025-06-06 16:25:33'),(19,'App\\Models\\UserCliente',1,'cliente_token','60989d38106b9316eb8678ddc3bd0c3697e21d536a4d1144ef999025e4f3275f','[\"*\"]',NULL,NULL,'2025-06-19 14:19:03','2025-06-19 14:19:03'),(22,'App\\Models\\UserCliente',2,'cliente_token','687175aa5df11ec748948acb23373c2dc990146962f227cf9ec30c059c98d7ed','[\"*\"]',NULL,NULL,'2025-06-19 15:25:53','2025-06-19 15:25:53'),(29,'App\\Models\\UserCliente',3,'cliente_token','db7ce46df909698d7b41949808581814c4f308d08d96fc144879e845585079a2','[\"*\"]',NULL,NULL,'2025-06-23 19:36:35','2025-06-23 19:36:35'),(37,'App\\Models\\User',1,'admin_token','1caf6bf018ea1a00457167d8d2426c4eb197bd4e99e416eb9c8f215bb6d66e7d','[\"*\"]','2025-06-30 12:47:31',NULL,'2025-06-30 12:46:19','2025-06-30 12:47:31'),(40,'App\\Models\\User',1,'admin_token','86d76b8819ea43ab9300497e682816b15fcb29c0f80773f389e6c151385b82fc','[\"*\"]','2025-07-05 13:59:12',NULL,'2025-07-05 13:59:10','2025-07-05 13:59:12'),(43,'App\\Models\\UserCliente',4,'cliente_token','9d1ac1230cc9f5e410875ebe38e73c5ec3eee6e9c715c7219e7ca5ea3c853870','[\"*\"]',NULL,NULL,'2025-07-05 20:26:29','2025-07-05 20:26:29'),(44,'App\\Models\\UserCliente',4,'auth_token','dced180bfc593b10d68995beb42f16dee7668e9841671b652f77e3958bdd5891','[\"*\"]',NULL,NULL,'2025-07-06 11:48:36','2025-07-06 11:48:36'),(45,'App\\Models\\UserCliente',4,'auth_token','b7d48ef1eeee919ed326b015ab98756d2c6095934b4a5096d77120c138a7d49c','[\"*\"]',NULL,NULL,'2025-07-06 11:58:36','2025-07-06 11:58:36'),(46,'App\\Models\\UserCliente',4,'auth_token','52e04aba84e4cf8f3ab6b522bad1b4fd3529ac216fa46eff102174bd059a103b','[\"*\"]',NULL,NULL,'2025-07-06 12:00:50','2025-07-06 12:00:50'),(49,'App\\Models\\UserCliente',4,'auth_token','68a7ae5305c6bee694e4fd5c7f39e5890f565c3996b1da86830bdb1b9c9c7754','[\"*\"]',NULL,NULL,'2025-07-06 13:03:13','2025-07-06 13:03:13'),(51,'App\\Models\\UserCliente',5,'cliente_token','890d752f34f61c902014f081e075cb1d7c4852ed7f72186f5cd37e5fce6df759','[\"*\"]',NULL,NULL,'2025-07-08 21:20:38','2025-07-08 21:20:38'),(62,'App\\Models\\User',1,'admin_token','7ea7ad9514959726f25963b3b547cdfc3e68b1112712c04d5e762a49eba58fd9','[\"*\"]','2025-07-11 15:03:36',NULL,'2025-07-11 15:00:06','2025-07-11 15:03:36'),(66,'App\\Models\\UserCliente',3,'auth_token','907c881583064cc503cf4ae3dbf90a8ceb983458533cf4bd2ec3e7eb3712b3cb','[\"*\"]',NULL,NULL,'2025-07-11 20:35:13','2025-07-11 20:35:13'),(67,'App\\Models\\UserCliente',4,'auth_token','bf330d25cf90acb2032d589206307144a3d9cd1ba44f0fab5ea4e898229ca297','[\"*\"]',NULL,NULL,'2025-07-11 23:46:31','2025-07-11 23:46:31'),(70,'App\\Models\\User',1,'admin_token','cd76d143710dac9271017ee4e23174939759a04ac33fdd9e7cbb4eeff3e15772','[\"*\"]','2025-07-14 00:51:14',NULL,'2025-07-14 00:51:05','2025-07-14 00:51:14'),(72,'App\\Models\\User',1,'admin_token','2154a61002d3017078113a8588a5bc3c77585b2a52b3198485c0b56431b79427','[\"*\"]','2025-07-14 07:43:54',NULL,'2025-07-14 07:36:21','2025-07-14 07:43:54'),(77,'App\\Models\\User',1,'admin_token','f9ff984b68d3898908f791dd3e34463f6b6b1ba1f6d58f0b6e6b9ce716d89bd4','[\"*\"]','2025-07-16 14:21:07',NULL,'2025-07-16 14:21:03','2025-07-16 14:21:07'),(78,'App\\Models\\User',1,'admin_token','150db278f254dd606190f73656b5f6e0393811f889042443c1b0a50a172e95ef','[\"*\"]','2025-07-16 17:43:46',NULL,'2025-07-16 15:17:53','2025-07-16 17:43:46'),(83,'App\\Models\\User',1,'admin_token','993828ecddc03aa1ee2bdc0215a1b332afe3858cac6e0562424f8619e666675a','[\"*\"]','2025-07-20 19:26:02',NULL,'2025-07-20 19:25:49','2025-07-20 19:26:02'),(87,'App\\Models\\User',1,'admin_token','96f578aaa56372f292fbc0e59e4b1aba6c4b11b4254ecb588ce8bc5b4bab1895','[\"*\"]',NULL,NULL,'2025-07-21 17:30:39','2025-07-21 17:30:39'),(88,'App\\Models\\User',1,'admin_token','5c4c11a37cd9892fd090954ad1d38726f80b5b91621c2edfdef5bca166d820c0','[\"*\"]','2025-07-21 17:36:50',NULL,'2025-07-21 17:30:55','2025-07-21 17:36:50'),(90,'App\\Models\\User',1,'admin_token','b2a89c1f02a99410860ab7c442b07e0735ea97a5908af3c0fbb3c2c54a683604','[\"*\"]','2025-07-21 17:54:20',NULL,'2025-07-21 17:37:24','2025-07-21 17:54:20'),(91,'App\\Models\\User',1,'admin_token','2fd667e7fd6ac08eed8ca31226b926eace4bfc9898224c3b4b3003def7794c49','[\"*\"]',NULL,NULL,'2025-07-21 17:40:27','2025-07-21 17:40:27'),(92,'App\\Models\\User',1,'admin_token','f20f446272e44612d56d884f15a439c269f389625abba96817e5f07e4e639fa3','[\"*\"]','2025-07-21 17:52:55',NULL,'2025-07-21 17:40:37','2025-07-21 17:52:55'),(94,'App\\Models\\User',1,'admin_token','ad7f84335226034ab164eed0f5b5e3f10249ab116046fd72152396e3abd426b4','[\"*\"]','2025-07-21 18:47:42',NULL,'2025-07-21 18:13:06','2025-07-21 18:47:42'),(95,'App\\Models\\User',1,'admin_token','5b048aa6ab4043233a71262ce5d7cca172d4f8c5035e2940fa2910a8c6a348af','[\"*\"]','2025-07-21 20:41:27',NULL,'2025-07-21 19:07:30','2025-07-21 20:41:27'),(96,'App\\Models\\User',1,'admin_token','2f480e8d6d2647d9ff50852c9c20675bb73bf89d22df9fdad3aeea7628779645','[\"*\"]','2025-07-21 19:30:04',NULL,'2025-07-21 19:29:57','2025-07-21 19:30:04'),(98,'App\\Models\\User',1,'admin_token','880e19f2824211b07ef2a60a8feb3750c22fb7cd2beaa23d880b53577fa57efe','[\"*\"]','2025-07-21 21:02:11',NULL,'2025-07-21 20:18:24','2025-07-21 21:02:11'),(99,'App\\Models\\User',1,'admin_token','0c3b8719c1c8fe7132f81032df3dae9b30815bf5e8b82f66044ce4a10d2a5e3d','[\"*\"]','2025-07-22 07:26:56',NULL,'2025-07-22 07:24:13','2025-07-22 07:26:56'),(100,'App\\Models\\User',1,'admin_token','e8230545d2897115b6da740cea5cd0a1ffb8a72f8a83a96140a6c245fbb42ca9','[\"*\"]','2025-07-22 16:28:55',NULL,'2025-07-22 16:25:01','2025-07-22 16:28:55'),(101,'App\\Models\\User',1,'admin_token','7036282da78c49de8c73e2976cf3b6a6ea94eafbeede07152b8d98438eafe845','[\"*\"]','2025-07-22 16:30:12',NULL,'2025-07-22 16:27:24','2025-07-22 16:30:12'),(103,'App\\Models\\UserCliente',15,'cliente_token','8f5ef3665296f0b55c41531996b8c6c3fd5b432005eae8d7c3b7d2f05460eefb','[\"*\"]',NULL,NULL,'2025-07-24 15:16:52','2025-07-24 15:16:52'),(104,'App\\Models\\User',1,'admin_token','cb277db29a46841f8b66c7f95f82360b3a392c34729cbd82f0285af1b16e39de','[\"*\"]','2025-07-24 15:22:08',NULL,'2025-07-24 15:21:19','2025-07-24 15:22:08'),(106,'App\\Models\\User',1,'admin_token','b7a85cd149e6302e0995de9a810b89f25742ce8703760953f74a2ec016bfa7b0','[\"*\"]','2025-07-30 14:02:34',NULL,'2025-07-30 13:56:52','2025-07-30 14:02:34'),(107,'App\\Models\\User',1,'admin_token','6ccbfa1d89fb43c71d2af2b19f915690111d35154fc1c1f1b8ec9aabf8d1255c','[\"*\"]','2025-07-30 14:07:01',NULL,'2025-07-30 14:06:13','2025-07-30 14:07:01'),(108,'App\\Models\\User',1,'admin_token','735884c3b152fb5c0bda6f1974e68d1de379676947039eb141bfe00d305f183d','[\"*\"]','2025-08-15 13:53:36',NULL,'2025-08-01 16:07:28','2025-08-15 13:53:36'),(109,'App\\Models\\User',1,'admin_token','7c76a275c0008bc8cb965db622fc1069be4e49a8c51b61cf0a1730191fe5d3d0','[\"*\"]','2025-08-14 19:10:29',NULL,'2025-08-14 18:00:19','2025-08-14 19:10:29'),(110,'App\\Models\\User',1,'admin_token','16b287b0f727a012ac30fb672545debac244e624a5fed526356bb72d5ac303a0','[\"*\"]','2025-08-14 20:13:53',NULL,'2025-08-14 19:46:15','2025-08-14 20:13:53'),(111,'App\\Models\\User',1,'admin_token','d0fa5e1b4b7f2217ef5fa1b840af52521133336cef5f4af08a64f94ea06b7e5b','[\"*\"]','2025-10-06 08:16:51',NULL,'2025-08-15 09:39:11','2025-10-06 08:16:51'),(113,'App\\Models\\User',1,'admin_token','9b6c64de7fbb30e893a84680f60dd73c87f4ea7678f1a841defd752e9b7210fb','[\"*\"]','2025-08-19 06:15:58',NULL,'2025-08-16 10:16:17','2025-08-19 06:15:58'),(114,'App\\Models\\UserCliente',3,'cliente_token','e71654541326a40b0c78de84e28c7dbe74a715ec685bd6738214e25f920d25ac','[\"*\"]','2025-08-22 15:43:28',NULL,'2025-08-22 12:24:14','2025-08-22 15:43:28'),(116,'App\\Models\\User',1,'admin_token','4d1918d2e897d91fd1ba9e35274c552ac568ba873e351d2722be3f12b935b7d3','[\"*\"]','2025-09-01 11:55:04',NULL,'2025-09-01 06:55:41','2025-09-01 11:55:04'),(120,'App\\Models\\User',1,'admin_token','66e1f4c894f4f46b0562e5dde878854e6ee23057bade0878da201452ae0a95c2','[\"*\"]','2025-09-02 14:30:48',NULL,'2025-09-02 14:29:58','2025-09-02 14:30:48'),(123,'App\\Models\\UserCliente',21,'auth_token','baf8edec9af883f8d9ae91738e187cd858084058da96e5c2510527f8cd9eb3fe','[\"*\"]',NULL,NULL,'2025-09-07 20:08:06','2025-09-07 20:08:06'),(124,'App\\Models\\UserCliente',21,'auth_token','5dd197ee8640061b735a6fed7a5d6cf01abb670824ad11091aca4654e94de6a1','[\"*\"]',NULL,NULL,'2025-09-07 20:11:27','2025-09-07 20:11:27'),(125,'App\\Models\\UserCliente',21,'cliente_token','ab8b6a68ac7f2de4b6c839d2d63eb60323621b7d9bd5cc86edb17c7aa66f7ac4','[\"*\"]','2025-09-09 13:41:14',NULL,'2025-09-08 05:33:17','2025-09-09 13:41:14'),(138,'App\\Models\\User',1,'admin_token','fa8e9206f44fe4da1b8c250edfecb65553d85a099d779883f1b6473d7dbe8e1e','[\"*\"]','2025-09-16 20:57:48',NULL,'2025-09-16 20:44:16','2025-09-16 20:57:48'),(139,'App\\Models\\UserCliente',22,'auth_token','b004b92b094cfba1a69970c56e22e1934b82b4c9ad3f97ef1a48e0775a5eeaa6','[\"*\"]',NULL,NULL,'2025-09-18 10:45:08','2025-09-18 10:45:08'),(142,'App\\Models\\UserCliente',4,'auth_token','fc019d01512299e18d2ebe886e673ee23d7279e8547b93c09f95a4fc3d524bfb','[\"*\"]',NULL,NULL,'2025-09-18 16:02:11','2025-09-18 16:02:11'),(143,'App\\Models\\UserCliente',4,'auth_token','55cdb3975d71f6018c21b9d472428e0f2700aaf8bdb04f35dd6044b8a697e49a','[\"*\"]',NULL,NULL,'2025-09-18 16:02:54','2025-09-18 16:02:54'),(144,'App\\Models\\UserCliente',4,'auth_token','3b268de24d46a9e550c5bd613f96bf0e9bb6dcc5b169ac5d575579b6968786e1','[\"*\"]',NULL,NULL,'2025-09-18 16:03:15','2025-09-18 16:03:15'),(145,'App\\Models\\UserCliente',4,'auth_token','0f664a6102c4bc4cbac811c2eb9c1db3accd0cbe41b0485d0b15d178fa2860c8','[\"*\"]',NULL,NULL,'2025-09-18 16:04:56','2025-09-18 16:04:56'),(146,'App\\Models\\UserCliente',4,'auth_token','72f249d67022798ff78b9b1145971286ee7d846f9a9ed44839abf2c6e0769f6d','[\"*\"]',NULL,NULL,'2025-09-18 16:05:03','2025-09-18 16:05:03'),(147,'App\\Models\\UserCliente',4,'auth_token','8d11acbda58f0273824bf7652b8044fd79090aeff81229753100a0e6e0a16c20','[\"*\"]',NULL,NULL,'2025-09-18 16:34:44','2025-09-18 16:34:44'),(148,'App\\Models\\UserCliente',4,'auth_token','4fe87c278c1ece0ebb4d91cf98a977686402fe5b151a0c629f37c1f4bb7c1ca1','[\"*\"]',NULL,NULL,'2025-09-18 16:50:11','2025-09-18 16:50:11'),(149,'App\\Models\\UserCliente',4,'auth_token','d6c38ab8d2d7b47383e203e238c707c01b1fb3324266f31bd632c81739546c19','[\"*\"]',NULL,NULL,'2025-09-18 16:53:04','2025-09-18 16:53:04'),(150,'App\\Models\\UserCliente',4,'auth_token','be2609afbba1c418f7ef57901578f67af46fce7d126e694c8b484ee1ec5c2824','[\"*\"]',NULL,NULL,'2025-09-18 17:06:40','2025-09-18 17:06:40'),(151,'App\\Models\\UserCliente',4,'auth_token','cc3092d48fa238d13ccfb6209ec7a3fdf56696232521c949dcb1e3b4b53f7b56','[\"*\"]',NULL,NULL,'2025-09-18 17:38:01','2025-09-18 17:38:01'),(153,'App\\Models\\UserCliente',4,'auth_token','91705e5ab5a08c99acce328cb738b1cd6bb033dd0073c48a39ba1050fd54ca0a','[\"*\"]',NULL,NULL,'2025-09-19 11:04:48','2025-09-19 11:04:48'),(154,'App\\Models\\UserCliente',4,'auth_token','f8efbbcb7816b7b7e11198b06e05a1515bee1d54afd09ef7e41e183fe57536f6','[\"*\"]',NULL,NULL,'2025-09-19 13:59:23','2025-09-19 13:59:23'),(158,'App\\Models\\User',1,'admin_token','982fecff465dcf11514d62cc3bb5acc61aeffb0c9234b211bc0cde7e151ff93a','[\"*\"]','2025-10-04 15:33:29',NULL,'2025-09-20 07:43:06','2025-10-04 15:33:29'),(159,'App\\Models\\UserCliente',3,'cliente_token','9b9cfbf83fbe08d3c5302ca8dc2a4ab8ea34eadec76053f53dd4b8e21787f2de','[\"*\"]','2025-09-22 08:20:25',NULL,'2025-09-22 08:00:07','2025-09-22 08:20:25'),(162,'App\\Models\\UserMotorizado',2,'motorizado_token','f559dd0a5e0824e3a5931f96fddd08eb575041fd0e21670bd74f34dbff66fd91','[\"*\"]','2025-09-22 08:45:16',NULL,'2025-09-22 08:45:15','2025-09-22 08:45:16'),(163,'App\\Models\\UserMotorizado',2,'motorizado_token','bfee38ebfc3ce87a18ead59b5174186baf945b99b9f1b0285304e78c1b60ab5e','[\"*\"]','2025-09-22 08:45:21',NULL,'2025-09-22 08:45:21','2025-09-22 08:45:21'),(164,'App\\Models\\UserMotorizado',2,'motorizado_token','1614f5729dd2d4a937c5901c34942a8489d9b9f7d95b59de841f7dbeaf4788bd','[\"*\"]','2025-09-22 08:45:24',NULL,'2025-09-22 08:45:22','2025-09-22 08:45:24'),(168,'App\\Models\\User',1,'admin_token','bd2829570b93a7490d1b750bdd65800e6f52d75484ba3305be38a5380747f01f','[\"*\"]','2025-09-23 13:24:20',NULL,'2025-09-23 13:24:19','2025-09-23 13:24:20'),(175,'App\\Models\\User',1,'admin_token','9b2ebcb36e17ab6e3a7be01de8c402c802eacc16c60994818e4206806eae1ef3','[\"*\"]','2025-09-26 05:20:19',NULL,'2025-09-24 07:55:58','2025-09-26 05:20:19'),(176,'App\\Models\\User',1,'admin_token','b1d41640bec2e3b10b7fff12d65a5e2dea2b1596ecf29daf50d9238325273348','[\"*\"]','2025-09-25 18:55:04',NULL,'2025-09-25 18:44:57','2025-09-25 18:55:04'),(178,'App\\Models\\User',1,'admin_token','8eb07561bb99c0b12a483a8e63e66274c1db554d821683b875307b9b5efbf8fd','[\"*\"]','2025-09-26 05:24:04',NULL,'2025-09-26 05:22:18','2025-09-26 05:24:04'),(180,'App\\Models\\User',1,'admin_token','bacfefad2159f9d2939a834c7609d9d2c7b40ea8659cda094c2b3d0d0950cb18','[\"*\"]','2025-09-26 05:49:06',NULL,'2025-09-26 05:45:02','2025-09-26 05:49:06'),(181,'App\\Models\\User',1,'admin_token','e73a6787e0e74eed561a15b62f0bcafa6b55e9f48d0e81d7337d1fb4b15a4b7f','[\"*\"]','2025-09-26 06:46:06',NULL,'2025-09-26 06:45:51','2025-09-26 06:46:06'),(186,'App\\Models\\User',1,'admin_token','f0749aef86de1150567760c2056f03f26201732162a5f40673d7c7e810ae18eb','[\"*\"]','2025-09-26 14:45:09',NULL,'2025-09-26 14:28:47','2025-09-26 14:45:09'),(188,'App\\Models\\UserCliente',31,'auth_token','2b3dcf78965d8810ff60ad2e88b77d544496b6ce32861f817094951d9c8b7435','[\"*\"]',NULL,NULL,'2025-09-27 12:46:42','2025-09-27 12:46:42'),(194,'App\\Models\\User',1,'admin_token','e4400ef6897f879485bd01e2de9da1c3682a8709e53a58647bb4c3865dde58d4','[\"*\"]','2025-09-28 13:39:55',NULL,'2025-09-27 19:00:51','2025-09-28 13:39:55'),(204,'App\\Models\\User',1,'admin_token','276f0575f7bf728d388a73e61871ff65054a5293f39fe1a4027bb4eb8f55b1cc','[\"*\"]','2025-09-29 16:10:18',NULL,'2025-09-29 10:47:13','2025-09-29 16:10:18'),(209,'App\\Models\\User',1,'admin_token','9c12615c952aec4edd571be15d70297ca312cf9af14c74500ffa41fa3a370d17','[\"*\"]','2025-10-01 14:11:49',NULL,'2025-10-01 07:55:30','2025-10-01 14:11:49'),(213,'App\\Models\\User',1,'admin_token','bf0f3c70899a37668d9ea07764c24d8a01c3e04f4d5da062a1d0dff743d3a1b6','[\"*\"]','2025-10-01 11:56:20',NULL,'2025-10-01 11:55:00','2025-10-01 11:56:20'),(214,'App\\Models\\User',1,'admin_token','64b62e5a717dd5e54dc165f389363f00597ad25cd8ef2d5a2355af1d02115d2f','[\"*\"]','2025-10-21 06:16:15',NULL,'2025-10-01 14:13:11','2025-10-21 06:16:15'),(216,'App\\Models\\User',1,'admin_token','b9be3b6ae44b52b49dea12bad647446aae66c454f31c72a90e8f259016f3a0c0','[\"*\"]','2025-10-02 10:21:13',NULL,'2025-10-02 10:20:56','2025-10-02 10:21:13'),(217,'App\\Models\\User',1,'admin_token','9f462cb7aad400085c251d006025cd257c4bf671e8f15c86ce0bada587d67e50','[\"*\"]','2025-10-02 19:07:50',NULL,'2025-10-02 19:07:09','2025-10-02 19:07:50'),(218,'App\\Models\\User',1,'admin_token','efb945ccbb1c3e7ab06a199cf0132aaf5b8f48f043276b5402d046ce6bd71fdb','[\"*\"]','2025-10-03 09:35:12',NULL,'2025-10-03 09:18:12','2025-10-03 09:35:12'),(219,'App\\Models\\User',1,'admin_token','eddf9c55e17a83417e0965d5d7bd68e0bc9e137563e2821bfe3c591641da48f9','[\"*\"]','2025-10-03 11:50:14',NULL,'2025-10-03 11:05:34','2025-10-03 11:50:14'),(223,'App\\Models\\User',1,'admin_token','1a67b02a9b6bca349919032a5c78447815c8d13ae63e1c77a90e08e94edaf50e','[\"*\"]','2025-10-04 15:15:34',NULL,'2025-10-04 15:13:22','2025-10-04 15:15:34'),(224,'App\\Models\\User',1,'admin_token','7c7c97a9938d8f571fb9426b86be3ebe4f821b03edba4e6f7f88b0dd237980c7','[\"*\"]','2025-10-04 15:20:31',NULL,'2025-10-04 15:18:08','2025-10-04 15:20:31'),(225,'App\\Models\\User',1,'admin_token','741ccbedb45d8dbc65b99b2b533d9b37d1cc8dd75be7980ab4ae954b73e58d10','[\"*\"]','2025-10-04 17:26:22',NULL,'2025-10-04 17:25:39','2025-10-04 17:26:22'),(234,'App\\Models\\User',1,'admin_token','9e879c02d678fd45b9807834b0d91f758187bfe5b665e1a8ae9f02d9180a2bc6','[\"*\"]','2025-10-29 16:04:25',NULL,'2025-10-06 13:16:01','2025-10-29 16:04:25'),(235,'App\\Models\\User',1,'admin_token','4a79fc985482f73d862fa363f7e900b5c8f1c99c322e8e8473ae30dc0be64960','[\"*\"]','2025-10-12 16:31:12',NULL,'2025-10-12 16:28:59','2025-10-12 16:31:12'),(236,'App\\Models\\User',1,'admin_token','8af316039e37e1a7334e875ed6b9db0ff960902b64c65412fcbb20ebad6d1751','[\"*\"]','2025-10-12 18:23:38',NULL,'2025-10-12 17:54:09','2025-10-12 18:23:38'),(237,'App\\Models\\User',1,'admin_token','7e6a6980e4528cc79653374afd47679847a58ff12777147082eb1f83b47c0ba8','[\"*\"]','2025-10-12 20:08:37',NULL,'2025-10-12 19:04:09','2025-10-12 20:08:37'),(239,'App\\Models\\User',1,'admin_token','82b866fdc3275d7e4f8292ab94823fa54e971e467a29fc063de5d3ed7ceec2f0','[\"*\"]','2025-10-13 08:08:01',NULL,'2025-10-13 08:02:45','2025-10-13 08:08:01'),(243,'App\\Models\\User',1,'admin_token','b48263ac0ad80e1c111918c74604dc9ea15c7f3e2bc432031003e4c44a112321','[\"*\"]','2025-10-24 18:11:42',NULL,'2025-10-24 18:11:38','2025-10-24 18:11:42'),(245,'App\\Models\\User',1,'admin_token','e3dd553bf610d7ebab392c88b37f0c67df3c52363909b3a8631597d785c6a4c2','[\"*\"]','2025-10-27 22:03:41',NULL,'2025-10-27 21:58:48','2025-10-27 22:03:41'),(247,'App\\Models\\User',1,'admin_token','8924d10d3aee593b67e8d07a6bb725f13b56127c06049db479f285cff1d5aae5','[\"*\"]','2025-10-28 10:28:50',NULL,'2025-10-28 08:38:00','2025-10-28 10:28:50'),(249,'App\\Models\\User',1,'admin_token','90727ad652b0b6602a6d6d6fc65caac5c636a3a029821c1a87959202b1550a69','[\"*\"]','2025-10-29 15:32:54',NULL,'2025-10-28 09:48:03','2025-10-29 15:32:54'),(254,'App\\Models\\User',1,'admin_token','a95c54dc25cb601fc3c3cdb632941222efd5c9ed9c3de46fca497de2ebb639db','[\"*\"]','2025-10-28 11:12:03',NULL,'2025-10-28 10:49:32','2025-10-28 11:12:03'),(256,'App\\Models\\User',1,'admin_token','d44c4400bdc6652390d90f25c25cc5cb364914bac8fd00101dd488a5db932565','[\"*\"]','2025-10-28 11:16:31',NULL,'2025-10-28 11:16:16','2025-10-28 11:16:31'),(259,'App\\Models\\User',1,'admin_token','0bec9104e28e90ba5c3777fc72ed423d544ef168c803bebac57f24b33c18cbf9','[\"*\"]','2025-10-28 11:28:41',NULL,'2025-10-28 11:21:56','2025-10-28 11:28:41'),(266,'App\\Models\\User',1,'admin_token','b07461d51db98b393d2a6605e7f9b972b7d61218c1ca94190848da7c2fbfb2e0','[\"*\"]','2025-10-29 17:13:44',NULL,'2025-10-29 16:02:59','2025-10-29 17:13:44'),(271,'App\\Models\\User',1,'admin_token','3e9c67c852337324839c73a49947a51118beeaf5b1416743f115c280d1d5fca4','[\"*\"]','2025-10-29 19:42:50',NULL,'2025-10-29 19:22:13','2025-10-29 19:42:50'),(274,'App\\Models\\User',1,'admin_token','9616c30b1c65accd3855ed739e8ab4ffc6cc51ef3d172469c9f39f464c85b3f5','[\"*\"]','2025-10-29 20:32:27',NULL,'2025-10-29 20:05:02','2025-10-29 20:32:27'),(275,'App\\Models\\User',1,'admin_token','426628176e5fcc5ddbc979ab3c9d5be8125531181499e1bf676699ca433c2274','[\"*\"]','2025-10-29 21:30:36',NULL,'2025-10-29 20:14:25','2025-10-29 21:30:36'),(276,'App\\Models\\User',1,'admin_token','3e81e8bb52ee21417e838450e18f18391f59758b0310f211ce22484d286c82d9','[\"*\"]','2025-10-29 20:35:45',NULL,'2025-10-29 20:35:30','2025-10-29 20:35:45'),(277,'App\\Models\\UserCliente',37,'cliente_token','693500040a2c8c09a13ff6da4f13337a9ea479180d5d9d2ddeb98bd0036917ae','[\"*\"]','2025-10-29 23:43:14',NULL,'2025-10-29 23:38:24','2025-10-29 23:43:14'),(280,'App\\Models\\User',1,'admin_token','ac95b32e00fadde6ff4b2dab80b4e843e2d9ea00a2ab560e729aa63cc9bea621','[\"*\"]','2025-10-31 21:59:41',NULL,'2025-10-31 15:15:08','2025-10-31 21:59:41'),(281,'App\\Models\\User',1,'admin_token','0fcbe6adb58e0980fe36c6e808ab33bb33bfd3ccea310389a0a17516bf26209f','[\"*\"]','2025-10-31 15:52:23',NULL,'2025-10-31 15:52:07','2025-10-31 15:52:23'),(282,'App\\Models\\User',1,'admin_token','83ad8d03cc4cea9e5f6f4cda33688e86793f5fef70f97a6e2e5ebf575f70f6e9','[\"*\"]','2025-11-01 03:37:04',NULL,'2025-10-31 21:48:39','2025-11-01 03:37:04'),(283,'App\\Models\\User',1,'admin_token','b888cce1135aec666cb836c194c1c91d79d29de2f07b8f00be3f100b07b1b92e','[\"*\"]','2025-10-31 21:50:48',NULL,'2025-10-31 21:49:41','2025-10-31 21:50:48'),(284,'App\\Models\\User',1,'admin_token','f93474f75a97e603fd16cdd95d9668a51b3b22947a31de6410bcb1eb26f8ddb3','[\"*\"]','2025-10-31 22:03:17',NULL,'2025-10-31 21:53:49','2025-10-31 22:03:17'),(285,'App\\Models\\User',1,'admin_token','405c3f57625b3e1a32f5cd1de1c585bda8ca632e9eab96cefac4e63091fefc4d','[\"*\"]','2025-10-31 21:59:04',NULL,'2025-10-31 21:55:57','2025-10-31 21:59:04'),(287,'App\\Models\\User',1,'admin_token','7e8d086ea46b13d917664bc2f04f6f6e1a19dffc9dfcbc05582e83e01a2ac15c','[\"*\"]','2025-11-02 14:53:00',NULL,'2025-11-02 03:14:17','2025-11-02 14:53:00'),(288,'App\\Models\\User',1,'admin_token','e4b65ada30d1a2b2e7b37197aa25ae11e16e8bb326c1d7f16692dfda337d8b4d','[\"*\"]','2025-11-03 02:33:56',NULL,'2025-11-03 02:29:39','2025-11-03 02:33:56'),(289,'App\\Models\\User',1,'admin_token','0deaa26cdf31bb2a4030e6dbce7a0aefd6200756058607157ac479dd8396a457','[\"*\"]','2025-11-03 03:15:46',NULL,'2025-11-03 03:09:28','2025-11-03 03:15:46'),(290,'App\\Models\\User',1,'admin_token','062c9ef5163cac7ba523c3d1f1ce7387e743a321192fec4ee93c5fcb0f31d56e','[\"*\"]','2025-11-03 03:40:36',NULL,'2025-11-03 03:23:13','2025-11-03 03:40:36'),(291,'App\\Models\\User',1,'admin_token','13860d023c0d4cdc4f6ebfe0c17995443e0d5dd1ce072674b460cb4f9f4fd58f','[\"*\"]','2025-11-03 03:46:42',NULL,'2025-11-03 03:42:33','2025-11-03 03:46:42'),(293,'App\\Models\\User',1,'admin_token','1e07f0cce2fc347d2f790725bf284f290df29f5e2a44686c7cda33f91b76354e','[\"*\"]','2025-11-03 04:07:24',NULL,'2025-11-03 03:52:34','2025-11-03 04:07:24'),(294,'App\\Models\\User',1,'admin_token','fa3d52d2e673d8f08b029fbf12be9f34215f1cfd87e817a2ca05cb24d95422da','[\"*\"]','2025-11-03 04:59:37',NULL,'2025-11-03 04:07:38','2025-11-03 04:59:37'),(295,'App\\Models\\User',1,'admin_token','638940af925e1e48f35ef630b47a763bde5e652f07de34a824f57cbee5c05d24','[\"*\"]','2025-11-03 05:00:33',NULL,'2025-11-03 04:59:53','2025-11-03 05:00:33'),(296,'App\\Models\\User',1,'admin_token','647cdc3dfd2b7e1da49132b33e888ba9277082b7e34b192e4e567ce12a4413a8','[\"*\"]','2025-11-03 05:14:09',NULL,'2025-11-03 05:03:10','2025-11-03 05:14:09'),(297,'App\\Models\\User',1,'admin_token','ae5937594feb8624b574b8be11fd106f0a6eaa43e0beb6312cdb38888561ba05','[\"*\"]','2025-11-03 20:25:57',NULL,'2025-11-03 05:14:50','2025-11-03 20:25:57'),(299,'App\\Models\\User',1,'admin_token','8f4f2d82c6ca77eb4b65acf29bda8c9c9e39131ee646b02dbe6d61709d26bae4','[\"*\"]','2025-11-03 23:07:22',NULL,'2025-11-03 16:09:36','2025-11-03 23:07:22'),(300,'App\\Models\\User',1,'admin_token','522dddfdadea2f0fee5ce3c0887c256c657569ccffdc271645775a33c8e0a8fb','[\"*\"]','2025-11-03 22:12:41',NULL,'2025-11-03 16:19:51','2025-11-03 22:12:41'),(302,'App\\Models\\User',1,'admin_token','52458d5c31d375fca5f7fd10f0ee6cc34211363655b48447e01b7d2063ca5216','[\"*\"]','2025-11-03 19:13:36',NULL,'2025-11-03 19:12:42','2025-11-03 19:13:36'),(303,'App\\Models\\User',1,'admin_token','5f3c1afc83c48519e5f9ca8ebab7ed984ec72d738a59b7fed18fc6029326938a','[\"*\"]','2025-11-03 20:38:33',NULL,'2025-11-03 20:31:13','2025-11-03 20:38:33'),(304,'App\\Models\\User',1,'admin_token','a74181f514ba143b06df18b0dd932b8e8da4caef8b125627da64576a44798614','[\"*\"]','2025-11-03 22:52:05',NULL,'2025-11-03 22:15:29','2025-11-03 22:52:05'),(305,'App\\Models\\User',1,'admin_token','5a8eb13a107b8a5491c293a4ec0e3b9f163352f9f433ce6fadd6c18f25f2626f','[\"*\"]','2025-11-03 22:59:44',NULL,'2025-11-03 22:46:48','2025-11-03 22:59:44'),(306,'App\\Models\\User',1,'admin_token','ec1c08e0e6ec12a6c4bb7d068e8f54821cb4fd33ca8ffe0104477f77ffb6201c','[\"*\"]','2025-11-03 23:02:07',NULL,'2025-11-03 22:48:28','2025-11-03 23:02:07'),(307,'App\\Models\\User',1,'admin_token','acc060b6f339edd26041c1487f041aac596adab5b3a037a7746b3cb0c0e0593c','[\"*\"]','2025-11-04 15:16:11',NULL,'2025-11-04 15:16:10','2025-11-04 15:16:11'),(308,'App\\Models\\User',1,'admin_token','8e3be0d1d457590c3e39d281d4a189d57a5ec79a3fbbdd07cc4da5816979cd5f','[\"*\"]','2025-11-04 16:16:35',NULL,'2025-11-04 16:15:46','2025-11-04 16:16:35'),(309,'App\\Models\\User',1,'admin_token','88931ac6de845cb826cdf9aaba4c3805cd674ed32f3190264fcd1f392d4db46a','[\"*\"]','2025-11-04 16:54:09',NULL,'2025-11-04 16:15:52','2025-11-04 16:54:09'),(310,'App\\Models\\User',1,'admin_token','d340dc67a658f6d8a0e9f51392526093472a3272b6bd50aaf1871037e04e798a','[\"*\"]','2025-11-04 18:33:02',NULL,'2025-11-04 16:54:57','2025-11-04 18:33:02'),(311,'App\\Models\\UserCliente',24,'auth_token','d1d67e7c06aafa6d880e45b38a1cff1e90ecf51be397cdf3d3ebe22ac86b4480','[\"*\"]','2025-11-04 17:18:26',NULL,'2025-11-04 17:09:00','2025-11-04 17:18:26'),(312,'App\\Models\\User',1,'admin_token','a205e1b6f180dfac0c13f8ef2e932afd150c969bfcbe9208b4129b63a007f97a','[\"*\"]','2025-11-05 01:16:00',NULL,'2025-11-04 19:32:20','2025-11-05 01:16:00'),(314,'App\\Models\\User',1,'admin_token','76cecdb7ba467333e8a3c20680ee41059f7b8e684bd916d26de8da298b9c8501','[\"*\"]','2025-11-04 21:56:50',NULL,'2025-11-04 21:52:38','2025-11-04 21:56:50'),(317,'App\\Models\\UserCliente',24,'auth_token','69ab6085153855adb73bcdd318b6b0cfa578afee879c8811eb858522bab52641','[\"*\"]','2025-11-05 22:23:58',NULL,'2025-11-05 15:44:51','2025-11-05 22:23:58'),(321,'App\\Models\\User',1,'admin_token','870c2cf7d0aa1d7153ab5039aa0331121700ccad70e9f2d20ff2925ba51fdf62','[\"*\"]','2025-11-07 16:42:09',NULL,'2025-11-07 15:06:52','2025-11-07 16:42:09'),(322,'App\\Models\\User',1,'admin_token','f2d46e2e9b45188959be5dc0d0e3278c5688211a3ee2031fa984eb7b295eb051','[\"*\"]','2025-11-10 14:58:02',NULL,'2025-11-10 14:13:51','2025-11-10 14:58:02'),(323,'App\\Models\\User',1,'admin_token','aee0a7a395598532e4c5798cf9dea1ff90282c417e9ac4ca4641e4a75461c5a3','[\"*\"]','2025-11-11 14:21:38',NULL,'2025-11-11 14:19:31','2025-11-11 14:21:38'),(325,'App\\Models\\User',1,'admin_token','37e4469ec3a867f79ed1a0e1160dd935377740ec51376a02545edbc70c486d12','[\"*\"]','2025-11-11 22:15:41',NULL,'2025-11-11 17:34:03','2025-11-11 22:15:41'),(326,'App\\Models\\User',1,'admin_token','41395469e5592124fa314ed00fe6895ed69d11a9a2057458350c6739c8e4db54','[\"*\"]','2025-11-12 15:01:17',NULL,'2025-11-12 13:48:31','2025-11-12 15:01:17'),(327,'App\\Models\\User',1,'admin_token','d1e77fb0d711447bae24a17167340fb7a24885a8032d3389cce3e34be690ef6c','[\"*\"]','2025-11-12 17:01:40',NULL,'2025-11-12 15:02:15','2025-11-12 17:01:40'),(330,'App\\Models\\User',1,'admin_token','fcedf0fb7b31735cd35ee309da83e60d67ce41f5de6ff833e77b2ce638edf7bd','[\"*\"]','2025-11-14 14:51:36',NULL,'2025-11-14 14:06:00','2025-11-14 14:51:36'),(333,'App\\Models\\User',1,'admin_token','666093520776035595bc5e77ac689d53b5ab4feb9268a05d63980a77b25cfc88','[\"*\"]','2025-11-14 22:08:33',NULL,'2025-11-14 22:06:26','2025-11-14 22:08:33'),(335,'App\\Models\\User',1,'admin_token','77a6762867ab4843c6edf8ee3a1aac73a9ca4b587cc2d02016ca393043c6199b','[\"*\"]','2025-11-15 02:58:38',NULL,'2025-11-15 01:48:13','2025-11-15 02:58:38'),(336,'App\\Models\\User',1,'admin_token','31b1baa1f7e3c0746d7b156fcb93e3fb47c90a610dc8c58442bc831737b15505','[\"*\"]','2025-11-15 03:04:46',NULL,'2025-11-15 02:59:24','2025-11-15 03:04:46'),(338,'App\\Models\\User',1,'admin_token','4235a19a231a4994c192b720be523573f12ced5db1d03e7d1ed6bd78494cb5ad','[\"*\"]','2025-11-15 03:14:39',NULL,'2025-11-15 03:10:45','2025-11-15 03:14:39'),(339,'App\\Models\\User',1,'admin_token','e3fc846ffe156975c8451d5e2c12e03ff193aa505a22186039bc90f77d92be51','[\"*\"]','2025-11-15 03:34:57',NULL,'2025-11-15 03:17:59','2025-11-15 03:34:57'),(341,'App\\Models\\User',1,'admin_token','03648aeca6a84588e7c3937260aa3e2377c91a612f62e4657b69bc27f4070738','[\"*\"]','2025-11-15 15:04:29',NULL,'2025-11-15 03:48:34','2025-11-15 15:04:29'),(342,'App\\Models\\User',1,'admin_token','16ae4129dcd03247db5446dbf49326ea676d56a93db3737d61e532d322a9ce3f','[\"*\"]','2025-11-16 03:41:32',NULL,'2025-11-15 23:30:54','2025-11-16 03:41:32'),(345,'App\\Models\\User',1,'admin_token','e708a7e4059c9bfa340dcad116508d9fa88d7d18ed4ce58d33ce47d0c90bbc36','[\"*\"]','2025-11-16 14:32:49',NULL,'2025-11-16 14:32:41','2025-11-16 14:32:49'),(346,'App\\Models\\User',1,'admin_token','c99d13ff0a331f2864de498736c41c23621c7c969e2363bb8b82394095ee71ac','[\"*\"]','2025-11-17 22:54:09',NULL,'2025-11-17 22:41:46','2025-11-17 22:54:09'),(347,'App\\Models\\User',1,'admin_token','ff570b613aa0ae105f6a716d1c083765c9f91fce5a61e6f5c93e41544d1c4124','[\"*\"]','2025-11-18 01:23:27',NULL,'2025-11-18 01:21:03','2025-11-18 01:23:27'),(348,'App\\Models\\User',1,'admin_token','b2f8d366bfdeeb84516bcb5fbaeed6d809b63a6da0b6a56d123fe8f5705e226a','[\"*\"]','2025-11-18 14:05:43',NULL,'2025-11-18 14:05:04','2025-11-18 14:05:43'),(349,'App\\Models\\User',1,'admin_token','5bf4e02c7394ead616989a4a30ed1796d4accf73b66c4fcb55ad6ad628f30e9a','[\"*\"]','2025-11-20 01:19:17',NULL,'2025-11-20 01:04:46','2025-11-20 01:19:17'),(350,'App\\Models\\User',1,'admin_token','469060a2bbb1d3cd2e2ccd2f0ddf5e52b57e5255a7bcbbe18a00a56a6310763c','[\"*\"]','2025-11-23 00:55:14',NULL,'2025-11-23 00:52:28','2025-11-23 00:55:14'),(351,'App\\Models\\User',1,'admin_token','ce7967fdee2d58a9917150a99c8868aabc1969788f93de8cefe577b855b37511','[\"*\"]','2025-11-24 03:34:47',NULL,'2025-11-24 00:14:12','2025-11-24 03:34:47'),(354,'App\\Models\\User',1,'admin_token','b273a2dd8624389f941532add59ed98b50b2fb09ee80427cd2fbaf96303e5ca6','[\"*\"]','2025-11-24 14:52:02',NULL,'2025-11-24 14:51:45','2025-11-24 14:52:02'),(356,'App\\Models\\UserCliente',37,'cliente_token','5bc06bb6a6e5a497b67246f2587394bba41f7d58c862f99adb67e6ac0dd3af58','[\"*\"]','2025-11-24 15:02:51',NULL,'2025-11-24 15:02:13','2025-11-24 15:02:51'),(360,'App\\Models\\User',1,'admin_token','774543c8a248c2f55644ccd6bc9ec8855adc7fa3fae62dc8160e7c80a2c854a2','[\"*\"]','2025-11-24 15:09:39',NULL,'2025-11-24 15:09:37','2025-11-24 15:09:39'),(361,'App\\Models\\User',1,'admin_token','2125188a672d02580049d10a9fa6ee8566f590df13b4ac49db8df27b17310d38','[\"*\"]','2025-11-24 15:11:46',NULL,'2025-11-24 15:10:15','2025-11-24 15:11:46'),(364,'App\\Models\\User',1,'admin_token','28b178446182ab4e900fc4855721a7588f2eac336ef8542242e703038295c75f','[\"*\"]','2025-11-25 14:15:44',NULL,'2025-11-25 14:15:07','2025-11-25 14:15:44'),(365,'App\\Models\\UserCliente',30,'auth_token','9b56188e40a52a3334ad15ab7e508a668ba87c82b2bb431c0928fd1277e22429','[\"*\"]','2025-11-26 01:21:41',NULL,'2025-11-25 23:44:02','2025-11-26 01:21:41'),(366,'App\\Models\\UserCliente',37,'cliente_token','3dedc13a187cef4d02319af8ba341edb9432be79b41865daf9bd713148fae03d','[\"*\"]','2025-11-26 15:08:40',NULL,'2025-11-26 03:14:03','2025-11-26 15:08:40'),(368,'App\\Models\\User',1,'admin_token','56eb1233939b0079eb863c48cce086193dc5b2cf401a4c3ef1edd069ad2f93fe','[\"*\"]','2025-11-26 21:06:26',NULL,'2025-11-26 21:06:18','2025-11-26 21:06:26'),(369,'App\\Models\\User',1,'admin_token','856a3d923916a1e72158cff0ebbd5c439aba7580dc81ed0230dfc373226d2b32','[\"*\"]','2025-11-26 21:09:56',NULL,'2025-11-26 21:07:47','2025-11-26 21:09:56'),(374,'App\\Models\\User',1,'admin_token','6e4ada8df89744ef95fd9f7e7ab25dcec52e1abefc7f7f89b34423a33bf23e7a','[\"*\"]','2025-11-27 12:39:16',NULL,'2025-11-27 12:16:15','2025-11-27 12:39:16'),(375,'App\\Models\\User',1,'admin_token','20bbbabc4564a86c78623a782a3b4005a12e4b863d8fb61c27cfe793aca630e9','[\"*\"]','2025-11-27 14:16:39',NULL,'2025-11-27 14:07:55','2025-11-27 14:16:39'),(379,'App\\Models\\User',1,'admin_token','c379ac58c7742f184d05153c460643bec70e20a4af9cbd1d9d14e028e69aea39','[\"*\"]','2025-11-27 15:30:24',NULL,'2025-11-27 15:29:35','2025-11-27 15:30:24'),(380,'App\\Models\\UserCliente',42,'auth_token','dc59297b51557f3addff57fcb49f75f156ab03d1e370eed0e6cdc9935a1f3a8c','[\"*\"]','2025-11-27 18:54:29',NULL,'2025-11-27 18:54:23','2025-11-27 18:54:29'),(382,'App\\Models\\User',1,'admin_token','4668634b0260ebb39414a8f785620eff9c6a19c69727a826feb22cf7975009c3','[\"*\"]','2025-11-27 21:27:15',NULL,'2025-11-27 20:43:18','2025-11-27 21:27:15'),(384,'App\\Models\\User',1,'admin_token','6d6c1b3da5096e9fcc79c8a7a479422b841deccfc6d704aa8beadf2c5c078433','[\"*\"]','2025-11-27 22:06:18',NULL,'2025-11-27 21:56:46','2025-11-27 22:06:18'),(385,'App\\Models\\User',1,'admin_token','bec72151b0da2a3a7e4e824099a8f01824cfe5b54e6631856bde220220e83ae0','[\"*\"]','2025-11-28 21:01:03',NULL,'2025-11-28 15:47:08','2025-11-28 21:01:03'),(386,'App\\Models\\User',1,'admin_token','fbb01e3ca1aac7fa5d5342c6aa3338c297dc70a3d4b5ace9b1330162e1944b91','[\"*\"]','2025-11-28 23:15:30',NULL,'2025-11-28 16:04:54','2025-11-28 23:15:30'),(387,'App\\Models\\User',1,'admin_token','a791ae167971771112695f1cf85999cab05ecb0419ba0cadf0f0f44b34346eeb','[\"*\"]','2025-11-29 13:25:46',NULL,'2025-11-29 13:19:26','2025-11-29 13:25:46'),(388,'App\\Models\\User',1,'admin_token','92510815be99b606407e4ed8199885926f1f879d05e85c1ae57b1e83933691f6','[\"*\"]','2025-11-29 13:29:53',NULL,'2025-11-29 13:25:56','2025-11-29 13:29:53'),(389,'App\\Models\\User',1,'admin_token','74a0007e0ed80d95fd87a5808aec09be94e8ee531be9c509e8be391fc8dba795','[\"*\"]','2025-11-29 14:26:24',NULL,'2025-11-29 13:30:49','2025-11-29 14:26:24'),(390,'App\\Models\\User',1,'admin_token','c428e2f25199e2e3996caa98e0f917d8822fcec31ce48b995d9e78ab67fb9ca6','[\"*\"]','2025-11-29 16:09:37',NULL,'2025-11-29 15:23:08','2025-11-29 16:09:37'),(391,'App\\Models\\User',1,'admin_token','a187d182f4f6ffbbca6e52300474e3dc984c86fe2780d9f75198b7ba28083fe1','[\"*\"]','2025-11-29 16:27:07',NULL,'2025-11-29 16:26:35','2025-11-29 16:27:07'),(392,'App\\Models\\User',1,'admin_token','b1dfea6449376a1adfa1690bf613c4607852b0703d3e938eedbe37cdad47d671','[\"*\"]','2025-11-29 16:35:58',NULL,'2025-11-29 16:35:57','2025-11-29 16:35:58'),(394,'App\\Models\\User',1,'admin_token','772f12f8abb091c2d7929041963a8b29319f046b470f6e7a735fe4e8b96c0955','[\"*\"]','2025-12-01 01:14:11',NULL,'2025-12-01 01:11:56','2025-12-01 01:14:11'),(395,'App\\Models\\User',1,'admin_token','5036134b5a2f1f08e09b66792b7a428addf64de4147851aaea83ce92407a457f','[\"*\"]','2025-12-01 13:14:05',NULL,'2025-12-01 01:14:37','2025-12-01 13:14:05'),(396,'App\\Models\\User',1,'admin_token','065614815e50fd7f8ef54332112e96e75f2e8b8a6cd51518d72567e6e7a95eda','[\"*\"]','2025-12-01 16:29:55',NULL,'2025-12-01 13:15:07','2025-12-01 16:29:55'),(398,'App\\Models\\User',1,'admin_token','5703d2f838346a33c844143f45212987414cc40064d2f313c319685cd49ff6db','[\"*\"]','2025-12-01 13:55:37',NULL,'2025-12-01 13:36:20','2025-12-01 13:55:37'),(399,'App\\Models\\UserCliente',37,'cliente_token','894cd617083472467c1feb0adec90b2e633c5f6783125806e925c6accb18738e','[\"*\"]','2025-12-01 13:47:19',NULL,'2025-12-01 13:47:16','2025-12-01 13:47:19');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantillas_notificacion`
--

DROP TABLE IF EXISTS `plantillas_notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantillas_notificacion` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `tipo` enum('VENTA_REALIZADA','PAGO_RECIBIDO','COMPROBANTE_GENERADO','CUENTA_POR_COBRAR','RECORDATORIO_PAGO','VOUCHER_VERIFICADO','PEDIDO_ENVIADO','OTRO') NOT NULL,
  `canal` enum('EMAIL','WHATSAPP','SMS') NOT NULL,
  `asunto` varchar(255) DEFAULT NULL,
  `contenido` text NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plantillas_notificacion_codigo_unique` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantillas_notificacion`
--

LOCK TABLES `plantillas_notificacion` WRITE;
/*!40000 ALTER TABLE `plantillas_notificacion` DISABLE KEYS */;
INSERT INTO `plantillas_notificacion` VALUES (1,'VENTA_REALIZADA_EMAIL','Venta Realizada - Email','VENTA_REALIZADA','EMAIL','Gracias por tu compra #{numero_venta}','Hola {nombre},\n\nGracias por tu compra en Magus.\n\nNúmero de venta: {numero_venta}\nTotal: {total}\nFecha: {fecha}\n\nEn breve recibirás tu comprobante electrónico.\n\nSaludos,\nEquipo Magus','[\"nombre\", \"numero_venta\", \"total\", \"fecha\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(2,'VENTA_REALIZADA_WHATSAPP','Venta Realizada - WhatsApp','VENTA_REALIZADA','WHATSAPP',NULL,'? *Compra Confirmada*\n\nHola {nombre}!\n\nTu compra #{numero_venta} por {total} ha sido registrada exitosamente.\n\n? Fecha: {fecha}\n\nGracias por tu preferencia! ?','[\"nombre\", \"numero_venta\", \"total\", \"fecha\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(3,'COMPROBANTE_GENERADO_EMAIL','Comprobante Generado - Email','COMPROBANTE_GENERADO','EMAIL','Tu {tipo_comprobante} {numero} está lista','Hola {nombre},\n\nTu {tipo_comprobante} electrónica ha sido generada:\n\nNúmero: {numero}\nTotal: {total}\n\nPuedes descargarla desde tu cuenta o haciendo clic aquí:\n{link_descarga}\n\nSaludos,\nEquipo Magus','[\"nombre\", \"tipo_comprobante\", \"numero\", \"total\", \"link_descarga\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(4,'COMPROBANTE_GENERADO_WHATSAPP','Comprobante Generado - WhatsApp','COMPROBANTE_GENERADO','WHATSAPP',NULL,'? *Comprobante Electrónico*\n\nHola {nombre}!\n\nTu {tipo_comprobante} {numero} por {total} ya está disponible.\n\n? Descárgala aquí:\n{link_descarga}\n\nGracias! ?','[\"nombre\", \"tipo_comprobante\", \"numero\", \"total\", \"link_descarga\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(5,'RECORDATORIO_PAGO_EMAIL','Recordatorio de Pago - Email','RECORDATORIO_PAGO','EMAIL','Recordatorio: Pago {estado} - {numero_documento}','Hola {nombre},\n\nTe recordamos que tienes un pago {estado}:\n\nDocumento: {numero_documento}\nMonto pendiente: {monto}\nFecha de vencimiento: {fecha_vencimiento}\nDías: {dias_vencidos}\n\nPor favor, realiza tu pago a la brevedad.\n\nSaludos,\nEquipo Magus','[\"nombre\", \"numero_documento\", \"monto\", \"fecha_vencimiento\", \"dias_vencidos\", \"estado\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(6,'RECORDATORIO_PAGO_WHATSAPP','Recordatorio de Pago - WhatsApp','RECORDATORIO_PAGO','WHATSAPP',NULL,'? *Recordatorio de Pago*\n\nHola {nombre},\n\nTienes un pago {estado}:\n\n? Doc: {numero_documento}\n? Monto: {monto}\n? Vencimiento: {fecha_vencimiento}\n⏰ {dias_vencidos} días\n\nPor favor, realiza tu pago pronto. Gracias!','[\"nombre\", \"numero_documento\", \"monto\", \"fecha_vencimiento\", \"dias_vencidos\", \"estado\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(7,'VOUCHER_VERIFICADO_EMAIL','Voucher Verificado - Email','VOUCHER_VERIFICADO','EMAIL','Pago verificado - {numero_operacion}','Hola {nombre},\n\nTu pago ha sido verificado exitosamente:\n\nNúmero de operación: {numero_operacion}\nMonto: {monto}\nFecha: {fecha}\n\nGracias por tu pago!\n\nSaludos,\nEquipo Magus','[\"nombre\", \"numero_operacion\", \"monto\", \"fecha\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20'),(8,'VOUCHER_VERIFICADO_WHATSAPP','Voucher Verificado - WhatsApp','VOUCHER_VERIFICADO','WHATSAPP',NULL,'✅ *Pago Verificado*\n\nHola {nombre}!\n\nTu pago ha sido confirmado:\n\n? Monto: {monto}\n? Op: {numero_operacion}\n? {fecha}\n\nGracias! ?','[\"nombre\", \"numero_operacion\", \"monto\", \"fecha\"]',1,'2025-10-20 05:36:20','2025-10-20 05:36:20');
/*!40000 ALTER TABLE `plantillas_notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto_detalles`
--

DROP TABLE IF EXISTS `producto_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) unsigned NOT NULL,
  `descripcion_detallada` longtext DEFAULT NULL,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `caracteristicas_tecnicas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `instrucciones_uso` text DEFAULT NULL,
  `garantia` text DEFAULT NULL,
  `politicas_devolucion` text DEFAULT NULL,
  `dimensiones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `imagenes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `videos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `producto_detalles_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `producto_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_detalles`
--

LOCK TABLES `producto_detalles` WRITE;
/*!40000 ALTER TABLE `producto_detalles` DISABLE KEYS */;
INSERT INTO `producto_detalles` VALUES (8,113,NULL,'\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 8700F, 4.1\\\\\\/5.0 Ghz, AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 7 8700F, tu PC obtiene el poder necesario para ejecutar todas tus aplicaciones y juegos con una fluidez impresionante. Gracias a su frecuencia de 4.10GHz y 16MB de cach\\\\u00e9, este procesador es ideal para quienes necesitan rendimiento extremo sin comprometer la calidad. El AMD Ryzen 7 8700F est\\\\u00e1 dise\\\\u00f1ado para satisfacer las demandas m\\\\u00e1s altas, ya sea para jugar, crear o trabajar de manera eficiente. Gracias a la ingenier\\\\u00eda de AMD, este procesador es capaz de manejar cargas de trabajo intensivas y multitarea sin esfuerzo, manteniendo tu equipo \\\\u00e1gil y confiable.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764561917_692d13fd830e9.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/QyYfxlSoar0?si=78INtbDO1XJTafk0\\\"]\"','2025-11-27 14:35:56','2025-12-01 04:05:17'),(9,114,'<p>La&nbsp;MSI&nbsp;MAG&nbsp;B860&nbsp;TOMAHAWK&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;ATX&nbsp;para&nbsp;gaming&nbsp;compatible&nbsp;con&nbsp;los&nbsp;procesadores&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;(Serie&nbsp;2)&nbsp;a&nbsp;través&nbsp;del&nbsp;socket&nbsp;LGA&nbsp;1851.&nbsp;Ofrece&nbsp;características&nbsp;premium&nbsp;como&nbsp;PCIe&nbsp;5.0,&nbsp;Thunderbolt&nbsp;4,&nbsp;Wi-Fi&nbsp;7&nbsp;y&nbsp;LAN&nbsp;de&nbsp;5&nbsp;Gbps,&nbsp;además&nbsp;de&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;RAM&nbsp;DDR5.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOTHERBOARD MSI\\\",\\\"detalle\\\":\\\"La serie MAG de MSI es sin\\\\u00f3nimo de estabilidad y durabilidad y est\\\\u00e1 dise\\\\u00f1ada para soportar las sesiones de juego m\\\\u00e1s intensas. Toda la gama presenta una construcci\\\\u00f3n robusta con una dureza similar a la del metal y una excelente disipaci\\\\u00f3n del calor, lo que garantiza la estabilidad de todos los componentes de juego cr\\\\u00edticos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764254728_69286408ebf1a.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/_60XmaYa3UY?si=Aa40bz_jHqhf44Zt\\\"]\"','2025-11-27 14:45:28','2025-11-27 15:02:19'),(10,115,'<p>Con&nbsp;el&nbsp;Razer&nbsp;Basilisk&nbsp;V3&nbsp;X&nbsp;HyperSpeed,&nbsp;no&nbsp;hay&nbsp;límites&nbsp;sobre&nbsp;cómo&nbsp;eliges&nbsp;jugar.&nbsp;Equipado&nbsp;con&nbsp;9&nbsp;controles&nbsp;programables,&nbsp;conectividad&nbsp;inalámbrica&nbsp;de&nbsp;modo&nbsp;dual&nbsp;y&nbsp;Razer&nbsp;Chroma&nbsp;RGB&nbsp;personalizable,&nbsp;está&nbsp;diseñado&nbsp;para&nbsp;responder&nbsp;a&nbsp;un&nbsp;solo&nbsp;maestro:&nbsp;usted.&nbsp;Habilitado&nbsp;a&nbsp;través&nbsp;de&nbsp;Razer&nbsp;Synapse,&nbsp;Razer&nbsp;Hypershift&nbsp;le&nbsp;permite&nbsp;asignar&nbsp;y&nbsp;desbloquear&nbsp;un&nbsp;conjunto&nbsp;de&nbsp;comandos&nbsp;secundarios&nbsp;además&nbsp;de&nbsp;los&nbsp;9&nbsp;controles&nbsp;existentes&nbsp;en&nbsp;el&nbsp;mouse.&nbsp;Como&nbsp;un&nbsp;mouse&nbsp;ergonómico&nbsp;inalámbrico&nbsp;para&nbsp;juegos&nbsp;diseñado&nbsp;para&nbsp;juegos&nbsp;largos,&nbsp;puede&nbsp;pasar&nbsp;mucho&nbsp;tiempo&nbsp;antes&nbsp;de&nbsp;que&nbsp;sea&nbsp;necesario&nbsp;reemplazar&nbsp;las&nbsp;baterías.</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMER RAZER BASILISK V3 26K DPI\\\",\\\"valor\\\":\\\"RAZER\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE RAZER\\\",\\\"detalle\\\":\\\"Crea, controla e impulsa tu estilo de juego con el nuevo Razer Basilisk V3, el rat\\\\u00f3n ergon\\\\u00f3mico para juegos por excelencia para un rendimiento personalizado. Con 10+1 botones programables, una rueda de desplazamiento inteligente y una buena dosis de Razer Chroma\\\\u2122 RGB, es hora de iluminar la competici\\\\u00f3n con tu juego.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764255356_6928667c7bc4d.webp\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/13L6ljqxg_8?si=Jd5xbjbgxlAn6GkF\\\"]\"','2025-11-27 14:55:56','2025-11-27 15:05:38'),(11,116,'<p>La&nbsp;ASUS&nbsp;ROG&nbsp;STRIX&nbsp;B850&nbsp;A&nbsp;GAMING&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;con&nbsp;socket&nbsp;AM5&nbsp;de&nbsp;formato&nbsp;ATX,&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;serie&nbsp;7000,&nbsp;8000&nbsp;y&nbsp;9000.&nbsp;Ofrece&nbsp;características&nbsp;de&nbsp;gama&nbsp;alta&nbsp;como&nbsp;DDR5,&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;la&nbsp;tarjeta&nbsp;gráfica,&nbsp;Wi-Fi&nbsp;7,&nbsp;y&nbsp;una&nbsp;solución&nbsp;de&nbsp;alimentación&nbsp;robusta&nbsp;para&nbsp;soportar&nbsp;procesadores&nbsp;de&nbsp;alto&nbsp;rendimiento.&nbsp;Su&nbsp;diseño&nbsp;también&nbsp;incluye&nbsp;un&nbsp;acabado&nbsp;estético&nbsp;en&nbsp;blanco&nbsp;y&nbsp;una&nbsp;solución&nbsp;de&nbsp;enfriamiento&nbsp;mejorada.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"ASUS ROG \\\",\\\"valor\\\":\\\"PLACA MADRE ASUS ROG STRIX B850 A GAMING WIFI AM5\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS ROG\\\",\\\"detalle\\\":\\\"Eleva tu construcci\\\\u00f3n con la ROG Strix B850-A Gaming WiFi. Con una elegante PCB blanca y compatibilidad con los procesadores AMD Ryzen\\\\u2122 Serie 9000, esta placa base ofrece la potencia y la conectividad necesarias para las aplicaciones avanzadas de IA. Con soporte DDR5, capacidades PCIe 5.0 completas, puerto USB 20 Gbps y WiFi 7, es la mezcla definitiva de estilo y rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764256530_69286b12f0395.webp\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/dqmf7q1o5CI?si=nJsg36EJ8nvYSjtS\\\"]\"','2025-11-27 15:15:30','2025-11-27 15:26:01'),(12,117,NULL,'\"[{\\\"nombre\\\":\\\"CASE ENKORE SHADOW ENK5021 ARGB\\\",\\\"valor\\\":\\\"ENKORE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE ENKORE\\\",\\\"detalle\\\":\\\"Soporte de Placa Madre: ATX\\\\\\/MicroATX\\\\\\/Mini ITX.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764279505_6928c4d11a045.webp\\\"]\"',NULL,'2025-11-27 21:38:25','2025-11-27 21:52:04'),(13,118,'<p>fgbdbgfgdbfgbgfgbf</p>','\"[{\\\"nombre\\\":\\\"sadvvdsa\\\",\\\"valor\\\":\\\"vfdfdvs\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"ghfmhngmf\\\",\\\"detalle\\\":\\\"hmghmgf\\\"}]\"','gbfbgfbgf','bgbgfdbgfgb','bgffgdbgbf','\"[23,23,2,3]\"','\"[\\\"1764422830_692af4ae60d63.jpeg\\\"]\"',NULL,'2025-11-29 13:27:10','2025-11-29 13:27:10'),(14,119,'<p>fgdgfdngfhnhgnfnhgffghnhng</p>','\"[{\\\"nombre\\\":\\\"fdgbgfnd\\\",\\\"valor\\\":\\\"ngfdghn\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"fghgfnd\\\",\\\"detalle\\\":\\\"dfgnfdn\\\"}]\"','nhgfhnfgn','ghfnhgfnhgf','ghfnhgfhnhgfnh','\"[32,32,32,2]\"','\"[\\\"1764422954_692af52ad8ab6.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/www.youtube.com\\\\\\/shorts\\\\\\/JrpvMU8WZ4Y\\\"]\"','2025-11-29 13:29:14','2025-11-29 13:29:14'),(15,122,'<p><strong>El&nbsp;Intel&nbsp;Core&nbsp;i3-10105F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;10ª&nbsp;generación&nbsp;con&nbsp;4&nbsp;núcleos&nbsp;y&nbsp;8&nbsp;hilos,&nbsp;diseñado&nbsp;para&nbsp;el&nbsp;socket&nbsp;LGA&nbsp;1200.&nbsp;Tiene&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;\\(3.7\\)&nbsp;GHz&nbsp;que&nbsp;puede&nbsp;alcanzar&nbsp;los&nbsp;\\(4.4\\)&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;6&nbsp;MB&nbsp;de&nbsp;caché&nbsp;y&nbsp;un&nbsp;TDP&nbsp;de&nbsp;\\(65\\)W.&nbsp;La&nbsp;&quot;F&quot;&nbsp;en&nbsp;su&nbsp;nombre&nbsp;indica&nbsp;que&nbsp;no&nbsp;cuenta&nbsp;con&nbsp;gráficos&nbsp;integrados,&nbsp;por&nbsp;lo&nbsp;que&nbsp;requiere&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;para&nbsp;su&nbsp;funcionamiento. </strong></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I3 10105F\\\",\\\"valor\\\":\\\"intel\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTER CORE\\\",\\\"detalle\\\":\\\"el Intel Core i3-10105F, de 10 generaci\\\\u00f3n para escritorio, con 4 n\\\\u00facleos y 8 hilos, y una frecuencia base de 3.7 GHz que puede alcanzar hasta 4.4 GHz con Turbo Boost. Posee una memoria cach\\\\u00e9 L3 de 6MB, usa el socket LGA 1200 y tiene un TDP de 65 W\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764561688_692d13184ba62.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/CzDOnRBbdns\\\"]\"','2025-12-01 01:46:52','2025-12-01 04:01:28'),(16,123,NULL,'\"[{\\\"nombre\\\":\\\"PROCESADOR RYZEN AMD RYZEN 7 9800X 3D AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"El AMD Ryzen 7 9800X3D AM5 ofrece un rendimiento superior gracias a su arquitectura Zen 5 y la tecnolog\\\\u00eda 3D V-Cache, que mejora notablemente la velocidad en juegos y tareas exigentes. Con frecuencias de hasta 5.2 GHz y compatibilidad con DDR5 y PCIe 5.0, es una opci\\\\u00f3n ideal para equipos de alto rendimiento que buscan potencia, eficiencia y larga vida \\\\u00fatil en la plataforma AM5.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764554449_692cf6d16636f.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/4uox2wouQjs\\\"]\"','2025-12-01 02:00:49','2025-12-01 02:02:59'),(17,124,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;5800XT&nbsp;AM4&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos&nbsp;para&nbsp;la&nbsp;plataforma&nbsp;AM4,&nbsp;con&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.8&nbsp;GHz&nbsp;y&nbsp;un&nbsp;modo&nbsp;turbo&nbsp;que&nbsp;alcanza&nbsp;hasta&nbsp;4.8&nbsp;GHz.&nbsp;Basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;3,&nbsp;ofrece&nbsp;un&nbsp;alto&nbsp;rendimiento&nbsp;en&nbsp;juegos,&nbsp;multitarea&nbsp;y&nbsp;aplicaciones&nbsp;exigentes,&nbsp;apoyado&nbsp;por&nbsp;sus&nbsp;36&nbsp;MB&nbsp;de&nbsp;caché&nbsp;combinada&nbsp;(L2+L3).</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5800XT AM4 AST\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"El Ryzen 7 5800XT ofrece un rendimiento s\\\\u00f3lido para la plataforma AM4 gracias a sus 8 n\\\\u00facleos Zen 3, altas frecuencias y amplia cach\\\\u00e9, lo que garantiza eficiencia en juegos y cargas de trabajo pesadas. Su compatibilidad con DDR4 y PCIe 4.0 maximiza el desempe\\\\u00f1o del sistema sin necesidad de migrar a plataformas m\\\\u00e1s nuevas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562032_692d1470bb029.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/24x_EE_zN2o\\\"]\"','2025-12-01 02:15:01','2025-12-01 04:07:12'),(18,125,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i5-14600KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;para&nbsp;socket&nbsp;LGA&nbsp;1700,&nbsp;equipado&nbsp;con&nbsp;14&nbsp;núcleos&nbsp;(6&nbsp;Performance-cores&nbsp;y&nbsp;8&nbsp;Efficient-cores)&nbsp;y&nbsp;20&nbsp;hilos,&nbsp;alcanzando&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.3&nbsp;GHz.&nbsp;Gracias&nbsp;a&nbsp;sus&nbsp;24&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache,&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;sólido&nbsp;en&nbsp;juegos,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;multitarea&nbsp;intensiva.&nbsp;Este&nbsp;modelo&nbsp;no&nbsp;incluye&nbsp;gráficos&nbsp;integrados,&nbsp;por&nbsp;lo&nbsp;que&nbsp;requiere&nbsp;obligatoriamente&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\" PROCESADOR INTEL CORE I5 14600KF LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\" PROCESADOR INTEL CORE \\\",\\\"detalle\\\":\\\"El Intel Core i5-14600KF combina una arquitectura h\\\\u00edbrida de 14 n\\\\u00facleos con frecuencias turbo de hasta 5.3 GHz y 24 MB de Smart Cache, logrando un rendimiento altamente eficiente en juegos y aplicaciones exigentes. Su soporte para el socket LGA 1700, junto con tecnolog\\\\u00eda DDR4\\\\\\/DDR5 y PCIe 5.0, lo convierte en una opci\\\\u00f3n vers\\\\u00e1til y actualizada para equipos de alto rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764561379_692d11e389195.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/5St4FD1utRw\\\"]\"','2025-12-01 02:22:22','2025-12-01 03:56:19'),(19,126,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i7-14700KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;moderno&nbsp;para&nbsp;socket&nbsp;LGA&nbsp;1700,&nbsp;con&nbsp;arquitectura&nbsp;híbrida&nbsp;—&nbsp;combina&nbsp;núcleos&nbsp;de&nbsp;rendimiento&nbsp;y&nbsp;eficiencia&nbsp;para&nbsp;maximizar&nbsp;potencia&nbsp;y&nbsp;eficiencia.&nbsp;Cuenta&nbsp;con&nbsp;33&nbsp;MB&nbsp;de&nbsp;caché&nbsp;(Intel&nbsp;Smart&nbsp;Cache)&nbsp;y&nbsp;puede&nbsp;alcanzar&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.6&nbsp;GHz,&nbsp;brindando&nbsp;un&nbsp;alto&nbsp;nivel&nbsp;de&nbsp;desempeño.&nbsp;Está&nbsp;pensado&nbsp;para&nbsp;tareas&nbsp;exigentes&nbsp;como&nbsp;juegos&nbsp;,&nbsp;edición&nbsp;de&nbsp;video,&nbsp;creación&nbsp;de&nbsp;contenido,&nbsp;renderizado&nbsp;3D&nbsp;y&nbsp;multitarea&nbsp;intensiva.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i7-14700KF CACHE 33 MB HASTA 5.6 GHZ\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"El Intel Core i7-14700KF es un procesador potente ideal para juegos de alto rendimiento, edici\\\\u00f3n de video, renderizado, multitarea pesada y trabajo profesional. Gracias a sus 20 n\\\\u00facleos, hasta 5.6 GHz y 33 MB de cach\\\\u00e9, ofrece gran velocidad y eficiencia en tareas exigentes, siendo perfecto para equipos modernos con tarjeta gr\\\\u00e1fica dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764560835_692d0fc355e1d.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/VW_pTdglQGU\\\"]\"','2025-12-01 02:31:01','2025-12-01 03:47:15'),(20,127,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;5700G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;muy&nbsp;completo&nbsp;que&nbsp;combina&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;gráficos&nbsp;integrados&nbsp;potentes,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;convierte&nbsp;en&nbsp;una&nbsp;excelente&nbsp;opción&nbsp;para&nbsp;equipos&nbsp;que&nbsp;buscan&nbsp;buen&nbsp;desempeño&nbsp;sin&nbsp;necesidad&nbsp;inmediata&nbsp;de&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.&nbsp;Gracias&nbsp;a&nbsp;sus&nbsp;8&nbsp;núcleos,&nbsp;16&nbsp;hilos&nbsp;y&nbsp;arquitectura&nbsp;Zen&nbsp;3,&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;sólido&nbsp;en&nbsp;tareas&nbsp;de&nbsp;productividad,&nbsp;edición&nbsp;ligera,&nbsp;programación&nbsp;y&nbsp;multitarea.&nbsp;Su&nbsp;GPU&nbsp;integrada&nbsp;Vega&nbsp;8&nbsp;permite&nbsp;ejecutar&nbsp;juegos&nbsp;en&nbsp;calidad&nbsp;media&nbsp;y&nbsp;realizar&nbsp;trabajos&nbsp;gráficos&nbsp;básicos&nbsp;sin&nbsp;hardware&nbsp;adicional.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5700G 3.8GHZ\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 7 5700G, tu PC obtiene la potencia ideal para ejecutar tus aplicaciones, programas y juegos con una fluidez destacada. Gracias a su frecuencia base de 3.8 GHz, su potencia turbo de hasta 4.6 GHz y su arquitectura Zen 3, este procesador ofrece un rendimiento s\\\\u00f3lido para quienes buscan eficiencia y velocidad sin compromisos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562185_692d15097d8ba.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/oxOdhelEiiU\\\"]\"','2025-12-01 02:39:44','2025-12-01 04:09:45'),(21,128,'<p>El&nbsp;<strong>Intel&nbsp;Pentium&nbsp;Gold&nbsp;G5420</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;básico&nbsp;y&nbsp;eficiente&nbsp;para&nbsp;tareas&nbsp;cotidianas,&nbsp;con&nbsp;<strong>2&nbsp;núcleos&nbsp;y&nbsp;4&nbsp;hilos</strong>,&nbsp;frecuencia&nbsp;de&nbsp;<strong>3.8&nbsp;GHz</strong>,&nbsp;gráficos&nbsp;integrados&nbsp;UHD&nbsp;610&nbsp;y&nbsp;bajo&nbsp;consumo&nbsp;de&nbsp;<strong>54&nbsp;W</strong>.&nbsp;Es&nbsp;ideal&nbsp;para&nbsp;oficinas,&nbsp;estudios,&nbsp;educación&nbsp;y&nbsp;equipos&nbsp;económicos.&nbsp;La&nbsp;versión&nbsp;<strong>OEM</strong>&nbsp;viene&nbsp;sin&nbsp;caja&nbsp;y&nbsp;usualmente&nbsp;sin&nbsp;disipador,&nbsp;siendo&nbsp;una&nbsp;opción&nbsp;accesible&nbsp;para&nbsp;reemplazos&nbsp;o&nbsp;PC&nbsp;sencillas.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL PENTIUM G5420 OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el Intel Pentium Gold G5420, tu PC obtiene el rendimiento ideal para ejecutar tus tareas diarias con rapidez y estabilidad. Gracias a su frecuencia de 3.8 GHz y sus 2 n\\\\u00facleos con 4 hilos, este procesador ofrece una experiencia fluida en actividades como navegaci\\\\u00f3n web, ofim\\\\u00e1tica, clases virtuales, multimedia y programas ligeros.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764559810_692d0bc291778.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/rKz6Q_ynPXE\\\"]\"','2025-12-01 02:47:27','2025-12-01 03:30:10'),(22,129,'<p>El&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;9&nbsp;285K&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;última&nbsp;generación&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;extremo&nbsp;en&nbsp;tareas&nbsp;profesionales,&nbsp;juegos&nbsp;avanzados&nbsp;y&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;intensivas.&nbsp;Equipado&nbsp;con&nbsp;24&nbsp;núcleos&nbsp;híbridos&nbsp;(Performance&nbsp;y&nbsp;Efficient)&nbsp;y&nbsp;36&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;este&nbsp;procesador&nbsp;alcanza&nbsp;una&nbsp;velocidad&nbsp;base&nbsp;de&nbsp;3.70&nbsp;GHz&nbsp;y&nbsp;un&nbsp;turbo&nbsp;máximo&nbsp;de&nbsp;5.70&nbsp;GHz,&nbsp;brindando&nbsp;una&nbsp;capacidad&nbsp;sobresaliente&nbsp;en&nbsp;multitarea,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;aplicaciones&nbsp;de&nbsp;alto&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE ULTRA 9 285K 3.70GHZ HASTA 5.70GHZ 36MB 24 CORE LGA1851\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el Intel Core Ultra 9 285K, tu PC obtiene la m\\\\u00e1xima potencia para ejecutar aplicaciones avanzadas, juegos de alto rendimiento y trabajos profesionales con una fluidez excepcional. Gracias a su frecuencia base de 3.70 GHz, su turbo de hasta 5.70 GHz y sus 24 n\\\\u00facleos h\\\\u00edbridos, este procesador est\\\\u00e1 dise\\\\u00f1ado para usuarios que necesitan un nivel extremo de rapidez, estabilidad y respuesta inmediata.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764560432_692d0e30417b3.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/B8nTndxxxaU\\\"]\"','2025-12-01 02:53:06','2025-12-01 03:40:32'),(23,130,'<p></p><p></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 9600X, CACHE 32 MB\\\\\\/ HASTA 5.4GHZ\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 5 9600X, tu PC obtiene la velocidad y eficiencia necesarias para ejecutar tus juegos y aplicaciones con un rendimiento superior. Gracias a sus 6 n\\\\u00facleos y 12 hilos, junto a su frecuencia turbo de hasta 5.4 GHz, este procesador ofrece una experiencia \\\\u00e1gil y fluida para quienes buscan potencia sin compromisos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562387_692d15d30fe31.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/Is9JgBzL-mA\\\"]\"','2025-12-01 03:00:33','2025-12-01 04:13:07'),(24,131,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i5-14600K&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;destacado&nbsp;en&nbsp;juegos,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;multitarea&nbsp;avanzada.&nbsp;Cuenta&nbsp;con&nbsp;14&nbsp;núcleos&nbsp;híbridos&nbsp;(6&nbsp;Performance-cores&nbsp;y&nbsp;8&nbsp;Efficient-cores)&nbsp;y&nbsp;20&nbsp;hilos,&nbsp;brindando&nbsp;una&nbsp;excelente&nbsp;combinación&nbsp;de&nbsp;potencia&nbsp;y&nbsp;eficiencia&nbsp;para&nbsp;cualquier&nbsp;tipo&nbsp;de&nbsp;tarea.</p><p>Alcanza&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.3&nbsp;GHz,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;tiempos&nbsp;de&nbsp;respuesta&nbsp;rápidos&nbsp;y&nbsp;un&nbsp;desempeño&nbsp;fluido&nbsp;en&nbsp;aplicaciones&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i5-14600K LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"el Intel Core i5-14600K incorpora 24 MB de cach\\\\u00e9 y la arquitectura m\\\\u00e1s moderna de Intel para el socket LGA1700, permitiendo aprovechar tecnolog\\\\u00edas actuales como DDR4\\\\\\/DDR5 y PCIe 5.0. Adem\\\\u00e1s, al ser un modelo desbloqueado, brinda la posibilidad de realizar overclocking para quienes buscan sacar el m\\\\u00e1ximo provecho de su equipo\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562537_692d166913972.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/dBBGPYjonEk\\\"]\"','2025-12-01 03:06:46','2025-12-01 04:15:37'),(25,132,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i3-9100F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;4&nbsp;núcleos&nbsp;y&nbsp;4&nbsp;hilos,&nbsp;perteneciente&nbsp;a&nbsp;la&nbsp;9ª&nbsp;generación&nbsp;Coffee&nbsp;Lake.&nbsp;Trabaja&nbsp;a&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;puede&nbsp;llegar&nbsp;hasta&nbsp;4.2&nbsp;GHz&nbsp;con&nbsp;Turbo&nbsp;Boost.&nbsp;Incluye&nbsp;6&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;tiene&nbsp;un&nbsp;consumo&nbsp;de&nbsp;65&nbsp;W&nbsp;(TDP)&nbsp;y&nbsp;utiliza&nbsp;el&nbsp;socket&nbsp;LGA&nbsp;1151,&nbsp;compatible&nbsp;con&nbsp;placas&nbsp;madre&nbsp;serie&nbsp;300.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I3-9100F 2.50GZ OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"El Intel Core i3-9100F aporta a la PC un rendimiento fiable para las tareas diarias y programas de exigencia moderada. Gracias a sus 4 n\\\\u00facleos y 4 hilos, el sistema puede ejecutar aplicaciones como navegadores, ofim\\\\u00e1tica, clases virtuales, multitarea b\\\\u00e1sica y algunos juegos ligeros sin presentar ca\\\\u00eddas de rendimiento. Su frecuencia de 3.6 GHz (hasta 4.2 GHz en Turbo Boost) permite que la PC responda con rapidez al abrir programas, cargar archivos y ejecutar procesos que requieren mayor velocidad moment\\\\u00e1nea.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562653_692d16dd6fc4f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/uSfURH7w7Yw\\\"]\"','2025-12-01 03:12:46','2025-12-01 04:17:33'),(26,133,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;9&nbsp;9950X&nbsp;ofrece&nbsp;una&nbsp;potencia&nbsp;extrema&nbsp;para&nbsp;llevar&nbsp;tu&nbsp;PC&nbsp;al&nbsp;máximo&nbsp;rendimiento&nbsp;en&nbsp;cualquier&nbsp;tarea.&nbsp;Con&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;4.3&nbsp;GHz,&nbsp;arquitectura&nbsp;Zen&nbsp;5&nbsp;y&nbsp;64&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;este&nbsp;procesador&nbsp;está&nbsp;diseñado&nbsp;para&nbsp;manejar&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;avanzadas&nbsp;con&nbsp;una&nbsp;velocidad&nbsp;y&nbsp;eficiencia&nbsp;sobresalientes.&nbsp;Su&nbsp;plataforma&nbsp;AM5&nbsp;permite&nbsp;aprovechar&nbsp;tecnologías&nbsp;modernas&nbsp;como&nbsp;DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0,&nbsp;garantizando&nbsp;un&nbsp;sistema&nbsp;rápido,&nbsp;ágil&nbsp;y&nbsp;preparado&nbsp;para&nbsp;el&nbsp;futuro</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD Ryzen 9 9950X 4.3GHZl 64MB AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 9 9950X, La PC obtiene una potencia de nivel profesional capaz de ejecutar cualquier tarea con m\\\\u00e1xima fluidez y rapidez. Gracias a su frecuencia de 4.3 GHz y su enorme cach\\\\u00e9 de 64 MB, el sistema responde de inmediato al abrir programas pesados, procesar archivos grandes y realizar m\\\\u00faltiples tareas a la vez sin perder rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764596370_692d9a9258550.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/6FKkJX9nD_s?si=4kej1KSCFiQVVlxF\\\"]\"','2025-12-01 13:39:30','2025-12-01 13:39:30'),(27,134,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;5500X3D&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;sobresaliente&nbsp;gracias&nbsp;a&nbsp;su&nbsp;tecnología&nbsp;3D&nbsp;V-Cache,&nbsp;que&nbsp;incorpora&nbsp;96&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;permitiendo&nbsp;una&nbsp;mayor&nbsp;rapidez&nbsp;en&nbsp;juegos&nbsp;y&nbsp;tareas&nbsp;que&nbsp;dependen&nbsp;fuertemente&nbsp;del&nbsp;acceso&nbsp;a&nbsp;datos.&nbsp;Con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;este&nbsp;procesador&nbsp;alcanza&nbsp;una&nbsp;frecuencia&nbsp;de&nbsp;3.0&nbsp;GHz,&nbsp;llegando&nbsp;hasta&nbsp;4.0&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;proporcionando&nbsp;una&nbsp;respuesta&nbsp;fluida&nbsp;tanto&nbsp;en&nbsp;aplicaciones&nbsp;de&nbsp;uso&nbsp;diario&nbsp;como&nbsp;en&nbsp;cargas&nbsp;más&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 5500X3D 3.00GHZ HASTA 4.00GHZ 96MB 6 CORE AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 5 5500X3D, la PC obtiene un rendimiento excelente para juegos y tareas del d\\\\u00eda a d\\\\u00eda gracias a su avanzada tecnolog\\\\u00eda 3D V-Cache, que incorpora 96 MB de cach\\\\u00e9 y acelera los procesos que requieren acceso r\\\\u00e1pido a datos. Su configuraci\\\\u00f3n de 6 n\\\\u00facleos y 12 hilos, junto con frecuencias que van desde 3.0 GHz hasta 4.0 GHz, permite que mi equipo funcione con gran fluidez al ejecutar aplicaciones, programas pesados o multitarea continua.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764597476_692d9ee41d858.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/NdpfV5IkUi0\\\"]\"','2025-12-01 13:57:56','2025-12-01 13:57:56'),(28,135,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i9-14900K&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;la&nbsp;máxima&nbsp;potencia&nbsp;en&nbsp;juegos,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;multitarea&nbsp;intensiva.&nbsp;Con&nbsp;su&nbsp;arquitectura&nbsp;híbrida&nbsp;de&nbsp;14ª&nbsp;generación,&nbsp;integra&nbsp;24&nbsp;núcleos&nbsp;(8&nbsp;de&nbsp;rendimiento&nbsp;y&nbsp;16&nbsp;de&nbsp;eficiencia)&nbsp;junto&nbsp;a&nbsp;32&nbsp;hilos,&nbsp;permitiendo&nbsp;ejecutar&nbsp;aplicaciones&nbsp;exigentes&nbsp;y&nbsp;flujos&nbsp;de&nbsp;trabajo&nbsp;pesados&nbsp;sin&nbsp;perder&nbsp;velocidad.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I9 14900K LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL CORE\\\",\\\"detalle\\\":\\\"Con el Intel Core i9-14900K, la PC obtiene un rendimiento extremo capaz de manejar cualquier tarea con total fluidez, desde juegos de alta exigencia hasta trabajos profesionales muy pesados. Gracias a su arquitectura h\\\\u00edbrida de 14\\\\u00aa generaci\\\\u00f3n, que combina 24 n\\\\u00facleos y 32 hilos,\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764598184_692da1a8dca39.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/rfqheytMk3U\\\"]\"','2025-12-01 14:09:44','2025-12-01 14:09:44'),(29,136,'<p>El&nbsp;<strong>Intel&nbsp;Core&nbsp;i5-14400</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;con&nbsp;<strong>10&nbsp;núcleos&nbsp;(6&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;+&nbsp;4&nbsp;eficientes)</strong>&nbsp;y&nbsp;<strong>16&nbsp;hilos</strong>,&nbsp;con&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;<strong>4.7&nbsp;GHz</strong>&nbsp;y&nbsp;<strong>20&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache</strong>.&nbsp;Incluye&nbsp;gráficos&nbsp;integrados&nbsp;<strong>Intel&nbsp;UHD&nbsp;Graphics&nbsp;730</strong>,&nbsp;es&nbsp;compatible&nbsp;con&nbsp;memoria&nbsp;<strong>DDR4&nbsp;o&nbsp;DDR5</strong>&nbsp;y&nbsp;usa&nbsp;socket&nbsp;<strong>LGA1700</strong>.&nbsp;Tiene&nbsp;un&nbsp;<strong>TDP&nbsp;base&nbsp;de&nbsp;65&nbsp;W</strong>,&nbsp;ideal&nbsp;para&nbsp;equipos&nbsp;equilibrados&nbsp;que&nbsp;busquen&nbsp;rendimiento&nbsp;eficiente&nbsp;sin&nbsp;excesivo&nbsp;consumo</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i5-14400 OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el Intel Core i5-14400, la PC obtiene un equilibrio perfecto entre potencia, eficiencia y compatibilidad. Sus 10 n\\\\u00facleos y 16 hilos permiten manejar multitarea, edici\\\\u00f3n, streaming, navegaci\\\\u00f3n y juegos sin problemas. La frecuencia de hasta 4.7 GHz asegura rapidez al abrir programas y ejecutar aplicaciones exigentes. Adem\\\\u00e1s, al incluir gr\\\\u00e1ficos integrados UHD 730, mi equipo puede funcionar sin tarjeta gr\\\\u00e1fica dedicada \\\\u2014 ideal para tareas comunes o uso multimedia.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764598655_692da37fd5e6c.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/tG-P5C5SS7U\\\"]\"','2025-12-01 14:17:35','2025-12-01 14:17:35'),(30,137,'<p>El&nbsp;<strong>AMD&nbsp;Ryzen&nbsp;9&nbsp;9900X&nbsp;(AM5)</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;con&nbsp;<strong>12&nbsp;núcleos</strong>,&nbsp;diseñado&nbsp;para&nbsp;rendir&nbsp;al&nbsp;máximo&nbsp;en&nbsp;tareas&nbsp;exigentes.&nbsp;Tiene&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;<strong>4.40&nbsp;GHz</strong>&nbsp;y&nbsp;puede&nbsp;alcanzar&nbsp;hasta&nbsp;<strong>5.60&nbsp;GHz</strong>&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;rendimiento&nbsp;intenso&nbsp;y&nbsp;fluido.&nbsp;Con&nbsp;<strong>64&nbsp;MB&nbsp;de&nbsp;caché</strong>,&nbsp;ofrece&nbsp;acceso&nbsp;rápido&nbsp;a&nbsp;datos,&nbsp;optimizando&nbsp;la&nbsp;velocidad&nbsp;en&nbsp;juegos,&nbsp;edición,&nbsp;renderizado&nbsp;y&nbsp;multitarea.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 9 9900X 4.40GHZ HASTA 5.60GHZ 64MB 12 CORE AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el RYZEN 9 9900X la PC obtiene un salto considerable de potencia y velocidad: sus 12 n\\\\u00facleos y 24 hilos permiten manejar sin esfuerzo juegos modernos, edici\\\\u00f3n de video, renderizado 3D, multitarea pesada, streaming y software profesional. Su boost hasta 5.6 GHz asegura una respuesta inmediata al ejecutar tareas exigentes, mientras que los 64 MB de cach\\\\u00e9 optimizan el acceso a datos y reducen tiempos de carga.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764599225_692da5b9c98a9.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/Dslwua6cck4\\\"]\"','2025-12-01 14:27:05','2025-12-01 14:27:05'),(31,138,'<p>El&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;5&nbsp;225F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;moderno&nbsp;orientado&nbsp;al&nbsp;rendimiento&nbsp;balanceado,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;buena&nbsp;velocidad&nbsp;en&nbsp;tareas&nbsp;diarias,&nbsp;juegos&nbsp;y&nbsp;productividad.&nbsp;Con&nbsp;frecuencias&nbsp;que&nbsp;alcanzan&nbsp;hasta&nbsp;4.9&nbsp;GHz&nbsp;y&nbsp;20&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;proporciona&nbsp;una&nbsp;experiencia&nbsp;fluida&nbsp;y&nbsp;eficiente,&nbsp;manteniendo&nbsp;un&nbsp;consumo&nbsp;moderado&nbsp;y&nbsp;aprovechando&nbsp;la&nbsp;arquitectura&nbsp;Intel&nbsp;de&nbsp;última&nbsp;generación.&nbsp;Es&nbsp;ideal&nbsp;para&nbsp;usuarios&nbsp;que&nbsp;necesitan&nbsp;potencia&nbsp;sin&nbsp;llegar&nbsp;al&nbsp;nivel&nbsp;extremo&nbsp;de&nbsp;los&nbsp;procesadores&nbsp;tope&nbsp;de&nbsp;gama.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE ULTRA 5 225F 3.30 4.9GHZ 20MB\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"En tu PC, el Intel Core Ultra 5 225F te garantiza un funcionamiento r\\\\u00e1pido y estable para todas tus actividades: juegos, multitarea, programas de trabajo y navegaci\\\\u00f3n. Su frecuencia de hasta 4.9 GHz permite que el sistema responda con fluidez, mientras que su cach\\\\u00e9 de 20 MB acelera la carga de aplicaciones y procesos. Es un procesador ideal para equipos modernos que buscan rendimiento s\\\\u00f3lido sin elevar demasiado el consumo o la temperatura.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764599765_692da7d528e0e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/G0EgLs7AkxE?si=kB19AlQgvOv8tfnB\\\"]\"','2025-12-01 14:36:05','2025-12-01 14:36:05'),(32,139,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;9&nbsp;9950X3D&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;socket&nbsp;AM5,&nbsp;con&nbsp;arquitectura&nbsp;Zen&nbsp;5&nbsp;y&nbsp;tecnología&nbsp;3D&nbsp;V-Cache.&nbsp;Con&nbsp;16&nbsp;núcleos&nbsp;y&nbsp;32&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;alrededor&nbsp;de&nbsp;4.3&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;≈&nbsp;5.7&nbsp;GHz,&nbsp;ofrece&nbsp;un&nbsp;alto&nbsp;desempeño&nbsp;tanto&nbsp;en&nbsp;tareas&nbsp;de&nbsp;productividad&nbsp;como&nbsp;en&nbsp;juegos&nbsp;exigentes.&nbsp;Su&nbsp;ventaja&nbsp;destacada&nbsp;es&nbsp;la&nbsp;gran&nbsp;cantidad&nbsp;de&nbsp;caché&nbsp;—&nbsp;gracias&nbsp;al&nbsp;3D&nbsp;V-Cache&nbsp;—&nbsp;lo&nbsp;que&nbsp;mejora&nbsp;notablemente&nbsp;el&nbsp;rendimiento&nbsp;en&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;intensivas,&nbsp;reduciendo&nbsp;latencias&nbsp;y&nbsp;acelerando&nbsp;el&nbsp;acceso&nbsp;a&nbsp;datos.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 9 9950X3D 4.30GHZ HASTA\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 9 9950X3D en la PC obtengo un rendimiento de primer nivel: el equipo puede gestionar sin esfuerzo tareas exigentes \\\\u2014 edici\\\\u00f3n de video, renderizado, programas pesados, multitarea \\\\u2014, y al mismo tiempo ofrecer fluidez en juegos modernos. La combinaci\\\\u00f3n de alto conteo de n\\\\u00facleos + 3D V-Cache asegura respuestas r\\\\u00e1pidas, tiempos de carga cortos y estabilidad bajo carga. Adem\\\\u00e1s, al ser un procesador AM5, preparo mi PC para el hardware moderno, con compatibilidad de memorias r\\\\u00e1pidas DDR5 y componentes actuales.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764600153_692da95949aba.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/xWXAPMAmFhA\\\"]\"','2025-12-01 14:42:33','2025-12-01 14:42:33'),(33,140,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i9-12900KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;escritorio&nbsp;con&nbsp;arquitectura&nbsp;híbrida&nbsp;(serie&nbsp;12ª&nbsp;generación,&nbsp;“Alder&nbsp;Lake”),&nbsp;que&nbsp;combina&nbsp;16&nbsp;núcleos&nbsp;(8&nbsp;núcleos&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;+&nbsp;8&nbsp;núcleos&nbsp;eficientes)&nbsp;y&nbsp;24&nbsp;hilos.&nbsp;Puede&nbsp;alcanzar&nbsp;velocidades&nbsp;de&nbsp;hasta&nbsp;5.20&nbsp;GHz,&nbsp;y&nbsp;cuenta&nbsp;con&nbsp;30&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache,&nbsp;lo&nbsp;que&nbsp;le&nbsp;proporciona&nbsp;potencia&nbsp;suficiente&nbsp;para&nbsp;juegos,&nbsp;edición&nbsp;de&nbsp;video,&nbsp;renderizado,&nbsp;multitarea&nbsp;exigente&nbsp;y&nbsp;trabajo&nbsp;profesional.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I9-12900KF LGA 1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el Intel Core i9-12900KF en tu PC, obtendr\\\\u00e1s un rendimiento sobresaliente en pr\\\\u00e1cticamente cualquier tarea: desde jugar videojuegos modernos a m\\\\u00e1ximo detalle, hasta editar video 4K, renderizar 3D, trabajar con m\\\\u00faltiples aplicaciones a la vez, e incluso streaming o dise\\\\u00f1o profesional. Sus 16 n\\\\u00facleos y 24 hilos aseguran potencia m\\\\u00e1s que suficiente para multitarea intensa, mientras que las altas frecuencias y gran cach\\\\u00e9 agilizan los procesos y reducen tiempos de carga.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764600791_692dabd741ca4.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/7K0aR8JoMH0\\\"]\"','2025-12-01 14:53:11','2025-12-01 14:53:11'),(34,141,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;4500&nbsp;es&nbsp;un&nbsp;procesador&nbsp;económico&nbsp;y&nbsp;eficiente&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;“boost”&nbsp;de&nbsp;hasta&nbsp;aproximadamente&nbsp;4.1&nbsp;GHz,&nbsp;Está&nbsp;pensado&nbsp;para&nbsp;ofrecer&nbsp;una&nbsp;relación&nbsp;calidad-precio&nbsp;atractiva&nbsp;—&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;de&nbsp;bajo&nbsp;o&nbsp;medio&nbsp;presupuesto&nbsp;—&nbsp;prestando&nbsp;buen&nbsp;desempeño&nbsp;en&nbsp;tareas&nbsp;comunes,&nbsp;navegación,&nbsp;ofimática,&nbsp;edición&nbsp;ligera&nbsp;y&nbsp;juegos&nbsp;cuando&nbsp;se&nbsp;usa&nbsp;con&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 4500 3.60GHz AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 5 4500 en la PC obtengo un rendimiento eficiente y equilibrado, adecuado para uso diario, juegos moderados, trabajo, estudio o multimedia. Sus 6 n\\\\u00facleos y 12 hilos garantizan fluidez en multitarea, al mismo tiempo que su frecuencia permite abrir programas y responder r\\\\u00e1pido ante demandas normales.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764601254_692dada6bd077.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/boWjWZMnD6U?si=RkdiWzx2knHuhgKZ\\\"]\"','2025-12-01 15:00:54','2025-12-01 15:00:54'),(35,142,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;5500&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;media&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;4.2&nbsp;GHz,&nbsp;Está&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;3&nbsp;(7&nbsp;nm),&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;eficiencia&nbsp;energética&nbsp;y&nbsp;buen&nbsp;rendimiento&nbsp;por&nbsp;núcleo.&nbsp;Su&nbsp;caché&nbsp;L3&nbsp;es&nbsp;de&nbsp;16&nbsp;MB,&nbsp;y&nbsp;tiene&nbsp;un&nbsp;diseño&nbsp;de&nbsp;TDP&nbsp;de&nbsp;65&nbsp;W,&nbsp;ideal&nbsp;para&nbsp;sistemas&nbsp;balanceados&nbsp;en&nbsp;consumo&nbsp;y&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 5500 OEM AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD RYZEN 5 5500 en la PC obtengo un rendimiento equilibrado y eficiente: los 6 n\\\\u00facleos y 12 hilos permiten manejar multitarea, navegaci\\\\u00f3n, trabajo, multimedia y juegos con fluidez, siempre que tenga una tarjeta gr\\\\u00e1fica dedicada. Su frecuencia hasta 4.2 GHz garantiza respuestas r\\\\u00e1pidas al abrir programas o al ejecutar tareas exigentes moderadas, mientras que el TDP de 65 W asegura consumo moderado y temperaturas controladas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764601627_692daf1b5633f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/TkNuCWagETM?si=wvZPTV1rYL0mq5JD\\\"]\"','2025-12-01 15:07:07','2025-12-01 15:07:07'),(36,143,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;5600GT&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;basado&nbsp;en&nbsp;arquitectura&nbsp;Zen&nbsp;3&nbsp;(Cezanne).&nbsp;Tiene&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;con&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;4.6&nbsp;GHz.&nbsp;Cuenta&nbsp;con&nbsp;16&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;DDR4-3200,&nbsp;y&nbsp;un&nbsp;TDP&nbsp;de&nbsp;65&nbsp;W,&nbsp;Además,&nbsp;incluye&nbsp;gráficos&nbsp;integrados&nbsp;Radeon&nbsp;Graphics&nbsp;(Vega&nbsp;7),&nbsp;lo&nbsp;que&nbsp;permite&nbsp;usar&nbsp;el&nbsp;PC&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR, AMD, RYZEN 5 5600GT 6N\\\\\\/12H 3.9Ghz\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Si utilizas el Ryzen 5 5600GT en tu PC, obtienes un equipo equilibrado y funcional para un uso vers\\\\u00e1til: desde navegar, trabajar, estudiar, hacer edici\\\\u00f3n ligera o multimedia \\\\u2014 hasta jugar t\\\\u00edtulos exigentes en calidad moderada sin necesidad de una tarjeta gr\\\\u00e1fica externa.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764601981_692db07da0f0f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/qXAAxIaSLDc\\\"]\"','2025-12-01 15:13:01','2025-12-01 15:13:01'),(37,144,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i3-4130&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;básica/media&nbsp;de&nbsp;escritorio,&nbsp;con&nbsp;arquitectura&nbsp;Haswell,&nbsp;fabricado&nbsp;en&nbsp;22&nbsp;nm,&nbsp;para&nbsp;socket&nbsp;LGA&nbsp;1150.&nbsp;Tiene&nbsp;2&nbsp;núcleos&nbsp;físicos&nbsp;y&nbsp;4&nbsp;hilos&nbsp;(Hyper-Threading),&nbsp;opera&nbsp;a&nbsp;una&nbsp;frecuencia&nbsp;de&nbsp;3.4&nbsp;GHz,&nbsp;sin&nbsp;turbo&nbsp;boost.&nbsp;Cuenta&nbsp;con&nbsp;3&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;incorpora&nbsp;gráficos&nbsp;integrados&nbsp;Intel&nbsp;HD&nbsp;Graphics&nbsp;4400,&nbsp;y&nbsp;tiene&nbsp;un&nbsp;consumo&nbsp;(TDP)&nbsp;de&nbsp;54&nbsp;W.&nbsp;Este&nbsp;procesador&nbsp;está&nbsp;concebido&nbsp;para&nbsp;tareas&nbsp;cotidianas:&nbsp;ofimática,&nbsp;navegación,&nbsp;multimedia,&nbsp;edición&nbsp;ligera,&nbsp;y&nbsp;uso&nbsp;general.&nbsp;Gracias&nbsp;a&nbsp;sus&nbsp;gráficos&nbsp;integrados&nbsp;puede&nbsp;funcionar&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;económicas&nbsp;o&nbsp;de&nbsp;oficina.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL I3 4130 CON DISIPADOR OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si uso un i3-4130 en mi PC, obtengo un equipo suficiente para trabajar con programas b\\\\u00e1sicos, navegar, ver videos, hacer tareas de oficina, estudiar, y usar software ligero. Su 2 n\\\\u00facleos \\\\\\/ 4 hilos son adecuados para tareas sencillas o moderadas, y sus gr\\\\u00e1ficos integrados HD 4400 permiten reproducir video en alta definici\\\\u00f3n sin tarjeta de video. Con un consumo moderado (54 W) y disipador incluido, mantiene el equipo simple, econ\\\\u00f3mico y eficiente.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764602499_692db28384eb1.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/N-KRN6aZRnI\\\"]\"','2025-12-01 15:21:39','2025-12-01 15:21:39'),(38,145,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i3-3240&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;gama&nbsp;básica/media,&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Ivy&nbsp;Bridge,&nbsp;fabricado&nbsp;en&nbsp;22&nbsp;nm.&nbsp;Tiene&nbsp;2&nbsp;núcleos&nbsp;físicos&nbsp;y&nbsp;4&nbsp;hilos&nbsp;(Hyper-Threading),&nbsp;con&nbsp;frecuencia&nbsp;de&nbsp;3.4&nbsp;GHz.&nbsp;Cuenta&nbsp;con&nbsp;3&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;lo&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;la&nbsp;agilidad&nbsp;del&nbsp;sistema&nbsp;en&nbsp;tareas&nbsp;simples&nbsp;y&nbsp;cotidianas.&nbsp;Además,&nbsp;incluye&nbsp;gráficos&nbsp;integrados&nbsp;Intel&nbsp;HD&nbsp;Graphics&nbsp;2500,&nbsp;suficientes&nbsp;para&nbsp;uso&nbsp;de&nbsp;oficina,&nbsp;navegación,&nbsp;reproducción&nbsp;de&nbsp;video&nbsp;y&nbsp;tareas&nbsp;multimedia&nbsp;básicas&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;Su&nbsp;consumo&nbsp;es&nbsp;moderado&nbsp;(TDP&nbsp;~&nbsp;55&nbsp;W),&nbsp;y&nbsp;es&nbsp;compatible&nbsp;con&nbsp;memorias&nbsp;DDR3,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;adecuado&nbsp;para&nbsp;equipos&nbsp;compactos&nbsp;o&nbsp;económicos.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL I3 3240 CON DISIPADOR OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"Si uso el Intel Core i3-3240 en la PC, obtengo un sistema funcional y eficiente para tareas habituales: trabajar con documentos, navegar en internet, ver videos, usar programas ligeros, y ejecutar software de oficina o educativo sin inconvenientes.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764603127_692db4f76a79a.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/fSaIL8lNtNY\\\"]\"','2025-12-01 15:32:07','2025-12-01 15:32:07'),(39,146,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;7700X&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;diseñado&nbsp;para&nbsp;gaming,&nbsp;edición,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;tareas&nbsp;exigentes.&nbsp;Usa&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;4&nbsp;y&nbsp;está&nbsp;fabricado&nbsp;a&nbsp;5&nbsp;nm,&nbsp;lo&nbsp;que&nbsp;le&nbsp;asegura&nbsp;eficiencia&nbsp;y&nbsp;potencia.&nbsp;Tiene&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;manejar&nbsp;múltiples&nbsp;tareas&nbsp;al&nbsp;mismo&nbsp;tiempo&nbsp;sin&nbsp;perder&nbsp;rendimiento.&nbsp;Su&nbsp;frecuencia&nbsp;base&nbsp;suele&nbsp;rondar&nbsp;los&nbsp;4.5&nbsp;GHz,&nbsp;y&nbsp;puede&nbsp;alcanzar&nbsp;hasta&nbsp;5.4&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;lo&nbsp;que&nbsp;asegura&nbsp;un&nbsp;rendimiento&nbsp;muy&nbsp;rápido&nbsp;en&nbsp;tareas&nbsp;intensivas,&nbsp;juegos&nbsp;y&nbsp;aplicaciones&nbsp;pesadas.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 7700X AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 7 7700X en la PC, obtengo un rendimiento potente y moderno \\\\u2014 ideal para jugar juegos exigentes, editar video, trabajar con 3D, dise\\\\u00f1o, multitarea intensiva o uso profesional. Gracias a sus 8 n\\\\u00facleos y 16 hilos, mi sistema puede ejecutar varias aplicaciones exigentes al mismo tiempo sin ralentizar.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764603633_692db6f16209e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9t-saE6F7Iw?si=0_KSTdAycTsyPuHV\\\"]\"','2025-12-01 15:40:33','2025-12-01 15:40:33'),(40,147,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i7-14700F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;escritorio&nbsp;con&nbsp;arquitectura&nbsp;híbrida&nbsp;de&nbsp;14ª&nbsp;generación,&nbsp;compatible&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1700.&nbsp;Cuenta&nbsp;con&nbsp;20&nbsp;núcleos&nbsp;totales&nbsp;(8&nbsp;de&nbsp;“Performance-cores”&nbsp;+&nbsp;12&nbsp;de&nbsp;“Efficient-cores”)&nbsp;y&nbsp;28&nbsp;hilos,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;exigentes.&nbsp;Su&nbsp;frecuencia&nbsp;turbo&nbsp;máxima&nbsp;llega&nbsp;a&nbsp;5.4&nbsp;GHz.&nbsp;Además,&nbsp;incorpora&nbsp;33&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache&nbsp;+&nbsp;memoria&nbsp;caché&nbsp;L2&nbsp;adicional,&nbsp;y&nbsp;es&nbsp;compatible&nbsp;con&nbsp;DDR4&nbsp;/&nbsp;DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0&nbsp;/&nbsp;4.0,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;trabajar&nbsp;con&nbsp;hardware&nbsp;moderno&nbsp;y&nbsp;de&nbsp;alta&nbsp;velocidad.&nbsp;Es&nbsp;un&nbsp;modelo&nbsp;“F”,&nbsp;así&nbsp;que&nbsp;no&nbsp;incluye&nbsp;gráficos&nbsp;integrados&nbsp;—&nbsp;por&nbsp;lo&nbsp;que&nbsp;necesita&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I7 14700F 2.1GHZ HASTA 5.4GHZ\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el i7-14700F en tu PC, obtendr\\\\u00e1s un nivel de potencia elevado: tu sistema podr\\\\u00e1 manejar juegos exigentes, edici\\\\u00f3n de video, renderizados, trabajos pesados, multitarea avanzada y streaming sin inconvenientes. Los 20 n\\\\u00facleos \\\\\\/ 28 hilos garantizan que m\\\\u00faltiples programas puedan correr simult\\\\u00e1neamente sin perder fluidez.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764604553_692dba898187c.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/LC0SFyvvMAw\\\"]\"','2025-12-01 15:55:53','2025-12-01 15:55:53'),(41,148,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;3&nbsp;3200G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;de&nbsp;entrada/media-económica&nbsp;con&nbsp;socket&nbsp;AM4,&nbsp;basado&nbsp;en&nbsp;arquitectura&nbsp;Zen+&nbsp;(12&nbsp;nm).&nbsp;Cuenta&nbsp;con&nbsp;4&nbsp;núcleos&nbsp;físicos&nbsp;y&nbsp;4&nbsp;hilos,&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;alcanza&nbsp;hasta&nbsp;4.0&nbsp;GHz&nbsp;con&nbsp;Turbo.&nbsp;Tiene&nbsp;integrada&nbsp;la&nbsp;gráfica&nbsp;Radeon&nbsp;Vega&nbsp;8,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;tener&nbsp;salida&nbsp;de&nbsp;video&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;cotidianas,&nbsp;multimedia,&nbsp;ofimática&nbsp;y&nbsp;juegos&nbsp;ligeros/moderados,&nbsp;La&nbsp;caché&nbsp;L3&nbsp;total&nbsp;es&nbsp;de&nbsp;4&nbsp;MB,&nbsp;y&nbsp;su&nbsp;TDP&nbsp;ronda&nbsp;los&nbsp;65&nbsp;W,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;bastante&nbsp;eficiente&nbsp;en&nbsp;consumo&nbsp;para&nbsp;su&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR RYZEN 3 3200G 3.60GHz\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Si uso el Ryzen 3 3200G en mi PC, obtengo un equipo equilibrado y vers\\\\u00e1til: puedo realizar tareas diarias (navegar, editar documentos, reproducir video, trabajar en ofim\\\\u00e1tica), ver contenido multimedia, y hasta disfrutar de juegos ligeros o moderados sin necesidad de una tarjeta de video dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764605002_692dbc4a4878e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9BBFNoBdofM?si=kqMV0oVwE0qZQlqZ\\\"]\"','2025-12-01 16:03:22','2025-12-01 16:03:22'),(42,149,'<p>El&nbsp;<strong>Intel&nbsp;Core&nbsp;i5-12600KF</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;híbrida&nbsp;de&nbsp;la&nbsp;12ª&nbsp;generación&nbsp;(Alder&nbsp;Lake),&nbsp;compatible&nbsp;con&nbsp;socket&nbsp;<strong>LGA1700</strong>.&nbsp;Cuenta&nbsp;con&nbsp;<strong>10&nbsp;núcleos</strong>&nbsp;(6&nbsp;núcleos&nbsp;de&nbsp;rendimiento&nbsp;+&nbsp;4&nbsp;núcleos&nbsp;eficientes)&nbsp;y&nbsp;<strong>16&nbsp;hilos</strong>,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;exigentes.&nbsp;Su&nbsp;frecuencia&nbsp;turbo&nbsp;máxima&nbsp;es&nbsp;de&nbsp;<strong>4.90&nbsp;GHz</strong>,&nbsp;acompañado&nbsp;de&nbsp;<strong>20&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache</strong></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I5-12600KF\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el i5-12600KF en tu PC, obtendr\\\\u00e1s un sistema potente y balanceado capaz de manejar pr\\\\u00e1cticamente cualquier tarea con fluidez: desde juegos , edici\\\\u00f3n de video, programas de dise\\\\u00f1o o trabajo intensivo, hasta multitarea exigente sin slowdowns.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764605358_692dbdae5d50d.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/BMQmOvKLWPQ?si=PAev94p-Xo_n3RKX\\\"]\"','2025-12-01 16:09:18','2025-12-01 16:09:18'),(43,150,'<p>El&nbsp;<strong>Intel&nbsp;Core&nbsp;i7-14700K</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;para&nbsp;el&nbsp;socket&nbsp;<strong>LGA1700</strong>,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;alto&nbsp;rendimiento&nbsp;en&nbsp;juegos&nbsp;y&nbsp;tareas&nbsp;profesionales.&nbsp;Incorpora&nbsp;<strong>20&nbsp;núcleos</strong>&nbsp;(8&nbsp;de&nbsp;rendimiento&nbsp;y&nbsp;12&nbsp;de&nbsp;eficiencia),&nbsp;<strong>28&nbsp;hilos</strong>&nbsp;y&nbsp;alcanza&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;<strong>5.6&nbsp;GHz</strong>,&nbsp;garantizando&nbsp;excelente&nbsp;capacidad&nbsp;de&nbsp;respuesta&nbsp;en&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;intensivas.</p><p>Cuenta&nbsp;con&nbsp;<strong>33&nbsp;MB&nbsp;de&nbsp;caché</strong>,&nbsp;soporte&nbsp;para&nbsp;<strong>memorias&nbsp;DDR5&nbsp;y&nbsp;DDR4</strong>,&nbsp;y&nbsp;gráficos&nbsp;integrados&nbsp;<strong>Intel&nbsp;UHD&nbsp;Graphics&nbsp;770</strong>,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;funcionamiento&nbsp;básico&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;una&nbsp;GPU&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I7 14700K LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el i7-14700K en tu PC, obtienes un equipo preparado para pr\\\\u00e1cticamente todo: juegos AAA a altos FPS, edici\\\\u00f3n de video, modelado 3D, multitarea intensa, streaming, compilaciones, y cualquier software exigente. Con sus 20 n\\\\u00facleos y la capacidad de alcanzar 5.6 GHz, tu sistema manejar\\\\u00e1 cargas intensivas sin pesta\\\\u00f1ear. La gran cach\\\\u00e9 ayuda a que los procesos fluyan r\\\\u00e1pido y los tiempos de carga se reduzcan.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764605781_692dbf55a6ead.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/AEWKYpz7NL8?si=3NR4kmqxnslbFJS2\\\"]\"','2025-12-01 16:16:21','2025-12-01 16:16:21'),(44,151,NULL,'\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 7500F OEM AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"el RYZEN 5 7500F le da a tu PC una combinaci\\\\u00f3n perfecta de rendimiento, eficiencia y modernidad, ideal para un equipo potente y bien optimizado.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764606594_692dc282ad9ae.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/7blE0kYwRlQ\\\"]\"','2025-12-01 16:29:54','2025-12-01 16:29:54');
/*!40000 ALTER TABLE `producto_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `codigo_producto` varchar(255) NOT NULL,
  `categoria_id` bigint(20) unsigned NOT NULL,
  `marca_id` bigint(20) unsigned DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) NOT NULL DEFAULT 5,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `destacado` tinyint(1) DEFAULT 0,
  `mostrar_igv` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `productos_codigo_producto_unique` (`codigo_producto`) USING BTREE,
  KEY `productos_categoria_id_foreign` (`categoria_id`) USING BTREE,
  KEY `productos_marca_id_index` (`marca_id`) USING BTREE,
  KEY `idx_productos_deleted_at` (`deleted_at`),
  CONSTRAINT `productos_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE,
  CONSTRAINT `productos_marca_id_foreign` FOREIGN KEY (`marca_id`) REFERENCES `marcas_productos` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (113,'PROCESADOR AMD RYZEN 7 8700F, 4.1/5.0 Ghz, AM5','El AMD Ryzen 7 8700F es un procesador de 8 núcleos con arquitectura Zen 4 para el socket AM5, que alcanza hasta 5.0 GHz de velocidad, tiene 16MB de caché L3, soporta memoria DDR5 y un TDP de 65W. Es una versión sin gráficos integrados (\"F\"), lo que significa que necesita una tarjeta de video dedicada.','RYZEN78700F',19,15,1020.00,1010.00,2,5,'1764561917_692d13fd08633.jpg',1,0,1,'2025-11-27 14:35:56','2025-12-01 13:11:11',NULL),(114,'PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5','La MSI MAG B860 TOMAHAWK WIFI es una placa base ATX para gaming compatible con los procesadores Intel Core Ultra (Serie 2) a través del socket LGA 1851. Ofrece características premium como PCIe 5.0, Thunderbolt 4, Wi-Fi 7 y LAN de 5 Gbps, además de soporte para memoria RAM DDR5.','MSIMAGB860',18,18,890.00,880.00,2,5,'1764254728_69286408ad1e4.jpg',1,0,1,'2025-11-27 14:45:28','2025-11-27 14:45:28',NULL),(115,'MOUSE GAMER RAZER BASILISK V3 26K DPI','Con el Razer Basilisk V3 X HyperSpeed, no hay límites sobre cómo eliges jugar. Equipado con 9 controles programables, conectividad inalámbrica de modo dual y Razer Chroma RGB personalizable, está diseñado para responder a un solo maestro: usted. Habilitado a través de Razer Synapse, Razer Hypershift le permite asignar y desbloquear un conjunto de comandos secundarios además de los 9 controles existentes en el mouse. Como un mouse ergonómico inalámbrico para juegos diseñado para juegos largos, puede pasar mucho tiempo antes de que sea necesario reemplazar las baterías.','BASILISKV3',17,12,210.00,200.00,2,5,'1764255356_6928667c332b2.webp',1,0,1,'2025-11-27 14:55:56','2025-11-27 14:55:56',NULL),(116,'PLACA MADRE ASUS ROG STRIX B850 A GAMING WIFI AM5','La ASUS ROG STRIX B850 A GAMING WIFI es una placa base con socket AM5 de formato ATX, diseñada para procesadores AMD Ryzen serie 7000, 8000 y 9000. Ofrece características de gama alta como DDR5, PCIe 5.0 para la tarjeta gráfica, Wi-Fi 7, y una solución de alimentación robusta para soportar procesadores de alto rendimiento. Su diseño también incluye un acabado estético en blanco y una solución de enfriamiento mejorada.','B850 ROG',18,10,960.00,950.00,2,5,'1764256530_69286b12a8371.webp',1,0,1,'2025-11-27 15:15:30','2025-11-27 15:23:25',NULL),(117,'CASE ENKORE SHADOW ENK5021 ARGB SIN FUENTE 4 FANS','La TARJETA DE VIDEO AMD RADEON XFX SWIFT GLASS 9070 16GB WHITE EDITION OC es una tarjeta gráfica de alta gama para juegos, con un diseño blanco de triple ventilador de la línea Swift de XFX. Cuenta con 16GB de memoria GDDR6, una interfaz PCIe 5.0 y el chip AMD Radeon RX 9070 XT con una frecuencia de hasta 2970 MHz (Boost Clock). Su sistema de refrigeración \"Swift\" está optimizado para un buen rendimiento térmico y un diseño moderno sin RGB, aunque tiene un logo blanco iluminado.','CG',20,15,2700.00,2800.00,2,5,'1764279504_6928c4d0a0838.webp',1,0,1,'2025-11-27 21:38:24','2025-11-27 21:38:24',NULL),(118,'fdsbnfbgvd','fdgngngf','456ngf',21,21,234.00,234.00,23,5,'1764422830_692af4ae1d94d.jpeg',1,0,1,'2025-11-29 13:27:10','2025-11-29 13:27:53','2025-11-29 13:27:53'),(119,'fdghgfjh','gfhmhmgfhmgf','gfhfgmk54',11,18,23.00,234.00,23,5,'1764422954_692af52a61f33.jpeg',1,0,1,'2025-11-29 13:29:14','2025-11-29 15:23:46','2025-11-29 15:23:46'),(120,'gbffdgbh','dfsbvdsbffgsdefhfdsghhbnfdgnnnghfffffffffffffffffffffffffffffffffffffffffffffffffffffffsawddhgfdgfdgfhngfdnhfgnghfngfngfngfngfnhgfdhrewojbbrgouebfdojusoujsfdbnusfbdfbudbsfudiubifdsubifdbuifdbufsud','cgs',19,15,1010.00,1010.00,2,5,'1764429904_692b105012aed.jpeg',1,0,1,'2025-11-29 15:25:04','2025-11-30 23:07:48','2025-11-30 23:07:48'),(121,'sdfbfdbdgf','sdfbvfsd','gfbdbgdfgbf',21,25,32.00,32.00,2,5,'1764429966_692b108e3804d.jpeg',1,0,1,'2025-11-29 15:26:06','2025-11-30 23:07:43','2025-11-30 23:07:43'),(122,'PROCESADOR INTEL CORE I3 10105F','El Intel Core i3-10105F es un procesador de escritorio de 10ª generación con 4 núcleos y 8 hilos, diseñado para el socket LGA 1200. Tiene una frecuencia base de \\(3.7\\) GHz que puede alcanzar los \\(4.4\\) GHz en modo turbo, 6 MB de caché y un TDP de \\(65\\)W. La \"F\" en su nombre indica que no cuenta con gráficos integrados, por lo que requiere una tarjeta gráfica dedicada para su funcionamiento.','PROCI310105F',19,14,290.00,280.00,2,5,'1764561687_692d1317c43fa.jpg',1,0,1,'2025-12-01 01:46:52','2025-12-01 13:11:39',NULL),(123,'PROCESADOR RYZEN AMD RYZEN 7 9800X 3D AM5','El AMD Ryzen 7 9800X3D es un procesador de 8 núcleos y 16 hilos con arquitectura de 4 nm, diseñado para gaming de alto rendimiento. Destaca por su tecnología 3D V-Cache, que incluye hasta 96MB de caché L3 y una frecuencia que alcanza los 5.2GHz, todo ello sobre el socket AM5 y con soporte para PCIe 5.0 y memoria DDR5. Ofrece una excelente eficiencia energética (120W TDP) y es ideal para juegos y aplicaciones exigentes.','PROC79800X',19,15,1960.00,1950.00,2,5,'1764554449_692cf6d112a8d.webp',1,0,1,'2025-12-01 02:00:49','2025-12-01 13:16:24',NULL),(124,'PROCESADOR AMD RYZEN 7 5800XT AM4 AST','El AMD Ryzen 7 5800XT AM4 es un procesador de 8 núcleos y 16 hilos para la plataforma AM4, con una frecuencia base de 3.8 GHz y un modo turbo que alcanza hasta 4.8 GHz. Basado en la arquitectura Zen 3, ofrece un alto rendimiento en juegos, multitarea y aplicaciones exigentes, apoyado por sus 36 MB de caché combinada (L2+L3).','RYZEN75800XT',19,15,760.00,750.00,2,5,'1764562032_692d1470742d2.jpg',1,0,1,'2025-12-01 02:15:01','2025-12-01 13:10:50',NULL),(125,'PROCESADOR INTEL CORE I5 14600KF LGA1700','El Intel Core i5-14600KF es un procesador de 14ª generación para socket LGA 1700, equipado con 14 núcleos (6 Performance-cores y 8 Efficient-cores) y 20 hilos, alcanzando una frecuencia turbo de hasta 5.3 GHz. Gracias a sus 24 MB de Intel Smart Cache, ofrece un rendimiento sólido en juegos, creación de contenido y multitarea intensiva. Este modelo no incluye gráficos integrados, por lo que requiere obligatoriamente una tarjeta gráfica dedicada.','PROCI514600KF',19,14,810.00,800.00,2,5,'1764561379_692d11e342567.jpg',1,0,1,'2025-12-01 02:22:22','2025-12-01 13:12:23',NULL),(126,'PROCESADOR INTEL CORE i7-14700KF CACHE 33 MB HASTA 5.6 GHZ','El Intel Core i7-14700KF es un procesador moderno para socket LGA 1700, con arquitectura híbrida — combina núcleos de rendimiento y eficiencia para maximizar potencia y eficiencia. Cuenta con 33 MB de caché (Intel Smart Cache) y puede alcanzar una frecuencia turbo de hasta 5.6 GHz, brindando un alto nivel de desempeño. Está pensado para tareas exigentes como juegos , edición de video, creación de contenido, renderizado 3D y multitarea intensiva.','PROCi7-14700KF',19,14,1360.00,1350.00,2,5,'1764561407_692d11ff694c4.jpg',1,0,1,'2025-12-01 02:31:01','2025-12-01 13:13:57',NULL),(127,'PROCESADOR AMD RYZEN 7 5700G 3.8GHZ','El AMD Ryzen 7 5700G es un procesador muy completo que combina alto rendimiento con gráficos integrados potentes, lo que lo convierte en una excelente opción para equipos que buscan buen desempeño sin necesidad inmediata de una tarjeta gráfica dedicada. Gracias a sus 8 núcleos, 16 hilos y arquitectura Zen 3, ofrece un rendimiento sólido en tareas de productividad, edición ligera, programación y multitarea. Su GPU integrada Vega 8 permite ejecutar juegos en calidad media y realizar trabajos gráficos básicos sin hardware adicional.','RYZEN75700G',19,15,685.00,675.00,2,5,'1764562185_692d150931460.jpg',1,0,1,'2025-12-01 02:39:43','2025-12-01 13:10:28',NULL),(128,'PROCESADOR PENTIUM G5420 OEM','El Intel Pentium Gold G5420 es un procesador básico y eficiente para tareas cotidianas, con 2 núcleos y 4 hilos, frecuencia de 3.8 GHz, gráficos integrados UHD 610 y bajo consumo de 54 W. Es ideal para oficinas, estudios, educación y equipos económicos. La versión OEM viene sin caja y usualmente sin disipador, siendo una opción accesible para reemplazos o PC sencillas.','PROCG5420OEM',19,14,110.00,100.00,2,5,'1764559810_692d0bc247648.jpg',1,0,1,'2025-12-01 02:47:26','2025-12-01 13:15:56',NULL),(129,'PROCESADOR INTEL CORE ULTRA 9 285K 3.70GHZ HASTA 5.70GHZ 36MB 24 CORE LGA1851','El Intel Core Ultra 9 285K es un procesador de última generación diseñado para ofrecer un rendimiento extremo en tareas profesionales, juegos avanzados y cargas de trabajo intensivas. Equipado con 24 núcleos híbridos (Performance y Efficient) y 36 MB de caché, este procesador alcanza una velocidad base de 3.70 GHz y un turbo máximo de 5.70 GHz, brindando una capacidad sobresaliente en multitarea, creación de contenido y aplicaciones de alto rendimiento.','PROC9285K',19,14,2610.00,2600.00,2,5,'1764560431_692d0e2feafe1.png',1,0,1,'2025-12-01 02:53:05','2025-12-01 13:15:34',NULL),(130,'PROCESADOR AMD RYZEN 5 9600X, CACHE 32 MB/ HASTA 5.4GHZ','El AMD Ryzen 5 9600X es un procesador de última generación diseñado para ofrecer un rendimiento sobresaliente en juegos, multitarea y aplicaciones modernas. Con 6 núcleos y 12 hilos, junto a su arquitectura avanzada, alcanza frecuencias de hasta 5.4 GHz, garantizando una respuesta rápida y estable incluso en tareas exigentes.\r\nEquipado con 32 MB de caché, el Ryzen 5 9600X mejora la velocidad de acceso a datos y optimiza el rendimiento por núcleo, brindando una experiencia fluida en productividad, streaming y gaming competitivo.','RYZEN59600X',19,15,875.00,865.00,2,5,'1764562386_692d15d2bcb9d.jpg',1,0,1,'2025-12-01 03:00:32','2025-12-01 13:09:52',NULL),(131,'PROCESADOR INTEL CORE i5-14600K LGA1700','El Intel Core i5-14600K es un procesador de 14ª generación diseñado para ofrecer un rendimiento destacado en juegos, creación de contenido y multitarea avanzada. Cuenta con 14 núcleos híbridos (6 Performance-cores y 8 Efficient-cores) y 20 hilos, brindando una excelente combinación de potencia y eficiencia para cualquier tipo de tarea.\r\nAlcanza una frecuencia turbo de hasta 5.3 GHz, lo que garantiza tiempos de respuesta rápidos y un desempeño fluido en aplicaciones exigentes.','PROCi5-14600K',19,14,840.00,830.00,2,5,'1764562536_692d1668b233f.jpg',1,0,1,'2025-12-01 03:06:46','2025-12-01 13:13:36',NULL),(132,'PROCESADOR INTEL CORE I3-9100F 2.50GZ OEM','El Intel Core i3-9100F es un procesador de 4 núcleos y 4 hilos, perteneciente a la 9ª generación Coffee Lake. Trabaja a 3.6 GHz y puede llegar hasta 4.2 GHz con Turbo Boost. Incluye 6 MB de caché, tiene un consumo de 65 W (TDP) y utiliza el socket LGA 1151, compatible con placas madre serie 300.','PROCI3-9100F',19,14,170.00,160.00,2,5,'1764562653_692d16dd290cd.jpg',1,0,1,'2025-12-01 03:12:45','2025-12-01 13:12:04',NULL),(133,'PROCESADOR AMD Ryzen 9 9950X 4.3GHZl 64MB AM5','El AMD Ryzen 9 9950X ofrece una potencia extrema para llevar tu PC al máximo rendimiento en cualquier tarea. Con una frecuencia base de 4.3 GHz, arquitectura Zen 5 y 64 MB de caché L3, este procesador está diseñado para manejar cargas de trabajo avanzadas con una velocidad y eficiencia sobresalientes. Su plataforma AM5 permite aprovechar tecnologías modernas como DDR5 y PCIe 5.0, garantizando un sistema rápido, ágil y preparado para el futuro','PROC99950X',19,15,2210.00,2200.00,2,5,'1764596370_692d9a920c79d.png',1,0,1,'2025-12-01 13:39:30','2025-12-01 13:39:30',NULL),(134,'PROCESADOR AMD RYZEN 5 5500X3D 3.00GHZ HASTA 4.00GHZ 96MB 6 CORE AM4','El AMD Ryzen 5 5500X3D ofrece un rendimiento sobresaliente gracias a su tecnología 3D V-Cache, que incorpora 96 MB de caché, permitiendo una mayor rapidez en juegos y tareas que dependen fuertemente del acceso a datos. Con 6 núcleos y 12 hilos, este procesador alcanza una frecuencia de 3.0 GHz, llegando hasta 4.0 GHz en modo turbo, proporcionando una respuesta fluida tanto en aplicaciones de uso diario como en cargas más exigentes.','PROC55500X3D',19,15,700.00,690.00,2,5,'1764597475_692d9ee3c2a16.jpg',1,0,1,'2025-12-01 13:57:55','2025-12-01 13:57:55',NULL),(135,'PROCESADOR INTEL CORE I9 14900K LGA1700','El Intel Core i9-14900K es un procesador de alto rendimiento diseñado para ofrecer la máxima potencia en juegos, creación de contenido y multitarea intensiva. Con su arquitectura híbrida de 14ª generación, integra 24 núcleos (8 de rendimiento y 16 de eficiencia) junto a 32 hilos, permitiendo ejecutar aplicaciones exigentes y flujos de trabajo pesados sin perder velocidad.','PROC914900K',19,14,1990.00,1980.00,2,5,'1764598184_692da1a892331.jpg',1,0,1,'2025-12-01 14:09:44','2025-12-01 14:09:44',NULL),(136,'PROCESADOR INTEL CORE i5-14400 OEM','El Intel Core i5-14400 es un procesador de 14ª generación con 10 núcleos (6 de alto rendimiento + 4 eficientes) y 16 hilos, con frecuencia turbo de hasta 4.7 GHz y 20 MB de Intel Smart Cache. Incluye gráficos integrados Intel UHD Graphics 730, es compatible con memoria DDR4 o DDR5 y usa socket LGA1700. Tiene un TDP base de 65 W, ideal para equipos equilibrados que busquen rendimiento eficiente sin excesivo consumo.','PROC5-14400',19,14,620.00,610.00,2,5,'1764598655_692da37f878ed.jpg',1,0,1,'2025-12-01 14:17:35','2025-12-01 14:17:35',NULL),(137,'PROCESADOR AMD RYZEN 9 9900X 4.40GHZ HASTA 5.60GHZ 64MB 12 CORE AM5','El AMD Ryzen 9 9900X (AM5) es un procesador de gama alta con 12 núcleos, diseñado para rendir al máximo en tareas exigentes. Tiene una frecuencia base de 4.40 GHz y puede alcanzar hasta 5.60 GHz en modo turbo, lo que lo hace ideal para rendimiento intenso y fluido. Con 64 MB de caché, ofrece acceso rápido a datos, optimizando la velocidad en juegos, edición, renderizado y multitarea.','PROC99900X',19,15,1730.00,1720.00,2,5,'1764599225_692da5b97f76a.jpg',1,0,1,'2025-12-01 14:27:05','2025-12-01 14:27:05',NULL),(138,'PROCESADOR INTEL CORE ULTRA 5 225F 3.30 4.9GHZ 20MB','El Intel Core Ultra 5 225F es un procesador moderno orientado al rendimiento balanceado, diseñado para ofrecer buena velocidad en tareas diarias, juegos y productividad. Con frecuencias que alcanzan hasta 4.9 GHz y 20 MB de caché, proporciona una experiencia fluida y eficiente, manteniendo un consumo moderado y aprovechando la arquitectura Intel de última generación. Es ideal para usuarios que necesitan potencia sin llegar al nivel extremo de los procesadores tope de gama.','PROC5225F',19,14,294.00,284.00,2,5,'1764599764_692da7d4d19b6.jpg',1,0,1,'2025-12-01 14:36:04','2025-12-01 14:36:04',NULL),(139,'PROCESADOR AMD RYZEN 9 9950X3D 4.30GHZ HASTA','El AMD Ryzen 9 9950X3D es un procesador de gama alta para socket AM5, con arquitectura Zen 5 y tecnología 3D V-Cache. Con 16 núcleos y 32 hilos, frecuencia base alrededor de 4.3 GHz y turbo de hasta ≈ 5.7 GHz, ofrece un alto desempeño tanto en tareas de productividad como en juegos exigentes. Su ventaja destacada es la gran cantidad de caché — gracias al 3D V-Cache — lo que mejora notablemente el rendimiento en cargas de trabajo intensivas, reduciendo latencias y acelerando el acceso a datos.','PROC99950X3D',19,15,3010.00,3000.00,2,5,'1764600152_692da958f04b0.jpg',1,0,1,'2025-12-01 14:42:32','2025-12-01 14:42:32',NULL),(140,'PROCESADOR INTEL CORE I9-12900KF LGA 1700','El Intel Core i9-12900KF es un procesador de gama alta para escritorio con arquitectura híbrida (serie 12ª generación, “Alder Lake”), que combina 16 núcleos (8 núcleos de alto rendimiento + 8 núcleos eficientes) y 24 hilos. Puede alcanzar velocidades de hasta 5.20 GHz, y cuenta con 30 MB de Intel Smart Cache, lo que le proporciona potencia suficiente para juegos, edición de video, renderizado, multitarea exigente y trabajo profesional.','PROCI9-12900KF',19,14,1490.00,1480.00,2,5,'1764600790_692dabd6ed4f6.jpg',1,0,1,'2025-12-01 14:53:10','2025-12-01 14:53:10',NULL),(141,'PROCESADOR AMD RYZEN 5 4500 3.60GHz AM4','El AMD Ryzen 5 4500 es un procesador económico y eficiente para socket AM4, con 6 núcleos y 12 hilos, frecuencia base de 3.6 GHz y “boost” de hasta aproximadamente 4.1 GHz, Está pensado para ofrecer una relación calidad-precio atractiva — ideal para PCs de bajo o medio presupuesto — prestando buen desempeño en tareas comunes, navegación, ofimática, edición ligera y juegos cuando se usa con una tarjeta gráfica dedicada.','PROC54500',19,15,280.00,270.00,2,5,'1764601254_692dada670c87.jpg',1,0,1,'2025-12-01 15:00:54','2025-12-01 15:00:54',NULL),(142,'PROCESADOR AMD RYZEN 5 5500 OEM AM4','El AMD Ryzen 5 5500 es un procesador de gama media para socket AM4, con 6 núcleos y 12 hilos, frecuencia base de 3.6 GHz y turbo de hasta 4.2 GHz, Está basado en la arquitectura Zen 3 (7 nm), lo que le da eficiencia energética y buen rendimiento por núcleo. Su caché L3 es de 16 MB, y tiene un diseño de TDP de 65 W, ideal para sistemas balanceados en consumo y rendimiento.','PROC55500',19,15,310.00,300.00,2,5,'1764601627_692daf1b0d1eb.jpg',1,0,1,'2025-12-01 15:07:07','2025-12-01 15:07:07',NULL),(143,'PROCESADOR, AMD, RYZEN 5 5600GT 6N/12H 3.9Ghz','El AMD Ryzen 5 5600GT es un procesador de gama media-alta para socket AM4, basado en arquitectura Zen 3 (Cezanne). Tiene 6 núcleos y 12 hilos, con frecuencia base de 3.6 GHz y turbo de hasta 4.6 GHz. Cuenta con 16 MB de caché L3, soporte para memoria DDR4-3200, y un TDP de 65 W, Además, incluye gráficos integrados Radeon Graphics (Vega 7), lo que permite usar el PC sin necesidad de una tarjeta gráfica dedicada.','PROC55600GT',19,15,580.00,570.00,2,5,'1764601981_692db07d56e9d.jpg',1,0,1,'2025-12-01 15:13:01','2025-12-01 15:13:01',NULL),(144,'PROCESADOR INTEL I3 4130 CON DISIPADOR OEM','El Intel Core i3-4130 es un procesador de gama básica/media de escritorio, con arquitectura Haswell, fabricado en 22 nm, para socket LGA 1150. Tiene 2 núcleos físicos y 4 hilos (Hyper-Threading), opera a una frecuencia de 3.4 GHz, sin turbo boost. Cuenta con 3 MB de caché L3, incorpora gráficos integrados Intel HD Graphics 4400, y tiene un consumo (TDP) de 54 W. Este procesador está concebido para tareas cotidianas: ofimática, navegación, multimedia, edición ligera, y uso general. Gracias a sus gráficos integrados puede funcionar sin necesidad de tarjeta gráfica dedicada, ideal para PCs económicas o de oficina.','PROC34130',19,15,110.00,100.00,2,5,'1764602499_692db2833ad94.jpg',1,0,1,'2025-12-01 15:21:39','2025-12-01 15:21:39',NULL),(145,'PROCESADOR INTEL I3 3240 CON DISIPADOR OEM','El Intel Core i3-3240 es un procesador de escritorio de gama básica/media, basado en la arquitectura Ivy Bridge, fabricado en 22 nm. Tiene 2 núcleos físicos y 4 hilos (Hyper-Threading), con frecuencia de 3.4 GHz. Cuenta con 3 MB de caché L3, lo que ayuda a mantener la agilidad del sistema en tareas simples y cotidianas. Además, incluye gráficos integrados Intel HD Graphics 2500, suficientes para uso de oficina, navegación, reproducción de video y tareas multimedia básicas sin necesidad de tarjeta gráfica dedicada, Su consumo es moderado (TDP ~ 55 W), y es compatible con memorias DDR3, lo que lo hace adecuado para equipos compactos o económicos.','PROC33240',19,14,80.00,70.00,2,5,'1764603127_692db4f71e311.jpg',1,0,1,'2025-12-01 15:32:07','2025-12-01 15:32:07',NULL),(146,'PROCESADOR AMD RYZEN 7 7700X AM5','El AMD Ryzen 7 7700X es un procesador de escritorio de alto rendimiento diseñado para gaming, edición, creación de contenido y tareas exigentes. Usa la arquitectura Zen 4 y está fabricado a 5 nm, lo que le asegura eficiencia y potencia. Tiene 8 núcleos y 16 hilos, lo que permite manejar múltiples tareas al mismo tiempo sin perder rendimiento. Su frecuencia base suele rondar los 4.5 GHz, y puede alcanzar hasta 5.4 GHz en modo turbo, lo que asegura un rendimiento muy rápido en tareas intensivas, juegos y aplicaciones pesadas.','PROC77700X',19,15,1220.00,1210.00,2,5,'1764603633_692db6f113f89.jpg',1,0,1,'2025-12-01 15:40:33','2025-12-01 15:40:33',NULL),(147,'PROCESADOR INTEL CORE I7 14700F 2.1GHZ HASTA 5.4GHZ','El Intel Core i7-14700F es un procesador de gama alta para escritorio con arquitectura híbrida de 14ª generación, compatible con socket LGA 1700. Cuenta con 20 núcleos totales (8 de “Performance-cores” + 12 de “Efficient-cores”) y 28 hilos, ideal para tareas exigentes. Su frecuencia turbo máxima llega a 5.4 GHz. Además, incorpora 33 MB de Intel Smart Cache + memoria caché L2 adicional, y es compatible con DDR4 / DDR5 y PCIe 5.0 / 4.0, lo que le permite trabajar con hardware moderno y de alta velocidad. Es un modelo “F”, así que no incluye gráficos integrados — por lo que necesita tarjeta gráfica dedicada.','PROC714700F',19,14,1320.00,1310.00,2,5,'1764604553_692dba8933232.jpg',1,0,1,'2025-12-01 15:55:53','2025-12-01 15:55:53',NULL),(148,'PROCESADOR RYZEN 3 3200G 3.60GHz','El AMD Ryzen 3 3200G es un procesador de gama de entrada/media-económica con socket AM4, basado en arquitectura Zen+ (12 nm). Cuenta con 4 núcleos físicos y 4 hilos, una frecuencia base de 3.6 GHz y alcanza hasta 4.0 GHz con Turbo. Tiene integrada la gráfica Radeon Vega 8, lo que permite tener salida de video sin necesidad de tarjeta gráfica dedicada, ideal para tareas cotidianas, multimedia, ofimática y juegos ligeros/moderados, La caché L3 total es de 4 MB, y su TDP ronda los 65 W, lo que lo hace bastante eficiente en consumo para su rendimiento.','PROC33200G',19,15,280.00,270.00,2,5,'1764605001_692dbc49ee668.jpg',1,0,1,'2025-12-01 16:03:21','2025-12-01 16:03:21',NULL),(149,'PROCESADOR INTEL CORE I5-12600KF','El Intel Core i5-12600KF es un procesador de gama media-alta basado en la arquitectura híbrida de la 12ª generación (Alder Lake), compatible con socket LGA1700. Cuenta con 10 núcleos (6 núcleos de rendimiento + 4 núcleos eficientes) y 16 hilos, ideal para tareas exigentes. Su frecuencia turbo máxima es de 4.90 GHz, acompañado de 20 MB de Intel Smart Cache.','PROC5-12600KF',19,14,700.00,690.00,2,5,'1764605357_692dbdada7ee6.jpg',1,0,1,'2025-12-01 16:09:17','2025-12-01 16:09:17',NULL),(150,'PROCESADOR INTEL CORE I7 14700K LGA1700','El Intel Core i7-14700K es un procesador de escritorio de 14ª generación para el socket LGA1700, con 20 núcleos (8 de rendimiento y 12 eficientes), 28 hilos y una frecuencia turbo máxima de 5.6 GHz. Está diseñado para tareas exigentes como juegos y creación de contenido, y cuenta con gráficos integrados (Intel UHD Graphics 770), una caché de 33 MB y soporte para memorias DDR5 y DDR4.','PROC714700K',19,14,1450.00,1440.00,2,5,'1764605781_692dbf5556cba.jpg',1,0,1,'2025-12-01 16:16:21','2025-12-01 16:16:21',NULL),(151,'PROCESADOR AMD RYZEN 5 7500F OEM AM5','El AMD Ryzen 5 7500F es un procesador de 6 núcleos y 12 hilos para el socket AM5, con una frecuencia base de 3.7 GHz que alcanza hasta 5.0 GHz en modo turbo. Es una versión OEM sin gráficos integrados, ideal para PCs de gaming o de alto rendimiento que usarán una tarjeta gráfica dedicada, y cuenta con 32 MB de caché L3 y un TDP de 65W.','PROC57500F',19,15,600.00,590.00,2,5,'1764606593_692dc2810778b.jpg',1,0,1,'2025-12-01 16:29:53','2025-12-01 16:29:53',NULL);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(10) NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `razon_social` varchar(200) NOT NULL,
  `nombre_comercial` varchar(200) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contacto_nombre` varchar(100) DEFAULT NULL,
  `contacto_telefono` varchar(20) DEFAULT NULL,
  `dias_credito` int(11) NOT NULL DEFAULT 0,
  `limite_credito` decimal(12,2) NOT NULL DEFAULT 0.00,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `proveedores_numero_documento_unique` (`numero_documento`),
  KEY `proveedores_numero_documento_index` (`numero_documento`),
  KEY `proveedores_activo_index` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reclamos`
--

DROP TABLE IF EXISTS `reclamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reclamos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `numero_reclamo` varchar(20) NOT NULL,
  `user_cliente_id` bigint(20) unsigned DEFAULT NULL,
  `consumidor_nombre` varchar(255) NOT NULL,
  `consumidor_dni` varchar(12) NOT NULL,
  `consumidor_direccion` text NOT NULL,
  `consumidor_telefono` varchar(15) NOT NULL,
  `consumidor_email` varchar(255) NOT NULL,
  `es_menor_edad` tinyint(1) DEFAULT 0,
  `apoderado_nombre` varchar(255) DEFAULT NULL,
  `apoderado_dni` varchar(12) DEFAULT NULL,
  `apoderado_direccion` text DEFAULT NULL,
  `apoderado_telefono` varchar(15) DEFAULT NULL,
  `apoderado_email` varchar(255) DEFAULT NULL,
  `tipo_bien` enum('producto','servicio') NOT NULL DEFAULT 'producto',
  `monto_reclamado` decimal(10,2) NOT NULL,
  `descripcion_bien` text NOT NULL,
  `tipo_solicitud` enum('reclamo','queja') NOT NULL DEFAULT 'reclamo',
  `detalle_reclamo` text NOT NULL,
  `pedido_consumidor` text NOT NULL,
  `respuesta_proveedor` text DEFAULT NULL,
  `fecha_respuesta` date DEFAULT NULL,
  `estado` enum('pendiente','en_proceso','resuelto','cerrado') DEFAULT 'pendiente',
  `fecha_limite_respuesta` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `numero_reclamo` (`numero_reclamo`) USING BTREE,
  KEY `user_cliente_id` (`user_cliente_id`) USING BTREE,
  KEY `estado` (`estado`) USING BTREE,
  KEY `tipo_solicitud` (`tipo_solicitud`) USING BTREE,
  KEY `created_at` (`created_at`) USING BTREE,
  KEY `fecha_limite_respuesta` (`fecha_limite_respuesta`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reclamos`
--

LOCK TABLES `reclamos` WRITE;
/*!40000 ALTER TABLE `reclamos` DISABLE KEYS */;
INSERT INTO `reclamos` VALUES (1,'REC-202509-9165',3,'EMER RODRIGO YARLEQIE','77425200','miraflores lima','999332324','rodrigoyarleque7@gmail.com',0,NULL,NULL,NULL,NULL,NULL,'producto',122.00,'wsdffvsadgfvdsfvdfsv','reclamo','sdfgvdsfggbfdgbfdgbfgdb','dfgbfdgbfgdbfg','dsgdsfbfsdgbdsfbfdsbfdgdfgbfdgbfggdb','2025-09-02','resuelto','2025-10-01','2025-09-01 07:03:24','2025-09-02 14:30:48');
/*!40000 ALTER TABLE `reclamos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas`
--

DROP TABLE IF EXISTS `recompensas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo` enum('puntos','descuento','envio_gratis','regalo') NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `estado` enum('programada','activa','pausada','expirada','cancelada') NOT NULL DEFAULT 'programada',
  `creado_por` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_activo_vigencia` (`fecha_inicio`,`fecha_fin`),
  KEY `idx_tipo_activo` (`tipo`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas`
--

LOCK TABLES `recompensas` WRITE;
/*!40000 ALTER TABLE `recompensas` DISABLE KEYS */;
INSERT INTO `recompensas` VALUES (41,'Descuento de Navidad 20%','Descuento especial del 20% por Navidad en todas tus compras.','descuento','2025-10-12 00:00:00','2025-10-31 00:00:00','pausada',1,'2025-10-12 21:53:22','2025-11-03 20:36:58'),(42,'Descuento de Navidad 20%','Descuento especial del 20% por Navidad en todas tus compras.','descuento','2025-10-12 00:00:00','2025-10-31 00:00:00','pausada',1,'2025-10-12 22:02:22','2025-11-03 20:36:47');
/*!40000 ALTER TABLE `recompensas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_clientes`
--

DROP TABLE IF EXISTS `recompensas_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_clientes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `segmento` enum('todos','nuevos','recurrentes','vip','no_registrados') NOT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_recompensa_segmento` (`recompensa_id`,`segmento`),
  KEY `idx_cliente_especifico` (`cliente_id`),
  CONSTRAINT `recompensas_clientes_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_clientes_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_clientes`
--

LOCK TABLES `recompensas_clientes` WRITE;
/*!40000 ALTER TABLE `recompensas_clientes` DISABLE KEYS */;
INSERT INTO `recompensas_clientes` VALUES (25,41,'todos',NULL),(26,42,'no_registrados',NULL);
/*!40000 ALTER TABLE `recompensas_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_descuentos`
--

DROP TABLE IF EXISTS `recompensas_descuentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_descuentos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `tipo_descuento` enum('porcentaje','cantidad_fija') NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `compra_minima` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  CONSTRAINT `recompensas_descuentos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_descuentos`
--

LOCK TABLES `recompensas_descuentos` WRITE;
/*!40000 ALTER TABLE `recompensas_descuentos` DISABLE KEYS */;
INSERT INTO `recompensas_descuentos` VALUES (20,41,'porcentaje',10.00,50.00),(21,42,'porcentaje',10.00,50.00);
/*!40000 ALTER TABLE `recompensas_descuentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_envios`
--

DROP TABLE IF EXISTS `recompensas_envios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_envios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `minimo_compra` decimal(10,2) DEFAULT 0.00,
  `zonas_aplicables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`zonas_aplicables`)),
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  CONSTRAINT `recompensas_envios_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_envios`
--

LOCK TABLES `recompensas_envios` WRITE;
/*!40000 ALTER TABLE `recompensas_envios` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_envios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_historial`
--

DROP TABLE IF EXISTS `recompensas_historial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_historial` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `cliente_id` bigint(20) unsigned NOT NULL,
  `pedido_id` bigint(20) unsigned DEFAULT NULL,
  `puntos_otorgados` decimal(10,2) DEFAULT 0.00,
  `beneficio_aplicado` text DEFAULT NULL,
  `fecha_aplicacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `pedido_id` (`pedido_id`),
  CONSTRAINT `recompensas_historial_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_historial_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_historial_ibfk_3` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_historial`
--

LOCK TABLES `recompensas_historial` WRITE;
/*!40000 ALTER TABLE `recompensas_historial` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_historial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_notificaciones_clientes`
--

DROP TABLE IF EXISTS `recompensas_notificaciones_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_notificaciones_clientes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `cliente_id` bigint(20) unsigned NOT NULL,
  `popup_id` bigint(20) unsigned NOT NULL,
  `fecha_notificacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_visualizacion` timestamp NULL DEFAULT NULL,
  `fecha_cierre` timestamp NULL DEFAULT NULL,
  `estado` enum('enviada','vista','cerrada','expirada') DEFAULT 'enviada',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_recompensa_id` (`recompensa_id`),
  KEY `idx_cliente_id` (`cliente_id`),
  KEY `idx_popup_id` (`popup_id`),
  CONSTRAINT `recompensas_notificaciones_clientes_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_notificaciones_clientes_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_notificaciones_clientes_ibfk_3` FOREIGN KEY (`popup_id`) REFERENCES `recompensas_popups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_notificaciones_clientes`
--

LOCK TABLES `recompensas_notificaciones_clientes` WRITE;
/*!40000 ALTER TABLE `recompensas_notificaciones_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_notificaciones_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_popups`
--

DROP TABLE IF EXISTS `recompensas_popups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_popups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_popup` varchar(255) DEFAULT NULL,
  `texto_boton` varchar(100) DEFAULT 'Ver más',
  `url_destino` varchar(500) DEFAULT NULL,
  `mostrar_cerrar` tinyint(1) DEFAULT 1,
  `auto_cerrar_segundos` int(11) DEFAULT NULL,
  `popup_activo` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_recompensa_id` (`recompensa_id`),
  KEY `idx_popup_activo` (`popup_activo`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_recompensa_activo` (`recompensa_id`,`popup_activo`),
  CONSTRAINT `recompensas_popups_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_popups`
--

LOCK TABLES `recompensas_popups` WRITE;
/*!40000 ALTER TABLE `recompensas_popups` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_popups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_productos`
--

DROP TABLE IF EXISTS `recompensas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_productos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned DEFAULT NULL,
  `categoria_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  KEY `producto_id` (`producto_id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `recompensas_productos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_productos_ibfk_3` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_productos`
--

LOCK TABLES `recompensas_productos` WRITE;
/*!40000 ALTER TABLE `recompensas_productos` DISABLE KEYS */;
INSERT INTO `recompensas_productos` VALUES (29,41,NULL,18),(30,42,NULL,18);
/*!40000 ALTER TABLE `recompensas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_puntos`
--

DROP TABLE IF EXISTS `recompensas_puntos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_puntos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `puntos_por_compra` decimal(10,2) DEFAULT 0.00,
  `puntos_por_monto` decimal(10,2) DEFAULT 0.00,
  `puntos_registro` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  CONSTRAINT `recompensas_puntos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_puntos`
--

LOCK TABLES `recompensas_puntos` WRITE;
/*!40000 ALTER TABLE `recompensas_puntos` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_puntos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas_regalos`
--

DROP TABLE IF EXISTS `recompensas_regalos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas_regalos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `cantidad` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `recompensas_regalos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_regalos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_regalos`
--

LOCK TABLES `recompensas_regalos` WRITE;
/*!40000 ALTER TABLE `recompensas_regalos` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_regalos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resumenes`
--

DROP TABLE IF EXISTS `resumenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumenes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint(20) unsigned NOT NULL,
  `fecha_resumen` date NOT NULL,
  `fecha_generacion` date NOT NULL,
  `correlativo` int(10) unsigned NOT NULL,
  `identificador` varchar(30) NOT NULL,
  `ticket` varchar(50) DEFAULT NULL,
  `cantidad_comprobantes` int(10) unsigned DEFAULT NULL,
  `total_gravado` decimal(12,2) DEFAULT 0.00,
  `total_exonerado` decimal(12,2) DEFAULT 0.00,
  `total_inafecto` decimal(12,2) DEFAULT 0.00,
  `total_igv` decimal(12,2) DEFAULT 0.00,
  `total_general` decimal(12,2) DEFAULT 0.00,
  `xml_path` varchar(500) DEFAULT NULL,
  `cdr_path` varchar(500) DEFAULT NULL,
  `estado` enum('PENDIENTE','ACEPTADO','RECHAZADO') DEFAULT 'PENDIENTE',
  `codigo_sunat` varchar(10) DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `fecha_procesamiento` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identificador` (`identificador`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_fecha_resumen` (`fecha_resumen`),
  KEY `idx_ticket` (`ticket`),
  KEY `idx_estado` (`estado`),
  KEY `idx_identificador` (`identificador`),
  CONSTRAINT `fk_resumenes_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresa_info` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumenes`
--

LOCK TABLES `resumenes` WRITE;
/*!40000 ALTER TABLE `resumenes` DISABLE KEYS */;
/*!40000 ALTER TABLE `resumenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resumenes_detalle`
--

DROP TABLE IF EXISTS `resumenes_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumenes_detalle` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `resumen_id` bigint(20) unsigned NOT NULL,
  `comprobante_id` bigint(20) unsigned NOT NULL,
  `tipo_comprobante` varchar(2) DEFAULT NULL,
  `serie` varchar(4) DEFAULT NULL,
  `numero` int(10) unsigned DEFAULT NULL,
  `estado_item` enum('1','2','3') DEFAULT '1',
  `total` decimal(12,2) DEFAULT NULL,
  `igv` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_resumen` (`resumen_id`),
  KEY `idx_comprobante` (`comprobante_id`),
  CONSTRAINT `resumenes_detalle_ibfk_1` FOREIGN KEY (`resumen_id`) REFERENCES `resumenes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resumenes_detalle_ibfk_2` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumenes_detalle`
--

LOCK TABLES `resumenes_detalle` WRITE;
/*!40000 ALTER TABLE `resumenes_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `resumenes_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`) USING BTREE,
  KEY `role_has_permissions_role_id_foreign` (`role_id`) USING BTREE,
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
INSERT INTO `role_has_permissions` VALUES (13,1),(16,1),(17,1),(17,2),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(38,1),(39,1),(40,1),(41,1),(42,1),(43,1),(44,1),(45,1),(46,1),(47,1),(48,1),(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),(55,1),(56,1),(57,1),(58,1),(59,1),(60,1),(61,1),(62,1),(63,1),(64,1),(65,1),(66,1),(67,1),(68,1),(69,1),(70,1),(71,1),(72,1),(73,1),(74,1),(75,1),(76,1),(77,1),(78,1),(79,1),(80,1),(81,1),(86,1),(87,1),(88,1),(89,1),(90,1),(91,1),(92,1),(93,1),(94,1),(95,1),(96,1),(97,1),(98,1),(99,1),(100,1),(101,1),(102,1),(103,1),(104,1),(105,1),(105,4),(106,5),(107,1),(107,4),(108,5),(109,1),(109,4),(110,5),(111,1),(111,4),(112,5),(113,1),(113,4),(114,5),(115,1),(115,4),(116,5),(117,1),(117,4),(118,5),(119,1),(119,4),(120,5),(121,1),(121,4),(122,5),(123,1),(123,4),(124,5),(125,1),(126,1),(127,1),(128,1),(129,1),(130,1),(131,1),(132,1),(133,1),(134,1),(135,1),(136,1),(137,1),(138,1),(139,1),(140,1),(141,1),(142,1),(143,1),(144,1),(145,1),(146,1),(147,1),(148,1),(149,1),(150,1),(151,1),(152,1),(153,1),(154,1),(155,1),(156,1),(157,1),(158,1),(159,1),(160,1),(161,1),(162,1),(163,1),(164,6),(164,7),(165,6),(166,6),(166,7),(167,6),(167,8),(168,6),(169,6),(170,6),(171,6),(172,6),(172,8),(173,6),(173,8),(174,6),(174,8),(175,6),(175,8),(176,6),(176,8),(177,6),(177,8),(178,6),(179,6),(180,6),(181,6),(182,6),(183,6),(184,6),(185,6),(186,6),(187,6),(188,6),(189,6),(190,6),(191,6),(192,1),(193,6),(193,7),(194,1),(195,6),(195,7),(196,1),(197,6),(197,7),(198,1),(199,6),(200,1),(201,6),(202,1),(203,6),(203,7),(204,1),(205,6),(206,1),(207,6),(207,7),(208,1),(209,6),(210,1),(211,6),(211,7),(212,1),(213,6),(214,1),(215,6),(216,1),(217,6),(218,1),(219,6),(220,1),(221,6),(222,1),(223,6),(224,1),(225,6),(226,1),(227,6),(228,1),(229,6),(230,1),(231,6),(232,1),(233,6),(234,1),(235,6),(236,1),(237,6),(238,1),(239,6),(240,1),(241,6),(242,1),(243,6),(244,1),(245,6),(246,1),(247,6),(248,1),(249,6),(250,1),(251,6),(252,1),(253,6),(254,1),(255,6),(256,1),(257,6),(258,1),(259,6),(260,1),(261,6),(262,1),(263,6),(264,1),(265,6),(266,1),(267,6),(268,1),(269,6),(270,1),(271,6),(272,1),(273,6),(274,1),(275,6),(276,1),(277,6),(278,1),(279,6),(279,7),(280,1),(281,6),(281,7),(282,1),(283,6),(283,7),(284,1),(285,6),(286,1),(287,6),(288,1),(289,6),(290,1),(291,6),(292,1),(293,6),(294,1),(295,6),(296,1),(297,6),(298,1),(299,6),(300,1),(301,6),(302,1),(303,6),(304,1),(305,6),(306,1),(307,6),(308,1),(309,6),(310,1),(311,6),(312,1),(313,6),(314,1),(315,6),(316,1),(317,1),(319,1),(320,1);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL DEFAULT 'web',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `roles_nombre_unique` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'superadmin','web','2025-05-31 03:49:45','2025-05-31 03:49:45'),(2,'admin','web','2025-05-31 03:49:45','2025-05-31 03:49:45'),(3,'vendedor','web','2025-05-31 03:49:45','2025-05-31 03:49:45'),(4,'motorizado','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(5,'motorizado-app','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(6,'Contador','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(7,'Cajero','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(8,'Compras','api','2025-10-28 08:31:23','2025-10-28 08:31:23');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secciones`
--

DROP TABLE IF EXISTS `secciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `secciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secciones`
--

LOCK TABLES `secciones` WRITE;
/*!40000 ALTER TABLE `secciones` DISABLE KEYS */;
INSERT INTO `secciones` VALUES (1,'Hardware',NULL,'2025-07-14 09:25:58','2025-09-29 15:37:51'),(2,'Laptos',NULL,'2025-07-16 17:42:54','2025-07-16 17:42:54'),(3,'Periféricos','Gaming','2025-09-29 15:31:29','2025-09-29 15:31:29');
/*!40000 ALTER TABLE `secciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `series_comprobantes`
--

DROP TABLE IF EXISTS `series_comprobantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `series_comprobantes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_comprobante` varchar(2) NOT NULL COMMENT '01=Factura, 03=Boleta, 07=Nota Crédito, 08=Nota Débito',
  `serie` varchar(4) NOT NULL,
  `correlativo` int(10) unsigned NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `sede_id` bigint(20) unsigned DEFAULT NULL,
  `caja_id` bigint(20) unsigned DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_tipo_serie` (`tipo_comprobante`,`serie`) USING BTREE,
  KEY `idx_tipo_comprobante` (`tipo_comprobante`) USING BTREE,
  KEY `idx_activo` (`activo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `series_comprobantes`
--

LOCK TABLES `series_comprobantes` WRITE;
/*!40000 ALTER TABLE `series_comprobantes` DISABLE KEYS */;
INSERT INTO `series_comprobantes` VALUES (1,'01','F001',67,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-11-14 22:14:23'),(2,'03','B001',81,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-11-14 23:45:09'),(3,'07','FC01',10,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-11-15 14:51:01'),(4,'07','BC01',0,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(5,'08','FD01',3,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-11-12 22:18:39'),(6,'08','BD01',0,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(7,'09','T001',18,1,NULL,NULL,'Serie por defecto Guía de Remisión','2025-10-17 18:19:58','2025-11-03 14:56:36');
/*!40000 ALTER TABLE `series_comprobantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sessions_user_id_index` (`user_id`) USING BTREE,
  KEY `sessions_last_activity_index` (`last_activity`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('1LakjvIoEYWSdlIsdrqSamrEC7sQ5jd0iagBkW4a',NULL,'38.56.216.90','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUZkdlR1WVNycTc5aktXUzdTZXZxSlZ2S2ptempxazY1cGF5OWJLeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMURZbTRjYk8xT0lkUWdIZVpmTWZZUFZPX1JfY1BaRDFmZ0NwZzM3N05CZ29BSWZhZmE1V0lBMnNUbFRTQ0pET1EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPXdyRGtLUzNGVkZtMHp5QlJDMTZnbldpREJaWmtlTzFRWUl3cUJBN1MiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759008427),('9zCeAJmTofdnjvQRMyHzoIqyXeyXQosTu0owcLT8',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMVRDV0c4elVDWW5iRkdSNUNkbW9YcEFOV1VxZ0VuU3JocTIyRHgzMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUJJRVd3Wm1vRV9MSlpwUzBVZmJCSjU5a083M1E2YlctTUx1dEU4LTNrUERsWHNBSnNrZjRZemxzbUVfczdRT1EmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPXltWnZxVU5qQjcyUzVPendnUGI0N01Tcno5S1lqcUpyY3ZaNXUyOFkiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759026506),('ByVvLUZbWaKcWrwySxu2Vsrk24LGtmghrv5P16gr',NULL,'38.255.107.234','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiV0xwWnNES0QzSkt1RFdvMUR0elZVZ2tSaVlCR29FTk5IYklXVXFNYSI7czo1OiJzdGF0ZSI7czo0MDoiSkZiazVKMXFsSnFTUURZTmhFU0VhTDFINE9kWHJsbDVzRVlIQjlCVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996334),('doYLp8T61tvOXzFZHMxVCprnZAoat8OYC0liEpQh',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkVpVHZzYXRUdzRRM3ZwZjVpSHp2NmxuMFJvVHFWNjdNRUJMRWhiSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFlYzZRVEtheWo3N1ZLa09mSWp6WksxNTVWNThsclNGcmJ4T3hyZnAwbUZRcnNJc1VnQzNLV3h1NUw0allDN2cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJnN0YXRlPWg1Z1B2V1RzNmE0QjZzUkJQOE81SUh1NXNPcG1jZmVmMkx3TE9SMm4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996818),('dPiVDdyuGYY4XSuy7Va6N6SBusfdV3gxLzqosrvF',NULL,'190.232.29.255','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibDhmVFBKUUNxN0JYNmhSa2cxUkdQVWdxbjJtNDEyZDVXN0F6aUliaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUJmcWs1Z3pzMnRYcnVVWG1wUUY2YXJoUHhiNEZBS1pFTXM1UENUWG4zVDVNaVUtTTJuUUNaZFZ5OGdDTC1feVEmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPVBsOG1LTk5JR2FiQ0VSWmxGbTUwSlplODFHWjY2MldxQlU2Q1BxWEoiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759004377),('DrBz18XbrY8CEtVUQKlAMdzlBtZoRWqj8bBeR3Nm',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTlc2OGxSUDUxOUN5Z0k0WjJPdkFRbFJJY1FDMzhpSkdNR2w5YnE4QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTB3UnI2azJLd1gtcmpNNncxZ0RPU0Y0Y1NRRGNhVVVIQWt6cFVTdjU1SmNWQXlsbEdvOERONC11Ni0yVm1sdWcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJTIwb3BlbmlkJnN0YXRlPXRIRDVKbzRUR3dnQ3Y3NjRrME1WMENndEhIdVd0dVZYVFN3ZjlxNEYiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764114242),('fyv3Ho4sELpQ2pSyLlCIvvyO3D6pumK0LumoMoeL',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoieUdSSXMxVWhQbVVrRVd6cDZFRklpZTltQmVsSFRQREt3M0Ridk5VMiI7czo1OiJzdGF0ZSI7czo0MDoiVlZURDVLUHpoMDZZYVBRTlpGWUl6UUlKTnV4d21sbExDRExmMWRQWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996321),('HhqyzQaRuzxK4RBPFaZVMFMjnYHwKFcz3VprVwWi',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUxibjdzWEdOb2RZWnBLN1dSN0gySXg3SGw3TUFuMk1reGlpbFN4aCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTJpWW5mRDdHeXExVGNJMG9WMmRuUVhXV21sSDlBNW5fSkNwMjZYM19jM3VRQmVHTmk2dWRpc0dpS21oeHVEZ2cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPWdBS00zMGVoRkpJRTNqMXpFQ055SDZwd3FCcE9jQ3kya0xzYVp6bGwiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763995181),('hPCeRiEUWSCR29c6sGhyrytv2mdiJI19ac0doPx8',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiV2RNOWoxT1ZXYUxuSnllaDZDYnBHaWhhY25oMDFsZVFoMHR6WnpWaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTEmY29kZT00JTJGMEFiMzJqOTFNdTAtV1ZSY1VrT2pSRks3SlBTUkZEYkFIamtVTmxsSE5xSnNoNHVYdkVOdi0zMjN3TGxaS01lZzh5dUJRR2cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJTIwb3BlbmlkJnN0YXRlPWs2SlRROVZsd2VUQnp5WHkxTnB4eGw1RERoMzExbUkyakFjdnlnTFciO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762276140),('HUmbMiyiWdFVw1mEvbfYSK73ppda9M9cpH3fuClt',NULL,'38.255.107.170','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiV01zUkk1UlhTM2FVekIxakg4NUZJdmw0cFBSd2tHdW8xRDJBRE4xbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762286175),('j3LC4WVweuzKqvCXGzxyf9MW7uaXkRAYCTbiaIY2',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTFBCY0NtQlY1U1I1QlpEVEw0SjZweEVYMHFrQXFaaWFac0xxRGtLZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTEmY29kZT00JTJGMEFiMzJqOTFUUmYzTVhGV1cybzRIekpGMlRGM2xfcG85U1dmbXhTRFM0QW9sODFmQ0l3QlR3TDctb05IenBZTUpKMElQWHcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPW5zVDlwWGszamFsc3p3RU1yQXNPNmdKd0hncGFkSkdCWUZucldHYUYiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762293020),('LCZqaYXCGkLCjVVPgJ8D9toOelQ1GGORY1DOPIfC',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoidXprbHhzRmhUTmJtQXFDNExvR1E2Nks0SVVDMUFsQ0Mxd2RNRzg5MyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFqTEQ3eEk0T1FuRml5LTNpMkdaMHNuYjRBSVZ5QnNhTjFfTVFGV0QyZlh6dHdpOW1wT190UEdTVkY3YjVhM3cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPUJGcTNvYTQ3NFRTNkxXT1huT2ljTXZFczE2RVV3NWpjbnhnN3JVemQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764245633),('Mt6rzDSViIVcsqHc0uCb2HhebRvK3ye2fdoFaVPL',NULL,'201.230.8.125','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2xHSU1JaVFDYVM2Q0dHdk90Z21ROEpKVm1rb1dvQ1JhVDI0UXo2OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTJ0Vlc4bDVZRUpKblhWN2kyUlZGVW1ITUtrM3Q5azA3LWIyRHBDclZvQVlqcHBMQVJ4ZW9Sbm1MMHNITHJES1EmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPUxXYmI3Rm5RYTU1c3dJV0xPY3pWdUI0MmJxYk0wWXRqRW1WNzhZWnMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764269663),('N8vKMbX1pLAdUbDUshCGahEiO04SNQ3WtsagGBaN',NULL,'38.252.222.61','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiS25kMFB5cG5JQVNsTVhpMTk4MG9vR3NJcmFxNDRGRk9oTVdYdFF4VCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMURPUm1MRHRYMmVLeXFwaGJva3hQR3p4S0lhN3pCOTFaaHVkbkhCbDBZZThoTWl2TE5LT3lSTk15QXlBV0lMQ0EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPTUyR1JybHNTRDhqcUdSazJhbDIyOWxLNTVlTHk1eE0wMUwxSzZiR00iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759024823),('nFpQ62cosXeDetMKytocX5mukueayzPsiEvbSbv3',NULL,'38.25.25.252','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiNFBmSWhWUks3d1hjVXVaN2hTMHRMWDQ2OW4xbjM2QUE1Z0RlVjgwbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFwNUdGTmZvN2l3M1hpWkdvbU1YQkQ4TUY4RFhzUTBwMV84MG40b09IOU04eVFleDQ3bFAtd3loYktIWWpLc3cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPTM3N0I1MWwyOTB6Z25XdmhMSnpFVHo1b2VlNGM0ZW1SQlFNVWlYV00iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762527772),('NLIS3N0H6Gn5UbbS3bPGnXorrh1Nd0T32DMm7zcg',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVmloWFcxWFlnb1pBcTF6ektFUkZKTXFHZHJDdjUzSzV1R0RZS0ZZUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFnaVB5cWZ2Ujd4dl8zLUxNWWFTU0lCN2R2OHJWbTVKLWY0OEZSVUlCRVlaTkt4WU1YLUVsZ1Z6d3hTQjFoWXcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPThxUVN5emNIZGNzUGFTT2hlN05uZFVlN1hSSVdtNXlmMW9mUVJ1ZTEiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764253014),('OejjUu7BMkJ5hlYZwDUkQl2KYni1BS9YIEMmwrOP',NULL,'190.216.191.102','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNW4wWUNYMVcwbUdaOXpGY3dDMlNhRmlPNGUzSUNzVm1FY1M2YnNjaCI7czo1OiJzdGF0ZSI7czo0MDoib2dYeExUV0tSMmh2bUdrMzA3RENTdzVoRE4xcE5OcExOTDlkU05USSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762527773),('sdZtAxnzdKKh4V6XH6N5G65X9PDEvKpxsy9xhM9E',NULL,'38.255.107.170','PostmanRuntime/7.49.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWkN5cDVJSWZFQTEwazNzbzhkMExJcTdtSkd0M3ZhZXdnZDlsck4zMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762286792),('tKAtKYb0i7zshjgpHkWU0yO0ftskbg92I3VXRiux',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTzYwSzFHZnk5NnVBcmRvUlFhVUROSG1qMmpxdHFETDdGVzhzeWh3eCI7czo1OiJzdGF0ZSI7czo0MDoiRnVxM05IMGhyTWlBY09Rdm9nQVhIcTYyYTdyVElRYUhER3RqUWpYUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762292922),('UrzTwtoqmO1dbK8Q487ASjblj2eSpkDK7UxIpNJF',NULL,'38.255.107.234','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibHhaWnJvdmtCM21RbDFVQkQwVlVHSFVHbGdZdlp4Tll4WHluZ0pTMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTF3U3NfamhoQzJpbnJkSnBZQldubGRsWXFEMVQ4UTBESGxHd0ZIc3luVkV4SWtFcHRHX21uN2NRU2xUSUkxLXcmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPURkSXBXN1AxblF5ejl0aWR6eWlpMjBTemM1VGdZaXM3YjNxdkhpNUMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996415),('Vfz10DP7bBn4yQlPJ0ET7rBOq8Z3HSr9iowcOf2t',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOVVwN291WUNQRlBJWVVXcllZOGYwc3dSVUpub2hucjFmRHBEbFlYbiI7czo1OiJzdGF0ZSI7czo0MDoiZlZybEZNa3FPUTF2NklUa0tJa2RIcGdBRzNEdWxDakNUd2R1ZFdMWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759160026),('x1LSwwfc5dj2h2S5R1ExUV9UbB8KOZqM4KBKGS0K',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVJuSzltRDBMczgyT2d5czQ0bkx1NlJ3MjNZbGx3OExQNTdUaVZSQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTEmY29kZT00JTJGMEFiMzJqOTBIaE9TMUh6UHpUSS12YlMwMlVLRXhTX3F5LWxqM2VIU3dMTUtfQkY4WDR4bmJobklGcmxYVmtPQkdHOXRnTmcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPTB2aHRxdWNtajl4MHo0RlZzYlFBYlB4a2NsTWJqZW9WanZWOFdURE4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762357491),('zTdVeNPmGPZNPffukpabPLqhRO2C26wzUq5oG4L3',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiY1ZwM01FUXA0YmRPYXR4UFV3aTVrQWs5NmJwc2tDSElaWlMxazdyViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUN4dkJrWVJCV21EOEd0MUs2MGZHRHFFcjA3TDJLQy0wNThPQmhabU5iOWFLcmhzOVIzS3dCR1ZER2ZkUUVhR0EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPWkyRVp0R0NkM1poWHFXeEM2b29YenlsalFlalA1UmJVY0R5aDJkTW8iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759246465);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sunat_error_codes`
--

DROP TABLE IF EXISTS `sunat_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sunat_error_codes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) NOT NULL,
  `descripcion` text NOT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `solucion_sugerida` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sunat_error_codes_codigo_unique` (`codigo`),
  KEY `sunat_error_codes_codigo_activo_index` (`codigo`,`activo`),
  KEY `sunat_error_codes_categoria_index` (`categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sunat_error_codes`
--

LOCK TABLES `sunat_error_codes` WRITE;
/*!40000 ALTER TABLE `sunat_error_codes` DISABLE KEYS */;
INSERT INTO `sunat_error_codes` VALUES (1,'0100','El sistema no puede responder su solicitud. Intente nuevamente o comuníquese con su Administrador','autenticacion','error',1,'Reintentar la operación o contactar al administrador','2025-10-11 19:05:48','2025-10-11 19:05:48'),(2,'0101','El encabezado de seguridad es incorrecto','autenticacion','error',1,'Verificar la configuración del certificado digital','2025-10-11 19:05:48','2025-10-11 19:05:48'),(3,'0102','Usuario o contraseña incorrectos','autenticacion','error',1,'Verificar las credenciales de acceso a SUNAT','2025-10-11 19:05:48','2025-10-11 19:05:48'),(4,'0103','El Usuario ingresado no existe','autenticacion','error',1,'Verificar que el usuario esté registrado en SUNAT','2025-10-11 19:05:48','2025-10-11 19:05:48'),(5,'0104','La Clave ingresada es incorrecta','autenticacion','error',1,'Verificar la contraseña de acceso','2025-10-11 19:05:48','2025-10-11 19:05:48'),(6,'0105','El Usuario no está activo','autenticacion','error',1,'Contactar a SUNAT para activar el usuario','2025-10-11 19:05:48','2025-10-11 19:05:48'),(7,'0106','El Usuario no es válido','autenticacion','error',1,'Verificar el estado del usuario en SUNAT','2025-10-11 19:05:48','2025-10-11 19:05:48'),(8,'0109','El sistema no puede responder su solicitud. (El servicio de autenticación no está disponible)','autenticacion','error',1,'Reintentar más tarde, el servicio está temporalmente no disponible','2025-10-11 19:05:48','2025-10-11 19:05:48'),(9,'0110','No se pudo obtener la informacion del tipo de usuario','autenticacion','error',1,'Verificar permisos del usuario en SUNAT','2025-10-11 19:05:48','2025-10-11 19:05:48'),(10,'0111','No tiene el perfil para enviar comprobantes electronicos','autenticacion','error',1,'Solicitar habilitación para facturación electrónica','2025-10-11 19:05:48','2025-10-11 19:05:48'),(11,'0112','El usuario debe ser secundario','autenticacion','error',1,'Usar un usuario secundario para esta operación','2025-10-11 19:05:48','2025-10-11 19:05:48'),(12,'0113','El usuario no esta afiliado a Factura Electronica','autenticacion','error',1,'Afiliarse al servicio de facturación electrónica','2025-10-11 19:05:48','2025-10-11 19:05:48'),(13,'0200','No se pudo procesar su solicitud. (Ocurrio un error en el batch)','procesamiento','error',1,'Reintentar el envío del comprobante','2025-10-11 19:05:48','2025-10-11 19:05:48'),(14,'0201','No se pudo procesar su solicitud. (Llego un requerimiento nulo al batch)','procesamiento','error',1,'Verificar que el comprobante tenga datos válidos','2025-10-11 19:05:48','2025-10-11 19:05:48'),(15,'0202','No se pudo procesar su solicitud. (No llego información del archivo ZIP)','procesamiento','error',1,'Verificar la integridad del archivo ZIP','2025-10-11 19:05:48','2025-10-11 19:05:48'),(16,'0203','No se pudo procesar su solicitud. (No se encontro archivos en la informacion del archivo ZIP)','procesamiento','error',1,'Verificar que el ZIP contenga archivos XML','2025-10-11 19:05:48','2025-10-11 19:05:48'),(17,'0204','No se pudo procesar su solicitud. (Este tipo de requerimiento solo acepta 1 archivo)','procesamiento','error',1,'Enviar solo un archivo por solicitud','2025-10-11 19:05:48','2025-10-11 19:05:48'),(18,'0300','No se encontró la raíz documento xml','xml','error',1,'Verificar la estructura del XML','2025-10-11 19:05:48','2025-10-11 19:05:48'),(19,'0301','Elemento raiz del xml no esta definido','xml','error',1,'Verificar el elemento raíz del XML','2025-10-11 19:05:49','2025-10-11 19:05:49'),(20,'0302','Codigo del tipo de comprobante no registrado','xml','error',1,'Verificar el código del tipo de comprobante','2025-10-11 19:05:49','2025-10-11 19:05:49'),(21,'0303','No existe el directorio de schemas','xml','error',1,'Verificar la configuración de schemas','2025-10-11 19:05:49','2025-10-11 19:05:49'),(22,'0304','No existe el archivo de schema','xml','error',1,'Verificar que el schema esté disponible','2025-10-11 19:05:49','2025-10-11 19:05:49'),(23,'0305','El sistema no puede procesar el archivo xml','xml','error',1,'Verificar la validez del XML','2025-10-11 19:05:49','2025-10-11 19:05:49'),(24,'0306','No se puede leer (parsear) el archivo XML','xml','error',1,'Verificar la sintaxis del XML','2025-10-11 19:05:49','2025-10-11 19:05:49'),(25,'0307','No se pudo recuperar la constancia','xml','error',1,'Reintentar la consulta de constancia','2025-10-11 19:05:49','2025-10-11 19:05:49'),(26,'0400','No tiene permiso para enviar casos de pruebas','validacion','error',1,'Solicitar permisos para casos de prueba','2025-10-11 19:05:49','2025-10-11 19:05:49'),(27,'0401','El caso de prueba no existe','validacion','error',1,'Verificar el caso de prueba','2025-10-11 19:05:49','2025-10-11 19:05:49'),(28,'0402','La numeracion o nombre del documento ya ha sido enviado anteriormente','validacion','error',1,'Usar una numeración diferente','2025-10-11 19:05:49','2025-10-11 19:05:49'),(29,'0403','El documento afectado por la nota no existe','validacion','error',1,'Verificar que el documento afectado exista','2025-10-11 19:05:49','2025-10-11 19:05:49'),(30,'0404','El documento afectado por la nota se encuentra rechazado','validacion','error',1,'El documento debe estar aceptado para crear la nota','2025-10-11 19:05:49','2025-10-11 19:05:49'),(31,'0151','El nombre del archivo ZIP es incorrecto','archivo','error',1,'Verificar el nombre del archivo ZIP','2025-10-11 19:05:49','2025-10-11 19:05:49'),(32,'0152','No se puede enviar por este método un archivo de resumen','archivo','error',1,'Usar el método correcto para resúmenes','2025-10-11 19:05:49','2025-10-11 19:05:49'),(33,'0153','No se puede enviar por este método un archivo por lotes','archivo','error',1,'Usar el método correcto para lotes','2025-10-11 19:05:49','2025-10-11 19:05:49'),(34,'0154','El RUC del archivo no corresponde al RUC del usuario o el proveedor no esta autorizado a enviar comprobantes del contribuyente','archivo','error',1,'Verificar el RUC y autorización','2025-10-11 19:05:49','2025-10-11 19:05:49'),(35,'0155','El archivo ZIP esta vacio','archivo','error',1,'Incluir archivos en el ZIP','2025-10-11 19:05:49','2025-10-11 19:05:49'),(36,'0156','El archivo ZIP esta corrupto','archivo','error',1,'Regenerar el archivo ZIP','2025-10-11 19:05:49','2025-10-11 19:05:49'),(37,'0157','El archivo ZIP no contiene comprobantes','archivo','error',1,'Incluir comprobantes en el ZIP','2025-10-11 19:05:49','2025-10-11 19:05:49'),(38,'0158','El archivo ZIP contiene demasiados comprobantes para este tipo de envío','archivo','error',1,'Reducir la cantidad de comprobantes','2025-10-11 19:05:49','2025-10-11 19:05:49'),(39,'0159','El nombre del archivo XML es incorrecto','archivo','error',1,'Verificar el nombre del archivo XML','2025-10-11 19:05:49','2025-10-11 19:05:49'),(40,'0160','El archivo XML esta vacio','archivo','error',1,'Generar contenido para el XML','2025-10-11 19:05:49','2025-10-11 19:05:49'),(41,'0161','El nombre del archivo XML no coincide con el nombre del archivo ZIP','archivo','error',1,'Verificar la coincidencia de nombres','2025-10-11 19:05:49','2025-10-11 19:05:49');
/*!40000 ALTER TABLE `sunat_error_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sunat_logs`
--

DROP TABLE IF EXISTS `sunat_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sunat_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comprobante_id` bigint(20) unsigned NOT NULL,
  `tipo_operacion` varchar(255) NOT NULL DEFAULT 'enviar',
  `estado` varchar(255) DEFAULT NULL,
  `numero_ticket` varchar(255) DEFAULT NULL,
  `xml_enviado` text DEFAULT NULL,
  `xml_respuesta` text DEFAULT NULL,
  `cdr_respuesta` text DEFAULT NULL,
  `hash_firma` varchar(255) DEFAULT NULL,
  `mensaje_sunat` text DEFAULT NULL,
  `errores_sunat` text DEFAULT NULL,
  `detalles_adicionales` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`detalles_adicionales`)),
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `fecha_respuesta` timestamp NULL DEFAULT NULL,
  `tiempo_respuesta_ms` int(11) DEFAULT NULL,
  `ip_origen` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sunat_logs_comprobante_id_index` (`comprobante_id`),
  KEY `sunat_logs_estado_index` (`estado`),
  KEY `sunat_logs_numero_ticket_index` (`numero_ticket`),
  KEY `sunat_logs_fecha_envio_index` (`fecha_envio`),
  KEY `sunat_logs_user_id_index` (`user_id`),
  CONSTRAINT `sunat_logs_comprobante_id_foreign` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sunat_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sunat_logs`
--

LOCK TABLES `sunat_logs` WRITE;
/*!40000 ALTER TABLE `sunat_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `sunat_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiendas`
--

DROP TABLE IF EXISTS `tiendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiendas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') DEFAULT 'ACTIVA',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiendas`
--

LOCK TABLES `tiendas` WRITE;
/*!40000 ALTER TABLE `tiendas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tiendas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_pagos`
--

DROP TABLE IF EXISTS `tipo_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_pagos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL COMMENT 'Ej: Efectivo, Tarjeta, Yape, Plin',
  `codigo` varchar(50) NOT NULL COMMENT 'Ej: efectivo, tarjeta, transferencia, yape, plin',
  `descripcion` text DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL COMMENT 'Clase de icono (phosphor, fontawesome, etc)',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0 COMMENT 'Para ordenar en el frontend',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo` (`codigo`) USING BTREE,
  UNIQUE KEY `tipo_pagos_codigo_unique` (`codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_pagos`
--

LOCK TABLES `tipo_pagos` WRITE;
/*!40000 ALTER TABLE `tipo_pagos` DISABLE KEYS */;
INSERT INTO `tipo_pagos` VALUES (1,'TARJETA','001','VISA',NULL,1,1,'2025-11-27 12:11:52','2025-11-27 12:11:52');
/*!40000 ALTER TABLE `tipo_pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_ofertas`
--

DROP TABLE IF EXISTS `tipos_ofertas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_ofertas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_ofertas`
--

LOCK TABLES `tipos_ofertas` WRITE;
/*!40000 ALTER TABLE `tipos_ofertas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_ofertas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ubigeo_inei`
--

DROP TABLE IF EXISTS `ubigeo_inei`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubigeo_inei` (
  `id_ubigeo` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `departamento` varchar(2) NOT NULL,
  `provincia` varchar(2) NOT NULL,
  `distrito` varchar(2) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`id_ubigeo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2077 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubigeo_inei`
--

LOCK TABLES `ubigeo_inei` WRITE;
/*!40000 ALTER TABLE `ubigeo_inei` DISABLE KEYS */;
INSERT INTO `ubigeo_inei` VALUES (1,'01','00','00','AMAZONAS'),(2,'01','01','00','CHACHAPOYAS'),(3,'01','01','01','CHACHAPOYAS'),(4,'01','01','02','ASUNCION'),(5,'01','01','03','BALSAS'),(6,'01','01','04','CHETO'),(7,'01','01','05','CHILIQUIN'),(8,'01','01','06','CHUQUIBAMBA'),(9,'01','01','07','GRANADA'),(10,'01','01','08','HUANCAS'),(11,'01','01','09','LA JALCA'),(12,'01','01','10','LEIMEBAMBA'),(13,'01','01','11','LEVANTO'),(14,'01','01','12','MAGDALENA'),(15,'01','01','13','MARISCAL CASTILLA'),(16,'01','01','14','MOLINOPAMPA'),(17,'01','01','15','MONTEVIDEO'),(18,'01','01','16','OLLEROS'),(19,'01','01','17','QUINJALCA'),(20,'01','01','18','SAN FRANCISCO DE DAGUAS'),(21,'01','01','19','SAN ISIDRO DE MAINO'),(22,'01','01','20','SOLOCO'),(23,'01','01','21','SONCHE'),(24,'01','02','00','BAGUA'),(25,'01','02','01','BAGUA'),(26,'01','02','02','ARAMANGO'),(27,'01','02','03','COPALLIN'),(28,'01','02','04','EL PARCO'),(29,'01','02','05','IMAZA'),(30,'01','02','06','LA PECA'),(31,'01','03','00','BONGARA'),(32,'01','03','01','JUMBILLA'),(33,'01','03','02','CHISQUILLA'),(34,'01','03','03','CHURUJA'),(35,'01','03','04','COROSHA'),(36,'01','03','05','CUISPES'),(37,'01','03','06','FLORIDA'),(38,'01','03','07','JAZÁN'),(39,'01','03','08','RECTA'),(40,'01','03','09','SAN CARLOS'),(41,'01','03','10','SHIPASBAMBA'),(42,'01','03','11','VALERA'),(43,'01','03','12','YAMBRASBAMBA'),(44,'01','04','00','CONDORCANQUI'),(45,'01','04','01','NIEVA'),(46,'01','04','02','EL CENEPA'),(47,'01','04','03','RIO SANTIAGO'),(48,'01','05','00','LUYA'),(49,'01','05','01','LAMUD'),(50,'01','05','02','CAMPORREDONDO'),(51,'01','05','03','COCABAMBA'),(52,'01','05','04','COLCAMAR'),(53,'01','05','05','CONILA'),(54,'01','05','06','INGUILPATA'),(55,'01','05','07','LONGUITA'),(56,'01','05','08','LONYA CHICO'),(57,'01','05','09','LUYA'),(58,'01','05','10','LUYA VIEJO'),(59,'01','05','11','MARIA'),(60,'01','05','12','OCALLI'),(61,'01','05','13','OCUMAL'),(62,'01','05','14','PISUQUIA'),(63,'01','05','15','PROVIDENCIA'),(64,'01','05','16','SAN CRISTOBAL'),(65,'01','05','17','SAN FRANCISCO DEL YESO'),(66,'01','05','18','SAN JERONIMO'),(67,'01','05','19','SAN JUAN DE LOPECANCHA'),(68,'01','05','20','SANTA CATALINA'),(69,'01','05','21','SANTO TOMAS'),(70,'01','05','22','TINGO'),(71,'01','05','23','TRITA'),(72,'01','06','00','RODRIGUEZ DE MENDOZA'),(73,'01','06','01','SAN NICOLAS'),(74,'01','06','02','CHIRIMOTO'),(75,'01','06','03','COCHAMAL'),(76,'01','06','04','HUAMBO'),(77,'01','06','05','LIMABAMBA'),(78,'01','06','06','LONGAR'),(79,'01','06','07','MARISCAL BENAVIDES'),(80,'01','06','08','MILPUC'),(81,'01','06','09','OMIA'),(82,'01','06','10','SANTA ROSA'),(83,'01','06','11','TOTORA'),(84,'01','06','12','VISTA ALEGRE'),(85,'01','07','00','UTCUBAMBA'),(86,'01','07','01','BAGUA GRANDE'),(87,'01','07','02','CAJARURO'),(88,'01','07','03','CUMBA'),(89,'01','07','04','EL MILAGRO'),(90,'01','07','05','JAMALCA'),(91,'01','07','06','LONYA GRANDE'),(92,'01','07','07','YAMON'),(93,'02','00','00','ANCASH'),(94,'02','01','00','HUARAZ'),(95,'02','01','01','HUARAZ'),(96,'02','01','02','COCHABAMBA'),(97,'02','01','03','COLCABAMBA'),(98,'02','01','04','HUANCHAY'),(99,'02','01','05','INDEPENDENCIA'),(100,'02','01','06','JANGAS'),(101,'02','01','07','LA LIBERTAD'),(102,'02','01','08','OLLEROS'),(103,'02','01','09','PAMPAS'),(104,'02','01','10','PARIACOTO'),(105,'02','01','11','PIRA'),(106,'02','01','12','TARICA'),(107,'02','02','00','AIJA'),(108,'02','02','01','AIJA'),(109,'02','02','02','CORIS'),(110,'02','02','03','HUACLLAN'),(111,'02','02','04','LA MERCED'),(112,'02','02','05','SUCCHA'),(113,'02','03','00','ANTONIO RAYMONDI'),(114,'02','03','01','LLAMELLIN'),(115,'02','03','02','ACZO'),(116,'02','03','03','CHACCHO'),(117,'02','03','04','CHINGAS'),(118,'02','03','05','MIRGAS'),(119,'02','03','06','SAN JUAN DE RONTOY'),(120,'02','04','00','ASUNCION'),(121,'02','04','01','CHACAS'),(122,'02','04','02','ACOCHACA'),(123,'02','05','00','BOLOGNESI'),(124,'02','05','01','CHIQUIAN'),(125,'02','05','02','ABELARDO PARDO LEZAMETA'),(126,'02','05','03','ANTONIO RAYMONDI'),(127,'02','05','04','AQUIA'),(128,'02','05','05','CAJACAY'),(129,'02','05','06','CANIS'),(130,'02','05','07','COLQUIOC'),(131,'02','05','08','HUALLANCA'),(132,'02','05','09','HUASTA'),(133,'02','05','10','HUAYLLACAYAN'),(134,'02','05','11','LA PRIMAVERA'),(135,'02','05','12','MANGAS'),(136,'02','05','13','PACLLON'),(137,'02','05','14','SAN MIGUEL DE CORPANQUI'),(138,'02','05','15','TICLLOS'),(139,'02','06','00','CARHUAZ'),(140,'02','06','01','CARHUAZ'),(141,'02','06','02','ACOPAMPA'),(142,'02','06','03','AMASHCA'),(143,'02','06','04','ANTA'),(144,'02','06','05','ATAQUERO'),(145,'02','06','06','MARCARA'),(146,'02','06','07','PARIAHUANCA'),(147,'02','06','08','SAN MIGUEL DE ACO'),(148,'02','06','09','SHILLA'),(149,'02','06','10','TINCO'),(150,'02','06','11','YUNGAR'),(151,'02','07','00','CARLOS FERMIN FITZCARRALD'),(152,'02','07','01','SAN LUIS'),(153,'02','07','02','SAN NICOLAS'),(154,'02','07','03','YAUYA'),(155,'02','08','00','CASMA'),(156,'02','08','01','CASMA'),(157,'02','08','02','BUENA VISTA ALTA'),(158,'02','08','03','COMANDANTE NOEL'),(159,'02','08','04','YAUTAN'),(160,'02','09','00','CORONGO'),(161,'02','09','01','CORONGO'),(162,'02','09','02','ACO'),(163,'02','09','03','BAMBAS'),(164,'02','09','04','CUSCA'),(165,'02','09','05','LA PAMPA'),(166,'02','09','06','YANAC'),(167,'02','09','07','YUPAN'),(168,'02','10','00','HUARI'),(169,'02','10','01','HUARI'),(170,'02','10','02','ANRA'),(171,'02','10','03','CAJAY'),(172,'02','10','04','CHAVIN DE HUANTAR'),(173,'02','10','05','HUACACHI'),(174,'02','10','06','HUACCHIS'),(175,'02','10','07','HUACHIS'),(176,'02','10','08','HUANTAR'),(177,'02','10','09','MASIN'),(178,'02','10','10','PAUCAS'),(179,'02','10','11','PONTO'),(180,'02','10','12','RAHUAPAMPA'),(181,'02','10','13','RAPAYAN'),(182,'02','10','14','SAN MARCOS'),(183,'02','10','15','SAN PEDRO DE CHANA'),(184,'02','10','16','UCO'),(185,'02','11','00','HUARMEY'),(186,'02','11','01','HUARMEY'),(187,'02','11','02','COCHAPETI'),(188,'02','11','03','CULEBRAS'),(189,'02','11','04','HUAYAN'),(190,'02','11','05','MALVAS'),(191,'02','12','00','HUAYLAS'),(192,'02','12','01','CARAZ'),(193,'02','12','02','HUALLANCA'),(194,'02','12','03','HUATA'),(195,'02','12','04','HUAYLAS'),(196,'02','12','05','MATO'),(197,'02','12','06','PAMPAROMAS'),(198,'02','12','07','PUEBLO LIBRE'),(199,'02','12','08','SANTA CRUZ'),(200,'02','12','09','SANTO TORIBIO'),(201,'02','12','10','YURACMARCA'),(202,'02','13','00','MARISCAL LUZURIAGA'),(203,'02','13','01','PISCOBAMBA'),(204,'02','13','02','CASCA'),(205,'02','13','03','ELEAZAR GUZMAN BARRON'),(206,'02','13','04','FIDEL OLIVAS ESCUDERO'),(207,'02','13','05','LLAMA'),(208,'02','13','06','LLUMPA'),(209,'02','13','07','LUCMA'),(210,'02','13','08','MUSGA'),(211,'02','14','00','OCROS'),(212,'02','14','01','OCROS'),(213,'02','14','02','ACAS'),(214,'02','14','03','CAJAMARQUILLA'),(215,'02','14','04','CARHUAPAMPA'),(216,'02','14','05','COCHAS'),(217,'02','14','06','CONGAS'),(218,'02','14','07','LLIPA'),(219,'02','14','08','SAN CRISTOBAL DE RAJAN'),(220,'02','14','09','SAN PEDRO'),(221,'02','14','10','SANTIAGO DE CHILCAS'),(222,'02','15','00','PALLASCA'),(223,'02','15','01','CABANA'),(224,'02','15','02','BOLOGNESI'),(225,'02','15','03','CONCHUCOS'),(226,'02','15','04','HUACASCHUQUE'),(227,'02','15','05','HUANDOVAL'),(228,'02','15','06','LACABAMBA'),(229,'02','15','07','LLAPO'),(230,'02','15','08','PALLASCA'),(231,'02','15','09','PAMPAS'),(232,'02','15','10','SANTA ROSA'),(233,'02','15','11','TAUCA'),(234,'02','16','00','POMABAMBA'),(235,'02','16','01','POMABAMBA'),(236,'02','16','02','HUAYLLAN'),(237,'02','16','03','PAROBAMBA'),(238,'02','16','04','QUINUABAMBA'),(239,'02','17','00','RECUAY'),(240,'02','17','01','RECUAY'),(241,'02','17','02','CATAC'),(242,'02','17','03','COTAPARACO'),(243,'02','17','04','HUAYLLAPAMPA'),(244,'02','17','05','LLACLLIN'),(245,'02','17','06','MARCA'),(246,'02','17','07','PAMPAS CHICO'),(247,'02','17','08','PARARIN'),(248,'02','17','09','TAPACOCHA'),(249,'02','17','10','TICAPAMPA'),(250,'02','18','00','SANTA'),(251,'02','18','01','CHIMBOTE'),(252,'02','18','02','CACERES DEL PERU'),(253,'02','18','03','COISHCO'),(254,'02','18','04','MACATE'),(255,'02','18','05','MORO'),(256,'02','18','06','NEPEÑA'),(257,'02','18','07','SAMANCO'),(258,'02','18','08','SANTA'),(259,'02','18','09','NUEVO CHIMBOTE'),(260,'02','19','00','SIHUAS'),(261,'02','19','01','SIHUAS'),(262,'02','19','02','ACOBAMBA'),(263,'02','19','03','ALFONSO UGARTE'),(264,'02','19','04','CASHAPAMPA'),(265,'02','19','05','CHINGALPO'),(266,'02','19','06','HUAYLLABAMBA'),(267,'02','19','07','QUICHES'),(268,'02','19','08','RAGASH'),(269,'02','19','09','SAN JUAN'),(270,'02','19','10','SICSIBAMBA'),(271,'02','20','00','YUNGAY'),(272,'02','20','01','YUNGAY'),(273,'02','20','02','CASCAPARA'),(274,'02','20','03','MANCOS'),(275,'02','20','04','MATACOTO'),(276,'02','20','05','QUILLO'),(277,'02','20','06','RANRAHIRCA'),(278,'02','20','07','SHUPLUY'),(279,'02','20','08','YANAMA'),(280,'03','00','00','APURIMAC'),(281,'03','01','00','ABANCAY'),(282,'03','01','01','ABANCAY'),(283,'03','01','02','CHACOCHE'),(284,'03','01','03','CIRCA'),(285,'03','01','04','CURAHUASI'),(286,'03','01','05','HUANIPACA'),(287,'03','01','06','LAMBRAMA'),(288,'03','01','07','PICHIRHUA'),(289,'03','01','08','SAN PEDRO DE CACHORA'),(290,'03','01','09','TAMBURCO'),(291,'03','02','00','ANDAHUAYLAS'),(292,'03','02','01','ANDAHUAYLAS'),(293,'03','02','02','ANDARAPA'),(294,'03','02','03','CHIARA'),(295,'03','02','04','HUANCARAMA'),(296,'03','02','05','HUANCARAY'),(297,'03','02','06','HUAYANA'),(298,'03','02','07','KISHUARA'),(299,'03','02','08','PACOBAMBA'),(300,'03','02','09','PACUCHA'),(301,'03','02','10','PAMPACHIRI'),(302,'03','02','11','POMACOCHA'),(303,'03','02','12','SAN ANTONIO DE CACHI'),(304,'03','02','13','SAN JERONIMO'),(305,'03','02','14','SAN MIGUEL DE CHACCRAMPA'),(306,'03','02','15','SANTA MARIA DE CHICMO'),(307,'03','02','16','TALAVERA'),(308,'03','02','17','TUMAY HUARACA'),(309,'03','02','18','TURPO'),(310,'03','02','19','KAQUIABAMBA'),(311,'03','03','00','ANTABAMBA'),(312,'03','03','01','ANTABAMBA'),(313,'03','03','02','EL ORO'),(314,'03','03','03','HUAQUIRCA'),(315,'03','03','04','JUAN ESPINOZA MEDRANO'),(316,'03','03','05','OROPESA'),(317,'03','03','06','PACHACONAS'),(318,'03','03','07','SABAINO'),(319,'03','04','00','AYMARAES'),(320,'03','04','01','CHALHUANCA'),(321,'03','04','02','CAPAYA'),(322,'03','04','03','CARAYBAMBA'),(323,'03','04','04','CHAPIMARCA'),(324,'03','04','05','COLCABAMBA'),(325,'03','04','06','COTARUSE'),(326,'03','04','07','HUAYLLO'),(327,'03','04','08','JUSTO APU SAHUARAURA'),(328,'03','04','09','LUCRE'),(329,'03','04','10','POCOHUANCA'),(330,'03','04','11','SAN JUAN DE CHACÑA'),(331,'03','04','12','SAÑAYCA'),(332,'03','04','13','SORAYA'),(333,'03','04','14','TAPAIRIHUA'),(334,'03','04','15','TINTAY'),(335,'03','04','16','TORAYA'),(336,'03','04','17','YANACA'),(337,'03','05','00','COTABAMBAS'),(338,'03','05','01','TAMBOBAMBA'),(339,'03','05','02','COTABAMBAS'),(340,'03','05','03','COYLLURQUI'),(341,'03','05','04','HAQUIRA'),(342,'03','05','05','MARA'),(343,'03','05','06','CHALLHUAHUACHO'),(344,'03','06','00','CHINCHEROS'),(345,'03','06','01','CHINCHEROS'),(346,'03','06','02','ANCO-HUALLO'),(347,'03','06','03','COCHARCAS'),(348,'03','06','04','HUACCANA'),(349,'03','06','05','OCOBAMBA'),(350,'03','06','06','ONGOY'),(351,'03','06','07','URANMARCA'),(352,'03','06','08','RANRACANCHA'),(353,'03','07','00','GRAU'),(354,'03','07','01','CHUQUIBAMBILLA'),(355,'03','07','02','CURPAHUASI'),(356,'03','07','03','GAMARRA'),(357,'03','07','04','HUAYLLATI'),(358,'03','07','05','MAMARA'),(359,'03','07','06','MICAELA BASTIDAS'),(360,'03','07','07','PATAYPAMPA'),(361,'03','07','08','PROGRESO'),(362,'03','07','09','SAN ANTONIO'),(363,'03','07','10','SANTA ROSA'),(364,'03','07','11','TURPAY'),(365,'03','07','12','VILCABAMBA'),(366,'03','07','13','VIRUNDO'),(367,'03','07','14','CURASCO'),(368,'04','00','00','AREQUIPA'),(369,'04','01','00','AREQUIPA'),(370,'04','01','01','AREQUIPA'),(371,'04','01','02','ALTO SELVA ALEGRE'),(372,'04','01','03','CAYMA'),(373,'04','01','04','CERRO COLORADO'),(374,'04','01','05','CHARACATO'),(375,'04','01','06','CHIGUATA'),(376,'04','01','07','JACOBO HUNTER'),(377,'04','01','08','LA JOYA'),(378,'04','01','09','MARIANO MELGAR'),(379,'04','01','10','MIRAFLORES'),(380,'04','01','11','MOLLEBAYA'),(381,'04','01','12','PAUCARPATA'),(382,'04','01','13','POCSI'),(383,'04','01','14','POLOBAYA'),(384,'04','01','15','QUEQUEÑA'),(385,'04','01','16','SABANDIA'),(386,'04','01','17','SACHACA'),(387,'04','01','18','SAN JUAN DE SIGUAS'),(388,'04','01','19','SAN JUAN DE TARUCANI'),(389,'04','01','20','SANTA ISABEL DE SIGUAS'),(390,'04','01','21','SANTA RITA DE SIGUAS'),(391,'04','01','22','SOCABAYA'),(392,'04','01','23','TIABAYA'),(393,'04','01','24','UCHUMAYO'),(394,'04','01','25','VITOR'),(395,'04','01','26','YANAHUARA'),(396,'04','01','27','YARABAMBA'),(397,'04','01','28','YURA'),(398,'04','01','29','JOSE LUIS BUSTAMANTE Y RIVERO'),(399,'04','02','00','CAMANA'),(400,'04','02','01','CAMANA'),(401,'04','02','02','JOSE MARIA QUIMPER'),(402,'04','02','03','MARIANO NICOLAS VALCARCEL'),(403,'04','02','04','MARISCAL CACERES'),(404,'04','02','05','NICOLAS DE PIEROLA'),(405,'04','02','06','OCOÑA'),(406,'04','02','07','QUILCA'),(407,'04','02','08','SAMUEL PASTOR'),(408,'04','03','00','CARAVELI'),(409,'04','03','01','CARAVELI'),(410,'04','03','02','ACARI'),(411,'04','03','03','ATICO'),(412,'04','03','04','ATIQUIPA'),(413,'04','03','05','BELLA UNION'),(414,'04','03','06','CAHUACHO'),(415,'04','03','07','CHALA'),(416,'04','03','08','CHAPARRA'),(417,'04','03','09','HUANUHUANU'),(418,'04','03','10','JAQUI'),(419,'04','03','11','LOMAS'),(420,'04','03','12','QUICACHA'),(421,'04','03','13','YAUCA'),(422,'04','04','00','CASTILLA'),(423,'04','04','01','APLAO'),(424,'04','04','02','ANDAGUA'),(425,'04','04','03','AYO'),(426,'04','04','04','CHACHAS'),(427,'04','04','05','CHILCAYMARCA'),(428,'04','04','06','CHOCO'),(429,'04','04','07','HUANCARQUI'),(430,'04','04','08','MACHAGUAY'),(431,'04','04','09','ORCOPAMPA'),(432,'04','04','10','PAMPACOLCA'),(433,'04','04','11','TIPAN'),(434,'04','04','12','UÑON'),(435,'04','04','13','URACA'),(436,'04','04','14','VIRACO'),(437,'04','05','00','CAYLLOMA'),(438,'04','05','01','CHIVAY'),(439,'04','05','02','ACHOMA'),(440,'04','05','03','CABANACONDE'),(441,'04','05','04','CALLALLI'),(442,'04','05','05','CAYLLOMA'),(443,'04','05','06','COPORAQUE'),(444,'04','05','07','HUAMBO'),(445,'04','05','08','HUANCA'),(446,'04','05','09','ICHUPAMPA'),(447,'04','05','10','LARI'),(448,'04','05','11','LLUTA'),(449,'04','05','12','MACA'),(450,'04','05','13','MADRIGAL'),(451,'04','05','14','SAN ANTONIO DE CHUCA'),(452,'04','05','15','SIBAYO'),(453,'04','05','16','TAPAY'),(454,'04','05','17','TISCO'),(455,'04','05','18','TUTI'),(456,'04','05','19','YANQUE'),(457,'04','05','20','MAJES'),(458,'04','06','00','CONDESUYOS'),(459,'04','06','01','CHUQUIBAMBA'),(460,'04','06','02','ANDARAY'),(461,'04','06','03','CAYARANI'),(462,'04','06','04','CHICHAS'),(463,'04','06','05','IRAY'),(464,'04','06','06','RIO GRANDE'),(465,'04','06','07','SALAMANCA'),(466,'04','06','08','YANAQUIHUA'),(467,'04','07','00','ISLAY'),(468,'04','07','01','MOLLENDO'),(469,'04','07','02','COCACHACRA'),(470,'04','07','03','DEAN VALDIVIA'),(471,'04','07','04','ISLAY'),(472,'04','07','05','MEJIA'),(473,'04','07','06','PUNTA DE BOMBON'),(474,'04','08','00','LA UNION'),(475,'04','08','01','COTAHUASI'),(476,'04','08','02','ALCA'),(477,'04','08','03','CHARCANA'),(478,'04','08','04','HUAYNACOTAS'),(479,'04','08','05','PAMPAMARCA'),(480,'04','08','06','PUYCA'),(481,'04','08','07','QUECHUALLA'),(482,'04','08','08','SAYLA'),(483,'04','08','09','TAURIA'),(484,'04','08','10','TOMEPAMPA'),(485,'04','08','11','TORO'),(486,'05','00','00','AYACUCHO'),(487,'05','01','00','HUAMANGA'),(488,'05','01','01','AYACUCHO'),(489,'05','01','02','ACOCRO'),(490,'05','01','03','ACOS VINCHOS'),(491,'05','01','04','CARMEN ALTO'),(492,'05','01','05','CHIARA'),(493,'05','01','06','OCROS'),(494,'05','01','07','PACAYCASA'),(495,'05','01','08','QUINUA'),(496,'05','01','09','SAN JOSE DE TICLLAS'),(497,'05','01','10','SAN JUAN BAUTISTA'),(498,'05','01','11','SANTIAGO DE PISCHA'),(499,'05','01','12','SOCOS'),(500,'05','01','13','TAMBILLO'),(501,'05','01','14','VINCHOS'),(502,'05','01','15','JESÚS NAZARENO'),(503,'05','01','16','ANDRÉS AVELINO CÁCERES DORREGAY'),(504,'05','02','00','CANGALLO'),(505,'05','02','01','CANGALLO'),(506,'05','02','02','CHUSCHI'),(507,'05','02','03','LOS MOROCHUCOS'),(508,'05','02','04','MARIA PARADO DE BELLIDO'),(509,'05','02','05','PARAS'),(510,'05','02','06','TOTOS'),(511,'05','03','00','HUANCA SANCOS'),(512,'05','03','01','SANCOS'),(513,'05','03','02','CARAPO'),(514,'05','03','03','SACSAMARCA'),(515,'05','03','04','SANTIAGO DE LUCANAMARCA'),(516,'05','04','00','HUANTA'),(517,'05','04','01','HUANTA'),(518,'05','04','02','AYAHUANCO'),(519,'05','04','03','HUAMANGUILLA'),(520,'05','04','04','IGUAIN'),(521,'05','04','05','LURICOCHA'),(522,'05','04','06','SANTILLANA'),(523,'05','04','07','SIVIA'),(524,'05','04','08','LLOCHEGUA'),(525,'05','04','09','CANAYRE'),(526,'05','04','10','UCHURACCAY'),(527,'05','04','11','PUCACOLPA'),(528,'05','05','00','LA MAR'),(529,'05','05','01','SAN MIGUEL'),(530,'05','05','02','ANCO'),(531,'05','05','03','AYNA'),(532,'05','05','04','CHILCAS'),(533,'05','05','05','CHUNGUI'),(534,'05','05','06','LUIS CARRANZA'),(535,'05','05','07','SANTA ROSA'),(536,'05','05','08','TAMBO'),(537,'05','05','09','SAMUGARI'),(538,'05','05','10','ANCHIHUAY'),(539,'05','06','00','LUCANAS'),(540,'05','06','01','PUQUIO'),(541,'05','06','02','AUCARA'),(542,'05','06','03','CABANA'),(543,'05','06','04','CARMEN SALCEDO'),(544,'05','06','05','CHAVIÑA'),(545,'05','06','06','CHIPAO'),(546,'05','06','07','HUAC-HUAS'),(547,'05','06','08','LARAMATE'),(548,'05','06','09','LEONCIO PRADO'),(549,'05','06','10','LLAUTA'),(550,'05','06','11','LUCANAS'),(551,'05','06','12','OCAÑA'),(552,'05','06','13','OTOCA'),(553,'05','06','14','SAISA'),(554,'05','06','15','SAN CRISTOBAL'),(555,'05','06','16','SAN JUAN'),(556,'05','06','17','SAN PEDRO'),(557,'05','06','18','SAN PEDRO DE PALCO'),(558,'05','06','19','SANCOS'),(559,'05','06','20','SANTA ANA DE HUAYCAHUACHO'),(560,'05','06','21','SANTA LUCIA'),(561,'05','07','00','PARINACOCHAS'),(562,'05','07','01','CORACORA'),(563,'05','07','02','CHUMPI'),(564,'05','07','03','CORONEL CASTAÑEDA'),(565,'05','07','04','PACAPAUSA'),(566,'05','07','05','PULLO'),(567,'05','07','06','PUYUSCA'),(568,'05','07','07','SAN FRANCISCO DE RAVACAYCO'),(569,'05','07','08','UPAHUACHO'),(570,'05','08','00','PAUCAR DEL SARA SARA'),(571,'05','08','01','PAUSA'),(572,'05','08','02','COLTA'),(573,'05','08','03','CORCULLA'),(574,'05','08','04','LAMPA'),(575,'05','08','05','MARCABAMBA'),(576,'05','08','06','OYOLO'),(577,'05','08','07','PARARCA'),(578,'05','08','08','SAN JAVIER DE ALPABAMBA'),(579,'05','08','09','SAN JOSE DE USHUA'),(580,'05','08','10','SARA SARA'),(581,'05','09','00','SUCRE'),(582,'05','09','01','QUEROBAMBA'),(583,'05','09','02','BELEN'),(584,'05','09','03','CHALCOS'),(585,'05','09','04','CHILCAYOC'),(586,'05','09','05','HUACAÑA'),(587,'05','09','06','MORCOLLA'),(588,'05','09','07','PAICO'),(589,'05','09','08','SAN PEDRO DE LARCAY'),(590,'05','09','09','SAN SALVADOR DE QUIJE'),(591,'05','09','10','SANTIAGO DE PAUCARAY'),(592,'05','09','11','SORAS'),(593,'05','10','00','VICTOR FAJARDO'),(594,'05','10','01','HUANCAPI'),(595,'05','10','02','ALCAMENCA'),(596,'05','10','03','APONGO'),(597,'05','10','04','ASQUIPATA'),(598,'05','10','05','CANARIA'),(599,'05','10','06','CAYARA'),(600,'05','10','07','COLCA'),(601,'05','10','08','HUAMANQUIQUIA'),(602,'05','10','09','HUANCARAYLLA'),(603,'05','10','10','HUAYA'),(604,'05','10','11','SARHUA'),(605,'05','10','12','VILCANCHOS'),(606,'05','11','00','VILCAS HUAMAN'),(607,'05','11','01','VILCAS HUAMAN'),(608,'05','11','02','ACCOMARCA'),(609,'05','11','03','CARHUANCA'),(610,'05','11','04','CONCEPCION'),(611,'05','11','05','HUAMBALPA'),(612,'05','11','06','INDEPENDENCIA'),(613,'05','11','07','SAURAMA'),(614,'05','11','08','VISCHONGO'),(615,'06','00','00','CAJAMARCA'),(616,'06','01','00','CAJAMARCA'),(617,'06','01','01','CAJAMARCA'),(618,'06','01','02','ASUNCION'),(619,'06','01','03','CHETILLA'),(620,'06','01','04','COSPAN'),(621,'06','01','05','ENCAÑADA'),(622,'06','01','06','JESUS'),(623,'06','01','07','LLACANORA'),(624,'06','01','08','LOS BAÑOS DEL INCA'),(625,'06','01','09','MAGDALENA'),(626,'06','01','10','MATARA'),(627,'06','01','11','NAMORA'),(628,'06','01','12','SAN JUAN'),(629,'06','02','00','CAJABAMBA'),(630,'06','02','01','CAJABAMBA'),(631,'06','02','02','CACHACHI'),(632,'06','02','03','CONDEBAMBA'),(633,'06','02','04','SITACOCHA'),(634,'06','03','00','CELENDIN'),(635,'06','03','01','CELENDIN'),(636,'06','03','02','CHUMUCH'),(637,'06','03','03','CORTEGANA'),(638,'06','03','04','HUASMIN'),(639,'06','03','05','JORGE CHAVEZ'),(640,'06','03','06','JOSE GALVEZ'),(641,'06','03','07','MIGUEL IGLESIAS'),(642,'06','03','08','OXAMARCA'),(643,'06','03','09','SOROCHUCO'),(644,'06','03','10','SUCRE'),(645,'06','03','11','UTCO'),(646,'06','03','12','LA LIBERTAD DE PALLAN'),(647,'06','04','00','CHOTA'),(648,'06','04','01','CHOTA'),(649,'06','04','02','ANGUIA'),(650,'06','04','03','CHADIN'),(651,'06','04','04','CHIGUIRIP'),(652,'06','04','05','CHIMBAN'),(653,'06','04','06','CHOROPAMPA'),(654,'06','04','07','COCHABAMBA'),(655,'06','04','08','CONCHAN'),(656,'06','04','09','HUAMBOS'),(657,'06','04','10','LAJAS'),(658,'06','04','11','LLAMA'),(659,'06','04','12','MIRACOSTA'),(660,'06','04','13','PACCHA'),(661,'06','04','14','PION'),(662,'06','04','15','QUEROCOTO'),(663,'06','04','16','SAN JUAN DE LICUPIS'),(664,'06','04','17','TACABAMBA'),(665,'06','04','18','TOCMOCHE'),(666,'06','04','19','CHALAMARCA'),(667,'06','05','00','CONTUMAZA'),(668,'06','05','01','CONTUMAZA'),(669,'06','05','02','CHILETE'),(670,'06','05','03','CUPISNIQUE'),(671,'06','05','04','GUZMANGO'),(672,'06','05','05','SAN BENITO'),(673,'06','05','06','SANTA CRUZ DE TOLED'),(674,'06','05','07','TANTARICA'),(675,'06','05','08','YONAN'),(676,'06','06','00','CUTERVO'),(677,'06','06','01','CUTERVO'),(678,'06','06','02','CALLAYUC'),(679,'06','06','03','CHOROS'),(680,'06','06','04','CUJILLO'),(681,'06','06','05','LA RAMADA'),(682,'06','06','06','PIMPINGOS'),(683,'06','06','07','QUEROCOTILLO'),(684,'06','06','08','SAN ANDRES DE CUTERVO'),(685,'06','06','09','SAN JUAN DE CUTERVO'),(686,'06','06','10','SAN LUIS DE LUCMA'),(687,'06','06','11','SANTA CRUZ'),(688,'06','06','12','SANTO DOMINGO DE LA CAPILLA'),(689,'06','06','13','SANTO TOMAS'),(690,'06','06','14','SOCOTA'),(691,'06','06','15','TORIBIO CASANOVA'),(692,'06','07','00','HUALGAYOC'),(693,'06','07','01','BAMBAMARCA'),(694,'06','07','02','CHUGUR'),(695,'06','07','03','HUALGAYOC'),(696,'06','08','00','JAEN'),(697,'06','08','01','JAEN'),(698,'06','08','02','BELLAVISTA'),(699,'06','08','03','CHONTALI'),(700,'06','08','04','COLASAY'),(701,'06','08','05','HUABAL'),(702,'06','08','06','LAS PIRIAS'),(703,'06','08','07','POMAHUACA'),(704,'06','08','08','PUCARA'),(705,'06','08','09','SALLIQUE'),(706,'06','08','10','SAN FELIPE'),(707,'06','08','11','SAN JOSE DEL ALTO'),(708,'06','08','12','SANTA ROSA'),(709,'06','09','00','SAN IGNACIO'),(710,'06','09','01','SAN IGNACIO'),(711,'06','09','02','CHIRINOS'),(712,'06','09','03','HUARANGO'),(713,'06','09','04','LA COIPA'),(714,'06','09','05','NAMBALLE'),(715,'06','09','06','SAN JOSE DE LOURDES'),(716,'06','09','07','TABACONAS'),(717,'06','10','00','SAN MARCOS'),(718,'06','10','01','PEDRO GALVEZ'),(719,'06','10','02','CHANCAY'),(720,'06','10','03','EDUARDO VILLANUEVA'),(721,'06','10','04','GREGORIO PITA'),(722,'06','10','05','ICHOCAN'),(723,'06','10','06','JOSE MANUEL QUIROZ'),(724,'06','10','07','JOSE SABOGAL'),(725,'06','11','00','SAN MIGUEL'),(726,'06','11','01','SAN MIGUEL'),(727,'06','11','02','BOLIVAR'),(728,'06','11','03','CALQUIS'),(729,'06','11','04','CATILLUC'),(730,'06','11','05','EL PRADO'),(731,'06','11','06','LA FLORIDA'),(732,'06','11','07','LLAPA'),(733,'06','11','08','NANCHOC'),(734,'06','11','09','NIEPOS'),(735,'06','11','10','SAN GREGORIO'),(736,'06','11','11','SAN SILVESTRE DE COCHAN'),(737,'06','11','12','TONGOD'),(738,'06','11','13','UNION AGUA BLANCA'),(739,'06','12','00','SAN PABLO'),(740,'06','12','01','SAN PABLO'),(741,'06','12','02','SAN BERNARDINO'),(742,'06','12','03','SAN LUIS'),(743,'06','12','04','TUMBADEN'),(744,'06','13','00','SANTA CRUZ'),(745,'06','13','01','SANTA CRUZ'),(746,'06','13','02','ANDABAMBA'),(747,'06','13','03','CATACHE'),(748,'06','13','04','CHANCAYBAÑOS'),(749,'06','13','05','LA ESPERANZA'),(750,'06','13','06','NINABAMBA'),(751,'06','13','07','PULAN'),(752,'06','13','08','SAUCEPAMPA'),(753,'06','13','09','SEXI'),(754,'06','13','10','UTICYACU'),(755,'06','13','11','YAUYUCAN'),(756,'07','00','00','CALLAO'),(757,'07','01','00','PROV. CONST. DEL CALLAO'),(758,'07','01','01','CALLAO'),(759,'07','01','02','BELLAVISTA'),(760,'07','01','03','CARMEN DE LA LEGUA REYNOSO'),(761,'07','01','04','LA PERLA'),(762,'07','01','05','LA PUNTA'),(763,'07','01','06','VENTANILLA'),(764,'07','01','07','MI PERÚ'),(765,'08','00','00','CUSCO'),(766,'08','01','00','CUSCO'),(767,'08','01','01','CUSCO'),(768,'08','01','02','CCORCA'),(769,'08','01','03','POROY'),(770,'08','01','04','SAN JERONIMO'),(771,'08','01','05','SAN SEBASTIAN'),(772,'08','01','06','SANTIAGO'),(773,'08','01','07','SAYLLA'),(774,'08','01','08','WANCHAQ'),(775,'08','02','00','ACOMAYO'),(776,'08','02','01','ACOMAYO'),(777,'08','02','02','ACOPIA'),(778,'08','02','03','ACOS'),(779,'08','02','04','MOSOC LLACTA'),(780,'08','02','05','POMACANCHI'),(781,'08','02','06','RONDOCAN'),(782,'08','02','07','SANGARARA'),(783,'08','03','00','ANTA'),(784,'08','03','01','ANTA'),(785,'08','03','02','ANCAHUASI'),(786,'08','03','03','CACHIMAYO'),(787,'08','03','04','CHINCHAYPUJIO'),(788,'08','03','05','HUAROCONDO'),(789,'08','03','06','LIMATAMBO'),(790,'08','03','07','MOLLEPATA'),(791,'08','03','08','PUCYURA'),(792,'08','03','09','ZURITE'),(793,'08','04','00','CALCA'),(794,'08','04','01','CALCA'),(795,'08','04','02','COYA'),(796,'08','04','03','LAMAY'),(797,'08','04','04','LARES'),(798,'08','04','05','PISAC'),(799,'08','04','06','SAN SALVADOR'),(800,'08','04','07','TARAY'),(801,'08','04','08','YANATILE'),(802,'08','05','00','CANAS'),(803,'08','05','01','YANAOCA'),(804,'08','05','02','CHECCA'),(805,'08','05','03','KUNTURKANKI'),(806,'08','05','04','LANGUI'),(807,'08','05','05','LAYO'),(808,'08','05','06','PAMPAMARCA'),(809,'08','05','07','QUEHUE'),(810,'08','05','08','TUPAC AMARU'),(811,'08','06','00','CANCHIS'),(812,'08','06','01','SICUANI'),(813,'08','06','02','CHECACUPE'),(814,'08','06','03','COMBAPATA'),(815,'08','06','04','MARANGANI'),(816,'08','06','05','PITUMARCA'),(817,'08','06','06','SAN PABLO'),(818,'08','06','07','SAN PEDRO'),(819,'08','06','08','TINTA'),(820,'08','07','00','CHUMBIVILCAS'),(821,'08','07','01','SANTO TOMAS'),(822,'08','07','02','CAPACMARCA'),(823,'08','07','03','CHAMACA'),(824,'08','07','04','COLQUEMARCA'),(825,'08','07','05','LIVITACA'),(826,'08','07','06','LLUSCO'),(827,'08','07','07','QUIÑOTA'),(828,'08','07','08','VELILLE'),(829,'08','08','00','ESPINAR'),(830,'08','08','01','ESPINAR'),(831,'08','08','02','CONDOROMA'),(832,'08','08','03','COPORAQUE'),(833,'08','08','04','OCORURO'),(834,'08','08','05','PALLPATA'),(835,'08','08','06','PICHIGUA'),(836,'08','08','07','SUYCKUTAMBO'),(837,'08','08','08','ALTO PICHIGUA'),(838,'08','09','00','LA CONVENCION'),(839,'08','09','01','SANTA ANA'),(840,'08','09','02','ECHARATE'),(841,'08','09','03','HUAYOPATA'),(842,'08','09','04','MARANURA'),(843,'08','09','05','OCOBAMBA'),(844,'08','09','06','QUELLOUNO'),(845,'08','09','07','KIMBIRI'),(846,'08','09','08','SANTA TERESA'),(847,'08','09','09','VILCABAMBA'),(848,'08','09','10','PICHARI'),(849,'08','09','11','INKAWASI'),(850,'08','09','12','VILLA VIRGEN'),(851,'08','10','00','PARURO'),(852,'08','10','01','PARURO'),(853,'08','10','02','ACCHA'),(854,'08','10','03','CCAPI'),(855,'08','10','04','COLCHA'),(856,'08','10','05','HUANOQUITE'),(857,'08','10','06','OMACHA'),(858,'08','10','07','PACCARITAMBO'),(859,'08','10','08','PILLPINTO'),(860,'08','10','09','YAURISQUE'),(861,'08','11','00','PAUCARTAMBO'),(862,'08','11','01','PAUCARTAMBO'),(863,'08','11','02','CAICAY'),(864,'08','11','03','CHALLABAMBA'),(865,'08','11','04','COLQUEPATA'),(866,'08','11','05','HUANCARANI'),(867,'08','11','06','KOSÑIPATA'),(868,'08','12','00','QUISPICANCHI'),(869,'08','12','01','URCOS'),(870,'08','12','02','ANDAHUAYLILLAS'),(871,'08','12','03','CAMANTI'),(872,'08','12','04','CCARHUAYO'),(873,'08','12','05','CCATCA'),(874,'08','12','06','CUSIPATA'),(875,'08','12','07','HUARO'),(876,'08','12','08','LUCRE'),(877,'08','12','09','MARCAPATA'),(878,'08','12','10','OCONGATE'),(879,'08','12','11','OROPESA'),(880,'08','12','12','QUIQUIJANA'),(881,'08','13','00','URUBAMBA'),(882,'08','13','01','URUBAMBA'),(883,'08','13','02','CHINCHERO'),(884,'08','13','03','HUAYLLABAMBA'),(885,'08','13','04','MACHUPICCHU'),(886,'08','13','05','MARAS'),(887,'08','13','06','OLLANTAYTAMBO'),(888,'08','13','07','YUCAY'),(889,'09','00','00','HUANCAVELICA'),(890,'09','01','00','HUANCAVELICA'),(891,'09','01','01','HUANCAVELICA'),(892,'09','01','02','ACOBAMBILLA'),(893,'09','01','03','ACORIA'),(894,'09','01','04','CONAYCA'),(895,'09','01','05','CUENCA'),(896,'09','01','06','HUACHOCOLPA'),(897,'09','01','07','HUAYLLAHUARA'),(898,'09','01','08','IZCUCHACA'),(899,'09','01','09','LARIA'),(900,'09','01','10','MANTA'),(901,'09','01','11','MARISCAL CACERES'),(902,'09','01','12','MOYA'),(903,'09','01','13','NUEVO OCCORO'),(904,'09','01','14','PALCA'),(905,'09','01','15','PILCHACA'),(906,'09','01','16','VILCA'),(907,'09','01','17','YAULI'),(908,'09','01','18','ASCENSIÓN'),(909,'09','01','19','HUANDO'),(910,'09','02','00','ACOBAMBA'),(911,'09','02','01','ACOBAMBA'),(912,'09','02','02','ANDABAMBA'),(913,'09','02','03','ANTA'),(914,'09','02','04','CAJA'),(915,'09','02','05','MARCAS'),(916,'09','02','06','PAUCARA'),(917,'09','02','07','POMACOCHA'),(918,'09','02','08','ROSARIO'),(919,'09','03','00','ANGARAES'),(920,'09','03','01','LIRCAY'),(921,'09','03','02','ANCHONGA'),(922,'09','03','03','CALLANMARCA'),(923,'09','03','04','CCOCHACCASA'),(924,'09','03','05','CHINCHO'),(925,'09','03','06','CONGALLA'),(926,'09','03','07','HUANCA-HUANCA'),(927,'09','03','08','HUAYLLAY GRANDE'),(928,'09','03','09','JULCAMARCA'),(929,'09','03','10','SAN ANTONIO DE ANTAPARCO'),(930,'09','03','11','SANTO TOMAS DE PATA'),(931,'09','03','12','SECCLLA'),(932,'09','04','00','CASTROVIRREYNA'),(933,'09','04','01','CASTROVIRREYNA'),(934,'09','04','02','ARMA'),(935,'09','04','03','AURAHUA'),(936,'09','04','04','CAPILLAS'),(937,'09','04','05','CHUPAMARCA'),(938,'09','04','06','COCAS'),(939,'09','04','07','HUACHOS'),(940,'09','04','08','HUAMATAMBO'),(941,'09','04','09','MOLLEPAMPA'),(942,'09','04','10','SAN JUAN'),(943,'09','04','11','SANTA ANA'),(944,'09','04','12','TANTARA'),(945,'09','04','13','TICRAPO'),(946,'09','05','00','CHURCAMPA'),(947,'09','05','01','CHURCAMPA'),(948,'09','05','02','ANCO'),(949,'09','05','03','CHINCHIHUASI'),(950,'09','05','04','EL CARMEN'),(951,'09','05','05','LA MERCED'),(952,'09','05','06','LOCROJA'),(953,'09','05','07','PAUCARBAMBA'),(954,'09','05','08','SAN MIGUEL DE MAYOCC'),(955,'09','05','09','SAN PEDRO DE CORIS'),(956,'09','05','10','PACHAMARCA'),(957,'09','05','11','COSME'),(958,'09','06','00','HUAYTARA'),(959,'09','06','01','HUAYTARA'),(960,'09','06','02','AYAVI'),(961,'09','06','03','CORDOVA'),(962,'09','06','04','HUAYACUNDO ARMA'),(963,'09','06','05','LARAMARCA'),(964,'09','06','06','OCOYO'),(965,'09','06','07','PILPICHACA'),(966,'09','06','08','QUERCO'),(967,'09','06','09','QUITO-ARMA'),(968,'09','06','10','SAN ANTONIO DE CUSICANCHA'),(969,'09','06','11','SAN FRANCISCO DE SANGAYAICO'),(970,'09','06','12','SAN ISIDRO'),(971,'09','06','13','SANTIAGO DE CHOCORVOS'),(972,'09','06','14','SANTIAGO DE QUIRAHUARA'),(973,'09','06','15','SANTO DOMINGO DE CAPILLAS'),(974,'09','06','16','TAMBO'),(975,'09','07','00','TAYACAJA'),(976,'09','07','01','PAMPAS'),(977,'09','07','02','ACOSTAMBO'),(978,'09','07','03','ACRAQUIA'),(979,'09','07','04','AHUAYCHA'),(980,'09','07','05','COLCABAMBA'),(981,'09','07','06','DANIEL HERNANDEZ'),(982,'09','07','07','HUACHOCOLPA'),(983,'09','07','09','HUARIBAMBA'),(984,'09','07','10','ÑAHUIMPUQUIO'),(985,'09','07','11','PAZOS'),(986,'09','07','13','QUISHUAR'),(987,'09','07','14','SALCABAMBA'),(988,'09','07','15','SALCAHUASI'),(989,'09','07','16','SAN MARCOS DE ROCCHAC'),(990,'09','07','17','SURCUBAMBA'),(991,'09','07','18','TINTAY PUNCU'),(992,'10','00','00','HUANUCO'),(993,'10','01','00','HUANUCO'),(994,'10','01','01','HUANUCO'),(995,'10','01','02','AMARILIS'),(996,'10','01','03','CHINCHAO'),(997,'10','01','04','CHURUBAMBA'),(998,'10','01','05','MARGOS'),(999,'10','01','06','QUISQUI'),(1000,'10','01','07','SAN FRANCISCO DE CAYRAN'),(1001,'10','01','08','SAN PEDRO DE CHAULAN'),(1002,'10','01','09','SANTA MARIA DEL VALLE'),(1003,'10','01','10','YARUMAYO'),(1004,'10','01','11','PILLCO MARCA'),(1005,'10','01','12','YACUS'),(1006,'10','02','00','AMBO'),(1007,'10','02','01','AMBO'),(1008,'10','02','02','CAYNA'),(1009,'10','02','03','COLPAS'),(1010,'10','02','04','CONCHAMARCA'),(1011,'10','02','05','HUACAR'),(1012,'10','02','06','SAN FRANCISCO'),(1013,'10','02','07','SAN RAFAEL'),(1014,'10','02','08','TOMAY KICHWA'),(1015,'10','03','00','DOS DE MAYO'),(1016,'10','03','01','LA UNION'),(1017,'10','03','07','CHUQUIS'),(1018,'10','03','11','MARIAS'),(1019,'10','03','13','PACHAS'),(1020,'10','03','16','QUIVILLA'),(1021,'10','03','17','RIPAN'),(1022,'10','03','21','SHUNQUI'),(1023,'10','03','22','SILLAPATA'),(1024,'10','03','23','YANAS'),(1025,'10','04','00','HUACAYBAMBA'),(1026,'10','04','01','HUACAYBAMBA'),(1027,'10','04','02','CANCHABAMBA'),(1028,'10','04','03','COCHABAMBA'),(1029,'10','04','04','PINRA'),(1030,'10','05','00','HUAMALIES'),(1031,'10','05','01','LLATA'),(1032,'10','05','02','ARANCAY'),(1033,'10','05','03','CHAVIN DE PARIARCA'),(1034,'10','05','04','JACAS GRANDE'),(1035,'10','05','05','JIRCAN'),(1036,'10','05','06','MIRAFLORES'),(1037,'10','05','07','MONZON'),(1038,'10','05','08','PUNCHAO'),(1039,'10','05','09','PUÑOS'),(1040,'10','05','10','SINGA'),(1041,'10','05','11','TANTAMAYO'),(1042,'10','06','00','LEONCIO PRADO'),(1043,'10','06','01','RUPA-RUPA'),(1044,'10','06','02','DANIEL ALOMIAS ROBLES'),(1045,'10','06','03','HERMILIO VALDIZAN'),(1046,'10','06','04','JOSE CRESPO Y CASTILLO'),(1047,'10','06','05','LUYANDO'),(1048,'10','06','06','MARIANO DAMASO BERAUN'),(1049,'10','07','00','MARAÑON'),(1050,'10','07','01','HUACRACHUCO'),(1051,'10','07','02','CHOLON'),(1052,'10','07','03','SAN BUENAVENTURA'),(1053,'10','08','00','PACHITEA'),(1054,'10','08','01','PANAO'),(1055,'10','08','02','CHAGLLA'),(1056,'10','08','03','MOLINO'),(1057,'10','08','04','UMARI'),(1058,'10','09','00','PUERTO INCA'),(1059,'10','09','01','PUERTO INCA'),(1060,'10','09','02','CODO DEL POZUZO'),(1061,'10','09','03','HONORIA'),(1062,'10','09','04','TOURNAVISTA'),(1063,'10','09','05','YUYAPICHIS'),(1064,'10','10','00','LAURICOCHA'),(1065,'10','10','01','JESUS'),(1066,'10','10','02','BAÑOS'),(1067,'10','10','03','JIVIA'),(1068,'10','10','04','QUEROPALCA'),(1069,'10','10','05','RONDOS'),(1070,'10','10','06','SAN FRANCISCO DE ASIS'),(1071,'10','10','07','SAN MIGUEL DE CAURI'),(1072,'10','11','00','YAROWILCA'),(1073,'10','11','01','CHAVINILLO'),(1074,'10','11','02','CAHUAC'),(1075,'10','11','03','CHACABAMBA'),(1076,'10','11','04','CHUPAN'),(1077,'10','11','05','JACAS CHICO'),(1078,'10','11','06','OBAS'),(1079,'10','11','07','PAMPAMARCA'),(1080,'10','11','08','CHORAS'),(1081,'11','00','00','ICA'),(1082,'11','01','00','ICA'),(1083,'11','01','01','ICA'),(1084,'11','01','02','LA TINGUIÑA'),(1085,'11','01','03','LOS AQUIJES'),(1086,'11','01','04','OCUCAJE'),(1087,'11','01','05','PACHACUTEC'),(1088,'11','01','06','PARCONA'),(1089,'11','01','07','PUEBLO NUEVO'),(1090,'11','01','08','SALAS'),(1091,'11','01','09','SAN JOSE DE LOS MOLINOS'),(1092,'11','01','10','SAN JUAN BAUTISTA'),(1093,'11','01','11','SANTIAGO'),(1094,'11','01','12','SUBTANJALLA'),(1095,'11','01','13','TATE'),(1096,'11','01','14','YAUCA DEL ROSARIO'),(1097,'11','02','00','CHINCHA'),(1098,'11','02','01','CHINCHA ALTA'),(1099,'11','02','02','ALTO LARAN'),(1100,'11','02','03','CHAVIN'),(1101,'11','02','04','CHINCHA BAJA'),(1102,'11','02','05','EL CARMEN'),(1103,'11','02','06','GROCIO PRADO'),(1104,'11','02','07','PUEBLO NUEVO'),(1105,'11','02','08','SAN JUAN DE YANAC'),(1106,'11','02','09','SAN PEDRO DE HUACARPANA'),(1107,'11','02','10','SUNAMPE'),(1108,'11','02','11','TAMBO DE MORA'),(1109,'11','03','00','NAZCA'),(1110,'11','03','01','NAZCA'),(1111,'11','03','02','CHANGUILLO'),(1112,'11','03','03','EL INGENIO'),(1113,'11','03','04','MARCONA'),(1114,'11','03','05','VISTA ALEGRE'),(1115,'11','04','00','PALPA'),(1116,'11','04','01','PALPA'),(1117,'11','04','02','LLIPATA'),(1118,'11','04','03','RIO GRANDE'),(1119,'11','04','04','SANTA CRUZ'),(1120,'11','04','05','TIBILLO'),(1121,'11','05','00','PISCO'),(1122,'11','05','01','PISCO'),(1123,'11','05','02','HUANCANO'),(1124,'11','05','03','HUMAY'),(1125,'11','05','04','INDEPENDENCIA'),(1126,'11','05','05','PARACAS'),(1127,'11','05','06','SAN ANDRES'),(1128,'11','05','07','SAN CLEMENTE'),(1129,'11','05','08','TUPAC AMARU INCA'),(1130,'12','00','00','JUNIN'),(1131,'12','01','00','HUANCAYO'),(1132,'12','01','01','HUANCAYO'),(1133,'12','01','04','CARHUACALLANGA'),(1134,'12','01','05','CHACAPAMPA'),(1135,'12','01','06','CHICCHE'),(1136,'12','01','07','CHILCA'),(1137,'12','01','08','CHONGOS ALTO'),(1138,'12','01','11','CHUPURO'),(1139,'12','01','12','COLCA'),(1140,'12','01','13','CULLHUAS'),(1141,'12','01','14','EL TAMBO'),(1142,'12','01','16','HUACRAPUQUIO'),(1143,'12','01','17','HUALHUAS'),(1144,'12','01','19','HUANCAN'),(1145,'12','01','20','HUASICANCHA'),(1146,'12','01','21','HUAYUCACHI'),(1147,'12','01','22','INGENIO'),(1148,'12','01','24','PARIAHUANCA'),(1149,'12','01','25','PILCOMAYO'),(1150,'12','01','26','PUCARA'),(1151,'12','01','27','QUICHUAY'),(1152,'12','01','28','QUILCAS'),(1153,'12','01','29','SAN AGUSTIN'),(1154,'12','01','30','SAN JERONIMO DE TUNAN'),(1155,'12','01','32','SAÑO'),(1156,'12','01','33','SAPALLANGA'),(1157,'12','01','34','SICAYA'),(1158,'12','01','35','SANTO DOMINGO DE ACOBAMBA'),(1159,'12','01','36','VIQUES'),(1160,'12','02','00','CONCEPCION'),(1161,'12','02','01','CONCEPCION'),(1162,'12','02','02','ACO'),(1163,'12','02','03','ANDAMARCA'),(1164,'12','02','04','CHAMBARA'),(1165,'12','02','05','COCHAS'),(1166,'12','02','06','COMAS'),(1167,'12','02','07','HEROINAS TOLEDO'),(1168,'12','02','08','MANZANARES'),(1169,'12','02','09','MARISCAL CASTILLA'),(1170,'12','02','10','MATAHUASI'),(1171,'12','02','11','MITO'),(1172,'12','02','12','NUEVE DE JULIO'),(1173,'12','02','13','ORCOTUNA'),(1174,'12','02','14','SAN JOSE DE QUERO'),(1175,'12','02','15','SANTA ROSA DE OCOPA'),(1176,'12','03','00','CHANCHAMAYO'),(1177,'12','03','01','CHANCHAMAYO'),(1178,'12','03','02','PERENE'),(1179,'12','03','03','PICHANAQUI'),(1180,'12','03','04','SAN LUIS DE SHUARO'),(1181,'12','03','05','SAN RAMON'),(1182,'12','03','06','VITOC'),(1183,'12','04','00','JAUJA'),(1184,'12','04','01','JAUJA'),(1185,'12','04','02','ACOLLA'),(1186,'12','04','03','APATA'),(1187,'12','04','04','ATAURA'),(1188,'12','04','05','CANCHAYLLO'),(1189,'12','04','06','CURICACA'),(1190,'12','04','07','EL MANTARO'),(1191,'12','04','08','HUAMALI'),(1192,'12','04','09','HUARIPAMPA'),(1193,'12','04','10','HUERTAS'),(1194,'12','04','11','JANJAILLO'),(1195,'12','04','12','JULCAN'),(1196,'12','04','13','LEONOR ORDOÑEZ'),(1197,'12','04','14','LLOCLLAPAMPA'),(1198,'12','04','15','MARCO'),(1199,'12','04','16','MASMA'),(1200,'12','04','17','MASMA CHICCHE'),(1201,'12','04','18','MOLINOS'),(1202,'12','04','19','MONOBAMBA'),(1203,'12','04','20','MUQUI'),(1204,'12','04','21','MUQUIYAUYO'),(1205,'12','04','22','PACA'),(1206,'12','04','23','PACCHA'),(1207,'12','04','24','PANCAN'),(1208,'12','04','25','PARCO'),(1209,'12','04','26','POMACANCHA'),(1210,'12','04','27','RICRAN'),(1211,'12','04','28','SAN LORENZO'),(1212,'12','04','29','SAN PEDRO DE CHUNAN'),(1213,'12','04','30','SAUSA'),(1214,'12','04','31','SINCOS'),(1215,'12','04','32','TUNAN MARCA'),(1216,'12','04','33','YAULI'),(1217,'12','04','34','YAUYOS'),(1218,'12','05','00','JUNIN'),(1219,'12','05','01','JUNIN'),(1220,'12','05','02','CARHUAMAYO'),(1221,'12','05','03','ONDORES'),(1222,'12','05','04','ULCUMAYO'),(1223,'12','06','00','SATIPO'),(1224,'12','06','01','SATIPO'),(1225,'12','06','02','COVIRIALI'),(1226,'12','06','03','LLAYLLA'),(1227,'12','06','04','MAZAMARI'),(1228,'12','06','05','PAMPA HERMOSA'),(1229,'12','06','06','PANGOA'),(1230,'12','06','07','RIO NEGRO'),(1231,'12','06','08','RIO TAMBO'),(1232,'12','06','99','MAZAMARI-PANGOA'),(1233,'12','07','00','TARMA'),(1234,'12','07','01','TARMA'),(1235,'12','07','02','ACOBAMBA'),(1236,'12','07','03','HUARICOLCA'),(1237,'12','07','04','HUASAHUASI'),(1238,'12','07','05','LA UNION'),(1239,'12','07','06','PALCA'),(1240,'12','07','07','PALCAMAYO'),(1241,'12','07','08','SAN PEDRO DE CAJAS'),(1242,'12','07','09','TAPO'),(1243,'12','08','00','YAULI'),(1244,'12','08','01','LA OROYA'),(1245,'12','08','02','CHACAPALPA'),(1246,'12','08','03','HUAY-HUAY'),(1247,'12','08','04','MARCAPOMACOCHA'),(1248,'12','08','05','MOROCOCHA'),(1249,'12','08','06','PACCHA'),(1250,'12','08','07','SANTA BARBARA DE CARHUACAYAN'),(1251,'12','08','08','SANTA ROSA DE SACCO'),(1252,'12','08','09','SUITUCANCHA'),(1253,'12','08','10','YAULI'),(1254,'12','09','00','CHUPACA'),(1255,'12','09','01','CHUPACA'),(1256,'12','09','02','AHUAC'),(1257,'12','09','03','CHONGOS BAJO'),(1258,'12','09','04','HUACHAC'),(1259,'12','09','05','HUAMANCACA CHICO'),(1260,'12','09','06','SAN JUAN DE ISCOS'),(1261,'12','09','07','SAN JUAN DE JARPA'),(1262,'12','09','08','3 DE DICIEMBRE'),(1263,'12','09','09','YANACANCHA'),(1264,'13','00','00','LA LIBERTAD'),(1265,'13','01','00','TRUJILLO'),(1266,'13','01','01','TRUJILLO'),(1267,'13','01','02','EL PORVENIR'),(1268,'13','01','03','FLORENCIA DE MORA'),(1269,'13','01','04','HUANCHACO'),(1270,'13','01','05','LA ESPERANZA'),(1271,'13','01','06','LAREDO'),(1272,'13','01','07','MOCHE'),(1273,'13','01','08','POROTO'),(1274,'13','01','09','SALAVERRY'),(1275,'13','01','10','SIMBAL'),(1276,'13','01','11','VICTOR LARCO HERRERA'),(1277,'13','02','00','ASCOPE'),(1278,'13','02','01','ASCOPE'),(1279,'13','02','02','CHICAMA'),(1280,'13','02','03','CHOCOPE'),(1281,'13','02','04','MAGDALENA DE CAO'),(1282,'13','02','05','PAIJAN'),(1283,'13','02','06','RAZURI'),(1284,'13','02','07','SANTIAGO DE CAO'),(1285,'13','02','08','CASA GRANDE'),(1286,'13','03','00','BOLIVAR'),(1287,'13','03','01','BOLIVAR'),(1288,'13','03','02','BAMBAMARCA'),(1289,'13','03','03','CONDORMARCA'),(1290,'13','03','04','LONGOTEA'),(1291,'13','03','05','UCHUMARCA'),(1292,'13','03','06','UCUNCHA'),(1293,'13','04','00','CHEPEN'),(1294,'13','04','01','CHEPEN'),(1295,'13','04','02','PACANGA'),(1296,'13','04','03','PUEBLO NUEVO'),(1297,'13','05','00','JULCAN'),(1298,'13','05','01','JULCAN'),(1299,'13','05','02','CALAMARCA'),(1300,'13','05','03','CARABAMBA'),(1301,'13','05','04','HUASO'),(1302,'13','06','00','OTUZCO'),(1303,'13','06','01','OTUZCO'),(1304,'13','06','02','AGALLPAMPA'),(1305,'13','06','04','CHARAT'),(1306,'13','06','05','HUARANCHAL'),(1307,'13','06','06','LA CUESTA'),(1308,'13','06','08','MACHE'),(1309,'13','06','10','PARANDAY'),(1310,'13','06','11','SALPO'),(1311,'13','06','13','SINSICAP'),(1312,'13','06','14','USQUIL'),(1313,'13','07','00','PACASMAYO'),(1314,'13','07','01','SAN PEDRO DE LLOC'),(1315,'13','07','02','GUADALUPE'),(1316,'13','07','03','JEQUETEPEQUE'),(1317,'13','07','04','PACASMAYO'),(1318,'13','07','05','SAN JOSE'),(1319,'13','08','00','PATAZ'),(1320,'13','08','01','TAYABAMBA'),(1321,'13','08','02','BULDIBUYO'),(1322,'13','08','03','CHILLIA'),(1323,'13','08','04','HUANCASPATA'),(1324,'13','08','05','HUAYLILLAS'),(1325,'13','08','06','HUAYO'),(1326,'13','08','07','ONGON'),(1327,'13','08','08','PARCOY'),(1328,'13','08','09','PATAZ'),(1329,'13','08','10','PIAS'),(1330,'13','08','11','SANTIAGO DE CHALLAS'),(1331,'13','08','12','TAURIJA'),(1332,'13','08','13','URPAY'),(1333,'13','09','00','SANCHEZ CARRION'),(1334,'13','09','01','HUAMACHUCO'),(1335,'13','09','02','CHUGAY'),(1336,'13','09','03','COCHORCO'),(1337,'13','09','04','CURGOS'),(1338,'13','09','05','MARCABAL'),(1339,'13','09','06','SANAGORAN'),(1340,'13','09','07','SARIN'),(1341,'13','09','08','SARTIMBAMBA'),(1342,'13','10','00','SANTIAGO DE CHUCO'),(1343,'13','10','01','SANTIAGO DE CHUCO'),(1344,'13','10','02','ANGASMARCA'),(1345,'13','10','03','CACHICADAN'),(1346,'13','10','04','MOLLEBAMBA'),(1347,'13','10','05','MOLLEPATA'),(1348,'13','10','06','QUIRUVILCA'),(1349,'13','10','07','SANTA CRUZ DE CHUCA'),(1350,'13','10','08','SITABAMBA'),(1351,'13','11','00','GRAN CHIMU'),(1352,'13','11','01','CASCAS'),(1353,'13','11','02','LUCMA'),(1354,'13','11','03','MARMOT'),(1355,'13','11','04','SAYAPULLO'),(1356,'13','12','00','VIRU'),(1357,'13','12','01','VIRU'),(1358,'13','12','02','CHAO'),(1359,'13','12','03','GUADALUPITO'),(1360,'14','00','00','LAMBAYEQUE'),(1361,'14','01','00','CHICLAYO'),(1362,'14','01','01','CHICLAYO'),(1363,'14','01','02','CHONGOYAPE'),(1364,'14','01','03','ETEN'),(1365,'14','01','04','ETEN PUERTO'),(1366,'14','01','05','JOSE LEONARDO ORTIZ'),(1367,'14','01','06','LA VICTORIA'),(1368,'14','01','07','LAGUNAS'),(1369,'14','01','08','MONSEFU'),(1370,'14','01','09','NUEVA ARICA'),(1371,'14','01','10','OYOTUN'),(1372,'14','01','11','PICSI'),(1373,'14','01','12','PIMENTEL'),(1374,'14','01','13','REQUE'),(1375,'14','01','14','SANTA ROSA'),(1376,'14','01','15','SAÑA'),(1377,'14','01','16','CAYALTÍ'),(1378,'14','01','17','PATAPO'),(1379,'14','01','18','POMALCA'),(1380,'14','01','19','PUCALÁ'),(1381,'14','01','20','TUMÁN'),(1382,'14','02','00','FERREÑAFE'),(1383,'14','02','01','FERREÑAFE'),(1384,'14','02','02','CAÑARIS'),(1385,'14','02','03','INCAHUASI'),(1386,'14','02','04','MANUEL ANTONIO MESONES MURO'),(1387,'14','02','05','PITIPO'),(1388,'14','02','06','PUEBLO NUEVO'),(1389,'14','03','00','LAMBAYEQUE'),(1390,'14','03','01','LAMBAYEQUE'),(1391,'14','03','02','CHOCHOPE'),(1392,'14','03','03','ILLIMO'),(1393,'14','03','04','JAYANCA'),(1394,'14','03','05','MOCHUMI'),(1395,'14','03','06','MORROPE'),(1396,'14','03','07','MOTUPE'),(1397,'14','03','08','OLMOS'),(1398,'14','03','09','PACORA'),(1399,'14','03','10','SALAS'),(1400,'14','03','11','SAN JOSE'),(1401,'14','03','12','TUCUME'),(1402,'15','00','00','LIMA'),(1403,'15','01','00','LIMA'),(1404,'15','01','01','LIMA'),(1405,'15','01','02','ANCON'),(1406,'15','01','03','ATE'),(1407,'15','01','04','BARRANCO'),(1408,'15','01','05','BREÑA'),(1409,'15','01','06','CARABAYLLO'),(1410,'15','01','07','CHACLACAYO'),(1411,'15','01','08','CHORRILLOS'),(1412,'15','01','09','CIENEGUILLA'),(1413,'15','01','10','COMAS'),(1414,'15','01','11','EL AGUSTINO'),(1415,'15','01','12','INDEPENDENCIA'),(1416,'15','01','13','JESUS MARIA'),(1417,'15','01','14','LA MOLINA'),(1418,'15','01','15','LA VICTORIA'),(1419,'15','01','16','LINCE'),(1420,'15','01','17','LOS OLIVOS'),(1421,'15','01','18','LURIGANCHO'),(1422,'15','01','19','LURIN'),(1423,'15','01','20','MAGDALENA DEL MAR'),(1424,'15','01','21','PUEBLO LIBRE MAGDALENA VIEJA'),(1425,'15','01','22','MIRAFLORES'),(1426,'15','01','23','PACHACAMAC'),(1427,'15','01','24','PUCUSANA'),(1428,'15','01','25','PUENTE PIEDRA'),(1429,'15','01','26','PUNTA HERMOSA'),(1430,'15','01','27','PUNTA NEGRA'),(1431,'15','01','28','RIMAC'),(1432,'15','01','29','SAN BARTOLO'),(1433,'15','01','30','SAN BORJA'),(1434,'15','01','31','SAN ISIDRO'),(1435,'15','01','32','SAN JUAN DE LURIGANCHO'),(1436,'15','01','33','SAN JUAN DE MIRAFLORES'),(1437,'15','01','34','SAN LUIS'),(1438,'15','01','35','SAN MARTIN DE PORRES'),(1439,'15','01','36','SAN MIGUEL'),(1440,'15','01','37','SANTA ANITA'),(1441,'15','01','38','SANTA MARIA DEL MAR'),(1442,'15','01','39','SANTA ROSA'),(1443,'15','01','40','SANTIAGO DE SURCO'),(1444,'15','01','41','SURQUILLO'),(1445,'15','01','42','VILLA EL SALVADOR'),(1446,'15','01','43','VILLA MARIA DEL TRIUNFO'),(1447,'15','02','00','BARRANCA'),(1448,'15','02','01','BARRANCA'),(1449,'15','02','02','PARAMONGA'),(1450,'15','02','03','PATIVILCA'),(1451,'15','02','04','SUPE'),(1452,'15','02','05','SUPE PUERTO'),(1453,'15','03','00','CAJATAMBO'),(1454,'15','03','01','CAJATAMBO'),(1455,'15','03','02','COPA'),(1456,'15','03','03','GORGOR'),(1457,'15','03','04','HUANCAPON'),(1458,'15','03','05','MANAS'),(1459,'15','04','00','CANTA'),(1460,'15','04','01','CANTA'),(1461,'15','04','02','ARAHUAY'),(1462,'15','04','03','HUAMANTANGA'),(1463,'15','04','04','HUAROS'),(1464,'15','04','05','LACHAQUI'),(1465,'15','04','06','SAN BUENAVENTURA'),(1466,'15','04','07','SANTA ROSA DE QUIVES'),(1467,'15','05','00','CAÑETE'),(1468,'15','05','01','SAN VICENTE DE CAÑETE'),(1469,'15','05','02','ASIA'),(1470,'15','05','03','CALANGO'),(1471,'15','05','04','CERRO AZUL'),(1472,'15','05','05','CHILCA'),(1473,'15','05','06','COAYLLO'),(1474,'15','05','07','IMPERIAL'),(1475,'15','05','08','LUNAHUANA'),(1476,'15','05','09','MALA'),(1477,'15','05','10','NUEVO IMPERIAL'),(1478,'15','05','11','PACARAN'),(1479,'15','05','12','QUILMANA'),(1480,'15','05','13','SAN ANTONIO'),(1481,'15','05','14','SAN LUIS'),(1482,'15','05','15','SANTA CRUZ DE FLORES'),(1483,'15','05','16','ZUÑIGA'),(1484,'15','06','00','HUARAL'),(1485,'15','06','01','HUARAL'),(1486,'15','06','02','ATAVILLOS ALTO'),(1487,'15','06','03','ATAVILLOS BAJO'),(1488,'15','06','04','AUCALLAMA'),(1489,'15','06','05','CHANCAY'),(1490,'15','06','06','IHUARI'),(1491,'15','06','07','LAMPIAN'),(1492,'15','06','08','PACARAOS'),(1493,'15','06','09','SAN MIGUEL DE ACOS'),(1494,'15','06','10','SANTA CRUZ DE ANDAMARCA'),(1495,'15','06','11','SUMBILCA'),(1496,'15','06','12','VEINTISIETE DE NOVIEMBRE'),(1497,'15','07','00','HUAROCHIRI'),(1498,'15','07','01','MATUCANA'),(1499,'15','07','02','ANTIOQUIA'),(1500,'15','07','03','CALLAHUANCA'),(1501,'15','07','04','CARAMPOMA'),(1502,'15','07','05','CHICLA'),(1503,'15','07','06','CUENCA'),(1504,'15','07','07','HUACHUPAMPA'),(1505,'15','07','08','HUANZA'),(1506,'15','07','09','HUAROCHIRI'),(1507,'15','07','10','LAHUAYTAMBO'),(1508,'15','07','11','LANGA'),(1509,'15','07','12','LARAOS'),(1510,'15','07','13','MARIATANA'),(1511,'15','07','14','RICARDO PALMA'),(1512,'15','07','15','SAN ANDRES DE TUPICOCHA'),(1513,'15','07','16','SAN ANTONIO'),(1514,'15','07','17','SAN BARTOLOME'),(1515,'15','07','18','SAN DAMIAN'),(1516,'15','07','19','SAN JUAN DE IRIS'),(1517,'15','07','20','SAN JUAN DE TANTARANCHE'),(1518,'15','07','21','SAN LORENZO DE QUINTI'),(1519,'15','07','22','SAN MATEO'),(1520,'15','07','23','SAN MATEO DE OTAO'),(1521,'15','07','24','SAN PEDRO DE CASTA'),(1522,'15','07','25','SAN PEDRO DE HUANCAYRE'),(1523,'15','07','26','SANGALLAYA'),(1524,'15','07','27','SANTA CRUZ DE COCACHACRA'),(1525,'15','07','28','SANTA EULALIA'),(1526,'15','07','29','SANTIAGO DE ANCHUCAYA'),(1527,'15','07','30','SANTIAGO DE TUNA'),(1528,'15','07','31','SANTO DOMINGO DE LOS OLLEROS'),(1529,'15','07','32','SURCO'),(1530,'15','08','00','HUAURA'),(1531,'15','08','01','HUACHO'),(1532,'15','08','02','AMBAR'),(1533,'15','08','03','CALETA DE CARQUIN'),(1534,'15','08','04','CHECRAS'),(1535,'15','08','05','HUALMAY'),(1536,'15','08','06','HUAURA'),(1537,'15','08','07','LEONCIO PRADO'),(1538,'15','08','08','PACCHO'),(1539,'15','08','09','SANTA LEONOR'),(1540,'15','08','10','SANTA MARIA'),(1541,'15','08','11','SAYAN'),(1542,'15','08','12','VEGUETA'),(1543,'15','09','00','OYON'),(1544,'15','09','01','OYON'),(1545,'15','09','02','ANDAJES'),(1546,'15','09','03','CAUJUL'),(1547,'15','09','04','COCHAMARCA'),(1548,'15','09','05','NAVAN'),(1549,'15','09','06','PACHANGARA'),(1550,'15','10','00','YAUYOS'),(1551,'15','10','01','YAUYOS'),(1552,'15','10','02','ALIS'),(1553,'15','10','03','AYAUCA'),(1554,'15','10','04','AYAVIRI'),(1555,'15','10','05','AZANGARO'),(1556,'15','10','06','CACRA'),(1557,'15','10','07','CARANIA'),(1558,'15','10','08','CATAHUASI'),(1559,'15','10','09','CHOCOS'),(1560,'15','10','10','COCHAS'),(1561,'15','10','11','COLONIA'),(1562,'15','10','12','HONGOS'),(1563,'15','10','13','HUAMPARA'),(1564,'15','10','14','HUANCAYA'),(1565,'15','10','15','HUANGASCAR'),(1566,'15','10','16','HUANTAN'),(1567,'15','10','17','HUAÑEC'),(1568,'15','10','18','LARAOS'),(1569,'15','10','19','LINCHA'),(1570,'15','10','20','MADEAN'),(1571,'15','10','21','MIRAFLORES'),(1572,'15','10','22','OMAS'),(1573,'15','10','23','PUTINZA'),(1574,'15','10','24','QUINCHES'),(1575,'15','10','25','QUINOCAY'),(1576,'15','10','26','SAN JOAQUIN'),(1577,'15','10','27','SAN PEDRO DE PILAS'),(1578,'15','10','28','TANTA'),(1579,'15','10','29','TAURIPAMPA'),(1580,'15','10','30','TOMAS'),(1581,'15','10','31','TUPE'),(1582,'15','10','32','VIÑAC'),(1583,'15','10','33','VITIS'),(1584,'16','00','00','LORETO'),(1585,'16','01','00','MAYNAS'),(1586,'16','01','01','IQUITOS'),(1587,'16','01','02','ALTO NANAY'),(1588,'16','01','03','FERNANDO LORES'),(1589,'16','01','04','INDIANA'),(1590,'16','01','05','LAS AMAZONAS'),(1591,'16','01','06','MAZAN'),(1592,'16','01','07','NAPO'),(1593,'16','01','08','PUNCHANA'),(1594,'16','01','09','PUTUMAYO'),(1595,'16','01','10','TORRES CAUSANA'),(1596,'16','01','12','BELÉN'),(1597,'16','01','13','SAN JUAN BAUTISTA'),(1598,'16','01','14','TENIENTE MANUEL CLAVERO'),(1599,'16','02','00','ALTO AMAZONAS'),(1600,'16','02','01','YURIMAGUAS'),(1601,'16','02','02','BALSAPUERTO'),(1602,'16','02','05','JEBEROS'),(1603,'16','02','06','LAGUNAS'),(1604,'16','02','10','SANTA CRUZ'),(1605,'16','02','11','TENIENTE CESAR LOPEZ ROJAS'),(1606,'16','03','00','LORETO'),(1607,'16','03','01','NAUTA'),(1608,'16','03','02','PARINARI'),(1609,'16','03','03','TIGRE'),(1610,'16','03','04','TROMPETEROS'),(1611,'16','03','05','URARINAS'),(1612,'16','04','00','MARISCAL RAMON CASTILLA'),(1613,'16','04','01','RAMON CASTILLA'),(1614,'16','04','02','PEBAS'),(1615,'16','04','03','YAVARI'),(1616,'16','04','04','SAN PABLO'),(1617,'16','05','00','REQUENA'),(1618,'16','05','01','REQUENA'),(1619,'16','05','02','ALTO TAPICHE'),(1620,'16','05','03','CAPELO'),(1621,'16','05','04','EMILIO SAN MARTIN'),(1622,'16','05','05','MAQUIA'),(1623,'16','05','06','PUINAHUA'),(1624,'16','05','07','SAQUENA'),(1625,'16','05','08','SOPLIN'),(1626,'16','05','09','TAPICHE'),(1627,'16','05','10','JENARO HERRERA'),(1628,'16','05','11','YAQUERANA'),(1629,'16','06','00','UCAYALI'),(1630,'16','06','01','CONTAMANA'),(1631,'16','06','02','INAHUAYA'),(1632,'16','06','03','PADRE MARQUEZ'),(1633,'16','06','04','PAMPA HERMOSA'),(1634,'16','06','05','SARAYACU'),(1635,'16','06','06','VARGAS GUERRA'),(1636,'16','07','00','DATEM DEL MARAÑÓN'),(1637,'16','07','01','BARRANCA'),(1638,'16','07','02','CAHUAPANAS'),(1639,'16','07','03','MANSERICHE'),(1640,'16','07','04','MORONA'),(1641,'16','07','05','PASTAZA'),(1642,'16','07','06','ANDOAS'),(1643,'16','08','00','PUTUMAYO'),(1644,'16','08','01','PUTUMAYO'),(1645,'16','08','02','ROSA PANDURO'),(1646,'16','08','03','TENIENTE MANUEL CLAVERO'),(1647,'16','08','04','YAGUAS'),(1648,'17','00','00','MADRE DE DIOS'),(1649,'17','01','00','TAMBOPATA'),(1650,'17','01','01','TAMBOPATA'),(1651,'17','01','02','INAMBARI'),(1652,'17','01','03','LAS PIEDRAS'),(1653,'17','01','04','LABERINTO'),(1654,'17','02','00','MANU'),(1655,'17','02','01','MANU'),(1656,'17','02','02','FITZCARRALD'),(1657,'17','02','03','MADRE DE DIOS'),(1658,'17','02','04','HUEPETUHE'),(1659,'17','03','00','TAHUAMANU'),(1660,'17','03','01','IÑAPARI'),(1661,'17','03','02','IBERIA'),(1662,'17','03','03','TAHUAMANU'),(1663,'18','00','00','MOQUEGUA'),(1664,'18','01','00','MARISCAL NIETO'),(1665,'18','01','01','MOQUEGUA'),(1666,'18','01','02','CARUMAS'),(1667,'18','01','03','CUCHUMBAYA'),(1668,'18','01','04','SAMEGUA'),(1669,'18','01','05','SAN CRISTOBAL'),(1670,'18','01','06','TORATA'),(1671,'18','02','00','GENERAL SANCHEZ CERRO'),(1672,'18','02','01','OMATE'),(1673,'18','02','02','CHOJATA'),(1674,'18','02','03','COALAQUE'),(1675,'18','02','04','ICHUÑA'),(1676,'18','02','05','LA CAPILLA'),(1677,'18','02','06','LLOQUE'),(1678,'18','02','07','MATALAQUE'),(1679,'18','02','08','PUQUINA'),(1680,'18','02','09','QUINISTAQUILLAS'),(1681,'18','02','10','UBINAS'),(1682,'18','02','11','YUNGA'),(1683,'18','03','00','ILO'),(1684,'18','03','01','ILO'),(1685,'18','03','02','EL ALGARROBAL'),(1686,'18','03','03','PACOCHA'),(1687,'19','00','00','PASCO'),(1688,'19','01','00','PASCO'),(1689,'19','01','01','CHAUPIMARCA'),(1690,'19','01','02','HUACHON'),(1691,'19','01','03','HUARIACA'),(1692,'19','01','04','HUAYLLAY'),(1693,'19','01','05','NINACACA'),(1694,'19','01','06','PALLANCHACRA'),(1695,'19','01','07','PAUCARTAMBO'),(1696,'19','01','08','SAN FCO. DE ASÍS DE YARUSYACÁN'),(1697,'19','01','09','SIMON BOLIVAR'),(1698,'19','01','10','TICLACAYAN'),(1699,'19','01','11','TINYAHUARCO'),(1700,'19','01','12','VICCO'),(1701,'19','01','13','YANACANCHA'),(1702,'19','02','00','DANIEL ALCIDES CARRION'),(1703,'19','02','01','YANAHUANCA'),(1704,'19','02','02','CHACAYAN'),(1705,'19','02','03','GOYLLARISQUIZGA'),(1706,'19','02','04','PAUCAR'),(1707,'19','02','05','SAN PEDRO DE PILLAO'),(1708,'19','02','06','SANTA ANA DE TUSI'),(1709,'19','02','07','TAPUC'),(1710,'19','02','08','VILCABAMBA'),(1711,'19','03','00','OXAPAMPA'),(1712,'19','03','01','OXAPAMPA'),(1713,'19','03','02','CHONTABAMBA'),(1714,'19','03','03','HUANCABAMBA'),(1715,'19','03','04','PALCAZU'),(1716,'19','03','05','POZUZO'),(1717,'19','03','06','PUERTO BERMUDEZ'),(1718,'19','03','07','VILLA RICA'),(1719,'19','03','08','CONSTITUCION'),(1720,'20','00','00','PIURA'),(1721,'20','01','00','PIURA'),(1722,'20','01','01','PIURA'),(1723,'20','01','04','CASTILLA'),(1724,'20','01','05','CATACAOS'),(1725,'20','01','07','CURA MORI'),(1726,'20','01','08','EL TALLAN'),(1727,'20','01','09','LA ARENA'),(1728,'20','01','10','LA UNION'),(1729,'20','01','11','LAS LOMAS'),(1730,'20','01','14','TAMBO GRANDE'),(1731,'20','01','15','VEINTISÉIS DE OCTUBRE'),(1732,'20','02','00','AYABACA'),(1733,'20','02','01','AYABACA'),(1734,'20','02','02','FRIAS'),(1735,'20','02','03','JILILI'),(1736,'20','02','04','LAGUNAS'),(1737,'20','02','05','MONTERO'),(1738,'20','02','06','PACAIPAMPA'),(1739,'20','02','07','PAIMAS'),(1740,'20','02','08','SAPILLICA'),(1741,'20','02','09','SICCHEZ'),(1742,'20','02','10','SUYO'),(1743,'20','03','00','HUANCABAMBA'),(1744,'20','03','01','HUANCABAMBA'),(1745,'20','03','02','CANCHAQUE'),(1746,'20','03','03','EL CARMEN DE LA FRONTERA'),(1747,'20','03','04','HUARMACA'),(1748,'20','03','05','LALAQUIZ'),(1749,'20','03','06','SAN MIGUEL DE EL FAIQUE'),(1750,'20','03','07','SONDOR'),(1751,'20','03','08','SONDORILLO'),(1752,'20','04','00','MORROPON'),(1753,'20','04','01','CHULUCANAS'),(1754,'20','04','02','BUENOS AIRES'),(1755,'20','04','03','CHALACO'),(1756,'20','04','04','LA MATANZA'),(1757,'20','04','05','MORROPON'),(1758,'20','04','06','SALITRAL'),(1759,'20','04','07','SAN JUAN DE BIGOTE'),(1760,'20','04','08','SANTA CATALINA DE MOSSA'),(1761,'20','04','09','SANTO DOMINGO'),(1762,'20','04','10','YAMANGO'),(1763,'20','05','00','PAITA'),(1764,'20','05','01','PAITA'),(1765,'20','05','02','AMOTAPE'),(1766,'20','05','03','ARENAL'),(1767,'20','05','04','COLAN'),(1768,'20','05','05','LA HUACA'),(1769,'20','05','06','TAMARINDO'),(1770,'20','05','07','VICHAYAL'),(1771,'20','06','00','SULLANA'),(1772,'20','06','01','SULLANA'),(1773,'20','06','02','BELLAVISTA'),(1774,'20','06','03','IGNACIO ESCUDERO'),(1775,'20','06','04','LANCONES'),(1776,'20','06','05','MARCAVELICA'),(1777,'20','06','06','MIGUEL CHECA'),(1778,'20','06','07','QUERECOTILLO'),(1779,'20','06','08','SALITRAL'),(1780,'20','07','00','TALARA'),(1781,'20','07','01','PARIÑAS'),(1782,'20','07','02','EL ALTO'),(1783,'20','07','03','LA BREA'),(1784,'20','07','04','LOBITOS'),(1785,'20','07','05','LOS ORGANOS'),(1786,'20','07','06','MANCORA'),(1787,'20','08','00','SECHURA'),(1788,'20','08','01','SECHURA'),(1789,'20','08','02','BELLAVISTA DE LA UNION'),(1790,'20','08','03','BERNAL'),(1791,'20','08','04','CRISTO NOS VALGA'),(1792,'20','08','05','VICE'),(1793,'20','08','06','RINCONADA LLICUAR'),(1794,'21','00','00','PUNO'),(1795,'21','01','00','PUNO'),(1796,'21','01','01','PUNO'),(1797,'21','01','02','ACORA'),(1798,'21','01','03','AMANTANI'),(1799,'21','01','04','ATUNCOLLA'),(1800,'21','01','05','CAPACHICA'),(1801,'21','01','06','CHUCUITO'),(1802,'21','01','07','COATA'),(1803,'21','01','08','HUATA'),(1804,'21','01','09','MAÑAZO'),(1805,'21','01','10','PAUCARCOLLA'),(1806,'21','01','11','PICHACANI'),(1807,'21','01','12','PLATERIA'),(1808,'21','01','13','SAN ANTONIO'),(1809,'21','01','14','TIQUILLACA'),(1810,'21','01','15','VILQUE'),(1811,'21','02','00','AZANGARO'),(1812,'21','02','01','AZANGARO'),(1813,'21','02','02','ACHAYA'),(1814,'21','02','03','ARAPA'),(1815,'21','02','04','ASILLO'),(1816,'21','02','05','CAMINACA'),(1817,'21','02','06','CHUPA'),(1818,'21','02','07','JOSE DOMINGO CHOQUEHUANCA'),(1819,'21','02','08','MUÑANI'),(1820,'21','02','09','POTONI'),(1821,'21','02','10','SAMAN'),(1822,'21','02','11','SAN ANTON'),(1823,'21','02','12','SAN JOSE'),(1824,'21','02','13','SAN JUAN DE SALINAS'),(1825,'21','02','14','SANTIAGO DE PUPUJA'),(1826,'21','02','15','TIRAPATA'),(1827,'21','03','00','CARABAYA'),(1828,'21','03','01','MACUSANI'),(1829,'21','03','02','AJOYANI'),(1830,'21','03','03','AYAPATA'),(1831,'21','03','04','COASA'),(1832,'21','03','05','CORANI'),(1833,'21','03','06','CRUCERO'),(1834,'21','03','07','ITUATA'),(1835,'21','03','08','OLLACHEA'),(1836,'21','03','09','SAN GABAN'),(1837,'21','03','10','USICAYOS'),(1838,'21','04','00','CHUCUITO'),(1839,'21','04','01','JULI'),(1840,'21','04','02','DESAGUADERO'),(1841,'21','04','03','HUACULLANI'),(1842,'21','04','04','KELLUYO'),(1843,'21','04','05','PISACOMA'),(1844,'21','04','06','POMATA'),(1845,'21','04','07','ZEPITA'),(1846,'21','05','00','EL COLLAO'),(1847,'21','05','01','ILAVE'),(1848,'21','05','02','CAPASO'),(1849,'21','05','03','PILCUYO'),(1850,'21','05','04','SANTA ROSA'),(1851,'21','05','05','CONDURIRI'),(1852,'21','06','00','HUANCANE'),(1853,'21','06','01','HUANCANE'),(1854,'21','06','02','COJATA'),(1855,'21','06','03','HUATASANI'),(1856,'21','06','04','INCHUPALLA'),(1857,'21','06','05','PUSI'),(1858,'21','06','06','ROSASPATA'),(1859,'21','06','07','TARACO'),(1860,'21','06','08','VILQUE CHICO'),(1861,'21','07','00','LAMPA'),(1862,'21','07','01','LAMPA'),(1863,'21','07','02','CABANILLA'),(1864,'21','07','03','CALAPUJA'),(1865,'21','07','04','NICASIO'),(1866,'21','07','05','OCUVIRI'),(1867,'21','07','06','PALCA'),(1868,'21','07','07','PARATIA'),(1869,'21','07','08','PUCARA'),(1870,'21','07','09','SANTA LUCIA'),(1871,'21','07','10','VILAVILA'),(1872,'21','08','00','MELGAR'),(1873,'21','08','01','AYAVIRI'),(1874,'21','08','02','ANTAUTA'),(1875,'21','08','03','CUPI'),(1876,'21','08','04','LLALLI'),(1877,'21','08','05','MACARI'),(1878,'21','08','06','NUÑOA'),(1879,'21','08','07','ORURILLO'),(1880,'21','08','08','SANTA ROSA'),(1881,'21','08','09','UMACHIRI'),(1882,'21','09','00','MOHO'),(1883,'21','09','01','MOHO'),(1884,'21','09','02','CONIMA'),(1885,'21','09','03','HUAYRAPATA'),(1886,'21','09','04','TILALI'),(1887,'21','10','00','SAN ANTONIO DE PUTINA'),(1888,'21','10','01','PUTINA'),(1889,'21','10','02','ANANEA'),(1890,'21','10','03','PEDRO VILCA APAZA'),(1891,'21','10','04','QUILCAPUNCU'),(1892,'21','10','05','SINA'),(1893,'21','11','00','SAN ROMAN'),(1894,'21','11','01','JULIACA'),(1895,'21','11','02','CABANA'),(1896,'21','11','03','CABANILLAS'),(1897,'21','11','04','CARACOTO'),(1898,'21','12','00','SANDIA'),(1899,'21','12','01','SANDIA'),(1900,'21','12','02','CUYOCUYO'),(1901,'21','12','03','LIMBANI'),(1902,'21','12','04','PATAMBUCO'),(1903,'21','12','05','PHARA'),(1904,'21','12','06','QUIACA'),(1905,'21','12','07','SAN JUAN DEL ORO'),(1906,'21','12','08','YANAHUAYA'),(1907,'21','12','09','ALTO INAMBARI'),(1908,'21','12','10','SAN PEDRO DE PUTINA PUNCO'),(1909,'21','13','00','YUNGUYO'),(1910,'21','13','01','YUNGUYO'),(1911,'21','13','02','ANAPIA'),(1912,'21','13','03','COPANI'),(1913,'21','13','04','CUTURAPI'),(1914,'21','13','05','OLLARAYA'),(1915,'21','13','06','TINICACHI'),(1916,'21','13','07','UNICACHI'),(1917,'22','00','00','SAN MARTIN'),(1918,'22','01','00','MOYOBAMBA'),(1919,'22','01','01','MOYOBAMBA'),(1920,'22','01','02','CALZADA'),(1921,'22','01','03','HABANA'),(1922,'22','01','04','JEPELACIO'),(1923,'22','01','05','SORITOR'),(1924,'22','01','06','YANTALO'),(1925,'22','02','00','BELLAVISTA'),(1926,'22','02','01','BELLAVISTA'),(1927,'22','02','02','ALTO BIAVO'),(1928,'22','02','03','BAJO BIAVO'),(1929,'22','02','04','HUALLAGA'),(1930,'22','02','05','SAN PABLO'),(1931,'22','02','06','SAN RAFAEL'),(1932,'22','03','00','EL DORADO'),(1933,'22','03','01','SAN JOSE DE SISA'),(1934,'22','03','02','AGUA BLANCA'),(1935,'22','03','03','SAN MARTIN'),(1936,'22','03','04','SANTA ROSA'),(1937,'22','03','05','SHATOJA'),(1938,'22','04','00','HUALLAGA'),(1939,'22','04','01','SAPOSOA'),(1940,'22','04','02','ALTO SAPOSOA'),(1941,'22','04','03','EL ESLABON'),(1942,'22','04','04','PISCOYACU'),(1943,'22','04','05','SACANCHE'),(1944,'22','04','06','TINGO DE SAPOSOA'),(1945,'22','05','00','LAMAS'),(1946,'22','05','01','LAMAS'),(1947,'22','05','02','ALONSO DE ALVARADO'),(1948,'22','05','03','BARRANQUITA'),(1949,'22','05','04','CAYNARACHI'),(1950,'22','05','05','CUÑUMBUQUI'),(1951,'22','05','06','PINTO RECODO'),(1952,'22','05','07','RUMISAPA'),(1953,'22','05','08','SAN ROQUE DE CUMBAZA'),(1954,'22','05','09','SHANAO'),(1955,'22','05','10','TABALOSOS'),(1956,'22','05','11','ZAPATERO'),(1957,'22','06','00','MARISCAL CACERES'),(1958,'22','06','01','JUANJUI'),(1959,'22','06','02','CAMPANILLA'),(1960,'22','06','03','HUICUNGO'),(1961,'22','06','04','PACHIZA'),(1962,'22','06','05','PAJARILLO'),(1963,'22','07','00','PICOTA'),(1964,'22','07','01','PICOTA'),(1965,'22','07','02','BUENOS AIRES'),(1966,'22','07','03','CASPISAPA'),(1967,'22','07','04','PILLUANA'),(1968,'22','07','05','PUCACACA'),(1969,'22','07','06','SAN CRISTOBAL'),(1970,'22','07','07','SAN HILARION'),(1971,'22','07','08','SHAMBOYACU'),(1972,'22','07','09','TINGO DE PONASA'),(1973,'22','07','10','TRES UNIDOS'),(1974,'22','08','00','RIOJA'),(1975,'22','08','01','RIOJA'),(1976,'22','08','02','AWAJUN'),(1977,'22','08','03','ELIAS SOPLIN VARGAS'),(1978,'22','08','04','NUEVA CAJAMARCA'),(1979,'22','08','05','PARDO MIGUEL'),(1980,'22','08','06','POSIC'),(1981,'22','08','07','SAN FERNANDO'),(1982,'22','08','08','YORONGOS'),(1983,'22','08','09','YURACYACU'),(1984,'22','09','00','SAN MARTIN'),(1985,'22','09','01','TARAPOTO'),(1986,'22','09','02','ALBERTO LEVEAU'),(1987,'22','09','03','CACATACHI'),(1988,'22','09','04','CHAZUTA'),(1989,'22','09','05','CHIPURANA'),(1990,'22','09','06','EL PORVENIR'),(1991,'22','09','07','HUIMBAYOC'),(1992,'22','09','08','JUAN GUERRA'),(1993,'22','09','09','LA BANDA DE SHILCAYO'),(1994,'22','09','10','MORALES'),(1995,'22','09','11','PAPAPLAYA'),(1996,'22','09','12','SAN ANTONIO'),(1997,'22','09','13','SAUCE'),(1998,'22','09','14','SHAPAJA'),(1999,'22','10','00','TOCACHE'),(2000,'22','10','01','TOCACHE'),(2001,'22','10','02','NUEVO PROGRESO'),(2002,'22','10','03','POLVORA'),(2003,'22','10','04','SHUNTE'),(2004,'22','10','05','UCHIZA'),(2005,'23','00','00','TACNA'),(2006,'23','01','00','TACNA'),(2007,'23','01','01','TACNA'),(2008,'23','01','02','ALTO DE LA ALIANZA'),(2009,'23','01','03','CALANA'),(2010,'23','01','04','CIUDAD NUEVA'),(2011,'23','01','05','INCLAN'),(2012,'23','01','06','PACHIA'),(2013,'23','01','07','PALCA'),(2014,'23','01','08','POCOLLAY'),(2015,'23','01','09','SAMA'),(2016,'23','01','10','CORONEL GREGORIO ALBARRACÍN L'),(2017,'23','02','00','CANDARAVE'),(2018,'23','02','01','CANDARAVE'),(2019,'23','02','02','CAIRANI'),(2020,'23','02','03','CAMILACA'),(2021,'23','02','04','CURIBAYA'),(2022,'23','02','05','HUANUARA'),(2023,'23','02','06','QUILAHUANI'),(2024,'23','03','00','JORGE BASADRE'),(2025,'23','03','01','LOCUMBA'),(2026,'23','03','02','ILABAYA'),(2027,'23','03','03','ITE'),(2028,'23','04','00','TARATA'),(2029,'23','04','01','TARATA'),(2030,'23','04','02','CHUCATAMANI'),(2031,'23','04','03','ESTIQUE'),(2032,'23','04','04','ESTIQUE-PAMPA'),(2033,'23','04','05','SITAJARA'),(2034,'23','04','06','SUSAPAYA'),(2035,'23','04','07','TARUCACHI'),(2036,'23','04','08','TICACO'),(2037,'24','00','00','TUMBES'),(2038,'24','01','00','TUMBES'),(2039,'24','01','01','TUMBES'),(2040,'24','01','02','CORRALES'),(2041,'24','01','03','LA CRUZ'),(2042,'24','01','04','PAMPAS DE HOSPITAL'),(2043,'24','01','05','SAN JACINTO'),(2044,'24','01','06','SAN JUAN DE LA VIRGEN'),(2045,'24','02','00','CONTRALMIRANTE VILLAR'),(2046,'24','02','01','ZORRITOS'),(2047,'24','02','02','CASITAS'),(2048,'24','02','03','CANOAS DE PUNTA SAL'),(2049,'24','03','00','ZARUMILLA'),(2050,'24','03','01','ZARUMILLA'),(2051,'24','03','02','AGUAS VERDES'),(2052,'24','03','03','MATAPALO'),(2053,'24','03','04','PAPAYAL'),(2054,'25','00','00','UCAYALI'),(2055,'25','01','00','CORONEL PORTILLO'),(2056,'25','01','01','CALLARIA'),(2057,'25','01','02','CAMPOVERDE'),(2058,'25','01','03','IPARIA'),(2059,'25','01','04','MASISEA'),(2060,'25','01','05','YARINACOCHA'),(2061,'25','01','06','NUEVA REQUENA'),(2062,'25','01','07','MANANTAY'),(2063,'25','02','00','ATALAYA'),(2064,'25','02','01','RAYMONDI'),(2065,'25','02','02','SEPAHUA'),(2066,'25','02','03','TAHUANIA'),(2067,'25','02','04','YURUA'),(2068,'25','03','00','PADRE ABAD'),(2069,'25','03','01','PADRE ABAD'),(2070,'25','03','02','IRAZOLA'),(2071,'25','03','03','CURIMANA'),(2072,'25','04','00','PURUS'),(2073,'25','04','01','PURUS'),(2074,'99','00','00','EXTRANJERO'),(2075,'99','99','00','EXTRANJERO'),(2076,'99','99','99','EXTRANJERO;');
/*!40000 ALTER TABLE `ubigeo_inei` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_addresses`
--

DROP TABLE IF EXISTS `user_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_addresses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `label` varchar(255) NOT NULL DEFAULT 'Casa',
  `address_line` text DEFAULT NULL,
  `city` varchar(255) NOT NULL,
  `province` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) NOT NULL DEFAULT 'Perú',
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_addresses_user_id_foreign` (`user_id`) USING BTREE,
  CONSTRAINT `user_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_addresses`
--

LOCK TABLES `user_addresses` WRITE;
/*!40000 ALTER TABLE `user_addresses` DISABLE KEYS */;
INSERT INTO `user_addresses` VALUES (2,35,'Casa','dsfvdsvds','1994','1984','1917','32424','Perú',1,'2025-07-14 07:36:00','2025-07-14 07:36:00');
/*!40000 ALTER TABLE `user_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_cliente_direcciones`
--

DROP TABLE IF EXISTS `user_cliente_direcciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_cliente_direcciones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_cliente_id` bigint(20) unsigned NOT NULL,
  `nombre_destinatario` varchar(255) NOT NULL,
  `direccion_completa` text NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_ubigeo` varchar(6) DEFAULT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `predeterminada` tinyint(1) NOT NULL DEFAULT 0,
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_cliente_id` (`user_cliente_id`) USING BTREE,
  KEY `idx_predeterminada` (`predeterminada`) USING BTREE,
  KEY `idx_activa` (`activa`) USING BTREE,
  KEY `idx_ubigeo` (`id_ubigeo`) USING BTREE,
  CONSTRAINT `fk_user_cliente_direcciones_user_cliente` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_cliente_direcciones`
--

LOCK TABLES `user_cliente_direcciones` WRITE;
/*!40000 ALTER TABLE `user_cliente_direcciones` DISABLE KEYS */;
INSERT INTO `user_cliente_direcciones` VALUES (17,25,'José Alonso Morales Yangua','jdsdf',NULL,'2076',NULL,NULL,1,1,'2025-09-22 15:45:55','2025-09-22 15:45:55'),(19,27,'CARMEN ROSA LOPEZ GUERRERO','sfjskf',NULL,'635',NULL,NULL,1,1,'2025-09-22 17:18:40','2025-09-22 17:18:40'),(22,32,'SUSAN LADY COBA TORRES','SJM',NULL,'1436',NULL,NULL,1,1,'2025-09-23 13:11:19','2025-09-23 13:11:19'),(23,33,'JOHNY HUALLPA LOPEZ','sjfsf',NULL,'121',NULL,NULL,1,1,'2025-09-23 14:05:29','2025-09-23 14:05:29');
/*!40000 ALTER TABLE `user_cliente_direcciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_clientes`
--

DROP TABLE IF EXISTS `user_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_clientes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombres` varchar(255) NOT NULL,
  `apellidos` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('masculino','femenino','otro') DEFAULT NULL,
  `tipo_documento_id` bigint(20) unsigned NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `verification_token` varchar(255) DEFAULT NULL,
  `verification_code` varchar(6) DEFAULT NULL,
  `is_first_google_login` tinyint(1) DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `cliente_facturacion_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Referencia a tabla clientes para facturación',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `numero_documento` (`numero_documento`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_numero_documento` (`numero_documento`) USING BTREE,
  KEY `idx_tipo_documento` (`tipo_documento_id`) USING BTREE,
  KEY `idx_estado` (`estado`) USING BTREE,
  KEY `idx_cliente_facturacion` (`cliente_facturacion_id`) USING BTREE,
  CONSTRAINT `fk_user_clientes_cliente_facturacion` FOREIGN KEY (`cliente_facturacion_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_clientes_tipo_documento` FOREIGN KEY (`tipo_documento_id`) REFERENCES `document_types` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_clientes`
--

LOCK TABLES `user_clientes` WRITE;
/*!40000 ALTER TABLE `user_clientes` DISABLE KEYS */;
INSERT INTO `user_clientes` VALUES (24,'Linder Lopez','Google','linsalo19b@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758555690','$2y$12$m6zXZwb/t0MPe9vrOSHhkOQArN00CyhqhoFGfgePNChom8QfdauZK','2025-09-22 08:41:30',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-22 08:41:30','2025-09-22 08:41:30'),(25,'José Alonso','Morales Yangua','chinchayjuan95@gmail.com','958478546',NULL,NULL,1,'73894795','$2y$12$VUbmaehtn8oFASYItw4Pg.EfJSaY2XYdQ61yorJegYzoRkkDye2DO',NULL,'q8J45LOckJWatOwbFO2jtDY3yweoxfNrD8EV2y8BakcdW2vCYQ77Rr88GyFE','8ICZNK',0,NULL,NULL,0,NULL,'2025-09-22 15:45:55','2025-09-22 15:45:55'),(27,'CARMEN ROSA','LOPEZ GUERRERO','cristiancamacaro360@gmail.com','94545436',NULL,NULL,1,'45674798','$2y$12$wva3gOCZLC5W89IOvvEzOeye/z6QQJr1k/A.NLPx4JlcD50KFrAna','2025-09-22 17:20:06',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-22 17:18:40','2025-09-22 17:20:06'),(30,'manuel aguado sierra','Google','umbrellasrl@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758641126','$2y$12$xzgJrZ8Pi5q3U8BuyOX/2OgbPTHEHSoVMe6v9X1JYoBxF3I3VZ5Yy','2025-09-23 08:25:26',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-23 08:25:26','2025-09-23 08:25:26'),(31,'kiyotaka hitori','Google','kiyotakahitori@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758647650','$2y$12$0wuYQJgC6GNFjgSnUxHuwOsstPJB5W3ryvpFdCUVDHPlN2RiMAUTS','2025-09-23 10:14:10',NULL,NULL,1,NULL,'/storage/clientes/1758647667_31.jpg',1,NULL,'2025-09-23 10:14:10','2025-09-23 10:14:27'),(32,'SUSAN LADY','COBA TORRES','ladysct11@gmail.com','949220756',NULL,NULL,1,'45891483','$2y$12$k9/uqBdd33M8lS8TcLOTZOHsIj94WXe.2tIzBD9R3tBY8OKmB/8Cq','2025-09-23 13:12:20',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-23 13:11:19','2025-09-23 13:12:20'),(33,'JOHNY','HUALLPA LOPEZ','anasilvia123vv@gmail.com','98545968',NULL,NULL,1,'44355989','$2y$12$jIhb7muvSY8oh47lGoIeSOwwXPG/qTRc1rzsNpO0fYk7qgzG99yme','2025-09-23 14:05:48',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-23 14:05:29','2025-09-23 14:05:48'),(34,'Alexander','Google','pieromorales1033@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759004376','$2y$12$Rs7OGG2u79yCz8ZRyCLMDeeuLBwBnKG.VIFP8oe/wnIhcVL4qE3u6','2025-09-27 13:19:36',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 13:19:36','2025-09-27 13:19:36'),(35,'Victor Canchari','Google','vcanchari38@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759024821','$2y$12$FaEL2UIE/CiJ7bQFD2NeRO1svLcVpNVnm5WYUS8sdA1hDaAX3jrTG','2025-09-27 19:00:21',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 19:00:21','2025-09-27 19:00:21'),(36,'Manuel Aguado','Google','systemcraft.pe@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759026505','$2y$12$9XNCRDImq9Z0sxRYA3FCxu2xQfdGd8O8e6eGOB034l.zL5GDNsIte','2025-09-27 19:28:25',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 19:28:25','2025-09-27 19:28:25'),(37,'EMER RODRIGO','YARLEQUE ZAPATA','rodrigoyarleque7@gmail.com','+51 993 321 920',NULL,NULL,1,'77425200','$2y$12$HrZBPY7Ru6IGzT0DFbwzEOdP1.nCr09x4HMQmu/YelOrQYEi7A12i','2025-10-29 23:37:52',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-29 10:32:20','2025-10-29 23:37:52'),(39,'ROGGER CESAR','CCORAHUA CORONADO','adan2025zapata@gmail.com','+51 993 321 920',NULL,NULL,1,'73425200','$2y$12$ajZvx2/5kc2HWyBfy.HQPu.VwpExk2LGLT60afjzjOHWltsAY4jLe',NULL,'qyQPs5p7lCPR5gKbPQjQuwyiKKe4gkYsUGQoxq9x8L55pjQsK6Of9xWpP2km','E02HCQ',0,NULL,NULL,0,NULL,'2025-09-29 10:38:53','2025-09-29 10:38:53'),(40,'HILDEBRANDO MANUEL','AGUADO MUÑOZ','manuel.aguado@magustechnologies.com','972711111',NULL,NULL,1,'08418039','$2y$12$ykz60mxusGyjEz49amFVnuIeAEOFMAdwV8pSmxCPdwp1y6EFq4xP6','2025-11-06 17:08:09',NULL,NULL,0,NULL,NULL,1,NULL,'2025-11-06 17:06:47','2025-11-06 17:08:09'),(41,'rodrigo Emer','Google','emer17rodrigo@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1763996413','$2y$12$HPAu0jeDHmSEoJf6XLerteYQPPZpQbEUqjf/fXQA1qFsh6gql0NF2','2025-11-24 15:00:13',NULL,NULL,1,NULL,NULL,1,NULL,'2025-11-24 15:00:13','2025-11-24 15:00:13'),(42,'alondra quiroz loarte','Google','alquilo30@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1764269660','$2y$12$RUuQKCNjiDsT.N6z/rsUkOJngUt1CjrtiFXIvAv74oh3s/0Pjwije','2025-11-27 18:54:20',NULL,NULL,1,NULL,NULL,1,NULL,'2025-11-27 18:54:20','2025-11-27 18:54:20');
/*!40000 ALTER TABLE `user_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_horarios`
--

DROP TABLE IF EXISTS `user_horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_horarios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `dia_semana` enum('lunes','martes','miercoles','jueves','viernes','sabado','domingo') NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `es_descanso` tinyint(1) DEFAULT 0,
  `fecha_especial` date DEFAULT NULL,
  `comentarios` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_horarios_user_dia` (`user_id`,`dia_semana`) USING BTREE,
  KEY `idx_user_horarios_fecha_especial` (`fecha_especial`) USING BTREE,
  KEY `idx_user_horarios_activo` (`activo`) USING BTREE,
  KEY `idx_user_horarios_disponibilidad` (`user_id`,`dia_semana`,`activo`) USING BTREE,
  CONSTRAINT `fk_user_horarios_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_hora_fin_mayor_inicio` CHECK (`hora_fin` > `hora_inicio`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_horarios`
--

LOCK TABLES `user_horarios` WRITE;
/*!40000 ALTER TABLE `user_horarios` DISABLE KEYS */;
INSERT INTO `user_horarios` VALUES (1,35,'lunes','03:36:00','18:36:00',0,NULL,NULL,1,'2025-07-14 07:36:50','2025-07-14 07:36:50'),(2,1,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(3,1,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(4,1,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(5,1,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(7,1,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(12,29,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(13,29,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(14,29,'miercoles','20:00:00','21:01:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-11-20 01:15:04'),(15,29,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(16,31,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(17,29,'jueves','07:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-11-27 12:07:20'),(18,31,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(19,31,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(20,31,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(21,31,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(22,32,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(23,32,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(24,32,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(25,32,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(26,32,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(27,35,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(28,35,'jueves','07:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-11-27 12:08:01'),(29,35,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(30,35,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(31,35,'martes','09:13:00','22:24:00',0,NULL,NULL,1,'2025-11-05 01:13:00','2025-11-05 01:13:00');
/*!40000 ALTER TABLE `user_horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_motorizados`
--

DROP TABLE IF EXISTS `user_motorizados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_motorizados` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `motorizado_id` bigint(20) unsigned NOT NULL,
  `username` varchar(50) NOT NULL COMMENT 'Usuario de login (ej: MOT-001)',
  `password` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Usuario activo/inactivo',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`),
  KEY `idx_motorizado_id` (`motorizado_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `user_motorizados_ibfk_1` FOREIGN KEY (`motorizado_id`) REFERENCES `motorizados` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Credenciales de acceso para motorizados';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_motorizados`
--

LOCK TABLES `user_motorizados` WRITE;
/*!40000 ALTER TABLE `user_motorizados` DISABLE KEYS */;
INSERT INTO `user_motorizados` VALUES (4,5,'akame17ga20kill@gmail.com','$2y$12$fT6q2KAEARTqRBfPYvcpK.5B/zk8N8Ml7ivqGgHCG.GLVTOtHWaca',1,'2025-09-29 08:56:53',NULL,'2025-09-29 08:56:03','2025-09-29 08:56:53'),(5,6,'magus@gmail.com','$2y$12$8quMHwnlhWZykx1utls35Ocf286W6NJsksFNNYa3mY3SxPP39mJqe',1,'2025-11-24 21:29:06',NULL,'2025-11-24 21:28:37','2025-11-24 21:29:06');
/*!40000 ALTER TABLE `user_motorizados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profiles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_profiles_document_number_unique` (`document_number`) USING BTREE,
  KEY `user_profiles_user_id_foreign` (`user_id`) USING BTREE,
  CONSTRAINT `user_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
INSERT INTO `user_profiles` VALUES (3,35,'swedfsdvc','dsfvdfvs','sdfvdsf','993321920','3','77425200','2025-06-06','masculino','/storage/avatars/avatar_35_1749229676.jpg','2025-06-06 15:07:56','2025-06-06 15:07:56');
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `users_email_unique` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin Usuario','admin@example.com',NULL,'$2y$12$1HlGmMzDtit03XChNUfyh.2V1gpHtzwN/BdsJX4XRBvg/b0BGECd2',NULL,1,'2025-05-21 13:07:04','2025-05-21 18:08:35'),(29,'AlexanderFitgh','shinji@gmail.com',NULL,'$2y$12$GmHHsqbKf5SzTFsy.FKIVObmV1iy6H9mhUJH3gg6jvrs0OJrXFBee',NULL,1,'2025-06-03 23:05:50','2025-06-03 23:05:50'),(31,'Jonas','akdkre@gmail.com',NULL,'$2y$12$kUGXM6nNttS56LTXuWv6DeYko29OKB4ljrUIlLanp7PNqug4bSXnq',NULL,1,'2025-06-03 23:18:50','2025-06-03 23:18:50'),(32,'Test User','test@example.com','2025-06-05 16:59:56','$2y$12$LSvxM6fDnM5sPphz02V7F.f9lMK9HHPnio9Ky1TMxWK7K1X3lhMYm','u0CJ3CuGQu',1,'2025-06-05 16:59:56','2025-06-05 16:59:56'),(35,'emer1','kiyotakahitori@gmail.com',NULL,'7817b0c8a26139a4f1f3623c2932e7d016dd59b1',NULL,1,'2025-06-06 15:07:56','2025-06-06 15:07:56');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilidad_mensual`
--

DROP TABLE IF EXISTS `utilidad_mensual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilidad_mensual` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mes` int(11) NOT NULL,
  `anio` int(11) NOT NULL,
  `total_ventas` decimal(12,2) NOT NULL,
  `total_costos` decimal(12,2) NOT NULL,
  `utilidad_bruta` decimal(12,2) NOT NULL,
  `margen_bruto_porcentaje` decimal(5,2) NOT NULL,
  `gastos_operativos` decimal(12,2) NOT NULL,
  `utilidad_operativa` decimal(12,2) NOT NULL,
  `margen_operativo_porcentaje` decimal(5,2) NOT NULL,
  `otros_ingresos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `otros_gastos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `utilidad_neta` decimal(12,2) NOT NULL,
  `margen_neto_porcentaje` decimal(5,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `utilidad_mensual_mes_anio_unique` (`mes`,`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilidad_mensual`
--

LOCK TABLES `utilidad_mensual` WRITE;
/*!40000 ALTER TABLE `utilidad_mensual` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilidad_mensual` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilidad_productos`
--

DROP TABLE IF EXISTS `utilidad_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilidad_productos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `cantidad_vendida` int(11) NOT NULL,
  `precio_venta_promedio` decimal(12,2) NOT NULL,
  `costo_promedio` decimal(12,2) NOT NULL,
  `total_ventas` decimal(12,2) NOT NULL,
  `total_costos` decimal(12,2) NOT NULL,
  `utilidad_bruta` decimal(12,2) NOT NULL,
  `margen_porcentaje` decimal(5,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `utilidad_productos_producto_id_fecha_index` (`producto_id`,`fecha`),
  CONSTRAINT `utilidad_productos_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilidad_productos`
--

LOCK TABLES `utilidad_productos` WRITE;
/*!40000 ALTER TABLE `utilidad_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilidad_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilidad_ventas`
--

DROP TABLE IF EXISTS `utilidad_ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilidad_ventas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint(20) unsigned NOT NULL,
  `comprobante_id` bigint(20) unsigned DEFAULT NULL,
  `fecha_venta` date NOT NULL,
  `total_venta` decimal(12,2) NOT NULL,
  `costo_total` decimal(12,2) NOT NULL,
  `utilidad_bruta` decimal(12,2) NOT NULL,
  `margen_porcentaje` decimal(5,2) NOT NULL,
  `gastos_operativos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `utilidad_neta` decimal(12,2) NOT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `utilidad_ventas_venta_id_foreign` (`venta_id`),
  KEY `utilidad_ventas_comprobante_id_foreign` (`comprobante_id`),
  KEY `utilidad_ventas_fecha_venta_venta_id_index` (`fecha_venta`,`venta_id`),
  CONSTRAINT `utilidad_ventas_comprobante_id_foreign` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `utilidad_ventas_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilidad_ventas`
--

LOCK TABLES `utilidad_ventas` WRITE;
/*!40000 ALTER TABLE `utilidad_ventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilidad_ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilidades`
--

DROP TABLE IF EXISTS `utilidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilidades` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `periodo` varchar(7) NOT NULL COMMENT 'Formato: YYYY-MM',
  `ingresos_totales` decimal(12,2) NOT NULL DEFAULT 0.00,
  `costos_ventas` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gastos_operativos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gastos_administrativos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gastos_financieros` decimal(12,2) NOT NULL DEFAULT 0.00,
  `otros_ingresos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `otros_egresos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `utilidad_bruta` decimal(12,2) NOT NULL DEFAULT 0.00,
  `utilidad_operativa` decimal(12,2) NOT NULL DEFAULT 0.00,
  `utilidad_neta` decimal(12,2) NOT NULL DEFAULT 0.00,
  `margen_bruto` decimal(5,2) DEFAULT 0.00 COMMENT 'Porcentaje',
  `margen_operativo` decimal(5,2) DEFAULT 0.00 COMMENT 'Porcentaje',
  `margen_neto` decimal(5,2) DEFAULT 0.00 COMMENT 'Porcentaje',
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `utilidades_periodo_unique` (`periodo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilidades`
--

LOCK TABLES `utilidades` WRITE;
/*!40000 ALTER TABLE `utilidades` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_formas_envio_detalle`
--

DROP TABLE IF EXISTS `v_formas_envio_detalle`;
/*!50001 DROP VIEW IF EXISTS `v_formas_envio_detalle`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_formas_envio_detalle` AS SELECT 
 1 AS `id`,
 1 AS `departamento_id`,
 1 AS `departamento_nombre`,
 1 AS `provincia_id`,
 1 AS `provincia_nombre`,
 1 AS `distrito_id`,
 1 AS `distrito_nombre`,
 1 AS `costo`,
 1 AS `activo`,
 1 AS `created_at`,
 1 AS `updated_at`,
 1 AS `ubicacion_completa`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_motorizados_activos`
--

DROP TABLE IF EXISTS `v_motorizados_activos`;
/*!50001 DROP VIEW IF EXISTS `v_motorizados_activos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_motorizados_activos` AS SELECT 
 1 AS `id`,
 1 AS `numero_unidad`,
 1 AS `nombre_completo`,
 1 AS `foto_perfil`,
 1 AS `tipo_documento_id`,
 1 AS `numero_documento`,
 1 AS `licencia_numero`,
 1 AS `licencia_categoria`,
 1 AS `telefono`,
 1 AS `correo`,
 1 AS `direccion_detalle`,
 1 AS `ubigeo`,
 1 AS `vehiculo_marca`,
 1 AS `vehiculo_modelo`,
 1 AS `vehiculo_ano`,
 1 AS `vehiculo_cilindraje`,
 1 AS `vehiculo_color_principal`,
 1 AS `vehiculo_color_secundario`,
 1 AS `vehiculo_placa`,
 1 AS `vehiculo_motor`,
 1 AS `vehiculo_chasis`,
 1 AS `comentario`,
 1 AS `registrado_por`,
 1 AS `user_motorizado_id`,
 1 AS `estado`,
 1 AS `created_at`,
 1 AS `updated_at`,
 1 AS `username`,
 1 AS `user_active`,
 1 AS `last_login_at`,
 1 AS `estado_actual`,
 1 AS `latitud`,
 1 AS `longitud`,
 1 AS `ultima_actividad`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `venta_detalle_metodos_pago`
--

DROP TABLE IF EXISTS `venta_detalle_metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venta_detalle_metodos_pago` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `venta_detalle_id` bigint(20) unsigned NOT NULL COMMENT 'Detalle de venta (producto)',
  `venta_metodo_pago_id` bigint(20) unsigned NOT NULL COMMENT 'Método de pago usado',
  `monto_asignado` decimal(10,2) NOT NULL COMMENT 'Monto de este método de pago asignado a este producto',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_detalle_metodo` (`venta_detalle_id`,`venta_metodo_pago_id`),
  KEY `venta_detalle_metodos_pago_venta_metodo_pago_id_foreign` (`venta_metodo_pago_id`),
  CONSTRAINT `venta_detalle_metodos_pago_venta_detalle_id_foreign` FOREIGN KEY (`venta_detalle_id`) REFERENCES `venta_detalles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `venta_detalle_metodos_pago_venta_metodo_pago_id_foreign` FOREIGN KEY (`venta_metodo_pago_id`) REFERENCES `venta_metodos_pago` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venta_detalle_metodos_pago`
--

LOCK TABLES `venta_detalle_metodos_pago` WRITE;
/*!40000 ALTER TABLE `venta_detalle_metodos_pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `venta_detalle_metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venta_detalles`
--

DROP TABLE IF EXISTS `venta_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venta_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
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
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_venta_id` (`venta_id`) USING BTREE,
  KEY `idx_producto_id` (`producto_id`) USING BTREE,
  CONSTRAINT `fk_venta_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_venta_detalles_venta_id` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venta_detalles`
--

LOCK TABLES `venta_detalles` WRITE;
/*!40000 ALTER TABLE `venta_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `venta_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venta_metodos_pago`
--

DROP TABLE IF EXISTS `venta_metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venta_metodos_pago` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint(20) unsigned NOT NULL,
  `metodo` varchar(50) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `venta_metodos_pago_venta_id_index` (`venta_id`),
  KEY `venta_metodos_pago_metodo_index` (`metodo`),
  CONSTRAINT `venta_metodos_pago_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venta_metodos_pago`
--

LOCK TABLES `venta_metodos_pago` WRITE;
/*!40000 ALTER TABLE `venta_metodos_pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `venta_metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo_venta` varchar(20) NOT NULL,
  `cliente_id` bigint(20) unsigned DEFAULT NULL,
  `user_cliente_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Cliente del e-commerce',
  `fecha_venta` datetime NOT NULL,
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Sin IGV',
  `igv` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','FACTURADO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `comprobante_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Comprobante generado',
  `requiere_factura` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cliente pidió factura',
  `metodo_pago` varchar(50) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Usuario que registró (puede ser null para ventas web)',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo_venta` (`codigo_venta`) USING BTREE,
  KEY `idx_codigo_venta` (`codigo_venta`) USING BTREE,
  KEY `idx_cliente_id` (`cliente_id`) USING BTREE,
  KEY `idx_fecha_venta` (`fecha_venta`) USING BTREE,
  KEY `idx_estado` (`estado`) USING BTREE,
  KEY `idx_comprobante_id` (`comprobante_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_user_cliente_id` (`user_cliente_id`) USING BTREE,
  KEY `idx_fecha_estado` (`fecha_venta`,`estado`),
  CONSTRAINT `fk_ventas_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_comprobante_id` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_user_cliente_id` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vista_estadisticas_cookies`
--

DROP TABLE IF EXISTS `vista_estadisticas_cookies`;
/*!50001 DROP VIEW IF EXISTS `vista_estadisticas_cookies`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_estadisticas_cookies` AS SELECT 
 1 AS `total_usuarios`,
 1 AS `aceptaron_todo`,
 1 AS `rechazaron_todo`,
 1 AS `personalizaron`,
 1 AS `aceptaron_analiticas`,
 1 AS `aceptaron_marketing`,
 1 AS `aceptaron_funcionales`,
 1 AS `promedio_actualizaciones`,
 1 AS `porcentaje_aceptacion_total`,
 1 AS `porcentaje_analiticas`,
 1 AS `porcentaje_marketing`,
 1 AS `ultima_preferencia_registrada`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voucher_detalles`
--

DROP TABLE IF EXISTS `voucher_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voucher_detalles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(20) unsigned NOT NULL,
  `cuenta_contable` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `debe` decimal(10,2) NOT NULL DEFAULT 0.00,
  `haber` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `voucher_detalles_voucher_id_foreign` (`voucher_id`),
  CONSTRAINT `voucher_detalles_voucher_id_foreign` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucher_detalles`
--

LOCK TABLES `voucher_detalles` WRITE;
/*!40000 ALTER TABLE `voucher_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `voucher_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vouchers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tipo` enum('PAGO_CLIENTE','PAGO_PROVEEDOR','DEPOSITO','TRANSFERENCIA','OTRO') NOT NULL,
  `numero_operacion` varchar(100) NOT NULL,
  `fecha` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `banco` varchar(100) DEFAULT NULL,
  `cuenta_origen` varchar(50) DEFAULT NULL,
  `cuenta_destino` varchar(50) DEFAULT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `archivo_voucher` varchar(255) DEFAULT NULL,
  `cuenta_por_cobrar_id` bigint(20) unsigned DEFAULT NULL,
  `cuenta_por_pagar_id` bigint(20) unsigned DEFAULT NULL,
  `venta_id` bigint(20) unsigned DEFAULT NULL,
  `compra_id` bigint(20) unsigned DEFAULT NULL,
  `estado` enum('PENDIENTE','VERIFICADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  `observaciones` text DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `verificado_por` bigint(20) unsigned DEFAULT NULL,
  `verificado_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vouchers_cuenta_por_cobrar_id_foreign` (`cuenta_por_cobrar_id`),
  KEY `vouchers_cuenta_por_pagar_id_foreign` (`cuenta_por_pagar_id`),
  KEY `vouchers_venta_id_foreign` (`venta_id`),
  KEY `vouchers_compra_id_foreign` (`compra_id`),
  KEY `vouchers_user_id_foreign` (`user_id`),
  KEY `vouchers_verificado_por_foreign` (`verificado_por`),
  KEY `vouchers_tipo_estado_index` (`tipo`,`estado`),
  KEY `vouchers_fecha_index` (`fecha`),
  KEY `vouchers_numero_operacion_index` (`numero_operacion`),
  CONSTRAINT `vouchers_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `vouchers_cuenta_por_cobrar_id_foreign` FOREIGN KEY (`cuenta_por_cobrar_id`) REFERENCES `cuentas_por_cobrar` (`id`) ON DELETE SET NULL,
  CONSTRAINT `vouchers_cuenta_por_pagar_id_foreign` FOREIGN KEY (`cuenta_por_pagar_id`) REFERENCES `cuentas_por_pagar` (`id`) ON DELETE SET NULL,
  CONSTRAINT `vouchers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vouchers_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL,
  CONSTRAINT `vouchers_verificado_por_foreign` FOREIGN KEY (`verificado_por`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_formas_envio_detalle`
--

/*!50001 DROP VIEW IF EXISTS `v_formas_envio_detalle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`38.255.107.234` SQL SECURITY DEFINER */
/*!50001 VIEW `v_formas_envio_detalle` AS select `fe`.`id` AS `id`,`fe`.`departamento_id` AS `departamento_id`,`d`.`nombre` AS `departamento_nombre`,`fe`.`provincia_id` AS `provincia_id`,`p`.`nombre` AS `provincia_nombre`,`fe`.`distrito_id` AS `distrito_id`,`dist`.`nombre` AS `distrito_nombre`,`fe`.`costo` AS `costo`,`fe`.`activo` AS `activo`,`fe`.`created_at` AS `created_at`,`fe`.`updated_at` AS `updated_at`,case when `fe`.`distrito_id` is not null then concat(`dist`.`nombre`,', ',`p`.`nombre`,', ',`d`.`nombre`) when `fe`.`provincia_id` is not null then concat(`p`.`nombre`,', ',`d`.`nombre`) else `d`.`nombre` end AS `ubicacion_completa` from (((`forma_envios` `fe` left join `ubigeo_inei` `d` on(`fe`.`departamento_id` = concat(`d`.`departamento`,`d`.`provincia`,`d`.`distrito`))) left join `ubigeo_inei` `p` on(`fe`.`provincia_id` = concat(`p`.`departamento`,`p`.`provincia`,`p`.`distrito`))) left join `ubigeo_inei` `dist` on(`fe`.`distrito_id` = concat(`dist`.`departamento`,`dist`.`provincia`,`dist`.`distrito`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_motorizados_activos`
--

/*!50001 DROP VIEW IF EXISTS `v_motorizados_activos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_motorizados_activos` AS select `m`.`id` AS `id`,`m`.`numero_unidad` AS `numero_unidad`,`m`.`nombre_completo` AS `nombre_completo`,`m`.`foto_perfil` AS `foto_perfil`,`m`.`tipo_documento_id` AS `tipo_documento_id`,`m`.`numero_documento` AS `numero_documento`,`m`.`licencia_numero` AS `licencia_numero`,`m`.`licencia_categoria` AS `licencia_categoria`,`m`.`telefono` AS `telefono`,`m`.`correo` AS `correo`,`m`.`direccion_detalle` AS `direccion_detalle`,`m`.`ubigeo` AS `ubigeo`,`m`.`vehiculo_marca` AS `vehiculo_marca`,`m`.`vehiculo_modelo` AS `vehiculo_modelo`,`m`.`vehiculo_ano` AS `vehiculo_ano`,`m`.`vehiculo_cilindraje` AS `vehiculo_cilindraje`,`m`.`vehiculo_color_principal` AS `vehiculo_color_principal`,`m`.`vehiculo_color_secundario` AS `vehiculo_color_secundario`,`m`.`vehiculo_placa` AS `vehiculo_placa`,`m`.`vehiculo_motor` AS `vehiculo_motor`,`m`.`vehiculo_chasis` AS `vehiculo_chasis`,`m`.`comentario` AS `comentario`,`m`.`registrado_por` AS `registrado_por`,`m`.`user_motorizado_id` AS `user_motorizado_id`,`m`.`estado` AS `estado`,`m`.`created_at` AS `created_at`,`m`.`updated_at` AS `updated_at`,`um`.`username` AS `username`,`um`.`is_active` AS `user_active`,`um`.`last_login_at` AS `last_login_at`,`me`.`estado` AS `estado_actual`,`me`.`latitud` AS `latitud`,`me`.`longitud` AS `longitud`,`me`.`ultima_actividad` AS `ultima_actividad` from ((`motorizados` `m` left join `user_motorizados` `um` on(`m`.`user_motorizado_id` = `um`.`id`)) left join `motorizado_estados` `me` on(`m`.`id` = `me`.`motorizado_id`)) where `m`.`estado` = 1 and (`um`.`is_active` = 1 or `um`.`is_active` is null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_estadisticas_cookies`
--

/*!50001 DROP VIEW IF EXISTS `vista_estadisticas_cookies`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`38.56.216.90` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_estadisticas_cookies` AS select count(0) AS `total_usuarios`,sum(case when `cookies_preferences`.`consintio_todo` = 1 then 1 else 0 end) AS `aceptaron_todo`,sum(case when `cookies_preferences`.`rechazo_todo` = 1 then 1 else 0 end) AS `rechazaron_todo`,sum(case when `cookies_preferences`.`personalizado` = 1 then 1 else 0 end) AS `personalizaron`,sum(case when `cookies_preferences`.`cookies_analiticas` = 1 then 1 else 0 end) AS `aceptaron_analiticas`,sum(case when `cookies_preferences`.`cookies_marketing` = 1 then 1 else 0 end) AS `aceptaron_marketing`,sum(case when `cookies_preferences`.`cookies_funcionales` = 1 then 1 else 0 end) AS `aceptaron_funcionales`,avg(`cookies_preferences`.`numero_actualizaciones`) AS `promedio_actualizaciones`,round(sum(case when `cookies_preferences`.`consintio_todo` = 1 then 1 else 0 end) / count(0) * 100,2) AS `porcentaje_aceptacion_total`,round(sum(case when `cookies_preferences`.`cookies_analiticas` = 1 then 1 else 0 end) / count(0) * 100,2) AS `porcentaje_analiticas`,round(sum(case when `cookies_preferences`.`cookies_marketing` = 1 then 1 else 0 end) / count(0) * 100,2) AS `porcentaje_marketing`,cast(max(`cookies_preferences`.`created_at`) as date) AS `ultima_preferencia_registrada` from `cookies_preferences` where `cookies_preferences`.`fecha_expiracion` > current_timestamp() or `cookies_preferences`.`fecha_expiracion` is null */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-01 16:35:40
