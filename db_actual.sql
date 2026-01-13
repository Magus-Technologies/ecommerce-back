CREATE DATABASE  IF NOT EXISTS `ecommerce_bak_magus3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ecommerce_bak_magus3`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_bak_magus3
-- ------------------------------------------------------
-- Server version	8.0.43

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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `categoria_id` bigint unsigned NOT NULL,
  `orden` int NOT NULL DEFAULT '1',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `nombre_paso` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `descripcion_paso` text COLLATE utf8mb4_unicode_ci,
  `es_requerido` tinyint(1) NOT NULL DEFAULT '1',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint unsigned NOT NULL,
  `tipo_operacion` enum('EMISION','CONSULTA','RESUMEN','BAJA') COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidad_tipo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entidad_id` bigint unsigned DEFAULT NULL,
  `entidad_referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `endpoint_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `request_body` longtext COLLATE utf8mb4_unicode_ci,
  `response_status` int DEFAULT NULL,
  `response_headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `response_body` longtext COLLATE utf8mb4_unicode_ci,
  `response_time_ms` int unsigned DEFAULT NULL,
  `exitoso` tinyint(1) DEFAULT '0',
  `codigo_sunat` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `intento` tinyint unsigned DEFAULT '1',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_empresa` (`empresa_id`),
  KEY `idx_tipo_operacion` (`tipo_operacion`),
  KEY `idx_entidad` (`entidad_tipo`,`entidad_id`),
  KEY `idx_exitoso` (`exitoso`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_usuario_id` (`usuario_id`),
  CONSTRAINT `auditoria_sunat_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_auditoria_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresa_info` (`id`) ON DELETE CASCADE,
  CONSTRAINT `auditoria_sunat_chk_1` CHECK (json_valid(`request_headers`)),
  CONSTRAINT `auditoria_sunat_chk_2` CHECK (json_valid(`response_headers`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint unsigned NOT NULL,
  `fecha_baja` date NOT NULL,
  `fecha_generacion` date NOT NULL,
  `correlativo` int unsigned NOT NULL,
  `identificador` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad_comprobantes` int unsigned DEFAULT NULL,
  `xml_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cdr_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('PENDIENTE','ACEPTADO','RECHAZADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `codigo_sunat` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `fecha_procesamiento` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `baja_id` bigint unsigned NOT NULL,
  `comprobante_id` bigint unsigned NOT NULL,
  `tipo_comprobante` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serie` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero` int unsigned DEFAULT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `banner_oferta_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `descuento_porcentaje` decimal(5,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_banner_producto` (`banner_oferta_id`,`producto_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `banner_oferta_producto_ibfk_1` FOREIGN KEY (`banner_oferta_id`) REFERENCES `banners_ofertas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `banner_oferta_producto_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner_oferta_producto`
--

LOCK TABLES `banner_oferta_producto` WRITE;
/*!40000 ALTER TABLE `banner_oferta_producto` DISABLE KEYS */;
INSERT INTO `banner_oferta_producto` VALUES (6,1,117,10.00,'2025-12-15 19:37:40','2025-12-15 19:37:40'),(7,1,160,10.00,'2025-12-15 19:37:46','2025-12-15 19:37:46'),(8,1,216,10.00,'2025-12-15 19:37:53','2025-12-15 19:37:53'),(9,1,210,10.00,'2025-12-15 19:37:59','2025-12-15 19:37:59'),(10,1,215,10.00,'2025-12-15 19:38:07','2025-12-15 19:38:07'),(11,1,212,10.00,'2025-12-15 19:38:13','2025-12-15 19:38:13'),(12,1,226,10.00,'2025-12-15 19:38:24','2025-12-15 19:38:24');
/*!40000 ALTER TABLE `banner_oferta_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitulo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `texto_boton` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Explorar Tienda',
  `precio_desde` decimal(10,2) DEFAULT NULL,
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enlace_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '/shop',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `orden` int NOT NULL DEFAULT '0',
  `tipo_banner` enum('principal','horizontal','sidebar') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'principal' COMMENT 'Tipo de banner: principal (carrusel), horizontal (banners de página), sidebar (banners laterales verticales)',
  `posicion_horizontal` enum('debajo_ofertas_especiales','debajo_categorias','debajo_ventas_flash','sidebar_shop') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Posición del banner: para horizontales (debajo_*) o para sidebar (sidebar_shop)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `banners_activo_orden_index` (`activo`,`orden`) USING BTREE,
  KEY `idx_banners_tipo_posicion` (`tipo_banner`,`posicion_horizontal`,`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
INSERT INTO `banners` VALUES (9,'Banner 1766504696969',NULL,NULL,'Ver más',NULL,'banners/1766504696_694ab8f8e605c.png','/product-details/15',1,1,'principal',NULL,'2025-09-26 05:23:13','2025-12-23 15:44:56'),(10,'Banner 1766505795505',NULL,NULL,'Ver más',NULL,'banners/1766505795_694abd4353cbb.png','/shop',1,1,'principal',NULL,'2025-09-26 05:23:27','2025-12-23 16:03:15'),(13,'Banner 1766512869067',NULL,NULL,'Ver más',NULL,'banners/1766512869_694ad8e57bf56.png','/shop',1,1,'principal',NULL,'2025-09-26 05:45:43','2025-12-23 18:01:09'),(19,'Banner Sidebar Shop',NULL,NULL,'Ver más',NULL,'banners/1760324489_68ec6b89e3826.jpg','/shop',0,1,'sidebar','sidebar_shop','2025-10-12 20:01:29','2025-10-12 20:03:24'),(20,'Banner Sidebar Shop',NULL,NULL,'Ver más',NULL,'banners/1760324657_68ec6c3178d85.png','/shop',1,1,'sidebar','sidebar_shop','2025-10-12 20:04:17','2025-10-12 20:04:17'),(21,'Banner Debajo de Ofertas Especiales',NULL,NULL,'Ver más',NULL,'banners/1766499976_694aa6884104e.png','/shop',1,2,'horizontal','debajo_ofertas_especiales','2025-12-23 14:26:16','2025-12-23 14:26:16'),(22,'Banner Debajo de Categorías',NULL,NULL,'Ver más',NULL,'banners/1766500142_694aa72e4b726.png','/shop',1,1,'horizontal','debajo_categorias','2025-12-23 14:29:02','2025-12-23 14:29:02');
/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners_flash_sales`
--

DROP TABLE IF EXISTS `banners_flash_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners_flash_sales` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `color_badge` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT '#DC2626' COMMENT 'Color hexadecimal del badge del nombre',
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Imagen de fondo del banner flash sale',
  `color_boton` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Color hexadecimal del botón',
  `texto_boton` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Compra ahora',
  `enlace_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
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
INSERT INTO `banners_flash_sales` VALUES (1,'POR EL DIA DEL GAMER','#DC2626','2026-01-03 08:08:00','2026-01-06 03:08:00','banners_flash_sales/ijvbgmCVscyBeFF1EL4wnBiO4MzY5Xu5ehezI8xI.png','#3B82F6','Compra ahora','https://magus-ecommerce.com/product-details/86',0,'2025-10-06 09:08:44','2026-01-03 16:36:55');
/*!40000 ALTER TABLE `banners_flash_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners_ofertas`
--

DROP TABLE IF EXISTS `banners_ofertas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners_ofertas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `prioridad` int DEFAULT '0',
  `tipo` enum('especiales','semana') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'especiales' COMMENT 'Tipo de banner: especiales (Ofertas Especiales) o semana (Oferta de la Semana)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners_ofertas`
--

LOCK TABLES `banners_ofertas` WRITE;
/*!40000 ALTER TABLE `banners_ofertas` DISABLE KEYS */;
INSERT INTO `banners_ofertas` VALUES (1,'banners-ofertas/cFJxs3BETAwRm9LXTLxiE682DWQrtl2CLFHd92KU.gif',1,1,'especiales','2025-10-03 09:18:37','2025-12-15 19:37:28'),(2,'banners-ofertas/yD0z8Lh75E11IrLkqmRtWPnKZsnKSnq3bl9t7Jp2.png',1,0,'semana','2025-12-15 19:33:53','2025-12-15 19:34:19');
/*!40000 ALTER TABLE `banners_ofertas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners_promocionales`
--

DROP TABLE IF EXISTS `banners_promocionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners_promocionales` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `precio` decimal(8,2) DEFAULT NULL,
  `texto_boton` varchar(100) NOT NULL DEFAULT 'Comprar ahora',
  `imagen_url` varchar(500) DEFAULT NULL,
  `enlace_url` varchar(255) NOT NULL DEFAULT '/shop',
  `orden` int NOT NULL DEFAULT '1',
  `animacion_delay` int NOT NULL DEFAULT '400',
  `color_fondo` varchar(7) DEFAULT '#ffffff',
  `color_boton` varchar(7) DEFAULT '#0d6efd',
  `color_texto` varchar(7) DEFAULT '#212529',
  `color_badge_nombre` varchar(7) DEFAULT '#0d6efd',
  `color_badge_precio` varchar(7) DEFAULT '#28a745',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_activo_orden` (`activo`,`orden`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners_promocionales`
--

LOCK TABLES `banners_promocionales` WRITE;
/*!40000 ALTER TABLE `banners_promocionales` DISABLE KEYS */;
INSERT INTO `banners_promocionales` VALUES (2,'BARRA SONIDO RAZER',820.00,'Ir a la oferta','banners_promocionales/1758851690_68d5f26aac356.jpg','https://www.plazavea.com.pe/panaderia-y-pasteleria/pan-de-la-casa?srsltid=AfmBOoo9YK35mmSlRKy_JC302mvr-VBURC10nZC2iNz8dcDNSFqBIhL8',1,400,'#ffffff','#ff1100','#ffffff','#0d6efd','#28a745',1,'2025-06-07 11:49:44','2025-12-23 18:15:50'),(3,'LAPTOP ASUS TUF',2800.00,'Ir a la oferta','banners_promocionales/1766513883_694adcdb99260.jpg','/shop',1,300,'#ffea00','#fa0000','#000000','#0d6efd','#28a745',1,'2025-06-07 11:51:35','2025-12-23 18:18:40'),(4,'Teclado Razer',320.00,'Comprar ahora','banners_promocionales/1759766465_68e3e7c1ba405.jpg','/shop',1,300,'#ffffff','#0d6efd','#212529','#0d6efd','#28a745',1,'2025-06-07 11:53:48','2025-12-23 18:19:58'),(6,'GPU 4090',12490.00,'Comprar ahora','banners_promocionales/1759766731_68e3e8cb034f3.jpg','/shop',1,400,'#ffffff','#0d6efd','#212529','#0d6efd','#28a745',1,'2025-06-07 12:49:36','2025-12-23 18:20:53');
/*!40000 ALTER TABLE `banners_promocionales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel_cache_spatie.permission.cache','a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:334:{i:0;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:12:\"usuarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:1;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:15:\"usuarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:2;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:13:\"usuarios.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:3;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:13:\"usuarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:4;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:15:\"usuarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:5;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:13:\"productos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:6;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:16:\"productos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:7;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:14:\"productos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:8;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:14:\"productos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:9;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:16:\"productos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:10;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:14:\"categorias.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:11;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:17:\"categorias.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:12;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:15:\"categorias.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:13;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:15:\"categorias.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:14;a:4:{s:1:\"a\";i:29;s:1:\"b\";s:17:\"categorias.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:15;a:4:{s:1:\"a\";i:30;s:1:\"b\";s:11:\"banners.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:16;a:4:{s:1:\"a\";i:31;s:1:\"b\";s:14:\"banners.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:17;a:4:{s:1:\"a\";i:32;s:1:\"b\";s:12:\"banners.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:18;a:4:{s:1:\"a\";i:33;s:1:\"b\";s:14:\"banners.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:19;a:4:{s:1:\"a\";i:38;s:1:\"b\";s:25:\"banners_promocionales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:20;a:4:{s:1:\"a\";i:39;s:1:\"b\";s:28:\"banners_promocionales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:21;a:4:{s:1:\"a\";i:40;s:1:\"b\";s:26:\"banners_promocionales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:22;a:4:{s:1:\"a\";i:41;s:1:\"b\";s:28:\"banners_promocionales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:23;a:4:{s:1:\"a\";i:42;s:1:\"b\";s:12:\"clientes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:24;a:4:{s:1:\"a\";i:43;s:1:\"b\";s:15:\"clientes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:25;a:4:{s:1:\"a\";i:44;s:1:\"b\";s:13:\"clientes.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:26;a:4:{s:1:\"a\";i:45;s:1:\"b\";s:13:\"clientes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:27;a:4:{s:1:\"a\";i:46;s:1:\"b\";s:15:\"clientes.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:28;a:4:{s:1:\"a\";i:47;s:1:\"b\";s:13:\"marcas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:29;a:4:{s:1:\"a\";i:48;s:1:\"b\";s:13:\"marcas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:30;a:4:{s:1:\"a\";i:49;s:1:\"b\";s:11:\"marcas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:31;a:4:{s:1:\"a\";i:50;s:1:\"b\";s:10:\"marcas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:32;a:4:{s:1:\"a\";i:51;s:1:\"b\";s:14:\"pedidos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:33;a:4:{s:1:\"a\";i:52;s:1:\"b\";s:12:\"pedidos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:34;a:4:{s:1:\"a\";i:53;s:1:\"b\";s:12:\"pedidos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:35;a:4:{s:1:\"a\";i:54;s:1:\"b\";s:11:\"pedidos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:36;a:4:{s:1:\"a\";i:55;s:1:\"b\";s:16:\"secciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:37;a:4:{s:1:\"a\";i:56;s:1:\"b\";s:16:\"secciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:38;a:4:{s:1:\"a\";i:57;s:1:\"b\";s:14:\"secciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:39;a:4:{s:1:\"a\";i:58;s:1:\"b\";s:13:\"secciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:40;a:4:{s:1:\"a\";i:59;s:1:\"b\";s:11:\"cupones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:41;a:4:{s:1:\"a\";i:60;s:1:\"b\";s:12:\"cupones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:42;a:4:{s:1:\"a\";i:61;s:1:\"b\";s:12:\"cupones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:43;a:4:{s:1:\"a\";i:62;s:1:\"b\";s:14:\"cupones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:44;a:4:{s:1:\"a\";i:63;s:1:\"b\";s:14:\"cupones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:45;a:4:{s:1:\"a\";i:64;s:1:\"b\";s:11:\"ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:46;a:4:{s:1:\"a\";i:65;s:1:\"b\";s:12:\"ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:47;a:4:{s:1:\"a\";i:66;s:1:\"b\";s:12:\"ofertas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:48;a:4:{s:1:\"a\";i:67;s:1:\"b\";s:14:\"ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:49;a:4:{s:1:\"a\";i:68;s:1:\"b\";s:14:\"ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:50;a:4:{s:1:\"a\";i:69;s:1:\"b\";s:12:\"horarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:51;a:4:{s:1:\"a\";i:70;s:1:\"b\";s:15:\"horarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:52;a:4:{s:1:\"a\";i:71;s:1:\"b\";s:13:\"horarios.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:53;a:4:{s:1:\"a\";i:72;s:1:\"b\";s:13:\"horarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:54;a:4:{s:1:\"a\";i:73;s:1:\"b\";s:15:\"horarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:55;a:4:{s:1:\"a\";i:74;s:1:\"b\";s:16:\"empresa_info.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:56;a:4:{s:1:\"a\";i:75;s:1:\"b\";s:17:\"empresa_info.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:57;a:4:{s:1:\"a\";i:76;s:1:\"b\";s:17:\"envio_correos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:58;a:4:{s:1:\"a\";i:77;s:1:\"b\";s:18:\"envio_correos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:59;a:4:{s:1:\"a\";i:78;s:1:\"b\";s:12:\"reclamos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:60;a:4:{s:1:\"a\";i:79;s:1:\"b\";s:13:\"reclamos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:61;a:4:{s:1:\"a\";i:80;s:1:\"b\";s:13:\"reclamos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:62;a:4:{s:1:\"a\";i:81;s:1:\"b\";s:15:\"reclamos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:63;a:4:{s:1:\"a\";i:86;s:1:\"b\";s:16:\"cotizaciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:64;a:4:{s:1:\"a\";i:87;s:1:\"b\";s:17:\"cotizaciones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:65;a:4:{s:1:\"a\";i:88;s:1:\"b\";s:19:\"cotizaciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:66;a:4:{s:1:\"a\";i:89;s:1:\"b\";s:17:\"cotizaciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:67;a:4:{s:1:\"a\";i:90;s:1:\"b\";s:19:\"cotizaciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:68;a:4:{s:1:\"a\";i:91;s:1:\"b\";s:20:\"cotizaciones.aprobar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:69;a:4:{s:1:\"a\";i:92;s:1:\"b\";s:11:\"compras.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:70;a:4:{s:1:\"a\";i:93;s:1:\"b\";s:12:\"compras.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:71;a:4:{s:1:\"a\";i:94;s:1:\"b\";s:14:\"compras.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:72;a:4:{s:1:\"a\";i:95;s:1:\"b\";s:12:\"compras.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:73;a:4:{s:1:\"a\";i:96;s:1:\"b\";s:14:\"compras.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:74;a:4:{s:1:\"a\";i:97;s:1:\"b\";s:15:\"compras.aprobar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:75;a:4:{s:1:\"a\";i:98;s:1:\"b\";s:20:\"envio_correos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:76;a:4:{s:1:\"a\";i:99;s:1:\"b\";s:20:\"envio_correos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:77;a:4:{s:1:\"a\";i:100;s:1:\"b\";s:15:\"motorizados.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:78;a:4:{s:1:\"a\";i:101;s:1:\"b\";s:18:\"motorizados.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:79;a:4:{s:1:\"a\";i:102;s:1:\"b\";s:16:\"motorizados.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:80;a:4:{s:1:\"a\";i:103;s:1:\"b\";s:16:\"motorizados.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:81;a:4:{s:1:\"a\";i:104;s:1:\"b\";s:18:\"motorizados.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:82;a:4:{s:1:\"a\";i:105;s:1:\"b\";s:22:\"pedidos.motorizado.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:83;a:4:{s:1:\"a\";i:106;s:1:\"b\";s:22:\"pedidos.motorizado.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:84;a:4:{s:1:\"a\";i:107;s:1:\"b\";s:36:\"pedidos.motorizado.actualizar_estado\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:85;a:4:{s:1:\"a\";i:108;s:1:\"b\";s:36:\"pedidos.motorizado.actualizar_estado\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:86;a:4:{s:1:\"a\";i:109;s:1:\"b\";s:36:\"pedidos.motorizado.confirmar_entrega\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:87;a:4:{s:1:\"a\";i:110;s:1:\"b\";s:36:\"pedidos.motorizado.confirmar_entrega\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:88;a:4:{s:1:\"a\";i:111;s:1:\"b\";s:21:\"motorizado.perfil.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:89;a:4:{s:1:\"a\";i:112;s:1:\"b\";s:21:\"motorizado.perfil.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:90;a:4:{s:1:\"a\";i:113;s:1:\"b\";s:24:\"motorizado.perfil.editar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:91;a:4:{s:1:\"a\";i:114;s:1:\"b\";s:24:\"motorizado.perfil.editar\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:92;a:4:{s:1:\"a\";i:115;s:1:\"b\";s:20:\"motorizado.rutas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:93;a:4:{s:1:\"a\";i:116;s:1:\"b\";s:20:\"motorizado.rutas.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:94;a:4:{s:1:\"a\";i:117;s:1:\"b\";s:31:\"motorizado.ubicacion.actualizar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:95;a:4:{s:1:\"a\";i:118;s:1:\"b\";s:31:\"motorizado.ubicacion.actualizar\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:96;a:4:{s:1:\"a\";i:119;s:1:\"b\";s:27:\"motorizado.estadisticas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:97;a:4:{s:1:\"a\";i:120;s:1:\"b\";s:27:\"motorizado.estadisticas.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:98;a:4:{s:1:\"a\";i:121;s:1:\"b\";s:19:\"motorizado.chat.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:99;a:4:{s:1:\"a\";i:122;s:1:\"b\";s:19:\"motorizado.chat.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:100;a:4:{s:1:\"a\";i:123;s:1:\"b\";s:29:\"motorizado.notificaciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:101;a:4:{s:1:\"a\";i:124;s:1:\"b\";s:29:\"motorizado.notificaciones.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:102;a:4:{s:1:\"a\";i:125;s:1:\"b\";s:19:\"email_templates.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:103;a:4:{s:1:\"a\";i:126;s:1:\"b\";s:20:\"email_templates.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:104;a:4:{s:1:\"a\";i:127;s:1:\"b\";s:22:\"email_templates.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:105;a:4:{s:1:\"a\";i:128;s:1:\"b\";s:20:\"email_templates.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:106;a:4:{s:1:\"a\";i:129;s:1:\"b\";s:22:\"email_templates.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:107;a:4:{s:1:\"a\";i:130;s:1:\"b\";s:10:\"ventas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:108;a:4:{s:1:\"a\";i:131;s:1:\"b\";s:11:\"ventas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:109;a:4:{s:1:\"a\";i:132;s:1:\"b\";s:13:\"ventas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:110;a:4:{s:1:\"a\";i:133;s:1:\"b\";s:11:\"ventas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:111;a:4:{s:1:\"a\";i:134;s:1:\"b\";s:13:\"ventas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:112;a:4:{s:1:\"a\";i:135;s:1:\"b\";s:9:\"roles.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:113;a:4:{s:1:\"a\";i:136;s:1:\"b\";s:12:\"roles.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:114;a:4:{s:1:\"a\";i:137;s:1:\"b\";s:10:\"roles.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:115;a:4:{s:1:\"a\";i:138;s:1:\"b\";s:12:\"roles.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:116;a:4:{s:1:\"a\";i:139;s:1:\"b\";s:15:\"recompensas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:117;a:4:{s:1:\"a\";i:140;s:1:\"b\";s:18:\"recompensas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:118;a:4:{s:1:\"a\";i:141;s:1:\"b\";s:16:\"recompensas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:119;a:4:{s:1:\"a\";i:142;s:1:\"b\";s:16:\"recompensas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:120;a:4:{s:1:\"a\";i:143;s:1:\"b\";s:18:\"recompensas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:121;a:4:{s:1:\"a\";i:144;s:1:\"b\";s:20:\"recompensas.activate\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:122;a:4:{s:1:\"a\";i:145;s:1:\"b\";s:21:\"recompensas.analytics\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:123;a:4:{s:1:\"a\";i:146;s:1:\"b\";s:21:\"recompensas.segmentos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:124;a:4:{s:1:\"a\";i:147;s:1:\"b\";s:21:\"recompensas.productos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:125;a:4:{s:1:\"a\";i:148;s:1:\"b\";s:18:\"recompensas.puntos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:126;a:4:{s:1:\"a\";i:149;s:1:\"b\";s:22:\"recompensas.descuentos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:127;a:4:{s:1:\"a\";i:150;s:1:\"b\";s:18:\"recompensas.envios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:128;a:4:{s:1:\"a\";i:151;s:1:\"b\";s:19:\"recompensas.regalos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:129;a:4:{s:1:\"a\";i:152;s:1:\"b\";s:17:\"configuracion.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:130;a:4:{s:1:\"a\";i:153;s:1:\"b\";s:20:\"configuracion.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:131;a:4:{s:1:\"a\";i:154;s:1:\"b\";s:18:\"configuracion.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:132;a:4:{s:1:\"a\";i:155;s:1:\"b\";s:20:\"configuracion.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:133;a:4:{s:1:\"a\";i:156;s:1:\"b\";s:23:\"banners_flash_sales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:134;a:4:{s:1:\"a\";i:157;s:1:\"b\";s:26:\"banners_flash_sales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:135;a:4:{s:1:\"a\";i:158;s:1:\"b\";s:24:\"banners_flash_sales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:136;a:4:{s:1:\"a\";i:159;s:1:\"b\";s:26:\"banners_flash_sales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:137;a:4:{s:1:\"a\";i:160;s:1:\"b\";s:19:\"banners_ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:138;a:4:{s:1:\"a\";i:161;s:1:\"b\";s:22:\"banners_ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:139;a:4:{s:1:\"a\";i:162;s:1:\"b\";s:20:\"banners_ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:140;a:4:{s:1:\"a\";i:163;s:1:\"b\";s:22:\"banners_ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:141;a:4:{s:1:\"a\";i:164;s:1:\"b\";s:22:\"contabilidad.cajas.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:142;a:4:{s:1:\"a\";i:165;s:1:\"b\";s:25:\"contabilidad.cajas.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:143;a:4:{s:1:\"a\";i:166;s:1:\"b\";s:23:\"contabilidad.cajas.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:144;a:4:{s:1:\"a\";i:167;s:1:\"b\";s:23:\"contabilidad.kardex.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:145;a:4:{s:1:\"a\";i:168;s:1:\"b\";s:24:\"contabilidad.kardex.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:146;a:4:{s:1:\"a\";i:169;s:1:\"b\";s:20:\"contabilidad.cxc.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:147;a:4:{s:1:\"a\";i:170;s:1:\"b\";s:23:\"contabilidad.cxc.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:148;a:4:{s:1:\"a\";i:171;s:1:\"b\";s:21:\"contabilidad.cxc.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:149;a:4:{s:1:\"a\";i:172;s:1:\"b\";s:20:\"contabilidad.cxp.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:150;a:4:{s:1:\"a\";i:173;s:1:\"b\";s:23:\"contabilidad.cxp.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:151;a:4:{s:1:\"a\";i:174;s:1:\"b\";s:21:\"contabilidad.cxp.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:152;a:4:{s:1:\"a\";i:175;s:1:\"b\";s:28:\"contabilidad.proveedores.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:153;a:4:{s:1:\"a\";i:176;s:1:\"b\";s:31:\"contabilidad.proveedores.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:154;a:4:{s:1:\"a\";i:177;s:1:\"b\";s:29:\"contabilidad.proveedores.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:8;}}i:155;a:4:{s:1:\"a\";i:178;s:1:\"b\";s:27:\"contabilidad.caja_chica.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:156;a:4:{s:1:\"a\";i:179;s:1:\"b\";s:30:\"contabilidad.caja_chica.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:157;a:4:{s:1:\"a\";i:180;s:1:\"b\";s:28:\"contabilidad.caja_chica.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:158;a:4:{s:1:\"a\";i:181;s:1:\"b\";s:27:\"contabilidad.flujo_caja.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:159;a:4:{s:1:\"a\";i:182;s:1:\"b\";s:30:\"contabilidad.flujo_caja.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:160;a:4:{s:1:\"a\";i:183;s:1:\"b\";s:28:\"contabilidad.flujo_caja.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:161;a:4:{s:1:\"a\";i:184;s:1:\"b\";s:25:\"contabilidad.reportes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:162;a:4:{s:1:\"a\";i:185;s:1:\"b\";s:27:\"contabilidad.utilidades.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:163;a:4:{s:1:\"a\";i:186;s:1:\"b\";s:30:\"contabilidad.utilidades.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:164;a:4:{s:1:\"a\";i:187;s:1:\"b\";s:28:\"contabilidad.utilidades.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:165;a:4:{s:1:\"a\";i:188;s:1:\"b\";s:25:\"contabilidad.vouchers.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:166;a:4:{s:1:\"a\";i:189;s:1:\"b\";s:28:\"contabilidad.vouchers.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:167;a:4:{s:1:\"a\";i:190;s:1:\"b\";s:26:\"contabilidad.vouchers.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:168;a:4:{s:1:\"a\";i:191;s:1:\"b\";s:28:\"contabilidad.vouchers.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:169;a:4:{s:1:\"a\";i:192;s:1:\"b\";s:28:\"facturacion.comprobantes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:170;a:4:{s:1:\"a\";i:193;s:1:\"b\";s:28:\"facturacion.comprobantes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:171;a:4:{s:1:\"a\";i:194;s:1:\"b\";s:29:\"facturacion.comprobantes.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:172;a:4:{s:1:\"a\";i:195;s:1:\"b\";s:29:\"facturacion.comprobantes.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:173;a:4:{s:1:\"a\";i:196;s:1:\"b\";s:31:\"facturacion.comprobantes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:174;a:4:{s:1:\"a\";i:197;s:1:\"b\";s:31:\"facturacion.comprobantes.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:175;a:4:{s:1:\"a\";i:198;s:1:\"b\";s:29:\"facturacion.comprobantes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:176;a:4:{s:1:\"a\";i:199;s:1:\"b\";s:29:\"facturacion.comprobantes.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:177;a:4:{s:1:\"a\";i:200;s:1:\"b\";s:31:\"facturacion.comprobantes.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:178;a:4:{s:1:\"a\";i:201;s:1:\"b\";s:31:\"facturacion.comprobantes.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:179;a:4:{s:1:\"a\";i:202;s:1:\"b\";s:24:\"facturacion.facturas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:180;a:4:{s:1:\"a\";i:203;s:1:\"b\";s:24:\"facturacion.facturas.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:181;a:4:{s:1:\"a\";i:204;s:1:\"b\";s:25:\"facturacion.facturas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:182;a:4:{s:1:\"a\";i:205;s:1:\"b\";s:25:\"facturacion.facturas.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:183;a:4:{s:1:\"a\";i:206;s:1:\"b\";s:27:\"facturacion.facturas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:184;a:4:{s:1:\"a\";i:207;s:1:\"b\";s:27:\"facturacion.facturas.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:185;a:4:{s:1:\"a\";i:208;s:1:\"b\";s:25:\"facturacion.facturas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:186;a:4:{s:1:\"a\";i:209;s:1:\"b\";s:25:\"facturacion.facturas.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:187;a:4:{s:1:\"a\";i:210;s:1:\"b\";s:22:\"facturacion.series.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:188;a:4:{s:1:\"a\";i:211;s:1:\"b\";s:22:\"facturacion.series.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:189;a:4:{s:1:\"a\";i:212;s:1:\"b\";s:25:\"facturacion.series.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:190;a:4:{s:1:\"a\";i:213;s:1:\"b\";s:25:\"facturacion.series.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:191;a:4:{s:1:\"a\";i:214;s:1:\"b\";s:23:\"facturacion.series.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:192;a:4:{s:1:\"a\";i:215;s:1:\"b\";s:23:\"facturacion.series.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:193;a:4:{s:1:\"a\";i:216;s:1:\"b\";s:29:\"facturacion.notas_credito.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:194;a:4:{s:1:\"a\";i:217;s:1:\"b\";s:29:\"facturacion.notas_credito.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:195;a:4:{s:1:\"a\";i:218;s:1:\"b\";s:30:\"facturacion.notas_credito.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:196;a:4:{s:1:\"a\";i:219;s:1:\"b\";s:30:\"facturacion.notas_credito.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:197;a:4:{s:1:\"a\";i:220;s:1:\"b\";s:32:\"facturacion.notas_credito.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:198;a:4:{s:1:\"a\";i:221;s:1:\"b\";s:32:\"facturacion.notas_credito.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:199;a:4:{s:1:\"a\";i:222;s:1:\"b\";s:30:\"facturacion.notas_credito.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:200;a:4:{s:1:\"a\";i:223;s:1:\"b\";s:30:\"facturacion.notas_credito.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:201;a:4:{s:1:\"a\";i:224;s:1:\"b\";s:28:\"facturacion.notas_debito.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:202;a:4:{s:1:\"a\";i:225;s:1:\"b\";s:28:\"facturacion.notas_debito.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:203;a:4:{s:1:\"a\";i:226;s:1:\"b\";s:29:\"facturacion.notas_debito.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:204;a:4:{s:1:\"a\";i:227;s:1:\"b\";s:29:\"facturacion.notas_debito.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:205;a:4:{s:1:\"a\";i:228;s:1:\"b\";s:31:\"facturacion.notas_debito.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:206;a:4:{s:1:\"a\";i:229;s:1:\"b\";s:31:\"facturacion.notas_debito.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:207;a:4:{s:1:\"a\";i:230;s:1:\"b\";s:29:\"facturacion.notas_debito.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:208;a:4:{s:1:\"a\";i:231;s:1:\"b\";s:29:\"facturacion.notas_debito.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:209;a:4:{s:1:\"a\";i:232;s:1:\"b\";s:30:\"facturacion.guias_remision.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:210;a:4:{s:1:\"a\";i:233;s:1:\"b\";s:30:\"facturacion.guias_remision.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:211;a:4:{s:1:\"a\";i:234;s:1:\"b\";s:31:\"facturacion.guias_remision.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:212;a:4:{s:1:\"a\";i:235;s:1:\"b\";s:31:\"facturacion.guias_remision.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:213;a:4:{s:1:\"a\";i:236;s:1:\"b\";s:33:\"facturacion.guias_remision.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:214;a:4:{s:1:\"a\";i:237;s:1:\"b\";s:33:\"facturacion.guias_remision.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:215;a:4:{s:1:\"a\";i:238;s:1:\"b\";s:31:\"facturacion.guias_remision.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:216;a:4:{s:1:\"a\";i:239;s:1:\"b\";s:31:\"facturacion.guias_remision.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:217;a:4:{s:1:\"a\";i:240;s:1:\"b\";s:28:\"facturacion.certificados.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:218;a:4:{s:1:\"a\";i:241;s:1:\"b\";s:28:\"facturacion.certificados.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:219;a:4:{s:1:\"a\";i:242;s:1:\"b\";s:31:\"facturacion.certificados.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:220;a:4:{s:1:\"a\";i:243;s:1:\"b\";s:31:\"facturacion.certificados.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:221;a:4:{s:1:\"a\";i:244;s:1:\"b\";s:29:\"facturacion.certificados.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:222;a:4:{s:1:\"a\";i:245;s:1:\"b\";s:29:\"facturacion.certificados.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:223;a:4:{s:1:\"a\";i:246;s:1:\"b\";s:31:\"facturacion.certificados.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:224;a:4:{s:1:\"a\";i:247;s:1:\"b\";s:31:\"facturacion.certificados.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:225;a:4:{s:1:\"a\";i:248;s:1:\"b\";s:25:\"facturacion.resumenes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:226;a:4:{s:1:\"a\";i:249;s:1:\"b\";s:25:\"facturacion.resumenes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:227;a:4:{s:1:\"a\";i:250;s:1:\"b\";s:28:\"facturacion.resumenes.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:228;a:4:{s:1:\"a\";i:251;s:1:\"b\";s:28:\"facturacion.resumenes.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:229;a:4:{s:1:\"a\";i:252;s:1:\"b\";s:26:\"facturacion.resumenes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:230;a:4:{s:1:\"a\";i:253;s:1:\"b\";s:26:\"facturacion.resumenes.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:231;a:4:{s:1:\"a\";i:254;s:1:\"b\";s:21:\"facturacion.bajas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:232;a:4:{s:1:\"a\";i:255;s:1:\"b\";s:21:\"facturacion.bajas.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:233;a:4:{s:1:\"a\";i:256;s:1:\"b\";s:24:\"facturacion.bajas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:234;a:4:{s:1:\"a\";i:257;s:1:\"b\";s:24:\"facturacion.bajas.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:235;a:4:{s:1:\"a\";i:258;s:1:\"b\";s:22:\"facturacion.bajas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:236;a:4:{s:1:\"a\";i:259;s:1:\"b\";s:22:\"facturacion.bajas.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:237;a:4:{s:1:\"a\";i:260;s:1:\"b\";s:25:\"facturacion.auditoria.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:238;a:4:{s:1:\"a\";i:261;s:1:\"b\";s:25:\"facturacion.auditoria.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:239;a:4:{s:1:\"a\";i:262;s:1:\"b\";s:26:\"facturacion.reintentos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:240;a:4:{s:1:\"a\";i:263;s:1:\"b\";s:26:\"facturacion.reintentos.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:241;a:4:{s:1:\"a\";i:264;s:1:\"b\";s:27:\"facturacion.reintentos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:242;a:4:{s:1:\"a\";i:265;s:1:\"b\";s:27:\"facturacion.reintentos.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:243;a:4:{s:1:\"a\";i:266;s:1:\"b\";s:25:\"facturacion.catalogos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:244;a:4:{s:1:\"a\";i:267;s:1:\"b\";s:25:\"facturacion.catalogos.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:245;a:4:{s:1:\"a\";i:268;s:1:\"b\";s:23:\"facturacion.empresa.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:246;a:4:{s:1:\"a\";i:269;s:1:\"b\";s:23:\"facturacion.empresa.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:247;a:4:{s:1:\"a\";i:270;s:1:\"b\";s:24:\"facturacion.empresa.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:248;a:4:{s:1:\"a\";i:271;s:1:\"b\";s:24:\"facturacion.empresa.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:249;a:4:{s:1:\"a\";i:272;s:1:\"b\";s:28:\"facturacion.contingencia.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:250;a:4:{s:1:\"a\";i:273;s:1:\"b\";s:28:\"facturacion.contingencia.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:251;a:4:{s:1:\"a\";i:274;s:1:\"b\";s:29:\"facturacion.contingencia.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:252;a:4:{s:1:\"a\";i:275;s:1:\"b\";s:29:\"facturacion.contingencia.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:253;a:4:{s:1:\"a\";i:276;s:1:\"b\";s:24:\"facturacion.reportes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:254;a:4:{s:1:\"a\";i:277;s:1:\"b\";s:24:\"facturacion.reportes.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:255;a:4:{s:1:\"a\";i:278;s:1:\"b\";s:21:\"facturacion.pagos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:256;a:4:{s:1:\"a\";i:279;s:1:\"b\";s:21:\"facturacion.pagos.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:257;a:4:{s:1:\"a\";i:280;s:1:\"b\";s:22:\"facturacion.pagos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:258;a:4:{s:1:\"a\";i:281;s:1:\"b\";s:22:\"facturacion.pagos.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:259;a:4:{s:1:\"a\";i:282;s:1:\"b\";s:24:\"facturacion.pagos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:260;a:4:{s:1:\"a\";i:283;s:1:\"b\";s:24:\"facturacion.pagos.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:2:{i:0;i:6;i:1;i:7;}}i:261;a:4:{s:1:\"a\";i:284;s:1:\"b\";s:22:\"facturacion.pagos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:262;a:4:{s:1:\"a\";i:285;s:1:\"b\";s:22:\"facturacion.pagos.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:263;a:4:{s:1:\"a\";i:286;s:1:\"b\";s:24:\"facturacion.pagos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:264;a:4:{s:1:\"a\";i:287;s:1:\"b\";s:24:\"facturacion.pagos.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:265;a:4:{s:1:\"a\";i:288;s:1:\"b\";s:32:\"facturacion.historial_envios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:266;a:4:{s:1:\"a\";i:289;s:1:\"b\";s:32:\"facturacion.historial_envios.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:267;a:4:{s:1:\"a\";i:290;s:1:\"b\";s:33:\"facturacion.historial_envios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:268;a:4:{s:1:\"a\";i:291;s:1:\"b\";s:33:\"facturacion.historial_envios.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:269;a:4:{s:1:\"a\";i:292;s:1:\"b\";s:35:\"facturacion.historial_envios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:270;a:4:{s:1:\"a\";i:293;s:1:\"b\";s:35:\"facturacion.historial_envios.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:271;a:4:{s:1:\"a\";i:294;s:1:\"b\";s:20:\"facturacion.logs.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:272;a:4:{s:1:\"a\";i:295;s:1:\"b\";s:20:\"facturacion.logs.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:273;a:4:{s:1:\"a\";i:296;s:1:\"b\";s:23:\"facturacion.logs.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:274;a:4:{s:1:\"a\";i:297;s:1:\"b\";s:23:\"facturacion.logs.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:275;a:4:{s:1:\"a\";i:298;s:1:\"b\";s:21:\"facturacion.logs.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:276;a:4:{s:1:\"a\";i:299;s:1:\"b\";s:21:\"facturacion.logs.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:277;a:4:{s:1:\"a\";i:300;s:1:\"b\";s:23:\"facturacion.logs.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:278;a:4:{s:1:\"a\";i:301;s:1:\"b\";s:23:\"facturacion.logs.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:279;a:4:{s:1:\"a\";i:302;s:1:\"b\";s:29:\"facturacion.configuracion.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:280;a:4:{s:1:\"a\";i:303;s:1:\"b\";s:29:\"facturacion.configuracion.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:281;a:4:{s:1:\"a\";i:304;s:1:\"b\";s:30:\"facturacion.configuracion.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:282;a:4:{s:1:\"a\";i:305;s:1:\"b\";s:30:\"facturacion.configuracion.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:283;a:4:{s:1:\"a\";i:306;s:1:\"b\";s:29:\"facturacion.integraciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:284;a:4:{s:1:\"a\";i:307;s:1:\"b\";s:29:\"facturacion.integraciones.ver\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:285;a:4:{s:1:\"a\";i:308;s:1:\"b\";s:30:\"facturacion.integraciones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:286;a:4:{s:1:\"a\";i:309;s:1:\"b\";s:30:\"facturacion.integraciones.show\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:287;a:4:{s:1:\"a\";i:310;s:1:\"b\";s:32:\"facturacion.integraciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:288;a:4:{s:1:\"a\";i:311;s:1:\"b\";s:32:\"facturacion.integraciones.create\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:289;a:4:{s:1:\"a\";i:312;s:1:\"b\";s:30:\"facturacion.integraciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:290;a:4:{s:1:\"a\";i:313;s:1:\"b\";s:30:\"facturacion.integraciones.edit\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:291;a:4:{s:1:\"a\";i:314;s:1:\"b\";s:32:\"facturacion.integraciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:292;a:4:{s:1:\"a\";i:315;s:1:\"b\";s:32:\"facturacion.integraciones.delete\";s:1:\"c\";s:3:\"api\";s:1:\"r\";a:1:{i:0;i:6;}}i:293;a:4:{s:1:\"a\";i:316;s:1:\"b\";s:18:\"recompensas.popups\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:294;a:4:{s:1:\"a\";i:317;s:1:\"b\";s:26:\"recompensas.notificaciones\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:295;a:3:{s:1:\"a\";i:318;s:1:\"b\";s:15:\"ventas.facturar\";s:1:\"c\";s:3:\"api\";}i:296;a:4:{s:1:\"a\";i:319;s:1:\"b\";s:15:\"ventas.facturar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:297;a:4:{s:1:\"a\";i:320;s:1:\"b\";s:16:\"pasos_envio.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:298;a:3:{s:1:\"a\";i:321;s:1:\"b\";s:24:\"contabilidad.cajas.crear\";s:1:\"c\";s:3:\"api\";}i:299;a:3:{s:1:\"a\";i:322;s:1:\"b\";s:25:\"contabilidad.cajas.editar\";s:1:\"c\";s:3:\"api\";}i:300;a:3:{s:1:\"a\";i:323;s:1:\"b\";s:28:\"contabilidad.cajas.aperturar\";s:1:\"c\";s:3:\"api\";}i:301;a:3:{s:1:\"a\";i:324;s:1:\"b\";s:25:\"contabilidad.cajas.cerrar\";s:1:\"c\";s:3:\"api\";}i:302;a:3:{s:1:\"a\";i:325;s:1:\"b\";s:32:\"contabilidad.cajas.transaccionar\";s:1:\"c\";s:3:\"api\";}i:303;a:3:{s:1:\"a\";i:326;s:1:\"b\";s:27:\"contabilidad.cajas.reportes\";s:1:\"c\";s:3:\"api\";}i:304;a:3:{s:1:\"a\";i:327;s:1:\"b\";s:27:\"contabilidad.kardex.ajustar\";s:1:\"c\";s:3:\"api\";}i:305;a:3:{s:1:\"a\";i:328;s:1:\"b\";s:31:\"contabilidad.cuentas-cobrar.ver\";s:1:\"c\";s:3:\"api\";}i:306;a:3:{s:1:\"a\";i:329;s:1:\"b\";s:33:\"contabilidad.cuentas-cobrar.crear\";s:1:\"c\";s:3:\"api\";}i:307;a:3:{s:1:\"a\";i:330;s:1:\"b\";s:33:\"contabilidad.cuentas-cobrar.pagar\";s:1:\"c\";s:3:\"api\";}i:308;a:3:{s:1:\"a\";i:331;s:1:\"b\";s:36:\"contabilidad.cuentas-cobrar.reportes\";s:1:\"c\";s:3:\"api\";}i:309;a:3:{s:1:\"a\";i:332;s:1:\"b\";s:30:\"contabilidad.cuentas-pagar.ver\";s:1:\"c\";s:3:\"api\";}i:310;a:3:{s:1:\"a\";i:333;s:1:\"b\";s:32:\"contabilidad.cuentas-pagar.crear\";s:1:\"c\";s:3:\"api\";}i:311;a:3:{s:1:\"a\";i:334;s:1:\"b\";s:33:\"contabilidad.cuentas-pagar.editar\";s:1:\"c\";s:3:\"api\";}i:312;a:3:{s:1:\"a\";i:335;s:1:\"b\";s:35:\"contabilidad.cuentas-pagar.eliminar\";s:1:\"c\";s:3:\"api\";}i:313;a:3:{s:1:\"a\";i:336;s:1:\"b\";s:32:\"contabilidad.cuentas-pagar.pagar\";s:1:\"c\";s:3:\"api\";}i:314;a:3:{s:1:\"a\";i:337;s:1:\"b\";s:35:\"contabilidad.cuentas-pagar.reportes\";s:1:\"c\";s:3:\"api\";}i:315;a:3:{s:1:\"a\";i:338;s:1:\"b\";s:22:\"contabilidad.cajas.ver\";s:1:\"c\";s:3:\"web\";}i:316;a:3:{s:1:\"a\";i:339;s:1:\"b\";s:24:\"contabilidad.cajas.crear\";s:1:\"c\";s:3:\"web\";}i:317;a:3:{s:1:\"a\";i:340;s:1:\"b\";s:25:\"contabilidad.cajas.editar\";s:1:\"c\";s:3:\"web\";}i:318;a:3:{s:1:\"a\";i:341;s:1:\"b\";s:28:\"contabilidad.cajas.aperturar\";s:1:\"c\";s:3:\"web\";}i:319;a:3:{s:1:\"a\";i:342;s:1:\"b\";s:25:\"contabilidad.cajas.cerrar\";s:1:\"c\";s:3:\"web\";}i:320;a:3:{s:1:\"a\";i:343;s:1:\"b\";s:32:\"contabilidad.cajas.transaccionar\";s:1:\"c\";s:3:\"web\";}i:321;a:3:{s:1:\"a\";i:344;s:1:\"b\";s:27:\"contabilidad.cajas.reportes\";s:1:\"c\";s:3:\"web\";}i:322;a:3:{s:1:\"a\";i:345;s:1:\"b\";s:23:\"contabilidad.kardex.ver\";s:1:\"c\";s:3:\"web\";}i:323;a:3:{s:1:\"a\";i:346;s:1:\"b\";s:27:\"contabilidad.kardex.ajustar\";s:1:\"c\";s:3:\"web\";}i:324;a:3:{s:1:\"a\";i:347;s:1:\"b\";s:31:\"contabilidad.cuentas-cobrar.ver\";s:1:\"c\";s:3:\"web\";}i:325;a:3:{s:1:\"a\";i:348;s:1:\"b\";s:33:\"contabilidad.cuentas-cobrar.crear\";s:1:\"c\";s:3:\"web\";}i:326;a:3:{s:1:\"a\";i:349;s:1:\"b\";s:33:\"contabilidad.cuentas-cobrar.pagar\";s:1:\"c\";s:3:\"web\";}i:327;a:3:{s:1:\"a\";i:350;s:1:\"b\";s:36:\"contabilidad.cuentas-cobrar.reportes\";s:1:\"c\";s:3:\"web\";}i:328;a:3:{s:1:\"a\";i:351;s:1:\"b\";s:30:\"contabilidad.cuentas-pagar.ver\";s:1:\"c\";s:3:\"web\";}i:329;a:3:{s:1:\"a\";i:352;s:1:\"b\";s:32:\"contabilidad.cuentas-pagar.crear\";s:1:\"c\";s:3:\"web\";}i:330;a:3:{s:1:\"a\";i:353;s:1:\"b\";s:33:\"contabilidad.cuentas-pagar.editar\";s:1:\"c\";s:3:\"web\";}i:331;a:3:{s:1:\"a\";i:354;s:1:\"b\";s:35:\"contabilidad.cuentas-pagar.eliminar\";s:1:\"c\";s:3:\"web\";}i:332;a:3:{s:1:\"a\";i:355;s:1:\"b\";s:32:\"contabilidad.cuentas-pagar.pagar\";s:1:\"c\";s:3:\"web\";}i:333;a:3:{s:1:\"a\";i:356;s:1:\"b\";s:35:\"contabilidad.cuentas-pagar.reportes\";s:1:\"c\";s:3:\"web\";}}s:5:\"roles\";a:8:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:10:\"superadmin\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:3;s:1:\"b\";s:8:\"vendedor\";s:1:\"c\";s:3:\"web\";}i:2;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:5:\"admin\";s:1:\"c\";s:3:\"web\";}i:3;a:3:{s:1:\"a\";i:4;s:1:\"b\";s:10:\"motorizado\";s:1:\"c\";s:3:\"web\";}i:4;a:3:{s:1:\"a\";i:5;s:1:\"b\";s:14:\"motorizado-app\";s:1:\"c\";s:7:\"sanctum\";}i:5;a:3:{s:1:\"a\";i:6;s:1:\"b\";s:8:\"Contador\";s:1:\"c\";s:3:\"api\";}i:6;a:3:{s:1:\"a\";i:7;s:1:\"b\";s:6:\"Cajero\";s:1:\"c\";s:3:\"api\";}i:7;a:3:{s:1:\"a\";i:8;s:1:\"b\";s:7:\"Compras\";s:1:\"c\";s:3:\"api\";}}}',1768019597);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fondo_fijo` decimal(12,2) NOT NULL,
  `saldo_actual` decimal(12,2) NOT NULL,
  `responsable_id` bigint unsigned NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `caja_chica_id` bigint unsigned NOT NULL,
  `tipo` enum('GASTO','REPOSICION') COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `categoria` enum('VIATICOS','UTILES_OFICINA','SERVICIOS','MANTENIMIENTO','TRANSPORTE','OTROS') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Categoría del gasto',
  `comprobante_tipo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comprobante_numero` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `proveedor` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `archivo_adjunto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('PENDIENTE','APROBADO','RECHAZADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `user_id` bigint unsigned NOT NULL,
  `aprobado_por` bigint unsigned DEFAULT NULL,
  `aprobado_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_chica_movimientos_user_id_foreign` (`user_id`),
  KEY `caja_chica_movimientos_aprobado_por_foreign` (`aprobado_por`),
  KEY `caja_chica_movimientos_caja_chica_id_fecha_index` (`caja_chica_id`,`fecha`),
  KEY `caja_chica_movimientos_estado_index` (`estado`),
  KEY `idx_caja_chica_mov_estado` (`estado`,`caja_chica_id`),
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `caja_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `monto_inicial` decimal(12,2) NOT NULL DEFAULT '0.00',
  `monto_final` decimal(12,2) DEFAULT NULL,
  `monto_sistema` decimal(12,2) DEFAULT NULL,
  `diferencia` decimal(12,2) DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `estado` enum('ABIERTA','CERRADA') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ABIERTA',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_movimientos_user_id_foreign` (`user_id`),
  KEY `caja_movimientos_caja_id_fecha_index` (`caja_id`,`fecha`),
  KEY `caja_movimientos_estado_index` (`estado`),
  KEY `idx_caja_movimientos_estado_caja` (`estado`,`caja_id`),
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `caja_movimiento_id` bigint unsigned NOT NULL,
  `tipo` enum('INGRESO','EGRESO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` enum('VENTA','COBRO','GASTO','RETIRO','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `comprobante_id` bigint unsigned DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tienda_id` bigint unsigned NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cajas_codigo_unique` (`codigo`),
  KEY `cajas_tienda_id_foreign` (`tienda_id`),
  KEY `idx_cajas_tienda_activo` (`tienda_id`,`activo`),
  CONSTRAINT `cajas_tienda_id_foreign` FOREIGN KEY (`tienda_id`) REFERENCES `tiendas` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'ID del usuario del sistema (admin, vendedor)',
  `user_cliente_id` bigint unsigned DEFAULT NULL COMMENT 'ID del cliente del e-commerce',
  `producto_id` bigint unsigned NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL DEFAULT '0.00',
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
  CONSTRAINT `check_user_type` CHECK ((((`user_id` is not null) and (`user_cliente_id` is null)) or ((`user_id` is null) and (`user_cliente_id` is not null))))
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (50,NULL,36,207,1,145.00,NULL,'2025-12-12 21:46:18','2025-12-12 21:46:18'),(51,1,NULL,186,1,860.00,NULL,'2025-12-12 21:46:33','2025-12-12 21:46:33'),(52,1,NULL,207,1,145.00,NULL,'2025-12-12 21:47:32','2025-12-12 21:47:32'),(54,NULL,49,294,1,1430.00,NULL,'2026-01-02 16:14:00','2026-01-02 16:14:43'),(55,NULL,49,292,1,463.00,NULL,'2026-01-02 16:14:23','2026-01-02 16:14:49'),(56,1,NULL,141,1,270.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(57,1,NULL,172,1,600.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(58,1,NULL,272,1,1670.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(59,1,NULL,285,1,478.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(60,1,NULL,219,1,620.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(61,1,NULL,243,1,270.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(62,1,NULL,293,1,480.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(63,1,NULL,115,1,200.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05'),(64,1,NULL,259,1,117.00,NULL,'2026-01-03 16:53:05','2026-01-03 16:53:05');
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogos_sunat`
--

DROP TABLE IF EXISTS `catalogos_sunat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogos_sunat` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `catalogo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_corta` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadatos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_catalogo_codigo` (`catalogo`,`codigo`),
  KEY `idx_catalogo` (`catalogo`),
  KEY `idx_activo` (`activo`),
  CONSTRAINT `catalogos_sunat_chk_1` CHECK (json_valid(`metadatos`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `categoria_principal_id` bigint unsigned NOT NULL,
  `categoria_compatible_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_seccion` int DEFAULT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_categoria_seccion` (`id_seccion`) USING BTREE,
  CONSTRAINT `fk_categoria_seccion` FOREIGN KEY (`id_seccion`) REFERENCES `secciones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (11,1,'Memoria RAM',NULL,'1758851506_68d5f1b25b941.png',1,'2025-07-18 07:47:49','2025-10-01 12:29:59'),(13,1,'Discos',NULL,'1758851433_68d5f1692d93c.png',1,'2025-07-18 07:48:12','2025-09-25 18:50:33'),(17,3,'Mouse',NULL,'1759185236_68db0954a9998.png',1,'2025-09-29 15:33:56','2025-09-29 15:33:56'),(18,1,'Placa Madre',NULL,'1759185526_68db0a76ca3bc.png',1,'2025-09-29 15:38:46','2025-09-29 15:38:46'),(19,1,'Procesador',NULL,'1759185621_68db0ad576a43.png',1,'2025-09-29 15:40:21','2025-09-29 15:40:21'),(20,1,'Tarjeta Gráfica',NULL,'1759185700_68db0b249fdc6.png',1,'2025-09-29 15:41:40','2025-09-29 15:41:40'),(21,1,'Case Gamer',NULL,'1759185867_68db0bcb6afb3.png',1,'2025-09-29 15:44:27','2025-09-29 15:44:27'),(22,3,'Teclado',NULL,'1759334418_68dd50125b9c2.webp',1,'2025-10-01 09:00:18','2025-10-01 09:00:18'),(23,1,'Refrigeración Liquida',NULL,'1759337230_68dd5b0e93437.jpg',1,'2025-10-01 09:47:10','2025-10-01 09:47:10'),(24,3,'Monitor','Monitores Gaming y de  Hogar.','1760454665_68ee6809ede7d.jpg',1,'2025-10-14 08:11:05','2025-10-14 08:11:05'),(25,2,'Laptop','Las mejores Laptop Gaming','1766586053_694bf6c558417.png',1,'2025-12-24 14:05:25','2025-12-24 14:20:53');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificados`
--

DROP TABLE IF EXISTS `certificados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificados` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint unsigned NOT NULL,
  `nombre_archivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruta_archivo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_cifrado` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `propietario` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emisor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_serie` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_vencimiento` date NOT NULL,
  `tamanio_bytes` int unsigned DEFAULT NULL,
  `hash_sha256` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('activo','vencido','revocado') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '1=DNI, 6=RUC, 4=CE, 7=PASAPORTE',
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre completo o razón social',
  `nombre_comercial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubigeo` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código UBIGEO INEI',
  `distrito` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'Referencia a usuario registrado',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `entidad_tipo` enum('comprobante','resumen','baja') COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidad_id` bigint unsigned NOT NULL,
  `intentos` int unsigned DEFAULT '0',
  `max_intentos` int unsigned DEFAULT '3',
  `ultimo_error` text COLLATE utf8mb4_unicode_ci,
  `ultimo_intento_at` timestamp NULL DEFAULT NULL,
  `proximo_reintento_at` timestamp NULL DEFAULT NULL,
  `delay_segundos` int unsigned DEFAULT '300',
  `estado` enum('PENDIENTE','PROCESANDO','COMPLETADO','FALLIDO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `compra_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `codigo_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `compra_id` bigint unsigned NOT NULL,
  `estado_compra_id` bigint unsigned NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint unsigned DEFAULT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_compra` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cotizacion_id` bigint unsigned DEFAULT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `fecha_compra` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `estado_compra_id` bigint unsigned NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requiere_factura` tinyint(1) DEFAULT '0',
  `datos_facturacion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `comprobante_id` bigint unsigned DEFAULT NULL,
  `facturado_automaticamente` tinyint(1) DEFAULT '0',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `direccion_envio` text COLLATE utf8mb4_unicode_ci,
  `telefono_contacto` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forma_envio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT '0.00',
  `departamento_id` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_id` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_id` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_completa` text COLLATE utf8mb4_unicode_ci,
  `aprobada_por` bigint unsigned DEFAULT NULL,
  `fecha_aprobacion` datetime DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
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
  CONSTRAINT `fk_compras_comprobante` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `compras_chk_1` CHECK (json_valid(`datos_facturacion`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `comprobante_id` bigint unsigned NOT NULL,
  `item` int unsigned NOT NULL COMMENT 'Número de línea',
  `producto_id` bigint unsigned DEFAULT NULL COMMENT 'Referencia al producto',
  `codigo_producto` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unidad_medida` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NIU' COMMENT 'NIU=Número de unidades',
  `cantidad` decimal(12,4) NOT NULL,
  `valor_unitario` decimal(12,4) NOT NULL COMMENT 'Precio sin IGV',
  `precio_unitario` decimal(12,4) NOT NULL COMMENT 'Precio con IGV',
  `descuento` decimal(12,2) NOT NULL DEFAULT '0.00',
  `valor_venta` decimal(12,2) NOT NULL COMMENT 'cantidad * valor_unitario - descuento',
  `porcentaje_igv` decimal(5,2) NOT NULL DEFAULT '18.00',
  `igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tipo_afectacion_igv` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '10' COMMENT '10=Gravado, 20=Exonerado, 30=Inafecto',
  `importe_total` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo_comprobante` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '01=Factura, 03=Boleta, 07=NC, 08=ND',
  `serie` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correlativo` int unsigned NOT NULL,
  `numero_completo` varchar(20) COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (concat(`serie`,_utf8mb4'-',lpad(`correlativo`,8,_utf8mb4'0'))) STORED,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `cliente_id` bigint unsigned NOT NULL,
  `cliente_tipo_documento` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_razon_social` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_direccion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `moneda` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PEN',
  `operacion_gravada` decimal(12,2) NOT NULL DEFAULT '0.00',
  `operacion_exonerada` decimal(12,2) NOT NULL DEFAULT '0.00',
  `operacion_inafecta` decimal(12,2) NOT NULL DEFAULT '0.00',
  `operacion_gratuita` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_descuentos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_otros_cargos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `importe_total` decimal(12,2) NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `comprobante_referencia_id` bigint unsigned DEFAULT NULL,
  `tipo_nota` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código de tipo de nota de crédito/débito',
  `motivo_nota` text COLLATE utf8mb4_unicode_ci,
  `estado` enum('PENDIENTE','ENVIADO','ACEPTADO','RECHAZADO','ANULADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `fecha_envio_sunat` timestamp NULL DEFAULT NULL,
  `fecha_respuesta_sunat` timestamp NULL DEFAULT NULL,
  `origen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MANUAL',
  `compra_id` bigint unsigned DEFAULT NULL,
  `metodo_pago` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia_pago` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_hash` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qr_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_firmado` longtext COLLATE utf8mb4_unicode_ci,
  `xml_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_respuesta_sunat` longtext COLLATE utf8mb4_unicode_ci,
  `cdr_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_base64` longtext COLLATE utf8mb4_unicode_ci,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `errores_sunat` text COLLATE utf8mb4_unicode_ci,
  `codigo_error_sunat` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL COMMENT 'Usuario que creó el comprobante',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `codigos_error_sunat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `informacion_errores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
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
  CONSTRAINT `fk_comprobantes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `comprobantes_chk_1` CHECK (json_valid(`codigos_error_sunat`)),
  CONSTRAINT `comprobantes_chk_2` CHECK (json_valid(`informacion_errores`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `preference_id` bigint unsigned DEFAULT NULL COMMENT 'ID de la preferencia relacionada',
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'ID del usuario',
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID de sesión',
  `accion` enum('aceptar_todo','rechazar_todo','personalizar','actualizar','revocar') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Acción realizada',
  `cookies_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'Estado anterior de las cookies',
  `cookies_nuevas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Estado nuevo de las cookies',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP del usuario',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT 'User agent',
  `url_origen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL donde se realizó la acción',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_preference_id` (`preference_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_fecha` (`created_at`),
  KEY `idx_accion_fecha` (`accion`,`created_at`),
  CONSTRAINT `cookies_audit_log_preference_id_foreign` FOREIGN KEY (`preference_id`) REFERENCES `cookies_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cookies_audit_log_chk_1` CHECK (json_valid(`cookies_anteriores`)),
  CONSTRAINT `cookies_audit_log_chk_2` CHECK (json_valid(`cookies_nuevas`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Clave única de configuración (ej: banner_activo, duracion_consentimiento)',
  `valor` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Valor de la configuración',
  `tipo` enum('boolean','string','integer','json') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string' COMMENT 'Tipo de dato del valor',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción de la configuración',
  `categoria` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'general' COMMENT 'Categoría de configuración (general, banner, politica, etc)',
  `editable` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Si es editable desde el admin',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'ID del usuario (NULL para usuarios no registrados)',
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID de sesión para usuarios no registrados',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Dirección IP del usuario',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT 'User agent del navegador',
  `cookies_necesarias` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Cookies necesarias (siempre activas)',
  `cookies_analiticas` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cookies de analítica (Google Analytics, etc)',
  `cookies_marketing` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cookies de marketing y publicidad',
  `cookies_funcionales` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cookies funcionales (preferencias, idioma, etc)',
  `consintio_todo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Si aceptó todas las cookies',
  `rechazo_todo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Si rechazó todas las opcionales',
  `personalizado` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Si personalizó las preferencias',
  `fecha_consentimiento` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha del consentimiento',
  `fecha_expiracion` timestamp NULL DEFAULT NULL COMMENT 'Fecha de expiración del consentimiento (12 meses)',
  `version_politica` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '1.0' COMMENT 'Versión de la política aceptada',
  `navegador` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Navegador utilizado',
  `dispositivo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de dispositivo (desktop, mobile, tablet)',
  `ultima_actualizacion` timestamp NULL DEFAULT NULL COMMENT 'Última vez que cambió preferencias',
  `numero_actualizaciones` int NOT NULL DEFAULT '1' COMMENT 'Número de veces que cambió preferencias',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `codigo_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cotizacion_detalles_cotizacion_id_foreign` (`cotizacion_id`),
  KEY `cotizacion_detalles_producto_id_foreign` (`producto_id`),
  CONSTRAINT `cotizacion_detalles_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizacion_detalles`
--

LOCK TABLES `cotizacion_detalles` WRITE;
/*!40000 ALTER TABLE `cotizacion_detalles` DISABLE KEYS */;
INSERT INTO `cotizacion_detalles` VALUES (2,2,9,'324adcs','desipiador de aire',1,123.00,123.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(3,2,12,'ajsk21','AJAZZ AK820PRO',1,210.00,210.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(4,2,7,'A10','Astro A10',1,2222.00,2222.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(5,2,2,'ASUS ROG','PLACA ASUS ROG STRIX B860-F GAMING WIFI LGA 1851 INTEL B860 DDR5 HDMI DP M.2 SATA 6GB BLUETOOTH M.2 SATA 6GB ATX',1,45.00,45.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(6,2,3,'AUD-213','AUDIFONOS',1,222.00,222.00,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(9,4,15,'LOGI346','MOUSE INALAMBRICO/BT LOGITECH M196 WHITE',1,40.00,40.00,'2025-09-27 19:29:33','2025-09-27 19:29:33'),(10,5,15,'LOGI346','MOUSE INALAMBRICO/BT LOGITECH M196 WHITE',1,40.00,40.00,'2025-09-29 08:37:58','2025-09-29 08:37:58'),(11,6,16,'i7','PROCESADOR INTEL CORE i7-14700K, Cache 33 MB, Hasta 5.6 Ghz.',1,100.00,100.00,'2025-09-30 08:35:32','2025-09-30 08:35:32'),(12,7,207,'PLACH18LM','PLACA ROG GAMING X MONSTER H81M DDR3 M.2 MICRO',1,145.00,145.00,'2025-12-12 21:46:45','2025-12-12 21:46:45');
/*!40000 ALTER TABLE `cotizacion_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cotizacion_tracking`
--

DROP TABLE IF EXISTS `cotizacion_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cotizacion_tracking` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_id` bigint unsigned NOT NULL,
  `estado_cotizacion_id` bigint unsigned NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint unsigned DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizacion_tracking`
--

LOCK TABLES `cotizacion_tracking` WRITE;
/*!40000 ALTER TABLE `cotizacion_tracking` DISABLE KEYS */;
INSERT INTO `cotizacion_tracking` VALUES (2,2,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-23 16:03:36','2025-09-23 14:03:36','2025-09-23 14:03:36'),(4,4,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-27 21:29:33','2025-09-27 19:29:33','2025-09-27 19:29:33'),(5,5,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-29 10:37:58','2025-09-29 08:37:58','2025-09-29 08:37:58'),(6,6,1,'Cotización creada desde el checkout del e-commerce',1,'2025-09-30 10:35:32','2025-09-30 08:35:32','2025-09-30 08:35:32'),(7,6,2,'Cliente solicitó el procesamiento de la cotización',NULL,'2025-09-30 10:38:33','2025-09-30 08:38:33','2025-09-30 08:38:33'),(8,7,1,'Cotización creada desde el checkout del e-commerce',1,'2025-12-12 16:46:45','2025-12-12 21:46:45','2025-12-12 21:46:45'),(9,7,2,'Cliente solicitó el procesamiento de la cotización',NULL,'2025-12-12 16:47:14','2025-12-12 21:47:14','2025-12-12 21:47:14');
/*!40000 ALTER TABLE `cotizacion_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cotizaciones`
--

DROP TABLE IF EXISTS `cotizaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cotizaciones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_cotizacion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `fecha_cotizacion` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `estado_cotizacion_id` bigint unsigned NOT NULL,
  `metodo_pago_preferido` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `direccion_envio` text COLLATE utf8mb4_unicode_ci,
  `telefono_contacto` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forma_envio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT '0.00',
  `departamento_id` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_id` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_id` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_completa` text COLLATE utf8mb4_unicode_ci,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cotizaciones`
--

LOCK TABLES `cotizaciones` WRITE;
/*!40000 ALTER TABLE `cotizaciones` DISABLE KEYS */;
INSERT INTO `cotizaciones` VALUES (2,'COT-20250923-0001',NULL,31,'2025-09-23 16:03:36',2822.00,507.96,0.00,3359.96,1,'tarjeta',NULL,'nbgm nbhmnbm,mnj','993321920',NULL,'kiyotaka hitori Google','kiyotakahitori@gmail.com','delivery',30.00,'05','04','01','AYACUCHO','HUANTA','HUANTA','HUANTA, HUANTA, AYACUCHO','2025-09-30 16:03:36',1,'2025-09-23 14:03:36','2025-09-23 14:03:36'),(4,'COT-20250927-0001',NULL,36,'2025-09-27 21:29:33',40.00,7.20,0.00,77.20,1,'efectivo',NULL,'Santa Anita','972781904','42799312','Manuel Aguado Google','systemcraft.pe@gmail.com','delivery',30.00,'15','01','37','LIMA','LIMA','SANTA ANITA','SANTA ANITA, LIMA, LIMA','2025-10-04 21:29:33',1,'2025-09-27 19:29:33','2025-09-27 19:29:33'),(5,'COT-20250929-0001',NULL,30,'2025-09-29 10:37:58',40.00,7.20,0.00,77.20,1,'efectivo',NULL,'santa anita','972781904','42799312','JUAN PÉREZ GARCÍA','umbrellasrl@gmail.com','delivery',30.00,'15','01','13','LIMA','LIMA','JESUS MARIA','JESUS MARIA, LIMA, LIMA','2025-10-06 10:37:58',1,'2025-09-29 08:37:58','2025-09-29 08:37:58'),(6,'COT-20250930-0001',NULL,36,'2025-09-30 10:35:32',100.00,18.00,0.00,148.00,2,'efectivo','con cuidado','Santa Anita','972781904','42799312','Manuel Aguado Google','systemcraft.pe@gmail.com','delivery',30.00,'15','01','03','LIMA','LIMA','ATE','ATE, LIMA, LIMA','2025-10-07 10:35:32',1,'2025-09-30 08:35:32','2025-09-30 08:38:33'),(7,'COT-20251212-0001',NULL,36,'2025-12-12 16:46:45',145.00,26.10,0.00,196.10,2,'001',NULL,'Santa Anita','987161736',NULL,'Manuel Aguado Google','systemcraft.pe@gmail.com','5',25.00,'15','01','16','LIMA','LIMA','LINCE','LINCE, LIMA, LIMA','2025-12-19 16:46:45',1,'2025-12-12 21:46:45','2025-12-12 21:47:14');
/*!40000 ALTER TABLE `cotizaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuenta_cobrar_pagos`
--

DROP TABLE IF EXISTS `cuenta_cobrar_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuenta_cobrar_pagos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_cobrar_id` bigint unsigned NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` date NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_pagar_id` bigint unsigned NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` date NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cliente_id` bigint unsigned NOT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `comprobante_id` bigint unsigned DEFAULT NULL,
  `numero_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto_total` decimal(12,2) NOT NULL,
  `monto_pagado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `saldo_pendiente` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PARCIAL','PAGADO','VENCIDO','ANULADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `dias_credito` int NOT NULL DEFAULT '0',
  `dias_vencidos` int NOT NULL DEFAULT '0',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `proveedor_id` bigint unsigned NOT NULL,
  `compra_id` bigint unsigned DEFAULT NULL,
  `numero_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto_total` decimal(12,2) NOT NULL,
  `monto_pagado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `saldo_pendiente` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PARCIAL','PAGADO','VENCIDO','ANULADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `dias_credito` int NOT NULL DEFAULT '0',
  `dias_vencidos` int NOT NULL DEFAULT '0',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cupon_id` int unsigned NOT NULL COMMENT 'Referencia al cupón usado',
  `user_cliente_id` bigint unsigned NOT NULL COMMENT 'Referencia al cliente que usó el cupón',
  `venta_id` bigint unsigned DEFAULT NULL COMMENT 'Referencia a la venta donde se aplicó',
  `descuento_aplicado` decimal(10,2) NOT NULL COMMENT 'Monto del descuento aplicado',
  `total_compra` decimal(10,2) DEFAULT NULL COMMENT 'Total de la compra antes del descuento',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo_descuento` enum('porcentaje','cantidad_fija') COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `compra_minima` decimal(10,2) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `limite_uso` int DEFAULT NULL,
  `usos_actuales` int DEFAULT '0',
  `solo_primera_compra` tinyint(1) DEFAULT '0',
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo` (`codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupones`
--

LOCK TABLES `cupones` WRITE;
/*!40000 ALTER TABLE `cupones` DISABLE KEYS */;
INSERT INTO `cupones` VALUES (3,'BLACK','POR EL BLACK FRIDAY','EN TODA NUESTRA PAGINA WEB POR COMPRAS MAYORES A 5000 SOLES.','porcentaje',10.00,5000.00,'2025-10-17 09:03:00','2026-01-04 09:03:00',10,0,0,1,'2025-10-13 08:03:54','2025-12-26 16:00:07');
/*!40000 ALTER TABLE `cupones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cxc_pagos`
--

DROP TABLE IF EXISTS `cxc_pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cxc_pagos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_cobrar_id` bigint unsigned NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_operacion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cuenta_por_pagar_id` bigint unsigned NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_operacion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `global_colors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `subject` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `greeting` text COLLATE utf8mb4_general_ci,
  `main_content` text COLLATE utf8mb4_general_ci,
  `secondary_content` text COLLATE utf8mb4_general_ci,
  `footer_text` text COLLATE utf8mb4_general_ci,
  `benefits_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `product_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `button_text` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `button_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `use_default` tinyint(1) NOT NULL DEFAULT '0',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre_empresa` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `celular` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `facebook` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instagram` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `twitter` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `youtube` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_atencion` text COLLATE utf8mb4_unicode_ci,
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
INSERT INTO `empresa_info` VALUES (1,'Magus Technologies','10427993120','MAGUS TECHNOLOGIES','santa anita','972781904','972781904','manuel.aguado@magustechnologies.com','https://magustechnologies.com/','empresa/logos/AERqD3yJqdYUzae8RYBR5GJ7W7ml4PpyLN4sUaMM.png','Magus E-commerce es una plataforma 100% peruana, diseñada para potenciar las ventas de sus clientes, con una integración óptima en los motores de búsqueda, asegurando un excelente posicionamiento.\r\n\r\nMagus E-commerce no solo está optimizada para el posicionamiento en buscadores, sino que también ofrece una pasarela de pagos segura y una gestión logística integral, asegurando una experiencia completa y sin complicaciones para los clientes.',NULL,NULL,NULL,NULL,'972781904',NULL,'2025-07-22 07:25:59','2025-12-26 14:06:29');
/*!40000 ALTER TABLE `empresa_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_logs`
--

DROP TABLE IF EXISTS `error_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'facturacion, webhook, greenter, etc',
  `origen` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Clase o método origen',
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `detalles` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Información adicional del error',
  `stack_trace` longtext COLLATE utf8mb4_unicode_ci,
  `entidad_tipo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'compra, comprobante, etc',
  `entidad_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `severidad` enum('DEBUG','INFO','WARNING','ERROR','CRITICAL') COLLATE utf8mb4_unicode_ci DEFAULT 'ERROR',
  `resuelto` tinyint(1) DEFAULT '0',
  `fecha_resolucion` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT '#6c757d',
  `orden` int DEFAULT '0',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT '#6c757d',
  `orden` int DEFAULT '0',
  `permite_conversion` tinyint(1) DEFAULT '0',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `orden` int NOT NULL DEFAULT '0',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_cliente_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `tipo` enum('INGRESO','EGRESO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `concepto` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto_proyectado` decimal(12,2) NOT NULL,
  `monto_real` decimal(12,2) DEFAULT NULL,
  `categoria` enum('VENTAS','COBROS','PRESTAMOS','OTROS_INGRESOS','COMPRAS','PAGOS_PROVEEDORES','SUELDOS','SERVICIOS','IMPUESTOS','PRESTAMOS_PAGO','OTROS_EGRESOS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('PROYECTADO','REALIZADO','CANCELADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PROYECTADO',
  `recurrente` tinyint(1) NOT NULL DEFAULT '0',
  `frecuencia` enum('DIARIO','SEMANAL','QUINCENAL','MENSUAL','ANUAL') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Frecuencia de recurrencia',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `departamento_id` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Código ubigeo del departamento (ej: 150000)',
  `provincia_id` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código ubigeo de la provincia (ej: 150100, null = todo el departamento)',
  `distrito_id` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código ubigeo del distrito (ej: 150122, null = toda la provincia)',
  `costo` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Costo de envío para esta ubicación',
  `activo` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = Activo, 0 = Inactivo',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: Delivery en Lima, Recojo en tienda',
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: delivery, recojo_tienda, envio_provincia',
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `costo` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Costo de envío',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Para ordenar en el frontend',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `categoria` enum('ALQUILER','SERVICIOS','SUELDOS','MARKETING','TRANSPORTE','MANTENIMIENTO','IMPUESTOS','OTROS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `concepto` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `comprobante_tipo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comprobante_numero` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `proveedor_id` bigint unsigned DEFAULT NULL,
  `es_fijo` tinyint(1) NOT NULL DEFAULT '0',
  `es_recurrente` tinyint(1) NOT NULL DEFAULT '0',
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo_comprobante` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '09',
  `serie` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correlativo` int NOT NULL,
  `tipo_guia` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requiere_sunat` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_emision` date NOT NULL,
  `fecha_inicio_traslado` date NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `comprobante_tipo` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '01=Factura, 03=Boleta',
  `comprobante_serie` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comprobante_numero` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_tipo_documento` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_razon_social` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario_tipo_documento` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario_numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario_razon_social` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario_direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario_ubigeo` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `motivo_traslado` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `modalidad_traslado` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `peso_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `numero_bultos` int NOT NULL DEFAULT '1',
  `modo_transporte` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01',
  `numero_placa` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `constancia_mtc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Constancia de inscripción MTC del vehículo',
  `transportista_ruc` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transportista_razon_social` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transportista_numero_mtc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conductor_tipo_documento` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conductor_numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transportista_direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_licencia` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conductor_dni` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conductor_nombres` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conductor_apellidos` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conductor_licencia` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehiculo_placa_principal` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehiculo_placa_secundaria` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `punto_partida_ubigeo` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `punto_partida_direccion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `punto_llegada_ubigeo` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `punto_llegada_direccion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `nota_sunat` text COLLATE utf8mb4_unicode_ci,
  `estado` enum('PENDIENTE','ACEPTADO','RECHAZADO','ANULADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `estado_logistico` enum('pendiente','en_transito','entregado','devuelto','anulado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente' COMMENT 'Estado del traslado físico',
  `xml_firmado` longtext COLLATE utf8mb4_unicode_ci,
  `xml_respuesta_sunat` longtext COLLATE utf8mb4_unicode_ci,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `codigo_hash` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_base64` longtext COLLATE utf8mb4_unicode_ci,
  `tiene_xml` tinyint(1) NOT NULL DEFAULT '0',
  `tiene_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `tiene_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `numero_ticket` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_aceptacion` timestamp NULL DEFAULT NULL,
  `errores_sunat` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guias_remision`
--

LOCK TABLES `guias_remision` WRITE;
/*!40000 ALTER TABLE `guias_remision` DISABLE KEYS */;
INSERT INTO `guias_remision` VALUES (19,'09','T001',19,'REMITENTE',1,'2026-01-08','2026-01-08',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6','20000000001','EMPRESA DE PRUEBA SAC','AV. PRUEBA 123 - LIMA','150101','01','01',0.50,1,'01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150101','Av. Principal 123, Lima','150131','Jr. Los Olivos 456, San Isidro','Entregar en horario de oficina',NULL,'PENDIENTE','pendiente','PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPERlc3BhdGNoQWR2aWNlIHhtbG5zPSJ1cm46b2FzaXM6bmFtZXM6c3BlY2lmaWNhdGlvbjp1Ymw6c2NoZW1hOnhzZDpEZXNwYXRjaEFkdmljZS0yIiB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyIgeG1sbnM6Y2FjPSJ1cm46b2FzaXM6bmFtZXM6c3BlY2lmaWNhdGlvbjp1Ymw6c2NoZW1hOnhzZDpDb21tb25BZ2dyZWdhdGVDb21wb25lbnRzLTIiIHhtbG5zOmNiYz0idXJuOm9hc2lzOm5hbWVzOnNwZWNpZmljYXRpb246dWJsOnNjaGVtYTp4c2Q6Q29tbW9uQmFzaWNDb21wb25lbnRzLTIiIHhtbG5zOmV4dD0idXJuOm9hc2lzOm5hbWVzOnNwZWNpZmljYXRpb246dWJsOnNjaGVtYTp4c2Q6Q29tbW9uRXh0ZW5zaW9uQ29tcG9uZW50cy0yIj48ZXh0OlVCTEV4dGVuc2lvbnM+PGV4dDpVQkxFeHRlbnNpb24+PGV4dDpFeHRlbnNpb25Db250ZW50PjxkczpTaWduYXR1cmUgSWQ9IkdyZWVudGVyU2lnbiI+PGRzOlNpZ25lZEluZm8+PGRzOkNhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy9UUi8yMDAxL1JFQy14bWwtYzE0bi0yMDAxMDMxNSIvPjxkczpTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjcnNhLXNoYTEiLz48ZHM6UmVmZXJlbmNlIFVSST0iIj48ZHM6VHJhbnNmb3Jtcz48ZHM6VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48L2RzOlRyYW5zZm9ybXM+PGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIi8+PGRzOkRpZ2VzdFZhbHVlPmxNTXlNNDNkUEEyZStpVXRxMmtOTjVtYTBvaz08L2RzOkRpZ2VzdFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2lnbmF0dXJlVmFsdWU+SzVzOUlaOWFFOFlvd3cyT0I2RUtnZ3dnMlF4eVUyVUIxeWlkQWFic0dWUjBZVlA4TEl0Zm1JUU1RaFNzZzFaMS9lZ0tXditWb1ZwWldqcnBNc0t0aTB5VlhRTEQ3dHdvVkdlMlVXbmU1ME1INmUxVXB4MkVlRlBtWVh4c1lMcjZSbkVJSUNteXhoSi9kY2MyNG9ycWNzcDFHSm84TjNoQ01MMFl2RlNmakNXNmhHL2ttRjU1WmNQcUNCdWNlMklaZEQzSXdCeVIxbXZXYThmOWZaWXVhL1NSeE1DdzNYektYVWxCbS9GcHhUVnlpNXhWT1VMNVAvMXBKSGpkV29vUUdOdGUwc204SnhERklDUTBQSDNXSVRiMWlyQUFad0VQcSs1RkMzazhXdXpkYVNmYmQ3NFdrRjBuYUsrbWVCb1hZU0Iyc0l6Qy9UVlpNVHZ5MElYcGZBPT08L2RzOlNpZ25hdHVyZVZhbHVlPjxkczpLZXlJbmZvPjxkczpYNTA5RGF0YT48ZHM6WDUwOUNlcnRpZmljYXRlPk1JSUluekNDQm9lZ0F3SUJBZ0lVVnpNeGgxNGZpdG5EUzc5bHRwVXNGME5kdEZZd0RRWUpLb1pJaHZjTkFRRUxCUUF3YnpFTE1Ba0dBMVVFQmhNQ1VFVXhQREE2QmdOVkJBb01NMUpsWjJsemRISnZJRTVoWTJsdmJtRnNJR1JsSUVsa1pXNTBhV1pwWTJGamFjT3piaUI1SUVWemRHRmtieUJEYVhacGJERWlNQ0FHQTFVRUF3d1pSVU5GVUMxU1JVNUpSVU1nUTBFZ1EyeGhjM01nTVNCSlNUQWVGdzB5TlRFeE1Ua3hOalF3TVRkYUZ3MHlPREV4TVRneE5qUXdNVGRhTUlIL01Rc3dDUVlEVlFRR0V3SlFSVEVTTUJBR0ExVUVDQXdKVEVsTlFTMU1TVTFCTVJRd0VnWURWUVFIREF0VFFVNVVRU0JCVGtsVVFURW1NQ1FHQTFVRUNnd2RRVWRWUVVSUElGTkpSVkpTUVNCTlFVNVZSVXdnU0VsUVQweEpWRTh4R2pBWUJnTlZCR0VNRVU1VVVsQkZMVEV3TkRJM09Ua3pNVEl3TVNFd0h3WURWUVFMREJoRlVrVlFYMU5WVGtGVVh6SXdNalV3TURBM05EQXpOakF4RkRBU0JnTlZCQXNNQ3pFd05ESTNPVGt6TVRJd01Va3dSd1lEVlFRRERFQjhmRlZUVHlCVVVrbENWVlJCVWtsUGZId2dRVWRWUVVSUElGTkpSVkpTUVNCTlFVNVZSVXdnU0VsUVQweEpWRThnUTBSVUlERXdOREkzT1Rrek1USXdNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQW8vRVE2ajlDZjYxNWRIZ0o3eDF5OElSR3pTTFBkSUxrbE5nWW9iaUtFck1iYlI3dWowV21pS0NDNnNZRElwWEIrMDI2cE1OL2RRTkhLY1FreFMxMEJYQVk2bVpEbU9IdFhWYmQ0b3g5YjRlcHI3SWYwZnRRQkRaRVltS0xacHZ6aWVlWlpvbkV4Y3h5cWEzSVM4a2xNN1ludTY2blh1M0E4UExaTHVWZEdyWC9NUTI1b3c4T2M3ekZPWnozbHpSTzRxKzY1TFpSdDlNaUMzYW1rWXN3Q1prUDJFY1JQbGdNRE02MTFVcFRia2ZBcHhpTlZYY3dVbFBaSkR0YjRBNENGdjJqL01pYnQ3QUR3azRKSGtzL3R3aXNFcmJkSVNlK1NKbnhGRFZpV3lablZ0RzJFcHV3dENuN0YraU5LcHdvVzBxQkdWL2lUamZlVXVzNVZiSHltUUlEQVFBQm80SURvRENDQTV3d0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JUTWZSOVc0b20vdmtQdGxkL0JSbnUvUy8zZEpUQndCZ2dyQmdFRkJRY0JBUVJrTUdJd09RWUlLd1lCQlFVSE1BS0dMV2gwZEhBNkx5OWpjblF1Y21WdWFXVmpMbWR2WWk1d1pTOXliMjkwTXk5allXTnNZWE56TVdscExtTnlkREFsQmdnckJnRUZCUWN3QVlZWmFIUjBjRG92TDI5amMzQXVjbVZ1YVdWakxtZHZZaTV3WlRDQ0FqY0dBMVVkSUFTQ0FpNHdnZ0lxTUhjR0VTc0dBUVFCZ3BOa0FnRURBUUJsaDJnQU1HSXdNUVlJS3dZQkJRVUhBZ0VXSldoMGRIQnpPaTh2ZDNkM0xuSmxibWxsWXk1bmIySXVjR1V2Y21Wd2IzTnBkRzl5ZVM4d0xRWUlLd1lCQlFVSEFnRVdJVkJ2Yk8xMGFXTmhJRWRsYm1WeVlXd2daR1VnUTJWeWRHbG1hV05oWTJuemJqQ0J4QVlSS3dZQkJBR0NrMlFDQVFNQkFHZUhhQUF3Z2E0d01nWUlLd1lCQlFVSEFnRVdKbWgwZEhCek9pOHZjR3RwTG5KbGJtbGxZeTVuYjJJdWNHVXZjbVZ3YjNOcGRHOXlhVzh2TUhnR0NDc0dBUVVGQndJQ01Hd2VhZ0JFQUdVQVl3QnNBR0VBY2dCaEFHTUFhUUR6QUc0QUlBQmtBR1VBSUFCUUFISUE0UUJqQUhRQWFRQmpBR0VBY3dBZ0FHUUFaUUFnQUVNQVpRQnlBSFFBYVFCbUFHa0FZd0JoQUdNQWFRRHpBRzRBSUFCRkFFTUFSUUJRQUMwQVVnQkZBRTRBU1FCRkFFTXdnZWNHRVNzR0FRUUJncE5rQWdFREFRRm5oM01ETUlIUk1JSE9CZ2dyQmdFRkJRY0NBakNCd1I2QnZnQkRBR1VBY2dCMEFHa0FaZ0JwQUdNQVlRQmtBRzhBSUFCRUFHa0Fad0JwQUhRQVlRQnNBQ0FBVkFCeUFHa0FZZ0IxQUhRQVlRQnlBR2tBYndBZ0FIQUFZUUJ5QUdFQUlBQkJBR2NBWlFCdUFIUUFaUUFnQUVFQWRRQjBBRzhBYlFCaEFIUUFhUUI2QUdFQVpBQnZBQ0FBUXdCc0FHRUFjd0J6QUNBQU1RQXNBQ0FBWlFCdUFDQUFZd0IxQUcwQWNBQnNBR2tBYlFCcEFHVUFiZ0IwQUc4QUlBQmtBR1VBYkFBZ0FFUUFUQUFnQUU0QXVnQWdBREVBTXdBM0FEQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUhBd1F3ZWdZRFZSMGZCSE13Y1RBMm9EU2dNb1l3YUhSMGNEb3ZMMk55YkM1eVpXNXBaV011WjI5aUxuQmxMMk55YkM5emFHRXlMMk5oWTJ4aGMzTXhhV2t1WTNKc01EZWdOYUF6aGpGb2RIUndPaTh2WTNKc01pNXlaVzVwWldNdVoyOWlMbkJsTDJOeWJDOXphR0V5TDJOaFkyeGhjM014YVdrdVkzSnNNQjBHQTFVZERnUVdCQlJmdFlPWGZXejZhZHYwRElidmJLdmR6bG96NERBT0JnTlZIUThCQWY4RUJBTUNCc0F3RFFZSktvWklodmNOQVFFTEJRQURnZ0lCQUN6L3NBeHdkYjVSTzAvZWR5V2pVblkvVmEvL3o2ZWNvR2ZUdzBBQm1IM1pCTkhxcWJYVzdHWXVtc2ZDREVNMVdFeCtqV3JBQm13Nk9aTmlPUUV0NU5PeVV4Z1hwd2kyb3kyTzZraVpuQUNSb1JJNUFMZ09WOWVwcXhCaUpwcEx2eDB4N0YzR0ZGRzErWWgzR09Oc1hGZXFyZEZiam9RZGRWeGVzaWh0SGJpR0F6K3F0eU5Fbm1wN2ppQ1dwQ0tGSU5IVm5GeVpqdDljYXFjdE1kdjZ4VDhZb2k3QnlrTHROSkhtVGI1VEtxbVovSU9Sb3VYV25RcGJKSEtKcXFJWEJMVlpHdFRVdU9HS0FuQW1NeXR3QWlHQXd5dWkvdHZxQ25VSjNEQmF2TVFjSHZ1cFhZQXM1VjZGMVRBQmxDc2RjWUFxSnFnSWhRdHVKTE5rNzUveTJuMHdJS0FuUEk2aDJzQVJ2M25wZFlNTVIwNllEMWVCZW5udExFZFFhY29VU254THIwNmREVXdoa3NDeW5zTzFCVVJBQmlFOTkvRWkzdUhwSEVxQ0RmZjZueVBhNlkyMlBGRERrbElweTFOTFc2ODMrTzJLbCt5UUlFOFVDc1VUaVRhcXhSTnRPN3ZOc1hnYitPOWFpR3BGSXV4UnduMlRMek1XckJOUjVQMmV1b1BkZXVUQjR1QldObGQ4N0hnQTZkQmwwWDZJdWNuSDNaQmFjM2dMMjVCcGFkc3oydlAxVVl5VksrRjJlUHRtYnlWdXpHYXhuSVJqM3dnMTRGTWgxMGYxb05Eelo4Q08ySlVNMnlDaWNMMTNSbDlEV05rSGRrYWFhbXJhSURPeUhBTWNwcXgxalhmdDFvU0FVaFdCeHcxZklSY3dURXBDSXhSdy90cXErbHpqPC9kczpYNTA5Q2VydGlmaWNhdGU+PC9kczpYNTA5RGF0YT48L2RzOktleUluZm8+PC9kczpTaWduYXR1cmU+PC9leHQ6RXh0ZW5zaW9uQ29udGVudD48L2V4dDpVQkxFeHRlbnNpb24+PC9leHQ6VUJMRXh0ZW5zaW9ucz48Y2JjOlVCTFZlcnNpb25JRD4yLjE8L2NiYzpVQkxWZXJzaW9uSUQ+PGNiYzpDdXN0b21pemF0aW9uSUQ+MS4wPC9jYmM6Q3VzdG9taXphdGlvbklEPjxjYmM6SUQ+VDAwMS0xOTwvY2JjOklEPjxjYmM6SXNzdWVEYXRlPjIwMjYtMDEtMDg8L2NiYzpJc3N1ZURhdGU+PGNiYzpJc3N1ZVRpbWU+MDA6MDA6MDA8L2NiYzpJc3N1ZVRpbWU+PGNiYzpEZXNwYXRjaEFkdmljZVR5cGVDb2RlPjA5PC9jYmM6RGVzcGF0Y2hBZHZpY2VUeXBlQ29kZT48Y2JjOk5vdGU+PCFbQ0RBVEFbRW50cmVnYXIgZW4gaG9yYXJpbyBkZSBvZmljaW5hXV0+PC9jYmM6Tm90ZT48Y2FjOlNpZ25hdHVyZT48Y2JjOklEPlNJR04yMDAwMDAwMDAwMTwvY2JjOklEPjxjYWM6U2lnbmF0b3J5UGFydHk+PGNhYzpQYXJ0eUlkZW50aWZpY2F0aW9uPjxjYmM6SUQ+MjAwMDAwMDAwMDE8L2NiYzpJRD48L2NhYzpQYXJ0eUlkZW50aWZpY2F0aW9uPjxjYWM6UGFydHlOYW1lPjxjYmM6TmFtZT48IVtDREFUQVtFTVBSRVNBIERFIFBSVUVCQSBTQUNdXT48L2NiYzpOYW1lPjwvY2FjOlBhcnR5TmFtZT48L2NhYzpTaWduYXRvcnlQYXJ0eT48Y2FjOkRpZ2l0YWxTaWduYXR1cmVBdHRhY2htZW50PjxjYWM6RXh0ZXJuYWxSZWZlcmVuY2U+PGNiYzpVUkk+I0dSRUVOVEVSLVNJR048L2NiYzpVUkk+PC9jYWM6RXh0ZXJuYWxSZWZlcmVuY2U+PC9jYWM6RGlnaXRhbFNpZ25hdHVyZUF0dGFjaG1lbnQ+PC9jYWM6U2lnbmF0dXJlPjxjYWM6RGVzcGF0Y2hTdXBwbGllclBhcnR5PjxjYmM6Q3VzdG9tZXJBc3NpZ25lZEFjY291bnRJRCBzY2hlbWVJRD0iNiI+MjAwMDAwMDAwMDE8L2NiYzpDdXN0b21lckFzc2lnbmVkQWNjb3VudElEPjxjYWM6UGFydHk+PGNhYzpQYXJ0eUxlZ2FsRW50aXR5PjxjYmM6UmVnaXN0cmF0aW9uTmFtZT48IVtDREFUQVtFTVBSRVNBIERFIFBSVUVCQSBTQUNdXT48L2NiYzpSZWdpc3RyYXRpb25OYW1lPjwvY2FjOlBhcnR5TGVnYWxFbnRpdHk+PC9jYWM6UGFydHk+PC9jYWM6RGVzcGF0Y2hTdXBwbGllclBhcnR5PjxjYWM6RGVsaXZlcnlDdXN0b21lclBhcnR5PjxjYmM6Q3VzdG9tZXJBc3NpZ25lZEFjY291bnRJRCBzY2hlbWVJRD0iNiI+MjAwMDAwMDAwMDE8L2NiYzpDdXN0b21lckFzc2lnbmVkQWNjb3VudElEPjxjYWM6UGFydHk+PGNhYzpQYXJ0eUxlZ2FsRW50aXR5PjxjYmM6UmVnaXN0cmF0aW9uTmFtZT48IVtDREFUQVtFTVBSRVNBIERFIFBSVUVCQSBTQUNdXT48L2NiYzpSZWdpc3RyYXRpb25OYW1lPjwvY2FjOlBhcnR5TGVnYWxFbnRpdHk+PC9jYWM6UGFydHk+PC9jYWM6RGVsaXZlcnlDdXN0b21lclBhcnR5PjxjYWM6U2hpcG1lbnQ+PGNiYzpJRD4xPC9jYmM6SUQ+PGNiYzpIYW5kbGluZ0NvZGU+MDE8L2NiYzpIYW5kbGluZ0NvZGU+PGNiYzpJbmZvcm1hdGlvbj5WZW50YTwvY2JjOkluZm9ybWF0aW9uPjxjYmM6R3Jvc3NXZWlnaHRNZWFzdXJlIHVuaXRDb2RlPSIiPjAuNTAwPC9jYmM6R3Jvc3NXZWlnaHRNZWFzdXJlPjxjYmM6VG90YWxUcmFuc3BvcnRIYW5kbGluZ1VuaXRRdWFudGl0eT4xPC9jYmM6VG90YWxUcmFuc3BvcnRIYW5kbGluZ1VuaXRRdWFudGl0eT48Y2JjOlNwbGl0Q29uc2lnbm1lbnRJbmRpY2F0b3I+ZmFsc2U8L2NiYzpTcGxpdENvbnNpZ25tZW50SW5kaWNhdG9yPjxjYWM6U2hpcG1lbnRTdGFnZT48Y2JjOlRyYW5zcG9ydE1vZGVDb2RlPjAxPC9jYmM6VHJhbnNwb3J0TW9kZUNvZGU+PGNhYzpUcmFuc2l0UGVyaW9kPjxjYmM6U3RhcnREYXRlPjIwMjYtMDEtMDg8L2NiYzpTdGFydERhdGU+PC9jYWM6VHJhbnNpdFBlcmlvZD48L2NhYzpTaGlwbWVudFN0YWdlPjxjYWM6RGVsaXZlcnk+PGNhYzpEZWxpdmVyeUFkZHJlc3M+PGNiYzpJRD4xNTAxMzE8L2NiYzpJRD48Y2JjOlN0cmVldE5hbWU+SnIuIExvcyBPbGl2b3MgNDU2LCBTYW4gSXNpZHJvPC9jYmM6U3RyZWV0TmFtZT48L2NhYzpEZWxpdmVyeUFkZHJlc3M+PC9jYWM6RGVsaXZlcnk+PGNhYzpPcmlnaW5BZGRyZXNzPjxjYmM6SUQ+MTUwMTAxPC9jYmM6SUQ+PGNiYzpTdHJlZXROYW1lPkF2LiBQcmluY2lwYWwgMTIzLCBMaW1hPC9jYmM6U3RyZWV0TmFtZT48L2NhYzpPcmlnaW5BZGRyZXNzPjwvY2FjOlNoaXBtZW50PjxjYWM6RGVzcGF0Y2hMaW5lPjxjYmM6SUQ+MTwvY2JjOklEPjxjYmM6RGVsaXZlcmVkUXVhbnRpdHkgdW5pdENvZGU9IktHTSI+MTwvY2JjOkRlbGl2ZXJlZFF1YW50aXR5PjxjYWM6T3JkZXJMaW5lUmVmZXJlbmNlPjxjYmM6TGluZUlEPjE8L2NiYzpMaW5lSUQ+PC9jYWM6T3JkZXJMaW5lUmVmZXJlbmNlPjxjYWM6SXRlbT48Y2JjOk5hbWU+PCFbQ0RBVEFbQ09PTEVSIERFIFBST0NFU0FET1IgREVFUENPT0wgQUs1MDAgV0hJVEVdXT48L2NiYzpOYW1lPjxjYWM6U2VsbGVyc0l0ZW1JZGVudGlmaWNhdGlvbj48Y2JjOklEPlAyNDM8L2NiYzpJRD48L2NhYzpTZWxsZXJzSXRlbUlkZW50aWZpY2F0aW9uPjwvY2FjOkl0ZW0+PC9jYWM6RGVzcGF0Y2hMaW5lPjwvRGVzcGF0Y2hBZHZpY2U+Cg==',NULL,'Requiere credenciales OAuth2 para enviar a SUNAT. XML ya generado.',NULL,'JVBERi0xLjcKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZwovT3V0bGluZXMgMiAwIFIKL1BhZ2VzIDMgMCBSID4+CmVuZG9iagoyIDAgb2JqCjw8IC9UeXBlIC9PdXRsaW5lcyAvQ291bnQgMCA+PgplbmRvYmoKMyAwIG9iago8PCAvVHlwZSAvUGFnZXMKL0tpZHMgWzYgMCBSCl0KL0NvdW50IDEKL1Jlc291cmNlcyA8PAovUHJvY1NldCA0IDAgUgovRm9udCA8PCAKL0YxIDEwIDAgUgovRjIgMTEgMCBSCj4+Ci9FeHRHU3RhdGUgPDwgCi9HUzEgOCAwIFIKL0dTMiA5IDAgUgo+Pgo+PgovTWVkaWFCb3ggWzAuMDAwIDAuMDAwIDU5NS4yODAgODQxLjg5MF0KID4+CmVuZG9iago0IDAgb2JqClsvUERGIC9UZXh0IF0KZW5kb2JqCjUgMCBvYmoKPDwKL1Byb2R1Y2VyICj+/wBkAG8AbQBwAGQAZgAgADMALgAxAC4AMwAgACsAIABDAFAARABGKQovQ3JlYXRpb25EYXRlIChEOjIwMjYwMTA4MTkyNTQ1LTA1JzAwJykKL01vZERhdGUgKEQ6MjAyNjAxMDgxOTI1NDUtMDUnMDAnKQovVGl0bGUgKP7/AEcAdQDtAGEAIABkAGUAIABSAGUAbQBpAHMAaQDzAG4AIABUADAAMAAxAC0AMQA5KQo+PgplbmRvYmoKNiAwIG9iago8PCAvVHlwZSAvUGFnZQovTWVkaWFCb3ggWzAuMDAwIDAuMDAwIDU5NS4yODAgODQxLjg5MF0KL1BhcmVudCAzIDAgUgovQ29udGVudHMgNyAwIFIKPj4KZW5kb2JqCjcgMCBvYmoKPDwgL0ZpbHRlciAvRmxhdGVEZWNvZGUKL0xlbmd0aCAxMjQ3ID4+CnN0cmVhbQp4nJ1XzXLbNhC+6yn22M4kCH4JMDfFZhyl/lElZXLI5MBKtMMZiXQpOn3KnvIEfYCc8gJdSAK4lKjUU4+HtD/tYr/9sFisRn+OdMq4SCBxhulUwgYioHfAGoxOmEz0IGJOkISlOyQuE4CPUI0445wDfc6uRoIZ+As4vIdPAJ/xj9WIOEvtSdH1PbKG+ej30auruYCHrX9L/z5dvnkYvVlAqlmacLBGMWUELFbw6q0AqRmHxT3Ap1+uPvw9hssMZtnNZD75dgvZdXaxmH27nVyMf/0Mi/eQLfxCUmkmcFkrFHPShZWEiystOBcv+e5HpNQ1pISJWBs5CBk93xbLLzlkm3Jb/qheU1ehLLPc9X0l9QXJZfLSR3bA+evd71BwyZkQ6dngiybfrvNV3Y+uBeNa953/T3STKqYTOxB9UT72Y1rHFIbsefRD+p1aZLeLbChQkjAnzECgbNsep4chuOR9n36oaXZ7OTkXSiVMKB5DdSV1WbT5el1sYVV4XavtY920RVyCs1SnQJ9YqrioTRJcWzBpUhD4FqkFmbDESGgKuEc/h4LQJ54gzuy5I2SwNqVL8AhJ3Ees24j4I4RGKhU7KEnE/vB7QKecGZ7ubM4dKmN2ZA3Hskj5gNgXdbUsHtv65zkHWiFpxfFocdFLWmo0TxRJJvQDmoxfSSlHsgkITcdow5xLiVVAnpO01HYv4tmsJ9V93WzyJR7imPhhL3wA5zTZi4CQvQg6dHuRKOw5dmfTya6tZNa5gXqdPlVt7atumjdtucoji6BiRyOoSGl0mgUeESFEOs2CVUT6dINg5/mOvzKYNmW1LB/zNX6gXsB1uclPxMN1tZNUvANCxUPIGUvEUygXN8fiIVeFVfMT8a7XxUM+JF6kEcUjNKhUex4RIUSoVHuriPTpRvHO8n3fMLiut3C3Lr/iS5vkBczzCibbctXUJxpit+KOUw0PCNUQIW0M0ZBjN+bqWENhWYo1c8rppl7layy81al4MX4Uj8TvpAoEIkIYdFIFq4j0eUbxzhLl4kQgXCKxjgp0QA4CeSPlsOYtbakBoSpyNDaqU1E51AD7Wl9F5XsOFs+Qii1u6amEkWGUkDAMVh3FYEUpdrIGjgGhJDtZg1VAjlIJQp/PhQjdXZ0KpzGh7eDVuW3LKm/zpqyHHKViqRmaI27rzR9N0b/e/STh+j796z27mc6y+W78m84+ZG/GMB9fDISVqcXyGpoqLuvl06bAxtGfm4T3k32/47kp/AwJJHEkwaHrP2aLm6JZ5qui+Z4/a7aQEkvWcMByUDrp3bIhrHY4ZfquJJTACUNGhJS3xLcwsitvv66/Jp8xMUjFWeIGJ4a8anuNYzCTSOuQisZh3CdBc/E2QkiSTDgINBlvpZ0l2USEpBPKvrOKyDOS9sP7ju3ZrLHcl035ODQx+ADKGroXB4T0I4EjbGoVMQoI3bCDWHHDvI1J3VE/kjh9STt0TftMI70ob+QX5SX8glVHMFhRglTyPcOAUIpU8r1VQI4SiXqfzeTi7u46m+3P+90FHv3LO/9fNvUfwPg3nO3g47sJmfc507td7Z77vQ0b4L9X8thc0u5r5dP33J/RWbH/VgfZuli2zY+qXObwUFRFgyMG5E9tvfmnRcw3kWKgEwiFAYQ7DfAu336JTedfl019eAplbmRzdHJlYW0KZW5kb2JqCjggMCBvYmoKPDwgL1R5cGUgL0V4dEdTdGF0ZQovQk0gL05vcm1hbAovQ0EgMQo+PgplbmRvYmoKOSAwIG9iago8PCAvVHlwZSAvRXh0R1N0YXRlCi9CTSAvTm9ybWFsCi9jYSAxCj4+CmVuZG9iagoxMCAwIG9iago8PCAvVHlwZSAvRm9udAovU3VidHlwZSAvVHlwZTEKL05hbWUgL0YxCi9CYXNlRm9udCAvSGVsdmV0aWNhLUJvbGQKL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcKPj4KZW5kb2JqCjExIDAgb2JqCjw8IC9UeXBlIC9Gb250Ci9TdWJ0eXBlIC9UeXBlMQovTmFtZSAvRjIKL0Jhc2VGb250IC9IZWx2ZXRpY2EKL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcKPj4KZW5kb2JqCnhyZWYKMCAxMgowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMDkgMDAwMDAgbiAKMDAwMDAwMDA3NCAwMDAwMCBuIAowMDAwMDAwMTIwIDAwMDAwIG4gCjAwMDAwMDAzMjYgMDAwMDAgbiAKMDAwMDAwMDM1NSAwMDAwMCBuIAowMDAwMDAwNTY0IDAwMDAwIG4gCjAwMDAwMDA2NjcgMDAwMDAgbiAKMDAwMDAwMTk4NyAwMDAwMCBuIAowMDAwMDAyMDQzIDAwMDAwIG4gCjAwMDAwMDIwOTkgMDAwMDAgbiAKMDAwMDAwMjIxMiAwMDAwMCBuIAp0cmFpbGVyCjw8Ci9TaXplIDEyCi9Sb290IDEgMCBSCi9JbmZvIDUgMCBSCi9JRFs8Y2NlN2RhZThhOGVkYWYyMWM2NGY5MjA5ODJkYWZmODM+PGNjZTdkYWU4YThlZGFmMjFjNjRmOTIwOTgyZGFmZjgzPl0KPj4Kc3RhcnR4cmVmCjIzMjAKJSVFT0YK',1,1,0,NULL,NULL,NULL,1,'2026-01-08 23:42:19','2026-01-09 01:00:01'),(20,'09','T001',20,'TRANSPORTISTA',1,'2026-01-08','2026-01-09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6','20000000001','EMPRESA DE PRUEBA SAC','AV. PRUEBA 123 - LIMA','150101','01','01',0.50,1,'01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'YORCHS BRAULIO',NULL,NULL,NULL,NULL,'150101','Av. Principal 123, Lima','150131','Jr. Los Olivos 456, San Isidro','Transporte de mercadería',NULL,'PENDIENTE','pendiente','PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPERlc3BhdGNoQWR2aWNlIHhtbG5zPSJ1cm46b2FzaXM6bmFtZXM6c3BlY2lmaWNhdGlvbjp1Ymw6c2NoZW1hOnhzZDpEZXNwYXRjaEFkdmljZS0yIiB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyIgeG1sbnM6Y2FjPSJ1cm46b2FzaXM6bmFtZXM6c3BlY2lmaWNhdGlvbjp1Ymw6c2NoZW1hOnhzZDpDb21tb25BZ2dyZWdhdGVDb21wb25lbnRzLTIiIHhtbG5zOmNiYz0idXJuOm9hc2lzOm5hbWVzOnNwZWNpZmljYXRpb246dWJsOnNjaGVtYTp4c2Q6Q29tbW9uQmFzaWNDb21wb25lbnRzLTIiIHhtbG5zOmV4dD0idXJuOm9hc2lzOm5hbWVzOnNwZWNpZmljYXRpb246dWJsOnNjaGVtYTp4c2Q6Q29tbW9uRXh0ZW5zaW9uQ29tcG9uZW50cy0yIj48ZXh0OlVCTEV4dGVuc2lvbnM+PGV4dDpVQkxFeHRlbnNpb24+PGV4dDpFeHRlbnNpb25Db250ZW50PjxkczpTaWduYXR1cmUgSWQ9IkdyZWVudGVyU2lnbiI+PGRzOlNpZ25lZEluZm8+PGRzOkNhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy9UUi8yMDAxL1JFQy14bWwtYzE0bi0yMDAxMDMxNSIvPjxkczpTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjcnNhLXNoYTEiLz48ZHM6UmVmZXJlbmNlIFVSST0iIj48ZHM6VHJhbnNmb3Jtcz48ZHM6VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48L2RzOlRyYW5zZm9ybXM+PGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIi8+PGRzOkRpZ2VzdFZhbHVlPjNwdkFqaWx2dWhpUDk4SUtxc1d5Nkk4YmRWUT08L2RzOkRpZ2VzdFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2lnbmF0dXJlVmFsdWU+QVFBR01SZVg4bmJQdlZCRTdvTm1UMG96MlRoZmx0ajllUW4reS9QQzBSakgzSThWN2MzSjEvVUZhSmFEQ2Q4ODhQWXBvK2FKTXhGTWxYek9XUFltOGpYbUc4OEVjaEV1Znc0c09IQTFHRnFJRjVvYXR1dHN6a2k1MjVBK0l6MVNGamZLQ3c4UEwzMW9SNUJmTjZ5QnJOSkwrOHN0OG1aYkVqOUppbG5MSHYxMHVVa0QvTjQ2SFJFS2FnMHFDYjJmM0tUUURicVo1aFFpZUdBcy9YaVR1MmRMRDFWeVBLazFxNTNsZ05INXFPK0t0WCtrbERlWDlaR2Q2ZVA1c2RCWld5c29NQVhPVnlnc1VVR3ZoRmlMVFJCZTVIcExTcHhhSFJqUWQzRXZJbFFDdlVYNE13dE92ZlM1REE0cnJQR3FYbTlDTW5Nam80Ty80ZnV2TmxDQVN3PT08L2RzOlNpZ25hdHVyZVZhbHVlPjxkczpLZXlJbmZvPjxkczpYNTA5RGF0YT48ZHM6WDUwOUNlcnRpZmljYXRlPk1JSUluekNDQm9lZ0F3SUJBZ0lVVnpNeGgxNGZpdG5EUzc5bHRwVXNGME5kdEZZd0RRWUpLb1pJaHZjTkFRRUxCUUF3YnpFTE1Ba0dBMVVFQmhNQ1VFVXhQREE2QmdOVkJBb01NMUpsWjJsemRISnZJRTVoWTJsdmJtRnNJR1JsSUVsa1pXNTBhV1pwWTJGamFjT3piaUI1SUVWemRHRmtieUJEYVhacGJERWlNQ0FHQTFVRUF3d1pSVU5GVUMxU1JVNUpSVU1nUTBFZ1EyeGhjM01nTVNCSlNUQWVGdzB5TlRFeE1Ua3hOalF3TVRkYUZ3MHlPREV4TVRneE5qUXdNVGRhTUlIL01Rc3dDUVlEVlFRR0V3SlFSVEVTTUJBR0ExVUVDQXdKVEVsTlFTMU1TVTFCTVJRd0VnWURWUVFIREF0VFFVNVVRU0JCVGtsVVFURW1NQ1FHQTFVRUNnd2RRVWRWUVVSUElGTkpSVkpTUVNCTlFVNVZSVXdnU0VsUVQweEpWRTh4R2pBWUJnTlZCR0VNRVU1VVVsQkZMVEV3TkRJM09Ua3pNVEl3TVNFd0h3WURWUVFMREJoRlVrVlFYMU5WVGtGVVh6SXdNalV3TURBM05EQXpOakF4RkRBU0JnTlZCQXNNQ3pFd05ESTNPVGt6TVRJd01Va3dSd1lEVlFRRERFQjhmRlZUVHlCVVVrbENWVlJCVWtsUGZId2dRVWRWUVVSUElGTkpSVkpTUVNCTlFVNVZSVXdnU0VsUVQweEpWRThnUTBSVUlERXdOREkzT1Rrek1USXdNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQW8vRVE2ajlDZjYxNWRIZ0o3eDF5OElSR3pTTFBkSUxrbE5nWW9iaUtFck1iYlI3dWowV21pS0NDNnNZRElwWEIrMDI2cE1OL2RRTkhLY1FreFMxMEJYQVk2bVpEbU9IdFhWYmQ0b3g5YjRlcHI3SWYwZnRRQkRaRVltS0xacHZ6aWVlWlpvbkV4Y3h5cWEzSVM4a2xNN1ludTY2blh1M0E4UExaTHVWZEdyWC9NUTI1b3c4T2M3ekZPWnozbHpSTzRxKzY1TFpSdDlNaUMzYW1rWXN3Q1prUDJFY1JQbGdNRE02MTFVcFRia2ZBcHhpTlZYY3dVbFBaSkR0YjRBNENGdjJqL01pYnQ3QUR3azRKSGtzL3R3aXNFcmJkSVNlK1NKbnhGRFZpV3lablZ0RzJFcHV3dENuN0YraU5LcHdvVzBxQkdWL2lUamZlVXVzNVZiSHltUUlEQVFBQm80SURvRENDQTV3d0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JUTWZSOVc0b20vdmtQdGxkL0JSbnUvUy8zZEpUQndCZ2dyQmdFRkJRY0JBUVJrTUdJd09RWUlLd1lCQlFVSE1BS0dMV2gwZEhBNkx5OWpjblF1Y21WdWFXVmpMbWR2WWk1d1pTOXliMjkwTXk5allXTnNZWE56TVdscExtTnlkREFsQmdnckJnRUZCUWN3QVlZWmFIUjBjRG92TDI5amMzQXVjbVZ1YVdWakxtZHZZaTV3WlRDQ0FqY0dBMVVkSUFTQ0FpNHdnZ0lxTUhjR0VTc0dBUVFCZ3BOa0FnRURBUUJsaDJnQU1HSXdNUVlJS3dZQkJRVUhBZ0VXSldoMGRIQnpPaTh2ZDNkM0xuSmxibWxsWXk1bmIySXVjR1V2Y21Wd2IzTnBkRzl5ZVM4d0xRWUlLd1lCQlFVSEFnRVdJVkJ2Yk8xMGFXTmhJRWRsYm1WeVlXd2daR1VnUTJWeWRHbG1hV05oWTJuemJqQ0J4QVlSS3dZQkJBR0NrMlFDQVFNQkFHZUhhQUF3Z2E0d01nWUlLd1lCQlFVSEFnRVdKbWgwZEhCek9pOHZjR3RwTG5KbGJtbGxZeTVuYjJJdWNHVXZjbVZ3YjNOcGRHOXlhVzh2TUhnR0NDc0dBUVVGQndJQ01Hd2VhZ0JFQUdVQVl3QnNBR0VBY2dCaEFHTUFhUUR6QUc0QUlBQmtBR1VBSUFCUUFISUE0UUJqQUhRQWFRQmpBR0VBY3dBZ0FHUUFaUUFnQUVNQVpRQnlBSFFBYVFCbUFHa0FZd0JoQUdNQWFRRHpBRzRBSUFCRkFFTUFSUUJRQUMwQVVnQkZBRTRBU1FCRkFFTXdnZWNHRVNzR0FRUUJncE5rQWdFREFRRm5oM01ETUlIUk1JSE9CZ2dyQmdFRkJRY0NBakNCd1I2QnZnQkRBR1VBY2dCMEFHa0FaZ0JwQUdNQVlRQmtBRzhBSUFCRUFHa0Fad0JwQUhRQVlRQnNBQ0FBVkFCeUFHa0FZZ0IxQUhRQVlRQnlBR2tBYndBZ0FIQUFZUUJ5QUdFQUlBQkJBR2NBWlFCdUFIUUFaUUFnQUVFQWRRQjBBRzhBYlFCaEFIUUFhUUI2QUdFQVpBQnZBQ0FBUXdCc0FHRUFjd0J6QUNBQU1RQXNBQ0FBWlFCdUFDQUFZd0IxQUcwQWNBQnNBR2tBYlFCcEFHVUFiZ0IwQUc4QUlBQmtBR1VBYkFBZ0FFUUFUQUFnQUU0QXVnQWdBREVBTXdBM0FEQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUhBd1F3ZWdZRFZSMGZCSE13Y1RBMm9EU2dNb1l3YUhSMGNEb3ZMMk55YkM1eVpXNXBaV011WjI5aUxuQmxMMk55YkM5emFHRXlMMk5oWTJ4aGMzTXhhV2t1WTNKc01EZWdOYUF6aGpGb2RIUndPaTh2WTNKc01pNXlaVzVwWldNdVoyOWlMbkJsTDJOeWJDOXphR0V5TDJOaFkyeGhjM014YVdrdVkzSnNNQjBHQTFVZERnUVdCQlJmdFlPWGZXejZhZHYwRElidmJLdmR6bG96NERBT0JnTlZIUThCQWY4RUJBTUNCc0F3RFFZSktvWklodmNOQVFFTEJRQURnZ0lCQUN6L3NBeHdkYjVSTzAvZWR5V2pVblkvVmEvL3o2ZWNvR2ZUdzBBQm1IM1pCTkhxcWJYVzdHWXVtc2ZDREVNMVdFeCtqV3JBQm13Nk9aTmlPUUV0NU5PeVV4Z1hwd2kyb3kyTzZraVpuQUNSb1JJNUFMZ09WOWVwcXhCaUpwcEx2eDB4N0YzR0ZGRzErWWgzR09Oc1hGZXFyZEZiam9RZGRWeGVzaWh0SGJpR0F6K3F0eU5Fbm1wN2ppQ1dwQ0tGSU5IVm5GeVpqdDljYXFjdE1kdjZ4VDhZb2k3QnlrTHROSkhtVGI1VEtxbVovSU9Sb3VYV25RcGJKSEtKcXFJWEJMVlpHdFRVdU9HS0FuQW1NeXR3QWlHQXd5dWkvdHZxQ25VSjNEQmF2TVFjSHZ1cFhZQXM1VjZGMVRBQmxDc2RjWUFxSnFnSWhRdHVKTE5rNzUveTJuMHdJS0FuUEk2aDJzQVJ2M25wZFlNTVIwNllEMWVCZW5udExFZFFhY29VU254THIwNmREVXdoa3NDeW5zTzFCVVJBQmlFOTkvRWkzdUhwSEVxQ0RmZjZueVBhNlkyMlBGRERrbElweTFOTFc2ODMrTzJLbCt5UUlFOFVDc1VUaVRhcXhSTnRPN3ZOc1hnYitPOWFpR3BGSXV4UnduMlRMek1XckJOUjVQMmV1b1BkZXVUQjR1QldObGQ4N0hnQTZkQmwwWDZJdWNuSDNaQmFjM2dMMjVCcGFkc3oydlAxVVl5VksrRjJlUHRtYnlWdXpHYXhuSVJqM3dnMTRGTWgxMGYxb05Eelo4Q08ySlVNMnlDaWNMMTNSbDlEV05rSGRrYWFhbXJhSURPeUhBTWNwcXgxalhmdDFvU0FVaFdCeHcxZklSY3dURXBDSXhSdy90cXErbHpqPC9kczpYNTA5Q2VydGlmaWNhdGU+PC9kczpYNTA5RGF0YT48L2RzOktleUluZm8+PC9kczpTaWduYXR1cmU+PC9leHQ6RXh0ZW5zaW9uQ29udGVudD48L2V4dDpVQkxFeHRlbnNpb24+PC9leHQ6VUJMRXh0ZW5zaW9ucz48Y2JjOlVCTFZlcnNpb25JRD4yLjE8L2NiYzpVQkxWZXJzaW9uSUQ+PGNiYzpDdXN0b21pemF0aW9uSUQ+MS4wPC9jYmM6Q3VzdG9taXphdGlvbklEPjxjYmM6SUQ+VDAwMS0yMDwvY2JjOklEPjxjYmM6SXNzdWVEYXRlPjIwMjYtMDEtMDg8L2NiYzpJc3N1ZURhdGU+PGNiYzpJc3N1ZVRpbWU+MDA6MDA6MDA8L2NiYzpJc3N1ZVRpbWU+PGNiYzpEZXNwYXRjaEFkdmljZVR5cGVDb2RlPjMxPC9jYmM6RGVzcGF0Y2hBZHZpY2VUeXBlQ29kZT48Y2JjOk5vdGU+PCFbQ0RBVEFbVHJhbnNwb3J0ZSBkZSBtZXJjYWRlcsOtYV1dPjwvY2JjOk5vdGU+PGNhYzpTaWduYXR1cmU+PGNiYzpJRD5TSUdOMjAwMDAwMDAwMDE8L2NiYzpJRD48Y2FjOlNpZ25hdG9yeVBhcnR5PjxjYWM6UGFydHlJZGVudGlmaWNhdGlvbj48Y2JjOklEPjIwMDAwMDAwMDAxPC9jYmM6SUQ+PC9jYWM6UGFydHlJZGVudGlmaWNhdGlvbj48Y2FjOlBhcnR5TmFtZT48Y2JjOk5hbWU+PCFbQ0RBVEFbRU1QUkVTQSBERSBQUlVFQkEgU0FDXV0+PC9jYmM6TmFtZT48L2NhYzpQYXJ0eU5hbWU+PC9jYWM6U2lnbmF0b3J5UGFydHk+PGNhYzpEaWdpdGFsU2lnbmF0dXJlQXR0YWNobWVudD48Y2FjOkV4dGVybmFsUmVmZXJlbmNlPjxjYmM6VVJJPiNHUkVFTlRFUi1TSUdOPC9jYmM6VVJJPjwvY2FjOkV4dGVybmFsUmVmZXJlbmNlPjwvY2FjOkRpZ2l0YWxTaWduYXR1cmVBdHRhY2htZW50PjwvY2FjOlNpZ25hdHVyZT48Y2FjOkRlc3BhdGNoU3VwcGxpZXJQYXJ0eT48Y2JjOkN1c3RvbWVyQXNzaWduZWRBY2NvdW50SUQgc2NoZW1lSUQ9IjYiPjIwMDAwMDAwMDAxPC9jYmM6Q3VzdG9tZXJBc3NpZ25lZEFjY291bnRJRD48Y2FjOlBhcnR5PjxjYWM6UGFydHlMZWdhbEVudGl0eT48Y2JjOlJlZ2lzdHJhdGlvbk5hbWU+PCFbQ0RBVEFbRU1QUkVTQSBERSBQUlVFQkEgU0FDXV0+PC9jYmM6UmVnaXN0cmF0aW9uTmFtZT48L2NhYzpQYXJ0eUxlZ2FsRW50aXR5PjwvY2FjOlBhcnR5PjwvY2FjOkRlc3BhdGNoU3VwcGxpZXJQYXJ0eT48Y2FjOkRlbGl2ZXJ5Q3VzdG9tZXJQYXJ0eT48Y2JjOkN1c3RvbWVyQXNzaWduZWRBY2NvdW50SUQgc2NoZW1lSUQ9IjYiPjIwMDAwMDAwMDAxPC9jYmM6Q3VzdG9tZXJBc3NpZ25lZEFjY291bnRJRD48Y2FjOlBhcnR5PjxjYWM6UGFydHlMZWdhbEVudGl0eT48Y2JjOlJlZ2lzdHJhdGlvbk5hbWU+PCFbQ0RBVEFbRU1QUkVTQSBERSBQUlVFQkEgU0FDXV0+PC9jYmM6UmVnaXN0cmF0aW9uTmFtZT48L2NhYzpQYXJ0eUxlZ2FsRW50aXR5PjwvY2FjOlBhcnR5PjwvY2FjOkRlbGl2ZXJ5Q3VzdG9tZXJQYXJ0eT48Y2FjOlNoaXBtZW50PjxjYmM6SUQ+MTwvY2JjOklEPjxjYmM6SGFuZGxpbmdDb2RlPjAxPC9jYmM6SGFuZGxpbmdDb2RlPjxjYmM6SW5mb3JtYXRpb24+VmVudGE8L2NiYzpJbmZvcm1hdGlvbj48Y2JjOkdyb3NzV2VpZ2h0TWVhc3VyZSB1bml0Q29kZT0iIj4wLjUwMDwvY2JjOkdyb3NzV2VpZ2h0TWVhc3VyZT48Y2JjOlRvdGFsVHJhbnNwb3J0SGFuZGxpbmdVbml0UXVhbnRpdHk+MTwvY2JjOlRvdGFsVHJhbnNwb3J0SGFuZGxpbmdVbml0UXVhbnRpdHk+PGNiYzpTcGxpdENvbnNpZ25tZW50SW5kaWNhdG9yPmZhbHNlPC9jYmM6U3BsaXRDb25zaWdubWVudEluZGljYXRvcj48Y2FjOlNoaXBtZW50U3RhZ2U+PGNiYzpUcmFuc3BvcnRNb2RlQ29kZT4wMTwvY2JjOlRyYW5zcG9ydE1vZGVDb2RlPjxjYWM6VHJhbnNpdFBlcmlvZD48Y2JjOlN0YXJ0RGF0ZT4yMDI2LTAxLTA5PC9jYmM6U3RhcnREYXRlPjwvY2FjOlRyYW5zaXRQZXJpb2Q+PC9jYWM6U2hpcG1lbnRTdGFnZT48Y2FjOkRlbGl2ZXJ5PjxjYWM6RGVsaXZlcnlBZGRyZXNzPjxjYmM6SUQ+MTUwMTMxPC9jYmM6SUQ+PGNiYzpTdHJlZXROYW1lPkpyLiBMb3MgT2xpdm9zIDQ1NiwgU2FuIElzaWRybzwvY2JjOlN0cmVldE5hbWU+PC9jYWM6RGVsaXZlcnlBZGRyZXNzPjwvY2FjOkRlbGl2ZXJ5PjxjYWM6T3JpZ2luQWRkcmVzcz48Y2JjOklEPjE1MDEwMTwvY2JjOklEPjxjYmM6U3RyZWV0TmFtZT5Bdi4gUHJpbmNpcGFsIDEyMywgTGltYTwvY2JjOlN0cmVldE5hbWU+PC9jYWM6T3JpZ2luQWRkcmVzcz48L2NhYzpTaGlwbWVudD48Y2FjOkRlc3BhdGNoTGluZT48Y2JjOklEPjE8L2NiYzpJRD48Y2JjOkRlbGl2ZXJlZFF1YW50aXR5IHVuaXRDb2RlPSJLR00iPjE8L2NiYzpEZWxpdmVyZWRRdWFudGl0eT48Y2FjOk9yZGVyTGluZVJlZmVyZW5jZT48Y2JjOkxpbmVJRD4xPC9jYmM6TGluZUlEPjwvY2FjOk9yZGVyTGluZVJlZmVyZW5jZT48Y2FjOkl0ZW0+PGNiYzpOYW1lPjwhW0NEQVRBW0NBU0UgSFlURSBZNDAgQkxBQ0sgUkVEIFNJTiBGVUVOVEUgVklEUklPIFRFTVBMQURPIE1JRCBUT1dFUl1dPjwvY2JjOk5hbWU+PGNhYzpTZWxsZXJzSXRlbUlkZW50aWZpY2F0aW9uPjxjYmM6SUQ+UDI5MzwvY2JjOklEPjwvY2FjOlNlbGxlcnNJdGVtSWRlbnRpZmljYXRpb24+PC9jYWM6SXRlbT48L2NhYzpEZXNwYXRjaExpbmU+PC9EZXNwYXRjaEFkdmljZT4K',NULL,'Requiere credenciales OAuth2 para enviar a SUNAT. XML ya generado.',NULL,'JVBERi0xLjcKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZwovT3V0bGluZXMgMiAwIFIKL1BhZ2VzIDMgMCBSID4+CmVuZG9iagoyIDAgb2JqCjw8IC9UeXBlIC9PdXRsaW5lcyAvQ291bnQgMCA+PgplbmRvYmoKMyAwIG9iago8PCAvVHlwZSAvUGFnZXMKL0tpZHMgWzYgMCBSCl0KL0NvdW50IDEKL1Jlc291cmNlcyA8PAovUHJvY1NldCA0IDAgUgovRm9udCA8PCAKL0YxIDEwIDAgUgovRjIgMTEgMCBSCj4+Ci9FeHRHU3RhdGUgPDwgCi9HUzEgOCAwIFIKL0dTMiA5IDAgUgo+Pgo+PgovTWVkaWFCb3ggWzAuMDAwIDAuMDAwIDU5NS4yODAgODQxLjg5MF0KID4+CmVuZG9iago0IDAgb2JqClsvUERGIC9UZXh0IF0KZW5kb2JqCjUgMCBvYmoKPDwKL1Byb2R1Y2VyICj+/wBkAG8AbQBwAGQAZgAgADMALgAxAC4AMwAgACsAIABDAFAARABGKQovQ3JlYXRpb25EYXRlIChEOjIwMjYwMTA4MjE1MjE1LTA1JzAwJykKL01vZERhdGUgKEQ6MjAyNjAxMDgyMTUyMTUtMDUnMDAnKQovVGl0bGUgKP7/AEcAdQDtAGEAIABkAGUAIABSAGUAbQBpAHMAaQDzAG4AIABUADAAMAAxAC0AMgAwKQo+PgplbmRvYmoKNiAwIG9iago8PCAvVHlwZSAvUGFnZQovTWVkaWFCb3ggWzAuMDAwIDAuMDAwIDU5NS4yODAgODQxLjg5MF0KL1BhcmVudCAzIDAgUgovQ29udGVudHMgNyAwIFIKPj4KZW5kb2JqCjcgMCBvYmoKPDwgL0ZpbHRlciAvRmxhdGVEZWNvZGUKL0xlbmd0aCAxMjk0ID4+CnN0cmVhbQp4nI1XS3LbRhDd8xS9TKrs8fwx8I4WYZuORDEkHJfL5QVCwjKq+FFAyDllVj5BDuCVL5AekjNokKAilgpgPfV0v37T09Mc/DXQKePCgnWG6VTCGiKg98AKjLZMWt2LmDPEsnSPRDcB+ACbAWecc6DP2ZuBYAb+Bg7v4BPAZ/yyHJDFUntS1L9HVjAf/D548WYu4G7n39K/z93Xd4NXOaSapZZDYhRTRkC+hBevBUjNOORfAD798ub9P0MYZTDLbsbz8fcJZNfZVT77PhlfDX/9DPk7yHLvSCrNBLpNhGJOuuBJuOgp51w85/uP5HRpSAkTSZLIQci48nW5+FpAtq521c/NS7pUqIQl3HXXSroWJJf2uY/sgPOX+7++4JIzIdKLwfO62K2K5bYbXQvGte4uvhA9fSy6SRXTNumJnlf33ZiJYwpDdlZ0Q+az4WQ+vZ3l43k+7AtmLXPC9ATLds1pihgGd6u7phtumk1G42ySZ32hlGVC8RiqLatR2RSrVbmDZem13ezut3VTRhecpRoVI08sV3SaWIu+BZMmBYFvkSYgLbNGQl3CF1znUBT6xFPEWXLpGBmsT+ksHiOJe4m1GxF/jNBIpWIPWSsODcADOuXM4I56m0sHy5g9WcOxNFLeI/bVdrMo75vt4zkHWiFpxfF4cdFJWmo0t4okE3oCTcZ7UsqRbAJC0zHaMOdSYhWQpyQtdXIQ8WLW482Xbb0uFniQY+LHvfABnNNkLwJC9iLo0O6FVdh3kr1NK7tOJEuc66nX6cOm2fqqmxZ1Uy2LyCKo2NIIKlIarWaBR0QIkVazYBWRLt0g2GW+w28MpnW1WVT3xQr/oZ7BdbUuzsRDv9pJKt4RoeIh5ExCxFMoFzen4iFXhVXziHjXq/Ku6BMv0ojiERpUqgOPiBAiVKqDVUS6dKN4F/m+qxlcb3dwu6q+4Usb+wzmxQbGu2pZb880xG7FHacaHhGqIULaGKIhx47M1amGImEp1sw5p5vtslhh4S3PxYvxo3gkfitVIBARwqCVKlhFpMszineRKBdnAqELmzgq0BE5CuSNlMOaT2hLDQhVkaOxUa2KyqEG2Ne6Kirfc7B4+lRscEvPJYwMo4SEYbBqKQYrSrGVNXAMCCXZyhqsAnKSShD6ci5E6PbqVDiRCZ30Xp27ptoUTVFX276FUrHU9M0Sk+36z7rsXu9+mnDdNd3rPbuZzrL5fgSczt5nr4YwH171hJVpguXVN1WMtouHdYmNozs7Cb9Odtedzk7h0yeQxJEEB6//mS1uynpRLMv6R/Gk2UJKLFnDAVuPUrZzy4aw2uGk6buS8JMu/jcgpLwlvoWRbXl7v/6afMLEIBVn1vVODMWm6TSO3kwirWMqWgm8yVUnF28juCTJhINAk/FWGr+32USEpBPKvrWKyBOS9mWwZ3sxayz3RV3d900MPoBKDN2LI0L6kUhwC6QgRgGhG3YUK26YwDk71fakH4nU4DnpO8M+00gvyhv5RXkJv2DVEgxWlCCV/MAwIJQilfxgFZCTRKLeOEfKpG/guBrOM3j7Mc/go+bw6np49Rv++BvBfDyB1+/9oA9/jEez8S3k2Buuh6NbuBmPTo/2XmeHrVf23cv57YdsRspY76uifR5qI2ygQjcmdoi0/Wn68KPwZ3xWHn4ZQrYqF039c1MtCrgrN2WNIwoUD812/W+DmG9CZU8nEftZ154HeFvsvsam9R/lNo1aCmVuZHN0cmVhbQplbmRvYmoKOCAwIG9iago8PCAvVHlwZSAvRXh0R1N0YXRlCi9CTSAvTm9ybWFsCi9DQSAxCj4+CmVuZG9iago5IDAgb2JqCjw8IC9UeXBlIC9FeHRHU3RhdGUKL0JNIC9Ob3JtYWwKL2NhIDEKPj4KZW5kb2JqCjEwIDAgb2JqCjw8IC9UeXBlIC9Gb250Ci9TdWJ0eXBlIC9UeXBlMQovTmFtZSAvRjEKL0Jhc2VGb250IC9IZWx2ZXRpY2EtQm9sZAovRW5jb2RpbmcgL1dpbkFuc2lFbmNvZGluZwo+PgplbmRvYmoKMTEgMCBvYmoKPDwgL1R5cGUgL0ZvbnQKL1N1YnR5cGUgL1R5cGUxCi9OYW1lIC9GMgovQmFzZUZvbnQgL0hlbHZldGljYQovRW5jb2RpbmcgL1dpbkFuc2lFbmNvZGluZwo+PgplbmRvYmoKeHJlZgowIDEyCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwOSAwMDAwMCBuIAowMDAwMDAwMDc0IDAwMDAwIG4gCjAwMDAwMDAxMjAgMDAwMDAgbiAKMDAwMDAwMDMyNiAwMDAwMCBuIAowMDAwMDAwMzU1IDAwMDAwIG4gCjAwMDAwMDA1NjQgMDAwMDAgbiAKMDAwMDAwMDY2NyAwMDAwMCBuIAowMDAwMDAyMDM0IDAwMDAwIG4gCjAwMDAwMDIwOTAgMDAwMDAgbiAKMDAwMDAwMjE0NiAwMDAwMCBuIAowMDAwMDAyMjU5IDAwMDAwIG4gCnRyYWlsZXIKPDwKL1NpemUgMTIKL1Jvb3QgMSAwIFIKL0luZm8gNSAwIFIKL0lEWzw5YWRmYzdmODc1ZmJjYmExY2Y5Y2ExNmJkNGUzMTEzZj48OWFkZmM3Zjg3NWZiY2JhMWNmOWNhMTZiZDRlMzExM2Y+XQo+PgpzdGFydHhyZWYKMjM2NwolJUVPRgo=',1,1,0,NULL,NULL,NULL,1,'2026-01-09 02:52:02','2026-01-09 02:52:44');
/*!40000 ALTER TABLE `guias_remision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guias_remision_detalle`
--

DROP TABLE IF EXISTS `guias_remision_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guias_remision_detalle` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `guia_remision_id` bigint unsigned NOT NULL,
  `item` int NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `codigo_producto` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unidad_medida` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'KGM',
  `cantidad` decimal(10,2) NOT NULL,
  `peso_unitario` decimal(10,2) NOT NULL,
  `peso_total` decimal(10,2) NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `guias_remision_detalle_guia_remision_id_index` (`guia_remision_id`),
  KEY `guias_remision_detalle_producto_id_index` (`producto_id`),
  KEY `guias_remision_detalle_item_index` (`item`),
  CONSTRAINT `guias_remision_detalle_guia_remision_id_foreign` FOREIGN KEY (`guia_remision_id`) REFERENCES `guias_remision` (`id`) ON DELETE CASCADE,
  CONSTRAINT `guias_remision_detalle_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guias_remision_detalle`
--

LOCK TABLES `guias_remision_detalle` WRITE;
/*!40000 ALTER TABLE `guias_remision_detalle` DISABLE KEYS */;
INSERT INTO `guias_remision_detalle` VALUES (17,19,1,243,'PROAK500','COOLER DE PROCESADOR DEEPCOOL AK500 WHITE','KGM',1.00,0.50,0.50,'Fragil','2026-01-08 23:42:19','2026-01-08 23:42:19'),(18,20,1,293,'HYT40BR','CASE HYTE Y40 BLACK RED SIN FUENTE VIDRIO TEMPLADO MID TOWER','KGM',1.00,0.50,0.50,NULL,'2026-01-09 02:52:02','2026-01-09 02:52:02');
/*!40000 ALTER TABLE `guias_remision_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_pedido`
--

DROP TABLE IF EXISTS `historial_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_pedido` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint unsigned NOT NULL,
  `estado_anterior_id` bigint unsigned DEFAULT NULL,
  `nuevo_estado_id` bigint unsigned NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `cambiado_por` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `producto_id` bigint unsigned NOT NULL,
  `fecha` date NOT NULL,
  `tipo_movimiento` enum('ENTRADA','SALIDA','AJUSTE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_operacion` enum('COMPRA','VENTA','DEVOLUCION_COMPRA','DEVOLUCION_VENTA','AJUSTE_POSITIVO','AJUSTE_NEGATIVO','INVENTARIO_INICIAL','TRANSFERENCIA_ENTRADA','TRANSFERENCIA_SALIDA','MERMA','ROBO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `documento_tipo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `documento_numero` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad` int NOT NULL,
  `costo_unitario` decimal(12,2) NOT NULL,
  `costo_total` decimal(12,2) NOT NULL,
  `stock_anterior` int NOT NULL,
  `stock_actual` int NOT NULL,
  `costo_promedio` decimal(12,2) NOT NULL,
  `compra_id` bigint unsigned DEFAULT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `marcas_productos_nombre_unique` (`nombre`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas_productos`
--

LOCK TABLES `marcas_productos` WRITE;
/*!40000 ALTER TABLE `marcas_productos` DISABLE KEYS */;
INSERT INTO `marcas_productos` VALUES (9,'ASTRO','ASTRO GAMING','1758726183_68d408277dd13.png',1,'2025-09-24 07:51:19','2025-09-24 08:03:03'),(10,'ASUS','ASUS GAMING','1758726367_68d408df54eb9.png',1,'2025-09-24 08:02:39','2025-09-24 08:06:30'),(11,'LOGITECH','LOGITECH GAMING','1758726341_68d408c51586f.png',1,'2025-09-24 08:05:41','2025-09-24 08:05:41'),(12,'RAZER','RAZER GAMING','1758727508_68d40d54ce0af.png',1,'2025-09-24 08:11:22','2025-09-24 08:25:08'),(13,'REDRAGON','REDRAGON GAMING','1758727654_68d40de61ea5c.jpg',1,'2025-09-24 08:27:34','2025-09-24 08:27:34'),(14,'INTEL','INTEL GAMING','1758727972_68d40f244daac.png',1,'2025-09-24 08:32:52','2025-09-24 08:32:52'),(15,'AMD','AMD GAMING','1758728112_68d40fb01ee89.jpg',1,'2025-09-24 08:35:12','2025-09-24 08:35:12'),(16,'NVIDIA','NVIDIA GAMING','1758728434_68d410f25690d.png',1,'2025-09-24 08:40:34','2025-09-24 08:40:34'),(17,'CORSAIR','CORSAIR GAMING','1760450606_68ee582e2f4e6.png',1,'2025-10-01 08:35:08','2025-10-14 07:03:26'),(18,'MSI','MSI GAMING','1760451170_68ee5a621925c.png',1,'2025-10-01 09:05:49','2025-10-14 07:12:50'),(19,'DEEPCOOL','DEEPCOOL GAMING','1760450683_68ee587b5e624.png',1,'2025-10-01 09:48:36','2025-10-14 07:04:43'),(20,'GAMEMAX','GAMEMAX GAMING','1760450840_68ee5918e4d63.png',1,'2025-10-01 13:56:51','2025-10-14 07:07:20'),(21,'LIAN LI','LIAN LI GAMING','1760451112_68ee5a2851632.png',1,'2025-10-01 13:59:20','2025-10-14 07:11:52'),(22,'G. SKILL','G. SKILL GAMING','1760450788_68ee58e4403de.png',1,'2025-10-01 14:00:58','2025-10-14 07:06:28'),(23,'KINGSTON','KINGSTON GAMING','1760451056_68ee59f0a1633.png',1,'2025-10-01 14:02:15','2025-10-14 07:10:56'),(24,'GIGABYTE','GIGABYTE GAMING','1760450956_68ee598c7cff5.png',1,'2025-10-01 14:06:09','2025-10-14 07:09:16'),(25,'ANTRYX','ANTRYX GAMING','1760450518_68ee57d687a4b.png',1,'2025-10-01 14:09:10','2025-10-14 07:01:58'),(26,'Seagate','Seagate Gaming','1759759412_68e3cc348d410.jpg',1,'2025-10-06 07:03:32','2025-10-06 07:03:32'),(27,'AORUS','AORUS GAMING','1759759657_68e3cd291fb66.jpg',1,'2025-10-06 07:07:37','2025-10-06 07:07:37'),(28,'ESONIC','ESONIC GAMING','1764688986_692f045ac1dd4.png',1,'2025-12-02 15:23:06','2025-12-02 20:55:42'),(29,'ASROCK','ASROCK GAMING','1764709017_692f5299bdb65.png',1,'2025-12-02 20:56:57','2025-12-02 20:56:57'),(30,'ADATA','ADATA','1764787229_6930841de4fa4.png',1,'2025-12-03 18:40:29','2025-12-03 18:40:29'),(31,'SAMSUNG','SAMSUNG','1764789281_69308c21b96a1.jpg',1,'2025-12-03 19:14:41','2025-12-03 19:14:41'),(32,'CRUCIAL','MICRON CRUCIAL','1764792926_69309a5e547f3.png',1,'2025-12-03 20:15:26','2025-12-03 20:15:26'),(33,'LEXAR','LEXAR','1764795400_6930a4083727e.png',1,'2025-12-03 20:56:40','2025-12-03 20:56:40'),(34,'T-FORCE','T-FORCE','1764796096_6930a6c09c86b.png',1,'2025-12-03 21:08:16','2025-12-03 21:08:16'),(35,'XPG','XPG','1764802302_6930befe44e99.png',1,'2025-12-03 22:51:42','2025-12-03 22:51:42'),(36,'AIRBOOM','AIRBOOM','1766515153_694ae1d1db0aa.jpeg',1,'2025-12-23 18:39:13','2025-12-23 18:39:13'),(37,'MASTERLIQUID','MASTERLIQUID','1766516932_694ae8c43bbe1.jpg',1,'2025-12-23 19:08:52','2025-12-23 19:08:52'),(38,'CYBERTEL','CYBERTEL','1766520194_694af582c8600.png',1,'2025-12-23 20:03:14','2025-12-23 20:03:14'),(39,'ENKORE','ENKORE','1766520309_694af5f516351.png',1,'2025-12-23 20:05:09','2025-12-23 20:05:09'),(40,'SCYROX','SCYROX','1766523039_694b009f617e8.png',1,'2025-12-23 20:50:39','2025-12-23 20:50:39'),(41,'EPOMAKER','EPOMAKER','1766524133_694b04e5f2b11.png',1,'2025-12-23 21:08:53','2025-12-23 21:08:53'),(42,'MACHENIKE','MACHENIKE','1766524199_694b0527a3a6e.png',1,'2025-12-23 21:09:59','2025-12-23 21:09:59'),(43,'HYTE','HYTE','1766541378_694b4842efd6d.png',1,'2025-12-24 01:56:18','2025-12-24 01:56:18');
/*!40000 ALTER TABLE `marcas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del menú (ej: Hogar, Computadoras)',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'URL de destino (ej: /shop, /contact)',
  `icono` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clase CSS del icono (ej: ph-house)',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Orden de visualización (1, 2, 3...)',
  `padre_id` bigint unsigned DEFAULT NULL COMMENT 'ID del menú padre (para submenús)',
  `tipo` enum('header','footer','sidebar') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'header' COMMENT 'Tipo de menú',
  `target` enum('_self','_blank') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '_self' COMMENT 'Target del enlace',
  `visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = Visible, 0 = Oculto',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_padre_id` (`padre_id`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_visible` (`visible`),
  KEY `idx_orden` (`orden`),
  CONSTRAINT `fk_menus_padre` FOREIGN KEY (`padre_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Menús configurables del sistema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'Lugar Gaming','javascript:void(0)',NULL,1,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-12-23 18:24:18'),(2,'Productos','https://magus-ecommerce.com/index-two',NULL,1,1,'header','_self',1,'2025-11-27 20:47:39','2025-12-23 18:25:08'),(3,'Ofertas','/ofertas',NULL,2,1,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(4,'Remates','/index-three',NULL,3,1,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(5,'Arma tu PC','/arma-tu-pc',NULL,2,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(6,'Computadoras','/index-two',NULL,3,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(7,'Laptops','/index-laptop',NULL,4,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-11-27 20:47:39'),(8,'Pasos de Envío','/pasos-envio',NULL,7,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-12-23 18:31:15'),(9,'Contáctanos','/contact',NULL,8,NULL,'header','_self',1,'2025-11-27 20:47:39','2025-12-23 18:31:07'),(10,'Celulares','/',NULL,5,NULL,'header','_self',1,'2025-12-23 18:26:15','2025-12-23 18:28:35'),(11,'Accesorios Tecnólogicos','/',NULL,6,NULL,'header','_self',1,'2025-12-23 18:31:37','2025-12-23 18:31:37');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_pago` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_05_21_141516_create_personal_access_tokens_table',1),(5,'2025_05_23_212502_create_user_profiles_table',1),(6,'2025_05_23_212626_create_user_addresses_table',1),(7,'2025_05_23_223135_add_last_names_to_user_profiles_table',1),(8,'2025_05_24_135354_create_roles_table',1),(9,'2025_05_24_224316_add_is_enabled_to_users_table',1),(10,'2025_05_25_040524_create_ubigeo_inei_table',1),(11,'2025_05_26_120602_create_document_types_table',1),(12,'2025_05_26_225958_remove_address_line_from_user_addresses_table',1),(13,'2025_05_27_223827_create_categorias_table',1),(14,'2025_05_27_223837_create_productos_table',1),(15,'2025_05_28_000008_add_address_line_to_user_addresses_table',2),(16,'2025_11_03_142045_add_sunat_fields_to_guias_remision_table',3),(17,'2024_11_04_000001_create_favoritos_table',4),(18,'2025_11_11_000001_create_nota_creditos_table',5),(19,'2025_11_11_000002_create_nota_debitos_table',6),(20,'2025_11_12_000001_add_sunat_fields_to_notas_tables',7),(21,'2025_11_12_172618_add_pdf_to_notas_tables',8),(22,'2025_11_14_000001_add_generado_estado_to_notas',9),(23,'2025_11_15_140000_change_estado_to_enum_in_guias_remision',10),(24,'2025_12_01_000001_create_servicios_table',11),(25,'2025_12_01_000002_add_servicio_to_venta_detalles',12);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
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
INSERT INTO `model_has_permissions` VALUES (139,'App\\Models\\User',1),(140,'App\\Models\\User',1),(141,'App\\Models\\User',1),(142,'App\\Models\\User',1),(144,'App\\Models\\User',1),(145,'App\\Models\\User',1),(146,'App\\Models\\User',1),(147,'App\\Models\\User',1),(148,'App\\Models\\User',1),(149,'App\\Models\\User',1),(150,'App\\Models\\User',1),(151,'App\\Models\\User',1),(316,'App\\Models\\User',1),(317,'App\\Models\\User',1),(338,'App\\Models\\User',1),(339,'App\\Models\\User',1),(340,'App\\Models\\User',1),(341,'App\\Models\\User',1),(342,'App\\Models\\User',1),(343,'App\\Models\\User',1),(344,'App\\Models\\User',1),(345,'App\\Models\\User',1),(346,'App\\Models\\User',1),(347,'App\\Models\\User',1),(348,'App\\Models\\User',1),(349,'App\\Models\\User',1),(350,'App\\Models\\User',1),(351,'App\\Models\\User',1),(352,'App\\Models\\User',1),(353,'App\\Models\\User',1),(354,'App\\Models\\User',1),(355,'App\\Models\\User',1),(356,'App\\Models\\User',1),(139,'App\\Models\\User',29),(141,'App\\Models\\User',29),(145,'App\\Models\\User',29),(139,'App\\Models\\User',31),(140,'App\\Models\\User',31),(141,'App\\Models\\User',31),(142,'App\\Models\\User',31),(143,'App\\Models\\User',31),(144,'App\\Models\\User',31),(145,'App\\Models\\User',31),(146,'App\\Models\\User',31),(147,'App\\Models\\User',31),(148,'App\\Models\\User',31),(149,'App\\Models\\User',31),(150,'App\\Models\\User',31),(151,'App\\Models\\User',31),(316,'App\\Models\\User',31),(317,'App\\Models\\User',31),(338,'App\\Models\\User',31),(339,'App\\Models\\User',31),(340,'App\\Models\\User',31),(341,'App\\Models\\User',31),(342,'App\\Models\\User',31),(343,'App\\Models\\User',31),(344,'App\\Models\\User',31),(345,'App\\Models\\User',31),(346,'App\\Models\\User',31),(347,'App\\Models\\User',31),(348,'App\\Models\\User',31),(349,'App\\Models\\User',31),(350,'App\\Models\\User',31),(351,'App\\Models\\User',31),(352,'App\\Models\\User',31),(353,'App\\Models\\User',31),(354,'App\\Models\\User',31),(355,'App\\Models\\User',31),(356,'App\\Models\\User',31),(139,'App\\Models\\User',35),(141,'App\\Models\\User',35),(145,'App\\Models\\User',35);
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
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
INSERT INTO `model_has_roles` VALUES (1,'App\\Models\\User',1),(5,'App\\Models\\UserMotorizado',1),(5,'App\\Models\\UserMotorizado',2),(5,'App\\Models\\UserMotorizado',3),(5,'App\\Models\\UserMotorizado',4),(5,'App\\Models\\UserMotorizado',5),(3,'App\\Models\\User',29),(1,'App\\Models\\User',31),(3,'App\\Models\\User',35),(3,'App\\Models\\User',36),(3,'App\\Models\\User',37);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motorizado_estados`
--

DROP TABLE IF EXISTS `motorizado_estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `motorizado_estados` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `motorizado_id` bigint unsigned NOT NULL,
  `estado` enum('disponible','ocupado','en_ruta','descanso','offline') COLLATE utf8mb4_unicode_ci DEFAULT 'offline',
  `latitud` decimal(10,8) DEFAULT NULL COMMENT 'Ubicacion actual',
  `longitud` decimal(11,8) DEFAULT NULL COMMENT 'Ubicacion actual',
  `ultima_actividad` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero_unidad` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_completo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto_perfil` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_documento_id` bigint unsigned NOT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `licencia_numero` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `licencia_categoria` enum('A1','A2a','A2b','A3a','A3b','A3c') COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion_detalle` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubigeo` bigint unsigned NOT NULL,
  `vehiculo_marca` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_modelo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_ano` year NOT NULL,
  `vehiculo_cilindraje` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_color_principal` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_color_secundario` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehiculo_placa` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_motor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_chasis` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `registrado_por` bigint unsigned NOT NULL,
  `user_motorizado_id` bigint unsigned DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `serie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serie_comprobante_ref` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_comprobante_ref` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_comprobante_ref` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_nota_credito` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01',
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `igv` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `moneda` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PEN',
  `estado` enum('pendiente','generado','enviado','aceptado','rechazado','anulado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `xml` text COLLATE utf8mb4_unicode_ci,
  `cdr` text COLLATE utf8mb4_unicode_ci,
  `pdf` longtext COLLATE utf8mb4_unicode_ci,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `codigo_error_sunat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_envio_sunat` timestamp NULL DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `serie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serie_comprobante_ref` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_comprobante_ref` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_comprobante_ref` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_nota_debito` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01',
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `igv` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `moneda` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PEN',
  `estado` enum('pendiente','generado','enviado','aceptado','rechazado','anulado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `xml` text COLLATE utf8mb4_unicode_ci,
  `cdr` text COLLATE utf8mb4_unicode_ci,
  `pdf` longtext COLLATE utf8mb4_unicode_ci,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `codigo_error_sunat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_envio_sunat` timestamp NULL DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo` enum('VENTA_REALIZADA','PAGO_RECIBIDO','COMPROBANTE_GENERADO','CUENTA_POR_COBRAR','RECORDATORIO_PAGO','VOUCHER_VERIFICADO','PEDIDO_ENVIADO','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `canal` enum('EMAIL','WHATSAPP','SMS','SISTEMA') COLLATE utf8mb4_unicode_ci NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `datos_adicionales` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `estado` enum('PENDIENTE','ENVIADO','FALLIDO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `enviado_at` timestamp NULL DEFAULT NULL,
  `error` text COLLATE utf8mb4_unicode_ci,
  `intentos` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notificaciones_user_id_estado_index` (`user_id`,`estado`),
  KEY `notificaciones_tipo_canal_index` (`tipo`,`canal`),
  KEY `notificaciones_estado_index` (`estado`),
  CONSTRAINT `notificaciones_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notificaciones_chk_1` CHECK (json_valid(`datos_adicionales`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destinatario` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `canal` enum('EMAIL','SMS','PUSH','WHATSAPP') COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('PENDIENTE','ENVIADO','FALLIDO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `error_mensaje` text COLLATE utf8mb4_unicode_ci,
  `referencia_tipo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia_id` bigint unsigned DEFAULT NULL,
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitulo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo_oferta_id` int unsigned DEFAULT NULL,
  `tipo_descuento` enum('porcentaje','cantidad_fija') COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `precio_minimo` decimal(10,2) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner_imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color_fondo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '#3B82F6',
  `texto_boton` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Compra ahora',
  `enlace_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '/shop',
  `limite_uso` int DEFAULT NULL,
  `usos_actuales` int DEFAULT '0',
  `activo` tinyint(1) DEFAULT '1',
  `mostrar_countdown` tinyint(1) DEFAULT '0',
  `mostrar_en_slider` tinyint(1) DEFAULT '0',
  `mostrar_en_banner` tinyint(1) DEFAULT '0',
  `prioridad` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `es_oferta_principal` tinyint(1) NOT NULL DEFAULT '0',
  `es_oferta_semana` tinyint(1) NOT NULL DEFAULT '0',
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `oferta_id` int unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `precio_oferta` decimal(10,2) DEFAULT NULL,
  `stock_oferta` int DEFAULT NULL,
  `vendidos_oferta` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `compra_id` bigint unsigned DEFAULT NULL,
  `comprobante_id` bigint unsigned DEFAULT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `moneda` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT 'PEN',
  `referencia_pago` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `proveedor_pago` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Culqi, Niubiz, PayPal, etc',
  `estado` enum('PENDIENTE','APROBADO','RECHAZADO','REEMBOLSADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `fecha_pago` timestamp NULL DEFAULT NULL,
  `fecha_confirmacion` timestamp NULL DEFAULT NULL,
  `datos_adicionales` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'Data del webhook o respuesta de pasarela',
  `ip_origen` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_compra` (`compra_id`),
  KEY `idx_comprobante` (`comprobante_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_metodo_pago` (`metodo_pago`),
  KEY `idx_referencia` (`referencia_pago`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `pagos_chk_1` CHECK (json_valid(`datos_adicionales`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `orden` int NOT NULL DEFAULT '1' COMMENT 'Orden de visualización del paso',
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Título del paso',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del paso',
  `imagen` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ruta de la imagen del paso (opcional)',
  `activo` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Si el paso está activo o no',
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
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `token` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
INSERT INTO `password_reset_tokens` VALUES ('koenjisuzune@gmail.com','$2y$12$.48wHwduy1gHPt.UcSR.ROr8J1uPjkS8ozqZwQE9KWRiTNBn6nIDu','2025-07-08 21:20:51'),('chinchayjuan95@gmail.com','$2y$12$l/vz8ZcWMB6O1fiEwCR7fuFpgzgTT0w5t5uHLFbtIdVaYjdJ3tWXO','2025-08-14 19:10:43'),('ladysct11@gmail.com','$2y$12$kpPC/w8wIIpSCXjs3SMGvumU1QPNFvbX.qEdQdQfSIkhA6J2EKK6K','2025-09-29 08:33:15'),('anasilvia123vv@gmail.com','$2y$12$JwBHsFyJ7TdnmRwGsFqv2.0UIZVkgSmqoi2g9udi6LpcH5qlcCqQq','2025-09-29 09:01:31'),('kiyotakahitori@gmail.com','$2y$12$i8zYrlJkLp5d7sgCSaLgN.2fD8l2nU69WtVPwIDU1A98y0bGtGoIK','2025-10-01 10:49:54'),('systemcraft.pe@gmail.com','$2y$12$DsmdAPP52W5wqq.T9WLsQegFz30S4wn.lBtScK8TNhirZTB5CyH56','2025-11-24 14:38:23'),('umbrellasrl@gmail.com','$2y$12$9vpBEuZU.DCij7e9dQXRaeSRBFXWA95DVB7DSWHqL0byo.inPiUcO','2025-11-24 14:59:06'),('manuel.aguado@magustechnologies.com','$2y$12$h.M1rNMFnG9jHp3I2mIdgeoF5RiA1nzB1Z1LP0tCoBxLSiLnOcdZO','2025-11-24 15:00:33'),('emer17rodrigo@gmail.com','$2y$12$xsB8utSd3YQscQcCFT0H4uk4mFDZNmBBWxr9qfv2lYoynvmUB0CBO','2025-11-24 15:01:28'),('rodrigoyarleque7@gmail.com','$2y$12$SsX5VZOp/NTlQZA2.vKu9Ohen/hr6VAGzN2Htpm5K2SU5OUHIM6r.','2025-12-24 14:35:31');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_detalles`
--

DROP TABLE IF EXISTS `pedido_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_detalles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `codigo_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint unsigned NOT NULL,
  `motorizado_id` bigint unsigned NOT NULL,
  `asignado_por` bigint unsigned DEFAULT NULL COMMENT 'Admin que asigno',
  `estado_asignacion` enum('asignado','aceptado','en_camino','entregado','cancelado') COLLATE utf8mb4_unicode_ci DEFAULT 'asignado',
  `fecha_asignacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aceptacion` timestamp NULL DEFAULT NULL,
  `fecha_inicio` timestamp NULL DEFAULT NULL COMMENT 'Cuando inicia el viaje',
  `fecha_entrega` timestamp NULL DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint unsigned NOT NULL,
  `estado_pedido_id` bigint unsigned NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint unsigned NOT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_pedido` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `cotizacion_id` bigint unsigned DEFAULT NULL,
  `tipo_pedido` enum('directo','desde_cotizacion') COLLATE utf8mb4_unicode_ci DEFAULT 'directo',
  `fecha_pedido` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `estado_pedido_id` bigint unsigned NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `direccion_envio` text COLLATE utf8mb4_unicode_ci,
  `telefono_contacto` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forma_envio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT '0.00',
  `departamento_id` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_id` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_id` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento_nombre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_nombre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_nombre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_completa` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (13,'usuarios.ver','web','2025-06-01 01:11:16','2025-06-05 16:59:57'),(16,'usuarios.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(17,'usuarios.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(18,'usuarios.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(19,'usuarios.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(20,'productos.ver','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(21,'productos.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(22,'productos.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(23,'productos.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(24,'productos.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(25,'categorias.ver','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(26,'categorias.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(27,'categorias.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(28,'categorias.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(29,'categorias.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(30,'banners.ver','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(31,'banners.create','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(32,'banners.edit','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(33,'banners.delete','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(38,'banners_promocionales.ver','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(39,'banners_promocionales.create','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(40,'banners_promocionales.edit','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(41,'banners_promocionales.delete','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(42,'clientes.ver','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(43,'clientes.create','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(44,'clientes.show','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(45,'clientes.edit','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(46,'clientes.delete','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(47,'marcas.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(48,'marcas.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(49,'marcas.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(50,'marcas.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(51,'pedidos.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(52,'pedidos.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(53,'pedidos.show','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(54,'pedidos.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(55,'secciones.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(56,'secciones.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(57,'secciones.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(58,'secciones.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(59,'cupones.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(60,'cupones.show','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(61,'cupones.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(62,'cupones.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(63,'cupones.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(64,'ofertas.ver','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(65,'ofertas.edit','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(66,'ofertas.show','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(67,'ofertas.create','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(68,'ofertas.delete','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(69,'horarios.ver','web','2025-07-14 07:28:35','2025-07-14 07:28:35'),(70,'horarios.create','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(71,'horarios.show','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(72,'horarios.edit','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(73,'horarios.delete','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(74,'empresa_info.ver','web','2025-07-19 06:52:57','2025-07-19 06:52:57'),(75,'empresa_info.edit','web','2025-07-19 06:52:57','2025-07-19 06:52:57'),(76,'envio_correos.ver','web','2025-08-14 17:54:08','2025-08-14 17:54:08'),(77,'envio_correos.edit','web','2025-08-14 17:54:19','2025-08-14 17:54:19'),(78,'reclamos.ver','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(79,'reclamos.show','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(80,'reclamos.edit','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(81,'reclamos.delete','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(86,'cotizaciones.ver','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(87,'cotizaciones.show','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(88,'cotizaciones.create','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(89,'cotizaciones.edit','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(90,'cotizaciones.delete','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(91,'cotizaciones.aprobar','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(92,'compras.ver','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(93,'compras.show','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(94,'compras.create','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(95,'compras.edit','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(96,'compras.delete','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(97,'compras.aprobar','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(98,'envio_correos.create','web','2025-09-16 20:07:13','2025-09-16 20:07:13'),(99,'envio_correos.delete','web','2025-09-16 20:07:13','2025-09-16 20:07:13'),(100,'motorizados.ver','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(101,'motorizados.create','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(102,'motorizados.show','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(103,'motorizados.edit','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(104,'motorizados.delete','web','2025-09-16 20:13:05','2025-09-16 20:13:05'),(105,'pedidos.motorizado.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(106,'pedidos.motorizado.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(107,'pedidos.motorizado.actualizar_estado','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(108,'pedidos.motorizado.actualizar_estado','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(109,'pedidos.motorizado.confirmar_entrega','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(110,'pedidos.motorizado.confirmar_entrega','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(111,'motorizado.perfil.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(112,'motorizado.perfil.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(113,'motorizado.perfil.editar','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(114,'motorizado.perfil.editar','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(115,'motorizado.rutas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(116,'motorizado.rutas.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(117,'motorizado.ubicacion.actualizar','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(118,'motorizado.ubicacion.actualizar','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(119,'motorizado.estadisticas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(120,'motorizado.estadisticas.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(121,'motorizado.chat.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(122,'motorizado.chat.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(123,'motorizado.notificaciones.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(124,'motorizado.notificaciones.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(125,'email_templates.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(126,'email_templates.show','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(127,'email_templates.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(128,'email_templates.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(129,'email_templates.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(130,'ventas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(131,'ventas.show','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(132,'ventas.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(133,'ventas.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(134,'ventas.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(135,'roles.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(136,'roles.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(137,'roles.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(138,'roles.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(139,'recompensas.ver','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(140,'recompensas.create','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(141,'recompensas.show','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(142,'recompensas.edit','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(143,'recompensas.delete','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(144,'recompensas.activate','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(145,'recompensas.analytics','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(146,'recompensas.segmentos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(147,'recompensas.productos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(148,'recompensas.puntos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(149,'recompensas.descuentos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(150,'recompensas.envios','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(151,'recompensas.regalos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(152,'configuracion.ver','web','2025-10-01 09:48:34','2025-10-01 09:48:34'),(153,'configuracion.create','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(154,'configuracion.edit','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(155,'configuracion.delete','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(156,'banners_flash_sales.ver','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(157,'banners_flash_sales.create','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(158,'banners_flash_sales.edit','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(159,'banners_flash_sales.delete','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(160,'banners_ofertas.ver','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(161,'banners_ofertas.create','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(162,'banners_ofertas.edit','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(163,'banners_ofertas.delete','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(164,'contabilidad.cajas.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(165,'contabilidad.cajas.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(166,'contabilidad.cajas.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(167,'contabilidad.kardex.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(168,'contabilidad.kardex.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(169,'contabilidad.cxc.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(170,'contabilidad.cxc.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(171,'contabilidad.cxc.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(172,'contabilidad.cxp.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(173,'contabilidad.cxp.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(174,'contabilidad.cxp.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(175,'contabilidad.proveedores.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(176,'contabilidad.proveedores.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(177,'contabilidad.proveedores.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(178,'contabilidad.caja_chica.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(179,'contabilidad.caja_chica.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(180,'contabilidad.caja_chica.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(181,'contabilidad.flujo_caja.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(182,'contabilidad.flujo_caja.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(183,'contabilidad.flujo_caja.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(184,'contabilidad.reportes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(185,'contabilidad.utilidades.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(186,'contabilidad.utilidades.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(187,'contabilidad.utilidades.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(188,'contabilidad.vouchers.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(189,'contabilidad.vouchers.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(190,'contabilidad.vouchers.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(191,'contabilidad.vouchers.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(192,'facturacion.comprobantes.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(193,'facturacion.comprobantes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(194,'facturacion.comprobantes.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(195,'facturacion.comprobantes.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(196,'facturacion.comprobantes.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(197,'facturacion.comprobantes.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(198,'facturacion.comprobantes.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(199,'facturacion.comprobantes.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(200,'facturacion.comprobantes.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(201,'facturacion.comprobantes.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(202,'facturacion.facturas.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(203,'facturacion.facturas.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(204,'facturacion.facturas.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(205,'facturacion.facturas.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(206,'facturacion.facturas.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(207,'facturacion.facturas.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(208,'facturacion.facturas.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(209,'facturacion.facturas.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(210,'facturacion.series.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(211,'facturacion.series.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(212,'facturacion.series.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(213,'facturacion.series.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(214,'facturacion.series.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(215,'facturacion.series.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(216,'facturacion.notas_credito.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(217,'facturacion.notas_credito.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(218,'facturacion.notas_credito.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(219,'facturacion.notas_credito.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(220,'facturacion.notas_credito.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(221,'facturacion.notas_credito.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(222,'facturacion.notas_credito.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(223,'facturacion.notas_credito.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(224,'facturacion.notas_debito.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(225,'facturacion.notas_debito.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(226,'facturacion.notas_debito.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(227,'facturacion.notas_debito.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(228,'facturacion.notas_debito.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(229,'facturacion.notas_debito.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(230,'facturacion.notas_debito.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(231,'facturacion.notas_debito.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(232,'facturacion.guias_remision.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(233,'facturacion.guias_remision.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(234,'facturacion.guias_remision.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(235,'facturacion.guias_remision.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(236,'facturacion.guias_remision.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(237,'facturacion.guias_remision.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(238,'facturacion.guias_remision.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(239,'facturacion.guias_remision.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(240,'facturacion.certificados.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(241,'facturacion.certificados.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(242,'facturacion.certificados.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(243,'facturacion.certificados.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(244,'facturacion.certificados.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(245,'facturacion.certificados.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(246,'facturacion.certificados.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(247,'facturacion.certificados.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(248,'facturacion.resumenes.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(249,'facturacion.resumenes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(250,'facturacion.resumenes.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(251,'facturacion.resumenes.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(252,'facturacion.resumenes.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(253,'facturacion.resumenes.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(254,'facturacion.bajas.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(255,'facturacion.bajas.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(256,'facturacion.bajas.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(257,'facturacion.bajas.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(258,'facturacion.bajas.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(259,'facturacion.bajas.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(260,'facturacion.auditoria.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(261,'facturacion.auditoria.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(262,'facturacion.reintentos.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(263,'facturacion.reintentos.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(264,'facturacion.reintentos.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(265,'facturacion.reintentos.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(266,'facturacion.catalogos.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(267,'facturacion.catalogos.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(268,'facturacion.empresa.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(269,'facturacion.empresa.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(270,'facturacion.empresa.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(271,'facturacion.empresa.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(272,'facturacion.contingencia.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(273,'facturacion.contingencia.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(274,'facturacion.contingencia.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(275,'facturacion.contingencia.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(276,'facturacion.reportes.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(277,'facturacion.reportes.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(278,'facturacion.pagos.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(279,'facturacion.pagos.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(280,'facturacion.pagos.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(281,'facturacion.pagos.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(282,'facturacion.pagos.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(283,'facturacion.pagos.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(284,'facturacion.pagos.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(285,'facturacion.pagos.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(286,'facturacion.pagos.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(287,'facturacion.pagos.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(288,'facturacion.historial_envios.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(289,'facturacion.historial_envios.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(290,'facturacion.historial_envios.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(291,'facturacion.historial_envios.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(292,'facturacion.historial_envios.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(293,'facturacion.historial_envios.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(294,'facturacion.logs.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(295,'facturacion.logs.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(296,'facturacion.logs.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(297,'facturacion.logs.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(298,'facturacion.logs.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(299,'facturacion.logs.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(300,'facturacion.logs.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(301,'facturacion.logs.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(302,'facturacion.configuracion.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(303,'facturacion.configuracion.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(304,'facturacion.configuracion.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(305,'facturacion.configuracion.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(306,'facturacion.integraciones.ver','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(307,'facturacion.integraciones.ver','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(308,'facturacion.integraciones.show','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(309,'facturacion.integraciones.show','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(310,'facturacion.integraciones.create','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(311,'facturacion.integraciones.create','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(312,'facturacion.integraciones.edit','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(313,'facturacion.integraciones.edit','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(314,'facturacion.integraciones.delete','web','2025-10-28 08:31:23','2025-10-28 08:31:23'),(315,'facturacion.integraciones.delete','api','2025-10-28 08:31:23','2025-10-28 08:31:23'),(316,'recompensas.popups','web','2025-10-28 08:31:24','2025-10-28 08:31:24'),(317,'recompensas.notificaciones','web','2025-10-28 08:31:24','2025-10-28 08:31:24'),(318,'ventas.facturar','api','2025-10-28 16:22:32','2025-10-28 16:22:32'),(319,'ventas.facturar','web','2025-10-28 17:54:42','2025-10-28 17:54:42'),(320,'pasos_envio.edit','web','2025-11-04 19:40:21','2025-11-04 19:40:21'),(321,'contabilidad.cajas.crear','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(322,'contabilidad.cajas.editar','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(323,'contabilidad.cajas.aperturar','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(324,'contabilidad.cajas.cerrar','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(325,'contabilidad.cajas.transaccionar','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(326,'contabilidad.cajas.reportes','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(327,'contabilidad.kardex.ajustar','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(328,'contabilidad.cuentas-cobrar.ver','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(329,'contabilidad.cuentas-cobrar.crear','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(330,'contabilidad.cuentas-cobrar.pagar','api','2026-01-09 04:29:15','2026-01-09 04:29:15'),(331,'contabilidad.cuentas-cobrar.reportes','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(332,'contabilidad.cuentas-pagar.ver','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(333,'contabilidad.cuentas-pagar.crear','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(334,'contabilidad.cuentas-pagar.editar','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(335,'contabilidad.cuentas-pagar.eliminar','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(336,'contabilidad.cuentas-pagar.pagar','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(337,'contabilidad.cuentas-pagar.reportes','api','2026-01-09 04:29:16','2026-01-09 04:29:16'),(338,'contabilidad.cajas.ver','web','2026-01-09 04:30:08','2026-01-09 04:30:08'),(339,'contabilidad.cajas.crear','web','2026-01-09 04:30:08','2026-01-09 04:30:08'),(340,'contabilidad.cajas.editar','web','2026-01-09 04:30:08','2026-01-09 04:30:08'),(341,'contabilidad.cajas.aperturar','web','2026-01-09 04:30:08','2026-01-09 04:30:08'),(342,'contabilidad.cajas.cerrar','web','2026-01-09 04:30:08','2026-01-09 04:30:08'),(343,'contabilidad.cajas.transaccionar','web','2026-01-09 04:30:08','2026-01-09 04:30:08'),(344,'contabilidad.cajas.reportes','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(345,'contabilidad.kardex.ver','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(346,'contabilidad.kardex.ajustar','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(347,'contabilidad.cuentas-cobrar.ver','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(348,'contabilidad.cuentas-cobrar.crear','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(349,'contabilidad.cuentas-cobrar.pagar','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(350,'contabilidad.cuentas-cobrar.reportes','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(351,'contabilidad.cuentas-pagar.ver','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(352,'contabilidad.cuentas-pagar.crear','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(353,'contabilidad.cuentas-pagar.editar','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(354,'contabilidad.cuentas-pagar.eliminar','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(355,'contabilidad.cuentas-pagar.pagar','web','2026-01-09 04:30:09','2026-01-09 04:30:09'),(356,'contabilidad.cuentas-pagar.reportes','web','2026-01-09 04:30:09','2026-01-09 04:30:09');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`) USING BTREE,
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=469 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (4,'App\\Models\\User',1,'auth_token','8f4fcd36aec6e8130083429a06243bc1641af0ecfbd9243dd5e83df7bae1786f','[\"*\"]','2025-06-06 15:08:00',NULL,'2025-06-06 14:53:46','2025-06-06 15:08:00'),(5,'App\\Models\\User',1,'auth_token','74b6c21260891055a70eccb26735e97d57f9f835944352ff62f723421cb5d8dd','[\"*\"]','2025-06-06 16:03:42',NULL,'2025-06-06 14:55:09','2025-06-06 16:03:42'),(6,'App\\Models\\User',1,'auth_token','744ca78aa44496a4ccc50a29ca6a15ac3f8618751a2a696bfce752f1fc062e17','[\"*\"]','2025-06-06 16:25:33',NULL,'2025-06-06 16:05:49','2025-06-06 16:25:33'),(19,'App\\Models\\UserCliente',1,'cliente_token','60989d38106b9316eb8678ddc3bd0c3697e21d536a4d1144ef999025e4f3275f','[\"*\"]',NULL,NULL,'2025-06-19 14:19:03','2025-06-19 14:19:03'),(22,'App\\Models\\UserCliente',2,'cliente_token','687175aa5df11ec748948acb23373c2dc990146962f227cf9ec30c059c98d7ed','[\"*\"]',NULL,NULL,'2025-06-19 15:25:53','2025-06-19 15:25:53'),(29,'App\\Models\\UserCliente',3,'cliente_token','db7ce46df909698d7b41949808581814c4f308d08d96fc144879e845585079a2','[\"*\"]',NULL,NULL,'2025-06-23 19:36:35','2025-06-23 19:36:35'),(37,'App\\Models\\User',1,'admin_token','1caf6bf018ea1a00457167d8d2426c4eb197bd4e99e416eb9c8f215bb6d66e7d','[\"*\"]','2025-06-30 12:47:31',NULL,'2025-06-30 12:46:19','2025-06-30 12:47:31'),(40,'App\\Models\\User',1,'admin_token','86d76b8819ea43ab9300497e682816b15fcb29c0f80773f389e6c151385b82fc','[\"*\"]','2025-07-05 13:59:12',NULL,'2025-07-05 13:59:10','2025-07-05 13:59:12'),(43,'App\\Models\\UserCliente',4,'cliente_token','9d1ac1230cc9f5e410875ebe38e73c5ec3eee6e9c715c7219e7ca5ea3c853870','[\"*\"]',NULL,NULL,'2025-07-05 20:26:29','2025-07-05 20:26:29'),(44,'App\\Models\\UserCliente',4,'auth_token','dced180bfc593b10d68995beb42f16dee7668e9841671b652f77e3958bdd5891','[\"*\"]',NULL,NULL,'2025-07-06 11:48:36','2025-07-06 11:48:36'),(45,'App\\Models\\UserCliente',4,'auth_token','b7d48ef1eeee919ed326b015ab98756d2c6095934b4a5096d77120c138a7d49c','[\"*\"]',NULL,NULL,'2025-07-06 11:58:36','2025-07-06 11:58:36'),(46,'App\\Models\\UserCliente',4,'auth_token','52e04aba84e4cf8f3ab6b522bad1b4fd3529ac216fa46eff102174bd059a103b','[\"*\"]',NULL,NULL,'2025-07-06 12:00:50','2025-07-06 12:00:50'),(49,'App\\Models\\UserCliente',4,'auth_token','68a7ae5305c6bee694e4fd5c7f39e5890f565c3996b1da86830bdb1b9c9c7754','[\"*\"]',NULL,NULL,'2025-07-06 13:03:13','2025-07-06 13:03:13'),(51,'App\\Models\\UserCliente',5,'cliente_token','890d752f34f61c902014f081e075cb1d7c4852ed7f72186f5cd37e5fce6df759','[\"*\"]',NULL,NULL,'2025-07-08 21:20:38','2025-07-08 21:20:38'),(62,'App\\Models\\User',1,'admin_token','7ea7ad9514959726f25963b3b547cdfc3e68b1112712c04d5e762a49eba58fd9','[\"*\"]','2025-07-11 15:03:36',NULL,'2025-07-11 15:00:06','2025-07-11 15:03:36'),(66,'App\\Models\\UserCliente',3,'auth_token','907c881583064cc503cf4ae3dbf90a8ceb983458533cf4bd2ec3e7eb3712b3cb','[\"*\"]',NULL,NULL,'2025-07-11 20:35:13','2025-07-11 20:35:13'),(67,'App\\Models\\UserCliente',4,'auth_token','bf330d25cf90acb2032d589206307144a3d9cd1ba44f0fab5ea4e898229ca297','[\"*\"]',NULL,NULL,'2025-07-11 23:46:31','2025-07-11 23:46:31'),(70,'App\\Models\\User',1,'admin_token','cd76d143710dac9271017ee4e23174939759a04ac33fdd9e7cbb4eeff3e15772','[\"*\"]','2025-07-14 00:51:14',NULL,'2025-07-14 00:51:05','2025-07-14 00:51:14'),(72,'App\\Models\\User',1,'admin_token','2154a61002d3017078113a8588a5bc3c77585b2a52b3198485c0b56431b79427','[\"*\"]','2025-07-14 07:43:54',NULL,'2025-07-14 07:36:21','2025-07-14 07:43:54'),(77,'App\\Models\\User',1,'admin_token','f9ff984b68d3898908f791dd3e34463f6b6b1ba1f6d58f0b6e6b9ce716d89bd4','[\"*\"]','2025-07-16 14:21:07',NULL,'2025-07-16 14:21:03','2025-07-16 14:21:07'),(78,'App\\Models\\User',1,'admin_token','150db278f254dd606190f73656b5f6e0393811f889042443c1b0a50a172e95ef','[\"*\"]','2025-07-16 17:43:46',NULL,'2025-07-16 15:17:53','2025-07-16 17:43:46'),(83,'App\\Models\\User',1,'admin_token','993828ecddc03aa1ee2bdc0215a1b332afe3858cac6e0562424f8619e666675a','[\"*\"]','2025-07-20 19:26:02',NULL,'2025-07-20 19:25:49','2025-07-20 19:26:02'),(87,'App\\Models\\User',1,'admin_token','96f578aaa56372f292fbc0e59e4b1aba6c4b11b4254ecb588ce8bc5b4bab1895','[\"*\"]',NULL,NULL,'2025-07-21 17:30:39','2025-07-21 17:30:39'),(88,'App\\Models\\User',1,'admin_token','5c4c11a37cd9892fd090954ad1d38726f80b5b91621c2edfdef5bca166d820c0','[\"*\"]','2025-07-21 17:36:50',NULL,'2025-07-21 17:30:55','2025-07-21 17:36:50'),(90,'App\\Models\\User',1,'admin_token','b2a89c1f02a99410860ab7c442b07e0735ea97a5908af3c0fbb3c2c54a683604','[\"*\"]','2025-07-21 17:54:20',NULL,'2025-07-21 17:37:24','2025-07-21 17:54:20'),(91,'App\\Models\\User',1,'admin_token','2fd667e7fd6ac08eed8ca31226b926eace4bfc9898224c3b4b3003def7794c49','[\"*\"]',NULL,NULL,'2025-07-21 17:40:27','2025-07-21 17:40:27'),(92,'App\\Models\\User',1,'admin_token','f20f446272e44612d56d884f15a439c269f389625abba96817e5f07e4e639fa3','[\"*\"]','2025-07-21 17:52:55',NULL,'2025-07-21 17:40:37','2025-07-21 17:52:55'),(94,'App\\Models\\User',1,'admin_token','ad7f84335226034ab164eed0f5b5e3f10249ab116046fd72152396e3abd426b4','[\"*\"]','2025-07-21 18:47:42',NULL,'2025-07-21 18:13:06','2025-07-21 18:47:42'),(95,'App\\Models\\User',1,'admin_token','5b048aa6ab4043233a71262ce5d7cca172d4f8c5035e2940fa2910a8c6a348af','[\"*\"]','2025-07-21 20:41:27',NULL,'2025-07-21 19:07:30','2025-07-21 20:41:27'),(96,'App\\Models\\User',1,'admin_token','2f480e8d6d2647d9ff50852c9c20675bb73bf89d22df9fdad3aeea7628779645','[\"*\"]','2025-07-21 19:30:04',NULL,'2025-07-21 19:29:57','2025-07-21 19:30:04'),(98,'App\\Models\\User',1,'admin_token','880e19f2824211b07ef2a60a8feb3750c22fb7cd2beaa23d880b53577fa57efe','[\"*\"]','2025-07-21 21:02:11',NULL,'2025-07-21 20:18:24','2025-07-21 21:02:11'),(99,'App\\Models\\User',1,'admin_token','0c3b8719c1c8fe7132f81032df3dae9b30815bf5e8b82f66044ce4a10d2a5e3d','[\"*\"]','2025-07-22 07:26:56',NULL,'2025-07-22 07:24:13','2025-07-22 07:26:56'),(100,'App\\Models\\User',1,'admin_token','e8230545d2897115b6da740cea5cd0a1ffb8a72f8a83a96140a6c245fbb42ca9','[\"*\"]','2025-07-22 16:28:55',NULL,'2025-07-22 16:25:01','2025-07-22 16:28:55'),(101,'App\\Models\\User',1,'admin_token','7036282da78c49de8c73e2976cf3b6a6ea94eafbeede07152b8d98438eafe845','[\"*\"]','2025-07-22 16:30:12',NULL,'2025-07-22 16:27:24','2025-07-22 16:30:12'),(103,'App\\Models\\UserCliente',15,'cliente_token','8f5ef3665296f0b55c41531996b8c6c3fd5b432005eae8d7c3b7d2f05460eefb','[\"*\"]',NULL,NULL,'2025-07-24 15:16:52','2025-07-24 15:16:52'),(104,'App\\Models\\User',1,'admin_token','cb277db29a46841f8b66c7f95f82360b3a392c34729cbd82f0285af1b16e39de','[\"*\"]','2025-07-24 15:22:08',NULL,'2025-07-24 15:21:19','2025-07-24 15:22:08'),(106,'App\\Models\\User',1,'admin_token','b7a85cd149e6302e0995de9a810b89f25742ce8703760953f74a2ec016bfa7b0','[\"*\"]','2025-07-30 14:02:34',NULL,'2025-07-30 13:56:52','2025-07-30 14:02:34'),(107,'App\\Models\\User',1,'admin_token','6ccbfa1d89fb43c71d2af2b19f915690111d35154fc1c1f1b8ec9aabf8d1255c','[\"*\"]','2025-07-30 14:07:01',NULL,'2025-07-30 14:06:13','2025-07-30 14:07:01'),(108,'App\\Models\\User',1,'admin_token','735884c3b152fb5c0bda6f1974e68d1de379676947039eb141bfe00d305f183d','[\"*\"]','2025-08-15 13:53:36',NULL,'2025-08-01 16:07:28','2025-08-15 13:53:36'),(109,'App\\Models\\User',1,'admin_token','7c76a275c0008bc8cb965db622fc1069be4e49a8c51b61cf0a1730191fe5d3d0','[\"*\"]','2025-08-14 19:10:29',NULL,'2025-08-14 18:00:19','2025-08-14 19:10:29'),(110,'App\\Models\\User',1,'admin_token','16b287b0f727a012ac30fb672545debac244e624a5fed526356bb72d5ac303a0','[\"*\"]','2025-08-14 20:13:53',NULL,'2025-08-14 19:46:15','2025-08-14 20:13:53'),(111,'App\\Models\\User',1,'admin_token','d0fa5e1b4b7f2217ef5fa1b840af52521133336cef5f4af08a64f94ea06b7e5b','[\"*\"]','2025-10-06 08:16:51',NULL,'2025-08-15 09:39:11','2025-10-06 08:16:51'),(113,'App\\Models\\User',1,'admin_token','9b6c64de7fbb30e893a84680f60dd73c87f4ea7678f1a841defd752e9b7210fb','[\"*\"]','2025-08-19 06:15:58',NULL,'2025-08-16 10:16:17','2025-08-19 06:15:58'),(114,'App\\Models\\UserCliente',3,'cliente_token','e71654541326a40b0c78de84e28c7dbe74a715ec685bd6738214e25f920d25ac','[\"*\"]','2025-08-22 15:43:28',NULL,'2025-08-22 12:24:14','2025-08-22 15:43:28'),(116,'App\\Models\\User',1,'admin_token','4d1918d2e897d91fd1ba9e35274c552ac568ba873e351d2722be3f12b935b7d3','[\"*\"]','2025-09-01 11:55:04',NULL,'2025-09-01 06:55:41','2025-09-01 11:55:04'),(120,'App\\Models\\User',1,'admin_token','66e1f4c894f4f46b0562e5dde878854e6ee23057bade0878da201452ae0a95c2','[\"*\"]','2025-09-02 14:30:48',NULL,'2025-09-02 14:29:58','2025-09-02 14:30:48'),(123,'App\\Models\\UserCliente',21,'auth_token','baf8edec9af883f8d9ae91738e187cd858084058da96e5c2510527f8cd9eb3fe','[\"*\"]',NULL,NULL,'2025-09-07 20:08:06','2025-09-07 20:08:06'),(124,'App\\Models\\UserCliente',21,'auth_token','5dd197ee8640061b735a6fed7a5d6cf01abb670824ad11091aca4654e94de6a1','[\"*\"]',NULL,NULL,'2025-09-07 20:11:27','2025-09-07 20:11:27'),(125,'App\\Models\\UserCliente',21,'cliente_token','ab8b6a68ac7f2de4b6c839d2d63eb60323621b7d9bd5cc86edb17c7aa66f7ac4','[\"*\"]','2025-09-09 13:41:14',NULL,'2025-09-08 05:33:17','2025-09-09 13:41:14'),(138,'App\\Models\\User',1,'admin_token','fa8e9206f44fe4da1b8c250edfecb65553d85a099d779883f1b6473d7dbe8e1e','[\"*\"]','2025-09-16 20:57:48',NULL,'2025-09-16 20:44:16','2025-09-16 20:57:48'),(139,'App\\Models\\UserCliente',22,'auth_token','b004b92b094cfba1a69970c56e22e1934b82b4c9ad3f97ef1a48e0775a5eeaa6','[\"*\"]',NULL,NULL,'2025-09-18 10:45:08','2025-09-18 10:45:08'),(142,'App\\Models\\UserCliente',4,'auth_token','fc019d01512299e18d2ebe886e673ee23d7279e8547b93c09f95a4fc3d524bfb','[\"*\"]',NULL,NULL,'2025-09-18 16:02:11','2025-09-18 16:02:11'),(143,'App\\Models\\UserCliente',4,'auth_token','55cdb3975d71f6018c21b9d472428e0f2700aaf8bdb04f35dd6044b8a697e49a','[\"*\"]',NULL,NULL,'2025-09-18 16:02:54','2025-09-18 16:02:54'),(144,'App\\Models\\UserCliente',4,'auth_token','3b268de24d46a9e550c5bd613f96bf0e9bb6dcc5b169ac5d575579b6968786e1','[\"*\"]',NULL,NULL,'2025-09-18 16:03:15','2025-09-18 16:03:15'),(145,'App\\Models\\UserCliente',4,'auth_token','0f664a6102c4bc4cbac811c2eb9c1db3accd0cbe41b0485d0b15d178fa2860c8','[\"*\"]',NULL,NULL,'2025-09-18 16:04:56','2025-09-18 16:04:56'),(146,'App\\Models\\UserCliente',4,'auth_token','72f249d67022798ff78b9b1145971286ee7d846f9a9ed44839abf2c6e0769f6d','[\"*\"]',NULL,NULL,'2025-09-18 16:05:03','2025-09-18 16:05:03'),(147,'App\\Models\\UserCliente',4,'auth_token','8d11acbda58f0273824bf7652b8044fd79090aeff81229753100a0e6e0a16c20','[\"*\"]',NULL,NULL,'2025-09-18 16:34:44','2025-09-18 16:34:44'),(148,'App\\Models\\UserCliente',4,'auth_token','4fe87c278c1ece0ebb4d91cf98a977686402fe5b151a0c629f37c1f4bb7c1ca1','[\"*\"]',NULL,NULL,'2025-09-18 16:50:11','2025-09-18 16:50:11'),(149,'App\\Models\\UserCliente',4,'auth_token','d6c38ab8d2d7b47383e203e238c707c01b1fb3324266f31bd632c81739546c19','[\"*\"]',NULL,NULL,'2025-09-18 16:53:04','2025-09-18 16:53:04'),(150,'App\\Models\\UserCliente',4,'auth_token','be2609afbba1c418f7ef57901578f67af46fce7d126e694c8b484ee1ec5c2824','[\"*\"]',NULL,NULL,'2025-09-18 17:06:40','2025-09-18 17:06:40'),(151,'App\\Models\\UserCliente',4,'auth_token','cc3092d48fa238d13ccfb6209ec7a3fdf56696232521c949dcb1e3b4b53f7b56','[\"*\"]',NULL,NULL,'2025-09-18 17:38:01','2025-09-18 17:38:01'),(153,'App\\Models\\UserCliente',4,'auth_token','91705e5ab5a08c99acce328cb738b1cd6bb033dd0073c48a39ba1050fd54ca0a','[\"*\"]',NULL,NULL,'2025-09-19 11:04:48','2025-09-19 11:04:48'),(154,'App\\Models\\UserCliente',4,'auth_token','f8efbbcb7816b7b7e11198b06e05a1515bee1d54afd09ef7e41e183fe57536f6','[\"*\"]',NULL,NULL,'2025-09-19 13:59:23','2025-09-19 13:59:23'),(158,'App\\Models\\User',1,'admin_token','982fecff465dcf11514d62cc3bb5acc61aeffb0c9234b211bc0cde7e151ff93a','[\"*\"]','2025-10-04 15:33:29',NULL,'2025-09-20 07:43:06','2025-10-04 15:33:29'),(159,'App\\Models\\UserCliente',3,'cliente_token','9b9cfbf83fbe08d3c5302ca8dc2a4ab8ea34eadec76053f53dd4b8e21787f2de','[\"*\"]','2025-09-22 08:20:25',NULL,'2025-09-22 08:00:07','2025-09-22 08:20:25'),(162,'App\\Models\\UserMotorizado',2,'motorizado_token','f559dd0a5e0824e3a5931f96fddd08eb575041fd0e21670bd74f34dbff66fd91','[\"*\"]','2025-09-22 08:45:16',NULL,'2025-09-22 08:45:15','2025-09-22 08:45:16'),(163,'App\\Models\\UserMotorizado',2,'motorizado_token','bfee38ebfc3ce87a18ead59b5174186baf945b99b9f1b0285304e78c1b60ab5e','[\"*\"]','2025-09-22 08:45:21',NULL,'2025-09-22 08:45:21','2025-09-22 08:45:21'),(164,'App\\Models\\UserMotorizado',2,'motorizado_token','1614f5729dd2d4a937c5901c34942a8489d9b9f7d95b59de841f7dbeaf4788bd','[\"*\"]','2025-09-22 08:45:24',NULL,'2025-09-22 08:45:22','2025-09-22 08:45:24'),(168,'App\\Models\\User',1,'admin_token','bd2829570b93a7490d1b750bdd65800e6f52d75484ba3305be38a5380747f01f','[\"*\"]','2025-09-23 13:24:20',NULL,'2025-09-23 13:24:19','2025-09-23 13:24:20'),(175,'App\\Models\\User',1,'admin_token','9b2ebcb36e17ab6e3a7be01de8c402c802eacc16c60994818e4206806eae1ef3','[\"*\"]','2025-09-26 05:20:19',NULL,'2025-09-24 07:55:58','2025-09-26 05:20:19'),(176,'App\\Models\\User',1,'admin_token','b1d41640bec2e3b10b7fff12d65a5e2dea2b1596ecf29daf50d9238325273348','[\"*\"]','2025-09-25 18:55:04',NULL,'2025-09-25 18:44:57','2025-09-25 18:55:04'),(178,'App\\Models\\User',1,'admin_token','8eb07561bb99c0b12a483a8e63e66274c1db554d821683b875307b9b5efbf8fd','[\"*\"]','2025-09-26 05:24:04',NULL,'2025-09-26 05:22:18','2025-09-26 05:24:04'),(180,'App\\Models\\User',1,'admin_token','bacfefad2159f9d2939a834c7609d9d2c7b40ea8659cda094c2b3d0d0950cb18','[\"*\"]','2025-09-26 05:49:06',NULL,'2025-09-26 05:45:02','2025-09-26 05:49:06'),(181,'App\\Models\\User',1,'admin_token','e73a6787e0e74eed561a15b62f0bcafa6b55e9f48d0e81d7337d1fb4b15a4b7f','[\"*\"]','2025-09-26 06:46:06',NULL,'2025-09-26 06:45:51','2025-09-26 06:46:06'),(186,'App\\Models\\User',1,'admin_token','f0749aef86de1150567760c2056f03f26201732162a5f40673d7c7e810ae18eb','[\"*\"]','2025-09-26 14:45:09',NULL,'2025-09-26 14:28:47','2025-09-26 14:45:09'),(188,'App\\Models\\UserCliente',31,'auth_token','2b3dcf78965d8810ff60ad2e88b77d544496b6ce32861f817094951d9c8b7435','[\"*\"]',NULL,NULL,'2025-09-27 12:46:42','2025-09-27 12:46:42'),(194,'App\\Models\\User',1,'admin_token','e4400ef6897f879485bd01e2de9da1c3682a8709e53a58647bb4c3865dde58d4','[\"*\"]','2025-09-28 13:39:55',NULL,'2025-09-27 19:00:51','2025-09-28 13:39:55'),(204,'App\\Models\\User',1,'admin_token','276f0575f7bf728d388a73e61871ff65054a5293f39fe1a4027bb4eb8f55b1cc','[\"*\"]','2025-09-29 16:10:18',NULL,'2025-09-29 10:47:13','2025-09-29 16:10:18'),(209,'App\\Models\\User',1,'admin_token','9c12615c952aec4edd571be15d70297ca312cf9af14c74500ffa41fa3a370d17','[\"*\"]','2025-10-01 14:11:49',NULL,'2025-10-01 07:55:30','2025-10-01 14:11:49'),(213,'App\\Models\\User',1,'admin_token','bf0f3c70899a37668d9ea07764c24d8a01c3e04f4d5da062a1d0dff743d3a1b6','[\"*\"]','2025-10-01 11:56:20',NULL,'2025-10-01 11:55:00','2025-10-01 11:56:20'),(214,'App\\Models\\User',1,'admin_token','64b62e5a717dd5e54dc165f389363f00597ad25cd8ef2d5a2355af1d02115d2f','[\"*\"]','2025-10-21 06:16:15',NULL,'2025-10-01 14:13:11','2025-10-21 06:16:15'),(216,'App\\Models\\User',1,'admin_token','b9be3b6ae44b52b49dea12bad647446aae66c454f31c72a90e8f259016f3a0c0','[\"*\"]','2025-10-02 10:21:13',NULL,'2025-10-02 10:20:56','2025-10-02 10:21:13'),(217,'App\\Models\\User',1,'admin_token','9f462cb7aad400085c251d006025cd257c4bf671e8f15c86ce0bada587d67e50','[\"*\"]','2025-10-02 19:07:50',NULL,'2025-10-02 19:07:09','2025-10-02 19:07:50'),(218,'App\\Models\\User',1,'admin_token','efb945ccbb1c3e7ab06a199cf0132aaf5b8f48f043276b5402d046ce6bd71fdb','[\"*\"]','2025-10-03 09:35:12',NULL,'2025-10-03 09:18:12','2025-10-03 09:35:12'),(219,'App\\Models\\User',1,'admin_token','eddf9c55e17a83417e0965d5d7bd68e0bc9e137563e2821bfe3c591641da48f9','[\"*\"]','2025-10-03 11:50:14',NULL,'2025-10-03 11:05:34','2025-10-03 11:50:14'),(223,'App\\Models\\User',1,'admin_token','1a67b02a9b6bca349919032a5c78447815c8d13ae63e1c77a90e08e94edaf50e','[\"*\"]','2025-10-04 15:15:34',NULL,'2025-10-04 15:13:22','2025-10-04 15:15:34'),(224,'App\\Models\\User',1,'admin_token','7c7c97a9938d8f571fb9426b86be3ebe4f821b03edba4e6f7f88b0dd237980c7','[\"*\"]','2025-10-04 15:20:31',NULL,'2025-10-04 15:18:08','2025-10-04 15:20:31'),(225,'App\\Models\\User',1,'admin_token','741ccbedb45d8dbc65b99b2b533d9b37d1cc8dd75be7980ab4ae954b73e58d10','[\"*\"]','2025-10-04 17:26:22',NULL,'2025-10-04 17:25:39','2025-10-04 17:26:22'),(234,'App\\Models\\User',1,'admin_token','9e879c02d678fd45b9807834b0d91f758187bfe5b665e1a8ae9f02d9180a2bc6','[\"*\"]','2025-10-29 16:04:25',NULL,'2025-10-06 13:16:01','2025-10-29 16:04:25'),(235,'App\\Models\\User',1,'admin_token','4a79fc985482f73d862fa363f7e900b5c8f1c99c322e8e8473ae30dc0be64960','[\"*\"]','2025-10-12 16:31:12',NULL,'2025-10-12 16:28:59','2025-10-12 16:31:12'),(236,'App\\Models\\User',1,'admin_token','8af316039e37e1a7334e875ed6b9db0ff960902b64c65412fcbb20ebad6d1751','[\"*\"]','2025-10-12 18:23:38',NULL,'2025-10-12 17:54:09','2025-10-12 18:23:38'),(237,'App\\Models\\User',1,'admin_token','7e6a6980e4528cc79653374afd47679847a58ff12777147082eb1f83b47c0ba8','[\"*\"]','2025-10-12 20:08:37',NULL,'2025-10-12 19:04:09','2025-10-12 20:08:37'),(239,'App\\Models\\User',1,'admin_token','82b866fdc3275d7e4f8292ab94823fa54e971e467a29fc063de5d3ed7ceec2f0','[\"*\"]','2025-10-13 08:08:01',NULL,'2025-10-13 08:02:45','2025-10-13 08:08:01'),(243,'App\\Models\\User',1,'admin_token','b48263ac0ad80e1c111918c74604dc9ea15c7f3e2bc432031003e4c44a112321','[\"*\"]','2025-10-24 18:11:42',NULL,'2025-10-24 18:11:38','2025-10-24 18:11:42'),(245,'App\\Models\\User',1,'admin_token','e3dd553bf610d7ebab392c88b37f0c67df3c52363909b3a8631597d785c6a4c2','[\"*\"]','2025-10-27 22:03:41',NULL,'2025-10-27 21:58:48','2025-10-27 22:03:41'),(247,'App\\Models\\User',1,'admin_token','8924d10d3aee593b67e8d07a6bb725f13b56127c06049db479f285cff1d5aae5','[\"*\"]','2025-10-28 10:28:50',NULL,'2025-10-28 08:38:00','2025-10-28 10:28:50'),(249,'App\\Models\\User',1,'admin_token','90727ad652b0b6602a6d6d6fc65caac5c636a3a029821c1a87959202b1550a69','[\"*\"]','2025-10-29 15:32:54',NULL,'2025-10-28 09:48:03','2025-10-29 15:32:54'),(254,'App\\Models\\User',1,'admin_token','a95c54dc25cb601fc3c3cdb632941222efd5c9ed9c3de46fca497de2ebb639db','[\"*\"]','2025-10-28 11:12:03',NULL,'2025-10-28 10:49:32','2025-10-28 11:12:03'),(256,'App\\Models\\User',1,'admin_token','d44c4400bdc6652390d90f25c25cc5cb364914bac8fd00101dd488a5db932565','[\"*\"]','2025-10-28 11:16:31',NULL,'2025-10-28 11:16:16','2025-10-28 11:16:31'),(259,'App\\Models\\User',1,'admin_token','0bec9104e28e90ba5c3777fc72ed423d544ef168c803bebac57f24b33c18cbf9','[\"*\"]','2025-10-28 11:28:41',NULL,'2025-10-28 11:21:56','2025-10-28 11:28:41'),(266,'App\\Models\\User',1,'admin_token','b07461d51db98b393d2a6605e7f9b972b7d61218c1ca94190848da7c2fbfb2e0','[\"*\"]','2025-10-29 17:13:44',NULL,'2025-10-29 16:02:59','2025-10-29 17:13:44'),(271,'App\\Models\\User',1,'admin_token','3e9c67c852337324839c73a49947a51118beeaf5b1416743f115c280d1d5fca4','[\"*\"]','2025-10-29 19:42:50',NULL,'2025-10-29 19:22:13','2025-10-29 19:42:50'),(274,'App\\Models\\User',1,'admin_token','9616c30b1c65accd3855ed739e8ab4ffc6cc51ef3d172469c9f39f464c85b3f5','[\"*\"]','2025-10-29 20:32:27',NULL,'2025-10-29 20:05:02','2025-10-29 20:32:27'),(275,'App\\Models\\User',1,'admin_token','426628176e5fcc5ddbc979ab3c9d5be8125531181499e1bf676699ca433c2274','[\"*\"]','2025-10-29 21:30:36',NULL,'2025-10-29 20:14:25','2025-10-29 21:30:36'),(276,'App\\Models\\User',1,'admin_token','3e81e8bb52ee21417e838450e18f18391f59758b0310f211ce22484d286c82d9','[\"*\"]','2025-10-29 20:35:45',NULL,'2025-10-29 20:35:30','2025-10-29 20:35:45'),(277,'App\\Models\\UserCliente',37,'cliente_token','693500040a2c8c09a13ff6da4f13337a9ea479180d5d9d2ddeb98bd0036917ae','[\"*\"]','2025-10-29 23:43:14',NULL,'2025-10-29 23:38:24','2025-10-29 23:43:14'),(280,'App\\Models\\User',1,'admin_token','ac95b32e00fadde6ff4b2dab80b4e843e2d9ea00a2ab560e729aa63cc9bea621','[\"*\"]','2025-10-31 21:59:41',NULL,'2025-10-31 15:15:08','2025-10-31 21:59:41'),(281,'App\\Models\\User',1,'admin_token','0fcbe6adb58e0980fe36c6e808ab33bb33bfd3ccea310389a0a17516bf26209f','[\"*\"]','2025-10-31 15:52:23',NULL,'2025-10-31 15:52:07','2025-10-31 15:52:23'),(282,'App\\Models\\User',1,'admin_token','83ad8d03cc4cea9e5f6f4cda33688e86793f5fef70f97a6e2e5ebf575f70f6e9','[\"*\"]','2025-11-01 03:37:04',NULL,'2025-10-31 21:48:39','2025-11-01 03:37:04'),(283,'App\\Models\\User',1,'admin_token','b888cce1135aec666cb836c194c1c91d79d29de2f07b8f00be3f100b07b1b92e','[\"*\"]','2025-10-31 21:50:48',NULL,'2025-10-31 21:49:41','2025-10-31 21:50:48'),(284,'App\\Models\\User',1,'admin_token','f93474f75a97e603fd16cdd95d9668a51b3b22947a31de6410bcb1eb26f8ddb3','[\"*\"]','2025-10-31 22:03:17',NULL,'2025-10-31 21:53:49','2025-10-31 22:03:17'),(285,'App\\Models\\User',1,'admin_token','405c3f57625b3e1a32f5cd1de1c585bda8ca632e9eab96cefac4e63091fefc4d','[\"*\"]','2025-10-31 21:59:04',NULL,'2025-10-31 21:55:57','2025-10-31 21:59:04'),(287,'App\\Models\\User',1,'admin_token','7e8d086ea46b13d917664bc2f04f6f6e1a19dffc9dfcbc05582e83e01a2ac15c','[\"*\"]','2025-11-02 14:53:00',NULL,'2025-11-02 03:14:17','2025-11-02 14:53:00'),(288,'App\\Models\\User',1,'admin_token','e4b65ada30d1a2b2e7b37197aa25ae11e16e8bb326c1d7f16692dfda337d8b4d','[\"*\"]','2025-11-03 02:33:56',NULL,'2025-11-03 02:29:39','2025-11-03 02:33:56'),(289,'App\\Models\\User',1,'admin_token','0deaa26cdf31bb2a4030e6dbce7a0aefd6200756058607157ac479dd8396a457','[\"*\"]','2025-11-03 03:15:46',NULL,'2025-11-03 03:09:28','2025-11-03 03:15:46'),(290,'App\\Models\\User',1,'admin_token','062c9ef5163cac7ba523c3d1f1ce7387e743a321192fec4ee93c5fcb0f31d56e','[\"*\"]','2025-11-03 03:40:36',NULL,'2025-11-03 03:23:13','2025-11-03 03:40:36'),(291,'App\\Models\\User',1,'admin_token','13860d023c0d4cdc4f6ebfe0c17995443e0d5dd1ce072674b460cb4f9f4fd58f','[\"*\"]','2025-11-03 03:46:42',NULL,'2025-11-03 03:42:33','2025-11-03 03:46:42'),(293,'App\\Models\\User',1,'admin_token','1e07f0cce2fc347d2f790725bf284f290df29f5e2a44686c7cda33f91b76354e','[\"*\"]','2025-11-03 04:07:24',NULL,'2025-11-03 03:52:34','2025-11-03 04:07:24'),(294,'App\\Models\\User',1,'admin_token','fa3d52d2e673d8f08b029fbf12be9f34215f1cfd87e817a2ca05cb24d95422da','[\"*\"]','2025-11-03 04:59:37',NULL,'2025-11-03 04:07:38','2025-11-03 04:59:37'),(295,'App\\Models\\User',1,'admin_token','638940af925e1e48f35ef630b47a763bde5e652f07de34a824f57cbee5c05d24','[\"*\"]','2025-11-03 05:00:33',NULL,'2025-11-03 04:59:53','2025-11-03 05:00:33'),(296,'App\\Models\\User',1,'admin_token','647cdc3dfd2b7e1da49132b33e888ba9277082b7e34b192e4e567ce12a4413a8','[\"*\"]','2025-11-03 05:14:09',NULL,'2025-11-03 05:03:10','2025-11-03 05:14:09'),(297,'App\\Models\\User',1,'admin_token','ae5937594feb8624b574b8be11fd106f0a6eaa43e0beb6312cdb38888561ba05','[\"*\"]','2025-11-03 20:25:57',NULL,'2025-11-03 05:14:50','2025-11-03 20:25:57'),(299,'App\\Models\\User',1,'admin_token','8f4f2d82c6ca77eb4b65acf29bda8c9c9e39131ee646b02dbe6d61709d26bae4','[\"*\"]','2025-11-03 23:07:22',NULL,'2025-11-03 16:09:36','2025-11-03 23:07:22'),(300,'App\\Models\\User',1,'admin_token','522dddfdadea2f0fee5ce3c0887c256c657569ccffdc271645775a33c8e0a8fb','[\"*\"]','2025-11-03 22:12:41',NULL,'2025-11-03 16:19:51','2025-11-03 22:12:41'),(302,'App\\Models\\User',1,'admin_token','52458d5c31d375fca5f7fd10f0ee6cc34211363655b48447e01b7d2063ca5216','[\"*\"]','2025-11-03 19:13:36',NULL,'2025-11-03 19:12:42','2025-11-03 19:13:36'),(303,'App\\Models\\User',1,'admin_token','5f3c1afc83c48519e5f9ca8ebab7ed984ec72d738a59b7fed18fc6029326938a','[\"*\"]','2025-11-03 20:38:33',NULL,'2025-11-03 20:31:13','2025-11-03 20:38:33'),(304,'App\\Models\\User',1,'admin_token','a74181f514ba143b06df18b0dd932b8e8da4caef8b125627da64576a44798614','[\"*\"]','2025-11-03 22:52:05',NULL,'2025-11-03 22:15:29','2025-11-03 22:52:05'),(305,'App\\Models\\User',1,'admin_token','5a8eb13a107b8a5491c293a4ec0e3b9f163352f9f433ce6fadd6c18f25f2626f','[\"*\"]','2025-11-03 22:59:44',NULL,'2025-11-03 22:46:48','2025-11-03 22:59:44'),(306,'App\\Models\\User',1,'admin_token','ec1c08e0e6ec12a6c4bb7d068e8f54821cb4fd33ca8ffe0104477f77ffb6201c','[\"*\"]','2025-11-03 23:02:07',NULL,'2025-11-03 22:48:28','2025-11-03 23:02:07'),(307,'App\\Models\\User',1,'admin_token','acc060b6f339edd26041c1487f041aac596adab5b3a037a7746b3cb0c0e0593c','[\"*\"]','2025-11-04 15:16:11',NULL,'2025-11-04 15:16:10','2025-11-04 15:16:11'),(308,'App\\Models\\User',1,'admin_token','8e3be0d1d457590c3e39d281d4a189d57a5ec79a3fbbdd07cc4da5816979cd5f','[\"*\"]','2025-11-04 16:16:35',NULL,'2025-11-04 16:15:46','2025-11-04 16:16:35'),(309,'App\\Models\\User',1,'admin_token','88931ac6de845cb826cdf9aaba4c3805cd674ed32f3190264fcd1f392d4db46a','[\"*\"]','2025-11-04 16:54:09',NULL,'2025-11-04 16:15:52','2025-11-04 16:54:09'),(310,'App\\Models\\User',1,'admin_token','d340dc67a658f6d8a0e9f51392526093472a3272b6bd50aaf1871037e04e798a','[\"*\"]','2025-11-04 18:33:02',NULL,'2025-11-04 16:54:57','2025-11-04 18:33:02'),(311,'App\\Models\\UserCliente',24,'auth_token','d1d67e7c06aafa6d880e45b38a1cff1e90ecf51be397cdf3d3ebe22ac86b4480','[\"*\"]','2025-11-04 17:18:26',NULL,'2025-11-04 17:09:00','2025-11-04 17:18:26'),(312,'App\\Models\\User',1,'admin_token','a205e1b6f180dfac0c13f8ef2e932afd150c969bfcbe9208b4129b63a007f97a','[\"*\"]','2025-11-05 01:16:00',NULL,'2025-11-04 19:32:20','2025-11-05 01:16:00'),(314,'App\\Models\\User',1,'admin_token','76cecdb7ba467333e8a3c20680ee41059f7b8e684bd916d26de8da298b9c8501','[\"*\"]','2025-11-04 21:56:50',NULL,'2025-11-04 21:52:38','2025-11-04 21:56:50'),(317,'App\\Models\\UserCliente',24,'auth_token','69ab6085153855adb73bcdd318b6b0cfa578afee879c8811eb858522bab52641','[\"*\"]','2025-11-05 22:23:58',NULL,'2025-11-05 15:44:51','2025-11-05 22:23:58'),(321,'App\\Models\\User',1,'admin_token','870c2cf7d0aa1d7153ab5039aa0331121700ccad70e9f2d20ff2925ba51fdf62','[\"*\"]','2025-11-07 16:42:09',NULL,'2025-11-07 15:06:52','2025-11-07 16:42:09'),(322,'App\\Models\\User',1,'admin_token','f2d46e2e9b45188959be5dc0d0e3278c5688211a3ee2031fa984eb7b295eb051','[\"*\"]','2025-11-10 14:58:02',NULL,'2025-11-10 14:13:51','2025-11-10 14:58:02'),(323,'App\\Models\\User',1,'admin_token','aee0a7a395598532e4c5798cf9dea1ff90282c417e9ac4ca4641e4a75461c5a3','[\"*\"]','2025-11-11 14:21:38',NULL,'2025-11-11 14:19:31','2025-11-11 14:21:38'),(325,'App\\Models\\User',1,'admin_token','37e4469ec3a867f79ed1a0e1160dd935377740ec51376a02545edbc70c486d12','[\"*\"]','2025-11-11 22:15:41',NULL,'2025-11-11 17:34:03','2025-11-11 22:15:41'),(326,'App\\Models\\User',1,'admin_token','41395469e5592124fa314ed00fe6895ed69d11a9a2057458350c6739c8e4db54','[\"*\"]','2025-11-12 15:01:17',NULL,'2025-11-12 13:48:31','2025-11-12 15:01:17'),(327,'App\\Models\\User',1,'admin_token','d1e77fb0d711447bae24a17167340fb7a24885a8032d3389cce3e34be690ef6c','[\"*\"]','2025-11-12 17:01:40',NULL,'2025-11-12 15:02:15','2025-11-12 17:01:40'),(330,'App\\Models\\User',1,'admin_token','fcedf0fb7b31735cd35ee309da83e60d67ce41f5de6ff833e77b2ce638edf7bd','[\"*\"]','2025-11-14 14:51:36',NULL,'2025-11-14 14:06:00','2025-11-14 14:51:36'),(333,'App\\Models\\User',1,'admin_token','666093520776035595bc5e77ac689d53b5ab4feb9268a05d63980a77b25cfc88','[\"*\"]','2025-11-14 22:08:33',NULL,'2025-11-14 22:06:26','2025-11-14 22:08:33'),(335,'App\\Models\\User',1,'admin_token','77a6762867ab4843c6edf8ee3a1aac73a9ca4b587cc2d02016ca393043c6199b','[\"*\"]','2025-11-15 02:58:38',NULL,'2025-11-15 01:48:13','2025-11-15 02:58:38'),(336,'App\\Models\\User',1,'admin_token','31b1baa1f7e3c0746d7b156fcb93e3fb47c90a610dc8c58442bc831737b15505','[\"*\"]','2025-11-15 03:04:46',NULL,'2025-11-15 02:59:24','2025-11-15 03:04:46'),(338,'App\\Models\\User',1,'admin_token','4235a19a231a4994c192b720be523573f12ced5db1d03e7d1ed6bd78494cb5ad','[\"*\"]','2025-11-15 03:14:39',NULL,'2025-11-15 03:10:45','2025-11-15 03:14:39'),(339,'App\\Models\\User',1,'admin_token','e3fc846ffe156975c8451d5e2c12e03ff193aa505a22186039bc90f77d92be51','[\"*\"]','2025-11-15 03:34:57',NULL,'2025-11-15 03:17:59','2025-11-15 03:34:57'),(341,'App\\Models\\User',1,'admin_token','03648aeca6a84588e7c3937260aa3e2377c91a612f62e4657b69bc27f4070738','[\"*\"]','2025-11-15 15:04:29',NULL,'2025-11-15 03:48:34','2025-11-15 15:04:29'),(342,'App\\Models\\User',1,'admin_token','16ae4129dcd03247db5446dbf49326ea676d56a93db3737d61e532d322a9ce3f','[\"*\"]','2025-11-16 03:41:32',NULL,'2025-11-15 23:30:54','2025-11-16 03:41:32'),(345,'App\\Models\\User',1,'admin_token','e708a7e4059c9bfa340dcad116508d9fa88d7d18ed4ce58d33ce47d0c90bbc36','[\"*\"]','2025-11-16 14:32:49',NULL,'2025-11-16 14:32:41','2025-11-16 14:32:49'),(346,'App\\Models\\User',1,'admin_token','c99d13ff0a331f2864de498736c41c23621c7c969e2363bb8b82394095ee71ac','[\"*\"]','2025-11-17 22:54:09',NULL,'2025-11-17 22:41:46','2025-11-17 22:54:09'),(347,'App\\Models\\User',1,'admin_token','ff570b613aa0ae105f6a716d1c083765c9f91fce5a61e6f5c93e41544d1c4124','[\"*\"]','2025-11-18 01:23:27',NULL,'2025-11-18 01:21:03','2025-11-18 01:23:27'),(348,'App\\Models\\User',1,'admin_token','b2f8d366bfdeeb84516bcb5fbaeed6d809b63a6da0b6a56d123fe8f5705e226a','[\"*\"]','2025-11-18 14:05:43',NULL,'2025-11-18 14:05:04','2025-11-18 14:05:43'),(349,'App\\Models\\User',1,'admin_token','5bf4e02c7394ead616989a4a30ed1796d4accf73b66c4fcb55ad6ad628f30e9a','[\"*\"]','2025-11-20 01:19:17',NULL,'2025-11-20 01:04:46','2025-11-20 01:19:17'),(350,'App\\Models\\User',1,'admin_token','469060a2bbb1d3cd2e2ccd2f0ddf5e52b57e5255a7bcbbe18a00a56a6310763c','[\"*\"]','2025-11-23 00:55:14',NULL,'2025-11-23 00:52:28','2025-11-23 00:55:14'),(351,'App\\Models\\User',1,'admin_token','ce7967fdee2d58a9917150a99c8868aabc1969788f93de8cefe577b855b37511','[\"*\"]','2025-11-24 03:34:47',NULL,'2025-11-24 00:14:12','2025-11-24 03:34:47'),(354,'App\\Models\\User',1,'admin_token','b273a2dd8624389f941532add59ed98b50b2fb09ee80427cd2fbaf96303e5ca6','[\"*\"]','2025-11-24 14:52:02',NULL,'2025-11-24 14:51:45','2025-11-24 14:52:02'),(356,'App\\Models\\UserCliente',37,'cliente_token','5bc06bb6a6e5a497b67246f2587394bba41f7d58c862f99adb67e6ac0dd3af58','[\"*\"]','2025-11-24 15:02:51',NULL,'2025-11-24 15:02:13','2025-11-24 15:02:51'),(360,'App\\Models\\User',1,'admin_token','774543c8a248c2f55644ccd6bc9ec8855adc7fa3fae62dc8160e7c80a2c854a2','[\"*\"]','2025-11-24 15:09:39',NULL,'2025-11-24 15:09:37','2025-11-24 15:09:39'),(361,'App\\Models\\User',1,'admin_token','2125188a672d02580049d10a9fa6ee8566f590df13b4ac49db8df27b17310d38','[\"*\"]','2025-11-24 15:11:46',NULL,'2025-11-24 15:10:15','2025-11-24 15:11:46'),(364,'App\\Models\\User',1,'admin_token','28b178446182ab4e900fc4855721a7588f2eac336ef8542242e703038295c75f','[\"*\"]','2025-11-25 14:15:44',NULL,'2025-11-25 14:15:07','2025-11-25 14:15:44'),(365,'App\\Models\\UserCliente',30,'auth_token','9b56188e40a52a3334ad15ab7e508a668ba87c82b2bb431c0928fd1277e22429','[\"*\"]','2025-11-26 01:21:41',NULL,'2025-11-25 23:44:02','2025-11-26 01:21:41'),(366,'App\\Models\\UserCliente',37,'cliente_token','3dedc13a187cef4d02319af8ba341edb9432be79b41865daf9bd713148fae03d','[\"*\"]','2025-11-26 15:08:40',NULL,'2025-11-26 03:14:03','2025-11-26 15:08:40'),(368,'App\\Models\\User',1,'admin_token','56eb1233939b0079eb863c48cce086193dc5b2cf401a4c3ef1edd069ad2f93fe','[\"*\"]','2025-11-26 21:06:26',NULL,'2025-11-26 21:06:18','2025-11-26 21:06:26'),(369,'App\\Models\\User',1,'admin_token','856a3d923916a1e72158cff0ebbd5c439aba7580dc81ed0230dfc373226d2b32','[\"*\"]','2025-11-26 21:09:56',NULL,'2025-11-26 21:07:47','2025-11-26 21:09:56'),(374,'App\\Models\\User',1,'admin_token','6e4ada8df89744ef95fd9f7e7ab25dcec52e1abefc7f7f89b34423a33bf23e7a','[\"*\"]','2025-11-27 12:39:16',NULL,'2025-11-27 12:16:15','2025-11-27 12:39:16'),(375,'App\\Models\\User',1,'admin_token','20bbbabc4564a86c78623a782a3b4005a12e4b863d8fb61c27cfe793aca630e9','[\"*\"]','2025-11-27 14:16:39',NULL,'2025-11-27 14:07:55','2025-11-27 14:16:39'),(379,'App\\Models\\User',1,'admin_token','c379ac58c7742f184d05153c460643bec70e20a4af9cbd1d9d14e028e69aea39','[\"*\"]','2025-11-27 15:30:24',NULL,'2025-11-27 15:29:35','2025-11-27 15:30:24'),(380,'App\\Models\\UserCliente',42,'auth_token','dc59297b51557f3addff57fcb49f75f156ab03d1e370eed0e6cdc9935a1f3a8c','[\"*\"]','2025-11-27 18:54:29',NULL,'2025-11-27 18:54:23','2025-11-27 18:54:29'),(382,'App\\Models\\User',1,'admin_token','4668634b0260ebb39414a8f785620eff9c6a19c69727a826feb22cf7975009c3','[\"*\"]','2025-11-27 21:27:15',NULL,'2025-11-27 20:43:18','2025-11-27 21:27:15'),(384,'App\\Models\\User',1,'admin_token','6d6c1b3da5096e9fcc79c8a7a479422b841deccfc6d704aa8beadf2c5c078433','[\"*\"]','2025-11-27 22:06:18',NULL,'2025-11-27 21:56:46','2025-11-27 22:06:18'),(385,'App\\Models\\User',1,'admin_token','bec72151b0da2a3a7e4e824099a8f01824cfe5b54e6631856bde220220e83ae0','[\"*\"]','2025-11-28 21:01:03',NULL,'2025-11-28 15:47:08','2025-11-28 21:01:03'),(386,'App\\Models\\User',1,'admin_token','fbb01e3ca1aac7fa5d5342c6aa3338c297dc70a3d4b5ace9b1330162e1944b91','[\"*\"]','2025-11-28 23:15:30',NULL,'2025-11-28 16:04:54','2025-11-28 23:15:30'),(387,'App\\Models\\User',1,'admin_token','a791ae167971771112695f1cf85999cab05ecb0419ba0cadf0f0f44b34346eeb','[\"*\"]','2025-11-29 13:25:46',NULL,'2025-11-29 13:19:26','2025-11-29 13:25:46'),(388,'App\\Models\\User',1,'admin_token','92510815be99b606407e4ed8199885926f1f879d05e85c1ae57b1e83933691f6','[\"*\"]','2025-11-29 13:29:53',NULL,'2025-11-29 13:25:56','2025-11-29 13:29:53'),(389,'App\\Models\\User',1,'admin_token','74a0007e0ed80d95fd87a5808aec09be94e8ee531be9c509e8be391fc8dba795','[\"*\"]','2025-11-29 14:26:24',NULL,'2025-11-29 13:30:49','2025-11-29 14:26:24'),(390,'App\\Models\\User',1,'admin_token','c428e2f25199e2e3996caa98e0f917d8822fcec31ce48b995d9e78ab67fb9ca6','[\"*\"]','2025-11-29 16:09:37',NULL,'2025-11-29 15:23:08','2025-11-29 16:09:37'),(391,'App\\Models\\User',1,'admin_token','a187d182f4f6ffbbca6e52300474e3dc984c86fe2780d9f75198b7ba28083fe1','[\"*\"]','2025-11-29 16:27:07',NULL,'2025-11-29 16:26:35','2025-11-29 16:27:07'),(392,'App\\Models\\User',1,'admin_token','b1dfea6449376a1adfa1690bf613c4607852b0703d3e938eedbe37cdad47d671','[\"*\"]','2025-11-29 16:35:58',NULL,'2025-11-29 16:35:57','2025-11-29 16:35:58'),(394,'App\\Models\\User',1,'admin_token','772f12f8abb091c2d7929041963a8b29319f046b470f6e7a735fe4e8b96c0955','[\"*\"]','2025-12-01 01:14:11',NULL,'2025-12-01 01:11:56','2025-12-01 01:14:11'),(395,'App\\Models\\User',1,'admin_token','5036134b5a2f1f08e09b66792b7a428addf64de4147851aaea83ce92407a457f','[\"*\"]','2025-12-01 13:14:05',NULL,'2025-12-01 01:14:37','2025-12-01 13:14:05'),(396,'App\\Models\\User',1,'admin_token','065614815e50fd7f8ef54332112e96e75f2e8b8a6cd51518d72567e6e7a95eda','[\"*\"]','2025-12-01 21:38:26',NULL,'2025-12-01 13:15:07','2025-12-01 21:38:26'),(398,'App\\Models\\User',1,'admin_token','5703d2f838346a33c844143f45212987414cc40064d2f313c319685cd49ff6db','[\"*\"]','2025-12-01 21:16:01',NULL,'2025-12-01 13:36:20','2025-12-01 21:16:01'),(399,'App\\Models\\UserCliente',37,'cliente_token','894cd617083472467c1feb0adec90b2e633c5f6783125806e925c6accb18738e','[\"*\"]','2025-12-01 21:01:35',NULL,'2025-12-01 13:47:16','2025-12-01 21:01:35'),(401,'App\\Models\\User',1,'admin_token','57e6523b292a91a8bcbbb88276801e758a961162c8cef5e6a095cb361f7b8348','[\"*\"]','2025-12-01 22:35:53',NULL,'2025-12-01 17:47:56','2025-12-01 22:35:53'),(403,'App\\Models\\User',1,'admin_token','b6595876368657478997239f31df8ed10a5219b71db0391843d3b9fc0a3c7c84','[\"*\"]','2025-12-01 22:21:08',NULL,'2025-12-01 20:55:41','2025-12-01 22:21:08'),(404,'App\\Models\\User',1,'admin_token','e0a9854a5c464986e60e5cb20d3e8c1a55154542ba624a4508c254ecd3664abe','[\"*\"]','2025-12-01 22:07:56',NULL,'2025-12-01 22:07:21','2025-12-01 22:07:56'),(405,'App\\Models\\User',1,'admin_token','1cbf4dad880b73467e587c72cab0dd3a51550512197023c33f0951257ef4f520','[\"*\"]','2025-12-02 03:29:23',NULL,'2025-12-02 03:22:48','2025-12-02 03:29:23'),(406,'App\\Models\\User',1,'admin_token','eaf79c00fe7c20dbc962101aba2bbad778658f36ad84c21e593c27cbfa4d9bf5','[\"*\"]','2025-12-03 00:20:55',NULL,'2025-12-02 14:00:25','2025-12-03 00:20:55'),(407,'App\\Models\\User',1,'admin_token','087f61aa603cda18fabc17854c3b25a6b146e72bc08b45d323cc931a382d6b83','[\"*\"]','2025-12-03 00:41:03',NULL,'2025-12-02 15:01:07','2025-12-03 00:41:03'),(408,'App\\Models\\User',1,'admin_token','664d9fdd889bc88e831242db110c15dda1f0c564a7a70479cbf806459cf085f2','[\"*\"]','2025-12-02 16:33:27',NULL,'2025-12-02 16:24:14','2025-12-02 16:33:27'),(409,'App\\Models\\User',1,'admin_token','ad0167834e67a460cca9de25a26e6c27b6e6a93e3d283400a4e095c819c7d86f','[\"*\"]','2025-12-03 00:02:14',NULL,'2025-12-03 00:02:09','2025-12-03 00:02:14'),(410,'App\\Models\\User',1,'admin_token','5402f6b2c08fb075a303dd113ae97da007c074feea99c8fb133d3d725d09541a','[\"*\"]','2025-12-04 00:13:31',NULL,'2025-12-03 14:35:12','2025-12-04 00:13:31'),(411,'App\\Models\\User',1,'admin_token','02ad2dd4c8d559d3e057d6ece69daaeaf1dccbf2b15d332c33bd0695f7971a42','[\"*\"]','2025-12-03 23:38:03',NULL,'2025-12-03 18:11:51','2025-12-03 23:38:03'),(412,'App\\Models\\User',1,'admin_token','94d66d7e707089ea1b695c18104e990ad1afd487e889eccef575051c5568d1e3','[\"*\"]','2025-12-07 23:24:58',NULL,'2025-12-07 23:24:17','2025-12-07 23:24:58'),(413,'App\\Models\\User',1,'admin_token','d588c79fca052122513a4e2331f5daed68ad8c6a6901c4fd5e8464a514db8d54','[\"*\"]','2025-12-08 14:35:40',NULL,'2025-12-08 14:35:35','2025-12-08 14:35:40'),(414,'App\\Models\\User',1,'admin_token','3dbb5d676a95879c013a45cd4408f8a6603881f026f334ffa26102a6f43207d1','[\"*\"]','2025-12-12 21:46:33',NULL,'2025-12-12 21:44:44','2025-12-12 21:46:33'),(417,'App\\Models\\User',1,'admin_token','e99bec94ccf35790be2e0608225654f9757b1e2b6201289f87a7568421b9afbf','[\"*\"]','2025-12-15 17:15:57',NULL,'2025-12-15 17:13:59','2025-12-15 17:15:57'),(418,'App\\Models\\User',1,'admin_token','7505b2a2c4f9dba72dbb982614ed0c144635d0aff1762b3eb13afe491aed8a89','[\"*\"]','2025-12-15 21:15:10',NULL,'2025-12-15 18:08:40','2025-12-15 21:15:10'),(419,'App\\Models\\UserCliente',37,'cliente_token','9704a0fd6493607ac417325cf6fea3ac197052301be9cdae1302f372381ad937','[\"*\"]','2025-12-15 19:44:23',NULL,'2025-12-15 19:39:22','2025-12-15 19:44:23'),(420,'App\\Models\\User',1,'admin_token','3ceafe94250b6978d16c431ef67bb6814d22210dbcce190a64135dd12863330e','[\"*\"]','2025-12-17 22:23:01',NULL,'2025-12-17 22:22:53','2025-12-17 22:23:01'),(421,'App\\Models\\User',1,'admin_token','000b3652a8b74fb1be3f9976f56706ef08f535cba8a5fcdad64be7dc0581ba7c','[\"*\"]','2025-12-19 16:12:38',NULL,'2025-12-19 16:11:44','2025-12-19 16:12:38'),(423,'App\\Models\\User',1,'admin_token','8b303d92b5587c12a4c1a9823c8ccedd5e654e9c9727ec0054f69b1a1478134a','[\"*\"]','2025-12-23 17:14:34',NULL,'2025-12-23 14:22:40','2025-12-23 17:14:34'),(424,'App\\Models\\User',1,'admin_token','a2509648dadde405204373d783baef124456842fe73632a20c7d68105e2a0f11','[\"*\"]','2025-12-23 16:15:33',NULL,'2025-12-23 15:01:42','2025-12-23 16:15:33'),(427,'App\\Models\\User',1,'admin_token','5ba7be9e5d55abf5b6c0f457d1e2a6117f0984fb76b5d1e16c41873b1abf6d5a','[\"*\"]','2025-12-24 03:27:19',NULL,'2025-12-23 18:26:18','2025-12-24 03:27:19'),(432,'App\\Models\\User',1,'admin_token','9e9e4795a5ae579421aa9e6a0ab366705b95db34705c955d77965054eff3dc8b','[\"*\"]','2025-12-26 21:02:58',NULL,'2025-12-26 14:05:35','2025-12-26 21:02:58'),(436,'App\\Models\\User',1,'admin_token','a3e14bd6ee73203556a13fa3b70417ace554f8e4537f097826c6dde3241115af','[\"*\"]','2025-12-26 16:00:07',NULL,'2025-12-26 15:25:01','2025-12-26 16:00:07'),(439,'App\\Models\\User',37,'admin_token','86f5be18d3c900d8ee641550579cfaef67bf5c718a5aa8c529eafe583523f0e1','[\"*\"]','2025-12-27 13:43:39',NULL,'2025-12-27 13:42:40','2025-12-27 13:43:39'),(443,'App\\Models\\User',1,'admin_token','bd18ae2e1ad02f4dda54a306b74893acbd40f5745668c9f29df513dd42220e2d','[\"*\"]','2026-01-03 16:46:57',NULL,'2026-01-03 16:17:07','2026-01-03 16:46:57'),(444,'App\\Models\\User',1,'admin_token','882193c9b1f742493a059c73ad0148fa93ccac03d40938074e1cc63870502acf','[\"*\"]','2026-01-03 16:53:10',NULL,'2026-01-03 16:53:05','2026-01-03 16:53:10'),(445,'App\\Models\\User',1,'admin_token','dba761285fd7860284113480e4f1d998c2aa8de38531462fd47110b7e65ca017','[\"*\"]','2026-01-05 19:48:07',NULL,'2026-01-05 19:23:21','2026-01-05 19:48:07'),(446,'App\\Models\\User',1,'admin_token','d7de8cb94db0b70b8838bebdcabab163ed9115d831e2b1d208e6c63ba55c6194','[\"*\"]','2026-01-08 02:43:34',NULL,'2026-01-08 02:43:20','2026-01-08 02:43:34'),(447,'App\\Models\\User',1,'admin_token','4e811307f66b6199aeaaf731b21b424e4a0f53973fbcb86b7699049880111fa7','[\"*\"]','2026-01-08 19:41:32',NULL,'2026-01-08 19:27:28','2026-01-08 19:41:32'),(448,'App\\Models\\User',1,'admin_token','f76424973b5a5789dd1d46596583d26395954d0d1381c08c0b1b25d6a793214b','[\"*\"]','2026-01-08 20:53:37',NULL,'2026-01-08 19:42:03','2026-01-08 20:53:37'),(453,'App\\Models\\User',1,'admin_token','17d8a06186a522a10f43290f4157cc7ab5167d06c135125425a3ebebcd3925cc','[\"*\"]','2026-01-09 00:19:53',NULL,'2026-01-09 00:19:39','2026-01-09 00:19:53'),(454,'App\\Models\\User',1,'admin_token','becbdc9a4fb439af4bced330f3975d9b38fe20061a306ae7d9a0a27071153d5a','[\"*\"]','2026-01-09 00:26:42',NULL,'2026-01-09 00:20:15','2026-01-09 00:26:42'),(457,'App\\Models\\User',1,'admin_token','2cbd1e8a1b221aa46583041e587053068ec506274dda424571a148572b7e4a84','[\"*\"]','2026-01-09 01:42:58',NULL,'2026-01-09 00:50:00','2026-01-09 01:42:58'),(463,'App\\Models\\User',1,'admin_token','7da8a79ad7cfce99cbbb2adaa9c77c5a15e3ac530df3cffbfc8882f7e673ce7b','[\"*\"]','2026-01-09 05:35:45',NULL,'2026-01-09 05:22:23','2026-01-09 05:35:45'),(466,'App\\Models\\User',1,'admin_token','8e47e0fba29b17aa76fab3a848ad28836f09195291499c779fa0ea42d2ae1a6f','[\"*\"]','2026-01-09 09:43:54',NULL,'2026-01-09 08:42:57','2026-01-09 09:43:54'),(467,'App\\Models\\User',1,'admin_token','646e4aa01af9f4519332642da18c2c6df9c527857acd71299c9825b6e6642277','[\"*\"]','2026-01-10 04:13:49',NULL,'2026-01-10 03:50:50','2026-01-10 04:13:49'),(468,'App\\Models\\User',1,'admin_token','b66afe71dec0f9709d683ea576b88a8beb6b57ac08cb83fb41173f8d69ae528c','[\"*\"]','2026-01-10 04:25:15',NULL,'2026-01-10 04:14:08','2026-01-10 04:25:15');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantillas_notificacion`
--

DROP TABLE IF EXISTS `plantillas_notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantillas_notificacion` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('VENTA_REALIZADA','PAGO_RECIBIDO','COMPROBANTE_GENERADO','CUENTA_POR_COBRAR','RECORDATORIO_PAGO','VOUCHER_VERIFICADO','PEDIDO_ENVIADO','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `canal` enum('EMAIL','WHATSAPP','SMS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contenido` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plantillas_notificacion_codigo_unique` (`codigo`),
  CONSTRAINT `plantillas_notificacion_chk_1` CHECK (json_valid(`variables`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `producto_id` bigint unsigned NOT NULL,
  `descripcion_detallada` longtext COLLATE utf8mb4_unicode_ci,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `caracteristicas_tecnicas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `instrucciones_uso` text COLLATE utf8mb4_unicode_ci,
  `garantia` text COLLATE utf8mb4_unicode_ci,
  `politicas_devolucion` text COLLATE utf8mb4_unicode_ci,
  `dimensiones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `imagenes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `videos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `producto_detalles_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `producto_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_detalles`
--

LOCK TABLES `producto_detalles` WRITE;
/*!40000 ALTER TABLE `producto_detalles` DISABLE KEYS */;
INSERT INTO `producto_detalles` VALUES (8,113,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;8700F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;8&nbsp;núcleos&nbsp;con&nbsp;arquitectura&nbsp;Zen&nbsp;4&nbsp;para&nbsp;el&nbsp;socket&nbsp;AM5,&nbsp;que&nbsp;alcanza&nbsp;hasta&nbsp;5.0&nbsp;GHz&nbsp;de&nbsp;velocidad,&nbsp;tiene&nbsp;16MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;soporta&nbsp;memoria&nbsp;DDR5&nbsp;y&nbsp;un&nbsp;TDP&nbsp;de&nbsp;65W.&nbsp;Es&nbsp;una&nbsp;versión&nbsp;sin&nbsp;gráficos&nbsp;integrados&nbsp;(&quot;F&quot;),&nbsp;lo&nbsp;que&nbsp;significa&nbsp;que&nbsp;necesita&nbsp;una&nbsp;tarjeta&nbsp;de&nbsp;video&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 8700F, 4.1\\\\\\/5.0 Ghz, AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 7 8700F, tu PC obtiene el poder necesario para ejecutar todas tus aplicaciones y juegos con una fluidez impresionante. Gracias a su frecuencia de 4.10GHz y 16MB de cach\\\\u00e9, este procesador es ideal para quienes necesitan rendimiento extremo sin comprometer la calidad. El AMD Ryzen 7 8700F est\\\\u00e1 dise\\\\u00f1ado para satisfacer las demandas m\\\\u00e1s altas, ya sea para jugar, crear o trabajar de manera eficiente. Gracias a la ingenier\\\\u00eda de AMD, este procesador es capaz de manejar cargas de trabajo intensivas y multitarea sin esfuerzo, manteniendo tu equipo \\\\u00e1gil y confiable.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764561917_692d13fd830e9.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/QyYfxlSoar0?si=78INtbDO1XJTafk0\\\"]\"','2025-11-27 14:35:56','2025-12-01 20:17:36'),(9,114,'<p>La&nbsp;MSI&nbsp;MAG&nbsp;B860&nbsp;TOMAHAWK&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;ATX&nbsp;para&nbsp;gaming&nbsp;compatible&nbsp;con&nbsp;los&nbsp;procesadores&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;(Serie&nbsp;2)&nbsp;a&nbsp;través&nbsp;del&nbsp;socket&nbsp;LGA&nbsp;1851.&nbsp;Ofrece&nbsp;características&nbsp;premium&nbsp;como&nbsp;PCIe&nbsp;5.0,&nbsp;Thunderbolt&nbsp;4,&nbsp;Wi-Fi&nbsp;7&nbsp;y&nbsp;LAN&nbsp;de&nbsp;5&nbsp;Gbps,&nbsp;además&nbsp;de&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;RAM&nbsp;DDR5.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOTHERBOARD MSI\\\",\\\"detalle\\\":\\\"La serie MAG de MSI es sin\\\\u00f3nimo de estabilidad y durabilidad y est\\\\u00e1 dise\\\\u00f1ada para soportar las sesiones de juego m\\\\u00e1s intensas. Toda la gama presenta una construcci\\\\u00f3n robusta con una dureza similar a la del metal y una excelente disipaci\\\\u00f3n del calor, lo que garantiza la estabilidad de todos los componentes de juego cr\\\\u00edticos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764254728_69286408ebf1a.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/_60XmaYa3UY?si=Aa40bz_jHqhf44Zt\\\"]\"','2025-11-27 14:45:28','2025-11-27 15:02:19'),(10,115,'<p>Con&nbsp;el&nbsp;Razer&nbsp;Basilisk&nbsp;V3&nbsp;X&nbsp;HyperSpeed,&nbsp;no&nbsp;hay&nbsp;límites&nbsp;sobre&nbsp;cómo&nbsp;eliges&nbsp;jugar.&nbsp;Equipado&nbsp;con&nbsp;9&nbsp;controles&nbsp;programables,&nbsp;conectividad&nbsp;inalámbrica&nbsp;de&nbsp;modo&nbsp;dual&nbsp;y&nbsp;Razer&nbsp;Chroma&nbsp;RGB&nbsp;personalizable,&nbsp;está&nbsp;diseñado&nbsp;para&nbsp;responder&nbsp;a&nbsp;un&nbsp;solo&nbsp;maestro:&nbsp;usted.&nbsp;Habilitado&nbsp;a&nbsp;través&nbsp;de&nbsp;Razer&nbsp;Synapse,&nbsp;Razer&nbsp;Hypershift&nbsp;le&nbsp;permite&nbsp;asignar&nbsp;y&nbsp;desbloquear&nbsp;un&nbsp;conjunto&nbsp;de&nbsp;comandos&nbsp;secundarios&nbsp;además&nbsp;de&nbsp;los&nbsp;9&nbsp;controles&nbsp;existentes&nbsp;en&nbsp;el&nbsp;mouse.&nbsp;Como&nbsp;un&nbsp;mouse&nbsp;ergonómico&nbsp;inalámbrico&nbsp;para&nbsp;juegos&nbsp;diseñado&nbsp;para&nbsp;juegos&nbsp;largos,&nbsp;puede&nbsp;pasar&nbsp;mucho&nbsp;tiempo&nbsp;antes&nbsp;de&nbsp;que&nbsp;sea&nbsp;necesario&nbsp;reemplazar&nbsp;las&nbsp;baterías.</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMER RAZER BASILISK V3 26K DPI\\\",\\\"valor\\\":\\\"RAZER\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE RAZER\\\",\\\"detalle\\\":\\\"Crea, controla e impulsa tu estilo de juego con el nuevo Razer Basilisk V3, el rat\\\\u00f3n ergon\\\\u00f3mico para juegos por excelencia para un rendimiento personalizado. Con 10+1 botones programables, una rueda de desplazamiento inteligente y una buena dosis de Razer Chroma\\\\u2122 RGB, es hora de iluminar la competici\\\\u00f3n con tu juego.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764255356_6928667c7bc4d.webp\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/13L6ljqxg_8?si=Jd5xbjbgxlAn6GkF\\\"]\"','2025-11-27 14:55:56','2025-11-27 15:05:38'),(11,116,'<p>La&nbsp;ASUS&nbsp;ROG&nbsp;STRIX&nbsp;B850&nbsp;A&nbsp;GAMING&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;con&nbsp;socket&nbsp;AM5&nbsp;de&nbsp;formato&nbsp;ATX,&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;serie&nbsp;7000,&nbsp;8000&nbsp;y&nbsp;9000.&nbsp;Ofrece&nbsp;características&nbsp;de&nbsp;gama&nbsp;alta&nbsp;como&nbsp;DDR5,&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;la&nbsp;tarjeta&nbsp;gráfica,&nbsp;Wi-Fi&nbsp;7,&nbsp;y&nbsp;una&nbsp;solución&nbsp;de&nbsp;alimentación&nbsp;robusta&nbsp;para&nbsp;soportar&nbsp;procesadores&nbsp;de&nbsp;alto&nbsp;rendimiento.&nbsp;Su&nbsp;diseño&nbsp;también&nbsp;incluye&nbsp;un&nbsp;acabado&nbsp;estético&nbsp;en&nbsp;blanco&nbsp;y&nbsp;una&nbsp;solución&nbsp;de&nbsp;enfriamiento&nbsp;mejorada.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"ASUS ROG \\\",\\\"valor\\\":\\\"PLACA MADRE ASUS ROG STRIX B850 A GAMING WIFI AM5\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS ROG\\\",\\\"detalle\\\":\\\"Eleva tu construcci\\\\u00f3n con la ROG Strix B850-A Gaming WiFi. Con una elegante PCB blanca y compatibilidad con los procesadores AMD Ryzen\\\\u2122 Serie 9000, esta placa base ofrece la potencia y la conectividad necesarias para las aplicaciones avanzadas de IA. Con soporte DDR5, capacidades PCIe 5.0 completas, puerto USB 20 Gbps y WiFi 7, es la mezcla definitiva de estilo y rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764256530_69286b12f0395.webp\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/dqmf7q1o5CI?si=nJsg36EJ8nvYSjtS\\\"]\"','2025-11-27 15:15:30','2025-11-27 15:26:01'),(12,117,'<p>La&nbsp;TARJETA&nbsp;DE&nbsp;VIDEO&nbsp;AMD&nbsp;RADEON&nbsp;XFX&nbsp;SWIFT&nbsp;GLASS&nbsp;9070&nbsp;16GB&nbsp;WHITE&nbsp;EDITION&nbsp;OC&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;alta&nbsp;gama&nbsp;para&nbsp;juegos,&nbsp;con&nbsp;un&nbsp;diseño&nbsp;blanco&nbsp;de&nbsp;triple&nbsp;ventilador&nbsp;de&nbsp;la&nbsp;línea&nbsp;Swift&nbsp;de&nbsp;XFX.&nbsp;Cuenta&nbsp;con&nbsp;16GB&nbsp;de&nbsp;memoria&nbsp;GDDR6,&nbsp;una&nbsp;interfaz&nbsp;PCIe&nbsp;5.0&nbsp;y&nbsp;el&nbsp;chip&nbsp;AMD&nbsp;Radeon&nbsp;RX&nbsp;9070&nbsp;XT&nbsp;con&nbsp;una&nbsp;frecuencia&nbsp;de&nbsp;hasta&nbsp;2970&nbsp;MHz&nbsp;(Boost&nbsp;Clock).&nbsp;Su&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;&quot;Swift&quot;&nbsp;está&nbsp;optimizado&nbsp;para&nbsp;un&nbsp;buen&nbsp;rendimiento&nbsp;térmico&nbsp;y&nbsp;un&nbsp;diseño&nbsp;moderno&nbsp;sin&nbsp;RGB,&nbsp;aunque&nbsp;tiene&nbsp;un&nbsp;logo&nbsp;blanco&nbsp;iluminado.</p>','\"[{\\\"nombre\\\":\\\"CASE ENKORE SHADOW ENK5021 ARGB\\\",\\\"valor\\\":\\\"ENKORE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE ENKORE\\\",\\\"detalle\\\":\\\"Soporte de Placa Madre: ATX\\\\\\/MicroATX\\\\\\/Mini ITX.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764279505_6928c4d11a045.webp\\\"]\"',NULL,'2025-11-27 21:38:25','2025-12-02 20:27:19'),(13,118,'<p>fgbdbgfgdbfgbgfgbf</p>','\"[{\\\"nombre\\\":\\\"sadvvdsa\\\",\\\"valor\\\":\\\"vfdfdvs\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"ghfmhngmf\\\",\\\"detalle\\\":\\\"hmghmgf\\\"}]\"','gbfbgfbgf','bgbgfdbgfgb','bgffgdbgbf','\"[23,23,2,3]\"','\"[\\\"1764422830_692af4ae60d63.jpeg\\\"]\"',NULL,'2025-11-29 13:27:10','2025-11-29 13:27:10'),(14,119,'<p>fgdgfdngfhnhgnfnhgffghnhng</p>','\"[{\\\"nombre\\\":\\\"fdgbgfnd\\\",\\\"valor\\\":\\\"ngfdghn\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"fghgfnd\\\",\\\"detalle\\\":\\\"dfgnfdn\\\"}]\"','nhgfhnfgn','ghfnhgfnhgf','ghfnhgfhnhgfnh','\"[32,32,32,2]\"','\"[\\\"1764422954_692af52ad8ab6.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/www.youtube.com\\\\\\/shorts\\\\\\/JrpvMU8WZ4Y\\\"]\"','2025-11-29 13:29:14','2025-11-29 13:29:14'),(15,122,'<p><strong>El&nbsp;Intel&nbsp;Core&nbsp;i3-10105F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;10ª&nbsp;generación&nbsp;con&nbsp;4&nbsp;núcleos&nbsp;y&nbsp;8&nbsp;hilos,&nbsp;diseñado&nbsp;para&nbsp;el&nbsp;socket&nbsp;LGA&nbsp;1200.&nbsp;Tiene&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;\\(3.7\\)&nbsp;GHz&nbsp;que&nbsp;puede&nbsp;alcanzar&nbsp;los&nbsp;\\(4.4\\)&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;6&nbsp;MB&nbsp;de&nbsp;caché&nbsp;y&nbsp;un&nbsp;TDP&nbsp;de&nbsp;\\(65\\)W.&nbsp;La&nbsp;&quot;F&quot;&nbsp;en&nbsp;su&nbsp;nombre&nbsp;indica&nbsp;que&nbsp;no&nbsp;cuenta&nbsp;con&nbsp;gráficos&nbsp;integrados,&nbsp;por&nbsp;lo&nbsp;que&nbsp;requiere&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;para&nbsp;su&nbsp;funcionamiento. </strong></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I3 10105F\\\",\\\"valor\\\":\\\"intel\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTER CORE\\\",\\\"detalle\\\":\\\"el Intel Core i3-10105F, de 10 generaci\\\\u00f3n para escritorio, con 4 n\\\\u00facleos y 8 hilos, y una frecuencia base de 3.7 GHz que puede alcanzar hasta 4.4 GHz con Turbo Boost. Posee una memoria cach\\\\u00e9 L3 de 6MB, usa el socket LGA 1200 y tiene un TDP de 65 W\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764561688_692d13184ba62.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/CzDOnRBbdns\\\"]\"','2025-12-01 01:46:52','2025-12-01 04:01:28'),(16,123,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;9800X3D&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos&nbsp;con&nbsp;arquitectura&nbsp;de&nbsp;4&nbsp;nm,&nbsp;diseñado&nbsp;para&nbsp;gaming&nbsp;de&nbsp;alto&nbsp;rendimiento.&nbsp;Destaca&nbsp;por&nbsp;su&nbsp;tecnología&nbsp;3D&nbsp;V-Cache,&nbsp;que&nbsp;incluye&nbsp;hasta&nbsp;96MB&nbsp;de&nbsp;caché&nbsp;L3&nbsp;y&nbsp;una&nbsp;frecuencia&nbsp;que&nbsp;alcanza&nbsp;los&nbsp;5.2GHz,&nbsp;todo&nbsp;ello&nbsp;sobre&nbsp;el&nbsp;socket&nbsp;AM5&nbsp;y&nbsp;con&nbsp;soporte&nbsp;para&nbsp;PCIe&nbsp;5.0&nbsp;y&nbsp;memoria&nbsp;DDR5.&nbsp;Ofrece&nbsp;una&nbsp;excelente&nbsp;eficiencia&nbsp;energética&nbsp;(120W&nbsp;TDP)&nbsp;y&nbsp;es&nbsp;ideal&nbsp;para&nbsp;juegos&nbsp;y&nbsp;aplicaciones&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR RYZEN AMD RYZEN 7 9800X 3D AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"El AMD Ryzen 7 9800X3D AM5 ofrece un rendimiento superior gracias a su arquitectura Zen 5 y la tecnolog\\\\u00eda 3D V-Cache, que mejora notablemente la velocidad en juegos y tareas exigentes. Con frecuencias de hasta 5.2 GHz y compatibilidad con DDR5 y PCIe 5.0, es una opci\\\\u00f3n ideal para equipos de alto rendimiento que buscan potencia, eficiencia y larga vida \\\\u00fatil en la plataforma AM5.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764554449_692cf6d16636f.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/4uox2wouQjs\\\"]\"','2025-12-01 02:00:49','2025-12-01 20:22:27'),(17,124,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;5800XT&nbsp;AM4&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos&nbsp;para&nbsp;la&nbsp;plataforma&nbsp;AM4,&nbsp;con&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.8&nbsp;GHz&nbsp;y&nbsp;un&nbsp;modo&nbsp;turbo&nbsp;que&nbsp;alcanza&nbsp;hasta&nbsp;4.8&nbsp;GHz.&nbsp;Basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;3,&nbsp;ofrece&nbsp;un&nbsp;alto&nbsp;rendimiento&nbsp;en&nbsp;juegos,&nbsp;multitarea&nbsp;y&nbsp;aplicaciones&nbsp;exigentes,&nbsp;apoyado&nbsp;por&nbsp;sus&nbsp;36&nbsp;MB&nbsp;de&nbsp;caché&nbsp;combinada&nbsp;(L2+L3).</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5800XT AM4 AST\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"El Ryzen 7 5800XT ofrece un rendimiento s\\\\u00f3lido para la plataforma AM4 gracias a sus 8 n\\\\u00facleos Zen 3, altas frecuencias y amplia cach\\\\u00e9, lo que garantiza eficiencia en juegos y cargas de trabajo pesadas. Su compatibilidad con DDR4 y PCIe 4.0 maximiza el desempe\\\\u00f1o del sistema sin necesidad de migrar a plataformas m\\\\u00e1s nuevas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562032_692d1470bb029.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/24x_EE_zN2o\\\"]\"','2025-12-01 02:15:01','2025-12-01 04:07:12'),(18,125,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i5-14600KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;para&nbsp;socket&nbsp;LGA&nbsp;1700,&nbsp;equipado&nbsp;con&nbsp;14&nbsp;núcleos&nbsp;(6&nbsp;Performance-cores&nbsp;y&nbsp;8&nbsp;Efficient-cores)&nbsp;y&nbsp;20&nbsp;hilos,&nbsp;alcanzando&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.3&nbsp;GHz.&nbsp;Gracias&nbsp;a&nbsp;sus&nbsp;24&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache,&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;sólido&nbsp;en&nbsp;juegos,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;multitarea&nbsp;intensiva.&nbsp;Este&nbsp;modelo&nbsp;no&nbsp;incluye&nbsp;gráficos&nbsp;integrados,&nbsp;por&nbsp;lo&nbsp;que&nbsp;requiere&nbsp;obligatoriamente&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\" PROCESADOR INTEL CORE I5 14600KF LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\" PROCESADOR INTEL CORE \\\",\\\"detalle\\\":\\\"El Intel Core i5-14600KF combina una arquitectura h\\\\u00edbrida de 14 n\\\\u00facleos con frecuencias turbo de hasta 5.3 GHz y 24 MB de Smart Cache, logrando un rendimiento altamente eficiente en juegos y aplicaciones exigentes. Su soporte para el socket LGA 1700, junto con tecnolog\\\\u00eda DDR4\\\\\\/DDR5 y PCIe 5.0, lo convierte en una opci\\\\u00f3n vers\\\\u00e1til y actualizada para equipos de alto rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764561379_692d11e389195.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/5St4FD1utRw\\\"]\"','2025-12-01 02:22:22','2025-12-01 03:56:19'),(19,126,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i7-14700KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;moderno&nbsp;para&nbsp;socket&nbsp;LGA&nbsp;1700,&nbsp;con&nbsp;arquitectura&nbsp;híbrida&nbsp;—&nbsp;combina&nbsp;núcleos&nbsp;de&nbsp;rendimiento&nbsp;y&nbsp;eficiencia&nbsp;para&nbsp;maximizar&nbsp;potencia&nbsp;y&nbsp;eficiencia.&nbsp;Cuenta&nbsp;con&nbsp;33&nbsp;MB&nbsp;de&nbsp;caché&nbsp;(Intel&nbsp;Smart&nbsp;Cache)&nbsp;y&nbsp;puede&nbsp;alcanzar&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.6&nbsp;GHz,&nbsp;brindando&nbsp;un&nbsp;alto&nbsp;nivel&nbsp;de&nbsp;desempeño.&nbsp;Está&nbsp;pensado&nbsp;para&nbsp;tareas&nbsp;exigentes&nbsp;como&nbsp;juegos&nbsp;,&nbsp;edición&nbsp;de&nbsp;video,&nbsp;creación&nbsp;de&nbsp;contenido,&nbsp;renderizado&nbsp;3D&nbsp;y&nbsp;multitarea&nbsp;intensiva.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i7-14700KF CACHE 33 MB HASTA 5.6 GHZ\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"El Intel Core i7-14700KF es un procesador potente ideal para juegos de alto rendimiento, edici\\\\u00f3n de video, renderizado, multitarea pesada y trabajo profesional. Gracias a sus 20 n\\\\u00facleos, hasta 5.6 GHz y 33 MB de cach\\\\u00e9, ofrece gran velocidad y eficiencia en tareas exigentes, siendo perfecto para equipos modernos con tarjeta gr\\\\u00e1fica dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764560835_692d0fc355e1d.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/VW_pTdglQGU\\\"]\"','2025-12-01 02:31:01','2025-12-01 03:47:15'),(20,127,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;5700G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;muy&nbsp;completo&nbsp;que&nbsp;combina&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;gráficos&nbsp;integrados&nbsp;potentes,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;convierte&nbsp;en&nbsp;una&nbsp;excelente&nbsp;opción&nbsp;para&nbsp;equipos&nbsp;que&nbsp;buscan&nbsp;buen&nbsp;desempeño&nbsp;sin&nbsp;necesidad&nbsp;inmediata&nbsp;de&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.&nbsp;Gracias&nbsp;a&nbsp;sus&nbsp;8&nbsp;núcleos,&nbsp;16&nbsp;hilos&nbsp;y&nbsp;arquitectura&nbsp;Zen&nbsp;3,&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;sólido&nbsp;en&nbsp;tareas&nbsp;de&nbsp;productividad,&nbsp;edición&nbsp;ligera,&nbsp;programación&nbsp;y&nbsp;multitarea.&nbsp;Su&nbsp;GPU&nbsp;integrada&nbsp;Vega&nbsp;8&nbsp;permite&nbsp;ejecutar&nbsp;juegos&nbsp;en&nbsp;calidad&nbsp;media&nbsp;y&nbsp;realizar&nbsp;trabajos&nbsp;gráficos&nbsp;básicos&nbsp;sin&nbsp;hardware&nbsp;adicional.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5700G 3.8GHZ\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 7 5700G, tu PC obtiene la potencia ideal para ejecutar tus aplicaciones, programas y juegos con una fluidez destacada. Gracias a su frecuencia base de 3.8 GHz, su potencia turbo de hasta 4.6 GHz y su arquitectura Zen 3, este procesador ofrece un rendimiento s\\\\u00f3lido para quienes buscan eficiencia y velocidad sin compromisos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562185_692d15097d8ba.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/oxOdhelEiiU\\\"]\"','2025-12-01 02:39:44','2025-12-01 04:09:45'),(21,128,'<p>El&nbsp;<strong>Intel&nbsp;Pentium&nbsp;Gold&nbsp;G5420</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;básico&nbsp;y&nbsp;eficiente&nbsp;para&nbsp;tareas&nbsp;cotidianas,&nbsp;con&nbsp;<strong>2&nbsp;núcleos&nbsp;y&nbsp;4&nbsp;hilos</strong>,&nbsp;frecuencia&nbsp;de&nbsp;<strong>3.8&nbsp;GHz</strong>,&nbsp;gráficos&nbsp;integrados&nbsp;UHD&nbsp;610&nbsp;y&nbsp;bajo&nbsp;consumo&nbsp;de&nbsp;<strong>54&nbsp;W</strong>.&nbsp;Es&nbsp;ideal&nbsp;para&nbsp;oficinas,&nbsp;estudios,&nbsp;educación&nbsp;y&nbsp;equipos&nbsp;económicos.&nbsp;La&nbsp;versión&nbsp;<strong>OEM</strong>&nbsp;viene&nbsp;sin&nbsp;caja&nbsp;y&nbsp;usualmente&nbsp;sin&nbsp;disipador,&nbsp;siendo&nbsp;una&nbsp;opción&nbsp;accesible&nbsp;para&nbsp;reemplazos&nbsp;o&nbsp;PC&nbsp;sencillas.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL PENTIUM G5420 OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el Intel Pentium Gold G5420, tu PC obtiene el rendimiento ideal para ejecutar tus tareas diarias con rapidez y estabilidad. Gracias a su frecuencia de 3.8 GHz y sus 2 n\\\\u00facleos con 4 hilos, este procesador ofrece una experiencia fluida en actividades como navegaci\\\\u00f3n web, ofim\\\\u00e1tica, clases virtuales, multimedia y programas ligeros.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764559810_692d0bc291778.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/rKz6Q_ynPXE\\\"]\"','2025-12-01 02:47:27','2025-12-01 03:30:10'),(22,129,'<p>El&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;9&nbsp;285K&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;última&nbsp;generación&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;extremo&nbsp;en&nbsp;tareas&nbsp;profesionales,&nbsp;juegos&nbsp;avanzados&nbsp;y&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;intensivas.&nbsp;Equipado&nbsp;con&nbsp;24&nbsp;núcleos&nbsp;híbridos&nbsp;(Performance&nbsp;y&nbsp;Efficient)&nbsp;y&nbsp;36&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;este&nbsp;procesador&nbsp;alcanza&nbsp;una&nbsp;velocidad&nbsp;base&nbsp;de&nbsp;3.70&nbsp;GHz&nbsp;y&nbsp;un&nbsp;turbo&nbsp;máximo&nbsp;de&nbsp;5.70&nbsp;GHz,&nbsp;brindando&nbsp;una&nbsp;capacidad&nbsp;sobresaliente&nbsp;en&nbsp;multitarea,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;aplicaciones&nbsp;de&nbsp;alto&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE ULTRA 9 285K 3.70GHZ HASTA 5.70GHZ 36MB 24 CORE LGA1851\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el Intel Core Ultra 9 285K, tu PC obtiene la m\\\\u00e1xima potencia para ejecutar aplicaciones avanzadas, juegos de alto rendimiento y trabajos profesionales con una fluidez excepcional. Gracias a su frecuencia base de 3.70 GHz, su turbo de hasta 5.70 GHz y sus 24 n\\\\u00facleos h\\\\u00edbridos, este procesador est\\\\u00e1 dise\\\\u00f1ado para usuarios que necesitan un nivel extremo de rapidez, estabilidad y respuesta inmediata.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764560432_692d0e30417b3.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/B8nTndxxxaU\\\"]\"','2025-12-01 02:53:06','2025-12-01 03:40:32'),(23,130,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;9600X&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;última&nbsp;generación&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;sobresaliente&nbsp;en&nbsp;juegos,&nbsp;multitarea&nbsp;y&nbsp;aplicaciones&nbsp;modernas.&nbsp;Con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;junto&nbsp;a&nbsp;su&nbsp;arquitectura&nbsp;avanzada,&nbsp;alcanza&nbsp;frecuencias&nbsp;de&nbsp;hasta&nbsp;5.4&nbsp;GHz,&nbsp;garantizando&nbsp;una&nbsp;respuesta&nbsp;rápida&nbsp;y&nbsp;estable&nbsp;incluso&nbsp;en&nbsp;tareas&nbsp;exigentes.</p><p></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 9600X, CACHE 32 MB\\\\\\/ HASTA 5.4GHZ\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 5 9600X, tu PC obtiene la velocidad y eficiencia necesarias para ejecutar tus juegos y aplicaciones con un rendimiento superior. Gracias a sus 6 n\\\\u00facleos y 12 hilos, junto a su frecuencia turbo de hasta 5.4 GHz, este procesador ofrece una experiencia \\\\u00e1gil y fluida para quienes buscan potencia sin compromisos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562387_692d15d30fe31.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/Is9JgBzL-mA\\\"]\"','2025-12-01 03:00:33','2025-12-01 20:19:42'),(24,131,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i5-14600K&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;destacado&nbsp;en&nbsp;juegos,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;multitarea&nbsp;avanzada.&nbsp;Cuenta&nbsp;con&nbsp;14&nbsp;núcleos&nbsp;híbridos&nbsp;(6&nbsp;Performance-cores&nbsp;y&nbsp;8&nbsp;Efficient-cores)&nbsp;y&nbsp;20&nbsp;hilos,&nbsp;brindando&nbsp;una&nbsp;excelente&nbsp;combinación&nbsp;de&nbsp;potencia&nbsp;y&nbsp;eficiencia&nbsp;para&nbsp;cualquier&nbsp;tipo&nbsp;de&nbsp;tarea.</p><p>Alcanza&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.3&nbsp;GHz,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;tiempos&nbsp;de&nbsp;respuesta&nbsp;rápidos&nbsp;y&nbsp;un&nbsp;desempeño&nbsp;fluido&nbsp;en&nbsp;aplicaciones&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i5-14600K LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"el Intel Core i5-14600K incorpora 24 MB de cach\\\\u00e9 y la arquitectura m\\\\u00e1s moderna de Intel para el socket LGA1700, permitiendo aprovechar tecnolog\\\\u00edas actuales como DDR4\\\\\\/DDR5 y PCIe 5.0. Adem\\\\u00e1s, al ser un modelo desbloqueado, brinda la posibilidad de realizar overclocking para quienes buscan sacar el m\\\\u00e1ximo provecho de su equipo\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562537_692d166913972.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/dBBGPYjonEk\\\"]\"','2025-12-01 03:06:46','2025-12-01 04:15:37'),(25,132,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i3-9100F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;4&nbsp;núcleos&nbsp;y&nbsp;4&nbsp;hilos,&nbsp;perteneciente&nbsp;a&nbsp;la&nbsp;9ª&nbsp;generación&nbsp;Coffee&nbsp;Lake.&nbsp;Trabaja&nbsp;a&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;puede&nbsp;llegar&nbsp;hasta&nbsp;4.2&nbsp;GHz&nbsp;con&nbsp;Turbo&nbsp;Boost.&nbsp;Incluye&nbsp;6&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;tiene&nbsp;un&nbsp;consumo&nbsp;de&nbsp;65&nbsp;W&nbsp;(TDP)&nbsp;y&nbsp;utiliza&nbsp;el&nbsp;socket&nbsp;LGA&nbsp;1151,&nbsp;compatible&nbsp;con&nbsp;placas&nbsp;madre&nbsp;serie&nbsp;300.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I3-9100F 2.50GZ OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"El Intel Core i3-9100F aporta a la PC un rendimiento fiable para las tareas diarias y programas de exigencia moderada. Gracias a sus 4 n\\\\u00facleos y 4 hilos, el sistema puede ejecutar aplicaciones como navegadores, ofim\\\\u00e1tica, clases virtuales, multitarea b\\\\u00e1sica y algunos juegos ligeros sin presentar ca\\\\u00eddas de rendimiento. Su frecuencia de 3.6 GHz (hasta 4.2 GHz en Turbo Boost) permite que la PC responda con rapidez al abrir programas, cargar archivos y ejecutar procesos que requieren mayor velocidad moment\\\\u00e1nea.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764562653_692d16dd6fc4f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/uSfURH7w7Yw\\\"]\"','2025-12-01 03:12:46','2025-12-01 04:17:33'),(26,133,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;9&nbsp;9950X&nbsp;ofrece&nbsp;una&nbsp;potencia&nbsp;extrema&nbsp;para&nbsp;llevar&nbsp;tu&nbsp;PC&nbsp;al&nbsp;máximo&nbsp;rendimiento&nbsp;en&nbsp;cualquier&nbsp;tarea.&nbsp;Con&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;4.3&nbsp;GHz,&nbsp;arquitectura&nbsp;Zen&nbsp;5&nbsp;y&nbsp;64&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;este&nbsp;procesador&nbsp;está&nbsp;diseñado&nbsp;para&nbsp;manejar&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;avanzadas&nbsp;con&nbsp;una&nbsp;velocidad&nbsp;y&nbsp;eficiencia&nbsp;sobresalientes.&nbsp;Su&nbsp;plataforma&nbsp;AM5&nbsp;permite&nbsp;aprovechar&nbsp;tecnologías&nbsp;modernas&nbsp;como&nbsp;DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0,&nbsp;garantizando&nbsp;un&nbsp;sistema&nbsp;rápido,&nbsp;ágil&nbsp;y&nbsp;preparado&nbsp;para&nbsp;el&nbsp;futuro</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD Ryzen 9 9950X 4.3GHZl 64MB AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 9 9950X, La PC obtiene una potencia de nivel profesional capaz de ejecutar cualquier tarea con m\\\\u00e1xima fluidez y rapidez. Gracias a su frecuencia de 4.3 GHz y su enorme cach\\\\u00e9 de 64 MB, el sistema responde de inmediato al abrir programas pesados, procesar archivos grandes y realizar m\\\\u00faltiples tareas a la vez sin perder rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764596370_692d9a9258550.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/6FKkJX9nD_s?si=4kej1KSCFiQVVlxF\\\"]\"','2025-12-01 13:39:30','2025-12-01 13:39:30'),(27,134,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;5500X3D&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;sobresaliente&nbsp;gracias&nbsp;a&nbsp;su&nbsp;tecnología&nbsp;3D&nbsp;V-Cache,&nbsp;que&nbsp;incorpora&nbsp;96&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;permitiendo&nbsp;una&nbsp;mayor&nbsp;rapidez&nbsp;en&nbsp;juegos&nbsp;y&nbsp;tareas&nbsp;que&nbsp;dependen&nbsp;fuertemente&nbsp;del&nbsp;acceso&nbsp;a&nbsp;datos.&nbsp;Con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;este&nbsp;procesador&nbsp;alcanza&nbsp;una&nbsp;frecuencia&nbsp;de&nbsp;3.0&nbsp;GHz,&nbsp;llegando&nbsp;hasta&nbsp;4.0&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;proporcionando&nbsp;una&nbsp;respuesta&nbsp;fluida&nbsp;tanto&nbsp;en&nbsp;aplicaciones&nbsp;de&nbsp;uso&nbsp;diario&nbsp;como&nbsp;en&nbsp;cargas&nbsp;más&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 5500X3D 3.00GHZ HASTA 4.00GHZ 96MB 6 CORE AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD Ryzen 5 5500X3D, la PC obtiene un rendimiento excelente para juegos y tareas del d\\\\u00eda a d\\\\u00eda gracias a su avanzada tecnolog\\\\u00eda 3D V-Cache, que incorpora 96 MB de cach\\\\u00e9 y acelera los procesos que requieren acceso r\\\\u00e1pido a datos. Su configuraci\\\\u00f3n de 6 n\\\\u00facleos y 12 hilos, junto con frecuencias que van desde 3.0 GHz hasta 4.0 GHz, permite que mi equipo funcione con gran fluidez al ejecutar aplicaciones, programas pesados o multitarea continua.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764597476_692d9ee41d858.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/NdpfV5IkUi0\\\"]\"','2025-12-01 13:57:56','2025-12-01 13:57:56'),(28,135,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i9-14900K&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;la&nbsp;máxima&nbsp;potencia&nbsp;en&nbsp;juegos,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;multitarea&nbsp;intensiva.&nbsp;Con&nbsp;su&nbsp;arquitectura&nbsp;híbrida&nbsp;de&nbsp;14ª&nbsp;generación,&nbsp;integra&nbsp;24&nbsp;núcleos&nbsp;(8&nbsp;de&nbsp;rendimiento&nbsp;y&nbsp;16&nbsp;de&nbsp;eficiencia)&nbsp;junto&nbsp;a&nbsp;32&nbsp;hilos,&nbsp;permitiendo&nbsp;ejecutar&nbsp;aplicaciones&nbsp;exigentes&nbsp;y&nbsp;flujos&nbsp;de&nbsp;trabajo&nbsp;pesados&nbsp;sin&nbsp;perder&nbsp;velocidad.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I9 14900K LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL CORE\\\",\\\"detalle\\\":\\\"Con el Intel Core i9-14900K, la PC obtiene un rendimiento extremo capaz de manejar cualquier tarea con total fluidez, desde juegos de alta exigencia hasta trabajos profesionales muy pesados. Gracias a su arquitectura h\\\\u00edbrida de 14\\\\u00aa generaci\\\\u00f3n, que combina 24 n\\\\u00facleos y 32 hilos,\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764598184_692da1a8dca39.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/rfqheytMk3U\\\"]\"','2025-12-01 14:09:44','2025-12-01 14:09:44'),(29,136,'<p>El&nbsp;<strong>Intel&nbsp;Core&nbsp;i5-14400</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;con&nbsp;<strong>10&nbsp;núcleos&nbsp;(6&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;+&nbsp;4&nbsp;eficientes)</strong>&nbsp;y&nbsp;<strong>16&nbsp;hilos</strong>,&nbsp;con&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;<strong>4.7&nbsp;GHz</strong>&nbsp;y&nbsp;<strong>20&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache</strong>.&nbsp;Incluye&nbsp;gráficos&nbsp;integrados&nbsp;<strong>Intel&nbsp;UHD&nbsp;Graphics&nbsp;730</strong>,&nbsp;es&nbsp;compatible&nbsp;con&nbsp;memoria&nbsp;<strong>DDR4&nbsp;o&nbsp;DDR5</strong>&nbsp;y&nbsp;usa&nbsp;socket&nbsp;<strong>LGA1700</strong>.&nbsp;Tiene&nbsp;un&nbsp;<strong>TDP&nbsp;base&nbsp;de&nbsp;65&nbsp;W</strong>,&nbsp;ideal&nbsp;para&nbsp;equipos&nbsp;equilibrados&nbsp;que&nbsp;busquen&nbsp;rendimiento&nbsp;eficiente&nbsp;sin&nbsp;excesivo&nbsp;consumo</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i5-14400 OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el Intel Core i5-14400, la PC obtiene un equilibrio perfecto entre potencia, eficiencia y compatibilidad. Sus 10 n\\\\u00facleos y 16 hilos permiten manejar multitarea, edici\\\\u00f3n, streaming, navegaci\\\\u00f3n y juegos sin problemas. La frecuencia de hasta 4.7 GHz asegura rapidez al abrir programas y ejecutar aplicaciones exigentes. Adem\\\\u00e1s, al incluir gr\\\\u00e1ficos integrados UHD 730, mi equipo puede funcionar sin tarjeta gr\\\\u00e1fica dedicada \\\\u2014 ideal para tareas comunes o uso multimedia.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764598655_692da37fd5e6c.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/tG-P5C5SS7U\\\"]\"','2025-12-01 14:17:35','2025-12-01 14:17:35'),(30,137,'<p>El&nbsp;<strong>AMD&nbsp;Ryzen&nbsp;9&nbsp;9900X&nbsp;(AM5)</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;con&nbsp;<strong>12&nbsp;núcleos</strong>,&nbsp;diseñado&nbsp;para&nbsp;rendir&nbsp;al&nbsp;máximo&nbsp;en&nbsp;tareas&nbsp;exigentes.&nbsp;Tiene&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;<strong>4.40&nbsp;GHz</strong>&nbsp;y&nbsp;puede&nbsp;alcanzar&nbsp;hasta&nbsp;<strong>5.60&nbsp;GHz</strong>&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;rendimiento&nbsp;intenso&nbsp;y&nbsp;fluido.&nbsp;Con&nbsp;<strong>64&nbsp;MB&nbsp;de&nbsp;caché</strong>,&nbsp;ofrece&nbsp;acceso&nbsp;rápido&nbsp;a&nbsp;datos,&nbsp;optimizando&nbsp;la&nbsp;velocidad&nbsp;en&nbsp;juegos,&nbsp;edición,&nbsp;renderizado&nbsp;y&nbsp;multitarea.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 9 9900X 4.40GHZ HASTA 5.60GHZ 64MB 12 CORE AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el RYZEN 9 9900X la PC obtiene un salto considerable de potencia y velocidad: sus 12 n\\\\u00facleos y 24 hilos permiten manejar sin esfuerzo juegos modernos, edici\\\\u00f3n de video, renderizado 3D, multitarea pesada, streaming y software profesional. Su boost hasta 5.6 GHz asegura una respuesta inmediata al ejecutar tareas exigentes, mientras que los 64 MB de cach\\\\u00e9 optimizan el acceso a datos y reducen tiempos de carga.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764599225_692da5b9c98a9.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/Dslwua6cck4\\\"]\"','2025-12-01 14:27:05','2025-12-01 14:27:05'),(31,138,'<p>El&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;5&nbsp;225F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;moderno&nbsp;orientado&nbsp;al&nbsp;rendimiento&nbsp;balanceado,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;buena&nbsp;velocidad&nbsp;en&nbsp;tareas&nbsp;diarias,&nbsp;juegos&nbsp;y&nbsp;productividad.&nbsp;Con&nbsp;frecuencias&nbsp;que&nbsp;alcanzan&nbsp;hasta&nbsp;4.9&nbsp;GHz&nbsp;y&nbsp;20&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;proporciona&nbsp;una&nbsp;experiencia&nbsp;fluida&nbsp;y&nbsp;eficiente,&nbsp;manteniendo&nbsp;un&nbsp;consumo&nbsp;moderado&nbsp;y&nbsp;aprovechando&nbsp;la&nbsp;arquitectura&nbsp;Intel&nbsp;de&nbsp;última&nbsp;generación.&nbsp;Es&nbsp;ideal&nbsp;para&nbsp;usuarios&nbsp;que&nbsp;necesitan&nbsp;potencia&nbsp;sin&nbsp;llegar&nbsp;al&nbsp;nivel&nbsp;extremo&nbsp;de&nbsp;los&nbsp;procesadores&nbsp;tope&nbsp;de&nbsp;gama.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE ULTRA 5 225F 3.30 4.9GHZ 20MB\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"En tu PC, el Intel Core Ultra 5 225F te garantiza un funcionamiento r\\\\u00e1pido y estable para todas tus actividades: juegos, multitarea, programas de trabajo y navegaci\\\\u00f3n. Su frecuencia de hasta 4.9 GHz permite que el sistema responda con fluidez, mientras que su cach\\\\u00e9 de 20 MB acelera la carga de aplicaciones y procesos. Es un procesador ideal para equipos modernos que buscan rendimiento s\\\\u00f3lido sin elevar demasiado el consumo o la temperatura.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764599765_692da7d528e0e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/G0EgLs7AkxE?si=kB19AlQgvOv8tfnB\\\"]\"','2025-12-01 14:36:05','2025-12-01 14:36:05'),(32,139,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;9&nbsp;9950X3D&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;socket&nbsp;AM5,&nbsp;con&nbsp;arquitectura&nbsp;Zen&nbsp;5&nbsp;y&nbsp;tecnología&nbsp;3D&nbsp;V-Cache.&nbsp;Con&nbsp;16&nbsp;núcleos&nbsp;y&nbsp;32&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;alrededor&nbsp;de&nbsp;4.3&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;≈&nbsp;5.7&nbsp;GHz,&nbsp;ofrece&nbsp;un&nbsp;alto&nbsp;desempeño&nbsp;tanto&nbsp;en&nbsp;tareas&nbsp;de&nbsp;productividad&nbsp;como&nbsp;en&nbsp;juegos&nbsp;exigentes.&nbsp;Su&nbsp;ventaja&nbsp;destacada&nbsp;es&nbsp;la&nbsp;gran&nbsp;cantidad&nbsp;de&nbsp;caché&nbsp;—&nbsp;gracias&nbsp;al&nbsp;3D&nbsp;V-Cache&nbsp;—&nbsp;lo&nbsp;que&nbsp;mejora&nbsp;notablemente&nbsp;el&nbsp;rendimiento&nbsp;en&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;intensivas,&nbsp;reduciendo&nbsp;latencias&nbsp;y&nbsp;acelerando&nbsp;el&nbsp;acceso&nbsp;a&nbsp;datos.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 9 9950X3D 4.30GHZ HASTA\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 9 9950X3D en la PC obtengo un rendimiento de primer nivel: el equipo puede gestionar sin esfuerzo tareas exigentes \\\\u2014 edici\\\\u00f3n de video, renderizado, programas pesados, multitarea \\\\u2014, y al mismo tiempo ofrecer fluidez en juegos modernos. La combinaci\\\\u00f3n de alto conteo de n\\\\u00facleos + 3D V-Cache asegura respuestas r\\\\u00e1pidas, tiempos de carga cortos y estabilidad bajo carga. Adem\\\\u00e1s, al ser un procesador AM5, preparo mi PC para el hardware moderno, con compatibilidad de memorias r\\\\u00e1pidas DDR5 y componentes actuales.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764600153_692da95949aba.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/xWXAPMAmFhA\\\"]\"','2025-12-01 14:42:33','2025-12-01 14:42:33'),(33,140,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i9-12900KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;escritorio&nbsp;con&nbsp;arquitectura&nbsp;híbrida&nbsp;(serie&nbsp;12ª&nbsp;generación,&nbsp;“Alder&nbsp;Lake”),&nbsp;que&nbsp;combina&nbsp;16&nbsp;núcleos&nbsp;(8&nbsp;núcleos&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;+&nbsp;8&nbsp;núcleos&nbsp;eficientes)&nbsp;y&nbsp;24&nbsp;hilos.&nbsp;Puede&nbsp;alcanzar&nbsp;velocidades&nbsp;de&nbsp;hasta&nbsp;5.20&nbsp;GHz,&nbsp;y&nbsp;cuenta&nbsp;con&nbsp;30&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache,&nbsp;lo&nbsp;que&nbsp;le&nbsp;proporciona&nbsp;potencia&nbsp;suficiente&nbsp;para&nbsp;juegos,&nbsp;edición&nbsp;de&nbsp;video,&nbsp;renderizado,&nbsp;multitarea&nbsp;exigente&nbsp;y&nbsp;trabajo&nbsp;profesional.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I9-12900KF LGA 1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el Intel Core i9-12900KF en tu PC, obtendr\\\\u00e1s un rendimiento sobresaliente en pr\\\\u00e1cticamente cualquier tarea: desde jugar videojuegos modernos a m\\\\u00e1ximo detalle, hasta editar video 4K, renderizar 3D, trabajar con m\\\\u00faltiples aplicaciones a la vez, e incluso streaming o dise\\\\u00f1o profesional. Sus 16 n\\\\u00facleos y 24 hilos aseguran potencia m\\\\u00e1s que suficiente para multitarea intensa, mientras que las altas frecuencias y gran cach\\\\u00e9 agilizan los procesos y reducen tiempos de carga.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764600791_692dabd741ca4.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/7K0aR8JoMH0\\\"]\"','2025-12-01 14:53:11','2025-12-01 14:53:11'),(34,141,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;4500&nbsp;es&nbsp;un&nbsp;procesador&nbsp;económico&nbsp;y&nbsp;eficiente&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;“boost”&nbsp;de&nbsp;hasta&nbsp;aproximadamente&nbsp;4.1&nbsp;GHz,&nbsp;Está&nbsp;pensado&nbsp;para&nbsp;ofrecer&nbsp;una&nbsp;relación&nbsp;calidad-precio&nbsp;atractiva&nbsp;—&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;de&nbsp;bajo&nbsp;o&nbsp;medio&nbsp;presupuesto&nbsp;—&nbsp;prestando&nbsp;buen&nbsp;desempeño&nbsp;en&nbsp;tareas&nbsp;comunes,&nbsp;navegación,&nbsp;ofimática,&nbsp;edición&nbsp;ligera&nbsp;y&nbsp;juegos&nbsp;cuando&nbsp;se&nbsp;usa&nbsp;con&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 4500 3.60GHz AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 5 4500 en la PC obtengo un rendimiento eficiente y equilibrado, adecuado para uso diario, juegos moderados, trabajo, estudio o multimedia. Sus 6 n\\\\u00facleos y 12 hilos garantizan fluidez en multitarea, al mismo tiempo que su frecuencia permite abrir programas y responder r\\\\u00e1pido ante demandas normales.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764601254_692dada6bd077.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/boWjWZMnD6U?si=RkdiWzx2knHuhgKZ\\\"]\"','2025-12-01 15:00:54','2025-12-01 15:00:54'),(35,142,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;5500&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;media&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;4.2&nbsp;GHz,&nbsp;Está&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;3&nbsp;(7&nbsp;nm),&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;eficiencia&nbsp;energética&nbsp;y&nbsp;buen&nbsp;rendimiento&nbsp;por&nbsp;núcleo.&nbsp;Su&nbsp;caché&nbsp;L3&nbsp;es&nbsp;de&nbsp;16&nbsp;MB,&nbsp;y&nbsp;tiene&nbsp;un&nbsp;diseño&nbsp;de&nbsp;TDP&nbsp;de&nbsp;65&nbsp;W,&nbsp;ideal&nbsp;para&nbsp;sistemas&nbsp;balanceados&nbsp;en&nbsp;consumo&nbsp;y&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 5500 OEM AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el AMD RYZEN 5 5500 en la PC obtengo un rendimiento equilibrado y eficiente: los 6 n\\\\u00facleos y 12 hilos permiten manejar multitarea, navegaci\\\\u00f3n, trabajo, multimedia y juegos con fluidez, siempre que tenga una tarjeta gr\\\\u00e1fica dedicada. Su frecuencia hasta 4.2 GHz garantiza respuestas r\\\\u00e1pidas al abrir programas o al ejecutar tareas exigentes moderadas, mientras que el TDP de 65 W asegura consumo moderado y temperaturas controladas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764601627_692daf1b5633f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/TkNuCWagETM?si=wvZPTV1rYL0mq5JD\\\"]\"','2025-12-01 15:07:07','2025-12-01 15:07:07'),(36,143,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;5600GT&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;basado&nbsp;en&nbsp;arquitectura&nbsp;Zen&nbsp;3&nbsp;(Cezanne).&nbsp;Tiene&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;con&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;4.6&nbsp;GHz.&nbsp;Cuenta&nbsp;con&nbsp;16&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;DDR4-3200,&nbsp;y&nbsp;un&nbsp;TDP&nbsp;de&nbsp;65&nbsp;W,&nbsp;Además,&nbsp;incluye&nbsp;gráficos&nbsp;integrados&nbsp;Radeon&nbsp;Graphics&nbsp;(Vega&nbsp;7),&nbsp;lo&nbsp;que&nbsp;permite&nbsp;usar&nbsp;el&nbsp;PC&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR, AMD, RYZEN 5 5600GT 6N\\\\\\/12H 3.9Ghz\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Si utilizas el Ryzen 5 5600GT en tu PC, obtienes un equipo equilibrado y funcional para un uso vers\\\\u00e1til: desde navegar, trabajar, estudiar, hacer edici\\\\u00f3n ligera o multimedia \\\\u2014 hasta jugar t\\\\u00edtulos exigentes en calidad moderada sin necesidad de una tarjeta gr\\\\u00e1fica externa.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764601981_692db07da0f0f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/qXAAxIaSLDc\\\"]\"','2025-12-01 15:13:01','2025-12-01 15:13:01'),(37,144,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i3-4130&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;básica/media&nbsp;de&nbsp;escritorio,&nbsp;con&nbsp;arquitectura&nbsp;Haswell,&nbsp;fabricado&nbsp;en&nbsp;22&nbsp;nm,&nbsp;para&nbsp;socket&nbsp;LGA&nbsp;1150.&nbsp;Tiene&nbsp;2&nbsp;núcleos&nbsp;físicos&nbsp;y&nbsp;4&nbsp;hilos&nbsp;(Hyper-Threading),&nbsp;opera&nbsp;a&nbsp;una&nbsp;frecuencia&nbsp;de&nbsp;3.4&nbsp;GHz,&nbsp;sin&nbsp;turbo&nbsp;boost.&nbsp;Cuenta&nbsp;con&nbsp;3&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;incorpora&nbsp;gráficos&nbsp;integrados&nbsp;Intel&nbsp;HD&nbsp;Graphics&nbsp;4400,&nbsp;y&nbsp;tiene&nbsp;un&nbsp;consumo&nbsp;(TDP)&nbsp;de&nbsp;54&nbsp;W.&nbsp;Este&nbsp;procesador&nbsp;está&nbsp;concebido&nbsp;para&nbsp;tareas&nbsp;cotidianas:&nbsp;ofimática,&nbsp;navegación,&nbsp;multimedia,&nbsp;edición&nbsp;ligera,&nbsp;y&nbsp;uso&nbsp;general.&nbsp;Gracias&nbsp;a&nbsp;sus&nbsp;gráficos&nbsp;integrados&nbsp;puede&nbsp;funcionar&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;económicas&nbsp;o&nbsp;de&nbsp;oficina.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL I3 4130 CON DISIPADOR OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si uso un i3-4130 en mi PC, obtengo un equipo suficiente para trabajar con programas b\\\\u00e1sicos, navegar, ver videos, hacer tareas de oficina, estudiar, y usar software ligero. Su 2 n\\\\u00facleos \\\\\\/ 4 hilos son adecuados para tareas sencillas o moderadas, y sus gr\\\\u00e1ficos integrados HD 4400 permiten reproducir video en alta definici\\\\u00f3n sin tarjeta de video. Con un consumo moderado (54 W) y disipador incluido, mantiene el equipo simple, econ\\\\u00f3mico y eficiente.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764602499_692db28384eb1.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/N-KRN6aZRnI\\\"]\"','2025-12-01 15:21:39','2025-12-01 15:21:39'),(38,145,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i3-3240&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;gama&nbsp;básica/media,&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Ivy&nbsp;Bridge,&nbsp;fabricado&nbsp;en&nbsp;22&nbsp;nm.&nbsp;Tiene&nbsp;2&nbsp;núcleos&nbsp;físicos&nbsp;y&nbsp;4&nbsp;hilos&nbsp;(Hyper-Threading),&nbsp;con&nbsp;frecuencia&nbsp;de&nbsp;3.4&nbsp;GHz.&nbsp;Cuenta&nbsp;con&nbsp;3&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3,&nbsp;lo&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;la&nbsp;agilidad&nbsp;del&nbsp;sistema&nbsp;en&nbsp;tareas&nbsp;simples&nbsp;y&nbsp;cotidianas.&nbsp;Además,&nbsp;incluye&nbsp;gráficos&nbsp;integrados&nbsp;Intel&nbsp;HD&nbsp;Graphics&nbsp;2500,&nbsp;suficientes&nbsp;para&nbsp;uso&nbsp;de&nbsp;oficina,&nbsp;navegación,&nbsp;reproducción&nbsp;de&nbsp;video&nbsp;y&nbsp;tareas&nbsp;multimedia&nbsp;básicas&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;Su&nbsp;consumo&nbsp;es&nbsp;moderado&nbsp;(TDP&nbsp;~&nbsp;55&nbsp;W),&nbsp;y&nbsp;es&nbsp;compatible&nbsp;con&nbsp;memorias&nbsp;DDR3,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;adecuado&nbsp;para&nbsp;equipos&nbsp;compactos&nbsp;o&nbsp;económicos.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL I3 3240 CON DISIPADOR OEM\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"Si uso el Intel Core i3-3240 en la PC, obtengo un sistema funcional y eficiente para tareas habituales: trabajar con documentos, navegar en internet, ver videos, usar programas ligeros, y ejecutar software de oficina o educativo sin inconvenientes.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764603127_692db4f76a79a.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/fSaIL8lNtNY\\\"]\"','2025-12-01 15:32:07','2025-12-01 15:32:07'),(39,146,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;7700X&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;diseñado&nbsp;para&nbsp;gaming,&nbsp;edición,&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;y&nbsp;tareas&nbsp;exigentes.&nbsp;Usa&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;4&nbsp;y&nbsp;está&nbsp;fabricado&nbsp;a&nbsp;5&nbsp;nm,&nbsp;lo&nbsp;que&nbsp;le&nbsp;asegura&nbsp;eficiencia&nbsp;y&nbsp;potencia.&nbsp;Tiene&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;manejar&nbsp;múltiples&nbsp;tareas&nbsp;al&nbsp;mismo&nbsp;tiempo&nbsp;sin&nbsp;perder&nbsp;rendimiento.&nbsp;Su&nbsp;frecuencia&nbsp;base&nbsp;suele&nbsp;rondar&nbsp;los&nbsp;4.5&nbsp;GHz,&nbsp;y&nbsp;puede&nbsp;alcanzar&nbsp;hasta&nbsp;5.4&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;lo&nbsp;que&nbsp;asegura&nbsp;un&nbsp;rendimiento&nbsp;muy&nbsp;rápido&nbsp;en&nbsp;tareas&nbsp;intensivas,&nbsp;juegos&nbsp;y&nbsp;aplicaciones&nbsp;pesadas.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 7700X AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 7 7700X en la PC, obtengo un rendimiento potente y moderno \\\\u2014 ideal para jugar juegos exigentes, editar video, trabajar con 3D, dise\\\\u00f1o, multitarea intensiva o uso profesional. Gracias a sus 8 n\\\\u00facleos y 16 hilos, mi sistema puede ejecutar varias aplicaciones exigentes al mismo tiempo sin ralentizar.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764603633_692db6f16209e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9t-saE6F7Iw?si=0_KSTdAycTsyPuHV\\\"]\"','2025-12-01 15:40:33','2025-12-01 15:40:33'),(40,147,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i7-14700F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;escritorio&nbsp;con&nbsp;arquitectura&nbsp;híbrida&nbsp;de&nbsp;14ª&nbsp;generación,&nbsp;compatible&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1700.&nbsp;Cuenta&nbsp;con&nbsp;20&nbsp;núcleos&nbsp;totales&nbsp;(8&nbsp;de&nbsp;“Performance-cores”&nbsp;+&nbsp;12&nbsp;de&nbsp;“Efficient-cores”)&nbsp;y&nbsp;28&nbsp;hilos,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;exigentes.&nbsp;Su&nbsp;frecuencia&nbsp;turbo&nbsp;máxima&nbsp;llega&nbsp;a&nbsp;5.4&nbsp;GHz.&nbsp;Además,&nbsp;incorpora&nbsp;33&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache&nbsp;+&nbsp;memoria&nbsp;caché&nbsp;L2&nbsp;adicional,&nbsp;y&nbsp;es&nbsp;compatible&nbsp;con&nbsp;DDR4&nbsp;/&nbsp;DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0&nbsp;/&nbsp;4.0,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;trabajar&nbsp;con&nbsp;hardware&nbsp;moderno&nbsp;y&nbsp;de&nbsp;alta&nbsp;velocidad.&nbsp;Es&nbsp;un&nbsp;modelo&nbsp;“F”,&nbsp;así&nbsp;que&nbsp;no&nbsp;incluye&nbsp;gráficos&nbsp;integrados&nbsp;—&nbsp;por&nbsp;lo&nbsp;que&nbsp;necesita&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I7 14700F 2.1GHZ HASTA 5.4GHZ\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el i7-14700F en tu PC, obtendr\\\\u00e1s un nivel de potencia elevado: tu sistema podr\\\\u00e1 manejar juegos exigentes, edici\\\\u00f3n de video, renderizados, trabajos pesados, multitarea avanzada y streaming sin inconvenientes. Los 20 n\\\\u00facleos \\\\\\/ 28 hilos garantizan que m\\\\u00faltiples programas puedan correr simult\\\\u00e1neamente sin perder fluidez.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764604553_692dba898187c.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/LC0SFyvvMAw\\\"]\"','2025-12-01 15:55:53','2025-12-01 15:55:53'),(41,148,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;3&nbsp;3200G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;de&nbsp;entrada/media-económica&nbsp;con&nbsp;socket&nbsp;AM4,&nbsp;basado&nbsp;en&nbsp;arquitectura&nbsp;Zen+&nbsp;(12&nbsp;nm).&nbsp;Cuenta&nbsp;con&nbsp;4&nbsp;núcleos&nbsp;físicos&nbsp;y&nbsp;4&nbsp;hilos,&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;alcanza&nbsp;hasta&nbsp;4.0&nbsp;GHz&nbsp;con&nbsp;Turbo.&nbsp;Tiene&nbsp;integrada&nbsp;la&nbsp;gráfica&nbsp;Radeon&nbsp;Vega&nbsp;8,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;tener&nbsp;salida&nbsp;de&nbsp;video&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;cotidianas,&nbsp;multimedia,&nbsp;ofimática&nbsp;y&nbsp;juegos&nbsp;ligeros/moderados,&nbsp;La&nbsp;caché&nbsp;L3&nbsp;total&nbsp;es&nbsp;de&nbsp;4&nbsp;MB,&nbsp;y&nbsp;su&nbsp;TDP&nbsp;ronda&nbsp;los&nbsp;65&nbsp;W,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;bastante&nbsp;eficiente&nbsp;en&nbsp;consumo&nbsp;para&nbsp;su&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR RYZEN 3 3200G 3.60GHz\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Si uso el Ryzen 3 3200G en mi PC, obtengo un equipo equilibrado y vers\\\\u00e1til: puedo realizar tareas diarias (navegar, editar documentos, reproducir video, trabajar en ofim\\\\u00e1tica), ver contenido multimedia, y hasta disfrutar de juegos ligeros o moderados sin necesidad de una tarjeta de video dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764605002_692dbc4a4878e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9BBFNoBdofM?si=kqMV0oVwE0qZQlqZ\\\"]\"','2025-12-01 16:03:22','2025-12-01 16:03:22'),(42,149,'<p>El&nbsp;<strong>Intel&nbsp;Core&nbsp;i5-12600KF</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;híbrida&nbsp;de&nbsp;la&nbsp;12ª&nbsp;generación&nbsp;(Alder&nbsp;Lake),&nbsp;compatible&nbsp;con&nbsp;socket&nbsp;<strong>LGA1700</strong>.&nbsp;Cuenta&nbsp;con&nbsp;<strong>10&nbsp;núcleos</strong>&nbsp;(6&nbsp;núcleos&nbsp;de&nbsp;rendimiento&nbsp;+&nbsp;4&nbsp;núcleos&nbsp;eficientes)&nbsp;y&nbsp;<strong>16&nbsp;hilos</strong>,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;exigentes.&nbsp;Su&nbsp;frecuencia&nbsp;turbo&nbsp;máxima&nbsp;es&nbsp;de&nbsp;<strong>4.90&nbsp;GHz</strong>,&nbsp;acompañado&nbsp;de&nbsp;<strong>20&nbsp;MB&nbsp;de&nbsp;Intel&nbsp;Smart&nbsp;Cache</strong></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I5-12600KF\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el i5-12600KF en tu PC, obtendr\\\\u00e1s un sistema potente y balanceado capaz de manejar pr\\\\u00e1cticamente cualquier tarea con fluidez: desde juegos , edici\\\\u00f3n de video, programas de dise\\\\u00f1o o trabajo intensivo, hasta multitarea exigente sin slowdowns.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764605358_692dbdae5d50d.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/BMQmOvKLWPQ?si=PAev94p-Xo_n3RKX\\\"]\"','2025-12-01 16:09:18','2025-12-01 16:09:18'),(43,150,'<p>El&nbsp;<strong>Intel&nbsp;Core&nbsp;i7-14700K</strong>&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;14ª&nbsp;generación&nbsp;para&nbsp;el&nbsp;socket&nbsp;<strong>LGA1700</strong>,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;alto&nbsp;rendimiento&nbsp;en&nbsp;juegos&nbsp;y&nbsp;tareas&nbsp;profesionales.&nbsp;Incorpora&nbsp;<strong>20&nbsp;núcleos</strong>&nbsp;(8&nbsp;de&nbsp;rendimiento&nbsp;y&nbsp;12&nbsp;de&nbsp;eficiencia),&nbsp;<strong>28&nbsp;hilos</strong>&nbsp;y&nbsp;alcanza&nbsp;una&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;<strong>5.6&nbsp;GHz</strong>,&nbsp;garantizando&nbsp;excelente&nbsp;capacidad&nbsp;de&nbsp;respuesta&nbsp;en&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;intensivas.</p><p>Cuenta&nbsp;con&nbsp;<strong>33&nbsp;MB&nbsp;de&nbsp;caché</strong>,&nbsp;soporte&nbsp;para&nbsp;<strong>memorias&nbsp;DDR5&nbsp;y&nbsp;DDR4</strong>,&nbsp;y&nbsp;gráficos&nbsp;integrados&nbsp;<strong>Intel&nbsp;UHD&nbsp;Graphics&nbsp;770</strong>,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;funcionamiento&nbsp;básico&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;una&nbsp;GPU&nbsp;dedicada.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I7 14700K LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Si instalas el i7-14700K en tu PC, obtienes un equipo preparado para pr\\\\u00e1cticamente todo: juegos AAA a altos FPS, edici\\\\u00f3n de video, modelado 3D, multitarea intensa, streaming, compilaciones, y cualquier software exigente. Con sus 20 n\\\\u00facleos y la capacidad de alcanzar 5.6 GHz, tu sistema manejar\\\\u00e1 cargas intensivas sin pesta\\\\u00f1ear. La gran cach\\\\u00e9 ayuda a que los procesos fluyan r\\\\u00e1pido y los tiempos de carga se reduzcan.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764605781_692dbf55a6ead.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/AEWKYpz7NL8?si=3NR4kmqxnslbFJS2\\\"]\"','2025-12-01 16:16:21','2025-12-01 16:16:21'),(44,151,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;5&nbsp;7500F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos&nbsp;para&nbsp;el&nbsp;socket&nbsp;AM5,&nbsp;con&nbsp;una&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.7&nbsp;GHz&nbsp;que&nbsp;alcanza&nbsp;hasta&nbsp;5.0&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo.&nbsp;Es&nbsp;una&nbsp;versión&nbsp;OEM&nbsp;sin&nbsp;gráficos&nbsp;integrados,&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;de&nbsp;gaming&nbsp;o&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;que&nbsp;usarán&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;y&nbsp;cuenta&nbsp;con&nbsp;32&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3&nbsp;y&nbsp;un&nbsp;TDP&nbsp;de&nbsp;65W.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 7500F OEM AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"el RYZEN 5 7500F le da a tu PC una combinaci\\\\u00f3n perfecta de rendimiento, eficiencia y modernidad, ideal para un equipo potente y bien optimizado.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764606594_692dc282ad9ae.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/7blE0kYwRlQ\\\"]\"','2025-12-01 16:29:54','2025-12-01 20:18:48'),(45,152,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;7800X3D&nbsp;usa&nbsp;arquitectura&nbsp;Zen&nbsp;4&nbsp;sobre&nbsp;socket&nbsp;AM5,&nbsp;con&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos.&nbsp;Su&nbsp;frecuencia&nbsp;base&nbsp;es&nbsp;de&nbsp;4.2&nbsp;GHz&nbsp;y&nbsp;alcanza&nbsp;hasta&nbsp;5.0&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;ideal&nbsp;para&nbsp;rendimiento&nbsp;rápido&nbsp;en&nbsp;tareas&nbsp;intensivas.&nbsp;Destaca&nbsp;por&nbsp;su&nbsp;enorme&nbsp;caché&nbsp;L3&nbsp;de&nbsp;96&nbsp;MB&nbsp;mediante&nbsp;la&nbsp;tecnología&nbsp;3D&nbsp;V-Cache,&nbsp;lo&nbsp;que&nbsp;mejora&nbsp;dramáticamente&nbsp;la&nbsp;latencia&nbsp;y&nbsp;el&nbsp;rendimiento&nbsp;en&nbsp;videojuegos&nbsp;y&nbsp;tareas&nbsp;sensibles&nbsp;a&nbsp;caché.&nbsp;Es&nbsp;compatible&nbsp;con&nbsp;memoria&nbsp;DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;deja&nbsp;listo&nbsp;para&nbsp;hardware&nbsp;moderno&nbsp;y&nbsp;futuras&nbsp;generaciones.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR RYZEN 7 7800X3D AM5 8N 16H 4.2GHZ GPU OEM\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Al instalar el RYZEN 7 7800X3D, tu PC obtiene un gran rendimiento en juegos gracias a su cach\\\\u00e9 3D y potencia por n\\\\u00facleo, y tambi\\\\u00e9n destaca en tareas pesadas como edici\\\\u00f3n de video o 3D. Adem\\\\u00e1s, ofrece una plataforma moderna con DDR5 y PCIe 5.0, logrando un equipo r\\\\u00e1pido, eficiente y preparado para el futuro.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764607054_692dc44e7e161.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/apZoe4LLiY0\\\"]\"','2025-12-01 16:37:34','2025-12-01 16:37:34'),(46,153,'<p>El&nbsp;Ryzen&nbsp;7&nbsp;7800X3D&nbsp;es&nbsp;un&nbsp;procesador&nbsp;AM5&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;8&nbsp;núcleos,&nbsp;16&nbsp;hilos&nbsp;y&nbsp;96&nbsp;MB&nbsp;de&nbsp;caché&nbsp;3D,&nbsp;optimizado&nbsp;para&nbsp;ofrecer&nbsp;los&nbsp;mejores&nbsp;FPS&nbsp;en&nbsp;juegos&nbsp;y&nbsp;excelente&nbsp;desempeño&nbsp;en&nbsp;tareas&nbsp;exigentes.&nbsp;Es&nbsp;moderno,&nbsp;eficiente&nbsp;y&nbsp;compatible&nbsp;con&nbsp;DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 7800X3D AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"En tu PC, el 7800X3D te dar\\\\u00e1 m\\\\u00e1ximo rendimiento en juegos, gran fluidez en edici\\\\u00f3n, dise\\\\u00f1o o multitarea y una plataforma moderna lista para futuras actualizaciones, logrando un equipo r\\\\u00e1pido, potente y muy estable.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764607775_692dc71f6c0e3.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/AOqCsIxS_sA?si=uXHUIx53WG3LBhbK\\\"]\"','2025-12-01 16:49:35','2025-12-01 16:49:35'),(47,154,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i5-13400F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;eficiente&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;con&nbsp;nucleos&nbsp;e&nbsp;hilos&nbsp;suficientes&nbsp;para&nbsp;gaming,&nbsp;trabajo&nbsp;y&nbsp;multitarea.&nbsp;Ofrece&nbsp;hasta&nbsp;4.6&nbsp;GHz&nbsp;en&nbsp;turbo&nbsp;y&nbsp;20&nbsp;MB&nbsp;de&nbsp;caché,&nbsp;proporcionando&nbsp;buen&nbsp;rendimiento&nbsp;por&nbsp;núcleo&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;hardware&nbsp;moderno&nbsp;a&nbsp;un&nbsp;precio&nbsp;accesible.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE i5-13400F, Cache 20MB, Hasta 4.6\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"En tu PC, el i5-13400F te dar\\\\u00e1 rendimiento fluido en juegos, edici\\\\u00f3n y tareas generales, manteniendo un buen equilibrio entre potencia y eficiencia. Es una opci\\\\u00f3n ideal si buscas una PC actualizada, r\\\\u00e1pida y estable para uso diario o gaming sin gastar demasiado.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764608263_692dc90784acc.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/RSKM2WwTi6c\\\"]\"','2025-12-01 16:57:43','2025-12-01 16:57:43'),(48,155,'<p>El&nbsp;Ryzen&nbsp;7&nbsp;5700X&nbsp;es&nbsp;un&nbsp;procesador&nbsp;Zen&nbsp;3&nbsp;para&nbsp;socket&nbsp;AM4,&nbsp;con&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;3.4&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;hasta&nbsp;4.6&nbsp;GHz,&nbsp;y&nbsp;32&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3.&nbsp;Ofrece&nbsp;un&nbsp;buen&nbsp;balance&nbsp;entre&nbsp;potencia&nbsp;y&nbsp;eficiencia&nbsp;(TDP&nbsp;de&nbsp;65&nbsp;W),&nbsp;ideal&nbsp;para&nbsp;gaming,&nbsp;edición,&nbsp;multitarea&nbsp;y&nbsp;uso&nbsp;exigente&nbsp;sin&nbsp;gastar&nbsp;demasiado.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5700X AM4, 3.4GHZ CAJA\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"Con el Ryzen 7 5700X, tu PC se convierte en una m\\\\u00e1quina potente y vers\\\\u00e1til: capaz de ejecutar juegos modernos, trabajar con edici\\\\u00f3n, renderizado, multitarea y software exigente con fluidez y estabilidad. Gracias a su arquitectura Zen 3 y buen equilibrio rendimiento-consumo, es una excelente opci\\\\u00f3n para un PC potente sin entrar en gama ultra.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764608777_692dcb094281f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/TGN521vatVw?si=3YvvyMVn9gi-LmQf\\\"]\"','2025-12-01 17:06:17','2025-12-01 17:06:17'),(49,156,'<p>En&nbsp;tu&nbsp;PC,&nbsp;el&nbsp;<strong>8500G</strong>&nbsp;te&nbsp;dará&nbsp;un&nbsp;rendimiento&nbsp;rápido&nbsp;y&nbsp;fluido&nbsp;para&nbsp;tareas&nbsp;comunes,&nbsp;estudio,&nbsp;trabajo&nbsp;y&nbsp;gaming&nbsp;básico,&nbsp;convirtiéndola&nbsp;en&nbsp;una&nbsp;máquina&nbsp;práctica,&nbsp;económica&nbsp;y&nbsp;muy&nbsp;equilibrada&nbsp;sin&nbsp;requerir&nbsp;una&nbsp;GPU&nbsp;extra.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 8500G, AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"En tu PC, el 8500G te dar\\\\u00e1 un rendimiento r\\\\u00e1pido y fluido para tareas comunes, estudio, trabajo y gaming b\\\\u00e1sico, convirti\\\\u00e9ndola en una m\\\\u00e1quina pr\\\\u00e1ctica, econ\\\\u00f3mica y muy equilibrada sin requerir una GPU extra.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764609301_692dcd15096d7.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/1UqxXtn98yY?si=SOrFm9AXN4qxc-2B\\\"]\"','2025-12-01 17:15:01','2025-12-01 17:15:01'),(50,157,'<p>El&nbsp;i5-12400F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;con&nbsp;frecuencia&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;4.4&nbsp;GHz&nbsp;y&nbsp;18&nbsp;MB&nbsp;de&nbsp;caché&nbsp;Intel&nbsp;Smart&nbsp;Cache.&nbsp;Utiliza&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;y&nbsp;necesita&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;(no&nbsp;incluye&nbsp;iGPU).&nbsp;Es&nbsp;una&nbsp;opción&nbsp;equilibrada&nbsp;en&nbsp;potencia&nbsp;y&nbsp;eficiencia,&nbsp;ideal&nbsp;para&nbsp;gaming,&nbsp;productividad&nbsp;y&nbsp;multitarea&nbsp;sin&nbsp;gastar&nbsp;demasiado.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I5 12400F OEM LGA 1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el i5-12400F tu PC ser\\\\u00e1 capaz de manejar juegos modernos, edici\\\\u00f3n, trabajo y multitarea con fluidez. Ofrece un rendimiento fluido y estable equilibrando potencia y consumo, ideal para quienes quieren un PC r\\\\u00e1pido, vers\\\\u00e1til y eficiente sin gastar mucho en el procesador.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764609950_692dcf9ed80e8.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/AZjyjPFsFdY\\\"]\"','2025-12-01 17:25:50','2025-12-01 17:25:50'),(51,158,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i7-12700KF&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;12&nbsp;núcleos&nbsp;(8&nbsp;de&nbsp;rendimiento&nbsp;+&nbsp;4&nbsp;eficientes)&nbsp;y&nbsp;20&nbsp;hilos,&nbsp;con&nbsp;frecuencias&nbsp;que&nbsp;alcanzan&nbsp;hasta&nbsp;<strong>5.0&nbsp;GHz</strong>&nbsp;y&nbsp;<strong>25&nbsp;MB&nbsp;de&nbsp;caché</strong>.&nbsp;Está&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;alto&nbsp;en&nbsp;juegos,&nbsp;edición,&nbsp;renderizado&nbsp;y&nbsp;multitarea&nbsp;exigente,&nbsp;con&nbsp;soporte&nbsp;para&nbsp;memorias&nbsp;DDR4/DDR5&nbsp;y&nbsp;PCIe&nbsp;5.0.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I7 12700KF LGA1700\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL\\\",\\\"detalle\\\":\\\"Con el i7-12700KF tu PC se transforma en una m\\\\u00e1quina potente y vers\\\\u00e1til, capaz de manejar juegos exigentes, edici\\\\u00f3n de video, trabajo profesional y multitarea pesada sin problemas. Su arquitectura h\\\\u00edbrida y alto desempe\\\\u00f1o lo hacen ideal si buscas un balance entre potencia, eficiencia y longevidad del sistema.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764610359_692dd137c36f7.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/lpOePiZtuiI\\\"]\"','2025-12-01 17:32:39','2025-12-01 17:32:39'),(52,159,'<p>El&nbsp;Ryzen&nbsp;5&nbsp;7600X&nbsp;es&nbsp;un&nbsp;procesador&nbsp;moderno&nbsp;con&nbsp;<strong>6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos</strong>,&nbsp;ideal&nbsp;para&nbsp;gaming,&nbsp;edición&nbsp;y&nbsp;trabajos&nbsp;exigentes.&nbsp;Al&nbsp;ser&nbsp;parte&nbsp;de&nbsp;la&nbsp;plataforma&nbsp;AM5,&nbsp;ofrece&nbsp;arquitectura&nbsp;actual,&nbsp;compatibilidad&nbsp;con&nbsp;memorias&nbsp;modernas&nbsp;y&nbsp;un&nbsp;buen&nbsp;equilibrio&nbsp;entre&nbsp;potencia&nbsp;y&nbsp;eficiencia.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 7600X AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"Con el 7600X, tu PC se transforma en una m\\\\u00e1quina potente y vers\\\\u00e1til: capaz de correr juegos exigentes, editar video, trabajar con programas pesados o multitarea, siempre con fluidez. Es una opci\\\\u00f3n equilibrada si buscas rendimiento alto sin gastar en procesadores de gama premium.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764610785_692dd2e18710f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/86HELJhdTfE\\\"]\"','2025-12-01 17:39:45','2025-12-01 17:40:31'),(53,160,'<p>El&nbsp;Ryzen&nbsp;5&nbsp;8600G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;APU&nbsp;moderno&nbsp;con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;4.3&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;5.0&nbsp;GHz,&nbsp;ideal&nbsp;para&nbsp;quienes&nbsp;buscan&nbsp;rendimiento&nbsp;eficiente&nbsp;sin&nbsp;gastar&nbsp;de&nbsp;más.&nbsp;Incorpora&nbsp;gráficos&nbsp;integrados&nbsp;Radeon&nbsp;760M,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;usar&nbsp;el&nbsp;PC&nbsp;sin&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada.&nbsp;Es&nbsp;compatible&nbsp;con&nbsp;socket&nbsp;AM5,&nbsp;memoria&nbsp;DDR5,&nbsp;y&nbsp;ofrece&nbsp;buen&nbsp;equilibrio&nbsp;entre&nbsp;potencia,&nbsp;eficiencia&nbsp;y&nbsp;versatilidad.</p>','\"[{\\\"nombre\\\":\\\"CPU AMD RYZEN 5 8600G 4.30GHZ 6N 12TH 22MB AMD\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el 8600G en tu PC tienes una m\\\\u00e1quina completa: puedes navegar, trabajar, estudiar, editar de forma b\\\\u00e1sica, ver multimedia y hasta jugar t\\\\u00edtulos moderados sin necesidad de GPU dedicada. Es ideal para quienes quieren un equipo funcional y econ\\\\u00f3mico, con buen rendimiento general y gr\\\\u00e1ficos integrados suficientes para tareas cotidianas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764611200_692dd4802b501.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9XLhDcX-hgA?si=tF4QT4jjnSF8cdPU\\\"]\"','2025-12-01 17:46:40','2025-12-02 20:27:33'),(54,161,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;8700G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos&nbsp;para&nbsp;escritorio,&nbsp;con&nbsp;arquitectura&nbsp;Zen&nbsp;4&nbsp;y&nbsp;socket&nbsp;AM5.&nbsp;Su&nbsp;principal&nbsp;característica&nbsp;es&nbsp;la&nbsp;combinación&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;de&nbsp;CPU&nbsp;(hasta&nbsp;5.1&nbsp;GHz)&nbsp;y&nbsp;la&nbsp;potente&nbsp;gráfica&nbsp;integrada&nbsp;AMD&nbsp;Radeon&nbsp;780M,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;compactos&nbsp;que&nbsp;no&nbsp;requieren&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;para&nbsp;juegos&nbsp;ligeros&nbsp;o&nbsp;tareas&nbsp;de&nbsp;productividad.&nbsp;</p><p></p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 8700G, AM5\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"El AMD RYZEN 7 8700G es un procesador moderno y muy equilibrado, ideal para una PC de uso general porque combina bueno rendimiento (8 n\\\\u00facleos \\\\\\/ 16 hilos) con gr\\\\u00e1ficos integrados potentes, permitiendo trabajar, estudiar, editar ligero y jugar de forma b\\\\u00e1sica sin necesidad de una tarjeta de video.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764621749_692dfdb53f0bf.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/jVtKMluGT1A\\\"]\"','2025-12-01 20:42:29','2025-12-01 20:42:29'),(55,162,'<p>fdbvsfgdbbgfdbgf</p>','\"[{\\\"nombre\\\":\\\"bfgdgbdf\\\",\\\"valor\\\":\\\"fbgdgdbf\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"fgbdgbfd\\\",\\\"detalle\\\":\\\"fgbdbdfg\\\"}]\"','bfgdbgfdbgfd','ddfgbfd','gbfdbgfdgbfd','\"[34,34,43,34]\"',NULL,NULL,'2025-12-01 20:57:18','2025-12-01 20:57:18'),(56,163,'<p>El&nbsp;Intel&nbsp;Core&nbsp;i5-12400F&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;12ª&nbsp;generación&nbsp;diseñado&nbsp;para&nbsp;PCs&nbsp;de&nbsp;escritorio&nbsp;que&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;muy&nbsp;equilibrado&nbsp;para&nbsp;gaming&nbsp;y&nbsp;multitarea.&nbsp;Cuenta&nbsp;con&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos&nbsp;que&nbsp;alcanzan&nbsp;frecuencias&nbsp;entre&nbsp;2.50&nbsp;GHz&nbsp;y&nbsp;4.40&nbsp;GHz&nbsp;en&nbsp;modo&nbsp;turbo,&nbsp;proporcionando&nbsp;buena&nbsp;velocidad&nbsp;en&nbsp;tareas&nbsp;diarias,&nbsp;trabajo,&nbsp;edición&nbsp;ligera&nbsp;y&nbsp;juegos&nbsp;modernos.&nbsp;Utiliza&nbsp;el&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;y&nbsp;es&nbsp;compatible&nbsp;tanto&nbsp;con&nbsp;memorias&nbsp;DDR4&nbsp;como&nbsp;DDR5,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;armar&nbsp;una&nbsp;PC&nbsp;flexible&nbsp;y&nbsp;actualizable.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR INTEL CORE I5-12400F 2.50GZ CAJA\\\",\\\"valor\\\":\\\"INTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR INTEL \\\",\\\"detalle\\\":\\\"El i5-12400F funciona con 6 n\\\\u00facleos basados en la arquitectura Alder Lake y 12 hilos mediante tecnolog\\\\u00eda Hyper-Threading, ofreciendo una base s\\\\u00f3lida para juegos, programas de oficina, dise\\\\u00f1o b\\\\u00e1sico y uso general. Su velocidad base de 2.50 GHz y su turbo de hasta 4.40 GHz ayudan a obtener un buen desempe\\\\u00f1o por n\\\\u00facleo, ideal para videojuegos actuales que dependen de la potencia individual del procesador.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764622959_692e026f36ce8.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/qska8IDYAiM?si=K9tK5Jqzvet-OaeK\\\"]\"','2025-12-01 21:02:39','2025-12-01 21:02:39'),(57,164,'<p>El&nbsp;AMD&nbsp;Ryzen&nbsp;7&nbsp;5700X&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos&nbsp;basado&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Zen&nbsp;3,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;bajo&nbsp;consumo.&nbsp;Trabaja&nbsp;entre&nbsp;3.4&nbsp;GHz&nbsp;y&nbsp;4.6&nbsp;GHz,&nbsp;permitiendo&nbsp;ejecutar&nbsp;juegos&nbsp;modernos&nbsp;y&nbsp;programas&nbsp;exigentes&nbsp;con&nbsp;fluidez.&nbsp;Su&nbsp;gran&nbsp;caché&nbsp;de&nbsp;32&nbsp;MB&nbsp;mejora&nbsp;la&nbsp;rapidez&nbsp;en&nbsp;procesamiento&nbsp;y&nbsp;respuesta&nbsp;del&nbsp;sistema.&nbsp;Funciona&nbsp;en&nbsp;socket&nbsp;AM4&nbsp;y&nbsp;usa&nbsp;memoria&nbsp;DDR4,&nbsp;siendo&nbsp;ideal&nbsp;para&nbsp;actualizar&nbsp;o&nbsp;armar&nbsp;una&nbsp;PC&nbsp;potente&nbsp;sin&nbsp;gastar&nbsp;demasiado.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5700X OEM AM4\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"el RYZEN 7 5700X para tu PC, obtendr\\\\u00e1s un equipo con potencia real para pr\\\\u00e1cticamente cualquier tarea: desde navegaci\\\\u00f3n, ofim\\\\u00e1tica y trabajo diario, hasta edici\\\\u00f3n de video, modelado 3D, multitarea exigente o gaming moderno con GPU dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764623534_692e04ae54a54.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/TGN521vatVw\\\"]\"','2025-12-01 21:12:14','2025-12-01 21:12:14'),(58,165,'<p>El&nbsp;Ryzen&nbsp;7&nbsp;5700G&nbsp;es&nbsp;un&nbsp;procesador-APU&nbsp;basado&nbsp;en&nbsp;arquitectura&nbsp;Zen&nbsp;3&nbsp;fabricado&nbsp;en&nbsp;7&nbsp;nm&nbsp;que&nbsp;reúne&nbsp;potencia&nbsp;de&nbsp;CPU&nbsp;y&nbsp;gráficos&nbsp;integrados&nbsp;en&nbsp;un&nbsp;solo&nbsp;chip.&nbsp;Tiene&nbsp;8&nbsp;núcleos&nbsp;y&nbsp;16&nbsp;hilos&nbsp;de&nbsp;ejecución,&nbsp;con&nbsp;frecuencia&nbsp;base&nbsp;de&nbsp;alrededor&nbsp;de&nbsp;3.8&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;de&nbsp;hasta&nbsp;4.6&nbsp;GHz,&nbsp;lo&nbsp;que&nbsp;asegura&nbsp;buen&nbsp;desempeño&nbsp;tanto&nbsp;en&nbsp;tareas&nbsp;de&nbsp;múltiples&nbsp;hilos&nbsp;como&nbsp;en&nbsp;aquellas&nbsp;que&nbsp;dependen&nbsp;de&nbsp;potencia&nbsp;por&nbsp;núcleo.&nbsp;Incluye&nbsp;una&nbsp;GPU&nbsp;integrada&nbsp;(Radeon&nbsp;Graphics&nbsp;/&nbsp;Vega&nbsp;8)&nbsp;que&nbsp;permite&nbsp;generar&nbsp;video&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;funcional&nbsp;“temprano”&nbsp;sin&nbsp;invertir&nbsp;adicional.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 7 5700G OEM AM4 AST\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"Con el RYZEN 7 5700G tu PC se convierte en un equipo robusto para un rango amplio de usos: desde tareas cotidianas, trabajo, edici\\\\u00f3n ligera, hasta gaming moderado y multimedia sin necesidad de comprar una tarjeta gr\\\\u00e1fica desde el inicio. Es una base s\\\\u00f3lida si buscas una PC equilibrada que funcione \\\\u201cde una vez\\\\u201d con solo instalar CPU, RAM, y placa madre \\\\u2014 \\\\u00fatil si no quieres gastar extra en GPU al principio.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764623868_692e05fcc1b1f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/4VqbYCpQdRo\\\"]\"','2025-12-01 21:17:48','2025-12-01 21:20:37'),(59,166,'<p>El&nbsp;Ryzen&nbsp;5&nbsp;5500&nbsp;es&nbsp;un&nbsp;procesador&nbsp;de&nbsp;escritorio&nbsp;basado&nbsp;en&nbsp;arquitectura&nbsp;Zen&nbsp;3&nbsp;(7&nbsp;nm)&nbsp;que&nbsp;ofrece&nbsp;un&nbsp;equilibrio&nbsp;atractivo&nbsp;entre&nbsp;potencia,&nbsp;eficiencia&nbsp;y&nbsp;compatibilidad.&nbsp;Tiene&nbsp;6&nbsp;núcleos&nbsp;y&nbsp;12&nbsp;hilos,&nbsp;con&nbsp;frecuencia&nbsp;base&nbsp;en&nbsp;3.6&nbsp;GHz&nbsp;y&nbsp;turbo&nbsp;hasta&nbsp;aproximadamente&nbsp;4.2&nbsp;GHz&nbsp;—&nbsp;suficiente&nbsp;para&nbsp;tareas&nbsp;cotidianas,&nbsp;gaming&nbsp;y&nbsp;trabajo&nbsp;multitarea&nbsp;con&nbsp;buen&nbsp;rendimiento.&nbsp;Dispone&nbsp;de&nbsp;caché&nbsp;L2&nbsp;y&nbsp;L3&nbsp;combinada&nbsp;(con&nbsp;16&nbsp;MB&nbsp;de&nbsp;caché&nbsp;L3),&nbsp;lo&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;velocidad&nbsp;y&nbsp;fluidez&nbsp;en&nbsp;procesos&nbsp;múltiples&nbsp;o&nbsp;exigentes.&nbsp;Su&nbsp;socket&nbsp;AM4&nbsp;y&nbsp;soporte&nbsp;de&nbsp;memoria&nbsp;DDR4&nbsp;lo&nbsp;hacen&nbsp;compatible&nbsp;con&nbsp;muchas&nbsp;placas&nbsp;madre&nbsp;existentes,&nbsp;facilitando&nbsp;construir&nbsp;o&nbsp;actualizar&nbsp;una&nbsp;PC&nbsp;sin&nbsp;gastar&nbsp;demasiado.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD RYZEN 5 5500 3.60 6N 12TH AM4 19MB\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD\\\",\\\"detalle\\\":\\\"Con el Ryzen 5 5500 tu PC ganar\\\\u00e1 potencia real sin complicaciones: podr\\\\u00e1 manejar desde ofim\\\\u00e1tica, navegaci\\\\u00f3n o edici\\\\u00f3n ligera hasta juegos modernos y tareas demandantes de CPU sin cuello de botella, siempre que uses una GPU dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764624669_692e091dc48a5.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/FRZq8n4LyR0\\\"]\"','2025-12-01 21:31:09','2025-12-01 21:31:09'),(60,167,'<p>El&nbsp;Athlon&nbsp;3000G&nbsp;es&nbsp;un&nbsp;procesador&nbsp;básico-económico&nbsp;para&nbsp;PC&nbsp;que&nbsp;combina&nbsp;CPU&nbsp;simple&nbsp;con&nbsp;gráficos&nbsp;integrados,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;sencillas.&nbsp;Tiene&nbsp;2&nbsp;núcleos&nbsp;y&nbsp;4&nbsp;hilos&nbsp;trabajando&nbsp;a&nbsp;3.5&nbsp;GHz,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;ejecutar&nbsp;sistemas&nbsp;operativos&nbsp;modernos,&nbsp;navegar&nbsp;por&nbsp;internet,&nbsp;reproducir&nbsp;multimedia,&nbsp;ofimática,&nbsp;y&nbsp;funcionar&nbsp;como&nbsp;base&nbsp;de&nbsp;una&nbsp;PC&nbsp;ligera.&nbsp;Integra&nbsp;gráficos&nbsp;Radeon&nbsp;Vega&nbsp;3,&nbsp;lo&nbsp;que&nbsp;evita&nbsp;la&nbsp;necesidad&nbsp;inmediata&nbsp;de&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;si&nbsp;solo&nbsp;buscas&nbsp;tareas&nbsp;básicas,&nbsp;multimedia&nbsp;o&nbsp;juegos&nbsp;muy&nbsp;ligeros.</p>','\"[{\\\"nombre\\\":\\\"PROCESADOR AMD ATHLON 3000G\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR AMD \\\",\\\"detalle\\\":\\\"Si usas el Athlon 3000G en tu PC, tendr\\\\u00e1s un equipo econ\\\\u00f3mico y funcional para trabajar, estudiar, navegar, ver videos, usar redes sociales, editar documentos o correr programas ligeros sin gastar demasiado en hardware.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764625105_692e0ad1e91ad.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/udhNNDT6uoo\\\"]\"','2025-12-01 21:38:25','2025-12-01 21:38:25'),(61,168,'<p>La&nbsp;ASUS&nbsp;TUF&nbsp;GAMING&nbsp;B760-PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;ATX&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;12ª&nbsp;y&nbsp;13ª&nbsp;generación&nbsp;(socket&nbsp;LGA&nbsp;1700),&nbsp;que&nbsp;ofrece&nbsp;conectividad&nbsp;inalámbrica&nbsp;Wi-Fi&nbsp;6&nbsp;y&nbsp;Bluetooth&nbsp;5.2,&nbsp;además&nbsp;de&nbsp;Ethernet&nbsp;de&nbsp;2.5&nbsp;Gb.&nbsp;Está&nbsp;equipada&nbsp;con&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;DDR5&nbsp;de&nbsp;hasta&nbsp;128&nbsp;GB,&nbsp;ranura&nbsp;PCIe&nbsp;5.0&nbsp;x16,&nbsp;M.2,&nbsp;y&nbsp;cuenta&nbsp;con&nbsp;un&nbsp;diseño&nbsp;de&nbsp;disipación&nbsp;mejorado&nbsp;y&nbsp;un&nbsp;sistema&nbsp;de&nbsp;audio&nbsp;de&nbsp;alta&nbsp;calidad&nbsp;con&nbsp;DTS.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS TUF GAMING B760 PLUS WIFI\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE ASUS\\\",\\\"detalle\\\":\\\"TUF GAMING B760 PLUS WIFI Con esta placa madre tu PC tendr\\\\u00e1 una base muy s\\\\u00f3lida: soporte para procesadores modernos, alta compatibilidad con memorias r\\\\u00e1pidas DDR5, almacenamiento SSD veloz y estable, adem\\\\u00e1s de conexiones modernas y red r\\\\u00e1pida gracias a WiFi 6 y Ethernet 2.5 Gb. Esto se traduce en un equipo que responde bien tanto a tareas cotidianas como a gaming, edici\\\\u00f3n, multitarea o trabajos que demandan recursos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764686305_692ef9e1cd907.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/PiVLDiTDd84\\\"]\"','2025-12-02 14:38:25','2025-12-02 14:38:25'),(62,169,'<p>La&nbsp;ASUS&nbsp;TUF&nbsp;GAMING&nbsp;B550-PLUS&nbsp;WIFI&nbsp;II&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;chipset&nbsp;AMD&nbsp;B550&nbsp;que&nbsp;ofrece&nbsp;una&nbsp;base&nbsp;moderna,&nbsp;robusta&nbsp;y&nbsp;versátil&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;con&nbsp;procesador&nbsp;AMD.&nbsp;Su&nbsp;socket&nbsp;AM4&nbsp;la&nbsp;hace&nbsp;compatible&nbsp;con&nbsp;múltiples&nbsp;generaciones&nbsp;de&nbsp;CPUs&nbsp;Ryzen,&nbsp;por&nbsp;lo&nbsp;que&nbsp;ofrece&nbsp;flexibilidad&nbsp;y&nbsp;longevidad.&nbsp;Con&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;DDR4&nbsp;hasta&nbsp;128&nbsp;GB&nbsp;y&nbsp;velocidades&nbsp;altas,&nbsp;brinda&nbsp;buenas&nbsp;posibilidades&nbsp;para&nbsp;multitarea,&nbsp;edición,&nbsp;juegos&nbsp;o&nbsp;trabajo&nbsp;exigente.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS TUF GAMING B550 PLUS WIFI II AM4\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE ASUS \\\",\\\"detalle\\\":\\\"ASUS TUF GAMING B550 PLUS WIFI II AM4 Con esta placa base tu PC se convierte en un equipo bien equipado, capaz de manejar procesadores Ryzen, memoria abundante, almacenamiento veloz, y tarjetas modernas sin cuellos de botella\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764687546_692efeba7c31e.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/UUlKsmfHxxs?si=4KAAuY30w8jSHghq\\\"]\"','2025-12-02 14:48:40','2025-12-02 14:59:06'),(63,170,'<p>La&nbsp;MSI&nbsp;PRO&nbsp;H610M-G&nbsp;DDR4&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;compacta&nbsp;(factor&nbsp;micro-ATX)&nbsp;cuya&nbsp;arquitectura&nbsp;está&nbsp;pensada&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;moderna&nbsp;con&nbsp;procesadores&nbsp;recientes&nbsp;Intel&nbsp;de&nbsp;socket&nbsp;LGA&nbsp;1700.&nbsp;Admite&nbsp;procesadores&nbsp;de&nbsp;12.ª,&nbsp;13.ª&nbsp;e&nbsp;incluso&nbsp;14.ª&nbsp;generación&nbsp;(Core,&nbsp;Pentium&nbsp;Gold,&nbsp;Celeron)&nbsp;—&nbsp;lo&nbsp;que&nbsp;te&nbsp;da&nbsp;flexibilidad&nbsp;para&nbsp;elegir&nbsp;CPU&nbsp;de&nbsp;distintas&nbsp;gamas.&nbsp;La&nbsp;placa&nbsp;usa&nbsp;memoria&nbsp;DDR4&nbsp;con&nbsp;soporte&nbsp;para&nbsp;hasta&nbsp;64&nbsp;GB&nbsp;en&nbsp;dual-channel,&nbsp;con&nbsp;frecuencias&nbsp;de&nbsp;hasta&nbsp;3200&nbsp;MHz,&nbsp;lo&nbsp;que&nbsp;brinda&nbsp;balance&nbsp;entre&nbsp;compatibilidad,&nbsp;rendimiento&nbsp;y&nbsp;precio.</p>','\"[{\\\"nombre\\\":\\\"MAINBOARD MSI PRO H610M-G DDR4, LGA 1700\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE MSI\\\",\\\"detalle\\\":\\\"MSI PRO H610M-G DDR4 tendr\\\\u00e1s una base s\\\\u00f3lida, flexible y preparada para muchos usos: desde tareas cotidianas, ofim\\\\u00e1tica, navegaci\\\\u00f3n o edici\\\\u00f3n ligera, hasta gaming con GPU dedicada, edici\\\\u00f3n media, multitarea y trabajo exigente. La placa da margen para actualizar componentes (CPU, RAM, GPU, almacenamiento) sin necesidad de cambiar la base pronto, lo que la hace ideal si buscas una PC duradera y flexible.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764687382_692efe167ecb0.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/--HkbsDBT8Q\\\"]\"','2025-12-02 14:56:22','2025-12-02 14:56:22'),(64,171,'<p>La&nbsp;ASUS&nbsp;TUF&nbsp;GAMING&nbsp;X870-PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;pensada&nbsp;para&nbsp;sacar&nbsp;el&nbsp;máximo&nbsp;provecho&nbsp;a&nbsp;los&nbsp;procesadores&nbsp;modernos&nbsp;de&nbsp;AMD&nbsp;—&nbsp;su&nbsp;socket&nbsp;AM5&nbsp;y&nbsp;su&nbsp;chipset&nbsp;X870&nbsp;la&nbsp;preparan&nbsp;para&nbsp;las&nbsp;últimas&nbsp;generaciones&nbsp;Ryzen.&nbsp;Usa&nbsp;memorias&nbsp;DDR5&nbsp;en&nbsp;configuración&nbsp;dual-channel,&nbsp;con&nbsp;soporte&nbsp;de&nbsp;hasta&nbsp;4&nbsp;módulos&nbsp;DIMM&nbsp;y&nbsp;velocidades&nbsp;altas,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;funcionamiento&nbsp;fluido,&nbsp;rápido&nbsp;y&nbsp;moderno.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA ASUS TUF GAMING X870-PLUS WIFI AMD RYZEN AM5 DDR5\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS \\\",\\\"detalle\\\":\\\"TUF GAMING X870-PLUS WIFI AMD RYZEN AM5 DDR5Con esta placa madre tu PC se convierte en un sistema moderno, potente y bien equipado, listo para aprovechar CPUs Ryzen actuales y futuras, memorias r\\\\u00e1pidas, SSDs veloces y tarjetas gr\\\\u00e1ficas exigentes. Tu equipo podr\\\\u00e1 manejar desde tareas cotidianas hasta gaming AAA, edici\\\\u00f3n, render, multitarea intensiva o trabajos profesionales sin cuellos de botella.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764688076_692f00cc48c38.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9ZAtrQjjtak\\\"]\"','2025-12-02 15:07:56','2025-12-02 15:07:56'),(65,172,'<p>La&nbsp;MSI&nbsp;B760&nbsp;GAMING&nbsp;PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;moderna&nbsp;y&nbsp;completa&nbsp;que&nbsp;sirve&nbsp;como&nbsp;columna&nbsp;vertebral&nbsp;para&nbsp;un&nbsp;PC&nbsp;con&nbsp;procesador&nbsp;Intel&nbsp;reciente.&nbsp;Su&nbsp;zócalo&nbsp;LGA&nbsp;1700&nbsp;la&nbsp;hace&nbsp;compatible&nbsp;con&nbsp;CPUs&nbsp;Intel&nbsp;Core&nbsp;(12ª,&nbsp;13ª,&nbsp;incluso&nbsp;14ª&nbsp;generación),&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;un&nbsp;rendimiento&nbsp;actual&nbsp;y&nbsp;con&nbsp;posibilidad&nbsp;de&nbsp;actualización&nbsp;futura.&nbsp;Soporta&nbsp;memorias&nbsp;DDR5&nbsp;en&nbsp;modo&nbsp;dual-channel,&nbsp;permitiendo&nbsp;montajes&nbsp;con&nbsp;RAM&nbsp;muy&nbsp;rápida&nbsp;y&nbsp;alta&nbsp;capacidad,&nbsp;ideal&nbsp;tanto&nbsp;para&nbsp;juegos&nbsp;como&nbsp;para&nbsp;tareas&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"MAINBOARD MSI B760 GAMING PLUS WIFI, DDR5 LGA 1700\\\",\\\"valor\\\":\\\" MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MSI\\\",\\\"detalle\\\":\\\"B760 GAMING PLUS WIFI, DDR5 LGA 1700 Esta placa como base de tu PC, obtendr\\\\u00e1s un equipo moderno, veloz y preparado para muchos a\\\\u00f1os: ser\\\\u00e1 capaz de manejar desde tareas cotidianas hasta juegos exigentes, edici\\\\u00f3n, multitarea intensiva o trabajo profesional. Gracias a DDR5, buena compatibilidad y red r\\\\u00e1pida, tu PC funcionar\\\\u00e1 fluida y estable, con tiempos de carga bajos, buena respuesta y poca latencia en red.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764688455_692f02474a708.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/6-gF9rl6Wp0\\\"]\"','2025-12-02 15:14:15','2025-12-02 15:14:15'),(66,173,'<p>La&nbsp;Esonic&nbsp;H610M&nbsp;DDR4&nbsp;LGA1700&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;sencilla&nbsp;y&nbsp;funcional&nbsp;pensada&nbsp;para&nbsp;montar&nbsp;PCs&nbsp;modernas&nbsp;con&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;(compatible&nbsp;con&nbsp;generaciones&nbsp;recientes).&nbsp;Su&nbsp;compatibilidad&nbsp;con&nbsp;memorias&nbsp;DDR4&nbsp;ofrece&nbsp;una&nbsp;opción&nbsp;económica&nbsp;y&nbsp;estable&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;sin&nbsp;gastar&nbsp;demasiado&nbsp;en&nbsp;componentes&nbsp;de&nbsp;gama&nbsp;alta.&nbsp;Con&nbsp;soporte&nbsp;para&nbsp;hasta&nbsp;64&nbsp;GB&nbsp;de&nbsp;RAM&nbsp;en&nbsp;dual-channel,&nbsp;almacenamiento&nbsp;por&nbsp;SATA&nbsp;y&nbsp;M.2,&nbsp;y&nbsp;opciones&nbsp;comunes&nbsp;de&nbsp;conectividad&nbsp;(USB,&nbsp;LAN,&nbsp;audio),&nbsp;ofrece&nbsp;lo&nbsp;esencial&nbsp;para&nbsp;un&nbsp;equipo&nbsp;de&nbsp;escritorio&nbsp;eficiente.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ESONIC H610M DDR4 LGA 1700\\\",\\\"valor\\\":\\\"ESONIC\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PROCESADOR ESONIC\\\",\\\"detalle\\\":\\\" H610M DDR4 LGA 1700 Si tu PC est\\\\u00e1 armada con esta placa, significa que tendr\\\\u00e1s una base econ\\\\u00f3mica y pr\\\\u00e1ctica: suficientemente capaz para tareas de oficina, estudio, navegaci\\\\u00f3n, multimedia, edici\\\\u00f3n ligera, e incluso gaming si agregas una GPU dedicada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764691152_692f0cd09b1a0.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/HF_ZqNLBagI\\\"]\"','2025-12-02 15:59:12','2025-12-02 15:59:12'),(67,174,'<p>La&nbsp;Gigabyte&nbsp;H610M&nbsp;K&nbsp;V2&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;moderna&nbsp;y&nbsp;compacta&nbsp;(formato&nbsp;micro-ATX)&nbsp;pensada&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;con&nbsp;procesador&nbsp;Intel&nbsp;actual.&nbsp;Su&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;y&nbsp;chipset&nbsp;Intel&nbsp;H610&nbsp;la&nbsp;hacen&nbsp;compatible&nbsp;con&nbsp;procesadores&nbsp;Intel&nbsp;Core&nbsp;de&nbsp;12.ª,&nbsp;13.ª&nbsp;y&nbsp;14.ª&nbsp;generación,&nbsp;lo&nbsp;que&nbsp;te&nbsp;permite&nbsp;usar&nbsp;CPUs&nbsp;recientes&nbsp;con&nbsp;buena&nbsp;compatibilidad.&nbsp;Su&nbsp;soporte&nbsp;de&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;dos&nbsp;ranuras&nbsp;DIMM,&nbsp;con&nbsp;hasta&nbsp;128&nbsp;GB&nbsp;y&nbsp;funcionamiento&nbsp;en&nbsp;doble&nbsp;canal,&nbsp;permite&nbsp;tener&nbsp;una&nbsp;base&nbsp;rápida&nbsp;y&nbsp;fluida&nbsp;para&nbsp;tareas&nbsp;variadas,&nbsp;desde&nbsp;ofimática&nbsp;hasta&nbsp;gaming.&nbsp;Para&nbsp;expansión&nbsp;gráfica&nbsp;o&nbsp;uso&nbsp;intensivo&nbsp;en&nbsp;gráficos,&nbsp;incluye&nbsp;ranura&nbsp;PCIe&nbsp;4.0&nbsp;x16,&nbsp;ideal&nbsp;para&nbsp;instalar&nbsp;tarjetas&nbsp;de&nbsp;video&nbsp;modernas.&nbsp;También&nbsp;ofrece&nbsp;ranura&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;rápido,&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(HDMI&nbsp;/&nbsp;DisplayPort,&nbsp;útil&nbsp;si&nbsp;tu&nbsp;CPU&nbsp;tiene&nbsp;gráficos&nbsp;integrados),&nbsp;múltiples&nbsp;puertos&nbsp;USB,&nbsp;red&nbsp;Gigabit&nbsp;LAN&nbsp;y&nbsp;audio&nbsp;integrado&nbsp;—&nbsp;cubriendo&nbsp;las&nbsp;necesidades&nbsp;básicas&nbsp;y&nbsp;medias&nbsp;de&nbsp;una&nbsp;PC&nbsp;actual.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE H610M K V2 DDR5 LGA 1700\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"\\\\u00b4PLACA MADRE GIGABYTE\\\",\\\"detalle\\\":\\\"La Gigabyte H610M K V2 DDR5 convierte tu PC en una plataforma moderna, r\\\\u00e1pida y estable gracias al soporte para procesadores Intel LGA1700 y memoria DDR5. Tu equipo obtiene una base eficiente para trabajar, estudiar, jugar y usar aplicaciones exigentes con buena fluidez. La placa permite instalar una tarjeta gr\\\\u00e1fica actual, un SSD M.2 de alta velocidad y procesadores potentes sin perder compatibilidad, logrando que tu PC sea \\\\u00e1gil, equilibrada y preparada para futuras mejoras sin necesidad de cambiar toda la estructura.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764691822_692f0f6ea9774.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/YHHs_X8OZEc\\\"]\"','2025-12-02 16:10:22','2025-12-02 16:10:22'),(68,175,'<p>La&nbsp;ROG&nbsp;STRIX&nbsp;B850-G&nbsp;Gaming&nbsp;WiFi&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;moderna&nbsp;con&nbsp;socket&nbsp;AM5,&nbsp;diseñada&nbsp;para&nbsp;aprovechar&nbsp;al&nbsp;máximo&nbsp;los&nbsp;procesadores&nbsp;recientes&nbsp;de&nbsp;AMD&nbsp;en&nbsp;la&nbsp;plataforma&nbsp;AM5.&nbsp;Usa&nbsp;memoria&nbsp;DDR5&nbsp;con&nbsp;soporte&nbsp;para&nbsp;altas&nbsp;velocidades&nbsp;y&nbsp;puede&nbsp;alojar&nbsp;hasta&nbsp;4&nbsp;módulos&nbsp;DIMM,&nbsp;lo&nbsp;que&nbsp;la&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;un&nbsp;sistema&nbsp;rápido,&nbsp;actual&nbsp;y&nbsp;con&nbsp;mucho&nbsp;potencial&nbsp;de&nbsp;RAM.&nbsp;Cuenta&nbsp;con&nbsp;soporte&nbsp;para&nbsp;PCIe&nbsp;5.0,&nbsp;ranuras&nbsp;M.2&nbsp;múltiples&nbsp;para&nbsp;SSD&nbsp;ultrarrápidos,&nbsp;y&nbsp;conectividad&nbsp;de&nbsp;primera&nbsp;línea:&nbsp;red&nbsp;LAN&nbsp;2.5&nbsp;Gb,&nbsp;WiFi&nbsp;7,&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(HDMI&nbsp;+&nbsp;DisplayPort)&nbsp;y&nbsp;puertos&nbsp;USB-C&nbsp;de&nbsp;20&nbsp;Gbps,&nbsp;ofreciendo&nbsp;compatibilidad&nbsp;con&nbsp;periféricos&nbsp;y&nbsp;componentes&nbsp;modernos.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS ROG STRIX B850-G GAMING WIFI 7 AM5\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"ROG STRIX B850-G GAMING WIFI 7 AM5 esta placa en tu PC significa contar con una plataforma vers\\\\u00e1til, eficiente y lista para el futuro: tu equipo podr\\\\u00e1 trabajar con procesadores AMD AM5 recientes, memoria DDR5 veloz, almacenamiento SSD moderno, y una tarjeta gr\\\\u00e1fica potente sin limitaciones. El soporte para WiFi 7 y red r\\\\u00e1pida te asegura conexi\\\\u00f3n estable y veloz para juegos, internet o trabajo online. Gracias a sus ranuras M.2 y PCIe 5.0, los tiempos de carga ser\\\\u00e1n r\\\\u00e1pidos y la expansi\\\\u00f3n de hardware (RAM, SSD, GPU) estar\\\\u00e1 asegurada por a\\\\u00f1os.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764692830_692f135ea1ef4.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/ZR4J5Okj0r8?si=raKYFXm09m14lNQt\\\"]\"','2025-12-02 16:27:10','2025-12-02 16:27:10'),(69,176,'<p>La&nbsp;MSI&nbsp;MAG&nbsp;B860&nbsp;TOMAHAWK&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1851,&nbsp;diseñada&nbsp;para&nbsp;ofrecer&nbsp;una&nbsp;plataforma&nbsp;moderna,&nbsp;veloz&nbsp;y&nbsp;lista&nbsp;para&nbsp;nuevas&nbsp;generaciones.&nbsp;Su&nbsp;compatibilidad&nbsp;con&nbsp;memoria&nbsp;DDR5&nbsp;(hasta&nbsp;256&nbsp;GB)&nbsp;y&nbsp;soporte&nbsp;de&nbsp;memorias&nbsp;muy&nbsp;rápidas&nbsp;la&nbsp;hacen&nbsp;ideal&nbsp;para&nbsp;quienes&nbsp;buscan&nbsp;un&nbsp;rendimiento&nbsp;fluido&nbsp;tanto&nbsp;en&nbsp;tareas&nbsp;comunes&nbsp;como&nbsp;exigentes.&nbsp;Dispone&nbsp;de&nbsp;ranura&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;GPU&nbsp;dedicada,&nbsp;ranuras&nbsp;M.2&nbsp;(una&nbsp;de&nbsp;ellas&nbsp;PCIe&nbsp;5.0)&nbsp;para&nbsp;SSDs&nbsp;ultrarrápidas&nbsp;y&nbsp;múltiples&nbsp;opciones&nbsp;de&nbsp;expansión,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;montar&nbsp;una&nbsp;PC&nbsp;equilibrada,&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella,&nbsp;y&nbsp;con&nbsp;almacenamiento&nbsp;rápido.&nbsp;Además&nbsp;integra&nbsp;conectividad&nbsp;avanzada&nbsp;con&nbsp;Wi-Fi&nbsp;7,&nbsp;LAN&nbsp;5&nbsp;Gb,&nbsp;Thunderbolt&nbsp;4,&nbsp;salidas&nbsp;modernas&nbsp;de&nbsp;video&nbsp;y&nbsp;puertos&nbsp;actualizados&nbsp;USB-C/A,&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;a&nbsp;tu&nbsp;sistema&nbsp;acceso&nbsp;a&nbsp;redes&nbsp;rápidas,&nbsp;periféricos&nbsp;modernos&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;hardware&nbsp;reciente.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MSI\\\",\\\"detalle\\\":\\\"Con la PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5 Tu PC con esta placa madre se convierte en un sistema moderno y eficiente, capaz de montar un procesador Intel reciente, memoria DDR5 r\\\\u00e1pida, SSDs NVMe veloces y una buena tarjeta gr\\\\u00e1fica sin limitaciones. Tendr\\\\u00e1s una base robusta y actual \\\\u2014 ideal para gaming, edici\\\\u00f3n, multitarea pesada o trabajo profesional \\\\u2014 que adem\\\\u00e1s acepta actualizaciones de hardware en el futuro sin necesidad de cambiar la placa madre. El soporte de PCIe 5.0, ranuras M.2 y conectividad avanzada (Wi-Fi 7, red 5 Gb, USB-C\\\\\\/Thunderbolt) te da una plataforma vers\\\\u00e1til, r\\\\u00e1pida y preparada para exigencias actuales y futuras. En pocas palabras: tu PC ser\\\\u00e1 equilibrada, veloz, estable y preparada para muchos a\\\\u00f1os de uso con buen rendimiento\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764693487_692f15ef54bde.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/zw2zNlu8b8g\\\"]\"','2025-12-02 16:38:07','2025-12-02 16:38:07'),(70,177,'<p>La&nbsp;ASUS&nbsp;TUF&nbsp;GAMING&nbsp;B850-PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;de&nbsp;nueva&nbsp;generación&nbsp;pensada&nbsp;para&nbsp;los&nbsp;procesadores&nbsp;modernos&nbsp;de&nbsp;AMD&nbsp;sobre&nbsp;el&nbsp;socket&nbsp;AM5.&nbsp;Está&nbsp;diseñada&nbsp;con&nbsp;componentes&nbsp;de&nbsp;grado&nbsp;militar,&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;robustez,&nbsp;durabilidad&nbsp;y&nbsp;estabilidad&nbsp;incluso&nbsp;bajo&nbsp;carga&nbsp;prolongada.&nbsp;Usa&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;configuración&nbsp;de&nbsp;doble&nbsp;canal&nbsp;con&nbsp;soporte&nbsp;para&nbsp;altas&nbsp;velocidades,&nbsp;permitiendo&nbsp;aprovechar&nbsp;toda&nbsp;la&nbsp;potencia&nbsp;de&nbsp;CPUs&nbsp;Ryzen&nbsp;recientes&nbsp;y&nbsp;de&nbsp;futuras&nbsp;generaciones.&nbsp;Integra&nbsp;ranuras&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;y&nbsp;para&nbsp;almacenamiento&nbsp;ultrarrápido,&nbsp;y&nbsp;dispone&nbsp;de&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;la&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;un&nbsp;sistema&nbsp;veloz,&nbsp;responsivo&nbsp;y&nbsp;preparado&nbsp;para&nbsp;hardware&nbsp;moderno.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS TUF GAMING B850-PLUS WIFI AM5\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS \\\",\\\"detalle\\\":\\\"Con la TUF GAMING B850-PLUS WIFI AM5 Tu PC con esa placa madre se convierte en un equipo moderno, potente y preparado para aprovechar procesadores actuales de AMD con socket AM5, con memoria DDR5 r\\\\u00e1pida, almacenamiento ultrarr\\\\u00e1pido v\\\\u00eda M.2 y espacio para una tarjeta gr\\\\u00e1fica potente. Esto significa que tu computadora rendir\\\\u00e1 muy bien en juegos, edici\\\\u00f3n, multitarea intensiva o trabajo pesado, con buena estabilidad y compatibilidad a futuro.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764694140_692f187ce3202.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/E7PoEJHFuDM\\\"]\"','2025-12-02 16:49:00','2025-12-02 16:49:00'),(71,178,'<p>La&nbsp;MSI&nbsp;MPG&nbsp;B550&nbsp;GAMING&nbsp;PLUS&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;socket&nbsp;AM4&nbsp;y&nbsp;chipset&nbsp;B550&nbsp;que&nbsp;sirve&nbsp;como&nbsp;base&nbsp;sólida&nbsp;y&nbsp;versátil&nbsp;para&nbsp;un&nbsp;PC&nbsp;con&nbsp;procesador&nbsp;AMD&nbsp;Ryzen.&nbsp;Soporta&nbsp;hasta&nbsp;128&nbsp;GB&nbsp;de&nbsp;memoria&nbsp;RAM&nbsp;DDR4&nbsp;en&nbsp;cuatro&nbsp;ranuras&nbsp;DIMM,&nbsp;con&nbsp;posibilidades&nbsp;de&nbsp;overclock,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;buen&nbsp;equilibrio&nbsp;entre&nbsp;rendimiento&nbsp;y&nbsp;compatibilidad.&nbsp;Incluye&nbsp;ranuras&nbsp;modernas&nbsp;para&nbsp;almacenamiento&nbsp;como&nbsp;M.2&nbsp;(una&nbsp;PCIe&nbsp;Gen4&nbsp;x4&nbsp;+&nbsp;otra&nbsp;Gen3&nbsp;x4)&nbsp;y&nbsp;puertos&nbsp;SATA,&nbsp;ofreciendo&nbsp;velocidad&nbsp;y&nbsp;flexibilidad&nbsp;para&nbsp;SSDs&nbsp;o&nbsp;discos&nbsp;duros.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;alimentación&nbsp;y&nbsp;disipación&nbsp;asegura&nbsp;estabilidad&nbsp;incluso&nbsp;con&nbsp;CPUs&nbsp;potentes&nbsp;bajo&nbsp;carga&nbsp;constante,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;o&nbsp;tareas&nbsp;exigentes.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI MPG B550 GAMING PLUS ATX V1\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE MSI \\\",\\\"detalle\\\":\\\"MPG B550 GAMING PLUS ATX V1 Si tu PC monta esta placa, est\\\\u00e1s construyendo una m\\\\u00e1quina vers\\\\u00e1til: compatible con procesadores Ryzen modernos, capaz de manejar memoria RAM generosa, almacenamiento veloz y una GPU dedicada sin limitaciones. Tu sistema podr\\\\u00e1 rendir bien en juegos, edici\\\\u00f3n, multitarea, productividad o programaci\\\\u00f3n, con fluidez y estabilidad. Gracias a su soporte de SSDs M.2 y RAM r\\\\u00e1pida, los tiempos de carga, arranque de sistema o programas pesados ser\\\\u00e1n cortos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764695007_692f1bdf20bfb.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/06rU2hv2tYs\\\"]\"','2025-12-02 17:03:27','2025-12-02 17:03:27'),(72,179,'<p>La&nbsp;Z790&nbsp;AORUS&nbsp;ELITE&nbsp;AX&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;chipset&nbsp;Z790&nbsp;y&nbsp;socket&nbsp;LGA&nbsp;1700,&nbsp;pensada&nbsp;para&nbsp;aprovechar&nbsp;al&nbsp;máximo&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;12.ª,&nbsp;13.ª&nbsp;o&nbsp;incluso&nbsp;14.ª&nbsp;generación.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;alimentación&nbsp;(“VRM”)&nbsp;robusto&nbsp;permite&nbsp;entregar&nbsp;potencia&nbsp;estable&nbsp;incluso&nbsp;con&nbsp;CPUs&nbsp;potentes,&nbsp;garantizando&nbsp;estabilidad&nbsp;y&nbsp;buena&nbsp;respuesta&nbsp;bajo&nbsp;cargas&nbsp;intensas.&nbsp;Soporta&nbsp;memorias&nbsp;DDR5&nbsp;en&nbsp;configuración&nbsp;de&nbsp;4&nbsp;ranuras&nbsp;DIMM,&nbsp;con&nbsp;posibilidad&nbsp;de&nbsp;frecuencias&nbsp;altas,&nbsp;lo&nbsp;que&nbsp;da&nbsp;fluidez&nbsp;en&nbsp;multitarea,&nbsp;edición&nbsp;o&nbsp;gaming&nbsp;exigente.&nbsp;Ofrece&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe&nbsp;y&nbsp;soporte&nbsp;PCIe&nbsp;5.0/4.0,&nbsp;lo&nbsp;que&nbsp;asegura&nbsp;compatibilidad&nbsp;con&nbsp;hardware&nbsp;moderno&nbsp;—&nbsp;SSD&nbsp;rápidos,&nbsp;tarjetas&nbsp;gráficas&nbsp;de&nbsp;última&nbsp;generación&nbsp;y&nbsp;periféricos&nbsp;avanzados.&nbsp;Su&nbsp;conectividad&nbsp;también&nbsp;destaca:&nbsp;incluye&nbsp;red&nbsp;2.5&nbsp;GbE&nbsp;y&nbsp;Wi-Fi&nbsp;6E,&nbsp;USB-C&nbsp;/&nbsp;USB&nbsp;modernos&nbsp;y&nbsp;buen&nbsp;soporte&nbsp;de&nbsp;puertos,&nbsp;lo&nbsp;que&nbsp;da&nbsp;una&nbsp;plataforma&nbsp;versátil,&nbsp;actual&nbsp;y&nbsp;preparada&nbsp;para&nbsp;periféricos&nbsp;y&nbsp;redes&nbsp;modernas.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE Z790 AORUS ELITE AX\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE GIGABYTE \\\",\\\"detalle\\\":\\\"Z790 AORUS ELITE AX Si instalas esta placa en tu PC, tu equipo ser\\\\u00e1 una m\\\\u00e1quina moderna, poderosa y preparada para el presente y futuro: podr\\\\u00e1 usar procesadores Intel recientes, RAM DDR5 r\\\\u00e1pida, SSDs ultra-veloces y tarjetas gr\\\\u00e1ficas actuales sin cuellos de botella. Tu PC responder\\\\u00e1 con agilidad tanto en juegos exigentes como en edici\\\\u00f3n, render, multitarea o trabajo intensivo. La conectividad de red r\\\\u00e1pida y Wi-Fi 6E, junto a puertos modernos, te permitir\\\\u00e1n aprovechar internet, perif\\\\u00e9ricos o dispositivos externos sin limitaciones.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764695726_692f1eae57602.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/n0yeTvduYoo\\\"]\"','2025-12-02 17:15:26','2025-12-02 17:15:26'),(73,180,'<p>La&nbsp;MAG&nbsp;X870&nbsp;TOMAHAWK&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;de&nbsp;gama&nbsp;alta&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;modernos&nbsp;de&nbsp;AMD&nbsp;sobre&nbsp;socket&nbsp;AM5,&nbsp;pensada&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;sistema&nbsp;potente,&nbsp;actualizado&nbsp;y&nbsp;con&nbsp;tecnologías&nbsp;de&nbsp;última&nbsp;generación.&nbsp;Soporta&nbsp;memorias&nbsp;DDR5&nbsp;de&nbsp;muy&nbsp;alta&nbsp;velocidad,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;rendimiento&nbsp;fluido&nbsp;y&nbsp;ágil&nbsp;en&nbsp;juegos,&nbsp;edición,&nbsp;multitarea&nbsp;o&nbsp;trabajo&nbsp;pesado.&nbsp;Su&nbsp;chipset&nbsp;X870&nbsp;brinda&nbsp;compatibilidad&nbsp;con&nbsp;las&nbsp;últimas&nbsp;generaciones&nbsp;de&nbsp;CPUs&nbsp;Ryzen,&nbsp;garantizando&nbsp;longevidad&nbsp;de&nbsp;la&nbsp;plataforma.&nbsp;Integra&nbsp;conectividad&nbsp;moderna:&nbsp;red&nbsp;de&nbsp;5&nbsp;Gb,&nbsp;Wi-Fi&nbsp;7,&nbsp;puertos&nbsp;USB4&nbsp;de&nbsp;alta&nbsp;velocidad,&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;y&nbsp;soporte&nbsp;PCIe&nbsp;5.0,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;compatibilidad&nbsp;con&nbsp;SSD&nbsp;ultrarrápidos,&nbsp;tarjetas&nbsp;gráficas&nbsp;potentes&nbsp;y&nbsp;periféricos&nbsp;avanzados.</p>','\"[{\\\"nombre\\\":\\\"PLACA MSI MAG X870 TOMAHAWK WIFI ATX DDR5 AMD\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE MSI\\\",\\\"detalle\\\":\\\"Si montas tu PC con esta placa madre MSI MAG X870 TOMAHAWK WIFI ATX DDR5 AMD, tu sistema pasa a ser muy moderno, potente y vers\\\\u00e1til. Tendr\\\\u00e1s la libertad de usar CPUs AMD recientes, memorias DDR5 r\\\\u00e1pidas y almacenamiento ultrarr\\\\u00e1pido con SSDs M.2 sin cuellos de botella. Tu computadora podr\\\\u00e1 rendir muy bien en tareas exigentes, juegos actuales, edici\\\\u00f3n, renderizado, multitarea intensiva o producci\\\\u00f3n, siempre con buen desempe\\\\u00f1o.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764696508_692f21bc808dc.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/qZLb41KBuKg\\\"]\"','2025-12-02 17:28:28','2025-12-02 17:28:28'),(74,181,'<p>La&nbsp;MSI&nbsp;X870&nbsp;GAMING&nbsp;PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;socket&nbsp;AM5&nbsp;y&nbsp;chipset&nbsp;X870&nbsp;diseñada&nbsp;para&nbsp;aprovechar&nbsp;al&nbsp;máximo&nbsp;los&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;de&nbsp;las&nbsp;series&nbsp;más&nbsp;nuevas.&nbsp;Su&nbsp;soporte&nbsp;para&nbsp;memorias&nbsp;DDR5,&nbsp;hasta&nbsp;256&nbsp;GB,&nbsp;permite&nbsp;que&nbsp;tu&nbsp;sistema&nbsp;tenga&nbsp;alta&nbsp;capacidad&nbsp;y&nbsp;velocidad,&nbsp;ideal&nbsp;para&nbsp;tareas&nbsp;exigentes&nbsp;y&nbsp;multitarea&nbsp;intensiva.&nbsp;Incluye&nbsp;ranuras&nbsp;de&nbsp;expansión&nbsp;modernas&nbsp;como&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;y&nbsp;ranuras&nbsp;M.2&nbsp;(Gen5/Gen4)&nbsp;para&nbsp;almacenamiento&nbsp;ultrarrápido,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;compatibilidad&nbsp;con&nbsp;GPUs&nbsp;potentes&nbsp;y&nbsp;SSD&nbsp;NVMe&nbsp;de&nbsp;última&nbsp;generación.&nbsp;Su&nbsp;sistema&nbsp;de&nbsp;alimentación&nbsp;robusta&nbsp;y&nbsp;su&nbsp;calidad&nbsp;de&nbsp;componentes&nbsp;proporcionan&nbsp;estabilidad&nbsp;y&nbsp;rendimiento&nbsp;constante&nbsp;incluso&nbsp;bajo&nbsp;cargas&nbsp;pesadas.&nbsp;Además&nbsp;incorpora&nbsp;conectividad&nbsp;avanzada:&nbsp;redes&nbsp;rápidas&nbsp;(LAN&nbsp;5G&nbsp;+&nbsp;Wi-Fi&nbsp;7),&nbsp;puertos&nbsp;USB&nbsp;modernos&nbsp;y&nbsp;audio&nbsp;de&nbsp;alta&nbsp;definición,&nbsp;lo&nbsp;que&nbsp;la&nbsp;convierte&nbsp;en&nbsp;una&nbsp;base&nbsp;completa&nbsp;para&nbsp;una&nbsp;PC&nbsp;actual,&nbsp;versátil&nbsp;y&nbsp;preparada&nbsp;para&nbsp;hardware&nbsp;moderno.</p>','\"[{\\\"nombre\\\":\\\"PLACA MSI X870 GAMING PLUS WIFI ATX DDR5 AMD AM5\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE MSI\\\",\\\"detalle\\\":\\\"Con esta placa madre X870 GAMING PLUS WIFI ATX DDR5 AMD AM5, tu PC se transforma en una m\\\\u00e1quina moderna y bien preparada: puedes montar un procesador AMD Ryzen actual, usar memoria r\\\\u00e1pida DDR5, almacenamiento veloz con SSD M.2 y una tarjeta gr\\\\u00e1fica potente sin temor a cuellos de botella. Tu equipo tendr\\\\u00e1 un rendimiento fluido en juegos, edici\\\\u00f3n, multitarea o trabajos exigentes, con tiempos de carga reducidos, buena estabilidad y capacidad para manejar softwares pesados. Gracias a su conectividad avanzada, tu PC estar\\\\u00e1 lista para redes r\\\\u00e1pidas, perif\\\\u00e9ricos modernos o tareas intensivas en red. En pocas palabras, con esta placa tu sistema ser\\\\u00e1 r\\\\u00e1pido, estable, vers\\\\u00e1til y actualizado \\\\u2014 ideal tanto para gaming como para trabajo, edici\\\\u00f3n o uso profesional.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764697580_692f25ec74849.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/adja6fQpwK8\\\"]\"','2025-12-02 17:46:20','2025-12-02 17:46:20'),(75,182,'<p>La&nbsp;ROG&nbsp;STRIX&nbsp;X870-A&nbsp;Gaming&nbsp;WiFi&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;de&nbsp;gama&nbsp;alta&nbsp;diseñada&nbsp;para&nbsp;los&nbsp;procesadores&nbsp;modernos&nbsp;de&nbsp;AMD&nbsp;con&nbsp;socket&nbsp;AM5,&nbsp;pensada&nbsp;para&nbsp;construir&nbsp;PCs&nbsp;potentes,&nbsp;rápidas&nbsp;y&nbsp;listas&nbsp;para&nbsp;el&nbsp;futuro.&nbsp;Soporta&nbsp;memorias&nbsp;DDR5&nbsp;de&nbsp;gran&nbsp;velocidad,&nbsp;con&nbsp;posibilidad&nbsp;de&nbsp;overclock&nbsp;y&nbsp;capacidad&nbsp;para&nbsp;decenas&nbsp;de&nbsp;gigabytes&nbsp;de&nbsp;RAM,&nbsp;lo&nbsp;que&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;fluido&nbsp;en&nbsp;multitarea,&nbsp;edición&nbsp;y&nbsp;juegos&nbsp;exigentes.&nbsp;Cuenta&nbsp;con&nbsp;soporte&nbsp;PCIe&nbsp;5.0,&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;ultrarrápidos,&nbsp;lo&nbsp;que&nbsp;significa&nbsp;que&nbsp;almacenamiento&nbsp;y&nbsp;tarjetas&nbsp;gráficas&nbsp;modernas&nbsp;aprovechan&nbsp;al&nbsp;máximo&nbsp;su&nbsp;potencial.&nbsp;Integra&nbsp;conectividad&nbsp;avanzada:&nbsp;red&nbsp;por&nbsp;cable&nbsp;de&nbsp;alta&nbsp;velocidad,&nbsp;Wi-Fi&nbsp;de&nbsp;nueva&nbsp;generación,&nbsp;USB4&nbsp;/&nbsp;USB-C&nbsp;modernos&nbsp;y&nbsp;soporte&nbsp;para&nbsp;periféricos&nbsp;actuales,&nbsp;garantizando&nbsp;compatibilidad&nbsp;con&nbsp;las&nbsp;tecnologías&nbsp;más&nbsp;recientes.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS ROG STRIX X870-A GAMING WIFI AM5, ATX\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE ASUS \\\",\\\"detalle\\\":\\\"Si tu PC monta esta placa madre ROG STRIX X870-A GAMING WIFI AM5, ATX , tu equipo se convierte en una m\\\\u00e1quina preparada para alto rendimiento y longevidad: podr\\\\u00e1s usar procesadores AMD actuales o pr\\\\u00f3ximos, montar memorias r\\\\u00e1pidas DDR5, SSDs NVMe veloces y una tarjeta gr\\\\u00e1fica potente sin riesgo de \\\\u201ccuello de botella\\\\u201d. Tu sistema responder\\\\u00e1 con rapidez en arranques, cargas de programas, juegos y tareas exigentes. La conectividad moderna permite aprovechar redes r\\\\u00e1pidas, perif\\\\u00e9ricos actuales y accesorios nuevos sin limitaciones.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764698147_692f2823d5b8a.png\\\"]\"',NULL,'2025-12-02 17:55:47','2025-12-02 17:55:47'),(76,183,'<p>La&nbsp;B550&nbsp;GAMING&nbsp;X&nbsp;V2&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;socket&nbsp;AM4&nbsp;y&nbsp;chipset&nbsp;AMD&nbsp;B550&nbsp;pensada&nbsp;para&nbsp;armar&nbsp;PCs&nbsp;con&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;con&nbsp;equilibrio&nbsp;entre&nbsp;rendimiento,&nbsp;compatibilidad&nbsp;y&nbsp;costo.&nbsp;Su&nbsp;soporte&nbsp;para&nbsp;memorias&nbsp;DDR4&nbsp;en&nbsp;cuatro&nbsp;ranuras&nbsp;DIMM&nbsp;permite&nbsp;tener&nbsp;un&nbsp;sistema&nbsp;con&nbsp;buena&nbsp;capacidad&nbsp;de&nbsp;RAM&nbsp;(hasta&nbsp;128&nbsp;GB)&nbsp;trabajando&nbsp;en&nbsp;dual-channel,&nbsp;ideal&nbsp;para&nbsp;multitarea,&nbsp;juegos&nbsp;o&nbsp;software&nbsp;exigente.&nbsp;Ofrece&nbsp;ranuras&nbsp;modernas&nbsp;de&nbsp;expansión:&nbsp;PCIe&nbsp;4.0&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;y&nbsp;una&nbsp;ranura&nbsp;M.2&nbsp;PCIe&nbsp;4.0&nbsp;para&nbsp;SSD&nbsp;ultrarrápido,&nbsp;sumado&nbsp;a&nbsp;otra&nbsp;ranura&nbsp;M.2&nbsp;adicional,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;almacenamiento&nbsp;veloz&nbsp;y&nbsp;ampliaciones&nbsp;sin&nbsp;esfuerzo.</p>','\"[{\\\"nombre\\\":\\\"PLACA GIGABYTE B550 GAMING X V2 AMD RYZEN DDR4 AM4\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Si tu PC monta esta placa madre B550 GAMING X V2 AMD RYZEN DDR4 AM4, tu equipo adquiere una plataforma estable, compatible con procesadores AMD Ryzen recientes, con opciones de RAM amplia, almacenamiento r\\\\u00e1pido y posibilidad de GPU dedicada sin limitaciones.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764707213_692f4b8dd56d9.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/xm9i_m-MJ64\\\"]\"','2025-12-02 20:26:53','2025-12-02 20:26:53'),(77,184,'<p>La&nbsp;ASUS&nbsp;TUF&nbsp;Gaming&nbsp;Z890-PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;ATX&nbsp;con&nbsp;chipset&nbsp;Intel&nbsp;Z890&nbsp;y&nbsp;socket&nbsp;LGA&nbsp;1851,&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;Core&nbsp;Ultra&nbsp;(Serie&nbsp;2).&nbsp;Destaca&nbsp;por&nbsp;su&nbsp;soporte&nbsp;para&nbsp;RAM&nbsp;DDR5&nbsp;de&nbsp;alta&nbsp;velocidad&nbsp;(hasta&nbsp;9066+&nbsp;MT/s&nbsp;OC),&nbsp;conectividad&nbsp;Wi-Fi&nbsp;7&nbsp;y&nbsp;Ethernet&nbsp;de&nbsp;2.5&nbsp;Gb,&nbsp;una&nbsp;robusta&nbsp;solución&nbsp;de&nbsp;potencia&nbsp;para&nbsp;el&nbsp;VRM&nbsp;y&nbsp;una&nbsp;variedad&nbsp;de&nbsp;ranuras&nbsp;de&nbsp;almacenamiento&nbsp;M.2,&nbsp;incluyendo&nbsp;una&nbsp;con&nbsp;PCIe&nbsp;5.0.&nbsp;Ofrece&nbsp;una&nbsp;solución&nbsp;de&nbsp;audio&nbsp;de&nbsp;alta&nbsp;calidad&nbsp;con&nbsp;el&nbsp;códec&nbsp;Realtek&nbsp;ALC1220P&nbsp;y&nbsp;múltiples&nbsp;conectores&nbsp;para&nbsp;ventiladores&nbsp;y&nbsp;RGB.</p>','\"[{\\\"nombre\\\":\\\"PLACA ASUS TUF Z890 GAMING PLUS WI-FI 7 DDR5 LGA 1851\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS \\\",\\\"detalle\\\":\\\" Z890 GAMING PLUS WI-FI 7 DDR5 LGA 1851 placa base ATX con chipset Intel Z890 y socket LGA 1851, dise\\\\u00f1ada para procesadores Intel Core\\\\u2122 Ultra (Serie 2), soporta memoria DDR5 de hasta 192 GB (con OC de hasta 9066+MT\\\\\\/s) y ofrece conectividad de vanguardia como Wi-Fi 7. Su dise\\\\u00f1o incluye una robusta soluci\\\\u00f3n de alimentaci\\\\u00f3n, un sistema de refrigeraci\\\\u00f3n optimizado y ranuras M.2, incluyendo una PCIe 5.0, ideal para una PC de alto rendimiento enfocada en juegos y aplicaciones de IA.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764707888_692f4e30b7b2a.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/42viKtF_r6s\\\"]\"','2025-12-02 20:38:08','2025-12-02 20:38:08'),(78,185,'<p>La&nbsp;placa&nbsp;madre&nbsp;ASUS&nbsp;TUF&nbsp;GAMING&nbsp;A620M-PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;micro-ATX&nbsp;para&nbsp;socket&nbsp;AM5&nbsp;diseñada&nbsp;para&nbsp;aprovechar&nbsp;procesadores&nbsp;recientes&nbsp;de&nbsp;AMD&nbsp;Ryzen,&nbsp;combinando&nbsp;compatibilidad&nbsp;moderna,&nbsp;memoria&nbsp;DDR5&nbsp;veloz&nbsp;y&nbsp;conectividad&nbsp;robusta&nbsp;en&nbsp;un&nbsp;formato&nbsp;compacto.&nbsp;Está&nbsp;equipada&nbsp;con&nbsp;chipset&nbsp;A620,&nbsp;lo&nbsp;que&nbsp;la&nbsp;posiciona&nbsp;como&nbsp;una&nbsp;opción&nbsp;accesible&nbsp;pero&nbsp;suficientemente&nbsp;completa:&nbsp;permite&nbsp;DDR5,&nbsp;ranuras&nbsp;PCIe&nbsp;4.0,&nbsp;doble&nbsp;slot&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;rápidos,&nbsp;soporte&nbsp;para&nbsp;hasta&nbsp;192&nbsp;GB&nbsp;de&nbsp;RAM,&nbsp;red&nbsp;2.5&nbsp;Gb,&nbsp;Wi-Fi&nbsp;6&nbsp;y&nbsp;salidas&nbsp;de&nbsp;video&nbsp;si&nbsp;se&nbsp;usa&nbsp;CPU&nbsp;con&nbsp;gráficos&nbsp;integrados.&nbsp;Su&nbsp;diseño&nbsp;incorpora&nbsp;componentes&nbsp;duraderos&nbsp;(“grado&nbsp;militar”&nbsp;TUF),&nbsp;solución&nbsp;de&nbsp;alimentación&nbsp;estable&nbsp;y&nbsp;buen&nbsp;sistema&nbsp;de&nbsp;refrigeración,&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;confiabilidad&nbsp;incluso&nbsp;en&nbsp;uso&nbsp;prolongado&nbsp;o&nbsp;exigente.&nbsp;En&nbsp;suma,&nbsp;ofrece&nbsp;un&nbsp;balance&nbsp;entre&nbsp;funcionalidad,&nbsp;compatibilidad&nbsp;y&nbsp;precio,&nbsp;ideal&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;moderna&nbsp;con&nbsp;buena&nbsp;relación&nbsp;costo-beneficio.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA ASUS TUF GAMING A620M-PLUS WIFI M.ATX DDR5\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"GAMING A620M-PLUS WIFI M.ATX DDR5 Si usas esta placa en tu PC, tu sistema se transforma en una m\\\\u00e1quina equilibrada, moderna y vers\\\\u00e1til: tendr\\\\u00e1s la base para aprovechar CPUs Ryzen recientes, memorias r\\\\u00e1pidas, SSD NVMe veloces y una GPU dedicada si lo deseas, sin cuellos de botella importantes. Tu equipo responder\\\\u00e1 con agilidad tanto en tareas cotidianas como en gaming, edici\\\\u00f3n, multitarea o trabajos exigentes. Gracias al soporte DDR5, almacenamiento moderno y conectividad con Wi-Fi + LAN r\\\\u00e1pido, la experiencia ser\\\\u00e1 fluida y actual, con posibilidad de actualizar componentes m\\\\u00e1s adelante sin necesidad de cambiar la placa madre.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764708220_692f4f7ca2688.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/ERzR2jh-Qr8\\\"]\"','2025-12-02 20:43:40','2025-12-02 20:43:40'),(79,186,'<p>La&nbsp;Z790&nbsp;EAGLE&nbsp;AX&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;que&nbsp;actúa&nbsp;como&nbsp;base&nbsp;moderna&nbsp;y&nbsp;potente&nbsp;para&nbsp;PCs&nbsp;con&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;12ª,&nbsp;13ª&nbsp;o&nbsp;14ª&nbsp;generación.&nbsp;Su&nbsp;compatibilidad&nbsp;con&nbsp;memoria&nbsp;DDR5&nbsp;permite&nbsp;usar&nbsp;RAM&nbsp;rápida&nbsp;y&nbsp;abundante,&nbsp;mejorando&nbsp;notablemente&nbsp;la&nbsp;fluidez&nbsp;en&nbsp;juegos,&nbsp;edición&nbsp;y&nbsp;multitarea.&nbsp;Con&nbsp;PCIe&nbsp;5.0&nbsp;+&nbsp;ranura&nbsp;reforzada&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;y&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe,&nbsp;garantiza&nbsp;que&nbsp;gráficos,&nbsp;almacenamiento&nbsp;y&nbsp;componentes&nbsp;modernos&nbsp;funcionen&nbsp;al&nbsp;máximo&nbsp;rendimiento.&nbsp;Integra&nbsp;conectividad&nbsp;actualizada:&nbsp;red&nbsp;por&nbsp;cable&nbsp;rápida&nbsp;(2.5&nbsp;GbE),&nbsp;Wi-Fi&nbsp;6E&nbsp;+&nbsp;Bluetooth,&nbsp;USB-C&nbsp;10Gb/s&nbsp;y&nbsp;salidas&nbsp;de&nbsp;video/puertos&nbsp;traseros&nbsp;modernos,&nbsp;lo&nbsp;que&nbsp;la&nbsp;convierte&nbsp;en&nbsp;una&nbsp;plataforma&nbsp;versátil&nbsp;y&nbsp;preparada&nbsp;para&nbsp;periféricos&nbsp;actuales.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;alimentación&nbsp;(VRM&nbsp;robusto)&nbsp;y&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;aseguran&nbsp;estabilidad&nbsp;sostenida&nbsp;incluso&nbsp;con&nbsp;CPUs&nbsp;exigentes&nbsp;o&nbsp;bajo&nbsp;carga&nbsp;intensiva.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE Z790 EAGLE AX WIFI LGA1700 D5 AST\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Si tu PC monta la Z790 EAGLE AX WIFI, tu equipo ser\\\\u00e1 poderoso, r\\\\u00e1pido y preparado para tareas exigentes: podr\\\\u00e1 manejar desde juegos AAA con tarjetas gr\\\\u00e1ficas recientes, hasta edici\\\\u00f3n de video, dise\\\\u00f1o, multitarea pesada o trabajo profesional sin limitaciones. El soporte DDR5, SSD NVMe y PCIe 5.0 reduce dr\\\\u00e1sticamente tiempos de carga, mejora la respuesta del sistema y permite aprovechar al m\\\\u00e1ximo el hardware moderno. La conectividad avanzada te ofrece comunicaci\\\\u00f3n r\\\\u00e1pida, estable y compatible con redes actuales e inal\\\\u00e1mbricas, ideal para gaming online o trabajo remoto. Adem\\\\u00e1s, la placa ofrece flexibilidad para actualizaciones futuras \\\\u2014 CPU, RAM, GPU, almacenamiento \\\\u2014 sin necesidad de cambiar la base, haciendo tu PC duradera y vers\\\\u00e1til.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764708800_692f51c02ebe5.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/fMbbr9VldSM\\\"]\"','2025-12-02 20:53:20','2025-12-02 20:53:20'),(80,187,'<p>La&nbsp;ASRock&nbsp;B850&nbsp;Steel&nbsp;Legend&nbsp;WiFi&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;moderna&nbsp;para&nbsp;CPUs&nbsp;AMD&nbsp;con&nbsp;socket&nbsp;AM5,&nbsp;diseñada&nbsp;con&nbsp;potencia&nbsp;y&nbsp;versatilidad&nbsp;para&nbsp;sistemas&nbsp;actuales.&nbsp;Admite&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;hasta&nbsp;cuatro&nbsp;módulos&nbsp;DIMM,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;tener&nbsp;RAM&nbsp;de&nbsp;alta&nbsp;velocidad&nbsp;y&nbsp;gran&nbsp;capacidad,&nbsp;ideal&nbsp;para&nbsp;multitarea,&nbsp;edición,&nbsp;juegos&nbsp;o&nbsp;trabajos&nbsp;exigentes.&nbsp;Tiene&nbsp;ranura&nbsp;PCIe&nbsp;5.0&nbsp;x16&nbsp;para&nbsp;tarjetas&nbsp;gráficas&nbsp;potentes&nbsp;y&nbsp;varias&nbsp;ranuras&nbsp;M.2&nbsp;(una&nbsp;compatible&nbsp;con&nbsp;PCIe&nbsp;5.0&nbsp;y&nbsp;otras&nbsp;con&nbsp;PCIe&nbsp;4.0)&nbsp;para&nbsp;SSD&nbsp;ultrarrápidos,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;que&nbsp;almacenamiento&nbsp;y&nbsp;GPU&nbsp;funcionen&nbsp;sin&nbsp;limitaciones&nbsp;de&nbsp;ancho&nbsp;de&nbsp;banda.&nbsp;Cuenta&nbsp;con&nbsp;conectividad&nbsp;moderna:&nbsp;red&nbsp;cableada&nbsp;2.5&nbsp;Gb,&nbsp;Wi-Fi&nbsp;7&nbsp;integrado&nbsp;y&nbsp;puertos&nbsp;USB&nbsp;rápidos&nbsp;(incluyendo&nbsp;USB-C),&nbsp;ofreciendo&nbsp;compatibilidad&nbsp;con&nbsp;redes,&nbsp;periféricos&nbsp;y&nbsp;dispositivos&nbsp;nuevos.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;alimentación&nbsp;con&nbsp;fases&nbsp;robustas&nbsp;(Dr.MOS)&nbsp;y&nbsp;disipación&nbsp;eficaz&nbsp;asegura&nbsp;estabilidad&nbsp;del&nbsp;sistema&nbsp;incluso&nbsp;con&nbsp;CPUs&nbsp;exigentes&nbsp;o&nbsp;bajo&nbsp;carga&nbsp;intensa&nbsp;—&nbsp;ideal&nbsp;para&nbsp;uso&nbsp;prolongado,&nbsp;gaming&nbsp;o&nbsp;tareas&nbsp;pesadas.</p>','\"[{\\\"nombre\\\":\\\"PLACA ASROCK B850 STEEL LEGEND WIFI ATX DDR5 AMD\\\",\\\"valor\\\":\\\"ASROCK\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASROCK\\\",\\\"detalle\\\":\\\"Si eliges esta placa madre B850 STEEL LEGEND WIFI ATX DDR5 AMD  para tu PC, tu sistema se convierte en una plataforma moderna, potente y flexible: puedes montar un procesador AMD reciente, usar DDR5 veloz, aprovechar SSD NVMe r\\\\u00e1pidos y una tarjeta gr\\\\u00e1fica actual sin que la placa sea un l\\\\u00edmite. Tu equipo tendr\\\\u00e1 tiempos de carga bajos, gran respuesta en uso intensivo o multitarea, y estabilidad incluso en trabajos largos o exigentes. La conectividad integrada (Wi-Fi, LAN r\\\\u00e1pida, USB-C) te permite conectar perif\\\\u00e9ricos modernos, acceder a internet de alta velocidad y usar dispositivos recientes sin problemas. Adem\\\\u00e1s, la estructura de la placa permite que en el futuro puedas actualizar componentes (RAM, GPU, SSD, CPU) manteniendo la misma base.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764709399_692f5417a46ed.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/6rDDY8bCGV0\\\"]\"','2025-12-02 21:03:19','2025-12-02 21:03:19'),(81,188,'<p>La&nbsp;B760M&nbsp;PG&nbsp;SONIC&nbsp;WiFi&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;pensada&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;moderna&nbsp;con&nbsp;procesadores&nbsp;Intel&nbsp;recientes&nbsp;(socket&nbsp;LGA&nbsp;1700).&nbsp;Acepta&nbsp;memorias&nbsp;DDR5&nbsp;rápidas,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;que&nbsp;el&nbsp;sistema&nbsp;sea&nbsp;ágil&nbsp;y&nbsp;fluido&nbsp;en&nbsp;tareas&nbsp;cotidianas,&nbsp;juegos&nbsp;o&nbsp;trabajo&nbsp;pesado.&nbsp;Integra&nbsp;ranura&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;tarjeta&nbsp;gráfica,&nbsp;puerto&nbsp;M.2&nbsp;y&nbsp;SATA&nbsp;para&nbsp;discos&nbsp;SSD&nbsp;o&nbsp;HDD,&nbsp;dando&nbsp;compatibilidad&nbsp;con&nbsp;hardware&nbsp;actual&nbsp;y&nbsp;velocidad&nbsp;de&nbsp;almacenamiento.&nbsp;Su&nbsp;sistema&nbsp;de&nbsp;alimentación&nbsp;con&nbsp;fases&nbsp;Dr.MOS&nbsp;garantiza&nbsp;estabilidad&nbsp;energética&nbsp;al&nbsp;procesador,&nbsp;incluso&nbsp;con&nbsp;CPUs&nbsp;potentes,&nbsp;lo&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;un&nbsp;buen&nbsp;rendimiento&nbsp;bajo&nbsp;carga.&nbsp;Ofrece&nbsp;conectividad&nbsp;moderna:&nbsp;red&nbsp;cableada&nbsp;rápida&nbsp;2.5&nbsp;Gb,&nbsp;Wi-Fi&nbsp;6E,&nbsp;múltiples&nbsp;puertos&nbsp;USB&nbsp;(incluyendo&nbsp;USB-C),&nbsp;salidas&nbsp;gráficas&nbsp;digitales&nbsp;(HDMI&nbsp;/&nbsp;DisplayPort)&nbsp;—&nbsp;lo&nbsp;que&nbsp;asegura&nbsp;compatibilidad&nbsp;con&nbsp;periféricos,&nbsp;redes&nbsp;e&nbsp;internet&nbsp;actual.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA ASROCK B760M PG SONIC WIFI M-ATX DDR5 LGA 1700\\\",\\\"valor\\\":\\\"ASROCK\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASROCK\\\",\\\"detalle\\\":\\\"Si usas esta placa B760M PG SONIC WIFI M-ATX DDR5 LGA 1700 en tu PC, obtendr\\\\u00e1s una base moderna, vers\\\\u00e1til y eficaz: tu sistema podr\\\\u00e1 usar un procesador Intel nuevo, memoria DDR5 veloz, almacenamiento r\\\\u00e1pido y una tarjeta de video dedicada sin cuellos de botella. Tu PC responder\\\\u00e1 con agilidad, ya sea en tareas cotidianas, multitarea, juegos, edici\\\\u00f3n o trabajo exigente \\\\u2014 ofreciendo un equilibrio entre potencia, velocidad y estabilidad. La conectividad integrada te permite usar Wi-Fi, red de alta velocidad, perif\\\\u00e9ricos actuales o unidades externas sin inconvenientes.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764709736_692f556854c4d.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/FWaJPsK1bQs\\\"]\"','2025-12-02 21:08:56','2025-12-02 21:08:56'),(82,189,'<p>La&nbsp;B850&nbsp;AORUS&nbsp;ELITE&nbsp;WiFi7&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;ATX&nbsp;de&nbsp;nueva&nbsp;generación&nbsp;con&nbsp;chipset&nbsp;B850&nbsp;y&nbsp;socket&nbsp;AM5&nbsp;que&nbsp;combina&nbsp;compatibilidad&nbsp;con&nbsp;los&nbsp;Ryzen&nbsp;más&nbsp;recientes,&nbsp;soporte&nbsp;para&nbsp;memorias&nbsp;DDR5&nbsp;veloces,&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;(incluyendo&nbsp;PCIe&nbsp;5.0)&nbsp;para&nbsp;almacenamiento&nbsp;ultrarrápido,&nbsp;y&nbsp;una&nbsp;robusta&nbsp;regulación&nbsp;de&nbsp;energía&nbsp;con&nbsp;VRM&nbsp;digital&nbsp;14+2+2&nbsp;—&nbsp;ideal&nbsp;para&nbsp;CPUs&nbsp;modernos.&nbsp;Incluye&nbsp;conectividad&nbsp;avanzada&nbsp;con&nbsp;WiFi&nbsp;7,&nbsp;LAN&nbsp;2.5&nbsp;Gb,&nbsp;salidas&nbsp;de&nbsp;video,&nbsp;puertos&nbsp;USB-C,&nbsp;USB&nbsp;3.x,&nbsp;HDMI/DisplayPort,&nbsp;lo&nbsp;que&nbsp;la&nbsp;convierte&nbsp;en&nbsp;una&nbsp;base&nbsp;muy&nbsp;completa.&nbsp;Su&nbsp;diseño&nbsp;está&nbsp;orientado&nbsp;a&nbsp;estabilidad,&nbsp;versatilidad&nbsp;y&nbsp;preparación&nbsp;para&nbsp;hardware&nbsp;de&nbsp;vanguardia,&nbsp;lo&nbsp;que&nbsp;la&nbsp;hace&nbsp;adecuada&nbsp;tanto&nbsp;para&nbsp;gaming,&nbsp;edición,&nbsp;creación&nbsp;de&nbsp;contenido,&nbsp;multitarea&nbsp;intensiva&nbsp;o&nbsp;PC&nbsp;de&nbsp;alto&nbsp;desempeño.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE B850 AORUS ELITE WIFI7 AM5 AST\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Tu PC con esta placa B850 AORUS ELITE WIFI7 AM5 AST se transforma en una m\\\\u00e1quina moderna, vers\\\\u00e1til y preparada para lo que venga. Gracias a su socket AM5 puedes usar procesadores recientes de AMD Ryzen (series 7000\\\\\\/8000\\\\\\/9000), lo que asegura compatibilidad con CPUs potentes. La memoria DDR5 soportada hasta 8200 MT\\\\\\/s le da a tu sistema agilidad en multitarea, edici\\\\u00f3n, juegos o productividad, con tiempos de respuesta r\\\\u00e1pidos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764710152_692f5708eee8f.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/gdFfNO5hSuw\\\"]\"','2025-12-02 21:15:52','2025-12-02 21:15:52'),(83,190,'<p>La&nbsp;H810M-K&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1851&nbsp;/&nbsp;chipset&nbsp;H810,&nbsp;pensada&nbsp;para&nbsp;sistemas&nbsp;modernos&nbsp;con&nbsp;procesadores&nbsp;Intel&nbsp;actuales.&nbsp;Soporta&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;configuración&nbsp;de&nbsp;doble&nbsp;canal&nbsp;mediante&nbsp;sus&nbsp;dos&nbsp;ranuras&nbsp;DIMM,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;tener&nbsp;RAM&nbsp;rápida&nbsp;y&nbsp;fluida&nbsp;para&nbsp;tareas&nbsp;comunes,&nbsp;productividad,&nbsp;ofimática&nbsp;o&nbsp;incluso&nbsp;gaming&nbsp;moderado.&nbsp;Dispone&nbsp;de&nbsp;ranura&nbsp;PCIe&nbsp;4.0&nbsp;x16&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;y&nbsp;ranura&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;combinar&nbsp;almacenamiento&nbsp;veloz&nbsp;con&nbsp;GPU&nbsp;potente&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.&nbsp;Trae&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(HDMI&nbsp;y&nbsp;DisplayPort),&nbsp;lo&nbsp;que&nbsp;facilita&nbsp;usarla&nbsp;con&nbsp;CPUs&nbsp;que&nbsp;tengan&nbsp;gráficos&nbsp;integrados.&nbsp;También&nbsp;ofrece&nbsp;conectividad&nbsp;básica&nbsp;y&nbsp;suficiente&nbsp;para&nbsp;un&nbsp;PC&nbsp;de&nbsp;escritorio:&nbsp;puertos&nbsp;USB,&nbsp;audio&nbsp;HD,&nbsp;red&nbsp;Gigabit&nbsp;LAN,&nbsp;soporte&nbsp;para&nbsp;ventiladores&nbsp;con&nbsp;control,&nbsp;almacenamiento&nbsp;SATA&nbsp;adicional&nbsp;—&nbsp;dando&nbsp;una&nbsp;base&nbsp;funcional,&nbsp;moderna&nbsp;y&nbsp;eficiente.&nbsp;Su&nbsp;diseño&nbsp;combina&nbsp;simplicidad&nbsp;con&nbsp;lo&nbsp;esencial:&nbsp;permite&nbsp;montar&nbsp;una&nbsp;PC&nbsp;confiable,&nbsp;actual&nbsp;y&nbsp;eficiente,&nbsp;sin&nbsp;extra&nbsp;de&nbsp;gama&nbsp;alta,&nbsp;ideal&nbsp;para&nbsp;un&nbsp;equipo&nbsp;de&nbsp;uso&nbsp;cotidiano,&nbsp;trabajo,&nbsp;estudio&nbsp;o&nbsp;como&nbsp;base&nbsp;económica&nbsp;con&nbsp;buen&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE H810M-K DDR5\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE \\\",\\\"detalle\\\":\\\"Si tu PC usa la H810M-K, est\\\\u00e1s armando un sistema funcional y equilibrado: podr\\\\u00e1s usar un procesador Intel compatible con LGA 1851, aprovechar memoria DDR5 r\\\\u00e1pida, instalar un SSD NVMe, y si agregas GPU dedicada, tendr\\\\u00e1s soporte para gr\\\\u00e1ficos potentes. Tu PC tendr\\\\u00e1 un rendimiento estable y suficiente para tareas diarias, oficina, navegaci\\\\u00f3n, edici\\\\u00f3n ligera, multimedia, e incluso juegos si agregas una buena tarjeta gr\\\\u00e1fica. La placa no es de gama entusiasta, pero ofrece lo necesario para una PC confiable, eficiente y actual \\\\u2014 ideal si buscas calidad-precio y no necesitas lo m\\\\u00e1s avanzado.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764710507_692f586b27f02.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/h9FkoCbZd6A\\\"]\"','2025-12-02 21:21:47','2025-12-02 21:21:47'),(84,191,'<p>La&nbsp;H810M&nbsp;GAMING&nbsp;WiFi6&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1851,&nbsp;pensada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;recientes,&nbsp;ofreciendo&nbsp;soporte&nbsp;para&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;dual-channel,&nbsp;con&nbsp;hasta&nbsp;128&nbsp;GB,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;sistema&nbsp;ágil,&nbsp;moderno&nbsp;y&nbsp;con&nbsp;buena&nbsp;capacidad&nbsp;para&nbsp;multitarea,&nbsp;edición&nbsp;ligera&nbsp;o&nbsp;uso&nbsp;cotidiano.&nbsp;Integra&nbsp;conectividad&nbsp;actual:&nbsp;red&nbsp;2.5&nbsp;GbE,&nbsp;WiFi&nbsp;6,&nbsp;Bluetooth,&nbsp;salidas&nbsp;HDMI/DisplayPort&nbsp;(útiles&nbsp;si&nbsp;el&nbsp;CPU&nbsp;tiene&nbsp;gráficos&nbsp;integrados),&nbsp;lo&nbsp;que&nbsp;facilita&nbsp;una&nbsp;PC&nbsp;funcional&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;componentes&nbsp;extra&nbsp;caros.&nbsp;Incluye&nbsp;ranura&nbsp;PCIe&nbsp;x16&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;y&nbsp;ranura&nbsp;M.2&nbsp;+&nbsp;puertos&nbsp;SATA&nbsp;para&nbsp;almacenamiento&nbsp;SSD&nbsp;o&nbsp;HDD,&nbsp;lo&nbsp;que&nbsp;da&nbsp;flexibilidad&nbsp;para&nbsp;escoger&nbsp;entre&nbsp;velocidad&nbsp;o&nbsp;capacidad&nbsp;según&nbsp;tu&nbsp;presupuesto&nbsp;o&nbsp;necesidades.&nbsp;Su&nbsp;formato&nbsp;micro-ATX&nbsp;la&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;compactas&nbsp;o&nbsp;moderadas,&nbsp;equilibrando&nbsp;funcionalidad,&nbsp;costo&nbsp;y&nbsp;compatibilidad.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE H810M GAMING WIFI6 DDR5\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Si tu PC usa la H810M GAMING WiFi6, tu sistema ser\\\\u00e1 una plataforma equilibrada, suficiente para tareas comunes como ofim\\\\u00e1tica, estudio, navegaci\\\\u00f3n, edici\\\\u00f3n ligera, multimedia, incluso gaming moderado \\\\u2014 siempre que le pongas una GPU dedicada si planeas jugar juegos exigentes o trabajar con gr\\\\u00e1ficos. Tu equipo tendr\\\\u00e1 buena compatibilidad con hardware actual, podr\\\\u00e1 usar memoria y almacenamiento modernos, y tendr\\\\u00e1 conectividad completa (internet r\\\\u00e1pido, WiFi, Bluetooth, puertos actuales). Ser\\\\u00e1 una PC funcional, pr\\\\u00e1ctica, moderna y accesible, ideal para quien busca performance decente sin gastar tanto, o para un equipo secundario\\\\\\/vers\\\\u00e1til.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764711024_692f5a7059376.png\\\"]\"',NULL,'2025-12-02 21:30:24','2025-12-02 21:30:24'),(85,192,'<p>La&nbsp;B850&nbsp;EAGLE&nbsp;WIFI7&nbsp;ICE&nbsp;es&nbsp;una&nbsp;placa&nbsp;base&nbsp;ATX&nbsp;moderna&nbsp;pensada&nbsp;para&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;con&nbsp;socket&nbsp;AM5,&nbsp;diseñada&nbsp;para&nbsp;darle&nbsp;a&nbsp;tu&nbsp;PC&nbsp;una&nbsp;base&nbsp;potente,&nbsp;veloz&nbsp;y&nbsp;preparada&nbsp;para&nbsp;hardware&nbsp;de&nbsp;nueva&nbsp;generación.&nbsp;Su&nbsp;soporte&nbsp;de&nbsp;memorias&nbsp;DDR5&nbsp;en&nbsp;cuatro&nbsp;ranuras&nbsp;DIMM&nbsp;permite&nbsp;tener&nbsp;RAM&nbsp;rápida&nbsp;(hasta&nbsp;8200&nbsp;MHz&nbsp;en&nbsp;OC)&nbsp;y&nbsp;gran&nbsp;capacidad&nbsp;—&nbsp;lo&nbsp;que&nbsp;da&nbsp;agilidad&nbsp;en&nbsp;multitarea,&nbsp;edición,&nbsp;juegos&nbsp;o&nbsp;uso&nbsp;intensivo.&nbsp;La&nbsp;placa&nbsp;trae&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;(incluyendo&nbsp;una&nbsp;compatible&nbsp;con&nbsp;PCIe&nbsp;5.0)&nbsp;y&nbsp;ranuras&nbsp;PCIe&nbsp;actualizadas,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;usar&nbsp;SSD&nbsp;ultrarrápidos&nbsp;y&nbsp;tarjetas&nbsp;gráficas&nbsp;potentes&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;alimentación&nbsp;con&nbsp;VRM&nbsp;digital&nbsp;8+2+2&nbsp;y&nbsp;sistema&nbsp;de&nbsp;disipación&nbsp;robusto&nbsp;garantiza&nbsp;estabilidad&nbsp;aún&nbsp;con&nbsp;CPUs&nbsp;exigentes,&nbsp;cargas&nbsp;largas&nbsp;o&nbsp;componentes&nbsp;potentes.&nbsp;Además&nbsp;incluye&nbsp;conectividad&nbsp;moderna:&nbsp;red&nbsp;2.5&nbsp;Gb,&nbsp;Wi-Fi&nbsp;7,&nbsp;salidas&nbsp;HDMI/DisplayPort,&nbsp;USB-C&nbsp;/&nbsp;USB&nbsp;modernos&nbsp;—&nbsp;lo&nbsp;que&nbsp;la&nbsp;hace&nbsp;compatible&nbsp;con&nbsp;periféricos&nbsp;actuales,&nbsp;conexión&nbsp;veloz&nbsp;a&nbsp;internet&nbsp;y&nbsp;dispositivos&nbsp;nuevos.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE B850 EAGLE ICE WIFI7 AM5 AST\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Si tu PC emplea esta placa madre B850 EAGLE ICE WIFI7 AM5 AST, entonces tendr\\\\u00e1s una m\\\\u00e1quina preparada para lo actual y lo que venga: podr\\\\u00e1s usar un procesador AMD moderno, memoria DDR5 r\\\\u00e1pida, SSD NVMe ultra-r\\\\u00e1pidos y una tarjeta gr\\\\u00e1fica potente, logrando un rendimiento fluido en juegos, edici\\\\u00f3n, dise\\\\u00f1o, multitarea o trabajo intensivo. Tu equipo responder\\\\u00e1 r\\\\u00e1pido en arranques, cargas, procesos m\\\\u00faltiples o tareas pesadas, con estabilidad gracias al buen sistema de energ\\\\u00eda y refrigeraci\\\\u00f3n. La conectividad con Wi-Fi 7 y red 2.5 Gb asegura internet veloz y estable para gaming o trabajo online, mientras los puertos modernos y salidas de video facilitan conectar perif\\\\u00e9ricos, monitores nuevos o dispositivos externos sin problemas. Adem\\\\u00e1s, la placa brinda espacio para futuras actualizaciones \\\\u2014 m\\\\u00e1s RAM, mejor GPU, m\\\\u00e1s almacenamiento \\\\u2014 sin necesidad de cambiar la base.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764711597_692f5cad321e7.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/9Gssdiuhtg0\\\"]\"','2025-12-02 21:39:57','2025-12-02 21:39:57'),(86,193,'<p>La&nbsp;MSI&nbsp;PRO&nbsp;B840M-B&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;con&nbsp;socket&nbsp;AM5&nbsp;que&nbsp;sirve&nbsp;como&nbsp;base&nbsp;moderada&nbsp;para&nbsp;construir&nbsp;un&nbsp;PC&nbsp;con&nbsp;procesador&nbsp;AMD&nbsp;reciente&nbsp;(series&nbsp;Ryzen&nbsp;7000&nbsp;/&nbsp;8000&nbsp;/&nbsp;9000).&nbsp;Está&nbsp;diseñada&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;buen&nbsp;equilibrio&nbsp;entre&nbsp;prestaciones&nbsp;y&nbsp;precio:&nbsp;permite&nbsp;usar&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;dual-channel&nbsp;con&nbsp;soporte&nbsp;hasta&nbsp;~8000&nbsp;MHz&nbsp;(OC),&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;al&nbsp;sistema&nbsp;agilidad,&nbsp;buen&nbsp;desempeño&nbsp;en&nbsp;multitarea,&nbsp;juegos&nbsp;o&nbsp;trabajo&nbsp;cotidiano.&nbsp;Posee&nbsp;ranura&nbsp;PCIe&nbsp;4.0&nbsp;x16&nbsp;para&nbsp;tarjeta&nbsp;gráfica,&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe&nbsp;rápidos&nbsp;y&nbsp;puertos&nbsp;SATA&nbsp;para&nbsp;almacenamiento&nbsp;tradicional,&nbsp;combinando&nbsp;velocidad&nbsp;y&nbsp;flexibilidad.&nbsp;Su&nbsp;red&nbsp;integrada&nbsp;de&nbsp;2.5&nbsp;Gb&nbsp;y&nbsp;soporte&nbsp;para&nbsp;audio&nbsp;de&nbsp;alta&nbsp;definición&nbsp;la&nbsp;hacen&nbsp;adecuada&nbsp;tanto&nbsp;para&nbsp;gaming&nbsp;como&nbsp;para&nbsp;trabajo,&nbsp;streaming&nbsp;o&nbsp;tareas&nbsp;multimedia.&nbsp;Su&nbsp;formato&nbsp;compacto&nbsp;y&nbsp;funciones&nbsp;esenciales&nbsp;la&nbsp;convierten&nbsp;en&nbsp;una&nbsp;opción&nbsp;práctica&nbsp;para&nbsp;quienes&nbsp;buscan&nbsp;montar&nbsp;una&nbsp;PC&nbsp;actual,&nbsp;equilibrada&nbsp;y&nbsp;funcional&nbsp;sin&nbsp;gastar&nbsp;demasiado&nbsp;en&nbsp;una&nbsp;placa&nbsp;“gama&nbsp;alta”.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI PRO B840M-B S\\\\\\/V\\\\\\/L DDR5\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MSI\\\",\\\"detalle\\\":\\\"Si tu PC usa esta placa PRO B840M-B S\\\\\\/V\\\\\\/L DDR5, tendr\\\\u00e1s una plataforma s\\\\u00f3lida y moderna: podr\\\\u00e1s instalar un CPU AMD AM5, tener memoria DDR5 r\\\\u00e1pida, SSD NVMe veloz y una tarjeta gr\\\\u00e1fica dedicada sin limitaciones graves. Tu sistema ser\\\\u00e1 vers\\\\u00e1til, capaz de rendir bien en tareas desde navegaci\\\\u00f3n, ofim\\\\u00e1tica, edici\\\\u00f3n ligera, hasta gaming moderado o uso multimedia. Es ideal para un PC equilibrado, con buen costo-beneficio, suficiente para usuarios que buscan funcionalidad y estabilidad sin necesidad de hardware \\\\u201ctop-gama\\\\u201d. Tambi\\\\u00e9n te ofrece flexibilidad para actualizar RAM, almacenamiento o GPU cuando quieras, sin tener que cambiar la placa madre \\\\u2014 lo que le da a tu PC un buen margen de vida \\\\u00fatil.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764712173_692f5eedb160d.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/hyCflk0JXcI\\\"]\"','2025-12-02 21:49:33','2025-12-02 21:49:33'),(87,194,'<p>La&nbsp;TUF&nbsp;GAMING&nbsp;B650E-PLUS&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;pensada&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;moderna&nbsp;con&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;recientes&nbsp;sobre&nbsp;socket&nbsp;AM5,&nbsp;combinando&nbsp;compatibilidad,&nbsp;potencia&nbsp;y&nbsp;estabilidad&nbsp;en&nbsp;un&nbsp;diseño&nbsp;robusto&nbsp;de&nbsp;“grado&nbsp;militar”.&nbsp;Al&nbsp;aceptar&nbsp;memorias&nbsp;DDR5&nbsp;de&nbsp;alta&nbsp;velocidad&nbsp;(y&nbsp;hasta&nbsp;256&nbsp;GB),&nbsp;ofrece&nbsp;gran&nbsp;agilidad&nbsp;en&nbsp;multitarea,&nbsp;edición,&nbsp;gaming&nbsp;o&nbsp;tareas&nbsp;exigentes.&nbsp;Con&nbsp;soporte&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;GPU&nbsp;y&nbsp;una&nbsp;ranura&nbsp;M.2&nbsp;también&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;SSD&nbsp;ultrarrápidos,&nbsp;garantiza&nbsp;que&nbsp;tanto&nbsp;gráficos&nbsp;como&nbsp;almacenamiento&nbsp;funcionen&nbsp;a&nbsp;máxima&nbsp;velocidad&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.&nbsp;Su&nbsp;red&nbsp;integrada&nbsp;(LAN&nbsp;2.5&nbsp;Gb&nbsp;+&nbsp;Wi-Fi&nbsp;6E)&nbsp;y&nbsp;puertos&nbsp;modernos&nbsp;(USB-C&nbsp;20&nbsp;Gbps,&nbsp;USB&nbsp;3.x)&nbsp;aseguran&nbsp;conectividad&nbsp;rápida,&nbsp;versátil&nbsp;y&nbsp;preparada&nbsp;para&nbsp;periféricos&nbsp;actuales.&nbsp;Su&nbsp;alimentación&nbsp;reforzada&nbsp;y&nbsp;sistema&nbsp;térmico&nbsp;optimizado&nbsp;dan&nbsp;estabilidad&nbsp;incluso&nbsp;bajo&nbsp;cargas&nbsp;intensas,&nbsp;mientras&nbsp;su&nbsp;diseño&nbsp;TUF&nbsp;garantiza&nbsp;durabilidad&nbsp;y&nbsp;fiabilidad&nbsp;a&nbsp;largo&nbsp;plazo.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS TUF GAMING B650E PLUS WIFI AM5\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MADRE ASUS \\\",\\\"detalle\\\":\\\"Si tu PC monta esta placa madre TUF GAMING B650E PLUS WIFI AM5, se transforma en un equipo potente, moderno y equilibrado: un sistema capaz de correr juegos actuales, edici\\\\u00f3n, render, multitarea y trabajo exigente con fluidez. Aprovechar\\\\u00e1s la velocidad de memoria DDR5, carga r\\\\u00e1pida de SSDs NVMe, compatibilidad con GPUs modernas y conectividad estable y veloz. Tu equipo tendr\\\\u00e1 tiempos de carga reducidos, buena respuesta general, estabilidad y capacidad de actualizaci\\\\u00f3n: podr\\\\u00e1s mejorar RAM, GPU o almacenamiento en el futuro sin cambiar la placa madre.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764712575_692f607fdc3b0.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/yVMX6zbRHtA\\\"]\"','2025-12-02 21:56:15','2025-12-02 21:56:15'),(88,195,'<p>La&nbsp;B550&nbsp;EAGLE&nbsp;WIFI6&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;socket&nbsp;AM4&nbsp;pensada&nbsp;para&nbsp;sistemas&nbsp;con&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;de&nbsp;generaciones&nbsp;compatibles.&nbsp;Su&nbsp;diseño&nbsp;con&nbsp;fases&nbsp;de&nbsp;potencia&nbsp;digital&nbsp;10+3&nbsp;le&nbsp;da&nbsp;estabilidad&nbsp;para&nbsp;manejar&nbsp;CPUs&nbsp;exigentes&nbsp;y&nbsp;asegurar&nbsp;rendimiento&nbsp;constante.&nbsp;Utiliza&nbsp;memorias&nbsp;DDR4&nbsp;en&nbsp;cuatro&nbsp;ranuras&nbsp;DIMM,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;montar&nbsp;suficiente&nbsp;RAM&nbsp;para&nbsp;multitarea,&nbsp;edición,&nbsp;juegos&nbsp;o&nbsp;trabajo&nbsp;exigente&nbsp;sin&nbsp;gastar&nbsp;demasiado.&nbsp;Ofrece&nbsp;ranuras&nbsp;modernas:&nbsp;PCIe&nbsp;4.0&nbsp;x16&nbsp;para&nbsp;tarjeta&nbsp;gráfica,&nbsp;dos&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe&nbsp;—&nbsp;una&nbsp;con&nbsp;soporte&nbsp;PCIe&nbsp;4.0&nbsp;—&nbsp;lo&nbsp;que&nbsp;significa&nbsp;almacenamiento&nbsp;rápido&nbsp;y&nbsp;buena&nbsp;compatibilidad&nbsp;con&nbsp;GPUs&nbsp;actuales.&nbsp;Su&nbsp;conectividad&nbsp;incluye&nbsp;red&nbsp;cableada&nbsp;GbE&nbsp;más&nbsp;Wi-Fi&nbsp;6&nbsp;con&nbsp;Bluetooth,&nbsp;ofreciendo&nbsp;flexibilidad&nbsp;de&nbsp;conexión&nbsp;sin&nbsp;depender&nbsp;exclusivamente&nbsp;de&nbsp;cable&nbsp;Ethernet.&nbsp;La&nbsp;placa&nbsp;también&nbsp;incorpora&nbsp;opciones&nbsp;de&nbsp;expansión,&nbsp;conectores&nbsp;USB&nbsp;actuales,&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(útil&nbsp;si&nbsp;usas&nbsp;procesador&nbsp;con&nbsp;gráficos&nbsp;integrados),&nbsp;y&nbsp;un&nbsp;diseño&nbsp;orientado&nbsp;a&nbsp;durabilidad&nbsp;gracias&nbsp;a&nbsp;su&nbsp;tecnología&nbsp;Ultra&nbsp;Durable&nbsp;y&nbsp;refuerzos&nbsp;en&nbsp;ranuras&nbsp;PCIe.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE B550 EAGLE WIFI6 ATX AST\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Con la B550 EAGLE WIFI6 tu PC se convierte en un equipo vers\\\\u00e1til, estable y muy funcional: puedes usar un procesador Ryzen moderno, RAM suficiente, SSD r\\\\u00e1pido y una tarjeta gr\\\\u00e1fica dedicada sin cuellos de botella. El almacenamiento r\\\\u00e1pido (SSD en M.2) combinado con buena memoria y soporte de GPU permite que tu sistema responda \\\\u00e1gil tanto en trabajo, edici\\\\u00f3n, multitarea y juegos exigentes. La conectividad con Wi-Fi 6 + LAN te da flexibilidad para conectarte en red o inal\\\\u00e1mbrico, ideal si no puedes usar cable o tienes ambientes variados.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764712923_692f61dbdf4cb.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/_fgNS4a0ZMc\\\"]\"','2025-12-02 22:02:03','2025-12-02 22:02:03'),(89,196,'<p>La&nbsp;ROG&nbsp;STRIX&nbsp;X870E-E&nbsp;GAMING&nbsp;WiFi&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;de&nbsp;gama&nbsp;alta&nbsp;pensada&nbsp;para&nbsp;procesadores&nbsp;modernos&nbsp;con&nbsp;socket&nbsp;AM5,&nbsp;diseñada&nbsp;para&nbsp;exprimir&nbsp;al&nbsp;máximo&nbsp;CPUs&nbsp;potentes&nbsp;y&nbsp;hardware&nbsp;de&nbsp;nueva&nbsp;generación.&nbsp;Su&nbsp;soporte&nbsp;de&nbsp;memoria&nbsp;DDR5&nbsp;permite&nbsp;velocidades&nbsp;muy&nbsp;altas&nbsp;y&nbsp;gran&nbsp;capacidad,&nbsp;lo&nbsp;que&nbsp;significa&nbsp;fluidez&nbsp;en&nbsp;multitarea,&nbsp;edición,&nbsp;juegos&nbsp;exigentes&nbsp;o&nbsp;trabajos&nbsp;pesados.&nbsp;Incluye&nbsp;ranuras&nbsp;PCIe&nbsp;5.0&nbsp;y&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;(PCIe&nbsp;5.0&nbsp;y&nbsp;4.0)&nbsp;para&nbsp;SSD&nbsp;ultrarrápidos,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;que&nbsp;tanto&nbsp;la&nbsp;GPU&nbsp;como&nbsp;el&nbsp;almacenamiento&nbsp;funcionen&nbsp;con&nbsp;el&nbsp;máximo&nbsp;rendimiento&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.&nbsp;Su&nbsp;sistema&nbsp;de&nbsp;alimentación&nbsp;con&nbsp;fases&nbsp;robustas&nbsp;y&nbsp;componentes&nbsp;premium&nbsp;asegura&nbsp;estabilidad&nbsp;incluso&nbsp;bajo&nbsp;cargas&nbsp;intensas&nbsp;o&nbsp;con&nbsp;CPUs&nbsp;de&nbsp;alta&nbsp;gama.&nbsp;En&nbsp;conectividad,&nbsp;ofrece&nbsp;lo&nbsp;moderno:&nbsp;WiFi&nbsp;7,&nbsp;red&nbsp;5&nbsp;Gb,&nbsp;puertos&nbsp;USB4,&nbsp;salidas&nbsp;de&nbsp;video,&nbsp;audio&nbsp;de&nbsp;alta&nbsp;fidelidad&nbsp;y&nbsp;opciones&nbsp;de&nbsp;expansión&nbsp;diversas&nbsp;—&nbsp;ideal&nbsp;para&nbsp;ensamblar&nbsp;un&nbsp;PC&nbsp;completo,&nbsp;rápido,&nbsp;potente&nbsp;y&nbsp;actualizado.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS ROG STRIX X870E-E GAMINGG WIFI\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"Si instalas esta placa ROG STRIX X870E-E GAMINGG WIFI, tu PC se transforma en una m\\\\u00e1quina de alto rendimiento lista para todo: podr\\\\u00e1 manejar juegos exigentes, edici\\\\u00f3n de video\\\\\\/fotograf\\\\u00eda, trabajo profesional, multitarea intensiva o software pesado con eficiencia y velocidad. Gracias a la DDR5, PCIe 5.0, SSD NVMe r\\\\u00e1pidos y buena fuente de potencia, tu sistema tendr\\\\u00e1 tiempos de carga m\\\\u00ednimos, gran fluidez, estabilidad y capacidad para aprovechar GPU modernas al m\\\\u00e1ximo. La conectividad avanzada (WiFi 7, red 5 Gb, USB4, audio, puertos modernos) asegura que tu PC est\\\\u00e9 lista para perif\\\\u00e9ricos actuales, redes r\\\\u00e1pidas, streaming, edici\\\\u00f3n o trabajo online sin limitaciones. Adem\\\\u00e1s, la placa te da margen para actualizar componentes (CPU, RAM, GPU, almacenamiento) en los pr\\\\u00f3ximos a\\\\u00f1os sin necesidad de renovar la base \\\\u2014 convirtiendo tu PC en un sistema moderno, vers\\\\u00e1til y duradero.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764713294_692f634eb2eb0.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/jN7C5wD3ZYs\\\"]\"','2025-12-02 22:08:14','2025-12-02 22:08:14'),(90,197,'<p>La&nbsp;ASUS&nbsp;PRIME&nbsp;X870-P&nbsp;WIFI&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;de&nbsp;última&nbsp;generación&nbsp;con&nbsp;socket&nbsp;AM5&nbsp;y&nbsp;chipset&nbsp;X870,&nbsp;pensada&nbsp;para&nbsp;aprovechar&nbsp;al&nbsp;máximo&nbsp;los&nbsp;procesadores&nbsp;actuales&nbsp;de&nbsp;AMD&nbsp;Ryzen&nbsp;serie&nbsp;7000&nbsp;/&nbsp;8000&nbsp;/&nbsp;9000.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;alimentación&nbsp;robusto&nbsp;—&nbsp;con&nbsp;etapas&nbsp;de&nbsp;energía&nbsp;potentes&nbsp;—&nbsp;ofrece&nbsp;estabilidad&nbsp;y&nbsp;potencia&nbsp;suficiente&nbsp;para&nbsp;CPUs&nbsp;exigentes,&nbsp;incluso&nbsp;en&nbsp;cargas&nbsp;intensas.&nbsp;Soporta&nbsp;memoria&nbsp;DDR5&nbsp;en&nbsp;cuatro&nbsp;ranuras,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;tener&nbsp;RAM&nbsp;rápida&nbsp;y&nbsp;abundante&nbsp;(hasta&nbsp;192&nbsp;GB)&nbsp;funcionando&nbsp;en&nbsp;dual-channel,&nbsp;ideal&nbsp;para&nbsp;multitarea,&nbsp;edición,&nbsp;juegos&nbsp;o&nbsp;trabajo&nbsp;pesado.&nbsp;Integra&nbsp;múltiples&nbsp;ranuras&nbsp;M.2&nbsp;—&nbsp;una&nbsp;compatible&nbsp;con&nbsp;PCIe&nbsp;5.0&nbsp;y&nbsp;otras&nbsp;con&nbsp;PCIe&nbsp;4.0/3.0&nbsp;—&nbsp;garantizando&nbsp;almacenamiento&nbsp;ultrarrápido&nbsp;mediante&nbsp;SSD&nbsp;NVMe.&nbsp;Su&nbsp;ranura&nbsp;PCIe&nbsp;5.0&nbsp;x16&nbsp;está&nbsp;preparada&nbsp;para&nbsp;tarjetas&nbsp;gráficas&nbsp;modernas,&nbsp;asegurando&nbsp;compatibilidad&nbsp;con&nbsp;hardware&nbsp;de&nbsp;vanguardia&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.</p><p></p><p>En&nbsp;conectividad,&nbsp;incluye&nbsp;red&nbsp;cableada&nbsp;2.5&nbsp;Gb,&nbsp;WiFi&nbsp;7&nbsp;y&nbsp;puertos&nbsp;USB-C&nbsp;/&nbsp;USB&nbsp;modernos&nbsp;de&nbsp;alta&nbsp;velocidad,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;uso&nbsp;óptimo&nbsp;de&nbsp;internet,&nbsp;periféricos&nbsp;y&nbsp;dispositivos&nbsp;externos&nbsp;actuales.&nbsp;Su&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;y&nbsp;diseño&nbsp;cuidado&nbsp;ayudan&nbsp;a&nbsp;mantener&nbsp;el&nbsp;sistema&nbsp;estable&nbsp;y&nbsp;fresco&nbsp;incluso&nbsp;en&nbsp;uso&nbsp;intensivo.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS PRIME X870 P WIFI7 AM5\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"Con esta placa madre PRIME X870 P WIFI7 AM5 , tu PC se convierte en una m\\\\u00e1quina moderna, potente y preparada para el futuro \\\\u2014 capaz de manejar gaming exigente, edici\\\\u00f3n, dise\\\\u00f1o, multitarea pesada y software demandante sin problemas. Podr\\\\u00e1s usar un CPU AMD reciente, memoria r\\\\u00e1pida, almacenamiento ultrarr\\\\u00e1pido y una tarjeta gr\\\\u00e1fica moderna, obteniendo una experiencia fluida y eficiente. Gracias a su conectividad y soporte de hardware actual, tu equipo estar\\\\u00e1 actualizado, se sentir\\\\u00e1 r\\\\u00e1pido y ser\\\\u00e1 escalable: podr\\\\u00e1s mejorar RAM, SSD o GPU m\\\\u00e1s adelante sin cambiar la placa base.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764713708_692f64ec5df8e.jpg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/ikqM6A4NfD8\\\"]\"','2025-12-02 22:15:08','2025-12-02 22:15:08'),(91,198,'<p>La&nbsp;B760M&nbsp;Project&nbsp;Zero&nbsp;DDR5&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;moderna&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;pensada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;12.ª,&nbsp;13.ª&nbsp;o&nbsp;14.ª&nbsp;generación,&nbsp;concebida&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;equilibrio&nbsp;entre&nbsp;compatibilidad&nbsp;actual,&nbsp;rendimiento&nbsp;y&nbsp;practicidad.&nbsp;Soporta&nbsp;memoria&nbsp;DDR5&nbsp;de&nbsp;alta&nbsp;velocidad,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;que&nbsp;tu&nbsp;sistema&nbsp;resulte&nbsp;ágil&nbsp;y&nbsp;responsivo&nbsp;en&nbsp;tareas&nbsp;cotidianas,&nbsp;gaming&nbsp;o&nbsp;trabajo&nbsp;exigente.&nbsp;Su&nbsp;diseño&nbsp;permite&nbsp;instalar&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;potente,&nbsp;almacenamiento&nbsp;NVMe&nbsp;rápido&nbsp;a&nbsp;través&nbsp;de&nbsp;ranuras&nbsp;M.2,&nbsp;y&nbsp;combinar&nbsp;componentes&nbsp;modernos&nbsp;manteniendo&nbsp;buena&nbsp;estabilidad.&nbsp;También&nbsp;integra&nbsp;conectividad&nbsp;actualizada&nbsp;con&nbsp;red&nbsp;de&nbsp;2.5&nbsp;Gb,&nbsp;soporte&nbsp;Wi-Fi&nbsp;6E&nbsp;(versión&nbsp;con&nbsp;WiFi),&nbsp;puertos&nbsp;USB&nbsp;modernos,&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(HDMI&nbsp;/&nbsp;DisplayPort&nbsp;—&nbsp;si&nbsp;el&nbsp;CPU&nbsp;tiene&nbsp;iGPU),&nbsp;lo&nbsp;que&nbsp;la&nbsp;convierte&nbsp;en&nbsp;una&nbsp;base&nbsp;versátil&nbsp;y&nbsp;funcional&nbsp;para&nbsp;diversos&nbsp;usos.&nbsp;Su&nbsp;factor&nbsp;de&nbsp;forma&nbsp;micro-ATX&nbsp;la&nbsp;hace&nbsp;adecuada&nbsp;tanto&nbsp;para&nbsp;gabinetes&nbsp;compactos&nbsp;como&nbsp;medianos,&nbsp;facilitando&nbsp;montajes&nbsp;más&nbsp;económicos&nbsp;o&nbsp;portables.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI B760M PROJECT ZERO DDR5 LGA1700\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MSI\\\",\\\"detalle\\\":\\\"Si eliges esta placa B760M PROJECT ZERO DDR5 LGA1700  para tu PC, tendr\\\\u00e1s una base compatible con procesadores Intel modernos, RAM veloz, SSD ultrarr\\\\u00e1pido, y posibilidad de tarjeta gr\\\\u00e1fica dedicada \\\\u2014 lo que resulta en un sistema equilibrado, r\\\\u00e1pido y con buen rendimiento en juegos, edici\\\\u00f3n, multitarea o uso intensivo. Tu PC ser\\\\u00e1 flexible: podr\\\\u00edas actualizar RAM, almacenamiento o GPU en el futuro sin cambiar la placa madre. Por su formato compacto, puede servir para una construcci\\\\u00f3n m\\\\u00e1s moderada o de menor tama\\\\u00f1o, manteniendo funcionalidad completa sin sacrificar capacidad.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764714342_692f6766b5f19.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/kZjlCQOGPKY\\\"]\"','2025-12-02 22:25:42','2025-12-02 22:25:42'),(92,199,'<p>La&nbsp;Gigabyte&nbsp;B760M&nbsp;DS3H&nbsp;DDR4&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;12.ª&nbsp;y&nbsp;13.ª&nbsp;generación,&nbsp;ideal&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;funcional,&nbsp;moderna&nbsp;y&nbsp;relativamente&nbsp;económica.&nbsp;Al&nbsp;usar&nbsp;memorias&nbsp;DDR4&nbsp;en&nbsp;configuración&nbsp;de&nbsp;cuatro&nbsp;ranuras&nbsp;DIMM&nbsp;con&nbsp;soporte&nbsp;dual-channel,&nbsp;ofrece&nbsp;compatibilidad&nbsp;y&nbsp;buen&nbsp;rendimiento&nbsp;en&nbsp;multitarea,&nbsp;ofimática,&nbsp;trabajo&nbsp;diario&nbsp;o&nbsp;gaming&nbsp;moderado.&nbsp;Cuenta&nbsp;con&nbsp;ranuras&nbsp;PCIe&nbsp;4.0&nbsp;y&nbsp;dos&nbsp;conectores&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;un&nbsp;almacenamiento&nbsp;veloz&nbsp;y&nbsp;óptimo&nbsp;aprovechamiento&nbsp;de&nbsp;GPU&nbsp;dedicada&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.&nbsp;Su&nbsp;red&nbsp;integrada&nbsp;2.5&nbsp;GbE&nbsp;y&nbsp;puertos&nbsp;modernos&nbsp;(como&nbsp;USB-C,&nbsp;USB&nbsp;3.x,&nbsp;salidas&nbsp;de&nbsp;video&nbsp;cuando&nbsp;el&nbsp;CPU&nbsp;tenga&nbsp;gráficos&nbsp;integrados)&nbsp;ofrecen&nbsp;conectividad&nbsp;suficiente&nbsp;para&nbsp;internet,&nbsp;periféricos&nbsp;y&nbsp;accesorios&nbsp;actuales.&nbsp;Su&nbsp;diseño&nbsp;de&nbsp;energía&nbsp;—&nbsp;VRM&nbsp;híbrido&nbsp;de&nbsp;6+2+1&nbsp;fases&nbsp;—&nbsp;aporta&nbsp;estabilidad&nbsp;al&nbsp;sistema&nbsp;aun&nbsp;con&nbsp;procesadores&nbsp;potentes.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE GIGABYTE B760M DS3H DDR4 LGA 1700\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA GIGABYTE\\\",\\\"detalle\\\":\\\"Si montas tu PC con la B760M DS3H, obtendr\\\\u00e1s un sistema funcional, estable y vers\\\\u00e1til: podr\\\\u00e1s usar un CPU Intel moderno, memoria RAM amplia, SSD r\\\\u00e1pido y GPU dedicada sin preocuparte por compatibilidad. Tu equipo ser\\\\u00e1 capaz de manejar navegaci\\\\u00f3n, oficina, edici\\\\u00f3n ligera, juegos, multimedia o tareas diarias con fluidez. Gracias a su combinaci\\\\u00f3n de prestaciones y precio, te da un buen punto de partida: si m\\\\u00e1s adelante quieres actualizar RAM, almacenamiento o tarjeta gr\\\\u00e1fica, esta placa te da espacio para crecer sin necesidad de cambiar la base. En resumen: con ella tu PC ser\\\\u00e1 equilibrada, eficiente, confiable y con buen rendimiento general.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764714976_692f69e08d56a.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/NE8Qv-hVMx4\\\"]\"','2025-12-02 22:36:16','2025-12-02 22:36:16'),(93,200,'<p>a&nbsp;PRIME&nbsp;B550M-A&nbsp;AC&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;con&nbsp;socket&nbsp;AM4&nbsp;y&nbsp;chipset&nbsp;B550&nbsp;diseñada&nbsp;para&nbsp;sistemas&nbsp;con&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;compatibles.&nbsp;Su&nbsp;arquitectura&nbsp;ofrece&nbsp;buen&nbsp;soporte&nbsp;a&nbsp;RAM&nbsp;DDR4&nbsp;rápida,&nbsp;ranuras&nbsp;PCIe&nbsp;modernas,&nbsp;almacenamiento&nbsp;SSD&nbsp;veloz&nbsp;mediante&nbsp;M.2,&nbsp;conectividad&nbsp;actual&nbsp;con&nbsp;Wi-Fi&nbsp;integrado&nbsp;y&nbsp;un&nbsp;conjunto&nbsp;de&nbsp;conexiones/puertos&nbsp;suficiente&nbsp;para&nbsp;una&nbsp;PC&nbsp;versátil.&nbsp;La&nbsp;placa&nbsp;incluye&nbsp;disipadores&nbsp;en&nbsp;zonas&nbsp;críticas&nbsp;para&nbsp;mantener&nbsp;temperaturas&nbsp;adecuadas,&nbsp;lo&nbsp;que&nbsp;favorece&nbsp;estabilidad&nbsp;incluso&nbsp;bajo&nbsp;uso&nbsp;prolongado,&nbsp;y&nbsp;ofrece&nbsp;funciones&nbsp;de&nbsp;audio,&nbsp;red,&nbsp;y&nbsp;expansión&nbsp;suficientes&nbsp;para&nbsp;montar&nbsp;una&nbsp;máquina&nbsp;equilibrada&nbsp;sin&nbsp;complicaciones.&nbsp;Su&nbsp;formato&nbsp;compacto&nbsp;la&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;de&nbsp;tamaño&nbsp;reducido&nbsp;o&nbsp;medianas,&nbsp;sin&nbsp;sacrificar&nbsp;compatibilidad&nbsp;ni&nbsp;funcionalidad.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS PRIME B550M-A AC, WI-FI, AM4 AMD\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS \\\",\\\"detalle\\\":\\\"Si usas esta placa PRIME B550M-A AC, WI-FI, AM4 AMD en tu PC, tendr\\\\u00e1s una base confiable y equilibrada: podr\\\\u00e1s montar un procesador Ryzen compatible, memoria RAM suficiente, almacenamiento SSD r\\\\u00e1pido y, si lo deseas, una tarjeta gr\\\\u00e1fica dedicada sin cuellos de botella serios. Tu sistema podr\\\\u00e1 rendir bien en tareas de oficina, edici\\\\u00f3n ligera, multimedia, gaming moderado o trabajo cotidiano con buena estabilidad. Gracias al soporte de M.2, PCIe 4.0, y Wi-Fi integrado, tu PC ser\\\\u00e1 flexible, moderna y adaptable: es una plataforma que permite actualizar RAM, almacenamiento o GPU m\\\\u00e1s adelante sin necesidad de cambiar la placa madre\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764715547_692f6c1b1e508.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/exevN3OuduU\\\"]\"','2025-12-02 22:45:47','2025-12-02 22:45:47'),(94,201,'<p>La&nbsp;ROG&nbsp;STRIX&nbsp;B550-F&nbsp;GAMING&nbsp;WIFI&nbsp;II&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;para&nbsp;socket&nbsp;Socket&nbsp;AM4,&nbsp;pensada&nbsp;para&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;de&nbsp;las&nbsp;series&nbsp;compatibles,&nbsp;que&nbsp;combina&nbsp;potencia,&nbsp;compatibilidad&nbsp;y&nbsp;conectividad&nbsp;moderna&nbsp;para&nbsp;un&nbsp;PC&nbsp;completo.&nbsp;Su&nbsp;soporte&nbsp;para&nbsp;memorias&nbsp;DDR4&nbsp;—&nbsp;con&nbsp;hasta&nbsp;128&nbsp;GB&nbsp;—&nbsp;permite&nbsp;que&nbsp;el&nbsp;sistema&nbsp;tenga&nbsp;buena&nbsp;capacidad&nbsp;y&nbsp;fluidez&nbsp;en&nbsp;multitarea,&nbsp;edición,&nbsp;trabajo&nbsp;intensivo&nbsp;o&nbsp;gaming.&nbsp;Al&nbsp;incluir&nbsp;soporte&nbsp;para&nbsp;PCIe&nbsp;4.0,&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe&nbsp;y&nbsp;múltiples&nbsp;puertos&nbsp;de&nbsp;expansión,&nbsp;permite&nbsp;montar&nbsp;discos&nbsp;rápidos&nbsp;y&nbsp;tarjetas&nbsp;gráficas&nbsp;modernas&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella,&nbsp;maximizando&nbsp;rendimiento&nbsp;general.&nbsp;Su&nbsp;red&nbsp;integrada&nbsp;con&nbsp;Wi-Fi&nbsp;6E&nbsp;y&nbsp;LAN&nbsp;2.5&nbsp;Gb&nbsp;garantiza&nbsp;conexión&nbsp;estable&nbsp;y&nbsp;rápida,&nbsp;útil&nbsp;para&nbsp;juegos&nbsp;online,&nbsp;streaming&nbsp;o&nbsp;trabajo&nbsp;en&nbsp;red.&nbsp;Además,&nbsp;su&nbsp;sistema&nbsp;de&nbsp;alimentación&nbsp;robusto&nbsp;(12+2&nbsp;fases)&nbsp;y&nbsp;diseño&nbsp;orientado&nbsp;a&nbsp;estabilidad&nbsp;aseguran&nbsp;que&nbsp;la&nbsp;placa&nbsp;maneje&nbsp;bien&nbsp;CPUs&nbsp;exigentes,&nbsp;manteniendo&nbsp;rendimiento&nbsp;sostenido.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS ROG STRIX B550-F GAMING WIFI II AM4 AMD\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"Si montas tu PC con esta placa madre ROG STRIX B550-F GAMING WIFI II AM4 AMD, tu sistema se convierte en una m\\\\u00e1quina equilibrada y vers\\\\u00e1til: tendr\\\\u00e1 potencia suficiente para trabajar, editar, jugar o realizar tareas pesadas sin problemas. Podr\\\\u00e1s aprovechar memoria RAM amplia, almacenamiento SSD veloz y una GPU dedicada potente, obteniendo tiempos de carga r\\\\u00e1pidos, buena respuesta y rendimiento estable. La conectividad incorporada permite internet r\\\\u00e1pido y confiable, uso c\\\\u00f3modo de perif\\\\u00e9ricos modernos, y versatilidad si usas Wi-Fi o red por cable. Tu equipo estar\\\\u00e1 preparado para uso intensivo, multitarea, juegos, edici\\\\u00f3n o cualquier tarea demandante, con capacidad de actualizaci\\\\u00f3n (m\\\\u00e1s RAM, mejor GPU o almacenamiento) sin necesidad de cambiar la placa madre.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764716346_692f6f3abb130.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/tdkvyCh4opY\\\"]\"','2025-12-02 22:59:06','2025-12-02 22:59:06'),(95,202,'<p>La&nbsp;PRIME&nbsp;A520M-K&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;pensada&nbsp;para&nbsp;armar&nbsp;una&nbsp;PC&nbsp;AMD&nbsp;económica&nbsp;o&nbsp;de&nbsp;gama&nbsp;media&nbsp;con&nbsp;procesadores&nbsp;AMD&nbsp;Ryzen&nbsp;compatibles&nbsp;con&nbsp;socket&nbsp;AM4.&nbsp;Trabaja&nbsp;con&nbsp;memoria&nbsp;DDR4,&nbsp;permitiendo&nbsp;hasta&nbsp;64&nbsp;GB&nbsp;en&nbsp;formato&nbsp;dual-channel&nbsp;con&nbsp;buenas&nbsp;velocidades,&nbsp;lo&nbsp;que&nbsp;da&nbsp;una&nbsp;base&nbsp;razonable&nbsp;para&nbsp;multitarea,&nbsp;trabajo,&nbsp;edición&nbsp;ligera,&nbsp;navegación&nbsp;o&nbsp;gaming&nbsp;modesto.&nbsp;Integra&nbsp;soporte&nbsp;para&nbsp;almacenamiento&nbsp;moderno&nbsp;mediante&nbsp;una&nbsp;ranura&nbsp;M.2&nbsp;y&nbsp;puertos&nbsp;SATA,&nbsp;lo&nbsp;que&nbsp;facilita&nbsp;usar&nbsp;SSDs&nbsp;rápidos&nbsp;o&nbsp;discos&nbsp;tradicionales.&nbsp;Su&nbsp;ranura&nbsp;PCIe&nbsp;x16&nbsp;permite&nbsp;instalar&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;si&nbsp;buscas&nbsp;rendimiento&nbsp;en&nbsp;videojuegos&nbsp;o&nbsp;tareas&nbsp;gráficas.&nbsp;Dispone&nbsp;de&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(HDMI&nbsp;y&nbsp;VGA)&nbsp;útiles&nbsp;si&nbsp;usas&nbsp;un&nbsp;APU&nbsp;con&nbsp;gráficos&nbsp;integrados,&nbsp;USB&nbsp;modernos&nbsp;y&nbsp;audio&nbsp;integrado,&nbsp;garantizando&nbsp;compatibilidad&nbsp;con&nbsp;periféricos,&nbsp;monitores&nbsp;y&nbsp;hardware&nbsp;común&nbsp;sin&nbsp;complicaciones.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE ASUS PRIME PRIME A520M-K AM4 AMD\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"Si tu PC tiene la PRIME A520M-K como base, tu equipo ser\\\\u00e1 un sistema equilibrado y asequible: podr\\\\u00e1s montar un Ryzen compatible, tener una RAM decente, usar un SSD o disco r\\\\u00e1pido, e incluso agregar una GPU, logrando un desempe\\\\u00f1o correcto en uso cotidiano, oficina, estudio, multimedia, edici\\\\u00f3n ligera o gaming b\\\\u00e1sico\\\\\\/moderado. Tu PC no ser\\\\u00e1 \\\\u201cgama alta\\\\u201d, pero s\\\\u00ed funcional, con buen equilibrio entre precio, compatibilidad y rendimiento \\\\u2014 ideal si buscas algo pr\\\\u00e1ctico sin gastar de m\\\\u00e1s. Adem\\\\u00e1s, al ser micro-ATX, puede servir en gabinetes compactos o sencillos, facilitando construcciones econ\\\\u00f3micas o de bajo presupuesto.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764718110_692f761e428e1.jpeg\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/CzSU_JcIojY\\\"]\"','2025-12-02 23:28:30','2025-12-02 23:28:30'),(96,203,'<p>La&nbsp;MSI&nbsp;PRO&nbsp;B760M-E&nbsp;DDR4&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;de&nbsp;socket&nbsp;LGA&nbsp;1700,&nbsp;pensada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;actuales&nbsp;de&nbsp;12.ª,&nbsp;13.ª&nbsp;y&nbsp;14.ª&nbsp;generación,&nbsp;así&nbsp;como&nbsp;CPUs&nbsp;más&nbsp;económicos.&nbsp;Su&nbsp;diseño&nbsp;utiliza&nbsp;memoria&nbsp;DDR4&nbsp;con&nbsp;dos&nbsp;ranuras&nbsp;DIMM,&nbsp;lo&nbsp;que&nbsp;garantiza&nbsp;compatibilidad&nbsp;con&nbsp;RAM&nbsp;común,&nbsp;estabilidad&nbsp;en&nbsp;dual-channel&nbsp;y&nbsp;facilidad&nbsp;de&nbsp;configuración&nbsp;—&nbsp;ideal&nbsp;para&nbsp;construir&nbsp;una&nbsp;PC&nbsp;sin&nbsp;complicaciones&nbsp;con&nbsp;componentes&nbsp;accesibles.</p><p>Ofrece&nbsp;expansión&nbsp;suficiente&nbsp;para&nbsp;una&nbsp;PC&nbsp;moderna:&nbsp;ranura&nbsp;PCIe&nbsp;x16&nbsp;para&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;y&nbsp;ranura&nbsp;PCIe&nbsp;x1&nbsp;extra&nbsp;para&nbsp;otros&nbsp;componentes;&nbsp;ranura&nbsp;M.2&nbsp;PCIe&nbsp;4.0&nbsp;para&nbsp;SSDs&nbsp;rápidos&nbsp;y&nbsp;múltiples&nbsp;puertos&nbsp;SATA&nbsp;para&nbsp;discos&nbsp;o&nbsp;unidades&nbsp;adicionales.&nbsp;Esto&nbsp;permite&nbsp;combinar&nbsp;buena&nbsp;potencia&nbsp;gráfica&nbsp;con&nbsp;almacenamiento&nbsp;veloz&nbsp;y&nbsp;gran&nbsp;capacidad.</p><p>Las&nbsp;salidas&nbsp;de&nbsp;video&nbsp;HDMI/VGA&nbsp;permiten&nbsp;usar&nbsp;el&nbsp;sistema&nbsp;con&nbsp;monitores&nbsp;si&nbsp;se&nbsp;emplea&nbsp;un&nbsp;CPU&nbsp;con&nbsp;gráficos&nbsp;integrados.&nbsp;La&nbsp;placa&nbsp;incluye&nbsp;soporte&nbsp;para&nbsp;audio&nbsp;de&nbsp;alta&nbsp;definición&nbsp;y&nbsp;red&nbsp;LAN,&nbsp;ofreciendo&nbsp;lo&nbsp;necesario&nbsp;para&nbsp;un&nbsp;equipo&nbsp;funcional,&nbsp;ya&nbsp;sea&nbsp;para&nbsp;trabajo,&nbsp;estudio,&nbsp;oficina,&nbsp;multimedia&nbsp;o&nbsp;gaming/moderado&nbsp;rendimiento,&nbsp;sin&nbsp;gastar&nbsp;en&nbsp;características&nbsp;premium.</p>','\"[{\\\"nombre\\\":\\\"PLACA MADRE MSI PRO B760M-E DDR4 2MODULOS\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MSI\\\",\\\"detalle\\\":\\\"Si tu PC monta esta placa madre PRO B760M-E DDR4 2MODULOS, tu equipo tendr\\\\u00e1 una base compatible con procesadores recientes Intel, posibilidad de usar memoria DDR4 est\\\\u00e1ndar, SSD NVMe veloz y tarjeta gr\\\\u00e1fica dedicada sin complicaciones. Tu sistema responder\\\\u00e1 bien en tareas de oficina, estudio, trabajo cotidiano, edici\\\\u00f3n ligera, multimedia o gaming medio, con buen equilibrio entre rendimiento y costo. La opci\\\\u00f3n de expansi\\\\u00f3n moderada te permite mejorar componentes (RAM, GPU, almacenamiento) en el futuro sin cambiar placa base, manteniendo compatibilidad.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764718641_692f783179112.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/CE_rbFVdcVA\\\"]\"','2025-12-02 23:37:21','2025-12-02 23:37:21'),(97,204,'<p>La&nbsp;MSI&nbsp;PRO&nbsp;B760M-P&nbsp;DDR5&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;micro-ATX&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;y&nbsp;chipset&nbsp;Intel&nbsp;B760,&nbsp;pensada&nbsp;para&nbsp;montar&nbsp;PCs&nbsp;con&nbsp;procesadores&nbsp;Intel&nbsp;recientes.&nbsp;Admite&nbsp;memoria&nbsp;DDR5&nbsp;con&nbsp;cuatro&nbsp;ranuras&nbsp;DIMM,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;usar&nbsp;RAM&nbsp;rápida&nbsp;y&nbsp;abundante,&nbsp;trayendo&nbsp;fluidez&nbsp;al&nbsp;sistema&nbsp;incluso&nbsp;en&nbsp;tareas&nbsp;exigentes.&nbsp;Dispone&nbsp;de&nbsp;ranura&nbsp;PCIe&nbsp;4.0&nbsp;x16&nbsp;para&nbsp;tarjeta&nbsp;gráfica&nbsp;dedicada&nbsp;y&nbsp;ranuras&nbsp;M.2&nbsp;PCIe&nbsp;4.0&nbsp;(Gen4&nbsp;x4)&nbsp;para&nbsp;unidades&nbsp;NVMe&nbsp;ultrarrápidas,&nbsp;garantizando&nbsp;velocidad&nbsp;en&nbsp;gráficos&nbsp;y&nbsp;almacenamiento.&nbsp;Ofrece&nbsp;conectividad&nbsp;moderna:&nbsp;varios&nbsp;puertos&nbsp;USB&nbsp;incluyendo&nbsp;USB-C,&nbsp;además&nbsp;de&nbsp;salidas&nbsp;de&nbsp;video&nbsp;(HDMI,&nbsp;DisplayPort,&nbsp;VGA&nbsp;—&nbsp;si&nbsp;el&nbsp;CPU&nbsp;lo&nbsp;permite),&nbsp;soporte&nbsp;de&nbsp;audio&nbsp;HD&nbsp;y&nbsp;red&nbsp;LAN&nbsp;de&nbsp;calidad.&nbsp;Su&nbsp;formato&nbsp;micro-ATX&nbsp;la&nbsp;hace&nbsp;versátil&nbsp;y&nbsp;adecuada&nbsp;para&nbsp;gabinetes&nbsp;compactos&nbsp;o&nbsp;medianos,&nbsp;manteniendo&nbsp;compatibilidad&nbsp;con&nbsp;hardware&nbsp;actual&nbsp;sin&nbsp;gastar&nbsp;tanto&nbsp;como&nbsp;una&nbsp;placa&nbsp;de&nbsp;gama&nbsp;alta.</p>','\"[{\\\"nombre\\\":\\\"PLACA MSI PRO B760M-P DDR5 LGA 1700\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA MSI\\\",\\\"detalle\\\":\\\"Con esta placa PRO B760M-P DDR5 LGA 1700, tu PC puede ser un sistema moderno, eficiente y flexible: puedes usar un procesador Intel reciente, memoria DDR5 veloz, SSD M.2 r\\\\u00e1pidos y una tarjeta gr\\\\u00e1fica dedicada sin problemas de compatibilidad. Tu equipo responder\\\\u00e1 con rapidez al arrancar, cargar programas o juegos, y manejar multitarea o trabajo exigente sin cuellos de botella. Gracias a su dise\\\\u00f1o compacto, puedes armar una PC relativamente peque\\\\u00f1a, con buen rendimiento, ideal para gaming, edici\\\\u00f3n, uso general o trabajo, sin gastar demasiado en la placa madre.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764719215_692f7a6f73ddb.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/6V_ZURUwR_0\\\"]\"','2025-12-02 23:46:55','2025-12-02 23:46:55'),(98,205,'<p>La&nbsp;ASUS&nbsp;Prime&nbsp;B760-PLUS&nbsp;es&nbsp;una&nbsp;placa&nbsp;madre&nbsp;ATX&nbsp;con&nbsp;socket&nbsp;LGA&nbsp;1700&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;recientes&nbsp;(12.ª,&nbsp;13.ª&nbsp;y&nbsp;compatibles).&nbsp;Su&nbsp;compatibilidad&nbsp;con&nbsp;memoria&nbsp;DDR5&nbsp;permite&nbsp;usar&nbsp;RAM&nbsp;rápida&nbsp;y&nbsp;moderna,&nbsp;lo&nbsp;que&nbsp;aporta&nbsp;agilidad&nbsp;y&nbsp;fluidez&nbsp;al&nbsp;sistema.&nbsp;Integra&nbsp;ranura&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;GPU,&nbsp;varias&nbsp;ranuras&nbsp;M.2&nbsp;para&nbsp;SSD&nbsp;NVMe&nbsp;de&nbsp;alta&nbsp;velocidad&nbsp;y&nbsp;múltiples&nbsp;puertos&nbsp;SATA,&nbsp;lo&nbsp;que&nbsp;permite&nbsp;montar&nbsp;un&nbsp;equipo&nbsp;con&nbsp;almacenamiento&nbsp;veloz&nbsp;y&nbsp;expansión&nbsp;cómoda.&nbsp;Tiene&nbsp;red&nbsp;integrada&nbsp;de&nbsp;2.5&nbsp;Gb,&nbsp;buena&nbsp;conectividad&nbsp;de&nbsp;puertos&nbsp;(USB-C,&nbsp;USB&nbsp;modernos,&nbsp;salidas&nbsp;de&nbsp;video&nbsp;si&nbsp;el&nbsp;CPU&nbsp;lo&nbsp;permite),&nbsp;lo&nbsp;que&nbsp;permite&nbsp;conectarse&nbsp;sin&nbsp;limitaciones&nbsp;a&nbsp;periféricos&nbsp;y&nbsp;redes&nbsp;modernas.&nbsp;Su&nbsp;diseño&nbsp;está&nbsp;orientado&nbsp;a&nbsp;ofrecer&nbsp;un&nbsp;equilibrio&nbsp;entre&nbsp;compatibilidad,&nbsp;rendimiento,&nbsp;modernidad&nbsp;y&nbsp;funcionalidad</p>','\"[{\\\"nombre\\\":\\\"MAINBOARD ASUS PRIME B760-PLUS, DDR5, LGA 1700\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\" la Prime B760-PLUS en tu PC, obtendr\\\\u00e1s una base s\\\\u00f3lida, moderna y flexible: tu sistema podr\\\\u00e1 operar con un procesador Intel compatible, RAM veloz DDR5, SSDs r\\\\u00e1pidos, y potencial para una tarjeta gr\\\\u00e1fica potente. Eso se traduce en una computadora capaz de rendir bien tanto en tareas cotidianas (ofim\\\\u00e1tica, navegaci\\\\u00f3n, edici\\\\u00f3n ligera) como en tareas exigentes: gaming, edici\\\\u00f3n, multitarea, etc. La conectividad moderna te garantiza compatibilidad con perif\\\\u00e9ricos actuales y acceso a redes r\\\\u00e1pidas, lo que mantiene tu equipo \\\\u201ca prueba del tiempo\\\\u201d. Adem\\\\u00e1s, la placa ofrece margen de crecimiento: puedes actualizar RAM, almacenamiento o GPU sin cambiar toda la base.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764719626_692f7c0a22469.png\\\"]\"','\"[\\\"https:\\\\\\/\\\\\\/youtu.be\\\\\\/ciipeigXl10?si=Dipd3p1iv41DDEOG\\\"]\"','2025-12-02 23:53:46','2025-12-02 23:53:46'),(99,206,'<p>La&nbsp;&quot;placa&nbsp;rog&nbsp;gaming&nbsp;x&nbsp;monster&nbsp;h61m&nbsp;ddr3&quot;&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;madre&nbsp;con&nbsp;chipset&nbsp;Intel&nbsp;H61&nbsp;y&nbsp;zócalo&nbsp;LGA&nbsp;1155,&nbsp;diseñada&nbsp;para&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;2ª&nbsp;y&nbsp;3ª&nbsp;generación.&nbsp;Es&nbsp;compatible&nbsp;con&nbsp;memoria&nbsp;RAM&nbsp;DDR3,&nbsp;soporta&nbsp;un&nbsp;máximo&nbsp;de&nbsp;16&nbsp;GB&nbsp;y&nbsp;ofrece&nbsp;ranuras&nbsp;de&nbsp;expansión&nbsp;PCI&nbsp;Express,&nbsp;además&nbsp;de&nbsp;puertos&nbsp;SATA&nbsp;y&nbsp;M.2&nbsp;para&nbsp;almacenamiento.</p>','\"[{\\\"nombre\\\":\\\"PLACA ROG GAMING X MONSTER H61M DDR3\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"La  placa rog gaming x monster h61m ddr3Es un modelo b\\\\u00e1sico para construir un equipo econ\\\\u00f3mico, que incluye caracter\\\\u00edsticas de entrada para gaming ligero como un slot M.2 para almacenamiento y compatibilidad con gr\\\\u00e1ficos integrados (dependiendo del procesador). \\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764720896_692f8100dadfb.jpeg\\\"]\"',NULL,'2025-12-03 00:14:56','2025-12-03 00:14:56'),(100,207,'<p>ROG&nbsp;GAMING&nbsp;X&nbsp;MONSTER&nbsp;H81M&nbsp;DDR3&nbsp;M.2&nbsp;MICRO&nbsp;se&nbsp;refiere&nbsp;a&nbsp;una&nbsp;placa&nbsp;de&nbsp;formato&nbsp;Micro-ATX&nbsp;con&nbsp;chipset&nbsp;H81&nbsp;que&nbsp;soporta&nbsp;procesadores&nbsp;Intel&nbsp;de&nbsp;4ª&nbsp;y&nbsp;5ª&nbsp;generación&nbsp;(socket&nbsp;LGA&nbsp;1150)&nbsp;y&nbsp;memoria&nbsp;DDR3.&nbsp;Ofrece&nbsp;conectividad&nbsp;M.2,&nbsp;4&nbsp;puertos&nbsp;SATA,&nbsp;2&nbsp;ranuras&nbsp;DIMM,&nbsp;un&nbsp;puerto&nbsp;PCIe&nbsp;x16&nbsp;y&nbsp;salidas&nbsp;de&nbsp;video&nbsp;como&nbsp;HDMI&nbsp;y&nbsp;D-SUB.</p>','\"[{\\\"nombre\\\":\\\"PLACA ROG GAMING X MONSTER H81M DDR3 M.2 MICRO\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"PLACA ASUS\\\",\\\"detalle\\\":\\\"ROG GAMING X MONSTER H81M DDR3 M.2 MICRO indica que es una placa de formato Micro-ATX para PCs de gama de entrada o para montar un sistema de juego b\\\\u00e1sico. Es compatible con procesadores Intel de 4\\\\u00aa generaci\\\\u00f3n (LGA 1150) y soporta memoria RAM DDR3, con una ranura M.2 para SSDs NVMe\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764721255_692f82678740f.png\\\"]\"',NULL,'2025-12-03 00:20:55','2025-12-03 00:20:55'),(101,208,'<p>El&nbsp;LEGEND&nbsp;860&nbsp;es&nbsp;un&nbsp;disco&nbsp;sólido&nbsp;(SSD)&nbsp;de&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;usa&nbsp;la&nbsp;interfaz&nbsp;moderna&nbsp;PCIe&nbsp;4.0&nbsp;x4&nbsp;con&nbsp;protocolo&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;comunicarse&nbsp;con&nbsp;la&nbsp;placa&nbsp;madre&nbsp;mucho&nbsp;más&nbsp;rápido&nbsp;que&nbsp;un&nbsp;disco&nbsp;duro&nbsp;tradicional&nbsp;o&nbsp;un&nbsp;SSD&nbsp;SATA.&nbsp;Su&nbsp;memoria&nbsp;interna&nbsp;es&nbsp;3D&nbsp;NAND&nbsp;y&nbsp;está&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;secuencial&nbsp;de&nbsp;hasta&nbsp;5000&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;hasta&nbsp;3000&nbsp;MB/s&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;500&nbsp;GB,&nbsp;con&nbsp;una&nbsp;durabilidad&nbsp;razonable&nbsp;medida&nbsp;en&nbsp;“TBW”&nbsp;para&nbsp;ciclos&nbsp;de&nbsp;escritura&nbsp;—&nbsp;lo&nbsp;que&nbsp;lo&nbsp;convierte&nbsp;en&nbsp;una&nbsp;opción&nbsp;eficiente&nbsp;para&nbsp;sistemas&nbsp;operativos,&nbsp;juegos,&nbsp;programas&nbsp;y&nbsp;trabajo&nbsp;intensivo.&nbsp;Este&nbsp;SSD&nbsp;aprovecha&nbsp;tecnologías&nbsp;modernas&nbsp;de&nbsp;control&nbsp;de&nbsp;errores&nbsp;(ECC&nbsp;/&nbsp;LDPC)&nbsp;y&nbsp;cachés&nbsp;inteligentes&nbsp;(SLC&nbsp;Caching)&nbsp;para&nbsp;mantener&nbsp;estabilidad&nbsp;y&nbsp;velocidad&nbsp;cuando&nbsp;estés&nbsp;escribiendo&nbsp;o&nbsp;leyendo&nbsp;datos&nbsp;intensamente.</p>','\"[{\\\"nombre\\\":\\\"DISCO SOLIDO ADATA, LEGEND 860, 500GB, M.2 NVME PCIE 4.0\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Si tu PC tiene este SSD LEGEND 860, 500GB, M.2 NVME PCIE 4.0 , tu sistema ganar\\\\u00e1 agilidad real: el sistema operativo arrancar\\\\u00e1 en segundos, los programas y juegos cargar\\\\u00e1n casi instant\\\\u00e1neamente, y las transferencias de archivos o proyectos pesados (edici\\\\u00f3n, dise\\\\u00f1o, multimedia) se sentir\\\\u00e1n mucho m\\\\u00e1s fluidas. Al usar NVMe y PCIe 4.0, evitas cuellos de botella modernos \\\\u2014 ideal si tienes una GPU potente, mucha RAM o haces tareas exigentes. Adem\\\\u00e1s, al ser un SSD moderno, reduce el tiempo de espera, mejora la respuesta general del equipo y hace que tu PC se sienta \\\\u201ccomo nueva\\\\u201d, incluso si otros componentes son m\\\\u00e1s modestos. Tambi\\\\u00e9n es \\\\u00fatil si buscas estabilidad a largo plazo \\\\u2014 el SSD soporta buen n\\\\u00famero de ciclos de escritura y deber\\\\u00eda funcionar bien durante a\\\\u00f1os si le das un uso normal.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764787823_6930866f403b8.png\\\"]\"',NULL,'2025-12-03 18:50:23','2025-12-03 18:50:23'),(102,209,'<p>El&nbsp;ADATA&nbsp;LEGEND&nbsp;970&nbsp;PRO&nbsp;es&nbsp;un&nbsp;SSD&nbsp;M.2&nbsp;NVMe&nbsp;de&nbsp;última&nbsp;generación&nbsp;que&nbsp;utiliza&nbsp;la&nbsp;interfaz&nbsp;PCIe&nbsp;5.0,&nbsp;diseñada&nbsp;para&nbsp;ofrecer&nbsp;velocidades&nbsp;extremas&nbsp;de&nbsp;hasta&nbsp;14,000&nbsp;MB/s,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;coloca&nbsp;entre&nbsp;los&nbsp;discos&nbsp;más&nbsp;rápidos&nbsp;del&nbsp;mercado.&nbsp;Su&nbsp;arquitectura&nbsp;interna&nbsp;emplea&nbsp;controladores&nbsp;avanzados&nbsp;y&nbsp;memoria&nbsp;3D&nbsp;NAND&nbsp;de&nbsp;alta&nbsp;durabilidad,&nbsp;capaz&nbsp;de&nbsp;sostener&nbsp;escrituras&nbsp;continuas&nbsp;sin&nbsp;perder&nbsp;estabilidad&nbsp;térmica&nbsp;gracias&nbsp;a&nbsp;un&nbsp;disipador&nbsp;con&nbsp;diseño&nbsp;activo&nbsp;que&nbsp;mantiene&nbsp;la&nbsp;temperatura&nbsp;bajo&nbsp;control&nbsp;incluso&nbsp;en&nbsp;tareas&nbsp;pesadas.&nbsp;Este&nbsp;modelo&nbsp;está&nbsp;construido&nbsp;para&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;profesionales,&nbsp;gaming&nbsp;de&nbsp;alto&nbsp;nivel&nbsp;y&nbsp;sistemas&nbsp;que&nbsp;requieren&nbsp;respuesta&nbsp;instantánea&nbsp;en&nbsp;lectura&nbsp;y&nbsp;escritura,&nbsp;ofreciendo&nbsp;un&nbsp;rendimiento&nbsp;que&nbsp;supera&nbsp;ampliamente&nbsp;a&nbsp;los&nbsp;SSD&nbsp;PCIe&nbsp;4.0&nbsp;tradicionales.</p>','\"[{\\\"nombre\\\":\\\"UNIDAD SSD M.2 LEGEND 970 PRO PCIe GEN5 1TB 14,000MB\\\\\\/s\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Al tener este SSD en tu PC UNIDAD SSD M.2 LEGEND 970 PRO PCIe GEN5 1TB 14,000MB\\\\\\/s, el sistema adquiere un nivel de velocidad que elimina pr\\\\u00e1cticamente cualquier tiempo de carga: Windows inicia en segundos, los juegos pesados cargan casi al instante y los programas profesionales (edici\\\\u00f3n 4K\\\\\\/8K, modelado, renders, IA local, compilaci\\\\u00f3n) responden sin demoras. La transferencia de archivos se vuelve casi inmediata, evitando cuellos de botella y permitiendo aprovechar al m\\\\u00e1ximo procesadores y tarjetas gr\\\\u00e1ficas modernas. Es un componente orientado a PCs potentes basadas en PCIe 5.0, por lo que realza el rendimiento total del equipo y lo deja preparado para tareas intensivas durante a\\\\u00f1os, ofreciendo m\\\\u00e1xima fluidez, estabilidad t\\\\u00e9rmica y una experiencia claramente superior.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764788531_693089336e081.jpg\\\"]\"',NULL,'2025-12-03 19:02:11','2025-12-03 19:02:11'),(103,210,'<p>El&nbsp;LEGEND&nbsp;860&nbsp;es&nbsp;un&nbsp;disco&nbsp;de&nbsp;estado&nbsp;sólido&nbsp;tipo&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;usa&nbsp;la&nbsp;interfaz&nbsp;moderna&nbsp;PCIe&nbsp;Gen4&nbsp;x4&nbsp;con&nbsp;protocolo&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;a&nbsp;tu&nbsp;PC&nbsp;comunicarse&nbsp;con&nbsp;el&nbsp;almacenamiento&nbsp;a&nbsp;muy&nbsp;alta&nbsp;velocidad.&nbsp;Su&nbsp;memoria&nbsp;es&nbsp;3D&nbsp;NAND,&nbsp;con&nbsp;soporte&nbsp;para&nbsp;tecnologías&nbsp;de&nbsp;corrección&nbsp;de&nbsp;errores&nbsp;(LDPC)&nbsp;y&nbsp;caché&nbsp;inteligente&nbsp;(SLC&nbsp;Caching),&nbsp;lo&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;rendimiento&nbsp;y&nbsp;estabilidad&nbsp;aún&nbsp;con&nbsp;uso&nbsp;intensivo.&nbsp;Este&nbsp;SSD&nbsp;ofrece&nbsp;velocidades&nbsp;secuenciales&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;6000&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;hasta&nbsp;~&nbsp;5000&nbsp;MB/s&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;1&nbsp;TB&nbsp;—&nbsp;bastante&nbsp;superiores&nbsp;a&nbsp;las&nbsp;de&nbsp;un&nbsp;HDD&nbsp;tradicional&nbsp;o&nbsp;un&nbsp;SSD&nbsp;SATA.&nbsp;&nbsp;El&nbsp;formato&nbsp;M.2&nbsp;significa&nbsp;que&nbsp;ocupa&nbsp;poco&nbsp;espacio&nbsp;dentro&nbsp;del&nbsp;gabinete,&nbsp;lo&nbsp;que&nbsp;facilita&nbsp;su&nbsp;instalación&nbsp;en&nbsp;placas&nbsp;madre&nbsp;modernas&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;cables&nbsp;adicionales,&nbsp;y&nbsp;al&nbsp;ser&nbsp;NVMe/PCIe&nbsp;4.0&nbsp;aprovecha&nbsp;al&nbsp;máximo&nbsp;las&nbsp;capacidades&nbsp;actuales&nbsp;de&nbsp;procesamiento&nbsp;y&nbsp;transferencia&nbsp;de&nbsp;datos.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"DISCO SOLIDO SSD 1TB M.2 ADATA, LEGEND 860 GEN 4X4\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Si instalas este SSD 1TB M.2 ADATA, LEGEND 860 GEN 4X4 en tu PC, notar\\\\u00e1s una diferencia clara en la rapidez general: el sistema operativo arrancar\\\\u00e1 mucho m\\\\u00e1s r\\\\u00e1pido, los programas se abrir\\\\u00e1n casi al instante, los juegos cargar\\\\u00e1n con agilidad, y los tiempos de espera en edici\\\\u00f3n, transferencia de archivos, compilaci\\\\u00f3n o renderizado se reducir\\\\u00e1n considerablemente. Al usar una interfaz NVMe PCIe 4.0 la unidad no ser\\\\u00e1 un cuello de botella: tu PC podr\\\\u00e1 aprovechar bien una GPU potente, mucha RAM o tareas exigentes sin que el almacenamiento limite el rendimiento.  Adem\\\\u00e1s, con 1 TB tienes espacio suficiente para sistema operativo, programas, juegos y proyectos. Esa combinaci\\\\u00f3n de velocidad y capacidad hace que tu PC se sienta \\\\u201c\\\\u00e1gil\\\\u201d, moderna, eficiente y preparada para trabajar o jugar sin demoras \\\\u2014 ideal si quieres un equipo equilibrado, r\\\\u00e1pido y duradero.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764789222_69308be6c1ef1.png\\\"]\"',NULL,'2025-12-03 19:13:42','2025-12-03 19:13:42'),(104,211,'<p>El&nbsp;990&nbsp;EVO&nbsp;Plus&nbsp;es&nbsp;un&nbsp;SSD&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;con&nbsp;interfaz&nbsp;NVMe&nbsp;y&nbsp;soporte&nbsp;PCIe&nbsp;4.0&nbsp;x4&nbsp;(compatible&nbsp;también&nbsp;con&nbsp;PCIe&nbsp;5.0&nbsp;x2),&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;ofrecer&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;secuencial&nbsp;de&nbsp;hasta&nbsp;~&nbsp;7.150&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;6.300&nbsp;MB/s&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;1&nbsp;TB.&nbsp;Usa&nbsp;memoria&nbsp;flash&nbsp;V-NAND&nbsp;TLC&nbsp;de&nbsp;Samsung,&nbsp;con&nbsp;controladora&nbsp;propia,&nbsp;y&nbsp;no&nbsp;depende&nbsp;de&nbsp;caché&nbsp;DRAM&nbsp;dedicada&nbsp;sino&nbsp;del&nbsp;mecanismo&nbsp;HMB&nbsp;(Host&nbsp;Memory&nbsp;Buffer),&nbsp;lo&nbsp;que&nbsp;mantiene&nbsp;su&nbsp;eficiencia&nbsp;y&nbsp;le&nbsp;permite&nbsp;ofrecer&nbsp;un&nbsp;excelente&nbsp;equilibrio&nbsp;entre&nbsp;velocidad,&nbsp;confiabilidad&nbsp;y&nbsp;durabilidad.&nbsp;Su&nbsp;factor&nbsp;de&nbsp;forma&nbsp;compacto&nbsp;(M.2&nbsp;2280)&nbsp;facilita&nbsp;la&nbsp;instalación&nbsp;en&nbsp;casi&nbsp;cualquier&nbsp;PC&nbsp;moderna&nbsp;sin&nbsp;ocupar&nbsp;espacio&nbsp;extra,&nbsp;y&nbsp;gracias&nbsp;a&nbsp;NVMe&nbsp;+&nbsp;PCIe&nbsp;4.0,&nbsp;maximiza&nbsp;el&nbsp;potencial&nbsp;del&nbsp;almacenamiento,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;ideal&nbsp;como&nbsp;unidad&nbsp;principal&nbsp;(sistema&nbsp;operativo,&nbsp;programas,&nbsp;juegos)&nbsp;o&nbsp;almacenamiento&nbsp;rápido&nbsp;para&nbsp;edición,&nbsp;diseño,&nbsp;proyectos&nbsp;grandes,&nbsp;etc.</p>','\"[{\\\"nombre\\\":\\\"SSD M.2 NVMe SAMSUNG 990 EVO PLUS 1TB 7150MBPS\\\",\\\"valor\\\":\\\"SAMSUNG\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO SAMSUNG\\\",\\\"detalle\\\":\\\"Si montas este SSD 990 EVO PLUS 1TB 7150MBPS en tu PC, notar\\\\u00e1s que el sistema operativo arranca muy r\\\\u00e1pido, los programas y juegos cargan en segundos, y las transferencias de archivos o la carga de proyectos pesados se vuelven casi instant\\\\u00e1neas. Tu PC ganar\\\\u00e1 agilidad real: la espera para abrir software, guardar archivos, editar videos o mover datos se reduce dr\\\\u00e1sticamente. Al usar almacenamiento ultrarr\\\\u00e1pido y estable, tu equipo dejar\\\\u00e1 de estar limitado por disco \\\\u2014 con lo que la RAM, CPU o GPU podr\\\\u00e1n rendir mejor, especialmente si haces multitarea, edici\\\\u00f3n, dise\\\\u00f1o gr\\\\u00e1fico, gaming o tareas intensivas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764789957_69308ec51237c.jpg\\\"]\"',NULL,'2025-12-03 19:25:57','2025-12-03 19:25:57'),(105,212,'<p>El&nbsp;Legend&nbsp;900&nbsp;es&nbsp;un&nbsp;SSD&nbsp;interno&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;utiliza&nbsp;interfaz&nbsp;PCIe&nbsp;Gen4&nbsp;x4&nbsp;con&nbsp;protocolo&nbsp;NVMe&nbsp;1.4,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;transferir&nbsp;datos&nbsp;mucho&nbsp;más&nbsp;rápido&nbsp;que&nbsp;un&nbsp;disco&nbsp;duro&nbsp;o&nbsp;un&nbsp;SSD&nbsp;SATA.&nbsp;Sus&nbsp;memorias&nbsp;3D&nbsp;NAND,&nbsp;con&nbsp;soporte&nbsp;de&nbsp;caché&nbsp;tipo&nbsp;SLC&nbsp;y&nbsp;corrección&nbsp;de&nbsp;errores&nbsp;(ECC/LDPC),&nbsp;buscan&nbsp;asegurar&nbsp;estabilidad,&nbsp;rapidez&nbsp;y&nbsp;durabilidad&nbsp;aun&nbsp;bajo&nbsp;cargas&nbsp;intensas&nbsp;o&nbsp;uso&nbsp;prolongado.&nbsp;El&nbsp;Legend&nbsp;900&nbsp;entrega&nbsp;velocidades&nbsp;secuenciales&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;7000&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;5400&nbsp;MB/s,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;coloca&nbsp;en&nbsp;un&nbsp;nivel&nbsp;superior&nbsp;de&nbsp;rendimiento&nbsp;respecto&nbsp;a&nbsp;SSD&nbsp;más&nbsp;antiguos&nbsp;—&nbsp;ideal&nbsp;para&nbsp;aprovechar&nbsp;PCs&nbsp;modernas,&nbsp;juegos,&nbsp;edición,&nbsp;multitarea,&nbsp;carga&nbsp;rápida&nbsp;de&nbsp;sistemas&nbsp;y&nbsp;programas.</p>','\"[{\\\"nombre\\\":\\\"DISCO SOLIDO SSD 1TB M.2 ADATA, LEGEND 900 NVME\\\",\\\"valor\\\":\\\"ADATA \\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Si colocas este SSD 1TB M.2 ADATA, LEGEND 900 NVME en tu PC, tu sistema ganar\\\\u00e1 rapidez perceptible: el sistema operativo arrancar\\\\u00e1 casi instant\\\\u00e1neamente, programas, juegos y cargas pesadas abrir\\\\u00e1n mucho m\\\\u00e1s r\\\\u00e1pido, y los tiempos de espera se reducir\\\\u00e1n notablemente. El almacenamiento deja de ser un cuello de botella, lo que permite que CPU, RAM o GPU rindan cerca de su m\\\\u00e1ximo potencial. El equipo se siente m\\\\u00e1s fluido, sensible y moderno. Adem\\\\u00e1s, con 1 TB tendr\\\\u00e1s espacio sobrante para sistema, juegos, trabajos, archivos y proyectos \\\\u2014 ideal si instalas muchos programas o manejas datos pesados. Con un SSD as\\\\u00ed tu PC se vuelve m\\\\u00e1s vers\\\\u00e1til: sirve para uso cotidiano, edici\\\\u00f3n, dise\\\\u00f1o, gaming, trabajo profesional, multitarea o proyectos exigentes, con un equilibrio real entre performance, estabilidad y almacenamiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764790433_693090a1b532d.jpg\\\"]\"',NULL,'2025-12-03 19:33:53','2025-12-03 19:33:53'),(106,213,'<p>El&nbsp;Kingston&nbsp;NV3&nbsp;es&nbsp;un&nbsp;SSD&nbsp;interno&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;usa&nbsp;interfaz&nbsp;PCIe&nbsp;4.0&nbsp;x4&nbsp;con&nbsp;protocolo&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;transferir&nbsp;datos&nbsp;muchísimo&nbsp;más&nbsp;rápido&nbsp;que&nbsp;un&nbsp;disco&nbsp;duro&nbsp;tradicional&nbsp;y&nbsp;con&nbsp;mejor&nbsp;eficiencia&nbsp;que&nbsp;un&nbsp;SSD&nbsp;SATA.&nbsp;u&nbsp;memoria&nbsp;es&nbsp;3D&nbsp;NAND,&nbsp;con&nbsp;buenas&nbsp;especificaciones&nbsp;en&nbsp;cuanto&nbsp;a&nbsp;durabilidad&nbsp;(hasta&nbsp;~320&nbsp;TBW&nbsp;en&nbsp;la&nbsp;versión&nbsp;de&nbsp;1&nbsp;TB)&nbsp;y&nbsp;un&nbsp;diseño&nbsp;pensado&nbsp;para&nbsp;un&nbsp;equilibrio&nbsp;entre&nbsp;desempeño,&nbsp;consumo&nbsp;y&nbsp;eficiencia.&nbsp;Con&nbsp;velocidades&nbsp;secuenciales&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;6000&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;de&nbsp;~&nbsp;4000–5000&nbsp;MB/s&nbsp;(dependiendo&nbsp;del&nbsp;tamaño&nbsp;y&nbsp;condiciones),&nbsp;el&nbsp;NV3&nbsp;se&nbsp;ubica&nbsp;en&nbsp;una&nbsp;gama&nbsp;media-alta&nbsp;de&nbsp;SSD&nbsp;NVMe,&nbsp;suficiente&nbsp;para&nbsp;sistemas&nbsp;modernos&nbsp;que&nbsp;buscan&nbsp;rapidez&nbsp;y&nbsp;fluidez&nbsp;en&nbsp;el&nbsp;uso&nbsp;cotidiano,&nbsp;gaming,&nbsp;edición,&nbsp;o&nbsp;manejo&nbsp;de&nbsp;datos&nbsp;pesados.</p>','\"[{\\\"nombre\\\":\\\"DISCO SSD M.2 PCIe 1TB KINGSTON NV3 PCI4 6000mb\\\\\\/s\\\",\\\"valor\\\":\\\"KINGSTON\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO KINGSTON\\\",\\\"detalle\\\":\\\"Al instalar este SSD 1TB KINGSTON NV3 PCI4 6000mb\\\\\\/s en tu PC, tu sistema gana agilidad real en muchos aspectos: el sistema operativo arrancar\\\\u00e1 m\\\\u00e1s r\\\\u00e1pido, programas y juegos cargar\\\\u00e1n casi al instante, y transferencias de archivos o cargas de proyectos pesados se sentir\\\\u00e1n m\\\\u00e1s fluidas. Se elimina gran parte de los cuellos de botella asociados al almacenamiento \\\\u2014 lo que permite que CPU, RAM y GPU funcionen mejor, especialmente bajo carga o multitarea. Con 1 TB tendr\\\\u00e1s espacio amplio para sistema, aplicaciones, juegos, multimedia y tus archivos \\\\u2014 suficiente para muchos a\\\\u00f1os sin preocuparte de quedarte corto.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764791232_693093c02d799.jpg\\\"]\"',NULL,'2025-12-03 19:47:12','2025-12-03 19:47:12'),(107,214,'<p>El&nbsp;Kingston&nbsp;NV3&nbsp;es&nbsp;un&nbsp;SSD&nbsp;interno&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;usa&nbsp;la&nbsp;interfaz&nbsp;PCIe&nbsp;4.0&nbsp;×4&nbsp;con&nbsp;protocolo&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;posiciona&nbsp;como&nbsp;una&nbsp;solución&nbsp;moderna&nbsp;de&nbsp;almacenamiento&nbsp;que&nbsp;va&nbsp;mucho&nbsp;más&nbsp;allá&nbsp;de&nbsp;un&nbsp;disco&nbsp;duro&nbsp;tradicional:&nbsp;ofrece&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;secuencial&nbsp;de&nbsp;hasta&nbsp;~&nbsp;5&nbsp;000&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;hasta&nbsp;~&nbsp;3&nbsp;000&nbsp;MB/s&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;500&nbsp;GB.&nbsp;Tiene&nbsp;memoria&nbsp;3D&nbsp;NAND,&nbsp;lo&nbsp;que&nbsp;—&nbsp;en&nbsp;combinación&nbsp;con&nbsp;su&nbsp;controlador&nbsp;NVMe&nbsp;Gen&nbsp;4x4&nbsp;—&nbsp;le&nbsp;permite&nbsp;ofrecer&nbsp;buen&nbsp;rendimiento&nbsp;con&nbsp;eficiencia&nbsp;energética,&nbsp;baja&nbsp;generación&nbsp;de&nbsp;calor&nbsp;y&nbsp;una&nbsp;vida&nbsp;útil&nbsp;decente,&nbsp;medida&nbsp;en&nbsp;terabytes&nbsp;escritos&nbsp;(TBW).&nbsp;Su&nbsp;factor&nbsp;de&nbsp;forma&nbsp;compacto&nbsp;(M.2&nbsp;2280)&nbsp;lo&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;de&nbsp;escritorio&nbsp;o&nbsp;portátiles&nbsp;con&nbsp;ranura&nbsp;M.2,&nbsp;ocupando&nbsp;poco&nbsp;espacio&nbsp;y&nbsp;simplificando&nbsp;la&nbsp;instalación&nbsp;sin&nbsp;cables&nbsp;adicionales.&nbsp;</p>','\"[{\\\"nombre\\\":\\\"DISCO SSD M.2 PCIe 500GB KINGSTON NV3 PCI4\\\",\\\"valor\\\":\\\"KINGSTON\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO KINGSTON\\\",\\\"detalle\\\":\\\"Instalar este SSD PCIe 500GB KINGSTON NV3 PCI4 en tu PC cambia la experiencia de uso: el sistema operativo arrancar\\\\u00e1 much\\\\u00edsimo m\\\\u00e1s r\\\\u00e1pido, los programas se abrir\\\\u00e1n al instante, y los tiempos de carga en juegos, edici\\\\u00f3n, renderizado o proyectos pesados se reducen notablemente. El almacenamiento deja de ser \\\\u201ccuello de botella\\\\u201d, lo que permite que CPU, RAM y GPU rindan mejor, especialmente en multitarea o uso intensivo. Con 500 GB tendr\\\\u00e1s espacio suficiente para el sistema, programas esenciales y algunos juegos o proyectos; suficiente para arrancar una PC moderna con buen desempe\\\\u00f1o sin gastar demasiado. Esto convierte tu equipo en una m\\\\u00e1quina m\\\\u00e1s fluida, responsiva y r\\\\u00e1pida, ideal para trabajo, estudio, edici\\\\u00f3n ligera, uso general o gaming moderado \\\\u2014 especialmente si antes usabas un HDD o SSD SATA m\\\\u00e1s lento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764791825_6930961153d13.jpg\\\"]\"',NULL,'2025-12-03 19:57:05','2025-12-03 19:57:05'),(108,215,'<p>El&nbsp;LEGEND&nbsp;710&nbsp;es&nbsp;un&nbsp;SSD&nbsp;tipo&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;utiliza&nbsp;la&nbsp;interfaz&nbsp;PCIe&nbsp;Gen3&nbsp;x4&nbsp;y&nbsp;protocolo&nbsp;NVMe,&nbsp;con&nbsp;memoria&nbsp;3D&nbsp;NAND,&nbsp;pensado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;salto&nbsp;de&nbsp;rendimiento&nbsp;respecto&nbsp;a&nbsp;discos&nbsp;duros&nbsp;tradicionales&nbsp;o&nbsp;SSD&nbsp;SATA.&nbsp;Su&nbsp;rendimiento&nbsp;máximo&nbsp;declarado&nbsp;ronda&nbsp;los&nbsp;~2400&nbsp;MB/s&nbsp;en&nbsp;lectura&nbsp;y&nbsp;~1800&nbsp;MB/s&nbsp;en&nbsp;escritura&nbsp;secuencial&nbsp;—&nbsp;lo&nbsp;que&nbsp;significa&nbsp;que&nbsp;el&nbsp;acceso&nbsp;a&nbsp;archivos,&nbsp;arranque&nbsp;del&nbsp;sistema&nbsp;operativo,&nbsp;carga&nbsp;de&nbsp;programas&nbsp;o&nbsp;juegos&nbsp;puede&nbsp;ser&nbsp;mucho&nbsp;más&nbsp;rápido&nbsp;que&nbsp;con&nbsp;discos&nbsp;convencionales.&nbsp;Está&nbsp;diseñado&nbsp;con&nbsp;un&nbsp;disipador&nbsp;liviano&nbsp;para&nbsp;ayudar&nbsp;a&nbsp;mantener&nbsp;temperaturas&nbsp;moderadas,&nbsp;lo&nbsp;que&nbsp;contribuye&nbsp;a&nbsp;su&nbsp;estabilidad&nbsp;y&nbsp;durabilidad.&nbsp;El&nbsp;formato&nbsp;M.2&nbsp;lo&nbsp;hace&nbsp;compacto&nbsp;y&nbsp;fácil&nbsp;de&nbsp;instalar&nbsp;en&nbsp;placas&nbsp;madre&nbsp;modernas&nbsp;con&nbsp;ranura&nbsp;M.2,&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;cables&nbsp;extra,&nbsp;lo&nbsp;que&nbsp;simplifica&nbsp;la&nbsp;instalación&nbsp;y&nbsp;mantiene&nbsp;el&nbsp;interior&nbsp;del&nbsp;gabinete&nbsp;limpio.</p>','\"[{\\\"nombre\\\":\\\"DISCO SOLIDO SSD 512GB M.2 ADATA LEGEND 710 PCIE GEN3\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Con este SSD 512GB M.2 ADATA LEGEND 710 PCIE GEN3 en tu PC, notar\\\\u00e1s que el sistema operativo arranca mucho m\\\\u00e1s r\\\\u00e1pido, los programas y juegos cargan en segundos, y las operaciones con archivos (abrir documentos, mover datos, guardar proyectos) se realizan con fluidez. Tu equipo dejar\\\\u00e1 de depender del almacenamiento lento: incluso con una CPU o RAM modestas, la agilidad general del sistema sube notablemente. Gracias al NVMe y PCIe Gen3, el SSD funciona sin cuellos de botella en placas actuales, aportando velocidad real en uso diario, juegos, edici\\\\u00f3n o multitarea. Con 512 GB de capacidad tienes espacio suficiente para sistema operativo + programas esenciales + algunos juegos o proyectos multimedia, lo que resulta pr\\\\u00e1ctico si buscas rendimiento sin gastar demasiado.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764792634_6930993a1e73b.jpeg\\\"]\"',NULL,'2025-12-03 20:10:34','2025-12-03 20:10:34'),(109,216,'<p>El&nbsp;Crucial&nbsp;T710&nbsp;es&nbsp;un&nbsp;SSD&nbsp;M.2&nbsp;NVMe&nbsp;de&nbsp;última&nbsp;generación&nbsp;con&nbsp;interfaz&nbsp;PCIe&nbsp;5.0&nbsp;y&nbsp;factor&nbsp;de&nbsp;forma&nbsp;2280,&nbsp;pensado&nbsp;para&nbsp;ofrecer&nbsp;velocidades&nbsp;extremas&nbsp;de&nbsp;lectura&nbsp;y&nbsp;escritura.&nbsp;Sus&nbsp;valores&nbsp;máximos&nbsp;alcanzan&nbsp;hasta&nbsp;≈&nbsp;14&nbsp;900&nbsp;MB/s&nbsp;de&nbsp;lectura&nbsp;y&nbsp;≈&nbsp;13&nbsp;800&nbsp;MB/s&nbsp;de&nbsp;escritura,&nbsp;gracias&nbsp;a&nbsp;su&nbsp;controlador&nbsp;moderno,&nbsp;memoria&nbsp;NAND&nbsp;de&nbsp;alta&nbsp;densidad&nbsp;y&nbsp;tecnología&nbsp;optimizada.&nbsp;Este&nbsp;SSD&nbsp;no&nbsp;solo&nbsp;ofrece&nbsp;velocidad&nbsp;sino&nbsp;también&nbsp;durabilidad:&nbsp;tiene&nbsp;una&nbsp;alta&nbsp;resistencia&nbsp;al&nbsp;desgaste&nbsp;(medida&nbsp;en&nbsp;TBW&nbsp;–&nbsp;terabytes&nbsp;escritos),&nbsp;soporte&nbsp;de&nbsp;cifrado&nbsp;(AES-256&nbsp;con&nbsp;TCG&nbsp;Opal&nbsp;2.01+)&nbsp;y&nbsp;firmware&nbsp;optimizado&nbsp;para&nbsp;tecnologías&nbsp;actuales&nbsp;como&nbsp;DirectStorage,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;apto&nbsp;tanto&nbsp;para&nbsp;gaming&nbsp;de&nbsp;última&nbsp;generación&nbsp;como&nbsp;para&nbsp;edición,&nbsp;renderizado,&nbsp;diseño&nbsp;o&nbsp;trabajo&nbsp;profesional.</p>','\"[{\\\"nombre\\\":\\\"DISCO DURO SSD CRUCIAL T710 2TB PCIE GEN5 NVME 2280 M.2\\\",\\\"valor\\\":\\\"CRUCIAL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO CRUCIAL\\\",\\\"detalle\\\":\\\"Si montas este SSD  T710 2TB PCIE GEN5 NVME 2280 M.2 en tu PC, tu equipo tendr\\\\u00e1 almacenamiento ultrarr\\\\u00e1pido, con lo que el sistema operativo arrancar\\\\u00e1 en segundos, los programas cargar\\\\u00e1n al instante, y juegos o proyectos pesados se ejecutar\\\\u00e1n con fluidez \\\\u2014 eliminando los tradicionales \\\\u201ccuellos de botella\\\\u201d de disco duro o SSD m\\\\u00e1s antiguos. El almacenamiento ya no ser\\\\u00e1 una limitaci\\\\u00f3n: tu CPU, RAM y GPU podr\\\\u00e1n rendir a su m\\\\u00e1ximo, ya que el SSD podr\\\\u00e1 mantener el ritmo.  Adem\\\\u00e1s, con capacidad amplia (2 TB), tendr\\\\u00e1s espacio de sobra para sistema, juegos, programas, proyectos multimedia, creaci\\\\u00f3n de contenido \\\\u2014 sin preocuparte por quedarte corto. Esto hace que tu PC sea moderna, r\\\\u00e1pida, eficiente, tanto para uso cotidiano como intensivo: gaming, edici\\\\u00f3n, render, multitarea, edici\\\\u00f3n de video\\\\\\/fotos, trabajo profesional, etc.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764793236_69309b94ced4c.jpg\\\"]\"',NULL,'2025-12-03 20:20:36','2025-12-03 20:20:36'),(110,217,NULL,'\"[{\\\"nombre\\\":\\\"DISCO SOLIDO SSD 2TB M.2 ADATA LEGEND 900 PRO NVME\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Al tener este SSD 2TB M.2 ADATA LEGEND 900 PRO NVME en tu PC, tu sistema gana agilidad real y consistencia de rendimiento: el arranque del sistema operativo ser\\\\u00e1 muy r\\\\u00e1pido, programas y juegos cargar\\\\u00e1n pr\\\\u00e1cticamente al instante, y el acceso o manipulaci\\\\u00f3n de archivos pesados ser\\\\u00e1 fluido. Los \\\\u201ccuellos de botella\\\\u201d por almacenamiento pr\\\\u00e1cticamente desaparecen, lo que permite que CPU, RAM y GPU rindan mejor \\\\u2014 especialmente si haces edici\\\\u00f3n, render, dise\\\\u00f1o, multitarea o gaming exigente.  Tendr\\\\u00e1s tambi\\\\u00e9n un espacio amplio y c\\\\u00f3modo para almacenar sistemas, software, juegos, archivos, proyectos o multimedia sin preocuparte por quedarte corto. Tu PC se siente m\\\\u00e1s moderna, receptiva y preparada para tareas intensas o profesionales, con un almacenamiento a la altura de componentes exigentes.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764793686_69309d569045b.jpg\\\"]\"',NULL,'2025-12-03 20:28:06','2025-12-03 20:28:06'),(111,218,'<p>El&nbsp;Kingston&nbsp;FURY&nbsp;Renegade&nbsp;G5&nbsp;es&nbsp;un&nbsp;SSD&nbsp;de&nbsp;última&nbsp;generación&nbsp;con&nbsp;interfaz&nbsp;PCIe&nbsp;5.0&nbsp;x4&nbsp;y&nbsp;formato&nbsp;M.2&nbsp;2280,&nbsp;pensado&nbsp;para&nbsp;quienes&nbsp;buscan&nbsp;velocidades&nbsp;extremas&nbsp;y&nbsp;gran&nbsp;capacidad.&nbsp;Su&nbsp;memoria&nbsp;flash&nbsp;3D&nbsp;TLC,&nbsp;combinada&nbsp;con&nbsp;controlador&nbsp;moderno,&nbsp;le&nbsp;permite&nbsp;alcanzar&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;14&nbsp;700&nbsp;MB/s&nbsp;y&nbsp;de&nbsp;escritura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;14&nbsp;000&nbsp;MB/s&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;2&nbsp;TB,&nbsp;cifras&nbsp;que&nbsp;lo&nbsp;sitúan&nbsp;entre&nbsp;los&nbsp;SSD&nbsp;más&nbsp;rápidos&nbsp;disponibles&nbsp;actualmente.&nbsp;Además&nbsp;de&nbsp;la&nbsp;velocidad,&nbsp;ofrece&nbsp;un&nbsp;rendimiento&nbsp;consistente&nbsp;incluso&nbsp;bajo&nbsp;carga&nbsp;intensa,&nbsp;con&nbsp;soporte&nbsp;para&nbsp;altas&nbsp;tasas&nbsp;de&nbsp;operaciones&nbsp;por&nbsp;segundo&nbsp;(IOPS),&nbsp;buena&nbsp;resistencia&nbsp;a&nbsp;desgaste&nbsp;(alto&nbsp;TBW),&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;protocolos&nbsp;modernos&nbsp;como&nbsp;NVMe&nbsp;+&nbsp;PCIe&nbsp;5.0&nbsp;—&nbsp;lo&nbsp;que&nbsp;lo&nbsp;hace&nbsp;ideal&nbsp;para&nbsp;gaming,&nbsp;edición&nbsp;de&nbsp;video/fotos,&nbsp;diseño&nbsp;3D,&nbsp;renderizado,&nbsp;software&nbsp;pesado&nbsp;o&nbsp;simplemente&nbsp;fluidez&nbsp;máxima&nbsp;en&nbsp;todo&nbsp;tipo&nbsp;de&nbsp;tareas.</p>','\"[{\\\"nombre\\\":\\\"DISCO SSD M.2 PCIe 2TB FURY RENEGADE G5 14200mb\\\\\\/S\\\",\\\"valor\\\":\\\"KINGSTON\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO KINGSTON\\\",\\\"detalle\\\":\\\"Con este SSD  2TB FURY RENEGADE G5 14200mb\\\\\\/S en tu PC, notar\\\\u00e1s que el sistema se vuelve mucho m\\\\u00e1s \\\\u00e1gil: el arranque del sistema operativo ser\\\\u00e1 casi instant\\\\u00e1neo, los programas, juegos y aplicaciones pesadas cargan muy r\\\\u00e1pido, y las tareas intensivas \\\\u2014 edici\\\\u00f3n, renderizado, compilaci\\\\u00f3n, edici\\\\u00f3n de video, trabajo con archivos grandes \\\\u2014 se realizan con fluidez.  El almacenamiento deja de ser un cuello de botella, lo que permite que CPU, RAM y GPU operen a su m\\\\u00e1ximo potencial. Tu PC se sentir\\\\u00e1 ligera, responsiva y r\\\\u00e1pida, reduciendo notablemente los tiempos de espera. Gracias al gran espacio (2 TB), puedes instalar muchos juegos, programas, guardar proyectos grandes u archivos multimedia sin preocuparte por llenar el disco pronto.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764794176_69309f40d9f5f.jpg\\\"]\"',NULL,'2025-12-03 20:36:16','2025-12-03 20:36:16'),(112,219,'<p>Este&nbsp;SSD&nbsp;es&nbsp;una&nbsp;unidad&nbsp;de&nbsp;estado&nbsp;sólido&nbsp;M.2&nbsp;con&nbsp;interfaz&nbsp;NVMe&nbsp;PCIe&nbsp;5.0&nbsp;x4,&nbsp;una&nbsp;de&nbsp;las&nbsp;tecnologías&nbsp;más&nbsp;avanzadas&nbsp;actualmente&nbsp;para&nbsp;almacenamiento.&nbsp;Ofrece&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;y&nbsp;escritura&nbsp;extremadamente&nbsp;altas&nbsp;—&nbsp;ideales&nbsp;para&nbsp;reducir&nbsp;al&nbsp;mínimo&nbsp;los&nbsp;tiempos&nbsp;de&nbsp;espera&nbsp;en&nbsp;carga&nbsp;de&nbsp;sistema,&nbsp;programas&nbsp;o&nbsp;juegos.&nbsp;Su&nbsp;memoria&nbsp;3D&nbsp;TLC&nbsp;y&nbsp;controlador&nbsp;moderno&nbsp;(SM2508)&nbsp;están&nbsp;optimizados&nbsp;para&nbsp;mantener&nbsp;un&nbsp;rendimiento&nbsp;alto&nbsp;incluso&nbsp;bajo&nbsp;uso&nbsp;intensivo,&nbsp;manejando&nbsp;grandes&nbsp;transferencias&nbsp;de&nbsp;datos,&nbsp;instalación&nbsp;de&nbsp;software&nbsp;pesado,&nbsp;edición,&nbsp;render&nbsp;o&nbsp;multitarea&nbsp;sin&nbsp;cuellos&nbsp;de&nbsp;botella.</p>','\"[{\\\"nombre\\\":\\\"DISCO SSD M.2 PCIe 1TB FURY RENEGADE G5 14200mb\\\\\\/S\\\",\\\"valor\\\":\\\"KINGSTON\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO KINGSTON\\\",\\\"detalle\\\":\\\"Si montas este SSD 1TB FURY RENEGADE G5 14200mb\\\\\\/S en tu PC, notar\\\\u00e1s que todo funciona con mucha m\\\\u00e1s fluidez: el sistema operativo arrancar\\\\u00e1 muy r\\\\u00e1pido, los programas y juegos cargar\\\\u00e1n casi al instante, y las operaciones con archivos grandes o m\\\\u00faltiples ser\\\\u00e1n \\\\u00e1giles. El almacenamiento deja de ser un cuello de botella, lo que permite que CPU, RAM y GPU trabajen a su m\\\\u00e1ximo rendimiento, especialmente si ejecutas tareas exigentes como edici\\\\u00f3n, renderizado, compilaci\\\\u00f3n o juegos pesados. Gracias a su dise\\\\u00f1o y velocidad, tu PC se siente m\\\\u00e1s \\\\u201cmoderna\\\\u201d: responsiva, r\\\\u00e1pida y eficiente \\\\u2014 ideal para usuarios exigentes que buscan potencia, estabilidad y velocidad real.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764794623_6930a0ff0015e.jpg\\\"]\"',NULL,'2025-12-03 20:43:43','2025-12-03 20:43:43'),(113,220,'<p>El&nbsp;Lexar&nbsp;NM790&nbsp;es&nbsp;un&nbsp;SSD&nbsp;moderno&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;con&nbsp;interfaz&nbsp;PCIe&nbsp;Gen4×4&nbsp;y&nbsp;protocolo&nbsp;NVMe,&nbsp;pensado&nbsp;para&nbsp;ofrecer&nbsp;almacenamiento&nbsp;ultrarrápido&nbsp;con&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;7400&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;de&nbsp;hasta&nbsp;~&nbsp;6500&nbsp;MB/s.&nbsp;Utiliza&nbsp;memoria&nbsp;3D&nbsp;TLC&nbsp;y&nbsp;un&nbsp;controlador&nbsp;eficiente&nbsp;(sin&nbsp;DRAM&nbsp;dedicada&nbsp;—&nbsp;usa&nbsp;HMB&nbsp;3.0&nbsp;+&nbsp;caché&nbsp;SLC&nbsp;dinámica&nbsp;para&nbsp;mantener&nbsp;un&nbsp;buen&nbsp;rendimiento)&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;equilibrar&nbsp;velocidad,&nbsp;eficiencia&nbsp;energética&nbsp;y&nbsp;costo.&nbsp;Está&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;rendimiento&nbsp;muy&nbsp;alto&nbsp;en&nbsp;tareas&nbsp;intensivas,&nbsp;carga&nbsp;rápida&nbsp;de&nbsp;datos,&nbsp;instalación&nbsp;veloz&nbsp;de&nbsp;programas/juegos,&nbsp;y&nbsp;tiempos&nbsp;de&nbsp;respuesta&nbsp;mínimos&nbsp;en&nbsp;general.Además&nbsp;su&nbsp;formato&nbsp;M.2&nbsp;lo&nbsp;hace&nbsp;compacto&nbsp;y&nbsp;fácil&nbsp;de&nbsp;instalar&nbsp;en&nbsp;placas&nbsp;madre&nbsp;modernas&nbsp;con&nbsp;ranura&nbsp;NVMe,&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;cables&nbsp;de&nbsp;datos&nbsp;o&nbsp;alimentación&nbsp;aparte.</p>','\"[{\\\"nombre\\\":\\\"SSD M.2 NVMe LEXAR NM790 2TB 7400MBPS GEN4 AST\\\",\\\"valor\\\":\\\"LEXAR\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO LEXAR\\\",\\\"detalle\\\":\\\"Al usar este SSD NM790 2TB 7400MBPS GEN4 AST en tu PC, tu sistema se vuelve mucho m\\\\u00e1s \\\\u00e1gil y responsivo: el sistema operativo arrancar\\\\u00e1 casi inmediatamente, los programas y juegos cargar\\\\u00e1n con gran rapidez, y cualquier operaci\\\\u00f3n de lectura\\\\\\/escritura de archivos se realizar\\\\u00e1 en fracciones de segundo en comparaci\\\\u00f3n con discos tradicionales o SSD antiguos. El almacenamiento deja de ser un cuello de botella, lo que permite que CPU, RAM y GPU trabajen sin limitaciones \\\\u2014 ideal si haces edici\\\\u00f3n, dise\\\\u00f1o, render, gaming, edici\\\\u00f3n de video o tareas pesadas. Con 2 TB de capacidad tendr\\\\u00e1s espacio amplio para sistema, juegos, programas, proyectos y archivos pesados \\\\u2014 suficiente para muchos a\\\\u00f1os sin preocuparte por falta de espacio. Tu PC ganar\\\\u00e1 en fluidez, eficiencia y comodidad: sentir\\\\u00e1s una notable mejora en velocidad de respuesta, carga de aplicaciones y manejo de datos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764795354_6930a3dac4c23.jpg\\\"]\"',NULL,'2025-12-03 20:55:54','2025-12-03 20:55:54'),(114,221,'<p>El&nbsp;MP700&nbsp;Elite&nbsp;es&nbsp;un&nbsp;SSD&nbsp;de&nbsp;nueva&nbsp;generación&nbsp;que&nbsp;usa&nbsp;interfaz&nbsp;PCIe&nbsp;5.0&nbsp;x4&nbsp;+&nbsp;NVMe&nbsp;2.0&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;pone&nbsp;en&nbsp;la&nbsp;vanguardia&nbsp;del&nbsp;almacenamiento,&nbsp;Su&nbsp;diseño&nbsp;prioriza&nbsp;velocidad&nbsp;extrema:&nbsp;ofrece&nbsp;hasta&nbsp;10&nbsp;000&nbsp;MB/s&nbsp;de&nbsp;lectura&nbsp;secuencial&nbsp;y&nbsp;8&nbsp;500&nbsp;MB/s&nbsp;de&nbsp;escritura&nbsp;según&nbsp;especificaciones&nbsp;oficiales.&nbsp;Usa&nbsp;memoria&nbsp;3D&nbsp;TLC&nbsp;NAND&nbsp;con&nbsp;controlador&nbsp;moderno,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;un&nbsp;balance&nbsp;entre&nbsp;rendimiento,&nbsp;durabilidad&nbsp;y&nbsp;eficiencia&nbsp;energética.</p>','\"[{\\\"nombre\\\":\\\"SSD M.2 NVMe CORSAIR MP700 ELITE 1TB 10000MBPS GEN5\\\",\\\"valor\\\":\\\"CORSAIR\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO CORSAIR\\\",\\\"detalle\\\":\\\"Si instalas este SSD MP700 ELITE 1TB 10000MBPS GEN5 en tu PC, el sistema se convierte en una m\\\\u00e1quina mucho m\\\\u00e1s \\\\u00e1gil: el sistema operativo arrancar\\\\u00e1 en segundos, los juegos y programas pesados cargar\\\\u00e1n casi al instante, y los tiempos de espera al abrir, guardar o mover archivos ser\\\\u00e1n m\\\\u00ednimos. El almacenamiento deja de ser l\\\\u00edmite \\\\u2014 CPU, RAM y GPU podr\\\\u00e1n rendir mejor, especialmente en edici\\\\u00f3n, dise\\\\u00f1o, renderizado, multitarea o juegos exigentes.  Con 1 TB de espacio tienes lugar m\\\\u00e1s que suficiente para sistema operativo, aplicaciones, juegos y proyectos multimedia, manteniendo tu equipo vers\\\\u00e1til y actualizado. Tu PC se siente m\\\\u00e1s moderna, responsiva y capaz, lista para exigencias actuales y futuras sin preocuparte por lentitud de disco.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764795921_6930a61116290.png\\\"]\"',NULL,'2025-12-03 21:05:21','2025-12-03 21:05:21'),(115,222,'<p>El&nbsp;Vulcan&nbsp;Z&nbsp;2TB&nbsp;es&nbsp;un&nbsp;disco&nbsp;de&nbsp;estado&nbsp;sólido&nbsp;(SSD)&nbsp;en&nbsp;formato&nbsp;tradicional&nbsp;2.5″&nbsp;con&nbsp;interfaz&nbsp;SATA&nbsp;III.&nbsp;Utiliza&nbsp;memoria&nbsp;3D&nbsp;NAND&nbsp;(normalmente&nbsp;TLC),&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;una&nbsp;vida&nbsp;útil&nbsp;aceptable&nbsp;en&nbsp;comparación&nbsp;a&nbsp;discos&nbsp;mecánicos.&nbsp;Su&nbsp;velocidad&nbsp;de&nbsp;lectura&nbsp;secuencial&nbsp;ronda&nbsp;los&nbsp;~&nbsp;550&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;alrededor&nbsp;de&nbsp;~&nbsp;500&nbsp;MB/s.&nbsp;No&nbsp;usa&nbsp;interfaz&nbsp;NVMe&nbsp;ni&nbsp;PCIe&nbsp;—&nbsp;por&nbsp;lo&nbsp;que&nbsp;no&nbsp;alcanza&nbsp;las&nbsp;velocidades&nbsp;extremas&nbsp;de&nbsp;los&nbsp;SSD&nbsp;M.2&nbsp;modernos&nbsp;—&nbsp;pero&nbsp;ofrece&nbsp;un&nbsp;salto&nbsp;grande&nbsp;respecto&nbsp;a&nbsp;un&nbsp;disco&nbsp;duro&nbsp;clásico:&nbsp;tiempos&nbsp;de&nbsp;arranque,&nbsp;carga&nbsp;de&nbsp;programas&nbsp;o&nbsp;sistema&nbsp;operativo,&nbsp;y&nbsp;apertura&nbsp;de&nbsp;archivos&nbsp;serán&nbsp;visiblemente&nbsp;más&nbsp;rápidos.&nbsp;La&nbsp;unidad&nbsp;es&nbsp;resistente&nbsp;a&nbsp;golpes&nbsp;y&nbsp;vibraciones&nbsp;(mejor&nbsp;que&nbsp;un&nbsp;HDD&nbsp;mecánico),&nbsp;con&nbsp;menor&nbsp;consumo&nbsp;y&nbsp;ruido,&nbsp;lo&nbsp;que&nbsp;mejora&nbsp;la&nbsp;confiabilidad&nbsp;y&nbsp;comodidad&nbsp;del&nbsp;sistema.</p>','\"[{\\\"nombre\\\":\\\"DISCO SSD 2.5 T-FORCE VULCAN Z 2TB\\\",\\\"valor\\\":\\\"T-FORCE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO T-FORCE\\\",\\\"detalle\\\":\\\"Si instalas este SSD 2.5 T-FORCE VULCAN Z 2TB en tu PC, notar\\\\u00e1s que el sistema arranca m\\\\u00e1s r\\\\u00e1pido, los programas cargan \\\\u00e1gilmente y la navegaci\\\\u00f3n entre aplicaciones es m\\\\u00e1s fluida. Las esperas que hab\\\\u00eda con un disco duro \\\\u2014 al abrir sistema operativo, programas pesados, juegos o al guardar\\\\\\/leer archivos grandes \\\\u2014 se acortan considerablemente. Con 2 TB tienes espacio amplio para sistema + programas + juegos + almacenamiento de archivos, sin preocuparte tanto por quedarte corto.  Tu PC se vuelve m\\\\u00e1s responsiva, c\\\\u00f3moda y pr\\\\u00e1ctica para uso general, edici\\\\u00f3n ligera, oficina, multimedia o gaming moderado. Puede ser una buena base si buscas una mejora clara sin gastar demasiado.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764796671_6930a8ff04eac.jpg\\\"]\"',NULL,'2025-12-03 21:17:51','2025-12-03 21:17:51'),(116,223,'<p>El&nbsp;Samsung&nbsp;9100&nbsp;PRO&nbsp;es&nbsp;un&nbsp;SSD&nbsp;de&nbsp;muy&nbsp;alto&nbsp;rendimiento&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;usa&nbsp;la&nbsp;interfaz&nbsp;PCIe&nbsp;5.0&nbsp;x4&nbsp;con&nbsp;protocolo&nbsp;NVMe&nbsp;2.0,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;posiciona&nbsp;en&nbsp;la&nbsp;punta&nbsp;de&nbsp;la&nbsp;tecnología&nbsp;de&nbsp;almacenamiento.&nbsp;Este&nbsp;modelo&nbsp;es&nbsp;capaz&nbsp;de&nbsp;alcanzar&nbsp;velocidades&nbsp;secuenciales&nbsp;de&nbsp;lectura&nbsp;muy&nbsp;altas&nbsp;—&nbsp;hasta&nbsp;~&nbsp;14&nbsp;800&nbsp;MB/s&nbsp;—&nbsp;y&nbsp;de&nbsp;escritura&nbsp;de&nbsp;~&nbsp;13&nbsp;400&nbsp;MB/s&nbsp;en&nbsp;condiciones&nbsp;óptimas.&nbsp;Su&nbsp;arquitectura&nbsp;incluye&nbsp;memoria&nbsp;NAND&nbsp;de&nbsp;última&nbsp;generación,&nbsp;controlador&nbsp;avanzado&nbsp;y&nbsp;soporte&nbsp;de&nbsp;NVMe,&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;manejar&nbsp;tanto&nbsp;transferencias&nbsp;grandes&nbsp;como&nbsp;cargas&nbsp;intensivas&nbsp;de&nbsp;datos:&nbsp;ideal&nbsp;para&nbsp;juegos&nbsp;pesados,&nbsp;edición&nbsp;de&nbsp;video,&nbsp;renderizado,&nbsp;proyectos&nbsp;multimedia,&nbsp;trabajo&nbsp;profesional&nbsp;o&nbsp;cargas&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"UNIDAD SSD M.2 1TB SAMSUNG 9100 PRO 14700 MB\\\\\\/S GEN 5\\\",\\\"valor\\\":\\\"SAMSUNG\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO SAMSUNG\\\",\\\"detalle\\\":\\\"Si instalas el 9100 PRO en tu PC, el almacenamiento deja de ser un l\\\\u00edmite: el sistema operativo arrancar\\\\u00e1 en segundos, programas, juegos y aplicaciones pesadas cargar\\\\u00e1n casi al instante, y la manipulaci\\\\u00f3n de archivos grandes o proyectos demandantes ser\\\\u00e1 fluida sin esperas notables. La capacidad de respuesta del equipo mejora enormemente, porque el SSD trabaja a velocidades que permiten que la CPU, RAM y GPU operen sin cuellos de botella cuando lo que falla suele ser el disco. Tu PC pasar\\\\u00e1 a sentirse moderna, veloz y preparada para tareas intensivas: edici\\\\u00f3n de video\\\\\\/fotograf\\\\u00eda, dise\\\\u00f1o, modelado, render, multitarea extrema, gaming exigente, etc. Si haces trabajos pesados, proyectos grandes o simplemente buscas que tu sistema sea \\\\u201ca prueba de futuro\\\\u201d, este SSD pone el almacenamiento a la altura del resto de componentes. Adem\\\\u00e1s, con 1 TB tienes un buen equilibrio entre espacio para sistema, software, juegos o archivos, sin necesidad de almacenamiento extra inmediato.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764797347_6930aba3d4c8a.jpg\\\"]\"',NULL,'2025-12-03 21:29:07','2025-12-03 21:29:07'),(117,224,'<p>El&nbsp;MSI&nbsp;SPATIUM&nbsp;M560&nbsp;es&nbsp;un&nbsp;SSD&nbsp;de&nbsp;última&nbsp;generación&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;con&nbsp;interfaz&nbsp;PCIe&nbsp;5.0&nbsp;x4&nbsp;y&nbsp;protocolo&nbsp;NVMe&nbsp;2.0,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;almacenamiento&nbsp;ultrarrápido&nbsp;con&nbsp;memorias&nbsp;3D&nbsp;NAND.&nbsp;Este&nbsp;SSD&nbsp;logra&nbsp;velocidades&nbsp;secuenciales&nbsp;de&nbsp;lectura&nbsp;muy&nbsp;elevadas&nbsp;—&nbsp;hasta&nbsp;~10&nbsp;200&nbsp;MB/s&nbsp;—&nbsp;y&nbsp;escritura&nbsp;alrededor&nbsp;de&nbsp;~8&nbsp;400&nbsp;MB/s,&nbsp;lo&nbsp;que&nbsp;representa&nbsp;un&nbsp;salto&nbsp;importante&nbsp;respecto&nbsp;a&nbsp;SSD&nbsp;más&nbsp;antiguos&nbsp;o&nbsp;discos&nbsp;duros,&nbsp;Internamente,&nbsp;utiliza&nbsp;un&nbsp;controlador&nbsp;moderno,&nbsp;soporta&nbsp;correcciones&nbsp;de&nbsp;errores&nbsp;(ECC&nbsp;/&nbsp;LDPC),&nbsp;funciones&nbsp;de&nbsp;mantenimiento&nbsp;de&nbsp;salud&nbsp;(SMART,&nbsp;TRIM)&nbsp;y&nbsp;ofrece&nbsp;buena&nbsp;durabilidad&nbsp;(alto&nbsp;TBW&nbsp;/&nbsp;MTBF),&nbsp;atributos&nbsp;que&nbsp;buscan&nbsp;equilibrio&nbsp;entre&nbsp;rendimiento,&nbsp;confiabilidad&nbsp;y&nbsp;longevidad.</p>','\"[{\\\"nombre\\\":\\\"SSD MSI SPATIUM M560, 1TB M.2 PCIe 5.0 NVMe\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO MSI\\\",\\\"detalle\\\":\\\"Al instalar este SSD SPATIUM M560, 1TB M.2 PCIe 5.0 NVMe, tu PC ganar\\\\u00e1 agilidad real: el sistema operativo arrancar\\\\u00e1 mucho m\\\\u00e1s r\\\\u00e1pido, los programas y juegos cargar\\\\u00e1n en segundos, y la carga o manipulaci\\\\u00f3n de archivos pesados ser\\\\u00e1 fluida. El almacenamiento deja de ser un cuello de botella, permitiendo que CPU, RAM y GPU rindan mejor cuando trabajan en conjunto, especialmente en tareas exigentes como edici\\\\u00f3n, render, juegos pesados o multitarea intensiva.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764797818_6930ad7a21e24.png\\\"]\"',NULL,'2025-12-03 21:36:58','2025-12-03 21:36:58'),(118,225,'<p>Un&nbsp;SSD&nbsp;M.2&nbsp;NVMe&nbsp;de&nbsp;500&nbsp;GB&nbsp;&quot;ROG&nbsp;GAMING&nbsp;X&quot;&nbsp;es&nbsp;un&nbsp;disco&nbsp;de&nbsp;estado&nbsp;sólido&nbsp;de&nbsp;alto&nbsp;rendimiento,&nbsp;optimizado&nbsp;para&nbsp;juegos,&nbsp;con&nbsp;interfaz&nbsp;NVMe&nbsp;y&nbsp;conector&nbsp;M.2,&nbsp;que&nbsp;ofrece&nbsp;velocidades&nbsp;de&nbsp;transferencia&nbsp;rápidas&nbsp;para&nbsp;un&nbsp;sistema&nbsp;más&nbsp;ágil&nbsp;y&nbsp;tiempos&nbsp;de&nbsp;carga&nbsp;más&nbsp;cortos.&nbsp;Su&nbsp;capacidad&nbsp;de&nbsp;500&nbsp;GB&nbsp;proporciona&nbsp;espacio&nbsp;para&nbsp;juegos&nbsp;y&nbsp;archivos,&nbsp;mientras&nbsp;que&nbsp;sus&nbsp;características&nbsp;como&nbsp;la&nbsp;tecnología&nbsp;de&nbsp;refrigeración&nbsp;y&nbsp;la&nbsp;durabilidad&nbsp;lo&nbsp;hacen&nbsp;ideal&nbsp;para&nbsp;PC&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;y&nbsp;portátiles&nbsp;gaming.</p>','\"[{\\\"nombre\\\":\\\"DISCO SOLIDO SSD 500GB ROG GAMING X M.2 NVME PCIE\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ASUS\\\",\\\"detalle\\\":\\\"SSD M.2 NVMe de 500 GB ROG Gaming es una unidad de almacenamiento de alto rendimiento para PC, ideal para gamers y usuarios exigentes. Su tecnolog\\\\u00eda NVMe PCIe Gen3x4 ofrece velocidades de transferencia de datos ultrarr\\\\u00e1pidas, reduciendo los tiempos de carga de juegos y aplicaciones, y mejora la respuesta general del sistema. Con 500 GB, proporciona espacio suficiente para el sistema operativo, varios juegos y programas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764798322_6930af725ac7c.jpg\\\"]\"',NULL,'2025-12-03 21:45:22','2025-12-03 21:45:22'),(119,226,'<p>El&nbsp;Legend&nbsp;860&nbsp;es&nbsp;un&nbsp;SSD&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280&nbsp;que&nbsp;emplea&nbsp;la&nbsp;interfaz&nbsp;moderna&nbsp;PCIe&nbsp;4.0&nbsp;x4&nbsp;+&nbsp;NVMe&nbsp;—&nbsp;lo&nbsp;que&nbsp;le&nbsp;permite&nbsp;un&nbsp;ancho&nbsp;de&nbsp;banda&nbsp;muy&nbsp;superior&nbsp;al&nbsp;de&nbsp;discos&nbsp;tradicionales&nbsp;o&nbsp;SSD&nbsp;SATA,&nbsp;Con&nbsp;sus&nbsp;memorias&nbsp;3D&nbsp;NAND&nbsp;y&nbsp;controlador&nbsp;optimizado,&nbsp;está&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;equilibrio&nbsp;entre&nbsp;velocidad,&nbsp;capacidad&nbsp;y&nbsp;durabilidad:&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;2&nbsp;TB&nbsp;da&nbsp;suficiente&nbsp;espacio&nbsp;para&nbsp;sistema&nbsp;operativo,&nbsp;programas,&nbsp;juegos&nbsp;y&nbsp;archivos&nbsp;pesados&nbsp;sin&nbsp;preocuparte&nbsp;por&nbsp;quedarte&nbsp;corto.&nbsp;La&nbsp;velocidad&nbsp;declarada&nbsp;de&nbsp;lectura&nbsp;secuencial&nbsp;de&nbsp;hasta&nbsp;~&nbsp;6000&nbsp;MB/s&nbsp;(y&nbsp;escritura&nbsp;hasta&nbsp;~&nbsp;5000&nbsp;MB/s)&nbsp;coloca&nbsp;a&nbsp;esta&nbsp;unidad&nbsp;en&nbsp;un&nbsp;rango&nbsp;de&nbsp;rendimiento&nbsp;alto/moderno,&nbsp;ideal&nbsp;para&nbsp;que&nbsp;el&nbsp;almacenamiento&nbsp;no&nbsp;sea&nbsp;un&nbsp;cuello&nbsp;de&nbsp;botella.</p>','\"[{\\\"nombre\\\":\\\"DISCO SOLIDO SSD 2TB M.2 ADATA LEGEND 860 NVME\\\\\\/ 6000\\\\\\/MB\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO ADATA\\\",\\\"detalle\\\":\\\"Si colocas este SSD SSD 2TB M.2 ADATA LEGEND 860 NVME\\\\\\/ 6000\\\\\\/MB, tu sistema gana agilidad real: arranque del sistema y carga de programas ser\\\\u00e1n r\\\\u00e1pidos, abrir y guardar archivos pesados o m\\\\u00faltiples ser\\\\u00e1 fluido, y juegos o softwares exigentes cargar\\\\u00e1n con mucha menor latencia. El almacenamiento deja de ser un limitante, lo que permite que CPU, RAM y GPU rindan mejor en conjunto \\\\u2014 \\\\u00fatil si haces edici\\\\u00f3n, render, edici\\\\u00f3n de video\\\\\\/foto, multitarea intensiva o gaming exigente. Con 2 TB de capacidad, tienes espacio sobrante para sistema operativo, programas, juegos, proyectos grandes o archivos multimedia sin necesidad de discos extra.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764798939_6930b1db5a9f6.jpg\\\"]\"',NULL,'2025-12-03 21:55:39','2025-12-03 21:55:39'),(120,227,'<p>El&nbsp;A400&nbsp;es&nbsp;un&nbsp;SSD&nbsp;de&nbsp;formato&nbsp;tradicional&nbsp;de&nbsp;2.5&quot;&nbsp;con&nbsp;interfaz&nbsp;SATA&nbsp;III,&nbsp;diseñado&nbsp;como&nbsp;una&nbsp;mejora&nbsp;directa&nbsp;frente&nbsp;a&nbsp;un&nbsp;disco&nbsp;duro&nbsp;mecánico,&nbsp;Este&nbsp;SSD&nbsp;utiliza&nbsp;memoria&nbsp;NAND&nbsp;3D&nbsp;y&nbsp;ofrece&nbsp;velocidades&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;~500&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;hasta&nbsp;~450&nbsp;MB/s&nbsp;en&nbsp;su&nbsp;versión&nbsp;de&nbsp;480&nbsp;GB,&nbsp;lo&nbsp;que&nbsp;resulta&nbsp;un&nbsp;importante&nbsp;salto&nbsp;en&nbsp;velocidad&nbsp;comparado&nbsp;con&nbsp;discos&nbsp;duros&nbsp;antiguos.&nbsp;Al&nbsp;no&nbsp;tener&nbsp;partes&nbsp;móviles,&nbsp;su&nbsp;funcionamiento&nbsp;es&nbsp;más&nbsp;silencioso,&nbsp;resistente&nbsp;a&nbsp;golpes&nbsp;o&nbsp;vibraciones,&nbsp;consume&nbsp;poca&nbsp;energía&nbsp;y&nbsp;genera&nbsp;menos&nbsp;calor&nbsp;—&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;durabilidad,&nbsp;confiabilidad&nbsp;y&nbsp;estabilidad&nbsp;para&nbsp;uso&nbsp;diario,&nbsp;tanto&nbsp;en&nbsp;laptops&nbsp;como&nbsp;PCs&nbsp;de&nbsp;escritorio.</p>','\"[{\\\"nombre\\\":\\\"SSD KINGSTON A400 480GB SATA 2.5\\\\\\\"\\\",\\\"valor\\\":\\\"KINGSTON\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO KINGSTON\\\",\\\"detalle\\\":\\\"Si instalas este SSD  A400 480GB SATA 2.5\\\\\\\", tu sistema ganar\\\\u00e1 agilidad real: el sistema operativo arrancar\\\\u00e1 mucho m\\\\u00e1s r\\\\u00e1pido, los programas cargar\\\\u00e1n con fluidez y la apertura o guardado de archivos ser\\\\u00e1 m\\\\u00e1s veloz comparado con discos mec\\\\u00e1nicos. Los tiempos de espera desaparecer\\\\u00e1n en muchas tareas cotidianas \\\\u2014 navegaci\\\\u00f3n, ofim\\\\u00e1tica, multimedia o edici\\\\u00f3n ligera \\\\u2014 mejorando la experiencia general.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764799403_6930b3abd974e.jpg\\\"]\"',NULL,'2025-12-03 22:03:23','2025-12-03 22:03:23'),(121,228,'<p>El&nbsp;990&nbsp;PRO&nbsp;2&nbsp;TB&nbsp;es&nbsp;un&nbsp;SSD&nbsp;interno&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;que&nbsp;usa&nbsp;la&nbsp;interfaz&nbsp;PCIe&nbsp;4.0&nbsp;x4&nbsp;+&nbsp;NVMe&nbsp;2.0&nbsp;en&nbsp;formato&nbsp;M.2&nbsp;2280.&nbsp;Gracias&nbsp;a&nbsp;su&nbsp;diseño&nbsp;con&nbsp;memoria&nbsp;V-NAND&nbsp;y&nbsp;controlador&nbsp;propietario,&nbsp;ofrece&nbsp;velocidades&nbsp;secuenciales&nbsp;de&nbsp;lectura&nbsp;de&nbsp;hasta&nbsp;≈&nbsp;7&nbsp;450&nbsp;MB/s&nbsp;y&nbsp;escritura&nbsp;hasta&nbsp;≈&nbsp;6&nbsp;900&nbsp;MB/s,&nbsp;lo&nbsp;que&nbsp;lo&nbsp;coloca&nbsp;entre&nbsp;los&nbsp;SSD&nbsp;más&nbsp;rápidos&nbsp;disponibles&nbsp;actualmente&nbsp;para&nbsp;PCs,&nbsp;Estos&nbsp;datos&nbsp;implican&nbsp;que&nbsp;el&nbsp;flujo&nbsp;de&nbsp;información&nbsp;entre&nbsp;almacenamiento,&nbsp;memoria&nbsp;y&nbsp;CPU/pila&nbsp;interna&nbsp;del&nbsp;equipo&nbsp;será&nbsp;extremadamente&nbsp;fluido,&nbsp;minimizando&nbsp;demoras&nbsp;y&nbsp;pérdidas&nbsp;de&nbsp;rendimiento&nbsp;por&nbsp;“cuellos&nbsp;de&nbsp;botella”&nbsp;en&nbsp;disco.&nbsp;El&nbsp;formato&nbsp;M.2&nbsp;hace&nbsp;que&nbsp;el&nbsp;SSD&nbsp;sea&nbsp;compacto&nbsp;y&nbsp;fácil&nbsp;de&nbsp;instalar&nbsp;directamente&nbsp;en&nbsp;la&nbsp;placa&nbsp;madre,&nbsp;sin&nbsp;cables&nbsp;de&nbsp;datos&nbsp;ni&nbsp;alimentación&nbsp;extra&nbsp;—&nbsp;lo&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;el&nbsp;interior&nbsp;del&nbsp;gabinete&nbsp;ordenado&nbsp;y&nbsp;simplifica&nbsp;el&nbsp;ensamblado,&nbsp;Además,&nbsp;la&nbsp;versión&nbsp;de&nbsp;2&nbsp;TB&nbsp;te&nbsp;ofrece&nbsp;un&nbsp;espacio&nbsp;generoso&nbsp;para&nbsp;sistema&nbsp;operativo,&nbsp;programas,&nbsp;juegos,&nbsp;edición,&nbsp;multimedia&nbsp;o&nbsp;proyectos,&nbsp;eliminando&nbsp;con&nbsp;holgura&nbsp;la&nbsp;necesidad&nbsp;de&nbsp;discos&nbsp;adicionales&nbsp;si&nbsp;buscas&nbsp;capacidad&nbsp;+&nbsp;rapidez.</p>','\"[{\\\"nombre\\\":\\\"SSD M.2 NVMe SAMSUNG 990 PRO 2TB 7450MBPS GEN4 AST\\\",\\\"valor\\\":\\\"SAMSUNG\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"DISCO SAMSUNG\\\",\\\"detalle\\\":\\\"Con este SSD 990 PRO 2TB 7450MBPS GEN4 AST instalado, tu PC pasa a sentirse radicalmente m\\\\u00e1s r\\\\u00e1pida y responsiva: el sistema operativo arrancar\\\\u00e1 en segundos, las aplicaciones se abrir\\\\u00e1n al instante, los juegos cargar\\\\u00e1n m\\\\u00e1s r\\\\u00e1pido y las transferencias o cargas de archivos pesados dejar\\\\u00e1n de ser un problema. El almacenamiento ya no ser\\\\u00e1 un l\\\\u00edmite \\\\u2014 permitiendo que CPU, RAM y GPU rindan a su m\\\\u00e1ximo potencial, especialmente en tareas exigentes como edici\\\\u00f3n, render, multitarea, dise\\\\u00f1o, compilaciones, etc.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764800364_6930b76c6d6e1.jpg\\\"]\"',NULL,'2025-12-03 22:19:24','2025-12-03 22:19:24'),(122,229,NULL,'\"[{\\\"nombre\\\":\\\"MEMORIA RAM SODIMM ADATA DDR5 8GB 5600MHZ\\\",\\\"valor\\\":\\\"ADATA\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM ADATA \\\",\\\"detalle\\\":\\\"Si instalas esta memoria SODIMM ADATA DDR5 8GB 5600MHZ en tu PC (si es compatible con DDR5 y formato SODIMM), notar\\\\u00e1s una mejora en la agilidad del sistema: programas, navegador y sistema operativo responder\\\\u00e1n m\\\\u00e1s r\\\\u00e1pido, y la carga de tareas ser\\\\u00e1 m\\\\u00e1s fluida. Para tareas de multitarea ligera a moderada, edici\\\\u00f3n, ofim\\\\u00e1tica, navegaci\\\\u00f3n, y uso diario, la experiencia ser\\\\u00e1 m\\\\u00e1s c\\\\u00f3moda y sin cuellos de botella por RAM.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764801031_6930ba07b7fdb.jpg\\\"]\"',NULL,'2025-12-03 22:30:31','2025-12-03 22:30:31'),(123,230,'<p>La&nbsp;XPG&nbsp;LANCER&nbsp;Blade&nbsp;RGB&nbsp;DDR5&nbsp;es&nbsp;una&nbsp;memoria&nbsp;RAM&nbsp;de&nbsp;nueva&nbsp;generación&nbsp;—&nbsp;DDR5&nbsp;—&nbsp;con&nbsp;capacidad&nbsp;de&nbsp;32&nbsp;GB&nbsp;(generalmente&nbsp;en&nbsp;kit&nbsp;2×16&nbsp;GB),&nbsp;diseñada&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;alto&nbsp;rendimiento,&nbsp;estabilidad&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;PCs&nbsp;modernas.&nbsp;Su&nbsp;diseño&nbsp;incluye&nbsp;un&nbsp;disipador&nbsp;de&nbsp;perfil&nbsp;bajo&nbsp;que&nbsp;facilita&nbsp;su&nbsp;instalación&nbsp;incluso&nbsp;en&nbsp;gabinetes&nbsp;compactos,&nbsp;sin&nbsp;interferir&nbsp;con&nbsp;disipadores&nbsp;grandes&nbsp;de&nbsp;CPU,&nbsp;Opera&nbsp;a&nbsp;frecuencias&nbsp;altas&nbsp;(tipos&nbsp;entre&nbsp;5600&nbsp;MHz,&nbsp;6000&nbsp;MHz&nbsp;o&nbsp;más,&nbsp;dependiendo&nbsp;del&nbsp;modelo&nbsp;exacto),&nbsp;lo&nbsp;que&nbsp;permite&nbsp;que&nbsp;la&nbsp;comunicación&nbsp;entre&nbsp;RAM&nbsp;y&nbsp;CPU&nbsp;sea&nbsp;muy&nbsp;ágil&nbsp;—&nbsp;esto&nbsp;acelera&nbsp;tareas,&nbsp;reduce&nbsp;tiempos&nbsp;de&nbsp;espera&nbsp;y&nbsp;mejora&nbsp;el&nbsp;desempeño&nbsp;general.&nbsp;La&nbsp;memoria&nbsp;incorpora&nbsp;corrección&nbsp;de&nbsp;errores&nbsp;interna&nbsp;(On-die&nbsp;ECC)&nbsp;y&nbsp;gestión&nbsp;eficiente&nbsp;de&nbsp;energía,&nbsp;lo&nbsp;que&nbsp;añade&nbsp;estabilidad,&nbsp;fiabilidad&nbsp;y&nbsp;eficiencia&nbsp;energética&nbsp;comparada&nbsp;con&nbsp;generaciones&nbsp;anteriores</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 32GB DDR5 XPG LANCER RGB BLADE BLACK\\\",\\\"valor\\\":\\\"XPG\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM XPG\\\",\\\"detalle\\\":\\\"Si usas esta memoria  32GB DDR5 XPG LANCER RGB BLADE BLACK en tu PC, obtendr\\\\u00e1s un sistema m\\\\u00e1s fluido, r\\\\u00e1pido y preparado para tareas exigentes. El sistema operativo, programas, edici\\\\u00f3n, renderizado, dise\\\\u00f1o, multitarea pesada o juegos agradecer\\\\u00e1n la mayor velocidad y capacidad de esta RAM \\\\u2014 ver\\\\u00e1s mejoras claras en tiempos de carga, cambios entre tareas y estabilidad bajo carga.  La compatibilidad con perfiles autom\\\\u00e1ticos de overclocking significa que, con solo activarlos, sacas lo m\\\\u00e1ximo a la RAM sin complicaciones \\\\u2014 ideal si no quieres \\\\u201ctocar BIOS\\\\u201d manualmente. El soporte de correcci\\\\u00f3n de errores ayuda a la estabilidad en el largo plazo, reduciendo posibilidades de crash o corrupci\\\\u00f3n de datos.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764802890_6930c14a2aaea.jpg\\\"]\"',NULL,'2025-12-03 23:01:30','2025-12-03 23:01:30'),(124,231,'<p>La&nbsp;XPG&nbsp;DDR4&nbsp;3200&nbsp;MHz&nbsp;8&nbsp;GB&nbsp;es&nbsp;un&nbsp;módulo&nbsp;de&nbsp;RAM&nbsp;de&nbsp;escritorio&nbsp;con&nbsp;interfaz&nbsp;DDR4,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;un&nbsp;buen&nbsp;equilibrio&nbsp;entre&nbsp;rendimiento,&nbsp;compatibilidad&nbsp;y&nbsp;costo.&nbsp;Su&nbsp;velocidad&nbsp;de&nbsp;3200&nbsp;MHz&nbsp;permite&nbsp;que&nbsp;la&nbsp;comunicación&nbsp;entre&nbsp;la&nbsp;memoria&nbsp;y&nbsp;el&nbsp;procesador&nbsp;sea&nbsp;más&nbsp;fluida&nbsp;y&nbsp;rápida,&nbsp;lo&nbsp;que&nbsp;se&nbsp;traduce&nbsp;en&nbsp;tiempos&nbsp;de&nbsp;respuesta&nbsp;ágil,&nbsp;mejora&nbsp;en&nbsp;carga&nbsp;de&nbsp;programas&nbsp;y&nbsp;generalmente&nbsp;en&nbsp;un&nbsp;sistema&nbsp;más&nbsp;receptivo.&nbsp;Este&nbsp;módulo&nbsp;incluye&nbsp;un&nbsp;disipador&nbsp;(“heatsink”)&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;mantener&nbsp;temperaturas&nbsp;controladas&nbsp;cuando&nbsp;la&nbsp;RAM&nbsp;trabaja&nbsp;intensamente,&nbsp;lo&nbsp;que&nbsp;le&nbsp;da&nbsp;estabilidad&nbsp;incluso&nbsp;en&nbsp;sesiones&nbsp;largas&nbsp;o&nbsp;con&nbsp;carga&nbsp;alta,&nbsp;y&nbsp;suma&nbsp;confiabilidad&nbsp;al&nbsp;sistema.&nbsp;Además&nbsp;integra&nbsp;iluminación&nbsp;RGB&nbsp;—&nbsp;pensada&nbsp;para&nbsp;quienes&nbsp;quieren&nbsp;estética&nbsp;en&nbsp;su&nbsp;PC&nbsp;—&nbsp;lo&nbsp;que&nbsp;permite&nbsp;combinar&nbsp;rendimiento&nbsp;con&nbsp;un&nbsp;diseño&nbsp;atractivo.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA RAM XPG 8GB 3200MHZ DDR4 HEATSINK RGB\\\",\\\"valor\\\":\\\"XPG\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM XPG\\\",\\\"detalle\\\":\\\"Si instalas este m\\\\u00f3dulo en tu PC, notar\\\\u00e1s que el sistema gana fluidez: el sistema operativo, programas y juegos responder\\\\u00e1n con mayor rapidez, las transiciones ser\\\\u00e1n m\\\\u00e1s suaves y las cargas de tareas ligeras o moderadas ser\\\\u00e1n m\\\\u00e1s \\\\u00e1giles. Tu equipo se percibe m\\\\u00e1s \\\\u201cvivo\\\\u201d, con un rendimiento m\\\\u00e1s estable que con memorias m\\\\u00e1s lentas o antiguas.  Para tareas comunes (navegaci\\\\u00f3n, ofim\\\\u00e1tica, multimedia, uso general) este RAM es suficiente; si tu PC alterna entre varias aplicaciones, editas documentos, haces trabajo de oficina, edici\\\\u00f3n ligera o juegos no muy pesados, obtendr\\\\u00e1s una mejora clara respecto a memorias b\\\\u00e1sicas.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764803355_6930c31b9d1e7.jpg\\\"]\"',NULL,'2025-12-03 23:09:15','2025-12-03 23:09:15'),(125,232,'<p>La&nbsp;T-Force&nbsp;Vulcan&nbsp;DDR5&nbsp;es&nbsp;una&nbsp;memoria&nbsp;RAM&nbsp;de&nbsp;nueva&nbsp;generación,&nbsp;DDR5,&nbsp;con&nbsp;frecuencia&nbsp;de&nbsp;5200&nbsp;MHz&nbsp;y&nbsp;latencias&nbsp;relativamente&nbsp;ajustadas,&nbsp;pensada&nbsp;para&nbsp;PCs&nbsp;modernas&nbsp;que&nbsp;buscan&nbsp;buen&nbsp;rendimiento&nbsp;sin&nbsp;gastar&nbsp;demasiado,&nbsp;Incluye&nbsp;un&nbsp;disipador&nbsp;metálico&nbsp;que&nbsp;ayuda&nbsp;a&nbsp;dispersar&nbsp;calor&nbsp;en&nbsp;uso&nbsp;prolongado,&nbsp;lo&nbsp;que&nbsp;incrementa&nbsp;la&nbsp;estabilidad&nbsp;cuando&nbsp;la&nbsp;memoria&nbsp;trabaja&nbsp;intensamente.&nbsp;Trae&nbsp;soporte&nbsp;para&nbsp;perfiles&nbsp;de&nbsp;memoria&nbsp;como&nbsp;Intel&nbsp;XMP&nbsp;3.0&nbsp;(y&nbsp;si&nbsp;la&nbsp;placa&nbsp;lo&nbsp;permite,&nbsp;perfiles&nbsp;compatibles&nbsp;con&nbsp;AMD),&nbsp;lo&nbsp;que&nbsp;facilita&nbsp;activar&nbsp;la&nbsp;velocidad&nbsp;deseada&nbsp;con&nbsp;un&nbsp;clic&nbsp;en&nbsp;BIOS&nbsp;sin&nbsp;ajustes&nbsp;manuales&nbsp;complicados.&nbsp;Internamente&nbsp;usa&nbsp;circuitos&nbsp;de&nbsp;administración&nbsp;de&nbsp;energía&nbsp;(PMIC)&nbsp;y&nbsp;soporte&nbsp;de&nbsp;corrección&nbsp;de&nbsp;errores&nbsp;“on-die&nbsp;ECC”,&nbsp;lo&nbsp;que&nbsp;mejora&nbsp;eficiencia,&nbsp;estabilidad&nbsp;y&nbsp;confiabilidad&nbsp;del&nbsp;sistema&nbsp;frente&nbsp;a&nbsp;errores&nbsp;de&nbsp;memoria,&nbsp;especialmente&nbsp;útil&nbsp;para&nbsp;cargas&nbsp;intensas&nbsp;o&nbsp;uso&nbsp;prolongado.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA TEAMGROUP T-FORCE VULCAN DDR5 8GB DDR5-5200\\\",\\\"valor\\\":\\\"T-FORCE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM T-FORCE\\\",\\\"detalle\\\":\\\"Si instalas este m\\\\u00f3dulo en tu PC, el sistema ganar\\\\u00e1 agilidad y fluidez: el sistema operativo, programas, edici\\\\u00f3n, multitarea, juegos u otras tareas se beneficiar\\\\u00e1n de la mayor velocidad de RAM y su estabilidad. Los tiempos de carga se reducen, los cambios entre aplicaciones son m\\\\u00e1s r\\\\u00e1pidos, y el rendimiento general mejora \\\\u2014 especialmente si usas software o juegos exigentes, trabajas con edici\\\\u00f3n, dise\\\\u00f1o o multitarea pesada.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1764804399_6930c72f16cce.png\\\"]\"',NULL,'2025-12-03 23:26:39','2025-12-03 23:26:39'),(126,233,'<p>Gabinete&nbsp;de&nbsp;doble&nbsp;cámara:&nbsp;Las&nbsp;partes&nbsp;internas&nbsp;del&nbsp;GT502&nbsp;están&nbsp;divididas&nbsp;en&nbsp;dos&nbsp;cámaras,&nbsp;lo&nbsp;que&nbsp;configura&nbsp;zonas&nbsp;de&nbsp;refrigeración&nbsp;independientes&nbsp;para&nbsp;la&nbsp;CPU&nbsp;y&nbsp;la&nbsp;GPU.</p>','\"[{\\\"nombre\\\":\\\"CASE ASUS TUF GAMING GT302\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER  ASUS\\\",\\\"detalle\\\":\\\"Gabinete de doble c\\\\u00e1mara: Las partes internas del GT502 est\\\\u00e1n divididas en dos c\\\\u00e1maras, lo que configura zonas de refrigeraci\\\\u00f3n independientes para la CPU y la GPU.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1766513288_694ada887b885.webp\\\"]\"',NULL,'2025-12-23 18:08:08','2025-12-24 02:04:57'),(127,234,'<p>El&nbsp;Cooler&nbsp;Case&nbsp;Gamer&nbsp;Vektor&nbsp;AB201&nbsp;ARGB&nbsp;4FANS&nbsp;de&nbsp;Airboom&nbsp;es&nbsp;un&nbsp;kit&nbsp;de&nbsp;4&nbsp;ventiladores&nbsp;de&nbsp;120mm&nbsp;para&nbsp;gabinetes&nbsp;de&nbsp;PC&nbsp;gaming,&nbsp;que&nbsp;ofrece&nbsp;una&nbsp;estética&nbsp;mejorada&nbsp;con&nbsp;iluminación&nbsp;ARGB&nbsp;personalizable&nbsp;en&nbsp;los&nbsp;ventiladores&nbsp;y&nbsp;un&nbsp;controlador&nbsp;para&nbsp;efectos,&nbsp;excelente&nbsp;flujo&nbsp;de&nbsp;aire&nbsp;(60CFM)&nbsp;para&nbsp;buena&nbsp;refrigeración,&nbsp;bajo&nbsp;ruido&nbsp;(2.1dB),&nbsp;fácil&nbsp;instalación&nbsp;y&nbsp;bajo&nbsp;consumo,&nbsp;ideal&nbsp;para&nbsp;renovar&nbsp;la&nbsp;estética&nbsp;y&nbsp;la&nbsp;temperatura&nbsp;de&nbsp;tu&nbsp;PC</p>','\"[{\\\"nombre\\\":\\\"COOLER CASE GAMER VEKTOR AB201 ARGB 4FANS \\\",\\\"valor\\\":\\\"AIRBOOM\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA AIRBOOM\\\",\\\"detalle\\\":\\\"El Vektor AB201 ARGB 4FANS Airboom es un kit de 4 ventiladores gamer de 120 mm con iluminaci\\\\u00f3n ARGB dise\\\\u00f1ado para gabinetes de PC. Ofrece efectos de luz personalizables y un flujo de aire eficiente con bajo ruido, mejorando tanto la est\\\\u00e9tica como la refrigeraci\\\\u00f3n interna de tu equipo gamer.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1766515755_694ae42bf3b0e.jfif\\\"]\"',NULL,'2025-12-23 18:49:16','2025-12-23 18:49:16'),(128,235,'<p>La&nbsp;Refrigeración&nbsp;Líquida&nbsp;Airboom&nbsp;ARC360&nbsp;RGB&nbsp;es&nbsp;un&nbsp;sistema&nbsp;de&nbsp;enfriamiento&nbsp;para&nbsp;PC&nbsp;gamer&nbsp;de&nbsp;360mm&nbsp;con&nbsp;tres&nbsp;ventiladores&nbsp;ARGB&nbsp;de&nbsp;120mm,&nbsp;que&nbsp;ofrece&nbsp;alto&nbsp;rendimiento&nbsp;térmico,&nbsp;bajo&nbsp;ruido&nbsp;y&nbsp;una&nbsp;estética&nbsp;personalizable&nbsp;con&nbsp;efectos&nbsp;de&nbsp;luz&nbsp;sincronizables,&nbsp;ideal&nbsp;para&nbsp;CPUs&nbsp;potentes,&nbsp;con&nbsp;amplia&nbsp;compatibilidad&nbsp;y&nbsp;fácil&nbsp;instalación,&nbsp;incluyendo&nbsp;pastas&nbsp;térmicas&nbsp;y&nbsp;radiador&nbsp;de&nbsp;alta&nbsp;disipación&nbsp;para&nbsp;setups&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"REFRIGERACION LIQUIDA ARC360 RGB GAMER \\\",\\\"valor\\\":\\\"AIRBOOM\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA AIRBOOM\\\",\\\"detalle\\\":\\\"La Refrigeraci\\\\u00f3n L\\\\u00edquida ARC360 RGB Gamer Airboom es un sistema de enfriamiento AIO (All-In-One) con radiador de 360 mm y iluminaci\\\\u00f3n ARGB que ofrece una disipaci\\\\u00f3n de calor eficiente y silenciosa para procesadores potentes. Dise\\\\u00f1ada para setups gamer exigentes, combina alto rendimiento t\\\\u00e9rmico con efectos de luz personalizables, facilitando mantener tu CPU m\\\\u00e1s fresca durante largas sesiones de juego o trabajo intensivo.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 18:56:29','2025-12-23 18:56:29'),(129,236,'<p>La&nbsp;Thermalright&nbsp;Wonder&nbsp;Vision&nbsp;360&nbsp;UB&nbsp;ARGB&nbsp;es&nbsp;una&nbsp;refrigeración&nbsp;líquida&nbsp;AIO&nbsp;(All-In-One)&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;diseñada&nbsp;para&nbsp;PCs&nbsp;gamer&nbsp;y&nbsp;estaciones&nbsp;de&nbsp;trabajo&nbsp;exigentes.&nbsp;Cuenta&nbsp;con&nbsp;un&nbsp;radiador&nbsp;de&nbsp;360&nbsp;mm&nbsp;con&nbsp;triple&nbsp;ventilador&nbsp;PWM&nbsp;ARGB,&nbsp;una&nbsp;bomba&nbsp;potente&nbsp;y&nbsp;silenciosa&nbsp;y&nbsp;una&nbsp;gran&nbsp;pantalla&nbsp;curva&nbsp;ARGB&nbsp;de&nbsp;6.67″&nbsp;en&nbsp;el&nbsp;bloque&nbsp;de&nbsp;la&nbsp;bomba&nbsp;que&nbsp;permite&nbsp;mostrar&nbsp;estadísticas&nbsp;del&nbsp;sistema,&nbsp;imágenes&nbsp;o&nbsp;animaciones&nbsp;personalizadas.&nbsp;Su&nbsp;diseño&nbsp;combina&nbsp;eficiencia&nbsp;térmica&nbsp;avanzada&nbsp;con&nbsp;estética&nbsp;moderna&nbsp;y&nbsp;personalizable,&nbsp;ideal&nbsp;para&nbsp;mantener&nbsp;procesadores&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;frescos&nbsp;incluso&nbsp;bajo&nbsp;cargas&nbsp;intensas.</p>','\"[{\\\"nombre\\\":\\\"COOLER LIQUIDA THERMALRIGHT WONDER VISION 360 UB ARGB\\\",\\\"valor\\\":\\\"AIRBOOM\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"COOLER LIQUIDA THERMALRIGHT WONDER VISION 360 UB ARGB\\\",\\\"detalle\\\":\\\"La Thermalright Wonder Vision 360 UB ARGB es una refrigeraci\\\\u00f3n l\\\\u00edquida AIO de alto rendimiento para CPU que integra un radiador de 360 mm, tres ventiladores 120 mm PWM ARGB de hasta 2150 RPM, una bomba de alta velocidad cercana a 6400 RPM con dise\\\\u00f1o antifugas y una pantalla curva de 6.67\\\\u2033 en resoluci\\\\u00f3n 2400\\\\u00d71080 capaz de mostrar informaci\\\\u00f3n del sistema o im\\\\u00e1genes personalizadas, ofreciendo una combinaci\\\\u00f3n de excelente capacidad de disipaci\\\\u00f3n t\\\\u00e9rmica, funcionamiento silencioso y est\\\\u00e9tica gamer avanzada, con compatibilidad para Intel LGA 115X\\\\\\/1200\\\\\\/1700\\\\\\/1851\\\\\\/2011\\\\\\/2066 y AMD AM4\\\\\\/AM5, ideal para equipos gaming y de alto rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1766516838_694ae86610bf1.jpg\\\"]\"',NULL,'2025-12-23 19:07:18','2025-12-23 19:07:18'),(130,237,'<p>La&nbsp;Cooler&nbsp;Master&nbsp;MasterLiquid&nbsp;360&nbsp;Core&nbsp;II&nbsp;es&nbsp;una&nbsp;refrigeración&nbsp;líquida&nbsp;AIO&nbsp;para&nbsp;CPU&nbsp;con&nbsp;radiador&nbsp;de&nbsp;360&nbsp;mm&nbsp;diseñada&nbsp;para&nbsp;ofrecer&nbsp;alto&nbsp;rendimiento&nbsp;térmico&nbsp;y&nbsp;estética&nbsp;moderna&nbsp;en&nbsp;sistemas&nbsp;gaming&nbsp;y&nbsp;PCs&nbsp;de&nbsp;alto&nbsp;rendimiento.&nbsp;Cuenta&nbsp;con&nbsp;una&nbsp;bomba&nbsp;de&nbsp;doble&nbsp;cámara&nbsp;refrigerada&nbsp;por&nbsp;líquido,&nbsp;tuberías&nbsp;optimizadas&nbsp;para&nbsp;una&nbsp;instalación&nbsp;sencilla&nbsp;y&nbsp;tres&nbsp;ventiladores&nbsp;PWM&nbsp;de&nbsp;120&nbsp;mm&nbsp;con&nbsp;iluminación&nbsp;ARGB&nbsp;que&nbsp;ayudan&nbsp;a&nbsp;mantener&nbsp;temperaturas&nbsp;bajas&nbsp;incluso&nbsp;bajo&nbsp;cargas&nbsp;exigentes.&nbsp;Su&nbsp;diseño&nbsp;incluye&nbsp;detalles&nbsp;estéticos&nbsp;como&nbsp;un&nbsp;efecto&nbsp;espejo&nbsp;infinito&nbsp;en&nbsp;la&nbsp;bomba&nbsp;y&nbsp;soporte&nbsp;para&nbsp;una&nbsp;amplia&nbsp;gama&nbsp;de&nbsp;sockets&nbsp;Intel&nbsp;y&nbsp;AMD,&nbsp;lo&nbsp;que&nbsp;la&nbsp;hace&nbsp;una&nbsp;opción&nbsp;sólida&nbsp;para&nbsp;mejorar&nbsp;la&nbsp;refrigeración&nbsp;y&nbsp;la&nbsp;apariencia&nbsp;interior&nbsp;de&nbsp;tu&nbsp;equipo.</p>','\"[{\\\"nombre\\\":\\\"COOLER LIQUIDA COOLER MASTERLIQUID 360 CORE II\\\",\\\"valor\\\":\\\"MASTERLIQUID\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA MASTERLIQUID\\\",\\\"detalle\\\":\\\"La Cooler Master MasterLiquid 360 Core II es un sistema de refrigeraci\\\\u00f3n l\\\\u00edquida AIO para CPU con radiador de 360 mm de aluminio y tubos de 400 mm, que incluye tres ventiladores ARGB de 120 mm con velocidad de 650\\\\u20131750 RPM (~70 CFM) y presi\\\\u00f3n est\\\\u00e1tica alta para una mejor disipaci\\\\u00f3n, una bomba de doble c\\\\u00e1mara silenciosa (~3100 RPM) con iluminaci\\\\u00f3n ARGB y conectores PWM\\\\\\/ARGB est\\\\u00e1ndar, compatibilidad amplia con sockets Intel (LGA1851\\\\\\/1700\\\\\\/1200\\\\\\/115x) y AMD (AM5\\\\\\/AM4), e incluye pasta t\\\\u00e9rmica Cryo-Fuze para una instalaci\\\\u00f3n r\\\\u00e1pida, ofreciendo alto rendimiento t\\\\u00e9rmico y est\\\\u00e9tica gamer con bajo nivel de ruido y larga vida \\\\u00fatil, ideal para PCs gaming y de alto rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 19:16:52','2025-12-23 19:16:52'),(131,238,'<p>La&nbsp;Refrigeración&nbsp;Líquida&nbsp;DeepCool&nbsp;LM360&nbsp;ARGB&nbsp;White&nbsp;es&nbsp;un&nbsp;sistema&nbsp;AIO&nbsp;de&nbsp;enfriamiento&nbsp;líquido&nbsp;para&nbsp;CPU&nbsp;con&nbsp;radiador&nbsp;de&nbsp;360&nbsp;mm&nbsp;y&nbsp;diseño&nbsp;blanco&nbsp;premium,&nbsp;pensada&nbsp;para&nbsp;mantener&nbsp;temperaturas&nbsp;bajas&nbsp;en&nbsp;procesadores&nbsp;potentes&nbsp;mientras&nbsp;ofrece&nbsp;una&nbsp;estética&nbsp;gamer&nbsp;con&nbsp;iluminación&nbsp;ARGB&nbsp;sincronizable;&nbsp;incluye&nbsp;tres&nbsp;ventiladores&nbsp;PWM&nbsp;ARGB&nbsp;de&nbsp;120&nbsp;mm&nbsp;de&nbsp;alto&nbsp;flujo&nbsp;de&nbsp;aire,&nbsp;una&nbsp;bomba&nbsp;de&nbsp;sexta&nbsp;generación&nbsp;con&nbsp;control&nbsp;PWM&nbsp;y&nbsp;tecnología&nbsp;Anti-Leak&nbsp;para&nbsp;mayor&nbsp;fiabilidad,&nbsp;y&nbsp;una&nbsp;pantalla&nbsp;IPS&nbsp;de&nbsp;2.4″&nbsp;en&nbsp;el&nbsp;bloque&nbsp;que&nbsp;puede&nbsp;mostrar&nbsp;temperaturas,&nbsp;GIFs&nbsp;o&nbsp;videos&nbsp;personalizados,&nbsp;compatible&nbsp;con&nbsp;los&nbsp;sockets&nbsp;modernos&nbsp;Intel&nbsp;(LGA&nbsp;1851/1700/1200/115x)&nbsp;y&nbsp;AMD&nbsp;(AM5/AM4).&nbsp;</p>','\"[{\\\"nombre\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL LM360 ARGB WHITE \\\",\\\"valor\\\":\\\"DEEPCOOL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL\\\",\\\"detalle\\\":\\\"La DeepCool LM360 ARGB White es una refrigeraci\\\\u00f3n l\\\\u00edquida AIO para CPU equipada con un radiador de 360 mm de aluminio, tres ventiladores PWM ARGB de 120 mm de alto flujo y presi\\\\u00f3n est\\\\u00e1tica, y una bomba de sexta generaci\\\\u00f3n con control PWM y tecnolog\\\\u00eda Anti-Leak para mayor fiabilidad; incorpora una pantalla IPS de 2.4\\\\u2033 en el bloque para mostrar informaci\\\\u00f3n del sistema o contenido personalizado, utiliza conectores ARGB de 5 V y PWM de 4 pines, ofrece funcionamiento eficiente y silencioso, y es compatible con sockets Intel LGA 1851\\\\\\/1700\\\\\\/1200\\\\\\/115x y AMD AM5\\\\\\/AM4, siendo ideal para PCs gaming y de alto rendimiento con est\\\\u00e9tica blanca.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 19:23:03','2025-12-23 19:23:03'),(132,239,'<p>La&nbsp;DeepCool&nbsp;LE360&nbsp;V2&nbsp;ARGB&nbsp;es&nbsp;una&nbsp;refrigeración&nbsp;líquida&nbsp;AIO&nbsp;de&nbsp;360&nbsp;mm&nbsp;diseñada&nbsp;para&nbsp;PCs&nbsp;gamer&nbsp;y&nbsp;de&nbsp;alto&nbsp;rendimiento,&nbsp;que&nbsp;combina&nbsp;alto&nbsp;poder&nbsp;de&nbsp;disipación&nbsp;térmica&nbsp;con&nbsp;iluminación&nbsp;ARGB&nbsp;personalizable,&nbsp;permitiendo&nbsp;mantener&nbsp;el&nbsp;procesador&nbsp;a&nbsp;temperaturas&nbsp;estables&nbsp;incluso&nbsp;en&nbsp;cargas&nbsp;intensas,&nbsp;además&nbsp;de&nbsp;aportar&nbsp;una&nbsp;estética&nbsp;moderna&nbsp;y&nbsp;atractiva&nbsp;al&nbsp;interior&nbsp;del&nbsp;gabinete.</p>','\"[{\\\"nombre\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL LE360 V2 ARGB\\\",\\\"valor\\\":\\\"DEEPCOOL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL\\\",\\\"detalle\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL LE360 V2 ARGB Cuenta con un radiador de aluminio de 360 mm, tres ventiladores PWM ARGB de 120 mm con alto flujo de aire y bajo nivel de ruido, una bomba de alto rendimiento con tecnolog\\\\u00eda Anti-Leak, conectores PWM de 4 pines y ARGB de 5 V, y es compatible con sockets Intel LGA 1851\\\\\\/1700\\\\\\/1200\\\\\\/115x y AMD AM5\\\\\\/AM4, ofreciendo un enfriamiento eficiente, confiable y silencioso para equipos de alto desempe\\\\u00f1o.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 19:34:39','2025-12-23 19:34:39'),(133,240,'<p>La&nbsp;Cooler&nbsp;Master&nbsp;MasterLiquid&nbsp;360&nbsp;Core&nbsp;II&nbsp;es&nbsp;una&nbsp;refrigeración&nbsp;líquida&nbsp;AIO&nbsp;para&nbsp;CPU&nbsp;con&nbsp;radiador&nbsp;de&nbsp;360&nbsp;mm&nbsp;y&nbsp;tres&nbsp;ventiladores&nbsp;ARGB,&nbsp;diseñada&nbsp;para&nbsp;ofrecer&nbsp;potente&nbsp;disipación&nbsp;térmica&nbsp;y&nbsp;una&nbsp;estética&nbsp;gamer&nbsp;llamativa,&nbsp;ideal&nbsp;para&nbsp;equipos&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;y&nbsp;juegos&nbsp;exigentes.</p>','\"[{\\\"nombre\\\":\\\"COOLER LIQUIDA COOLER MASTERLIQUID 360 CORE II\\\",\\\"valor\\\":\\\"MASTERLIQUID\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA MASTERLIQUID\\\",\\\"detalle\\\":\\\"COOLER LIQUIDA COOLER MASTERLIQUID 360 CORE II Cuenta con un radiador de aluminio de 360 mm, tres ventiladores PWM ARGB de 120 mm con buen flujo de aire, una bomba de doble c\\\\u00e1mara silenciosa, conectores PWM y ARGB est\\\\u00e1ndar, compatibilidad con sockets Intel (LGA1851\\\\\\/1700\\\\\\/1200\\\\\\/115x) y AMD (AM5\\\\\\/AM4), e incluye pasta t\\\\u00e9rmica preaplicada, proporcionando enfriamiento eficiente y funcionamiento silencioso.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 19:39:31','2025-12-23 19:39:31'),(134,241,'<p>El&nbsp;disipador&nbsp;torre&nbsp;MSI&nbsp;MAG&nbsp;CoreFrozr&nbsp;AA13&nbsp;ARGB&nbsp;es&nbsp;un&nbsp;cooler&nbsp;de&nbsp;aire&nbsp;para&nbsp;CPU&nbsp;con&nbsp;iluminación&nbsp;ARGB&nbsp;personalizable,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;refrigeración&nbsp;eficiente&nbsp;y&nbsp;estética&nbsp;gamer&nbsp;en&nbsp;una&nbsp;configuración&nbsp;de&nbsp;torre&nbsp;compacta,&nbsp;ideal&nbsp;para&nbsp;mantener&nbsp;procesadores&nbsp;modernos&nbsp;a&nbsp;temperaturas&nbsp;controladas&nbsp;mientras&nbsp;añade&nbsp;un&nbsp;toque&nbsp;visual&nbsp;llamativo&nbsp;al&nbsp;interior&nbsp;de&nbsp;tu&nbsp;PC.</p>','\"[{\\\"nombre\\\":\\\"DISIPADOR TORRE MSI MAG COREFROZR AA13 ARGB\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA MSI\\\",\\\"detalle\\\":\\\"DISIPADOR TORRE MSI MAG COREFROZR AA13 ARGB Cuenta con un ventilador ARGB de 120 mm (CycloBlade7) con velocidad entre 510 y 2070 RPM, flujo de aire de 62.6 CFM y bajo ruido (\\\\u224830 dBA), cuatro heat pipes de cobre de 6 mm con contacto directo que mejoran la transferencia t\\\\u00e9rmica hacia las aletas del radiador, dimensiones de 152 \\\\u00d7 121 \\\\u00d7 94.5 mm, conectores 5 V ARGB 3-pin y PWM, compatibilidad con Intel (LGA1700\\\\\\/1851) y AMD (AM4\\\\\\/AM5), pasta t\\\\u00e9rmica preaplicada y capacidad de disipaci\\\\u00f3n de hasta 240 W TDP, ofreciendo enfriamiento s\\\\u00f3lido y est\\\\u00e9tica ARGB en sistemas gamer y de alto rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 19:44:13','2025-12-23 19:44:13'),(135,242,'<p>La&nbsp;DeepCool&nbsp;LS520&nbsp;White&nbsp;ARGB&nbsp;es&nbsp;una&nbsp;refrigeración&nbsp;líquida&nbsp;AIO&nbsp;para&nbsp;CPU&nbsp;con&nbsp;diseño&nbsp;blanco&nbsp;premium&nbsp;e&nbsp;iluminación&nbsp;ARGB,&nbsp;pensada&nbsp;para&nbsp;ofrecer&nbsp;eficiente&nbsp;disipación&nbsp;térmica&nbsp;y&nbsp;estética&nbsp;visual&nbsp;atractiva&nbsp;en&nbsp;PCs&nbsp;gamer&nbsp;y&nbsp;sistemas&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;soporte&nbsp;para&nbsp;múltiples&nbsp;efectos&nbsp;de&nbsp;luz&nbsp;sincronizados&nbsp;con&nbsp;la&nbsp;placa&nbsp;base.</p>','\"[{\\\"nombre\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL LS520 WHITE ARGB\\\",\\\"valor\\\":\\\"DEEPCOOL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL\\\",\\\"detalle\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL LS520 WHITE ARGB Cuenta con un radiador de 240 mm de aluminio, dos ventiladores FC120 PWM ARGB de 120 mm con flujo de aire de \\\\u224885.85 CFM, velocidad de 500\\\\u20132250 RPM y ruido \\\\u226432.9 dB(A), una bomba de alto rendimiento (~3100 RPM) con microcanales optimizados y base de cobre s\\\\u00f3lido, conectores PWM y ARGB est\\\\u00e1ndar, y compatibilidad amplia con sockets Intel (LGA2066\\\\\\/2011\\\\\\/1700\\\\\\/1200\\\\\\/115x) y AMD (AM5\\\\\\/AM4) para un rendimiento silencioso y confiable.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1766519614_694af33e79063.jfif\\\"]\"',NULL,'2025-12-23 19:53:34','2025-12-23 19:53:34'),(136,243,'<p>El&nbsp;DeepCool&nbsp;AK500&nbsp;White&nbsp;es&nbsp;un&nbsp;disipador&nbsp;de&nbsp;aire&nbsp;para&nbsp;CPU&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;diseño&nbsp;blanco&nbsp;elegante,&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;gamer&nbsp;y&nbsp;sistemas&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;que&nbsp;buscan&nbsp;refrigeración&nbsp;eficiente&nbsp;y&nbsp;estética&nbsp;limpia,&nbsp;ofreciendo&nbsp;una&nbsp;solución&nbsp;sólida&nbsp;para&nbsp;mantener&nbsp;tu&nbsp;procesador&nbsp;a&nbsp;temperaturas&nbsp;controladas&nbsp;sin&nbsp;complicaciones.</p>','\"[{\\\"nombre\\\":\\\"COOLER DE PROCESADOR DEEPCOOL AK500 WHITE\\\",\\\"valor\\\":\\\"DEEPCOOL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"REFRIGERACION LIQUIDA DEEPCOOL\\\",\\\"detalle\\\":\\\"COOLER DE PROCESADOR DEEPCOOL AK500 WHITE Cuenta con dise\\\\u00f1o de torre con 5 heat pipes de 6 mm y base de cobre optimizada, un ventilador PWM FK120 de 120 mm con rodamiento din\\\\u00e1mico de fluidos que gira entre 500\\\\u20131850 RPM y entrega hasta \\\\u224869 CFM con bajo ruido (\\\\u226431.5 dB(A)), compatibilidad con sockets Intel (LGA1150\\\\\\/1151\\\\\\/1155\\\\\\/1200\\\\\\/1700\\\\\\/2011\\\\\\/2066) y AMD (AM4\\\\\\/AM5), capacidad de disipaci\\\\u00f3n TDP de hasta ~240 W, dimensiones compactas (~127\\\\u00d7117\\\\u00d7158 mm) y un acabado blanco moderno para combinar con sistemas personalizados. \\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 19:59:54','2025-12-23 19:59:54'),(137,244,'<p>El&nbsp;mouse&nbsp;Striker&nbsp;White&nbsp;CBX&nbsp;M601W&nbsp;7200&nbsp;DPI&nbsp;de&nbsp;Cybertel&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;con&nbsp;cable&nbsp;USB&nbsp;en&nbsp;color&nbsp;blanco&nbsp;diseñado&nbsp;para&nbsp;brindar&nbsp;precisión&nbsp;y&nbsp;control&nbsp;en&nbsp;juegos&nbsp;y&nbsp;uso&nbsp;diario,&nbsp;con&nbsp;iluminación&nbsp;RGB&nbsp;dinámica,&nbsp;siete&nbsp;botones,&nbsp;agarre&nbsp;lateral&nbsp;cómodo&nbsp;y&nbsp;cable&nbsp;trenzado&nbsp;resistente,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;rendimiento&nbsp;y&nbsp;estilo&nbsp;en&nbsp;su&nbsp;setup.</p>','\"[{\\\"nombre\\\":\\\"MOUSE STRIKER WHITE CBX M601W 7200DPI \\\",\\\"valor\\\":\\\"CYBERTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE CYBERTEL\\\",\\\"detalle\\\":\\\"MOUSE STRIKER WHITE CBX M601W 7200DPI CYBERTEL Cuenta con sensor \\\\u00f3ptico ajustable hasta 7200 DPI para sensibilidad precisa, 7 botones (incluyendo dos laterales de avance\\\\\\/retroceso), iluminaci\\\\u00f3n LED RGB, conexi\\\\u00f3n USB plug & play con cable de nylon trenzado antienredos de ~1.5 m, agarre lateral antideslizante y compatibilidad con Windows y otros sistemas operativos, ofreciendo una experiencia estable y personalizable para gaming.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:13:08','2025-12-23 20:20:49'),(138,245,'<p>El&nbsp;Mouse&nbsp;Gaming&nbsp;Wireless&nbsp;Antryx&nbsp;Scorpio&nbsp;250&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;inalámbrico&nbsp;versátil&nbsp;y&nbsp;ergonómico&nbsp;que&nbsp;permite&nbsp;conectarse&nbsp;por&nbsp;2.4&nbsp;GHz,&nbsp;Bluetooth&nbsp;v5.1&nbsp;o&nbsp;cable&nbsp;USB,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;movilidad,&nbsp;precisión&nbsp;y&nbsp;comodidad&nbsp;sin&nbsp;sacrificar&nbsp;rendimiento.</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMING WIRELESS ANTRYX SCORPIO 250, DPI 8000,\\\",\\\"valor\\\":\\\"ANTRYX\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE ANTRYX\\\",\\\"detalle\\\":\\\"MOUSE GAMING WIRELESS ANTRYX SCORPIO 250, DPI 8000, Cuenta con sensor \\\\u00f3ptico PixArt PAW3104 con DPI ajustables hasta 8000, 6 botones personalizables, microinterruptores OMRON\\\\\\/HUANO duraderos (~20 millones de clics), bater\\\\u00eda recargable de 600 mAh con hasta ~140 h de uso, dise\\\\u00f1o ligero (~59 g) y ergon\\\\u00f3mico, alcance inal\\\\u00e1mbrico de hasta ~10 m, iluminaci\\\\u00f3n RGB y software con perfiles\\\\\\/macros, y compatibilidad con varios sistemas mediante conectividad 2.4 GHz inal\\\\u00e1mbrica, Bluetooth o USB.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:20:34','2025-12-23 20:20:34'),(139,246,'<p>El&nbsp;Mouse&nbsp;Gamer&nbsp;Killer&nbsp;CBX&nbsp;M600&nbsp;Negro&nbsp;de&nbsp;Cybertel&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;con&nbsp;cable&nbsp;USB&nbsp;y&nbsp;retroiluminación&nbsp;RGB,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;precisión&nbsp;y&nbsp;control&nbsp;en&nbsp;juegos&nbsp;FPS,&nbsp;MOBA&nbsp;o&nbsp;MMO,&nbsp;con&nbsp;botones&nbsp;programables&nbsp;y&nbsp;un&nbsp;agarre&nbsp;cómodo,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;rendimiento&nbsp;y&nbsp;estilo&nbsp;en&nbsp;su&nbsp;setup.</p>','\"[{\\\"nombre\\\":\\\"MOUSE KILLER - CBX M600 NEGRO\\\",\\\"valor\\\":\\\"CYBERTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE KILLER - CBX M600 NEGRO\\\",\\\"detalle\\\":\\\"MOUSE KILLER - CBX M600 NEGRO Cuenta con sensor \\\\u00f3ptico con DPI ajustable hasta 7200 para movimientos precisos, 8 botones programables (incluyendo botones de avance\\\\\\/retroceso y bot\\\\u00f3n Fire), iluminaci\\\\u00f3n RGB personalizable, cable USB trenzado con filtro anti-electromagnetismo para mayor durabilidad, agarre lateral antideslizante y compatibilidad con Windows y otros sistemas, proporcionando control c\\\\u00f3modo, respuesta r\\\\u00e1pida y est\\\\u00e9tica gamer RGB.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:23:27','2025-12-23 20:23:27'),(140,247,'<p>El&nbsp;Mouse&nbsp;Logitech&nbsp;M90&nbsp;1000&nbsp;DPI&nbsp;USB&nbsp;Negro&nbsp;es&nbsp;un&nbsp;mouse&nbsp;con&nbsp;cable&nbsp;simple&nbsp;y&nbsp;confiable&nbsp;pensado&nbsp;para&nbsp;uso&nbsp;diario&nbsp;en&nbsp;oficina,&nbsp;estudio&nbsp;o&nbsp;navegación&nbsp;web,&nbsp;con&nbsp;un&nbsp;diseño&nbsp;ambidiestro&nbsp;cómodo&nbsp;y&nbsp;funcional&nbsp;que&nbsp;se&nbsp;conecta&nbsp;por&nbsp;USB&nbsp;y&nbsp;funciona&nbsp;al&nbsp;instante&nbsp;sin&nbsp;necesidad&nbsp;de&nbsp;software,&nbsp;ofreciendo&nbsp;control&nbsp;fluido&nbsp;y&nbsp;preciso&nbsp;gracias&nbsp;a&nbsp;su&nbsp;sensor&nbsp;óptico.</p>','\"[{\\\"nombre\\\":\\\"MOUSE LOGITECH M90 1000 DPI USB NEGRO\\\",\\\"valor\\\":\\\"LOGITECH\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE LOGITECH\\\",\\\"detalle\\\":\\\"MOUSE LOGITECH M90 1000 DPI USB NEGRO Cuenta con sensor \\\\u00f3ptico de hasta 1000 DPI, 3 botones (clic izquierdo, derecho y rueda central), rueda de desplazamiento \\\\u00f3ptica, cable USB de ~1.8 m, dise\\\\u00f1o ambidiestro, peso de ~90 g y compatibilidad con Windows, macOS, Linux y Chrome OS, proporcionando seguimiento preciso del cursor y comodidad b\\\\u00e1sica plug-and-play.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:28:01','2025-12-23 20:28:01'),(141,248,'<p>El&nbsp;mouse&nbsp;Enkore&nbsp;Pivot&nbsp;EKM105&nbsp;es&nbsp;un&nbsp;mouse&nbsp;óptico&nbsp;alámbrico&nbsp;sencillo&nbsp;y&nbsp;ergonómico&nbsp;con&nbsp;conexión&nbsp;USB&nbsp;plug&nbsp;&amp;&nbsp;play,&nbsp;ideal&nbsp;para&nbsp;uso&nbsp;diario&nbsp;en&nbsp;oficina,&nbsp;estudio&nbsp;o&nbsp;navegación,&nbsp;que&nbsp;ofrece&nbsp;un&nbsp;movimiento&nbsp;suave&nbsp;y&nbsp;preciso&nbsp;en&nbsp;color&nbsp;negro&nbsp;con&nbsp;diseño&nbsp;cómodo&nbsp;para&nbsp;largas&nbsp;horas&nbsp;de&nbsp;trabajo.</p>','\"[{\\\"nombre\\\":\\\"MOUSE ENKORE PIVOT EKM105\\\",\\\"valor\\\":\\\"ENKORE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE ENKORE\\\",\\\"detalle\\\":\\\"MOUSE ENKORE PIVOT EKM105 Cuenta con sensor \\\\u00f3ptico con resoluci\\\\u00f3n de 1200 DPI para un seguimiento preciso del cursor, 3 botones est\\\\u00e1ndar (izquierdo, derecho y rueda clicable), conexi\\\\u00f3n USB al\\\\u00e1mbrica compatible con Windows y otros sistemas operativos, y un dise\\\\u00f1o ergon\\\\u00f3mico que facilita el uso prolongado sin molestias.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:33:59','2025-12-23 20:33:59'),(142,249,'<p>El&nbsp;Mouse&nbsp;Gaming&nbsp;Razer&nbsp;Viper&nbsp;V2&nbsp;Pro&nbsp;Hyperspeed&nbsp;30K&nbsp;DPI&nbsp;Black&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;inalámbrico&nbsp;ultraliviano&nbsp;(≈58&nbsp;g)&nbsp;diseñado&nbsp;para&nbsp;jugadores&nbsp;competitivos,&nbsp;con&nbsp;conectividad&nbsp;inalámbrica&nbsp;Razer&nbsp;HyperSpeed&nbsp;o&nbsp;por&nbsp;cable&nbsp;Speedflex,&nbsp;ofreciendo&nbsp;precisión&nbsp;extrema,&nbsp;respuesta&nbsp;rápida&nbsp;y&nbsp;control&nbsp;preciso&nbsp;para&nbsp;esports&nbsp;y&nbsp;sesiones&nbsp;largas&nbsp;de&nbsp;juego&nbsp;sin&nbsp;retrasos.</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMER RAZER VIPER V2 PRO HYPERSPEED DPI 30K BLACK\\\",\\\"valor\\\":\\\"RAZER\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE RAZER\\\",\\\"detalle\\\":\\\"MOUSE GAMER RAZER VIPER V2 PRO HYPERSPEED DPI 30K BLACK Incorpora un sensor \\\\u00f3ptico Focus Pro 30K con hasta 30 000 DPI para seguimiento ultra preciso, 5 botones programables, interruptores \\\\u00f3pticos Gen-3 con vida \\\\u00fatil de ~90 millones de clics, hasta ~80 h de bater\\\\u00eda por carga, pies 100 % PTFE para deslizamiento suave, dise\\\\u00f1o sim\\\\u00e9trico para diestros, conectividad inal\\\\u00e1mbrica HyperSpeed y por cable USB-C Speedflex, y un peso ultraligero de ~58 g para movimientos r\\\\u00e1pidos y \\\\u00e1giles durante el juego.\\\"}]\"',NULL,NULL,NULL,NULL,'\"[\\\"1766522334_694afddea0537.png\\\"]\"',NULL,'2025-12-23 20:38:54','2025-12-23 20:38:54'),(143,250,'<p>El&nbsp;Mouse&nbsp;Gaming&nbsp;Logitech&nbsp;G502&nbsp;HERO&nbsp;Black&nbsp;25K&nbsp;DPI&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;con&nbsp;cable&nbsp;USB&nbsp;de&nbsp;alto&nbsp;rendimiento,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;precisión&nbsp;extrema,&nbsp;personalización&nbsp;avanzada&nbsp;y&nbsp;estética&nbsp;RGB&nbsp;LIGHTSYNC,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;competitivos&nbsp;y&nbsp;exigentes&nbsp;que&nbsp;necesitan&nbsp;control&nbsp;fino&nbsp;y&nbsp;múltiples&nbsp;funciones&nbsp;programables&nbsp;en&nbsp;sus&nbsp;partidas.</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMING LOGITECH G502 HERO BLACK 25K DPI\\\",\\\"valor\\\":\\\"LOGITECH\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE LOGITECH\\\",\\\"detalle\\\":\\\"MOUSE GAMING LOGITECH G502 HERO BLACK 25K DPI Incorpora un sensor \\\\u00f3ptico HERO 25K con resoluci\\\\u00f3n ajustable de 100 \\\\u2013 25 600 DPI sin suavizado ni filtros, respuesta USB de 1000 Hz (1 ms), memoria interna para hasta 5 perfiles, iluminaci\\\\u00f3n RGB LIGHTSYNC personalizable, peso de ~121 g con pesos adicionales ajustables, 11 botones programables, pies de PTFE de alta durabilidad y compatibilidad con Windows, macOS y Chrome OS, proporcionando seguimiento preciso, gran personalizaci\\\\u00f3n y confort para largas sesiones de juego.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:45:22','2025-12-23 20:45:22'),(144,251,'<p>El&nbsp;Mouse&nbsp;Gamer&nbsp;Scyrox&nbsp;V8&nbsp;Blanco&nbsp;8K&nbsp;/&nbsp;30K&nbsp;DPI&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;inalámbrico&nbsp;ultraligero&nbsp;(~36&nbsp;g)&nbsp;con&nbsp;diseño&nbsp;ergonómico&nbsp;pensado&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;precisión,&nbsp;velocidad&nbsp;y&nbsp;comodidad,&nbsp;ofreciendo&nbsp;un&nbsp;rendimiento&nbsp;competitivo&nbsp;tanto&nbsp;en&nbsp;juegos&nbsp;rápidos&nbsp;como&nbsp;en&nbsp;tareas&nbsp;diarias&nbsp;con&nbsp;un&nbsp;estilo&nbsp;minimalista&nbsp;sin&nbsp;iluminación&nbsp;RGB.</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMER SCYROX V8 BLANCO 8K\\\\\\/30K\\\",\\\"valor\\\":\\\" SCYROX\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE SCYROX\\\",\\\"detalle\\\":\\\"MOUSE GAMER SCYROX V8 BLANCO 8K\\\\\\/30K Cuenta con conectividad inal\\\\u00e1mbrica 2.4 GHz con dongle 8K (8000 Hz polling) y modo USB-C con cable, un sensor \\\\u00f3ptico PixArt PAW3950 con hasta 30 000 DPI, switches \\\\u00f3pticos Omron para clics precisos y duraderos, dimensiones de \\\\u2248118 \\\\u00d7 63 \\\\u00d7 38 mm, patines PTFE de baja fricci\\\\u00f3n y dise\\\\u00f1o sim\\\\u00e9trico c\\\\u00f3modo para diestros, ofreciendo seguimiento muy r\\\\u00e1pido y eficiente con bajo peso para competitivo gaming.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:54:13','2025-12-23 20:54:13'),(145,252,'<p>El&nbsp;Mouse&nbsp;Gamer&nbsp;Scyrox&nbsp;V8&nbsp;Negro&nbsp;8K/30K&nbsp;DPI&nbsp;PAW3950&nbsp;es&nbsp;un&nbsp;mouse&nbsp;gamer&nbsp;inalámbrico&nbsp;ultraligero&nbsp;(~36&nbsp;g)&nbsp;diseñado&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;respuesta&nbsp;ultra&nbsp;rápida,&nbsp;precisión&nbsp;competitiva&nbsp;y&nbsp;control&nbsp;cómodo,&nbsp;con&nbsp;un&nbsp;diseño&nbsp;ambidiestro&nbsp;ideal&nbsp;para&nbsp;sesiones&nbsp;largas&nbsp;y&nbsp;rendimiento&nbsp;en&nbsp;eSports</p>','\"[{\\\"nombre\\\":\\\"MOUSE GAMER SCYROX V8 NEGRO 8K\\\\\\/30K DPI\\\\\\/36GR\\\\\\/PAW3950\\\",\\\"valor\\\":\\\"SCYROX\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MOUSE SCYROX\\\",\\\"detalle\\\":\\\"MOUSE GAMER SCYROX V8 NEGRO 8K\\\\\\/30K DPI\\\\\\/36GR\\\\\\/PAW3950 Cuenta con sensor \\\\u00f3ptico PixArt PAW3950 con hasta 30 000 DPI y seguimiento preciso, conectividad dual inal\\\\u00e1mbrica 2.4 GHz con polling de hasta 8000 Hz y con cable USB-C, switches \\\\u00f3pticos Omron para clics duraderos, forma sim\\\\u00e9trica ergon\\\\u00f3mica (~118\\\\u00d763\\\\u00d738 mm), patines PTFE de baja fricci\\\\u00f3n para deslizamiento suave, 5 botones funcionales y compatibilidad con Windows y otros sistemas, ofreciendo alto rendimiento competitivo con baja latencia y gran precisi\\\\u00f3n.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 20:58:48','2025-12-23 20:58:48'),(146,253,'<p>El&nbsp;Teclado&nbsp;Logitech&nbsp;Pebble&nbsp;2&nbsp;K380S&nbsp;Wireless/Bluetooth&nbsp;es&nbsp;un&nbsp;teclado&nbsp;compacto,&nbsp;delgado&nbsp;y&nbsp;silencioso&nbsp;diseñado&nbsp;para&nbsp;uso&nbsp;diario&nbsp;tanto&nbsp;en&nbsp;oficina&nbsp;como&nbsp;en&nbsp;casa,&nbsp;que&nbsp;ofrece&nbsp;conectividad&nbsp;inalámbrica&nbsp;por&nbsp;Bluetooth&nbsp;y&nbsp;un&nbsp;diseño&nbsp;elegante,&nbsp;minimalista&nbsp;y&nbsp;portátil&nbsp;ideal&nbsp;para&nbsp;trabajar&nbsp;o&nbsp;estudiar&nbsp;con&nbsp;comodidad&nbsp;en&nbsp;múltiples&nbsp;dispositivos.</p>','\"[{\\\"nombre\\\":\\\"TECLADO LOGITECH PEBBLE 2 K380S WIRELESS\\\\\\/BLUETOOTH\\\",\\\"valor\\\":\\\"LOGITECH\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO LOGITECH \\\",\\\"detalle\\\":\\\"TECLADO LOGITECH PEBBLE 2 K380S WIRELESS\\\\\\/BLUETOOTH Cuenta con conectividad Bluetooth\\\\u00ae para emparejar hasta tres dispositivos simult\\\\u00e1neamente, teclas de perfil bajo y silenciosas con distribuci\\\\u00f3n c\\\\u00f3moda para escritura fluida, dise\\\\u00f1o ultradelgado y ligero, bater\\\\u00eda de larga duraci\\\\u00f3n (hasta varios meses con uso t\\\\u00edpico), compatibilidad con Windows, macOS, ChromeOS, iPadOS, Android y m\\\\u00e1s, y una construcci\\\\u00f3n robusta y port\\\\u00e1til que facilita el uso en diferentes espacios y dispositivos sin cables.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:07:47','2025-12-23 21:07:47'),(147,254,'<p>El&nbsp;Teclado&nbsp;Gamer&nbsp;Machenike&nbsp;K600T&nbsp;es&nbsp;un&nbsp;teclado&nbsp;mecánico&nbsp;inalámbrico&nbsp;compacto&nbsp;(75%&nbsp;/&nbsp;82&nbsp;teclas)&nbsp;con&nbsp;retroiluminación&nbsp;RGB&nbsp;personalizable&nbsp;y&nbsp;diseño&nbsp;gamer&nbsp;ergonómico,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;y&nbsp;usuarios&nbsp;que&nbsp;buscan&nbsp;rendimiento&nbsp;y&nbsp;estilo;&nbsp;soporta&nbsp;múltiples&nbsp;modos&nbsp;de&nbsp;conexión&nbsp;(USB&nbsp;cableado,&nbsp;inalámbrico&nbsp;2.4&nbsp;GHz&nbsp;y&nbsp;Bluetooth)&nbsp;y&nbsp;permite&nbsp;personalizar&nbsp;la&nbsp;experiencia&nbsp;de&nbsp;uso&nbsp;con&nbsp;efectos&nbsp;de&nbsp;luz&nbsp;y&nbsp;funciones&nbsp;avanzadas.</p>','\"[{\\\"nombre\\\":\\\"TECLADO MACHENIKE K600T\\\",\\\"valor\\\":\\\"MACHENIKE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO MACHENIKE \\\",\\\"detalle\\\":\\\"TECLADO MACHENIKE K600T Cuenta con teclas mec\\\\u00e1nicas con switches intercambiables (hot-swap), layout de 82 teclas con anti-ghosting y N-key rollover, conectividad tri-mode (USB, Bluetooth 5.0 y 2.4 GHz), bater\\\\u00eda interna de gran capacidad (~4000 mAh), teclas PBT + ABS de doble inyecci\\\\u00f3n, cable USB-C desmontable, retroiluminaci\\\\u00f3n RGB y compatibilidad con PC\\\\\\/laptops\\\\\\/macOS, ofreciendo versatilidad, durabilidad y rendimiento tanto para gaming como para productividad.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:16:40','2025-12-23 21:16:40'),(148,255,'<p>El&nbsp;Teclado&nbsp;Machenike&nbsp;K500-B61&nbsp;Switch&nbsp;Rojo&nbsp;es&nbsp;un&nbsp;teclado&nbsp;gamer&nbsp;mecánico&nbsp;con&nbsp;retroiluminación&nbsp;RGB&nbsp;y&nbsp;switches&nbsp;rojos&nbsp;lineales,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;escritura&nbsp;suave,&nbsp;rápida&nbsp;y&nbsp;silenciosa,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;y&nbsp;uso&nbsp;diario&nbsp;con&nbsp;estilo&nbsp;gamer.</p>','\"[{\\\"nombre\\\":\\\"TECLADO MACHENIKE K500-B61 SWITCH ROJO\\\",\\\"valor\\\":\\\"MACHENIKE \\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO MACHENIKE\\\",\\\"detalle\\\":\\\"TECLADO MACHENIKE K500-B61 SWITCH ROJO Cuenta con switches mec\\\\u00e1nicos rojos lineales para pulsaciones r\\\\u00e1pidas y sin clic audible, retroiluminaci\\\\u00f3n RGB personalizable, anticontrol de ghosting y N-Key Rollover para registrar m\\\\u00faltiples teclas simult\\\\u00e1neamente, estructura robusta con teclas ABS de doble inyecci\\\\u00f3n, conexi\\\\u00f3n USB con cable trenzado resistente, y compatibilidad con Windows y sistemas comunes, entregando precisi\\\\u00f3n, durabilidad y estilo gamer en un teclado mec\\\\u00e1nico accesible.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:27:43','2025-12-23 21:27:43'),(149,256,'<p>El&nbsp;Teclado&nbsp;Corsair&nbsp;K63&nbsp;LED&nbsp;Azul&nbsp;(Switch&nbsp;Cherry&nbsp;MX&nbsp;Red)&nbsp;Mecánico&nbsp;Wireless/Bluetooth&nbsp;(PN:&nbsp;90MP0317-BKAA-01)&nbsp;es&nbsp;un&nbsp;teclado&nbsp;mecánico&nbsp;compacto&nbsp;y&nbsp;versátil&nbsp;especialmente&nbsp;diseñado&nbsp;para&nbsp;gamers&nbsp;y&nbsp;usuarios&nbsp;exigentes,&nbsp;que&nbsp;combina&nbsp;interruptores&nbsp;Cherry&nbsp;MX&nbsp;Red&nbsp;de&nbsp;acción&nbsp;lineal&nbsp;suave&nbsp;con&nbsp;conectividad&nbsp;inalámbrica&nbsp;y&nbsp;Bluetooth,&nbsp;iluminación&nbsp;LED&nbsp;azul&nbsp;y&nbsp;construcción&nbsp;sólida,&nbsp;ofreciendo&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;escritura&nbsp;y&nbsp;juego&nbsp;precisa,&nbsp;cómoda&nbsp;y&nbsp;sin&nbsp;cables.</p>','\"[{\\\"nombre\\\":\\\"TECLADO CORSAIR K63 LED AZUL SWITCH CHERRY MX RED MECANICO WIRELESS\\\\\\/BLUETOOTH (PN:90MP0317-BKAA01)\\\",\\\"valor\\\":\\\" CORSAIR\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO CORSAIR\\\",\\\"detalle\\\":\\\"TECLADO CORSAIR K63 LED AZUL SWITCH CHERRY MX RED MECANICO WIRELESS\\\\\\/BLUETOOTH Cuenta con switches mec\\\\u00e1nicos Cherry MX Red de perfil bajo para pulsaciones suaves y r\\\\u00e1pidas, retroiluminaci\\\\u00f3n LED azul, conectividad inal\\\\u00e1mbrica 2.4 GHz y Bluetooth con emparejamiento m\\\\u00faltiple, antic ghosting y rollover completo (N-Key), teclado compacto sin teclado num\\\\u00e9rico (tenkeyless), bater\\\\u00eda recargable de larga duraci\\\\u00f3n, construcci\\\\u00f3n robusta con carcasa s\\\\u00f3lida y teclas duraderas, y compatibilidad amplia con Windows y otros sistemas, proporcionando precisi\\\\u00f3n, respuesta r\\\\u00e1pida y comodidad tanto en juegos como en productividad.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:36:11','2025-12-23 21:36:11'),(150,257,'<p>El&nbsp;Teclado&nbsp;Enkore&nbsp;Patriot&nbsp;ENK-1013&nbsp;Rainbow&nbsp;Mecánico&nbsp;es&nbsp;un&nbsp;teclado&nbsp;gamer&nbsp;mecánico&nbsp;con&nbsp;iluminación&nbsp;RGB&nbsp;tipo&nbsp;arcoíris&nbsp;y&nbsp;conexión&nbsp;USB&nbsp;cableada,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;respuestas&nbsp;rápidas,&nbsp;durabilidad&nbsp;y&nbsp;estilo&nbsp;gamer&nbsp;vibrante,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;y&nbsp;usuarios&nbsp;que&nbsp;buscan&nbsp;precisión&nbsp;y&nbsp;estética&nbsp;llamativa&nbsp;en&nbsp;su&nbsp;setup.</p>','\"[{\\\"nombre\\\":\\\"TECLADO ENKORE PATRIOT ENK 1013 RAINBOW MECANICO CONEXION WIRED USB\\\",\\\"valor\\\":\\\"ENKORE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO ENKORE \\\",\\\"detalle\\\":\\\"TECLADO ENKORE PATRIOT ENK 1013 RAINBOW MECANICO CONEXION WIRED USB Cuenta con teclas mec\\\\u00e1nicas de respuesta r\\\\u00e1pida, retroiluminaci\\\\u00f3n RGB Rainbow con m\\\\u00faltiples efectos, conexi\\\\u00f3n USB Wired para respuesta inmediata y sin latencia, antic ghosting y rollover mejorado para registrar m\\\\u00faltiples teclas simult\\\\u00e1neamente, estructura robusta y teclas duraderas, y compatibilidad con Windows, proporcionando experiencia de escritura y juego precisa, c\\\\u00f3moda y visualmente atractiva.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:40:33','2025-12-23 21:40:33'),(151,258,'<p>El&nbsp;Kit&nbsp;Antryx&nbsp;GC-3100&nbsp;Black&nbsp;RGB&nbsp;combina&nbsp;un&nbsp;teclado&nbsp;mecánico&nbsp;con&nbsp;switches&nbsp;rojos&nbsp;y&nbsp;un&nbsp;mouse&nbsp;USB&nbsp;cableado,&nbsp;ambos&nbsp;con&nbsp;iluminación&nbsp;RGB,&nbsp;ofreciendo&nbsp;una&nbsp;experiencia&nbsp;gamer&nbsp;completa,&nbsp;cómoda&nbsp;y&nbsp;visualmente&nbsp;atractiva&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;rendimiento&nbsp;y&nbsp;estilo&nbsp;en&nbsp;un&nbsp;pack&nbsp;accesible.</p>','\"[{\\\"nombre\\\":\\\"KIT ANTRYX GC-3100 BLACK RGB TECLADO MECANICO SWITCH RED USB + MOUSE WIRED USB (PN:AGC-3100KRE-SP)\\\",\\\"valor\\\":\\\"ANTRYX\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO ANTRYX\\\",\\\"detalle\\\":\\\"KIT ANTRYX GC-3100 BLACK RGB TECLADO MECANICO SWITCH RED USB + MOUSE WIRED USB (PN:AGC-3100KRE-SP) Incluye un teclado mec\\\\u00e1nico con switches rojos lineales para pulsaciones suaves y r\\\\u00e1pidas, retroiluminaci\\\\u00f3n RGB con efectos personalizables, conexi\\\\u00f3n USB Wired con antic ghosting y rollover mejorado; y un mouse gaming USB cableado con sensor preciso, varios DPI ajustables, iluminaci\\\\u00f3n RGB y dise\\\\u00f1o ergon\\\\u00f3mico, proporcionando control preciso, respuesta r\\\\u00e1pida y est\\\\u00e9tica gamer integrada compatible con Windows y otros sistemas.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:45:12','2025-12-23 21:45:12'),(152,259,'<p>El&nbsp;Teclado&nbsp;Antryx&nbsp;MK840L&nbsp;Black&nbsp;Gray&nbsp;Rainbow&nbsp;es&nbsp;un&nbsp;teclado&nbsp;gamer&nbsp;mecánico&nbsp;con&nbsp;switches&nbsp;rojos&nbsp;lineales&nbsp;y&nbsp;retroiluminación&nbsp;RGB&nbsp;tipo&nbsp;arcoíris,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;teclado&nbsp;mecánico&nbsp;responsivo&nbsp;y&nbsp;visual&nbsp;atractivo&nbsp;en&nbsp;setups&nbsp;gaming&nbsp;o&nbsp;de&nbsp;productividad,&nbsp;con&nbsp;conexión&nbsp;USB&nbsp;cableada&nbsp;para&nbsp;respuesta&nbsp;inmediata&nbsp;y&nbsp;sin&nbsp;latencia.</p>','\"[{\\\"nombre\\\":\\\"TECLADO ANTRYX MK840L BLACK GRAY RAINBOW SWITCH RED MECANICO WIRED USB (PN:AMK-CS840LKGRE-SP)\\\",\\\"valor\\\":\\\"ANTRYX\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO ANTRYX\\\",\\\"detalle\\\":\\\"TECLADO ANTRYX MK840L BLACK GRAY RAINBOW SWITCH RED MECANICO WIRED USB Cuenta con switches mec\\\\u00e1nicos Red (lineales) para pulsaciones suaves y r\\\\u00e1pidas, retroiluminaci\\\\u00f3n RGB Rainbow con m\\\\u00faltiples efectos, conexi\\\\u00f3n USB Wired con cable trenzado resistente, antic ghosting y rollover mejorado para registrar m\\\\u00faltiples teclas simult\\\\u00e1neamente, estructura robusta con teclas duraderas y compatibilidad con Windows y otros sistemas, proporcionando precisi\\\\u00f3n en juegos, comodidad al escribir y estilo gamer llamativo.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:49:34','2025-12-23 21:49:34'),(153,260,'<p>El&nbsp;Teclado&nbsp;ASUS&nbsp;TUF&nbsp;Gaming&nbsp;K1&nbsp;RA04&nbsp;RGB&nbsp;es&nbsp;un&nbsp;teclado&nbsp;gamer&nbsp;de&nbsp;membrana&nbsp;con&nbsp;iluminación&nbsp;RGB&nbsp;personalizable&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;escritura&nbsp;suave&nbsp;y&nbsp;silenciosa&nbsp;junto&nbsp;con&nbsp;una&nbsp;estética&nbsp;gamer&nbsp;llamativa,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;y&nbsp;usuarios&nbsp;que&nbsp;buscan&nbsp;comodidad,&nbsp;durabilidad&nbsp;y&nbsp;estilo&nbsp;en&nbsp;un&nbsp;teclado&nbsp;con&nbsp;conexión&nbsp;USB&nbsp;cableada.</p>','\"[{\\\"nombre\\\":\\\"TECLADO ASUS TUF GAMING K1 RA04 RGB MEMBRANA WIRED USB\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO ASUS\\\",\\\"detalle\\\":\\\"TECLADO ASUS TUF GAMING K1 RA04 RGB MEMBRANA WIRED USB Cuenta con teclas de membrana silenciosas y c\\\\u00f3modas, retroiluminaci\\\\u00f3n RGB con efectos personalizables, conexi\\\\u00f3n USB Wired plug-and-play sin necesidad de software adicional, estructura resistente con dise\\\\u00f1o TUF Gaming para uso prolongado, antic ghosting en teclas comunes y compatibilidad con Windows, proporcionando comodidad, respuesta fiable y estilo gamer iluminado.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:54:30','2025-12-23 21:54:30'),(154,261,'<p>El&nbsp;Teclado&nbsp;Antryx&nbsp;MK&nbsp;Zigra&nbsp;Evo&nbsp;Black&nbsp;Gray&nbsp;Mecánico&nbsp;(Red&nbsp;Switch)&nbsp;Wired&nbsp;USB&nbsp;es&nbsp;un&nbsp;teclado&nbsp;gamer&nbsp;mecánico&nbsp;con&nbsp;switches&nbsp;rojos&nbsp;lineales&nbsp;y&nbsp;diseño&nbsp;robusto&nbsp;en&nbsp;negro&nbsp;y&nbsp;gris,&nbsp;que&nbsp;ofrece&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;escritura&nbsp;suave,&nbsp;rápida&nbsp;y&nbsp;silenciosa&nbsp;con&nbsp;estilo&nbsp;gamer&nbsp;atractivo,&nbsp;ideal&nbsp;para&nbsp;juegos&nbsp;y&nbsp;uso&nbsp;diario&nbsp;con&nbsp;conexión&nbsp;USB&nbsp;cableada&nbsp;para&nbsp;respuesta&nbsp;inmediata.</p>','\"[{\\\"nombre\\\":\\\"TECLADO ANTRYX MK ZIGRA EVO BLACK GRAY MECANICO RED SWITCH WIRED USB \\\",\\\"valor\\\":\\\"ANTRYX\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO ANTRYX\\\",\\\"detalle\\\":\\\"TECLADO ANTRYX MK ZIGRA EVO BLACK GRAY MECANICO RED SWITCH WIRED USB  Cuenta con switches mec\\\\u00e1nicos Red (lineales) para pulsaciones r\\\\u00e1pidas y fluidas, conexi\\\\u00f3n USB Wired con cable trenzado resistente, retroiluminaci\\\\u00f3n RGB (o efectos Rainbow), antic ghosting\\\\\\/N-Key Rollover mejorado para registrar m\\\\u00faltiples teclas simult\\\\u00e1neamente, estructura s\\\\u00f3lida con teclas duraderas y compatibilidad con Windows y otros sistemas, proporcionando precisi\\\\u00f3n, durabilidad y estilo gamer en un teclado mec\\\\u00e1nico fiable.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 21:58:35','2025-12-23 21:58:35'),(155,262,'<p>El&nbsp;Teclado&nbsp;Cybertel&nbsp;Striker&nbsp;CBX&nbsp;K1008-3M&nbsp;es&nbsp;un&nbsp;teclado&nbsp;mecánico&nbsp;gamer&nbsp;RGB,&nbsp;compacto&nbsp;(96&nbsp;teclas),&nbsp;con&nbsp;triple&nbsp;conectividad&nbsp;(Bluetooth,&nbsp;WiFi&nbsp;2.4GHz&nbsp;y&nbsp;cable&nbsp;USB-C),&nbsp;ideal&nbsp;para&nbsp;juegos&nbsp;y&nbsp;productividad,&nbsp;destacando&nbsp;por&nbsp;sus&nbsp;switches&nbsp;mecánicos&nbsp;(rojos&nbsp;o&nbsp;azules,&nbsp;según&nbsp;versión),&nbsp;retroiluminación&nbsp;LED&nbsp;RGB&nbsp;personalizable,&nbsp;perilla&nbsp;para&nbsp;control&nbsp;de&nbsp;volumen&nbsp;y&nbsp;efectos,&nbsp;teclas&nbsp;elevadas,&nbsp;sistema&nbsp;anti-ghosting&nbsp;y&nbsp;compatibilidad&nbsp;multiplataforma&nbsp;(Windows,&nbsp;macOS,&nbsp;Android,&nbsp;Linux).</p>','\"[{\\\"nombre\\\":\\\"TECLADO CYBERTEL STRIKER CBX K1008-3M RGB MECANICO WIRELESS\\\\\\/BLUETOOTH\\\",\\\"valor\\\":\\\"CYBERTEL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO CYBERTEL\\\",\\\"detalle\\\":\\\"El Teclado Cybertel Striker CBX K1008-3M es un teclado mec\\\\u00e1nico gamer compacto (96 teclas) con switches mec\\\\u00e1nicos (azules o rojos, seg\\\\u00fan versi\\\\u00f3n), conectividad inal\\\\u00e1mbrica (Wireless 2.4GHz) y Bluetooth, adem\\\\u00e1s de cable USB-C, iluminaci\\\\u00f3n RGB personalizable, bater\\\\u00eda recargable, teclas elevadas para confort, funci\\\\u00f3n multimedia (FN), anti-ghosting y una perilla para control de LED y volumen, compatible con m\\\\u00faltiples sistemas operativos.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 22:12:05','2025-12-23 22:12:05'),(156,263,'<p>El&nbsp;Logitech&nbsp;G&nbsp;PRO&nbsp;X&nbsp;60&nbsp;LIGHTSPEED&nbsp;es&nbsp;un&nbsp;teclado&nbsp;gamer&nbsp;inalámbrico&nbsp;compacto&nbsp;(60%)&nbsp;para&nbsp;juegos&nbsp;competitivos,&nbsp;con&nbsp;switches&nbsp;ópticos&nbsp;(GX&nbsp;Tactile/Blue),&nbsp;conectividad&nbsp;triple&nbsp;(LIGHTSPEED&nbsp;2.4GHz,&nbsp;Bluetooth,&nbsp;USB-C),&nbsp;personalización&nbsp;RGB&nbsp;LIGHTSYNC,&nbsp;y&nbsp;funciones&nbsp;avanzadas&nbsp;como&nbsp;KEYCONTROL&nbsp;para&nbsp;macros,&nbsp;ofreciendo&nbsp;portabilidad&nbsp;y&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;hasta&nbsp;65h&nbsp;de&nbsp;batería,&nbsp;ideal&nbsp;para&nbsp;profesionales&nbsp;de&nbsp;esports.</p>','\"[{\\\"nombre\\\":\\\"TECLADO LOGITECH G PRO X 60 LIGTHSPEED BLACK RGB MECANICO WIRELES\\\\\\/BLUETOOTH\\\\\\/WIRED USB \\\",\\\"valor\\\":\\\"LOGITECH\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TECLADO LOGITECH \\\",\\\"detalle\\\":\\\"El Logitech G PRO X 60 LIGHTSPEED es un teclado compacto 60% para gaming, con dise\\\\u00f1o profesional, switches \\\\u00f3pticos GX t\\\\u00e1ctiles, personalizaci\\\\u00f3n RGB LIGHTSYNC y conexi\\\\u00f3n triple (LIGHTSPEED 2.4GHz, Bluetooth, USB), destacando por su velocidad de respuesta de 1ms, duraci\\\\u00f3n de bater\\\\u00eda (hasta 65h), alta portabilidad y software de personalizaci\\\\u00f3n G HUB con funci\\\\u00f3n KEYCONTROL para asignar hasta 15 funciones por tecla, ideal para esports y m\\\\u00e1xima eficiencia espacial.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 22:21:25','2025-12-23 22:21:25'),(157,264,'<p>La&nbsp;Gigabyte&nbsp;AORUS&nbsp;Elite&nbsp;Radeon&nbsp;RX&nbsp;9070&nbsp;XT&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;alta&nbsp;de&nbsp;AMD,&nbsp;parte&nbsp;de&nbsp;la&nbsp;línea&nbsp;AORUS,&nbsp;con&nbsp;16GB&nbsp;de&nbsp;memoria&nbsp;GDDR6&nbsp;en&nbsp;bus&nbsp;de&nbsp;256&nbsp;bits,&nbsp;interfaz&nbsp;PCI-E&nbsp;5.0,&nbsp;y&nbsp;un&nbsp;robusto&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;WINDFORCE&nbsp;de&nbsp;3&nbsp;ventiladores&nbsp;para&nbsp;mantener&nbsp;bajas&nbsp;temperaturas,&nbsp;ofreciendo&nbsp;rendimiento&nbsp;superior&nbsp;en&nbsp;resolución&nbsp;1440p&nbsp;y&nbsp;defendiéndose&nbsp;bien&nbsp;en&nbsp;4K&nbsp;gracias&nbsp;a&nbsp;su&nbsp;arquitectura&nbsp;RDNA4,&nbsp;compatibilidad&nbsp;con&nbsp;FSR&nbsp;4&nbsp;y&nbsp;tecnologías&nbsp;de&nbsp;IA,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;exigente&nbsp;y&nbsp;creación&nbsp;de&nbsp;contenido&nbsp;con&nbsp;un&nbsp;diseño&nbsp;premium,&nbsp;pero&nbsp;requiere&nbsp;buena&nbsp;ventilación&nbsp;y&nbsp;fuente&nbsp;de&nbsp;poder.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO GIGABYTE AORUS ELITE RADEON RX 9070\\\",\\\"valor\\\":\\\"AORUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO GIGABYTE AORUS\\\",\\\"detalle\\\":\\\"La Gigabyte AORUS Elite Radeon RX 9070 XT es una potente tarjeta gr\\\\u00e1fica de gama alta basada en la arquitectura RDNA 4 de AMD, que cuenta con 16GB de memoria GDDR6, un bus de 256 bits, y soporta PCIe 5.0, destacando por su gran disipaci\\\\u00f3n t\\\\u00e9rmica (sistema WINDFORCE), un robusto dise\\\\u00f1o de alimentaci\\\\u00f3n (15 fases), y caracter\\\\u00edsticas como FSR 4 y un excelente rendimiento en 1440p y 4K, aunque con un alto consumo y requerimiento de fuente de 850W con 3 conectores de 8 pines.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 22:29:31','2025-12-23 22:29:31'),(158,265,'<p>La&nbsp;Gigabyte&nbsp;Radeon&nbsp;RX&nbsp;9070&nbsp;Gaming&nbsp;OC&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;alta,&nbsp;basada&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;RDNA&nbsp;4&nbsp;de&nbsp;AMD,&nbsp;diseñada&nbsp;para&nbsp;juegos&nbsp;exigentes&nbsp;en&nbsp;1440p&nbsp;y&nbsp;4K,&nbsp;con&nbsp;16GB&nbsp;de&nbsp;memoria&nbsp;GDDR6&nbsp;y&nbsp;un&nbsp;bus&nbsp;de&nbsp;256&nbsp;bits,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;potente&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;WINDFORCE,&nbsp;iluminación&nbsp;RGB&nbsp;personalizable&nbsp;y&nbsp;características&nbsp;como&nbsp;AMD&nbsp;HYPR-RX&nbsp;para&nbsp;optimizar&nbsp;rendimiento&nbsp;y&nbsp;latencia,&nbsp;ofreciendo&nbsp;un&nbsp;gran&nbsp;equilibrio&nbsp;entre&nbsp;potencia,&nbsp;refrigeración&nbsp;y&nbsp;estética&nbsp;moderna&nbsp;para&nbsp;gaming&nbsp;y&nbsp;creación&nbsp;de&nbsp;contenido.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO GIGABYTE RADEON RX9070 GAMING OC\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO GIGABYTE \\\",\\\"detalle\\\":\\\"La Gigabyte Radeon RX 9070 Gaming OC es una tarjeta gr\\\\u00e1fica de alto rendimiento basada en la arquitectura AMD RDNA 4, con 16GB de memoria GDDR6 (256 bits, 20Gbps), enfocada en gaming 4K y creaci\\\\u00f3n de contenido, ofreciendo clocks superiores a los de referencia (hasta 2700 MHz Boost) y tecnolog\\\\u00edas como HYPR-RX e FSR 4, con un dise\\\\u00f1o WINDFORCE de refrigeraci\\\\u00f3n avanzada, iluminaci\\\\u00f3n RGB, y conectividad PCIe 5.0 y DisplayPort 2.1.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 22:41:04','2025-12-23 22:41:04'),(159,266,'<p>La&nbsp;MSI&nbsp;GeForce&nbsp;RTX&nbsp;5090&nbsp;32G&nbsp;GAMING&nbsp;TRIO&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;alta&nbsp;con&nbsp;la&nbsp;arquitectura&nbsp;Blackwell,&nbsp;32GB&nbsp;de&nbsp;memoria&nbsp;GDDR7&nbsp;ultrarrápida&nbsp;(28&nbsp;Gbps),&nbsp;21,760&nbsp;núcleos&nbsp;CUDA,&nbsp;bus&nbsp;de&nbsp;512&nbsp;bits,&nbsp;PCI&nbsp;Express&nbsp;5.0&nbsp;y&nbsp;un&nbsp;diseño&nbsp;TRIO&nbsp;de&nbsp;triple&nbsp;ventilador&nbsp;para&nbsp;una&nbsp;refrigeración&nbsp;superior,&nbsp;ofreciendo&nbsp;rendimiento&nbsp;extremo&nbsp;en&nbsp;4K&nbsp;y&nbsp;cargas&nbsp;de&nbsp;trabajo&nbsp;creativas,&nbsp;con&nbsp;un&nbsp;consumo&nbsp;de&nbsp;575W&nbsp;y&nbsp;un&nbsp;conector&nbsp;de&nbsp;12&nbsp;pines.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO RTX 5090 32G GAMING TRIO GDDR7\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO MSI\\\",\\\"detalle\\\":\\\"La MSI RTX 5090 Gaming Trio GDDR7 es una tarjeta gr\\\\u00e1fica de gama ultra alta basada en la arquitectura NVIDIA Blackwell, con 32GB de memoria GDDR7 ultrarr\\\\u00e1pida, interfaz PCIe 5.0, hasta 21760 n\\\\u00facleos CUDA, soporte para DLSS 4 y Ray Tracing de \\\\u00faltima generaci\\\\u00f3n, ideal para gaming 4K\\\\\\/8K y creaci\\\\u00f3n de contenido profesional, ofreciendo un rendimiento sin precedentes y un consumo energ\\\\u00e9tico de hasta 575W, refrigerada por el sistema TRI FROZR 4 de MSI para mantener la eficiencia y el silencio.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 22:49:47','2025-12-23 22:49:47'),(160,267,'<p>La&nbsp;Gigabyte&nbsp;RTX&nbsp;5070&nbsp;WINDFORCE&nbsp;SFF&nbsp;12G&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;compacta&nbsp;basada&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Blackwell&nbsp;de&nbsp;NVIDIA,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;en&nbsp;1440p&nbsp;y&nbsp;4K,&nbsp;con&nbsp;12GB&nbsp;de&nbsp;memoria&nbsp;GDDR7,&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;Windforce&nbsp;de&nbsp;3&nbsp;ventiladores,&nbsp;soporte&nbsp;para&nbsp;DLSS&nbsp;4&nbsp;y&nbsp;Ray&nbsp;Tracing,&nbsp;y&nbsp;un&nbsp;diseño&nbsp;SFF&nbsp;(Factor&nbsp;de&nbsp;Forma&nbsp;Pequeño)&nbsp;perfecto&nbsp;para&nbsp;gabinetes&nbsp;compactos,&nbsp;ofreciendo&nbsp;alto&nbsp;rendimiento&nbsp;en&nbsp;un&nbsp;tamaño&nbsp;reducido&nbsp;y&nbsp;eficiente&nbsp;en&nbsp;refrigeración.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO GIGABYTE RTX 5070 WINDFORCE SFF 12G\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO GIGABYTE\\\",\\\"detalle\\\":\\\"La Gigabyte RTX 5070 WINDFORCE SFF 12G es una tarjeta gr\\\\u00e1fica compacta (SFF) de la arquitectura Blackwell, ideal para gaming en 1440p\\\\\\/4K, con 12GB GDDR7, sistema de enfriamiento WINDFORCE de 3 ventiladores, soporte para DLSS 4, Ray Tracing de 4\\\\u00aa Gen y salidas DisplayPort 2.1 \\\\\\/ HDMI 2.1, ofreciendo gran potencia en un tama\\\\u00f1o reducido para PCs compactas.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 22:56:04','2025-12-23 22:56:04'),(161,268,'<p>La&nbsp;Gigabyte&nbsp;RTX&nbsp;5060&nbsp;Eagle&nbsp;Max&nbsp;OC&nbsp;8GB&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;nueva&nbsp;generación&nbsp;(arquitectura&nbsp;Blackwell)&nbsp;para&nbsp;gaming&nbsp;1080p/1440p,&nbsp;con&nbsp;8GB&nbsp;de&nbsp;memoria&nbsp;GDDR7,&nbsp;interfaz&nbsp;de&nbsp;128&nbsp;bits,&nbsp;y&nbsp;refrigeración&nbsp;WINDFORCE&nbsp;de&nbsp;triple&nbsp;ventilador&nbsp;(alterno),&nbsp;que&nbsp;ofrece&nbsp;buen&nbsp;rendimiento&nbsp;gracias&nbsp;a&nbsp;DLSS&nbsp;4&nbsp;y&nbsp;un&nbsp;diseño&nbsp;robusto&nbsp;con&nbsp;backplate&nbsp;metálico,&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;compactos&nbsp;y&nbsp;gaming&nbsp;moderno</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO GIGABYTE RTX 5060 EAGLE MAX OC 8GB\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO GIGABYTE\\\",\\\"detalle\\\":\\\"La Gigabyte RTX 5060 Eagle Max OC 8GB es una tarjeta gr\\\\u00e1fica de nueva generaci\\\\u00f3n con arquitectura Blackwell, 8GB de memoria GDDR7 en bus de 128 bits, tecnolog\\\\u00eda DLSS 4 y Ray Tracing, ideal para gaming en 1080p\\\\\\/1440p, con un dise\\\\u00f1o de triple ventilador (X3 Fan) para excelente refrigeraci\\\\u00f3n y un consumo eficiente, usando un solo conector de 8 pines y ofreciendo conectividad DisplayPort 2.1b y HDMI 2.1b.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:05:02','2025-12-23 23:05:02'),(162,269,'<p>La&nbsp;GIGABYTE&nbsp;AORUS&nbsp;RTX&nbsp;5080&nbsp;XTREME&nbsp;es&nbsp;una&nbsp;potente&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;alta&nbsp;basada&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;NVIDIA&nbsp;Blackwell,&nbsp;que&nbsp;ofrece&nbsp;16GB&nbsp;de&nbsp;memoria&nbsp;GDDR7&nbsp;ultrarrápida,&nbsp;núcleos&nbsp;CUDA&nbsp;masivos&nbsp;(10752),&nbsp;y&nbsp;un&nbsp;rendimiento&nbsp;superior&nbsp;para&nbsp;gaming&nbsp;en&nbsp;4K+&nbsp;con&nbsp;tecnologías&nbsp;DLSS&nbsp;4&nbsp;y&nbsp;Ray&nbsp;Tracing&nbsp;avanzado.&nbsp;Su&nbsp;característica&nbsp;principal&nbsp;es&nbsp;el&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;WATERFORCE&nbsp;AIO,&nbsp;con&nbsp;un&nbsp;radiador&nbsp;de&nbsp;360mm&nbsp;y&nbsp;ventiladores&nbsp;ARGB,&nbsp;que&nbsp;mantiene&nbsp;la&nbsp;GPU,&nbsp;VRAM&nbsp;y&nbsp;MOSFET&nbsp;fríos&nbsp;para&nbsp;un&nbsp;overclocking&nbsp;extremo,&nbsp;incluyendo&nbsp;una&nbsp;pantalla&nbsp;LCD&nbsp;integrada&nbsp;y&nbsp;un&nbsp;diseño&nbsp;robusto&nbsp;con&nbsp;placa&nbsp;metálica.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO GIGABYTE AORUS RTX5080 XTREME\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO GIGABYTE\\\",\\\"detalle\\\":\\\"La Gigabyte AORUS RTX 5080 XTREME es una tarjeta gr\\\\u00e1fica de gama alta basada en la arquitectura NVIDIA Blackwell, con 16GB de memoria GDDR7, refrigeraci\\\\u00f3n l\\\\u00edquida AIO (Waterforce) con radiador de 360mm, n\\\\u00facleos CUDA, Tensor y RT de \\\\u00faltima generaci\\\\u00f3n, soporte para DLSS 4, y caracter\\\\u00edsticas premium como metal l\\\\u00edquido, backplate met\\\\u00e1lico, y RGB, ofreciendo rendimiento extremo en 4K y m\\\\u00e1s all\\\\u00e1, ideal para gaming y creaci\\\\u00f3n de contenido profesional.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:13:57','2025-12-23 23:13:57'),(163,270,'<p>La&nbsp;MSI&nbsp;GeForce&nbsp;RTX&nbsp;5070&nbsp;Ti&nbsp;16G&nbsp;INSPIRE&nbsp;3X&nbsp;OC&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;gaming&nbsp;y&nbsp;creación,&nbsp;basada&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;NVIDIA&nbsp;Blackwell,&nbsp;con&nbsp;16GB&nbsp;de&nbsp;memoria&nbsp;GDDR7,&nbsp;refrigeración&nbsp;avanzada&nbsp;de&nbsp;3&nbsp;ventiladores&nbsp;(STORMFORCE),&nbsp;placa&nbsp;base&nbsp;de&nbsp;cobre&nbsp;niquelado&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;tecnologías&nbsp;de&nbsp;IA&nbsp;como&nbsp;DLSS&nbsp;4,&nbsp;ofreciendo&nbsp;alto&nbsp;rendimiento&nbsp;para&nbsp;1440p&nbsp;y&nbsp;4K&nbsp;con&nbsp;Ray&nbsp;Tracing,&nbsp;y&nbsp;un&nbsp;diseño&nbsp;optimizado&nbsp;para&nbsp;PC&nbsp;compactos&nbsp;(SFF).</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO MSI GEFORCE RTX 5070 Ti 16G INSPIRE 3X OC\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO MSI \\\",\\\"detalle\\\":\\\"La MSI GeForce RTX 5070 Ti 16G INSPIRE 3X OC{\\\\\\/nav} es una potente tarjeta gr\\\\u00e1fica de gama entusiasta, basada en la arquitectura NVIDIA Blackwell, que ofrece 16GB de memoria GDDR7, refrigeraci\\\\u00f3n de triple ventilador (STORMFORCE con ventiladores optimizados), compatibilidad con PCIe 5.0, y caracter\\\\u00edsticas de IA avanzadas como DLSS 4, ideal para gaming 2K\\\\\\/4K y creaci\\\\u00f3n de contenido, destacando por su buen rendimiento y dise\\\\u00f1o t\\\\u00e9rmico eficiente con cobre niquelado y tubos de calor cuadrados.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:19:52','2025-12-23 23:19:52'),(164,271,'<p>La&nbsp;Gigabyte&nbsp;RTX&nbsp;5060&nbsp;Ti&nbsp;Eagle&nbsp;OC&nbsp;Ice&nbsp;16GB&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;basada&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;NVIDIA&nbsp;Blackwell,&nbsp;destacando&nbsp;por&nbsp;sus&nbsp;16GB&nbsp;de&nbsp;memoria&nbsp;GDDR7,&nbsp;ideal&nbsp;para&nbsp;juegos&nbsp;en&nbsp;resolución&nbsp;1080p&nbsp;y&nbsp;2K&nbsp;(QHD)&nbsp;con&nbsp;DLSS&nbsp;4,&nbsp;con&nbsp;un&nbsp;potente&nbsp;sistema&nbsp;de&nbsp;refrigeración&nbsp;WINDFORCE,&nbsp;diseño&nbsp;blanco&nbsp;Ice&nbsp;y&nbsp;conectividad&nbsp;PCIe&nbsp;5.0&nbsp;para&nbsp;un&nbsp;excelente&nbsp;rendimiento&nbsp;térmico&nbsp;y&nbsp;visual&nbsp;en&nbsp;juegos&nbsp;modernos.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO GIGABYTE RTX 5060TI EAGLE OC ICE 16GB\\\",\\\"valor\\\":\\\"GIGABYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO GIGABYTE\\\",\\\"detalle\\\":\\\"La Gigabyte RTX 5060 Ti EAGLE OC ICE 16GB es una tarjeta gr\\\\u00e1fica de gama media-alta, basada en la arquitectura NVIDIA Blackwell, que destaca por sus 16GB de memoria GDDR7 (128-bit), su sistema de refrigeraci\\\\u00f3n WINDFORCE con ventiladores de halc\\\\u00f3n, y caracter\\\\u00edsticas como DLSS 4, Ray Tracing, y soporte para PCI-E 5.0, ofreciendo rendimiento superior para gaming en 1080p y QHD, con un consumo de alrededor de 180W y un conector de energ\\\\u00eda de 8 pines.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:25:26','2025-12-23 23:25:26'),(165,272,'<p>La&nbsp;ASUS&nbsp;GeForce&nbsp;RTX&nbsp;5060&nbsp;8GB&nbsp;GDDR7&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;media-baja&nbsp;basada&nbsp;en&nbsp;la&nbsp;arquitectura&nbsp;Blackwell,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;en&nbsp;1080p&nbsp;y&nbsp;algunos&nbsp;juegos&nbsp;en&nbsp;2K,&nbsp;ofreciendo&nbsp;excelente&nbsp;rendimiento&nbsp;en&nbsp;resolución&nbsp;Full&nbsp;HD&nbsp;con&nbsp;tecnologías&nbsp;IA&nbsp;como&nbsp;DLSS&nbsp;3&nbsp;y&nbsp;RT&nbsp;Cores,&nbsp;memoria&nbsp;GDDR7&nbsp;rápida,&nbsp;un&nbsp;robusto&nbsp;sistema&nbsp;de&nbsp;enfriamiento&nbsp;Axial-Tech&nbsp;de&nbsp;doble&nbsp;o&nbsp;triple&nbsp;ventilador&nbsp;según&nbsp;el&nbsp;modelo&nbsp;(Dual&nbsp;o&nbsp;Prime),&nbsp;y&nbsp;un&nbsp;diseño&nbsp;compacto&nbsp;de&nbsp;2.5&nbsp;ranuras&nbsp;para&nbsp;compatibilidad&nbsp;con&nbsp;PCs&nbsp;pequeñas,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;eficiencia&nbsp;y&nbsp;potencia&nbsp;en&nbsp;juegos&nbsp;actuales.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO ASUS GEFORCE RTX 5060 8GB GDDR7\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO ASUS\\\",\\\"detalle\\\":\\\"La ASUS GeForce RTX 5060 8GB GDDR7 es una tarjeta gr\\\\u00e1fica de gama media-baja basada en la arquitectura Blackwell, ideal para juegos en 1080p, que ofrece 8GB de memoria GDDR7 ultrarr\\\\u00e1pida, tecnolog\\\\u00eda DLSS 3.5 y hardware de trazado de rayos (RT Cores de 4\\\\u00aa gen y Tensor Cores de 5\\\\u00aa gen) para rendimiento y efectos visuales mejorados, con caracter\\\\u00edsticas como ventiladores Axial-Tech, Dual BIOS, y conectividad PCI Express 5.0, requiriendo una fuente de poder de 550W y un conector de 8 pines.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:30:59','2025-12-23 23:30:59'),(166,273,'<p>La&nbsp;ASRock&nbsp;Radeon&nbsp;RX&nbsp;9060&nbsp;XT&nbsp;8GB&nbsp;Steel&nbsp;Legend&nbsp;es&nbsp;una&nbsp;tarjeta&nbsp;gráfica&nbsp;de&nbsp;gama&nbsp;media-alta&nbsp;para&nbsp;gaming,&nbsp;con&nbsp;8GB&nbsp;GDDR6,&nbsp;interfaz&nbsp;PCIe&nbsp;5.0,&nbsp;diseño&nbsp;de&nbsp;triple&nbsp;ventilador&nbsp;(Steel&nbsp;Legend)&nbsp;para&nbsp;buena&nbsp;refrigeración,&nbsp;y&nbsp;conectividad&nbsp;moderna&nbsp;(DisplayPort&nbsp;2.1a,&nbsp;HDMI&nbsp;2.1b),&nbsp;enfocada&nbsp;en&nbsp;ofrecer&nbsp;alto&nbsp;rendimiento&nbsp;a&nbsp;1080p/1440p&nbsp;con&nbsp;tecnologías&nbsp;AMD&nbsp;avanzadas,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;y&nbsp;creadores&nbsp;de&nbsp;contenido&nbsp;que&nbsp;buscan&nbsp;una&nbsp;excelente&nbsp;relación&nbsp;calidad-precio&nbsp;y&nbsp;un&nbsp;diseño&nbsp;robusto.</p>','\"[{\\\"nombre\\\":\\\"TARJETA DE VIDEO ASROCK AMD RADEON RX 9060 XT 8GB STEEL\\\",\\\"valor\\\":\\\"AMD\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"TARJETA DE VIDEO ASROCK AMD\\\",\\\"detalle\\\":\\\"La ASRock Radeon RX 9060 XT Steel Legend 8GB es una GPU de gama media-alta de pr\\\\u00f3xima generaci\\\\u00f3n basada en la arquitectura AMD RDNA 4, ideal para juegos 1080p\\\\\\/1440p, con 8GB GDDR6, PCI Express 5.0, refrigeraci\\\\u00f3n robusta de triple ventilador (con modo 0dB), overclock de f\\\\u00e1brica hasta 3320 MHz (Boost) y conectividad moderna (DisplayPort 2.1a, HDMI 2.1b), ofreciendo tecnolog\\\\u00edas IA y un dise\\\\u00f1o premium Steel Legend.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:42:32','2025-12-23 23:42:32'),(167,274,'<p>El&nbsp;ASUS&nbsp;ROG&nbsp;Strix&nbsp;XG256Q&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gaming&nbsp;Fast&nbsp;IPS&nbsp;de&nbsp;24.5&quot;&nbsp;Full&nbsp;HD&nbsp;(1920x1080)&nbsp;enfocado&nbsp;en&nbsp;la&nbsp;velocidad,&nbsp;con&nbsp;una&nbsp;tasa&nbsp;de&nbsp;refresco&nbsp;de&nbsp;180Hz&nbsp;(OC),&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;de&nbsp;1ms&nbsp;(GTG),&nbsp;y&nbsp;soporte&nbsp;para&nbsp;AMD&nbsp;FreeSync&nbsp;Premium&nbsp;y&nbsp;NVIDIA&nbsp;G-Sync&nbsp;Compatible,&nbsp;ofreciendo&nbsp;imágenes&nbsp;fluidas&nbsp;y&nbsp;nítidas,&nbsp;certificación&nbsp;DisplayHDR&nbsp;400&nbsp;para&nbsp;mejor&nbsp;contraste,&nbsp;tecnologías&nbsp;como&nbsp;ELMB&nbsp;y&nbsp;GamePlus,&nbsp;y&nbsp;diseño&nbsp;ergonómico&nbsp;con&nbsp;soporte&nbsp;para&nbsp;trípode,&nbsp;ideal&nbsp;para&nbsp;gamers&nbsp;competitivos&nbsp;que&nbsp;buscan&nbsp;rendimiento&nbsp;sin&nbsp;interrupciones.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG STRIX XG256Q 24.5\\\\\\\" FHD 1920x1080\\\\\\/180HZ\\\\\\/1MS\\\\\\/FREESYNC PREMIUM\\\\\\/COMPATIBLE NVIDIA G-SYNC\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS\\\",\\\"detalle\\\":\\\"El ASUS ROG Strix XG256Q es un monitor gamer Fast IPS de 24.5\\\\\\\" Full HD (1920x1080) con tasa de refresco de 180Hz (OC) y 1ms de respuesta (GTG), ideal para esports, ofreciendo tecnolog\\\\u00eda NVIDIA G-Sync Compatible y AMD FreeSync Premium, HDR DisplayHDR\\\\u2122 400, ASUS Extreme Low Motion Blur, y un dise\\\\u00f1o ergon\\\\u00f3mico con soporte para tr\\\\u00edpode.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:47:38','2025-12-23 23:47:38'),(168,275,'<p>El&nbsp;ASUS&nbsp;ROG&nbsp;Strix&nbsp;XG27AQMR&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gamer&nbsp;de&nbsp;27&quot;&nbsp;QHD&nbsp;(2560x1440)&nbsp;con&nbsp;panel&nbsp;Fast&nbsp;IPS,&nbsp;que&nbsp;ofrece&nbsp;una&nbsp;velocidad&nbsp;extrema&nbsp;de&nbsp;300Hz,&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;de&nbsp;1ms&nbsp;(GTG)&nbsp;y&nbsp;tecnologías&nbsp;como&nbsp;FreeSync&nbsp;Premium&nbsp;Pro&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;NVIDIA&nbsp;G-SYNC&nbsp;para&nbsp;eliminar&nbsp;tearing,&nbsp;además&nbsp;de&nbsp;DisplayHDR&nbsp;600&nbsp;y&nbsp;una&nbsp;amplia&nbsp;gama&nbsp;de&nbsp;colores&nbsp;DCI-P3&nbsp;para&nbsp;una&nbsp;imagen&nbsp;vibrante&nbsp;y&nbsp;nítida,&nbsp;ideal&nbsp;para&nbsp;eSports&nbsp;competitivos&nbsp;y&nbsp;juegos&nbsp;inmersivos.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG STRIX XG27AQMR 27\\\\\\\" QHD 2560x1440\\\\\\/300HZ\\\\\\/1MS\\\\\\/FREESYNC PREMIUM PRO\\\\\\/COMPATIBLE NVIDIA G-SYNC\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS \\\",\\\"detalle\\\":\\\"El ASUS ROG Strix XG27AQMR es un monitor gaming Fast IPS de 27 pulgadas, con resoluci\\\\u00f3n QHD (2560x1440), una tasa de refresco rapid\\\\u00edsima de 300 Hz, tiempo de respuesta de 1 ms (GTG),\\\\\\/nav compatibilidad G-SYNC y FreeSync Premium Pro para juegos fluidos sin desgarros (tearing),\\\\\\/nav y certificaci\\\\u00f3n DisplayHDR 600 para colores vibrantes, ideal para eSports competitivos por su nitidez y velocidad.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:53:54','2025-12-23 23:53:54'),(169,276,'<p>El&nbsp;ASUS&nbsp;ROG&nbsp;Strix&nbsp;XG309CM&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gaming&nbsp;ultrawide&nbsp;de&nbsp;29.5&quot;&nbsp;con&nbsp;panel&nbsp;Fast&nbsp;IPS,&nbsp;resolución&nbsp;WFHD&nbsp;(2560x1080),&nbsp;frecuencia&nbsp;de&nbsp;refresco&nbsp;de&nbsp;220Hz&nbsp;(overclock),&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;de&nbsp;1ms&nbsp;(GTG)&nbsp;y&nbsp;compatibilidad&nbsp;con&nbsp;G-Sync&nbsp;y&nbsp;FreeSync&nbsp;Premium,&nbsp;ofreciendo&nbsp;imágenes&nbsp;nítidas&nbsp;y&nbsp;fluidas&nbsp;para&nbsp;juegos&nbsp;competitivos,&nbsp;además&nbsp;de&nbsp;características&nbsp;como&nbsp;USB-C,&nbsp;KVM&nbsp;y&nbsp;un&nbsp;soporte&nbsp;con&nbsp;socket&nbsp;para&nbsp;trípode&nbsp;para&nbsp;versatilidad.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG STRIX XG309CM 29.5\\\\\\\" WFHD 2560x1080\\\\\\/220HZ\\\\\\/1MS\\\\\\/FREESYNC PREMIUM\\\\\\/COMPATIBLE NVIDIA G-SYNC\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS\\\",\\\"detalle\\\":\\\"El ASUS ROG Strix XG309CM es un monitor gaming ultrawide de 29.5 pulgadas, con panel Fast IPS, resoluci\\\\u00f3n WFHD (2560x1080), tasa de refresco de 220Hz, tiempo de respuesta de 1ms (GTG), y tecnolog\\\\u00edas Adaptive Sync como FreeSync Premium y G-Sync Compatible para juegos fluidos, ofreciendo adem\\\\u00e1s USB-C con DisplayPort Alt Mode, KVM Switch, y cobertura de color del 110% sRGB para una experiencia visual inmersiva y productiva.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-23 23:58:24','2025-12-23 23:58:24'),(170,277,'<p>El&nbsp;MSI&nbsp;G274CV&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gamer&nbsp;curvo&nbsp;de&nbsp;27&nbsp;pulgadas&nbsp;con&nbsp;resolución&nbsp;Full&nbsp;HD&nbsp;(1920x1080),&nbsp;panel&nbsp;VA,&nbsp;que&nbsp;ofrece&nbsp;una&nbsp;experiencia&nbsp;inmersiva&nbsp;con&nbsp;curvatura&nbsp;1500R,&nbsp;ideal&nbsp;para&nbsp;juegos&nbsp;gracias&nbsp;a&nbsp;su&nbsp;alta&nbsp;tasa&nbsp;de&nbsp;refresco&nbsp;de&nbsp;75Hz,&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;de&nbsp;1ms&nbsp;(MPRT)&nbsp;y&nbsp;tecnología&nbsp;AMD&nbsp;FreeSync&nbsp;para&nbsp;una&nbsp;jugabilidad&nbsp;fluida&nbsp;sin&nbsp;desgarros,&nbsp;además&nbsp;de&nbsp;incluir&nbsp;conectividad&nbsp;DisplayPort&nbsp;y&nbsp;HDMI&nbsp;y&nbsp;un&nbsp;diseño&nbsp;sin&nbsp;bordes.</p>','\"[{\\\"nombre\\\":\\\"MONITOR MSI G274CV 27\\\\\\\" CURVO FHD 1920x1080\\\\\\/75HZ\\\\\\/1MS\\\\\\/AMD RADEON FREESYNC\\\",\\\"valor\\\":\\\"MSI\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR MSI\\\",\\\"detalle\\\":\\\"El Monitor MSI G274CV es un panel curvo VA de 27\\\\\\\" Full HD (1920x1080) con tecnolog\\\\u00eda AMD FreeSync, ideal para gaming por su baja latencia de 1ms y tasa de refresco de 75Hz, ofreciendo colores realistas con su panel VA y buena inmersi\\\\u00f3n gracias a su curvatura 1500R, incluyendo puertos HDMI y DisplayPort para conectividad vers\\\\u00e1til. \\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:06:23','2025-12-24 00:06:23'),(171,278,'<p>El&nbsp;ASUS&nbsp;VZ24EHF&nbsp;es&nbsp;un&nbsp;monitor&nbsp;IPS&nbsp;Full&nbsp;HD&nbsp;de&nbsp;23.8&quot;&nbsp;ultradelgado,&nbsp;ideal&nbsp;para&nbsp;trabajo&nbsp;y&nbsp;juegos&nbsp;casuales,&nbsp;que&nbsp;destaca&nbsp;por&nbsp;su&nbsp;fluidez&nbsp;con&nbsp;100Hz&nbsp;de&nbsp;tasa&nbsp;de&nbsp;refresco&nbsp;y&nbsp;1ms&nbsp;(MPRT)&nbsp;de&nbsp;respuesta,&nbsp;tecnología&nbsp;Adaptive-Sync&nbsp;(FreeSync)&nbsp;para&nbsp;eliminar&nbsp;tearing,&nbsp;y&nbsp;tecnologías&nbsp;Eye&nbsp;Care&nbsp;certificadas&nbsp;(Flicker-Free,&nbsp;Low&nbsp;Blue&nbsp;Light)&nbsp;para&nbsp;comodidad&nbsp;visual,&nbsp;ofreciendo&nbsp;colores&nbsp;precisos&nbsp;y&nbsp;amplios&nbsp;ángulos&nbsp;de&nbsp;visión,&nbsp;con&nbsp;diseño&nbsp;sin&nbsp;marco&nbsp;y&nbsp;montaje&nbsp;VESA.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS VZ24EHF 23.8\\\\\\\" FHD 1920x1080\\\\\\/100HZ\\\\\\/1MS\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS\\\",\\\"detalle\\\":\\\"El ASUS VZ24EHF es un monitor IPS Full HD de 23.8\\\\\\\" con dise\\\\u00f1o ultradelgado sin marco, ideal para trabajo y gaming casual, destacando por su alta frecuencia de refresco de 100Hz y tiempo de respuesta de 1ms (MPRT), tecnolog\\\\u00eda Adaptive-Sync para fluidez, y cuidado ocular (Flicker-Free, Low Blue Light) certificado por TUV, ofreciendo gran calidad de imagen y \\\\u00e1ngulos de visi\\\\u00f3n amplios, aunque con conectividad b\\\\u00e1sica (HDMI) y sin altavoces.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:11:32','2025-12-24 00:11:32'),(172,279,'<p>El&nbsp;ASUS&nbsp;ROG&nbsp;Strix&nbsp;XG27AQ-W&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gaming&nbsp;de&nbsp;27&quot;&nbsp;WQHD&nbsp;(2560x1440)&nbsp;con&nbsp;panel&nbsp;IPS&nbsp;rápido,&nbsp;que&nbsp;ofrece&nbsp;hasta&nbsp;170Hz&nbsp;(overclock)&nbsp;y&nbsp;1ms&nbsp;(GTG)&nbsp;de&nbsp;respuesta,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;compatibilidad&nbsp;G-Sync,&nbsp;tecnología&nbsp;ELMB&nbsp;SYNC&nbsp;para&nbsp;eliminar&nbsp;el&nbsp;ghosting,&nbsp;y&nbsp;certificación&nbsp;DisplayHDR&nbsp;400&nbsp;para&nbsp;un&nbsp;buen&nbsp;contraste&nbsp;y&nbsp;color,&nbsp;siendo&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;competitivo&nbsp;y&nbsp;creación&nbsp;de&nbsp;contenido,&nbsp;aunque&nbsp;su&nbsp;HDR&nbsp;es&nbsp;básico.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG STRIX XG27AQ-W 27\\\\\\\" WQHD 2560x1440\\\\\\/170HZ\\\\\\/1MS\\\\\\/COMPATIBLE NVIDIA G-SYNC\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS \\\",\\\"detalle\\\":\\\"El ASUS ROG STRIX XG27AQ-W es un monitor gaming premium de 27\\\\\\\" con panel Fast IPS, resoluci\\\\u00f3n WQHD (2K), y alta velocidad (170Hz, 1ms GTG) para juegos fluidos, ofreciendo colores precisos con HDR y certificaci\\\\u00f3n NVIDIA G-SYNC Compatible, ideal para gamers que buscan inmersi\\\\u00f3n y rendimiento competitivo con caracter\\\\u00edsticas como ELMB SYNC, dise\\\\u00f1o ergon\\\\u00f3mico y Aura Sync RGB, una combinaci\\\\u00f3n de potencia y est\\\\u00e9tica gamer.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:16:20','2025-12-24 00:16:20'),(173,280,'<p>El&nbsp;Asus&nbsp;ROG&nbsp;Strix&nbsp;XG27AQV&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gamer&nbsp;curvo&nbsp;de&nbsp;27&nbsp;pulgadas&nbsp;QHD&nbsp;(2560x1440)&nbsp;con&nbsp;panel&nbsp;IPS&nbsp;rápido,&nbsp;diseñado&nbsp;para&nbsp;ofrecer&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;juego&nbsp;fluida&nbsp;y&nbsp;detallada,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;alta&nbsp;tasa&nbsp;de&nbsp;refresco&nbsp;de&nbsp;170Hz&nbsp;(OC),&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;de&nbsp;1ms&nbsp;GTG,&nbsp;tecnología&nbsp;Adaptive&nbsp;Sync&nbsp;(FreeSync&nbsp;Premium&nbsp;y&nbsp;G-Sync&nbsp;Compatible),&nbsp;y&nbsp;compatibilidad&nbsp;HDR&nbsp;DisplayHDR&nbsp;400,&nbsp;ideal&nbsp;para&nbsp;jugadores&nbsp;que&nbsp;buscan&nbsp;inmersión,&nbsp;velocidad&nbsp;y&nbsp;calidad&nbsp;de&nbsp;imagen&nbsp;superior&nbsp;en&nbsp;juegos&nbsp;competitivos&nbsp;y&nbsp;visuales&nbsp;vibrantes.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG STRIX GAMING XG27AQV 27\\\\\\\" CURVO QHD 2560x1440\\\\\\/170HZ\\\\\\/1MS\\\\\\/FREESYNC PREMIUM\\\\\\/COMPATIBLE NVIDIA G-SYNC\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS\\\",\\\"detalle\\\":\\\"El ASUS ROG Strix XG27AQV, es un monitor gamer curvo de 27 pulgadas WQHD (2560x1440) con panel Fast IPS, alta tasa de refresco de 170Hz (OC) y 1ms de respuesta (GTG), ideal para juegos r\\\\u00e1pidos gracias a FreeSync Premium y compatibilidad G-Sync, ofreciendo colores vibrantes con HDR (DisplayHDR 400) y tecnolog\\\\u00edas como ELMB Sync para una experiencia fluida sin desenfoques ni tearing, destacando por su dise\\\\u00f1o ergon\\\\u00f3mico y conectividad.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:19:57','2025-12-24 00:19:57'),(174,281,'<p>El&nbsp;ASUS&nbsp;ROG&nbsp;Strix&nbsp;PG279QM&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gaming&nbsp;de&nbsp;27&quot;&nbsp;QHD&nbsp;(2560x1440)&nbsp;con&nbsp;panel&nbsp;Fast&nbsp;IPS,&nbsp;diseñado&nbsp;para&nbsp;profesionales,&nbsp;ofreciendo&nbsp;240Hz&nbsp;de&nbsp;refresco,&nbsp;1ms&nbsp;de&nbsp;respuesta&nbsp;(GTG)&nbsp;y&nbsp;tecnología&nbsp;NVIDIA&nbsp;G-Sync&nbsp;con&nbsp;analizador&nbsp;de&nbsp;latencia,&nbsp;además&nbsp;de&nbsp;HDR&nbsp;DisplayHDR&nbsp;400,&nbsp;cobertura&nbsp;DCI-P3&nbsp;y&nbsp;puertos&nbsp;DisplayPort,&nbsp;HDMI&nbsp;y&nbsp;USB&nbsp;3.0,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;competitivo&nbsp;fluido&nbsp;y&nbsp;visuales&nbsp;impresionantes.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG STRIX PG279QM 27\\\\\\\" QHD 2560x1440\\\\\\/240HZ\\\\\\/1MS\\\\\\/NVIDIA G-SYNC (PN:90LM0235-B13B0)\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS \\\",\\\"detalle\\\":\\\"El ASUS ROG STRIX PG279QM es un monitor gamer premium de 27 pulgadas con panel Fast IPS, ideal para PC, que ofrece una resoluci\\\\u00f3n QHD (2K) n\\\\u00edtida, una tasa de refresco ultra r\\\\u00e1pida de 240Hz, tiempo de respuesta de 1ms, y tecnolog\\\\u00eda NVIDIA G-SYNC para una jugabilidad fluida sin tirones, junto con HDR DisplayHDR 400,analyzer de latencia NVIDIA Reflex, y dise\\\\u00f1o ergon\\\\u00f3mico con Aura Sync para gaming competitivo de alto nivel.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:23:34','2025-12-24 00:23:34'),(175,282,'<p>El&nbsp;ASUS&nbsp;ROG&nbsp;Swift&nbsp;OLED&nbsp;PG27AQDM&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gaming&nbsp;de&nbsp;gama&nbsp;alta&nbsp;que&nbsp;ofrece&nbsp;una&nbsp;experiencia&nbsp;visual&nbsp;superior&nbsp;con&nbsp;su&nbsp;panel&nbsp;OLED&nbsp;de&nbsp;27&nbsp;pulgadas,&nbsp;resolución&nbsp;QHD&nbsp;(2560x1440),&nbsp;altísima&nbsp;tasa&nbsp;de&nbsp;refresco&nbsp;de&nbsp;240Hz&nbsp;y&nbsp;un&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;ultrarrápido&nbsp;de&nbsp;0.03ms&nbsp;(GTG),&nbsp;brindando&nbsp;colores&nbsp;vibrantes,&nbsp;negros&nbsp;puros&nbsp;y&nbsp;fluidez&nbsp;extrema,&nbsp;ideal&nbsp;para&nbsp;PCs&nbsp;potentes&nbsp;con&nbsp;NVIDIA&nbsp;G-SYNC&nbsp;y&nbsp;FreeSync&nbsp;Premium&nbsp;para&nbsp;gaming&nbsp;sin&nbsp;tirones,&nbsp;con&nbsp;tecnologías&nbsp;extra&nbsp;para&nbsp;proteger&nbsp;el&nbsp;panel&nbsp;OLED&nbsp;y&nbsp;mejorar&nbsp;la&nbsp;gestión&nbsp;del&nbsp;calor.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS ROG SWIFT OLED PG27AQDM 27\\\\\\\" QHD 2560x1440\\\\\\/240HZ\\\\\\/0.003MS\\\\\\/FREESYNC PREMIUM\\\\\\/COMPATIBLE NVIDIA G-SYNC\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS\\\",\\\"detalle\\\":\\\"El ASUS ROG Swift OLED PG27AQDM es un monitor gaming OLED de 27\\\\\\\" QHD (2560x1440) con una tasa de refresco de 240Hz y un tiempo de respuesta ultrarr\\\\u00e1pido de 0.03ms (GTG), ofreciendo negros perfectos, alto contraste (1,500,000:1), 99% DCI-P3, HDR10, y tecnolog\\\\u00eda ASUS OLED Care con disipador t\\\\u00e9rmico personalizado para prevenir el quemado, adem\\\\u00e1s de compatibilidad con G-Sync y FreeSync Premium para una experiencia de juego fluida y colores realistas.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:30:59','2025-12-24 00:30:59'),(176,283,'<p>El&nbsp;ASUS&nbsp;TUF&nbsp;Gaming&nbsp;VG279Q1A&nbsp;es&nbsp;un&nbsp;monitor&nbsp;gamer&nbsp;de&nbsp;27&nbsp;pulgadas&nbsp;Full&nbsp;HD&nbsp;(1920x1080)&nbsp;con&nbsp;panel&nbsp;IPS,&nbsp;enfocado&nbsp;en&nbsp;la&nbsp;velocidad&nbsp;y&nbsp;fluidez&nbsp;para&nbsp;juegos,&nbsp;ofreciendo&nbsp;una&nbsp;tasa&nbsp;de&nbsp;refresco&nbsp;de&nbsp;165Hz,&nbsp;tiempo&nbsp;de&nbsp;respuesta&nbsp;de&nbsp;1ms&nbsp;(MPRT)&nbsp;con&nbsp;la&nbsp;tecnología&nbsp;ELMB,&nbsp;y&nbsp;FreeSync&nbsp;Premium&nbsp;para&nbsp;eliminar&nbsp;el&nbsp;desgarro&nbsp;de&nbsp;pantalla,&nbsp;además&nbsp;de&nbsp;incluir&nbsp;altavoces&nbsp;y&nbsp;puertos&nbsp;HDMI/DisplayPort&nbsp;para&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;juego&nbsp;inmersiva&nbsp;y&nbsp;nítida.</p>','\"[{\\\"nombre\\\":\\\"MONITOR ASUS TUF GAMING VG279Q1A 27\\\\\\\" FHD 1920x1080\\\\\\/165HZ\\\\\\/1MS\\\\\\/FREESYNC PREMIUM (PN:90LM05X0\'B051B0)\\\",\\\"valor\\\":\\\"ASUS\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MONITOR ASUS \\\",\\\"detalle\\\":\\\"El ASUS TUF Gaming VG279Q1A es un monitor gaming IPS de 27 pulgadas Full HD (1920x1080) con alta tasa de refresco de 165Hz y 1ms (MPRT) de respuesta gracias a su tecnolog\\\\u00eda ELMB, ideal para juegos fluidos y sin tearing con FreeSync Premium, ofreciendo gran color y amplios \\\\u00e1ngulos de visi\\\\u00f3n para tu PC\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:34:07','2025-12-24 00:34:07'),(177,284,'<p>La&nbsp;memoria&nbsp;G.Skill&nbsp;Trident&nbsp;Z5&nbsp;RGB&nbsp;Black&nbsp;de&nbsp;32GB&nbsp;(2x16GB)&nbsp;DDR5&nbsp;a&nbsp;6000MHz&nbsp;es&nbsp;un&nbsp;kit&nbsp;de&nbsp;RAM&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;para&nbsp;PCs&nbsp;de&nbsp;escritorio,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;y&nbsp;tareas&nbsp;exigentes,&nbsp;ofreciendo&nbsp;velocidades&nbsp;ultrarrápidas,&nbsp;iluminación&nbsp;RGB&nbsp;personalizable,&nbsp;diseño&nbsp;de&nbsp;disipador&nbsp;negro&nbsp;con&nbsp;estilo&nbsp;deportivo,&nbsp;compatibilidad&nbsp;con&nbsp;perfiles&nbsp;Intel&nbsp;XMP&nbsp;3.0&nbsp;y&nbsp;bajo&nbsp;voltaje&nbsp;para&nbsp;una&nbsp;mayor&nbsp;eficiencia,&nbsp;con&nbsp;timings&nbsp;(latencias)&nbsp;agresivos&nbsp;como&nbsp;CL30-40-40-96&nbsp;para&nbsp;un&nbsp;rendimiento&nbsp;superior&nbsp;en&nbsp;plataformas&nbsp;DDR5.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 32GB (16GBx2) DDR5 G.SKILL TRIDENT Z5 RGB BLACK BUS 6000MHZ\\\",\\\"valor\\\":\\\"G.SKILL \\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM G.SKILL \\\",\\\"detalle\\\":\\\"La memoria G.Skill Trident Z5 RGB 32GB (16GBx2) DDR5 6000MHz es un kit de RAM de alto rendimiento para PC de escritorio, ideal para gaming y creaci\\\\u00f3n de contenido, ofreciendo 32 GB (2x16GB) con velocidad DDR5 a 6000 MT\\\\\\/s, latencia CL30 (tiempos 30-40-40-96), voltaje de 1.35V, compatibilidad con perfiles Intel XMP 3.0 (y a veces AMD EXPO), y un disipador negro con iluminaci\\\\u00f3n RGB personalizable para est\\\\u00e9tica y rendimiento.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:52:55','2025-12-24 00:52:55'),(178,285,'<p>La&nbsp;memoria&nbsp;G.Skill&nbsp;Trident&nbsp;Z&nbsp;16GB&nbsp;(8GBx2)&nbsp;DDR4&nbsp;3200MHz&nbsp;es&nbsp;un&nbsp;kit&nbsp;de&nbsp;RAM&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;para&nbsp;PC,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;y&nbsp;tareas&nbsp;exigentes,&nbsp;ofreciendo&nbsp;16GB&nbsp;en&nbsp;doble&nbsp;canal&nbsp;con&nbsp;una&nbsp;frecuencia&nbsp;de&nbsp;3200&nbsp;MHz&nbsp;y&nbsp;latencias&nbsp;bajas&nbsp;(CL16),&nbsp;que&nbsp;se&nbsp;activa&nbsp;vía&nbsp;XMP&nbsp;para&nbsp;una&nbsp;configuración&nbsp;fácil&nbsp;y&nbsp;estable&nbsp;en&nbsp;plataformas&nbsp;Intel&nbsp;(y&nbsp;AMD),&nbsp;destacando&nbsp;por&nbsp;su&nbsp;diseño&nbsp;premium&nbsp;con&nbsp;disipadores&nbsp;de&nbsp;aluminio&nbsp;y&nbsp;a&nbsp;menudo&nbsp;iluminación&nbsp;RGB&nbsp;personalizable&nbsp;para&nbsp;enfriamiento&nbsp;y&nbsp;estilo.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 16GB (8GBx2) DDR4 G.SKILL TRIDENT Z INTEL XMP BUS 3200MHZ\\\",\\\"valor\\\":\\\"G.SKILL\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA G.SKILL\\\",\\\"detalle\\\":\\\"La memoria G.Skill Trident Z 16GB (8GBx2) DDR4 3200MHz es un kit de RAM de alto rendimiento para PC de escritorio, con dos m\\\\u00f3dulos de 8GB para un total de 16GB, que alcanza 3200 MHz de velocidad, ideal para gaming y tareas exigentes, con perfiles Intel XMP 2.0 para f\\\\u00e1cil overclock y un disipador de aluminio para mejor enfriamiento, ofreciendo dise\\\\u00f1o premium y compatibilidad con Intel y AMD, aunque para su velocidad m\\\\u00e1xima debes activarla en la BIOS.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 00:59:05','2025-12-24 00:59:05'),(179,286,'<p>La&nbsp;memoria&nbsp;Kingston&nbsp;FURY&nbsp;Beast&nbsp;RGB&nbsp;Black&nbsp;de&nbsp;8GB&nbsp;DDR4&nbsp;3200MHz&nbsp;es&nbsp;un&nbsp;módulo&nbsp;RAM&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;disipador&nbsp;negro&nbsp;y&nbsp;iluminación&nbsp;RGB&nbsp;personalizable,&nbsp;ideal&nbsp;para&nbsp;gamers&nbsp;y&nbsp;usuarios&nbsp;que&nbsp;buscan&nbsp;mejorar&nbsp;la&nbsp;velocidad&nbsp;en&nbsp;juegos&nbsp;y&nbsp;multitarea,&nbsp;ofreciendo&nbsp;frecuencias&nbsp;de&nbsp;3200MHz,&nbsp;latencia&nbsp;CL16,&nbsp;compatibilidad&nbsp;con&nbsp;Intel&nbsp;XMP&nbsp;y&nbsp;AMD&nbsp;Ryzen,&nbsp;y&nbsp;tecnología&nbsp;de&nbsp;sincronización&nbsp;de&nbsp;luz&nbsp;(Infrared&nbsp;Sync)&nbsp;para&nbsp;un&nbsp;aspecto&nbsp;visual&nbsp;atractivo,&nbsp;además&nbsp;de&nbsp;estabilidad&nbsp;con&nbsp;ODECC.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 8GB DDR4 KINGSTON FURY BEAST RGB BLACK BUS 3200MHZ\\\",\\\"valor\\\":\\\"KINGSTON \\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM KINGSTON \\\",\\\"detalle\\\":\\\"La memoria Kingston FURY Beast RGB 8GB DDR4 3200MHz es un m\\\\u00f3dulo RAM para PC que ofrece 8GB de capacidad, tipo DDR4, con velocidad de 3200MHz y latencia CL16, ideal para mejorar gaming y multitarea, cuenta con iluminaci\\\\u00f3n RGB personalizable y disipador negro de bajo perfil para refrigeraci\\\\u00f3n, compatible con Intel XMP y AMD Ryzen para f\\\\u00e1cil instalaci\\\\u00f3n y overclock autom\\\\u00e1tico, mejorando la respuesta y fluidez de tu sistema.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 01:08:24','2025-12-24 01:08:24'),(180,287,'<p>La&nbsp;memoria&nbsp;8GB&nbsp;DDR4&nbsp;T-FORCE&nbsp;DELTA&nbsp;RGB&nbsp;WHITE&nbsp;BUS&nbsp;3200MHZ&nbsp;es&nbsp;un&nbsp;módulo&nbsp;RAM&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;para&nbsp;PC&nbsp;de&nbsp;escritorio&nbsp;de&nbsp;la&nbsp;marca&nbsp;Teamgroup,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;diseño&nbsp;blanco&nbsp;con&nbsp;iluminación&nbsp;RGB&nbsp;de&nbsp;120°,&nbsp;velocidad&nbsp;de&nbsp;3200MHz&nbsp;(CL16),&nbsp;disipador&nbsp;de&nbsp;calor&nbsp;eficiente,&nbsp;compatibilidad&nbsp;con&nbsp;ASUS&nbsp;Aura&nbsp;Sync&nbsp;y&nbsp;soporte&nbsp;XMP&nbsp;2.0&nbsp;para&nbsp;overclock&nbsp;fácil,&nbsp;ideal&nbsp;para&nbsp;gamers&nbsp;que&nbsp;buscan&nbsp;estética&nbsp;y&nbsp;potencia.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 8GB DDR4 T-FORCE DELTA RGB WHITE BUS 3200MHZ\\\",\\\"valor\\\":\\\"T-FORCE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA T-FORCE\\\",\\\"detalle\\\":\\\"La memoria RAM T-FORCE DELTA RGB WHITE 8GB DDR4 3200MHz es un m\\\\u00f3dulo de alta velocidad para PC, con un dise\\\\u00f1o blanco y retroiluminaci\\\\u00f3n RGB de gran angular para est\\\\u00e9tica gamer, que ofrece rendimiento mejorado (latencia CL16) para gaming y tareas exigentes, gracias a su disipador de aluminio y compatibilidad con XMP 2.0 para f\\\\u00e1cil overclocking, siendo ideal para tu PC, mejorando la velocidad de respuesta y visuales en juegos.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 01:14:08','2025-12-24 01:14:08'),(181,288,'<p>La&nbsp;memoria&nbsp;T-Force&nbsp;Delta&nbsp;Black&nbsp;RGB&nbsp;DDR5&nbsp;16GB&nbsp;6000MHz&nbsp;es&nbsp;un&nbsp;módulo&nbsp;RAM&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;para&nbsp;PC,&nbsp;caracterizado&nbsp;por&nbsp;su&nbsp;gran&nbsp;velocidad&nbsp;(6000MHz)&nbsp;y&nbsp;baja&nbsp;latencia&nbsp;(CL38),&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;y&nbsp;tareas&nbsp;exigentes,&nbsp;con&nbsp;un&nbsp;diseño&nbsp;negro&nbsp;agresivo,&nbsp;disipador&nbsp;de&nbsp;aluminio,&nbsp;y&nbsp;una&nbsp;iluminación&nbsp;RGB&nbsp;personalizable&nbsp;de&nbsp;120°.&nbsp;Es&nbsp;DDR5,&nbsp;compatible&nbsp;con&nbsp;Intel&nbsp;XMP&nbsp;3.0&nbsp;y&nbsp;AMD&nbsp;EXPO,&nbsp;e&nbsp;incluye&nbsp;un&nbsp;circuito&nbsp;PMIC&nbsp;para&nbsp;una&nbsp;gestión&nbsp;de&nbsp;energía&nbsp;eficiente&nbsp;y&nbsp;estable,&nbsp;con&nbsp;tecnología&nbsp;ECC&nbsp;on-die&nbsp;para&nbsp;mayor&nbsp;confiabilidad&nbsp;del&nbsp;sistema.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 16GB DDR5 T-FORCE DELTA BLACK RGB BUS 6000MHZ\\\",\\\"valor\\\":\\\"T-FORCE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM T-FORCE\\\",\\\"detalle\\\":\\\"La memoria T-FORCE DELTA BLACK RGB 16GB DDR5 6000MHz es un m\\\\u00f3dulo RAM de alto rendimiento para PC, ideal para gaming y tareas exigentes, que ofrece 16GB de capacidad, alta velocidad (6000MHz), disipaci\\\\u00f3n t\\\\u00e9rmica de aluminio, iluminaci\\\\u00f3n RGB personalizable con efecto de 120\\\\u00b0 (estilo avi\\\\u00f3n sigiloso) y compatibilidad con Intel XMP 3.0 y AMD EXPO, proporcionando un gran rendimiento y est\\\\u00e9tica a tu PC moderna.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 01:24:50','2025-12-24 01:24:50'),(182,289,'<p>La&nbsp;memoria&nbsp;T-FORCE&nbsp;DELTA&nbsp;RGB&nbsp;WHITE&nbsp;16GB&nbsp;DDR5&nbsp;6000MHz&nbsp;es&nbsp;un&nbsp;módulo&nbsp;RAM&nbsp;de&nbsp;alto&nbsp;rendimiento,&nbsp;color&nbsp;blanco,&nbsp;con&nbsp;iluminación&nbsp;RGB&nbsp;personalizable,&nbsp;diseñado&nbsp;para&nbsp;sistemas&nbsp;Intel&nbsp;(compatible&nbsp;con&nbsp;XMP&nbsp;3.0),&nbsp;que&nbsp;ofrece&nbsp;16GB&nbsp;de&nbsp;capacidad,&nbsp;velocidad&nbsp;de&nbsp;6000&nbsp;MT/s&nbsp;y&nbsp;latencia&nbsp;CL38&nbsp;para&nbsp;gaming&nbsp;y&nbsp;tareas&nbsp;exigentes,&nbsp;mejorando&nbsp;la&nbsp;eficiencia&nbsp;con&nbsp;el&nbsp;estándar&nbsp;DDR5.</p>','\"[{\\\"nombre\\\":\\\"MEMORIA 16GB DDR5 T-FORCE DELTA RGB WHITE INTEL XMP BUS 6000MHZ\\\",\\\"valor\\\":\\\"T-FORCE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"MEMORIA RAM T-FORCE \\\",\\\"detalle\\\":\\\"La memoria T-Force Delta RGB White 16GB DDR5 6000MHz Intel XMP es una RAM de alto rendimiento para PC, color blanco, con disipadores, 16GB (1x16GB), DDR5, velocidad de 6000MHz (PC5-48000), latencia CL38, voltaje de 1.25V y RGB personalizable de 120\\\\u00b0, ideal para gaming y exigencia, con soporte Intel XMP 3.0 para overclock f\\\\u00e1cil, garantizando estabilidad y est\\\\u00e9tica moderna para plataformas Intel compatibles (Series 600\\\\\\/700).\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 01:32:35','2025-12-24 01:32:35'),(183,290,'<p>El&nbsp;HYTE&nbsp;Y60&nbsp;Negro&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid-Tower&nbsp;ATX&nbsp;de&nbsp;doble&nbsp;cámara,&nbsp;famoso&nbsp;por&nbsp;su&nbsp;diseño&nbsp;panorámico&nbsp;de&nbsp;vidrio&nbsp;templado&nbsp;sin&nbsp;biseles&nbsp;que&nbsp;muestra&nbsp;los&nbsp;componentes,&nbsp;ideal&nbsp;para&nbsp;gaming&nbsp;y&nbsp;estética,&nbsp;viene&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder&nbsp;(PSU),&nbsp;incluye&nbsp;3&nbsp;ventiladores&nbsp;de&nbsp;120mm,&nbsp;soporta&nbsp;EATX/ATX,&nbsp;tiene&nbsp;un&nbsp;riser&nbsp;PCIe&nbsp;4.0&nbsp;para&nbsp;GPU&nbsp;vertical,&nbsp;y&nbsp;excelente&nbsp;soporte&nbsp;para&nbsp;refrigeración&nbsp;líquida,&nbsp;ofreciendo&nbsp;un&nbsp;look&nbsp;premium&nbsp;y&nbsp;moderno&nbsp;para&nbsp;exhibir&nbsp;tu&nbsp;PC</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y60 BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER \\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE \\\",\\\"detalle\\\":\\\"El HYTE Y60 es una caja Mid-Tower negra de dise\\\\u00f1o panor\\\\u00e1mico con vidrio templado, ideal para mostrar tus componentes, que incluye tres ventiladores de 120mm preinstalados y un riser PCIe 4.0 para GPU vertical, soporta ATX\\\\\\/E-ATX, refrigeraci\\\\u00f3n l\\\\u00edquida hasta 360mm en el techo y aire hasta 160mm, ofreciendo doble c\\\\u00e1mara, conectividad moderna y est\\\\u00e9tica sin pilar central para una visualizaci\\\\u00f3n sin obstrucciones.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 01:50:58','2025-12-24 01:50:58'),(184,291,'<p>El&nbsp;HYTE&nbsp;Y60&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid-Tower&nbsp;ATX&nbsp;de&nbsp;doble&nbsp;cámara&nbsp;con&nbsp;un&nbsp;diseño&nbsp;estético&nbsp;premium,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;vidrio&nbsp;templado&nbsp;panorámico&nbsp;de&nbsp;3&nbsp;piezas&nbsp;para&nbsp;exhibir&nbsp;componentes&nbsp;y&nbsp;una&nbsp;montura&nbsp;vertical&nbsp;para&nbsp;la&nbsp;GPU&nbsp;(incluye&nbsp;cable&nbsp;riser&nbsp;PCIe&nbsp;4.0),&nbsp;ideal&nbsp;para&nbsp;mostrar&nbsp;hardware&nbsp;con&nbsp;estética&nbsp;blanco/negro&nbsp;(Black/White),&nbsp;es&nbsp;un&nbsp;chasis&nbsp;moderno&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder,&nbsp;optimizado&nbsp;para&nbsp;flujo&nbsp;de&nbsp;aire&nbsp;y&nbsp;refrigeración&nbsp;líquida,&nbsp;perfecto&nbsp;para&nbsp;builds&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;y&nbsp;gaming.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y60 BLACK WHITE SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE\\\",\\\"detalle\\\":\\\"El HYTE Y60 es un gabinete Mid-Tower de doble c\\\\u00e1mara, ideal para mostrar tu PC con sus paneles de vidrio templado panor\\\\u00e1mico (sin pilar en la esquina) y flujo de aire vertical, incluyendo tres ventiladores de 120mm preinstalados (dos abajo, uno atr\\\\u00e1s) y un riser PCIe 4.0 para GPU vertical; soporta placas base E-ATX a ITX, hasta 160mm de cooler de CPU, y radiadores de hasta 360mm\\\\\\/280mm, adem\\\\u00e1s de tener espacio para discos duros\\\\\\/SSD y puertos USB frontales.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 02:03:42','2025-12-24 02:03:42'),(185,292,'<p>El&nbsp;CASE&nbsp;HYTE&nbsp;Y40&nbsp;BLACK&nbsp;SIN&nbsp;FUENTE&nbsp;VIDRIO&nbsp;TEMPLADO&nbsp;MID&nbsp;TOWER&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;ATX&nbsp;Mid&nbsp;Tower&nbsp;moderno&nbsp;y&nbsp;estético,&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder,&nbsp;con&nbsp;vidrio&nbsp;templado&nbsp;panorámico&nbsp;que&nbsp;exhibe&nbsp;el&nbsp;interior,&nbsp;soporte&nbsp;para&nbsp;GPU&nbsp;vertical&nbsp;con&nbsp;riser&nbsp;PCIe&nbsp;4.0&nbsp;incluido,&nbsp;y&nbsp;excelente&nbsp;flujo&nbsp;de&nbsp;aire&nbsp;para&nbsp;refrigeración,&nbsp;ideal&nbsp;para&nbsp;montajes&nbsp;de&nbsp;PC&nbsp;gaming&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;con&nbsp;un&nbsp;diseño&nbsp;elegante&nbsp;y&nbsp;funcional&nbsp;que&nbsp;integra&nbsp;detalles&nbsp;de&nbsp;biselado&nbsp;y&nbsp;ventilación&nbsp;optimizada.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y40 BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE \\\",\\\"detalle\\\":\\\"El HYTE Y40 negro es un gabinete Mid-Tower ATX de est\\\\u00e9tica premium con vidrio templado panor\\\\u00e1mico para mostrar tus componentes, incluye Riser PCIe 4.0 para GPU vertical y excelente flujo de aire con ventiladores inferiores y laterales, ideal para PC de alto rendimiento y gaming moderno, sin fuente de poder incluida, destacando por su dise\\\\u00f1o multidimensional y compatibilidad para refrigeraci\\\\u00f3n l\\\\u00edquida avanzada y GPUs grandes.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 02:12:22','2025-12-24 02:12:22'),(186,293,'<p>El&nbsp;CASE&nbsp;HYTE&nbsp;Y40&nbsp;BLACK&nbsp;RED&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid-Tower&nbsp;ATX&nbsp;de&nbsp;estética&nbsp;premium,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;vidrio&nbsp;panorámico&nbsp;sin&nbsp;bisel&nbsp;(dos&nbsp;piezas)&nbsp;que&nbsp;muestra&nbsp;tus&nbsp;componentes,&nbsp;ideal&nbsp;para&nbsp;una&nbsp;visualización&nbsp;total;&nbsp;incluye&nbsp;un&nbsp;riser&nbsp;PCIe&nbsp;4.0&nbsp;para&nbsp;instalar&nbsp;la&nbsp;GPU&nbsp;verticalmente&nbsp;y&nbsp;ventilación&nbsp;eficiente&nbsp;con&nbsp;ventiladores&nbsp;preinstalados&nbsp;y&nbsp;excelente&nbsp;gestión&nbsp;de&nbsp;cables,&nbsp;ofreciendo&nbsp;un&nbsp;diseño&nbsp;moderno&nbsp;y&nbsp;funcional&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder&nbsp;incluida,&nbsp;enfocado&nbsp;en&nbsp;mostrar&nbsp;el&nbsp;hardware&nbsp;con&nbsp;un&nbsp;estilo&nbsp;único&nbsp;y&nbsp;un&nbsp;precio&nbsp;competitivo.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y40 BLACK RED SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE\\\",\\\"detalle\\\":\\\"El HYTE Y40 Black Red es un gabinete mid-tower ATX con dise\\\\u00f1o est\\\\u00e9tico premium, cristal templado panor\\\\u00e1mico, sin fuente (PSU) incluida, que se enfoca en la instalaci\\\\u00f3n vertical de GPU con su riser PCIe 4.0 incluido, excelente flujo de aire con ventilaci\\\\u00f3n inferior y lateral, y compatibilidad con placas base ATX\\\\\\/mATX\\\\\\/ITX para PC gamer de alto rendimiento, ofreciendo un look \\\\u00fanico y minimalista.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 02:18:15','2025-12-24 02:18:15'),(187,294,'<p>El&nbsp;HYTE&nbsp;Y70&nbsp;Touch&nbsp;Infinite&nbsp;White&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;mid-tower&nbsp;de&nbsp;gama&nbsp;alta&nbsp;para&nbsp;PC&nbsp;que&nbsp;destaca&nbsp;por&nbsp;su&nbsp;pantalla&nbsp;táctil&nbsp;IPS&nbsp;de&nbsp;14.9&nbsp;pulgadas&nbsp;integrada,&nbsp;un&nbsp;diseño&nbsp;panorámico&nbsp;de&nbsp;triple&nbsp;vidrio&nbsp;templado&nbsp;y&nbsp;una&nbsp;estética&nbsp;moderna&nbsp;con&nbsp;dos&nbsp;cámaras,&nbsp;ofreciendo&nbsp;una&nbsp;vista&nbsp;inmersiva&nbsp;del&nbsp;hardware,&nbsp;gran&nbsp;soporte&nbsp;para&nbsp;refrigeración&nbsp;(radiadores&nbsp;de&nbsp;hasta&nbsp;360mm)&nbsp;y&nbsp;un&nbsp;elevador&nbsp;PCIe&nbsp;4.0&nbsp;incluido&nbsp;para&nbsp;GPU&nbsp;vertical,&nbsp;ideal&nbsp;para&nbsp;construcciones&nbsp;de&nbsp;alto&nbsp;rendimiento&nbsp;y&nbsp;personalización&nbsp;visual&nbsp;avanzada,&nbsp;sin&nbsp;incluir&nbsp;la&nbsp;fuente&nbsp;de&nbsp;poder&nbsp;(PSU)</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y70 TOUCH INFINITE WHITE SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE \\\",\\\"detalle\\\":\\\"El HYTE Y70 Touch Infinite White es un gabinete Mid-Tower ATX blanco con vidrio templado panor\\\\u00e1mico, una pantalla t\\\\u00e1ctil IPS de 14.9\\\\\\\" integrada para monitoreo y personalizaci\\\\u00f3n (software HYTE Nexus), dise\\\\u00f1o de doble c\\\\u00e1mara para est\\\\u00e9tica y gesti\\\\u00f3n de cables, soporte para gr\\\\u00e1ficas verticales de 4 slots (con riser PCIe 4.0 incluido), y excelente refrigeraci\\\\u00f3n (hasta 10 ventiladores y radiadores de 360mm), ideal para mostrar hardware potente sin fuente de poder, ofreciendo un look premium y moderno para tu PC gamer.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 02:29:31','2025-12-24 02:29:31'),(188,295,'<p>El&nbsp;HYTE&nbsp;Y70&nbsp;Touch&nbsp;Infinite&nbsp;Black&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid-Tower&nbsp;ATX&nbsp;de&nbsp;doble&nbsp;cámara,&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder,&nbsp;que&nbsp;destaca&nbsp;por&nbsp;su&nbsp;innovadora&nbsp;pantalla&nbsp;táctil&nbsp;de&nbsp;14.9&quot;&nbsp;2.5K&nbsp;integrada&nbsp;en&nbsp;el&nbsp;frontal&nbsp;y&nbsp;un&nbsp;diseño&nbsp;panorámico&nbsp;de&nbsp;vidrio&nbsp;templado&nbsp;de&nbsp;3&nbsp;piezas,&nbsp;ideal&nbsp;para&nbsp;mostrar&nbsp;el&nbsp;hardware&nbsp;con&nbsp;instalación&nbsp;de&nbsp;GPU&nbsp;vertical&nbsp;(incluye&nbsp;riser&nbsp;PCIe&nbsp;4.0),&nbsp;ofreciendo&nbsp;estética&nbsp;moderna,&nbsp;gran&nbsp;capacidad&nbsp;de&nbsp;refrigeración&nbsp;(hasta&nbsp;10&nbsp;ventiladores)&nbsp;y&nbsp;gestión&nbsp;de&nbsp;cables&nbsp;optimizada&nbsp;para&nbsp;entusiastas&nbsp;del&nbsp;gaming&nbsp;y&nbsp;creadores&nbsp;de&nbsp;contenido.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y70 TOUCH INFINITE BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE HYTE Y70 TOUCH INFINITE BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"detalle\\\":\\\"El HYTE Y70 Touch Infinite Black es un gabinete Mid Tower ATX de doble c\\\\u00e1mara premium, famoso por su pantalla t\\\\u00e1ctil IPS de 14.9 pulgadas integrada para personalizaci\\\\u00f3n y monitoreo en tiempo real, dise\\\\u00f1o de vidrio templado panor\\\\u00e1mico que muestra hardware de alta gama (soporta GPUs de 4 ranuras), y excelente flujo de aire con gran capacidad para ventiladores y radiadores, ideal para builds potentes sin fuente de poder\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 02:37:49','2025-12-24 02:37:49'),(189,296,'<p>El&nbsp;Hyte&nbsp;Y70&nbsp;Persona&nbsp;3&nbsp;Reload&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid-Tower&nbsp;de&nbsp;doble&nbsp;cámara,&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder,&nbsp;con&nbsp;paneles&nbsp;de&nbsp;vidrio&nbsp;templado&nbsp;que&nbsp;resaltan&nbsp;tu&nbsp;hardware,&nbsp;inspirado&nbsp;en&nbsp;el&nbsp;videojuego&nbsp;Persona&nbsp;3,&nbsp;ideal&nbsp;para&nbsp;PC&nbsp;gamers&nbsp;de&nbsp;alto&nbsp;rendimiento,&nbsp;ofreciendo&nbsp;gran&nbsp;espacio&nbsp;para&nbsp;GPUs&nbsp;de&nbsp;4&nbsp;ranuras&nbsp;y&nbsp;excelente&nbsp;refrigeración&nbsp;para&nbsp;placas&nbsp;ATX/E-ATX.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y70 PERSONA 3 RELOAD SIN FUENTE VIDRIO TEMPLADO MID TOWER \\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE \\\",\\\"detalle\\\":\\\"El HYTE Y70 Persona 3 Reload es un gabinete Mid Tower ATX de doble c\\\\u00e1mara, edici\\\\u00f3n limitada, que destaca por su dise\\\\u00f1o panor\\\\u00e1mico con vidrio templado sin pilares, est\\\\u00e9tica del juego Persona 3, y un enfoque en la refrigeraci\\\\u00f3n y la exhibici\\\\u00f3n de componentes, incluyendo instalaci\\\\u00f3n vertical de GPU con riser PCIe 4.0 incluido, ideal para builds potentes y est\\\\u00e9ticas sin fuente de poder propia.\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 02:50:20','2025-12-24 02:50:20'),(190,297,'<p>El&nbsp;HYTE&nbsp;Y70&nbsp;Blueberry&nbsp;Milk&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid-Tower&nbsp;ATX&nbsp;de&nbsp;doble&nbsp;cámara&nbsp;con&nbsp;un&nbsp;diseño&nbsp;premium&nbsp;y&nbsp;un&nbsp;llamativo&nbsp;color&nbsp;azul&nbsp;&quot;Milk&quot;,&nbsp;ideal&nbsp;para&nbsp;mostrar&nbsp;tu&nbsp;hardware&nbsp;con&nbsp;su&nbsp;gran&nbsp;ventana&nbsp;panorámica&nbsp;de&nbsp;cristal&nbsp;templado,&nbsp;es&nbsp;sin&nbsp;fuente&nbsp;de&nbsp;poder&nbsp;y&nbsp;trae&nbsp;incluido&nbsp;un&nbsp;riser&nbsp;PCIe&nbsp;4.0&nbsp;x16&nbsp;para&nbsp;instalar&nbsp;la&nbsp;tarjeta&nbsp;gráfica&nbsp;en&nbsp;vertical,&nbsp;ofreciendo&nbsp;gran&nbsp;capacidad&nbsp;de&nbsp;refrigeración&nbsp;para&nbsp;setups&nbsp;potentes&nbsp;y&nbsp;una&nbsp;gestión&nbsp;de&nbsp;cables&nbsp;superior.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y70 BLUEBERRY MILK SIN FUENTE VIDRIO TEMPLADO MID TOWER \\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE\\\",\\\"detalle\\\":\\\"El CASE HYTE Y70 Blueberry Milk es un gabinete Mid-Tower ATX de doble c\\\\u00e1mara con est\\\\u00e9tica moderna (color azul cremoso), vidrio templado panor\\\\u00e1mico, y enfocado en mostrar tu hardware, incluyendo una GPU vertical de 4 slots con un Riser PCIe 4.0 incluido, gran flujo de aire para refrigeraci\\\\u00f3n (radiadores 360mm), excelente gesti\\\\u00f3n de cables, y dise\\\\u00f1o sin fuente de poder ni coolers preinstalados\\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 03:01:26','2025-12-24 03:01:26'),(191,298,'<p>El&nbsp;HYTE&nbsp;Y70&nbsp;Touch&nbsp;Infinite&nbsp;Red/Black&nbsp;es&nbsp;un&nbsp;gabinete&nbsp;Mid&nbsp;Tower&nbsp;ATX&nbsp;de&nbsp;doble&nbsp;cámara,&nbsp;&quot;sin&nbsp;fuente&quot;&nbsp;(No&nbsp;PSU),&nbsp;con&nbsp;un&nbsp;panel&nbsp;táctil&nbsp;IPS&nbsp;de&nbsp;14.9&quot;&nbsp;2.5K&nbsp;integrado,&nbsp;vidrio&nbsp;templado&nbsp;panorámico,&nbsp;y&nbsp;soporte&nbsp;para&nbsp;GPU&nbsp;vertical&nbsp;de&nbsp;4&nbsp;ranuras,&nbsp;destacando&nbsp;por&nbsp;su&nbsp;estética&nbsp;moderna,&nbsp;excelente&nbsp;refrigeración&nbsp;y&nbsp;una&nbsp;experiencia&nbsp;de&nbsp;usuario&nbsp;inmersiva&nbsp;al&nbsp;mostrar&nbsp;hardware&nbsp;y&nbsp;widgets,&nbsp;ideal&nbsp;para&nbsp;entusiastas&nbsp;que&nbsp;buscan&nbsp;exhibir&nbsp;su&nbsp;PC&nbsp;y&nbsp;controlar&nbsp;su&nbsp;sistema.</p>','\"[{\\\"nombre\\\":\\\"CASE HYTE Y70 TOUCH INFINITE RED BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER\\\",\\\"valor\\\":\\\"HYTE\\\"}]\"','\"[{\\\"caracteristica\\\":\\\"CASE GAMER HYTE \\\",\\\"detalle\\\":\\\"El Hyte Y70 Touch Infinite es un chasis Mid Tower de doble c\\\\u00e1mara con vidrio templado panor\\\\u00e1mico que exhibe tu hardware, destacando por su pantalla t\\\\u00e1ctil IPS de 14.5\\\\\\\" 2.5K integrada (software HYTE Nexus) para monitoreo y widgets, soporte de GPU vertical de 4 ranuras con PCIe 4.0 riser incluido, y excelente refrigeraci\\\\u00f3n con capacidad para hasta 10 ventiladores (radiadores 360mm), ideal para builds potentes y est\\\\u00e9ticas, sin incluir fuente de poder (PSU), y este modelo es en color Rojo\\\\\\/Negro. \\\"}]\"',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-24 03:12:06','2025-12-24 03:12:06');
/*!40000 ALTER TABLE `producto_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `codigo_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_id` bigint unsigned NOT NULL,
  `marca_id` bigint unsigned DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `stock_minimo` int NOT NULL DEFAULT '5',
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `destacado` tinyint(1) DEFAULT '0',
  `mostrar_igv` tinyint(1) NOT NULL DEFAULT '1',
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
) ENGINE=InnoDB AUTO_INCREMENT=299 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (113,'PROCESADOR AMD RYZEN 7 8700F, 4.1/5.0 Ghz, AM5','El AMD Ryzen 7 8700F es un procesador de 8 núcleos con arquitectura Zen 4 para el socket AM5, que alcanza hasta 5.0 GHz de velocidad, tiene 16MB de caché L3, soporta memoria DDR5 y un TDP de 65W. Es una versión sin gráficos integrados (\"F\"), lo que significa que necesita una tarjeta de video dedicada.','RYZEN78700F',19,15,1020.00,1010.00,2,5,'1764561917_692d13fd08633.jpg',1,0,1,'2025-11-27 14:35:56','2025-12-01 13:11:11',NULL),(114,'PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5','La MSI MAG B860 TOMAHAWK WIFI es una placa base ATX para gaming compatible con los procesadores Intel Core Ultra (Serie 2) a través del socket LGA 1851. Ofrece características premium como PCIe 5.0, Thunderbolt 4, Wi-Fi 7 y LAN de 5 Gbps, además de soporte para memoria RAM DDR5.','MSIMAGB860',18,18,890.00,880.00,2,5,'1764254728_69286408ad1e4.jpg',1,0,1,'2025-11-27 14:45:28','2025-11-27 14:45:28',NULL),(115,'MOUSE GAMER RAZER BASILISK V3 26K DPI','Con el Razer Basilisk V3 X HyperSpeed, no hay límites sobre cómo eliges jugar. Equipado con 9 controles programables, conectividad inalámbrica de modo dual y Razer Chroma RGB personalizable, está diseñado para responder a un solo maestro: usted. Habilitado a través de Razer Synapse, Razer Hypershift le permite asignar y desbloquear un conjunto de comandos secundarios además de los 9 controles existentes en el mouse. Como un mouse ergonómico inalámbrico para juegos diseñado para juegos largos, puede pasar mucho tiempo antes de que sea necesario reemplazar las baterías.','BASILISKV3',17,12,210.00,200.00,2,5,'1764255356_6928667c332b2.webp',1,0,1,'2025-11-27 14:55:56','2025-11-27 14:55:56',NULL),(116,'PLACA MADRE ASUS ROG STRIX B850 A GAMING WIFI AM5','La ASUS ROG STRIX B850 A GAMING WIFI es una placa base con socket AM5 de formato ATX, diseñada para procesadores AMD Ryzen serie 7000, 8000 y 9000. Ofrece características de gama alta como DDR5, PCIe 5.0 para la tarjeta gráfica, Wi-Fi 7, y una solución de alimentación robusta para soportar procesadores de alto rendimiento. Su diseño también incluye un acabado estético en blanco y una solución de enfriamiento mejorada.','B850 ROG',18,10,960.00,950.00,2,5,'1764256530_69286b12a8371.webp',1,0,1,'2025-11-27 15:15:30','2025-11-27 15:23:25',NULL),(117,'CASE ENKORE SHADOW ENK5021 ARGB SIN FUENTE 4 FANS','La TARJETA DE VIDEO AMD RADEON XFX SWIFT GLASS 9070 16GB WHITE EDITION OC es una tarjeta gráfica de alta gama para juegos, con un diseño blanco de triple ventilador de la línea Swift de XFX. Cuenta con 16GB de memoria GDDR6, una interfaz PCIe 5.0 y el chip AMD Radeon RX 9070 XT con una frecuencia de hasta 2970 MHz (Boost Clock). Su sistema de refrigeración \"Swift\" está optimizado para un buen rendimiento térmico y un diseño moderno sin RGB, aunque tiene un logo blanco iluminado.','CG',20,15,2700.00,2800.00,2,5,'1764279504_6928c4d0a0838.webp',1,1,1,'2025-11-27 21:38:24','2025-12-23 18:04:08','2025-12-23 18:04:08'),(118,'fdsbnfbgvd','fdgngngf','456ngf',21,21,234.00,234.00,23,5,'1764422830_692af4ae1d94d.jpeg',1,0,1,'2025-11-29 13:27:10','2025-11-29 13:27:53','2025-11-29 13:27:53'),(119,'fdghgfjh','gfhmhmgfhmgf','gfhfgmk54',11,18,23.00,234.00,23,5,'1764422954_692af52a61f33.jpeg',1,0,1,'2025-11-29 13:29:14','2025-11-29 15:23:46','2025-11-29 15:23:46'),(120,'gbffdgbh','dfsbvdsbffgsdefhfdsghhbnfdgnnnghfffffffffffffffffffffffffffffffffffffffffffffffffffffffsawddhgfdgfdgfhngfdnhfgnghfngfngfngfngfnhgfdhrewojbbrgouebfdojusoujsfdbnusfbdfbudbsfudiubifdsubifdbuifdbufsud','cgs',19,15,1010.00,1010.00,2,5,'1764429904_692b105012aed.jpeg',1,0,1,'2025-11-29 15:25:04','2025-11-30 23:07:48','2025-11-30 23:07:48'),(121,'sdfbfdbdgf','sdfbvfsd','gfbdbgdfgbf',21,25,32.00,32.00,2,5,'1764429966_692b108e3804d.jpeg',1,0,1,'2025-11-29 15:26:06','2025-11-30 23:07:43','2025-11-30 23:07:43'),(122,'PROCESADOR INTEL CORE I3 10105F','El Intel Core i3-10105F es un procesador de escritorio de 10ª generación con 4 núcleos y 8 hilos, diseñado para el socket LGA 1200. Tiene una frecuencia base de \\(3.7\\) GHz que puede alcanzar los \\(4.4\\) GHz en modo turbo, 6 MB de caché y un TDP de \\(65\\)W. La \"F\" en su nombre indica que no cuenta con gráficos integrados, por lo que requiere una tarjeta gráfica dedicada para su funcionamiento.','PROCI310105F',19,14,290.00,280.00,2,5,'1764561687_692d1317c43fa.jpg',1,0,1,'2025-12-01 01:46:52','2025-12-01 13:11:39',NULL),(123,'PROCESADOR RYZEN AMD RYZEN 7 9800X 3D AM5','El AMD Ryzen 7 9800X3D es un procesador de 8 núcleos y 16 hilos con arquitectura de 4 nm, diseñado para gaming de alto rendimiento. Destaca por su tecnología 3D V-Cache, que incluye hasta 96MB de caché L3 y una frecuencia que alcanza los 5.2GHz, todo ello sobre el socket AM5 y con soporte para PCIe 5.0 y memoria DDR5. Ofrece una excelente eficiencia energética (120W TDP) y es ideal para juegos y aplicaciones exigentes.','PROC79800X',19,15,1960.00,1950.00,2,5,'1764554449_692cf6d112a8d.webp',1,0,1,'2025-12-01 02:00:49','2025-12-01 13:16:24',NULL),(124,'PROCESADOR AMD RYZEN 7 5800XT AM4 AST','El AMD Ryzen 7 5800XT AM4 es un procesador de 8 núcleos y 16 hilos para la plataforma AM4, con una frecuencia base de 3.8 GHz y un modo turbo que alcanza hasta 4.8 GHz. Basado en la arquitectura Zen 3, ofrece un alto rendimiento en juegos, multitarea y aplicaciones exigentes, apoyado por sus 36 MB de caché combinada (L2+L3).','RYZEN75800XT',19,15,760.00,750.00,2,5,'1764562032_692d1470742d2.jpg',1,0,1,'2025-12-01 02:15:01','2025-12-01 13:10:50',NULL),(125,'PROCESADOR INTEL CORE I5 14600KF LGA1700','El Intel Core i5-14600KF es un procesador de 14ª generación para socket LGA 1700, equipado con 14 núcleos (6 Performance-cores y 8 Efficient-cores) y 20 hilos, alcanzando una frecuencia turbo de hasta 5.3 GHz. Gracias a sus 24 MB de Intel Smart Cache, ofrece un rendimiento sólido en juegos, creación de contenido y multitarea intensiva. Este modelo no incluye gráficos integrados, por lo que requiere obligatoriamente una tarjeta gráfica dedicada.','PROCI514600KF',19,14,810.00,800.00,2,5,'1764561379_692d11e342567.jpg',1,0,1,'2025-12-01 02:22:22','2025-12-01 13:12:23',NULL),(126,'PROCESADOR INTEL CORE i7-14700KF CACHE 33 MB HASTA 5.6 GHZ','El Intel Core i7-14700KF es un procesador moderno para socket LGA 1700, con arquitectura híbrida — combina núcleos de rendimiento y eficiencia para maximizar potencia y eficiencia. Cuenta con 33 MB de caché (Intel Smart Cache) y puede alcanzar una frecuencia turbo de hasta 5.6 GHz, brindando un alto nivel de desempeño. Está pensado para tareas exigentes como juegos , edición de video, creación de contenido, renderizado 3D y multitarea intensiva.','PROCi7-14700KF',19,14,1360.00,1350.00,2,5,'1764561407_692d11ff694c4.jpg',1,0,1,'2025-12-01 02:31:01','2025-12-01 13:13:57',NULL),(127,'PROCESADOR AMD RYZEN 7 5700G 3.8GHZ','El AMD Ryzen 7 5700G es un procesador muy completo que combina alto rendimiento con gráficos integrados potentes, lo que lo convierte en una excelente opción para equipos que buscan buen desempeño sin necesidad inmediata de una tarjeta gráfica dedicada. Gracias a sus 8 núcleos, 16 hilos y arquitectura Zen 3, ofrece un rendimiento sólido en tareas de productividad, edición ligera, programación y multitarea. Su GPU integrada Vega 8 permite ejecutar juegos en calidad media y realizar trabajos gráficos básicos sin hardware adicional.','RYZEN75700G',19,15,685.00,675.00,2,5,'1764562185_692d150931460.jpg',1,0,1,'2025-12-01 02:39:43','2025-12-01 13:10:28',NULL),(128,'PROCESADOR PENTIUM G5420 OEM','El Intel Pentium Gold G5420 es un procesador básico y eficiente para tareas cotidianas, con 2 núcleos y 4 hilos, frecuencia de 3.8 GHz, gráficos integrados UHD 610 y bajo consumo de 54 W. Es ideal para oficinas, estudios, educación y equipos económicos. La versión OEM viene sin caja y usualmente sin disipador, siendo una opción accesible para reemplazos o PC sencillas.','PROCG5420OEM',19,14,110.00,100.00,2,5,'1764559810_692d0bc247648.jpg',1,0,1,'2025-12-01 02:47:26','2025-12-01 13:15:56',NULL),(129,'PROCESADOR INTEL CORE ULTRA 9 285K 3.70GHZ HASTA 5.70GHZ 36MB 24 CORE LGA1851','El Intel Core Ultra 9 285K es un procesador de última generación diseñado para ofrecer un rendimiento extremo en tareas profesionales, juegos avanzados y cargas de trabajo intensivas. Equipado con 24 núcleos híbridos (Performance y Efficient) y 36 MB de caché, este procesador alcanza una velocidad base de 3.70 GHz y un turbo máximo de 5.70 GHz, brindando una capacidad sobresaliente en multitarea, creación de contenido y aplicaciones de alto rendimiento.','PROC9285K',19,14,2610.00,2600.00,2,5,'1764560431_692d0e2feafe1.png',1,0,1,'2025-12-01 02:53:05','2025-12-01 13:15:34',NULL),(130,'PROCESADOR AMD RYZEN 5 9600X, CACHE 32 MB/ HASTA 5.4GHZ','El AMD Ryzen 5 9600X es un procesador de última generación diseñado para ofrecer un rendimiento sobresaliente en juegos, multitarea y aplicaciones modernas. Con 6 núcleos y 12 hilos, junto a su arquitectura avanzada, alcanza frecuencias de hasta 5.4 GHz, garantizando una respuesta rápida y estable incluso en tareas exigentes.\r\nEquipado con 32 MB de caché, el Ryzen 5 9600X mejora la velocidad de acceso a datos y optimiza el rendimiento por núcleo, brindando una experiencia fluida en productividad, streaming y gaming competitivo.','RYZEN59600X',19,15,875.00,865.00,2,5,'1764562386_692d15d2bcb9d.jpg',1,0,1,'2025-12-01 03:00:32','2025-12-01 13:09:52',NULL),(131,'PROCESADOR INTEL CORE i5-14600K LGA1700','El Intel Core i5-14600K es un procesador de 14ª generación diseñado para ofrecer un rendimiento destacado en juegos, creación de contenido y multitarea avanzada. Cuenta con 14 núcleos híbridos (6 Performance-cores y 8 Efficient-cores) y 20 hilos, brindando una excelente combinación de potencia y eficiencia para cualquier tipo de tarea.\r\nAlcanza una frecuencia turbo de hasta 5.3 GHz, lo que garantiza tiempos de respuesta rápidos y un desempeño fluido en aplicaciones exigentes.','PROCi5-14600K',19,14,840.00,830.00,2,5,'1764562536_692d1668b233f.jpg',1,0,1,'2025-12-01 03:06:46','2025-12-01 13:13:36',NULL),(132,'PROCESADOR INTEL CORE I3-9100F 2.50GZ OEM','El Intel Core i3-9100F es un procesador de 4 núcleos y 4 hilos, perteneciente a la 9ª generación Coffee Lake. Trabaja a 3.6 GHz y puede llegar hasta 4.2 GHz con Turbo Boost. Incluye 6 MB de caché, tiene un consumo de 65 W (TDP) y utiliza el socket LGA 1151, compatible con placas madre serie 300.','PROCI3-9100F',19,14,170.00,160.00,2,5,'1764562653_692d16dd290cd.jpg',1,0,1,'2025-12-01 03:12:45','2025-12-01 13:12:04',NULL),(133,'PROCESADOR AMD Ryzen 9 9950X 4.3GHZl 64MB AM5','El AMD Ryzen 9 9950X ofrece una potencia extrema para llevar tu PC al máximo rendimiento en cualquier tarea. Con una frecuencia base de 4.3 GHz, arquitectura Zen 5 y 64 MB de caché L3, este procesador está diseñado para manejar cargas de trabajo avanzadas con una velocidad y eficiencia sobresalientes. Su plataforma AM5 permite aprovechar tecnologías modernas como DDR5 y PCIe 5.0, garantizando un sistema rápido, ágil y preparado para el futuro','PROC99950X',19,15,2210.00,2200.00,2,5,'1764596370_692d9a920c79d.png',1,0,1,'2025-12-01 13:39:30','2025-12-01 13:39:30',NULL),(134,'PROCESADOR AMD RYZEN 5 5500X3D 3.00GHZ HASTA 4.00GHZ 96MB 6 CORE AM4','El AMD Ryzen 5 5500X3D ofrece un rendimiento sobresaliente gracias a su tecnología 3D V-Cache, que incorpora 96 MB de caché, permitiendo una mayor rapidez en juegos y tareas que dependen fuertemente del acceso a datos. Con 6 núcleos y 12 hilos, este procesador alcanza una frecuencia de 3.0 GHz, llegando hasta 4.0 GHz en modo turbo, proporcionando una respuesta fluida tanto en aplicaciones de uso diario como en cargas más exigentes.','PROC55500X3D',19,15,700.00,690.00,2,5,'1764597475_692d9ee3c2a16.jpg',1,0,1,'2025-12-01 13:57:55','2025-12-01 13:57:55',NULL),(135,'PROCESADOR INTEL CORE I9 14900K LGA1700','El Intel Core i9-14900K es un procesador de alto rendimiento diseñado para ofrecer la máxima potencia en juegos, creación de contenido y multitarea intensiva. Con su arquitectura híbrida de 14ª generación, integra 24 núcleos (8 de rendimiento y 16 de eficiencia) junto a 32 hilos, permitiendo ejecutar aplicaciones exigentes y flujos de trabajo pesados sin perder velocidad.','PROC914900K',19,14,1990.00,1980.00,2,5,'1764598184_692da1a892331.jpg',1,0,1,'2025-12-01 14:09:44','2025-12-01 14:09:44',NULL),(136,'PROCESADOR INTEL CORE i5-14400 OEM','El Intel Core i5-14400 es un procesador de 14ª generación con 10 núcleos (6 de alto rendimiento + 4 eficientes) y 16 hilos, con frecuencia turbo de hasta 4.7 GHz y 20 MB de Intel Smart Cache. Incluye gráficos integrados Intel UHD Graphics 730, es compatible con memoria DDR4 o DDR5 y usa socket LGA1700. Tiene un TDP base de 65 W, ideal para equipos equilibrados que busquen rendimiento eficiente sin excesivo consumo.','PROC5-14400',19,14,620.00,610.00,2,5,'1764598655_692da37f878ed.jpg',1,0,1,'2025-12-01 14:17:35','2025-12-01 14:17:35',NULL),(137,'PROCESADOR AMD RYZEN 9 9900X 4.40GHZ HASTA 5.60GHZ 64MB 12 CORE AM5','El AMD Ryzen 9 9900X (AM5) es un procesador de gama alta con 12 núcleos, diseñado para rendir al máximo en tareas exigentes. Tiene una frecuencia base de 4.40 GHz y puede alcanzar hasta 5.60 GHz en modo turbo, lo que lo hace ideal para rendimiento intenso y fluido. Con 64 MB de caché, ofrece acceso rápido a datos, optimizando la velocidad en juegos, edición, renderizado y multitarea.','PROC99900X',19,15,1730.00,1720.00,2,5,'1764599225_692da5b97f76a.jpg',1,0,1,'2025-12-01 14:27:05','2025-12-01 14:27:05',NULL),(138,'PROCESADOR INTEL CORE ULTRA 5 225F 3.30 4.9GHZ 20MB','El Intel Core Ultra 5 225F es un procesador moderno orientado al rendimiento balanceado, diseñado para ofrecer buena velocidad en tareas diarias, juegos y productividad. Con frecuencias que alcanzan hasta 4.9 GHz y 20 MB de caché, proporciona una experiencia fluida y eficiente, manteniendo un consumo moderado y aprovechando la arquitectura Intel de última generación. Es ideal para usuarios que necesitan potencia sin llegar al nivel extremo de los procesadores tope de gama.','PROC5225F',19,14,294.00,284.00,2,5,'1764599764_692da7d4d19b6.jpg',1,0,1,'2025-12-01 14:36:04','2025-12-01 14:36:04',NULL),(139,'PROCESADOR AMD RYZEN 9 9950X3D 4.30GHZ HASTA','El AMD Ryzen 9 9950X3D es un procesador de gama alta para socket AM5, con arquitectura Zen 5 y tecnología 3D V-Cache. Con 16 núcleos y 32 hilos, frecuencia base alrededor de 4.3 GHz y turbo de hasta ≈ 5.7 GHz, ofrece un alto desempeño tanto en tareas de productividad como en juegos exigentes. Su ventaja destacada es la gran cantidad de caché — gracias al 3D V-Cache — lo que mejora notablemente el rendimiento en cargas de trabajo intensivas, reduciendo latencias y acelerando el acceso a datos.','PROC99950X3D',19,15,3010.00,3000.00,2,5,'1764600152_692da958f04b0.jpg',1,0,1,'2025-12-01 14:42:32','2025-12-01 14:42:32',NULL),(140,'PROCESADOR INTEL CORE I9-12900KF LGA 1700','El Intel Core i9-12900KF es un procesador de gama alta para escritorio con arquitectura híbrida (serie 12ª generación, “Alder Lake”), que combina 16 núcleos (8 núcleos de alto rendimiento + 8 núcleos eficientes) y 24 hilos. Puede alcanzar velocidades de hasta 5.20 GHz, y cuenta con 30 MB de Intel Smart Cache, lo que le proporciona potencia suficiente para juegos, edición de video, renderizado, multitarea exigente y trabajo profesional.','PROCI9-12900KF',19,14,1490.00,1480.00,2,5,'1764600790_692dabd6ed4f6.jpg',1,0,1,'2025-12-01 14:53:10','2025-12-01 14:53:10',NULL),(141,'PROCESADOR AMD RYZEN 5 4500 3.60GHz AM4','El AMD Ryzen 5 4500 es un procesador económico y eficiente para socket AM4, con 6 núcleos y 12 hilos, frecuencia base de 3.6 GHz y “boost” de hasta aproximadamente 4.1 GHz, Está pensado para ofrecer una relación calidad-precio atractiva — ideal para PCs de bajo o medio presupuesto — prestando buen desempeño en tareas comunes, navegación, ofimática, edición ligera y juegos cuando se usa con una tarjeta gráfica dedicada.','PROC54500',19,15,280.00,270.00,2,5,'1764601254_692dada670c87.jpg',1,0,1,'2025-12-01 15:00:54','2025-12-01 15:00:54',NULL),(142,'PROCESADOR AMD RYZEN 5 5500 OEM AM4','El AMD Ryzen 5 5500 es un procesador de gama media para socket AM4, con 6 núcleos y 12 hilos, frecuencia base de 3.6 GHz y turbo de hasta 4.2 GHz, Está basado en la arquitectura Zen 3 (7 nm), lo que le da eficiencia energética y buen rendimiento por núcleo. Su caché L3 es de 16 MB, y tiene un diseño de TDP de 65 W, ideal para sistemas balanceados en consumo y rendimiento.','PROC55500',19,15,310.00,300.00,2,5,'1764601627_692daf1b0d1eb.jpg',1,0,1,'2025-12-01 15:07:07','2025-12-01 15:07:07',NULL),(143,'PROCESADOR, AMD, RYZEN 5 5600GT 6N/12H 3.9Ghz','El AMD Ryzen 5 5600GT es un procesador de gama media-alta para socket AM4, basado en arquitectura Zen 3 (Cezanne). Tiene 6 núcleos y 12 hilos, con frecuencia base de 3.6 GHz y turbo de hasta 4.6 GHz. Cuenta con 16 MB de caché L3, soporte para memoria DDR4-3200, y un TDP de 65 W, Además, incluye gráficos integrados Radeon Graphics (Vega 7), lo que permite usar el PC sin necesidad de una tarjeta gráfica dedicada.','PROC55600GT',19,15,580.00,570.00,2,5,'1764601981_692db07d56e9d.jpg',1,0,1,'2025-12-01 15:13:01','2025-12-01 15:13:01',NULL),(144,'PROCESADOR INTEL I3 4130 CON DISIPADOR OEM','El Intel Core i3-4130 es un procesador de gama básica/media de escritorio, con arquitectura Haswell, fabricado en 22 nm, para socket LGA 1150. Tiene 2 núcleos físicos y 4 hilos (Hyper-Threading), opera a una frecuencia de 3.4 GHz, sin turbo boost. Cuenta con 3 MB de caché L3, incorpora gráficos integrados Intel HD Graphics 4400, y tiene un consumo (TDP) de 54 W. Este procesador está concebido para tareas cotidianas: ofimática, navegación, multimedia, edición ligera, y uso general. Gracias a sus gráficos integrados puede funcionar sin necesidad de tarjeta gráfica dedicada, ideal para PCs económicas o de oficina.','PROC34130',19,15,110.00,100.00,2,5,'1764602499_692db2833ad94.jpg',1,0,1,'2025-12-01 15:21:39','2025-12-01 15:21:39',NULL),(145,'PROCESADOR INTEL I3 3240 CON DISIPADOR OEM','El Intel Core i3-3240 es un procesador de escritorio de gama básica/media, basado en la arquitectura Ivy Bridge, fabricado en 22 nm. Tiene 2 núcleos físicos y 4 hilos (Hyper-Threading), con frecuencia de 3.4 GHz. Cuenta con 3 MB de caché L3, lo que ayuda a mantener la agilidad del sistema en tareas simples y cotidianas. Además, incluye gráficos integrados Intel HD Graphics 2500, suficientes para uso de oficina, navegación, reproducción de video y tareas multimedia básicas sin necesidad de tarjeta gráfica dedicada, Su consumo es moderado (TDP ~ 55 W), y es compatible con memorias DDR3, lo que lo hace adecuado para equipos compactos o económicos.','PROC33240',19,14,80.00,70.00,2,5,'1764603127_692db4f71e311.jpg',1,0,1,'2025-12-01 15:32:07','2025-12-01 15:32:07',NULL),(146,'PROCESADOR AMD RYZEN 7 7700X AM5','El AMD Ryzen 7 7700X es un procesador de escritorio de alto rendimiento diseñado para gaming, edición, creación de contenido y tareas exigentes. Usa la arquitectura Zen 4 y está fabricado a 5 nm, lo que le asegura eficiencia y potencia. Tiene 8 núcleos y 16 hilos, lo que permite manejar múltiples tareas al mismo tiempo sin perder rendimiento. Su frecuencia base suele rondar los 4.5 GHz, y puede alcanzar hasta 5.4 GHz en modo turbo, lo que asegura un rendimiento muy rápido en tareas intensivas, juegos y aplicaciones pesadas.','PROC77700X',19,15,1220.00,1210.00,2,5,'1764603633_692db6f113f89.jpg',1,0,1,'2025-12-01 15:40:33','2025-12-01 15:40:33',NULL),(147,'PROCESADOR INTEL CORE I7 14700F 2.1GHZ HASTA 5.4GHZ','El Intel Core i7-14700F es un procesador de gama alta para escritorio con arquitectura híbrida de 14ª generación, compatible con socket LGA 1700. Cuenta con 20 núcleos totales (8 de “Performance-cores” + 12 de “Efficient-cores”) y 28 hilos, ideal para tareas exigentes. Su frecuencia turbo máxima llega a 5.4 GHz. Además, incorpora 33 MB de Intel Smart Cache + memoria caché L2 adicional, y es compatible con DDR4 / DDR5 y PCIe 5.0 / 4.0, lo que le permite trabajar con hardware moderno y de alta velocidad. Es un modelo “F”, así que no incluye gráficos integrados — por lo que necesita tarjeta gráfica dedicada.','PROC714700F',19,14,1320.00,1310.00,2,5,'1764604553_692dba8933232.jpg',1,0,1,'2025-12-01 15:55:53','2025-12-01 15:55:53',NULL),(148,'PROCESADOR RYZEN 3 3200G 3.60GHz','El AMD Ryzen 3 3200G es un procesador de gama de entrada/media-económica con socket AM4, basado en arquitectura Zen+ (12 nm). Cuenta con 4 núcleos físicos y 4 hilos, una frecuencia base de 3.6 GHz y alcanza hasta 4.0 GHz con Turbo. Tiene integrada la gráfica Radeon Vega 8, lo que permite tener salida de video sin necesidad de tarjeta gráfica dedicada, ideal para tareas cotidianas, multimedia, ofimática y juegos ligeros/moderados, La caché L3 total es de 4 MB, y su TDP ronda los 65 W, lo que lo hace bastante eficiente en consumo para su rendimiento.','PROC33200G',19,15,280.00,270.00,2,5,'1764605001_692dbc49ee668.jpg',1,0,1,'2025-12-01 16:03:21','2025-12-01 16:03:21',NULL),(149,'PROCESADOR INTEL CORE I5-12600KF','El Intel Core i5-12600KF es un procesador de gama media-alta basado en la arquitectura híbrida de la 12ª generación (Alder Lake), compatible con socket LGA1700. Cuenta con 10 núcleos (6 núcleos de rendimiento + 4 núcleos eficientes) y 16 hilos, ideal para tareas exigentes. Su frecuencia turbo máxima es de 4.90 GHz, acompañado de 20 MB de Intel Smart Cache.','PROC5-12600KF',19,14,700.00,690.00,2,5,'1764605357_692dbdada7ee6.jpg',1,0,1,'2025-12-01 16:09:17','2025-12-01 16:09:17',NULL),(150,'PROCESADOR INTEL CORE I7 14700K LGA1700','El Intel Core i7-14700K es un procesador de escritorio de 14ª generación para el socket LGA1700, con 20 núcleos (8 de rendimiento y 12 eficientes), 28 hilos y una frecuencia turbo máxima de 5.6 GHz. Está diseñado para tareas exigentes como juegos y creación de contenido, y cuenta con gráficos integrados (Intel UHD Graphics 770), una caché de 33 MB y soporte para memorias DDR5 y DDR4.','PROC714700K',19,14,1450.00,1440.00,2,5,'1764605781_692dbf5556cba.jpg',1,0,1,'2025-12-01 16:16:21','2025-12-01 16:16:21',NULL),(151,'PROCESADOR AMD RYZEN 5 7500F OEM AM5','El AMD Ryzen 5 7500F es un procesador de 6 núcleos y 12 hilos para el socket AM5, con una frecuencia base de 3.7 GHz que alcanza hasta 5.0 GHz en modo turbo. Es una versión OEM sin gráficos integrados, ideal para PCs de gaming o de alto rendimiento que usarán una tarjeta gráfica dedicada, y cuenta con 32 MB de caché L3 y un TDP de 65W.','PROC57500F',19,15,600.00,590.00,2,5,'1764606593_692dc2810778b.jpg',1,0,1,'2025-12-01 16:29:53','2025-12-01 16:29:53',NULL),(152,'PROCESADOR RYZEN 7 7800X3D AM5 8N 16H 4.2GHZ GPU OEM','El AMD Ryzen 7 7800X3D usa arquitectura Zen 4 sobre socket AM5, con 8 núcleos y 16 hilos. Su frecuencia base es de 4.2 GHz y alcanza hasta 5.0 GHz en modo turbo, ideal para rendimiento rápido en tareas intensivas. Destaca por su enorme caché L3 de 96 MB mediante la tecnología 3D V-Cache, lo que mejora dramáticamente la latencia y el rendimiento en videojuegos y tareas sensibles a caché. Es compatible con memoria DDR5 y PCIe 5.0, lo que lo deja listo para hardware moderno y futuras generaciones.','PROC77800X3D',19,15,1560.00,1550.00,2,5,'1764607054_692dc44e2a36c.jpg',1,0,1,'2025-12-01 16:37:34','2025-12-01 16:37:34',NULL),(153,'PROCESADOR AMD RYZEN 7 7800X3D AM5','El Ryzen 7 7800X3D es un procesador AM5 de alto rendimiento con 8 núcleos, 16 hilos y 96 MB de caché 3D, optimizado para ofrecer los mejores FPS en juegos y excelente desempeño en tareas exigentes. Es moderno, eficiente y compatible con DDR5 y PCIe 5.0.','PROC7-7800X3D',19,15,1660.00,1650.00,2,5,'1764607774_692dc71e8ba67.jpg',1,0,1,'2025-12-01 16:49:34','2025-12-01 16:49:34',NULL),(154,'PROCESADOR INTEL CORE i5-13400F, Cache 20MB, Hasta 4.6','El Intel Core i5-13400F es un procesador eficiente de gama media-alta con nucleos e hilos suficientes para gaming, trabajo y multitarea. Ofrece hasta 4.6 GHz en turbo y 20 MB de caché, proporcionando buen rendimiento por núcleo y compatibilidad con hardware moderno a un precio accesible.','PROC5-13400F',19,14,585.00,575.00,2,5,'1764608263_692dc9073a7cd.jpg',1,0,1,'2025-12-01 16:57:43','2025-12-01 16:57:43',NULL),(155,'PROCESADOR AMD RYZEN 7 5700X AM4, 3.4GHZ CAJA','El Ryzen 7 5700X es un procesador Zen 3 para socket AM4, con 8 núcleos y 16 hilos, frecuencia base de 3.4 GHz y turbo hasta 4.6 GHz, y 32 MB de caché L3. Ofrece un buen balance entre potencia y eficiencia (TDP de 65 W), ideal para gaming, edición, multitarea y uso exigente sin gastar demasiado.','PROC7-5700X',19,15,710.00,700.00,2,5,'1764608776_692dcb08eafae.jpg',1,0,1,'2025-12-01 17:06:16','2025-12-01 17:06:16',NULL),(156,'PROCESADOR AMD RYZEN 5 8500G, AM5','El AMD Ryzen 5 8500G es un procesador de escritorio para el socket AM5, con 6 núcleos y 12 hilos, que alcanza una frecuencia de hasta 5.0 GHz y tiene gráficos integrados AMD Radeon 740M. Es ideal para sistemas modernos que buscan versatilidad en tareas de productividad y gaming básico, gracias a su arquitectura Zen 4, compatibilidad con memoria DDR5 y PCIe 4.0, y un TDP de 65W.','PROC5-8500G',19,15,560.00,550.00,2,5,'1764609300_692dcd14b1015.jpg',1,0,1,'2025-12-01 17:15:00','2025-12-01 17:15:00',NULL),(157,'PROCESADOR INTEL CORE I5 12400F OEM LGA 1700','El i5-12400F es un procesador de escritorio de 6 núcleos y 12 hilos, con frecuencia turbo de hasta 4.4 GHz y 18 MB de caché Intel Smart Cache. Utiliza socket LGA 1700 y necesita una tarjeta gráfica dedicada (no incluye iGPU). Es una opción equilibrada en potencia y eficiencia, ideal para gaming, productividad y multitarea sin gastar demasiado.','PROC5-12400F',19,14,410.00,400.00,2,5,'1764609950_692dcf9e8c88e.jpg',1,0,1,'2025-12-01 17:25:50','2025-12-01 17:25:50',NULL),(158,'PROCESADOR INTEL CORE I7 12700KF LGA1700','El Intel Core i7-12700KF es un procesador de 12 núcleos (8 de rendimiento + 4 eficientes) y 20 hilos, con frecuencias que alcanzan hasta 5.0 GHz y 25 MB de caché. Está diseñado para ofrecer un rendimiento alto en juegos, edición, renderizado y multitarea exigente, con soporte para memorias DDR4/DDR5 y PCIe 5.0.','PROC7-12700KF',19,14,890.00,880.00,2,5,'1764610359_692dd1377b7f5.jpg',1,0,1,'2025-12-01 17:32:39','2025-12-01 17:32:39',NULL),(159,'PROCESADOR AMD RYZEN 5 7600X AM5','El Ryzen 5 7600X es un procesador moderno con 6 núcleos y 12 hilos, ideal para gaming, edición y trabajos exigentes. Al ser parte de la plataforma AM5, ofrece arquitectura actual, compatibilidad con memorias modernas y un buen equilibrio entre potencia y eficiencia.','PROC57600X',19,15,855.00,845.00,2,5,'1764610785_692dd2e10d882.jpg',1,0,1,'2025-12-01 17:39:45','2025-12-01 17:39:45',NULL),(160,'CPU AMD RYZEN 5 8600G 4.30GHZ 6N 12TH 22MB AMD','El Ryzen 5 8600G es un procesador APU moderno con 6 núcleos y 12 hilos, frecuencia base de 4.3 GHz y turbo de hasta 5.0 GHz, ideal para quienes buscan rendimiento eficiente sin gastar de más. Incorpora gráficos integrados Radeon 760M, lo que permite usar el PC sin tarjeta gráfica dedicada. Es compatible con socket AM5, memoria DDR5, y ofrece buen equilibrio entre potencia, eficiencia y versatilidad.','PROC5-8600G',19,15,715.00,705.00,2,5,'1764611199_692dd47fd98bf.jpg',1,1,1,'2025-12-01 17:46:39','2025-12-15 19:35:55',NULL),(161,'PROCESADOR AMD RYZEN 7 8700G, AM5','El AMD Ryzen 7 8700G es un procesador de 8 núcleos y 16 hilos para escritorio, con arquitectura Zen 4 y socket AM5. Su principal característica es la combinación de alto rendimiento de CPU (hasta 5.1 GHz) y la potente gráfica integrada AMD Radeon 780M, lo que lo hace ideal para PCs compactos que no requieren una tarjeta gráfica dedicada para juegos ligeros o tareas de productividad.','PROC7-8700G',19,15,1040.00,1030.00,2,5,'1764621748_692dfdb4dda6b.jpg',1,0,1,'2025-12-01 20:42:28','2025-12-01 20:42:28',NULL),(162,'dghbnteghng','hgnfnhgf','hnnhgfhgnf',13,21,32.00,23.00,2,5,'1764622637_692e012d75cfc.jpeg',1,0,1,'2025-12-01 20:57:17','2025-12-01 21:03:59','2025-12-01 21:03:59'),(163,'PROCESADOR INTEL CORE I5-12400F 2.50GZ CAJA','El Intel Core i5-12400F es un procesador de 12ª generación diseñado para PCs de escritorio que ofrece un rendimiento muy equilibrado para gaming y multitarea. Cuenta con 6 núcleos y 12 hilos que alcanzan frecuencias entre 2.50 GHz y 4.40 GHz en modo turbo, proporcionando buena velocidad en tareas diarias, trabajo, edición ligera y juegos modernos. Utiliza el socket LGA 1700 y es compatible tanto con memorias DDR4 como DDR5, lo que permite armar una PC flexible y actualizable.','PROC5-2400F',19,14,510.00,500.00,2,5,'1764622958_692e026edd0ea.jpg',1,0,1,'2025-12-01 21:02:38','2025-12-01 21:02:38',NULL),(164,'PROCESADOR AMD RYZEN 7 5700X OEM AM4','El AMD Ryzen 7 5700X es un procesador de 8 núcleos y 16 hilos basado en la arquitectura Zen 3, diseñado para ofrecer alto rendimiento con bajo consumo. Trabaja entre 3.4 GHz y 4.6 GHz, permitiendo ejecutar juegos modernos y programas exigentes con fluidez. Su gran caché de 32 MB mejora la rapidez en procesamiento y respuesta del sistema. Funciona en socket AM4 y usa memoria DDR4, siendo ideal para actualizar o armar una PC potente sin gastar demasiado.','PROC75700XY',19,15,670.00,660.00,2,5,'1764623534_692e04ae075c1.jpg',1,0,1,'2025-12-01 21:12:14','2025-12-01 21:12:14',NULL),(165,'PROCESADOR AMD RYZEN 7 5700G OEM AM4 AST','El Ryzen 7 5700G es un procesador-APU basado en arquitectura Zen 3 fabricado en 7 nm que reúne potencia de CPU y gráficos integrados en un solo chip. Tiene 8 núcleos y 16 hilos de ejecución, con frecuencia base de alrededor de 3.8 GHz y turbo de hasta 4.6 GHz, lo que asegura buen desempeño tanto en tareas de múltiples hilos como en aquellas que dependen de potencia por núcleo. Incluye una GPU integrada (Radeon Graphics / Vega 8) que permite generar video sin necesidad de tarjeta gráfica dedicada, lo que lo hace funcional “temprano” sin invertir adicional.','PROC75700GOEM',19,15,650.00,640.00,2,5,'1764623868_692e05fc7b613.jpg',1,0,1,'2025-12-01 21:17:48','2025-12-01 21:17:48',NULL),(166,'PROCESADOR AMD RYZEN 5 5500 3.60 6N 12TH AM4 19MB','El Ryzen 5 5500 es un procesador de escritorio basado en arquitectura Zen 3 (7 nm) que ofrece un equilibrio atractivo entre potencia, eficiencia y compatibilidad. Tiene 6 núcleos y 12 hilos, con frecuencia base en 3.6 GHz y turbo hasta aproximadamente 4.2 GHz — suficiente para tareas cotidianas, gaming y trabajo multitarea con buen rendimiento. Dispone de caché L2 y L3 combinada (con 16 MB de caché L3), lo que ayuda a mantener velocidad y fluidez en procesos múltiples o exigentes. Su socket AM4 y soporte de memoria DDR4 lo hacen compatible con muchas placas madre existentes, facilitando construir o actualizar una PC sin gastar demasiado.','PROC555003606N',19,15,350.00,340.00,2,5,'1764624669_692e091d78571.jpg',1,0,1,'2025-12-01 21:31:09','2025-12-01 21:31:09',NULL),(167,'PROCESADOR AMD ATHLON 3000G','El Athlon 3000G es un procesador básico-económico para PC que combina CPU simple con gráficos integrados, ideal para tareas sencillas. Tiene 2 núcleos y 4 hilos trabajando a 3.5 GHz, lo que le permite ejecutar sistemas operativos modernos, navegar por internet, reproducir multimedia, ofimática, y funcionar como base de una PC ligera. Integra gráficos Radeon Vega 3, lo que evita la necesidad inmediata de una tarjeta gráfica dedicada si solo buscas tareas básicas, multimedia o juegos muy ligeros.','PROC3000G',19,15,140.00,130.00,2,5,'1764625105_692e0ad1a271a.jpg',1,0,1,'2025-12-01 21:38:25','2025-12-01 21:38:25',NULL),(168,'PLACA MADRE ASUS TUF GAMING B760 PLUS WIFI','La ASUS TUF GAMING B760-PLUS WIFI es una placa base ATX para procesadores Intel de 12ª y 13ª generación (socket LGA 1700), que ofrece conectividad inalámbrica Wi-Fi 6 y Bluetooth 5.2, además de Ethernet de 2.5 Gb. Está equipada con soporte para memoria DDR5 de hasta 128 GB, ranura PCIe 5.0 x16, M.2, y cuenta con un diseño de disipación mejorado y un sistema de audio de alta calidad con DTS.','PLACB760',18,10,840.00,830.00,2,5,'1764687694_692eff4e6f084.jpg',1,0,1,'2025-12-02 14:38:25','2025-12-02 15:01:34',NULL),(169,'PLACA MADRE ASUS TUF GAMING B550 PLUS WIFI II AM4','La ASUS TUF GAMING B550-PLUS WIFI II es una placa madre ATX con chipset AMD B550 que ofrece una base moderna, robusta y versátil para construir una PC con procesador AMD. Su socket AM4 la hace compatible con múltiples generaciones de CPUs Ryzen, por lo que ofrece flexibilidad y longevidad. Con soporte para memoria DDR4 hasta 128 GB y velocidades altas, brinda buenas posibilidades para multitarea, edición, juegos o trabajo exigente.','PLACB550',18,10,690.00,680.00,2,5,'1764686920_692efc481e151.jpg',1,0,1,'2025-12-02 14:48:40','2025-12-02 14:48:40',NULL),(170,'MAINBOARD MSI PRO H610M-G DDR4, LGA 1700','La MSI PRO H610M-G DDR4 es una placa madre compacta (factor micro-ATX) cuya arquitectura está pensada para construir una PC moderna con procesadores recientes Intel de socket LGA 1700. Admite procesadores de 12.ª, 13.ª e incluso 14.ª generación (Core, Pentium Gold, Celeron) — lo que te da flexibilidad para elegir CPU de distintas gamas. La placa usa memoria DDR4 con soporte para hasta 64 GB en dual-channel, con frecuencias de hasta 3200 MHz, lo que brinda balance entre compatibilidad, rendimiento y precio.','PLACH610M',18,18,275.00,265.00,2,5,'1764687382_692efe162ffc4.png',1,0,1,'2025-12-02 14:56:22','2025-12-02 14:56:22',NULL),(171,'PLACA ASUS TUF GAMING X870-PLUS WIFI AMD RYZEN AM5 DDR5','La ASUS TUF GAMING X870-PLUS WIFI es una placa madre pensada para sacar el máximo provecho a los procesadores modernos de AMD — su socket AM5 y su chipset X870 la preparan para las últimas generaciones Ryzen. Usa memorias DDR5 en configuración dual-channel, con soporte de hasta 4 módulos DIMM y velocidades altas, lo que permite un funcionamiento fluido, rápido y moderno.','PLACX870',18,10,1210.00,1200.00,2,5,'1764688075_692f00cbf1630.jpg',1,0,1,'2025-12-02 15:07:55','2025-12-02 15:07:55',NULL),(172,'MAINBOARD MSI B760 GAMING PLUS WIFI, DDR5 LGA 1700','La MSI B760 GAMING PLUS WIFI es una placa base moderna y completa que sirve como columna vertebral para un PC con procesador Intel reciente. Su zócalo LGA 1700 la hace compatible con CPUs Intel Core (12ª, 13ª, incluso 14ª generación), lo que garantiza un rendimiento actual y con posibilidad de actualización futura. Soporta memorias DDR5 en modo dual-channel, permitiendo montajes con RAM muy rápida y alta capacidad, ideal tanto para juegos como para tareas exigentes.','PLAC1700',18,18,610.00,600.00,2,5,'1764688453_692f024559a83.png',1,0,1,'2025-12-02 15:14:13','2025-12-02 15:14:13',NULL),(173,'PLACA MADRE ESONIC H610M DDR4 LGA 1700','La Esonic H610M DDR4 LGA1700 es una placa base sencilla y funcional pensada para montar PCs modernas con procesadores Intel de socket LGA 1700 (compatible con generaciones recientes). Su compatibilidad con memorias DDR4 ofrece una opción económica y estable para construir una PC sin gastar demasiado en componentes de gama alta. Con soporte para hasta 64 GB de RAM en dual-channel, almacenamiento por SATA y M.2, y opciones comunes de conectividad (USB, LAN, audio), ofrece lo esencial para un equipo de escritorio eficiente.','PLACH610MDDR4',18,28,260.00,250.00,2,5,'1764691152_692f0cd04f81e.jpg',1,0,1,'2025-12-02 15:59:12','2025-12-02 15:59:12',NULL),(174,'PLACA MADRE GIGABYTE H610M K V2 DDR5 LGA 1700','La Gigabyte H610M K V2 es una placa madre moderna y compacta (formato micro-ATX) pensada para construir una PC con procesador Intel actual. Su socket LGA 1700 y chipset Intel H610 la hacen compatible con procesadores Intel Core de 12.ª, 13.ª y 14.ª generación, lo que te permite usar CPUs recientes con buena compatibilidad. Su soporte de memoria DDR5 en dos ranuras DIMM, con hasta 128 GB y funcionamiento en doble canal, permite tener una base rápida y fluida para tareas variadas, desde ofimática hasta gaming. Para expansión gráfica o uso intensivo en gráficos, incluye ranura PCIe 4.0 x16, ideal para instalar tarjetas de video modernas. También ofrece ranura M.2 para SSD rápido, salidas de video (HDMI / DisplayPort, útil si tu CPU tiene gráficos integrados), múltiples puertos USB, red Gigabit LAN y audio integrado — cubriendo las necesidades básicas y medias de una PC actual.','PLACH610MKV2',18,24,310.00,300.00,2,5,'1764691821_692f0f6deee31.png',1,0,1,'2025-12-02 16:10:21','2025-12-02 16:10:21',NULL),(175,'PLACA MADRE ASUS ROG STRIX B850-G GAMING WIFI 7 AM5','La ROG STRIX B850-G Gaming WiFi es una placa madre moderna con socket AM5, diseñada para aprovechar al máximo los procesadores recientes de AMD en la plataforma AM5. Usa memoria DDR5 con soporte para altas velocidades y puede alojar hasta 4 módulos DIMM, lo que la hace ideal para un sistema rápido, actual y con mucho potencial de RAM. Cuenta con soporte para PCIe 5.0, ranuras M.2 múltiples para SSD ultrarrápidos, y conectividad de primera línea: red LAN 2.5 Gb, WiFi 7, salidas de video (HDMI + DisplayPort) y puertos USB-C de 20 Gbps, ofreciendo compatibilidad con periféricos y componentes modernos.','PLACB850-G',18,10,960.00,950.00,2,5,'1764692830_692f135e58500.png',1,0,1,'2025-12-02 16:27:10','2025-12-02 16:27:10',NULL),(176,'PLACA MADRE MSI MAG B860 TOMAHAWK WIFI LGA1851 D5','La MSI MAG B860 TOMAHAWK WIFI es una placa madre ATX para procesadores Intel con socket LGA 1851, diseñada para ofrecer una plataforma moderna, veloz y lista para nuevas generaciones. Su compatibilidad con memoria DDR5 (hasta 256 GB) y soporte de memorias muy rápidas la hacen ideal para quienes buscan un rendimiento fluido tanto en tareas comunes como exigentes. Dispone de ranura PCIe 5.0 para GPU dedicada, ranuras M.2 (una de ellas PCIe 5.0) para SSDs ultrarrápidas y múltiples opciones de expansión, lo que permite montar una PC equilibrada, sin cuellos de botella, y con almacenamiento rápido. Además integra conectividad avanzada con Wi-Fi 7, LAN 5 Gb, Thunderbolt 4, salidas modernas de video y puertos actualizados USB-C/A, lo que le da a tu sistema acceso a redes rápidas, periféricos modernos y compatibilidad con hardware reciente.','PLACB860MSI',18,18,890.00,880.00,2,5,'1764693486_692f15eecc288.png',1,0,1,'2025-12-02 16:38:06','2025-12-02 16:38:06',NULL),(177,'PLACA MADRE ASUS TUF GAMING B850-PLUS WIFI AM5','La ASUS TUF GAMING B850-PLUS WIFI es una placa madre ATX de nueva generación pensada para los procesadores modernos de AMD sobre el socket AM5. Está diseñada con componentes de grado militar, lo que le da robustez, durabilidad y estabilidad incluso bajo carga prolongada. Usa memoria DDR5 en configuración de doble canal con soporte para altas velocidades, permitiendo aprovechar toda la potencia de CPUs Ryzen recientes y de futuras generaciones. Integra ranuras PCIe 5.0 para tarjeta gráfica y para almacenamiento ultrarrápido, y dispone de múltiples ranuras M.2 para SSD NVMe, lo que la hace ideal para un sistema veloz, responsivo y preparado para hardware moderno.','PLACB850PS',18,10,940.00,930.00,2,5,'1764694140_692f187c5cba3.jpg',1,0,1,'2025-12-02 16:49:00','2025-12-02 16:49:00',NULL),(178,'PLACA MADRE MSI MPG B550 GAMING PLUS ATX V1','La MSI MPG B550 GAMING PLUS es una placa madre ATX con socket AM4 y chipset B550 que sirve como base sólida y versátil para un PC con procesador AMD Ryzen. Soporta hasta 128 GB de memoria RAM DDR4 en cuatro ranuras DIMM, con posibilidades de overclock, lo que permite un buen equilibrio entre rendimiento y compatibilidad. Incluye ranuras modernas para almacenamiento como M.2 (una PCIe Gen4 x4 + otra Gen3 x4) y puertos SATA, ofreciendo velocidad y flexibilidad para SSDs o discos duros. Su diseño de alimentación y disipación asegura estabilidad incluso con CPUs potentes bajo carga constante, ideal para gaming o tareas exigentes.','PLACB550MPG',18,18,540.00,530.00,2,5,'1764695006_692f1bdec3d02.png',1,0,1,'2025-12-02 17:03:26','2025-12-02 17:03:26',NULL),(179,'PLACA MADRE GIGABYTE Z790 AORUS ELITE AX','La Z790 AORUS ELITE AX es una placa madre ATX con chipset Z790 y socket LGA 1700, pensada para aprovechar al máximo procesadores Intel de 12.ª, 13.ª o incluso 14.ª generación. Su diseño de alimentación (“VRM”) robusto permite entregar potencia estable incluso con CPUs potentes, garantizando estabilidad y buena respuesta bajo cargas intensas. Soporta memorias DDR5 en configuración de 4 ranuras DIMM, con posibilidad de frecuencias altas, lo que da fluidez en multitarea, edición o gaming exigente. Ofrece múltiples ranuras M.2 para SSD NVMe y soporte PCIe 5.0/4.0, lo que asegura compatibilidad con hardware moderno — SSD rápidos, tarjetas gráficas de última generación y periféricos avanzados. Su conectividad también destaca: incluye red 2.5 GbE y Wi-Fi 6E, USB-C / USB modernos y buen soporte de puertos, lo que da una plataforma versátil, actual y preparada para periféricos y redes modernas.','PLACZ790',18,24,880.00,870.00,2,5,'1764695726_692f1eae0d45b.png',1,0,1,'2025-12-02 17:15:26','2025-12-02 17:15:26',NULL),(180,'PLACA MSI MAG X870 TOMAHAWK WIFI ATX DDR5 AMD','La MAG X870 TOMAHAWK WIFI es una placa madre ATX de gama alta diseñada para procesadores modernos de AMD sobre socket AM5, pensada para ofrecer un sistema potente, actualizado y con tecnologías de última generación. Soporta memorias DDR5 de muy alta velocidad, lo que permite un rendimiento fluido y ágil en juegos, edición, multitarea o trabajo pesado. Su chipset X870 brinda compatibilidad con las últimas generaciones de CPUs Ryzen, garantizando longevidad de la plataforma. Integra conectividad moderna: red de 5 Gb, Wi-Fi 7, puertos USB4 de alta velocidad, múltiples ranuras M.2 y soporte PCIe 5.0, lo que garantiza compatibilidad con SSD ultrarrápidos, tarjetas gráficas potentes y periféricos avanzados.','PLACX870MAG',18,18,1240.00,1230.00,2,5,'1764696507_692f21bbb3c16.jpg',1,0,1,'2025-12-02 17:28:27','2025-12-02 17:28:27',NULL),(181,'PLACA MSI X870 GAMING PLUS WIFI ATX DDR5 AMD AM5','La MSI X870 GAMING PLUS WIFI es una placa madre ATX con socket AM5 y chipset X870 diseñada para aprovechar al máximo los procesadores AMD Ryzen de las series más nuevas. Su soporte para memorias DDR5, hasta 256 GB, permite que tu sistema tenga alta capacidad y velocidad, ideal para tareas exigentes y multitarea intensiva. Incluye ranuras de expansión modernas como PCIe 5.0 para tarjeta gráfica y ranuras M.2 (Gen5/Gen4) para almacenamiento ultrarrápido, lo que garantiza compatibilidad con GPUs potentes y SSD NVMe de última generación. Su sistema de alimentación robusta y su calidad de componentes proporcionan estabilidad y rendimiento constante incluso bajo cargas pesadas. Además incorpora conectividad avanzada: redes rápidas (LAN 5G + Wi-Fi 7), puertos USB modernos y audio de alta definición, lo que la convierte en una base completa para una PC actual, versátil y preparada para hardware moderno.','PLACX870ATX',18,18,1010.00,999.00,2,5,'1764697579_692f25ebba6d1.jpg',1,0,1,'2025-12-02 17:46:19','2025-12-02 17:46:19',NULL),(182,'PLACA MADRE ASUS ROG STRIX X870-A GAMING WIFI AM5, ATX','La ROG STRIX X870-A Gaming WiFi es una placa madre de gama alta diseñada para los procesadores modernos de AMD con socket AM5, pensada para construir PCs potentes, rápidas y listas para el futuro. Soporta memorias DDR5 de gran velocidad, con posibilidad de overclock y capacidad para decenas de gigabytes de RAM, lo que ofrece un rendimiento fluido en multitarea, edición y juegos exigentes. Cuenta con soporte PCIe 5.0, ranuras M.2 para SSD ultrarrápidos, lo que significa que almacenamiento y tarjetas gráficas modernas aprovechan al máximo su potencial. Integra conectividad avanzada: red por cable de alta velocidad, Wi-Fi de nueva generación, USB4 / USB-C modernos y soporte para periféricos actuales, garantizando compatibilidad con las tecnologías más recientes.','PLACX870-A',18,10,1360.00,1350.00,2,5,'1764698146_692f282228d20.png',1,0,1,'2025-12-02 17:55:46','2025-12-02 17:55:46',NULL),(183,'PLACA GIGABYTE B550 GAMING X V2 AMD RYZEN DDR4 AM4','La B550 GAMING X V2 es una placa madre ATX con socket AM4 y chipset AMD B550 pensada para armar PCs con procesadores AMD Ryzen con equilibrio entre rendimiento, compatibilidad y costo. Su soporte para memorias DDR4 en cuatro ranuras DIMM permite tener un sistema con buena capacidad de RAM (hasta 128 GB) trabajando en dual-channel, ideal para multitarea, juegos o software exigente. Ofrece ranuras modernas de expansión: PCIe 4.0 para tarjeta gráfica y una ranura M.2 PCIe 4.0 para SSD ultrarrápido, sumado a otra ranura M.2 adicional, lo que permite almacenamiento veloz y ampliaciones sin esfuerzo.','PLACB550XV',18,24,460.00,450.00,2,5,'1764707213_692f4b8d4ffc1.jpg',1,0,1,'2025-12-02 20:26:53','2025-12-02 20:26:53',NULL),(184,'PLACA ASUS TUF Z890 GAMING PLUS WI-FI 7 DDR5 LGA 1851','La ASUS TUF Gaming Z890-PLUS WIFI es una placa base ATX con chipset Intel Z890 y socket LGA 1851, diseñada para procesadores Intel Core Ultra (Serie 2). Destaca por su soporte para RAM DDR5 de alta velocidad (hasta 9066+ MT/s OC), conectividad Wi-Fi 7 y Ethernet de 2.5 Gb, una robusta solución de potencia para el VRM y una variedad de ranuras de almacenamiento M.2, incluyendo una con PCIe 5.0. Ofrece una solución de audio de alta calidad con el códec Realtek ALC1220P y múltiples conectores para ventiladores y RGB.','PLACZ890SA',18,10,940.00,930.00,2,5,'1764707888_692f4e306be87.jpg',1,0,1,'2025-12-02 20:38:08','2025-12-02 20:38:08',NULL),(185,'PLACA ASUS TUF GAMING A620M-PLUS WIFI M.ATX DDR5','La placa madre ASUS TUF GAMING A620M-PLUS WIFI es una tarjeta micro-ATX para socket AM5 diseñada para aprovechar procesadores recientes de AMD Ryzen, combinando compatibilidad moderna, memoria DDR5 veloz y conectividad robusta en un formato compacto. Está equipada con chipset A620, lo que la posiciona como una opción accesible pero suficientemente completa: permite DDR5, ranuras PCIe 4.0, doble slot M.2 para SSD rápidos, soporte para hasta 192 GB de RAM, red 2.5 Gb, Wi-Fi 6 y salidas de video si se usa CPU con gráficos integrados. Su diseño incorpora componentes duraderos (“grado militar” TUF), solución de alimentación estable y buen sistema de refrigeración, lo que le da confiabilidad incluso en uso prolongado o exigente. En suma, ofrece un balance entre funcionalidad, compatibilidad y precio, ideal para construir una PC moderna con buena relación costo-beneficio.','PLACA620M',18,10,560.00,550.00,2,5,'1764708220_692f4f7c54c62.png',1,0,1,'2025-12-02 20:43:40','2025-12-02 20:43:40',NULL),(186,'PLACA MADRE GIGABYTE Z790 EAGLE AX WIFI LGA1700 D5 AST','La Z790 EAGLE AX WIFI es una placa madre ATX que actúa como base moderna y potente para PCs con procesadores Intel de 12ª, 13ª o 14ª generación. Su compatibilidad con memoria DDR5 permite usar RAM rápida y abundante, mejorando notablemente la fluidez en juegos, edición y multitarea. Con PCIe 5.0 + ranura reforzada para tarjeta gráfica y múltiples ranuras M.2 para SSD NVMe, garantiza que gráficos, almacenamiento y componentes modernos funcionen al máximo rendimiento. Integra conectividad actualizada: red por cable rápida (2.5 GbE), Wi-Fi 6E + Bluetooth, USB-C 10Gb/s y salidas de video/puertos traseros modernos, lo que la convierte en una plataforma versátil y preparada para periféricos actuales. Su diseño de alimentación (VRM robusto) y sistema de refrigeración aseguran estabilidad sostenida incluso con CPUs exigentes o bajo carga intensiva.','PLACZ790AX',18,24,870.00,860.00,2,5,'1764708799_692f51bfa3110.png',1,0,1,'2025-12-02 20:53:19','2025-12-02 20:53:19',NULL),(187,'PLACA ASROCK B850 STEEL LEGEND WIFI ATX DDR5 AMD','La ASRock B850 Steel Legend WiFi es una placa madre ATX moderna para CPUs AMD con socket AM5, diseñada con potencia y versatilidad para sistemas actuales. Admite memoria DDR5 en hasta cuatro módulos DIMM, lo que permite tener RAM de alta velocidad y gran capacidad, ideal para multitarea, edición, juegos o trabajos exigentes. Tiene ranura PCIe 5.0 x16 para tarjetas gráficas potentes y varias ranuras M.2 (una compatible con PCIe 5.0 y otras con PCIe 4.0) para SSD ultrarrápidos, lo que garantiza que almacenamiento y GPU funcionen sin limitaciones de ancho de banda. Cuenta con conectividad moderna: red cableada 2.5 Gb, Wi-Fi 7 integrado y puertos USB rápidos (incluyendo USB-C), ofreciendo compatibilidad con redes, periféricos y dispositivos nuevos. Su diseño de alimentación con fases robustas (Dr.MOS) y disipación eficaz asegura estabilidad del sistema incluso con CPUs exigentes o bajo carga intensa — ideal para uso prolongado, gaming o tareas pesadas.','PLACB850KS',18,29,920.00,910.00,2,5,'1764709399_692f5417561e9.png',1,0,1,'2025-12-02 21:03:19','2025-12-02 21:03:19',NULL),(188,'PLACA ASROCK B760M PG SONIC WIFI M-ATX DDR5 LGA 1700','La B760M PG SONIC WiFi es una placa madre micro-ATX pensada para construir una PC moderna con procesadores Intel recientes (socket LGA 1700). Acepta memorias DDR5 rápidas, lo que permite que el sistema sea ágil y fluido en tareas cotidianas, juegos o trabajo pesado. Integra ranura PCIe 5.0 para tarjeta gráfica, puerto M.2 y SATA para discos SSD o HDD, dando compatibilidad con hardware actual y velocidad de almacenamiento. Su sistema de alimentación con fases Dr.MOS garantiza estabilidad energética al procesador, incluso con CPUs potentes, lo que ayuda a mantener un buen rendimiento bajo carga. Ofrece conectividad moderna: red cableada rápida 2.5 Gb, Wi-Fi 6E, múltiples puertos USB (incluyendo USB-C), salidas gráficas digitales (HDMI / DisplayPort) — lo que asegura compatibilidad con periféricos, redes e internet actual.','PLACB760KA',18,29,560.00,550.00,2,5,'1764709735_692f5567ced68.png',1,0,1,'2025-12-02 21:08:55','2025-12-02 21:08:55',NULL),(189,'PLACA MADRE GIGABYTE B850 AORUS ELITE WIFI7 AM5 AST','La B850 AORUS ELITE WiFi7 es una placa base ATX de nueva generación con chipset B850 y socket AM5 que combina compatibilidad con los Ryzen más recientes, soporte para memorias DDR5 veloces, múltiples ranuras M.2 (incluyendo PCIe 5.0) para almacenamiento ultrarrápido, y una robusta regulación de energía con VRM digital 14+2+2 — ideal para CPUs modernos. Incluye conectividad avanzada con WiFi 7, LAN 2.5 Gb, salidas de video, puertos USB-C, USB 3.x, HDMI/DisplayPort, lo que la convierte en una base muy completa. Su diseño está orientado a estabilidad, versatilidad y preparación para hardware de vanguardia, lo que la hace adecuada tanto para gaming, edición, creación de contenido, multitarea intensiva o PC de alto desempeño.','PLACB850AIW',18,24,890.00,880.00,2,5,'1764710152_692f5708a2c0c.jpg',1,0,1,'2025-12-02 21:15:52','2025-12-02 21:15:52',NULL),(190,'PLACA MADRE GIGABYTE H810M-K DDR5','La H810M-K es una placa madre micro-ATX con socket LGA 1851 / chipset H810, pensada para sistemas modernos con procesadores Intel actuales. Soporta memoria DDR5 en configuración de doble canal mediante sus dos ranuras DIMM, lo que permite tener RAM rápida y fluida para tareas comunes, productividad, ofimática o incluso gaming moderado. Dispone de ranura PCIe 4.0 x16 para tarjeta gráfica dedicada y ranura M.2 para SSD NVMe, lo que permite combinar almacenamiento veloz con GPU potente sin cuellos de botella. Trae salidas de video (HDMI y DisplayPort), lo que facilita usarla con CPUs que tengan gráficos integrados. También ofrece conectividad básica y suficiente para un PC de escritorio: puertos USB, audio HD, red Gigabit LAN, soporte para ventiladores con control, almacenamiento SATA adicional — dando una base funcional, moderna y eficiente. Su diseño combina simplicidad con lo esencial: permite montar una PC confiable, actual y eficiente, sin extra de gama alta, ideal para un equipo de uso cotidiano, trabajo, estudio o como base económica con buen rendimiento.','PLACH810M-KDDR5',18,24,375.00,365.00,2,5,'1764710506_692f586aa0c96.png',1,0,1,'2025-12-02 21:21:46','2025-12-02 21:21:46',NULL),(191,'PLACA MADRE H810M GAMING WIFI6 DDR5','La H810M GAMING WiFi6 es una placa madre micro-ATX con socket LGA 1851, pensada para procesadores Intel recientes, ofreciendo soporte para memoria DDR5 en dual-channel, con hasta 128 GB, lo que permite un sistema ágil, moderno y con buena capacidad para multitarea, edición ligera o uso cotidiano. Integra conectividad actual: red 2.5 GbE, WiFi 6, Bluetooth, salidas HDMI/DisplayPort (útiles si el CPU tiene gráficos integrados), lo que facilita una PC funcional sin necesidad de componentes extra caros. Incluye ranura PCIe x16 para tarjeta gráfica dedicada y ranura M.2 + puertos SATA para almacenamiento SSD o HDD, lo que da flexibilidad para escoger entre velocidad o capacidad según tu presupuesto o necesidades. Su formato micro-ATX la hace ideal para PCs compactas o moderadas, equilibrando funcionalidad, costo y compatibilidad.','PLAC6DDR5',18,24,475.00,465.00,2,5,'1764711023_692f5a6fd2022.png',1,0,1,'2025-12-02 21:30:23','2025-12-02 21:30:23',NULL),(192,'PLACA MADRE GIGABYTE B850 EAGLE ICE WIFI7 AM5 AST','La B850 EAGLE WIFI7 ICE es una placa base ATX moderna pensada para procesadores AMD Ryzen con socket AM5, diseñada para darle a tu PC una base potente, veloz y preparada para hardware de nueva generación. Su soporte de memorias DDR5 en cuatro ranuras DIMM permite tener RAM rápida (hasta 8200 MHz en OC) y gran capacidad — lo que da agilidad en multitarea, edición, juegos o uso intensivo. La placa trae múltiples ranuras M.2 (incluyendo una compatible con PCIe 5.0) y ranuras PCIe actualizadas, lo que permite usar SSD ultrarrápidos y tarjetas gráficas potentes sin cuellos de botella. Su diseño de alimentación con VRM digital 8+2+2 y sistema de disipación robusto garantiza estabilidad aún con CPUs exigentes, cargas largas o componentes potentes. Además incluye conectividad moderna: red 2.5 Gb, Wi-Fi 7, salidas HDMI/DisplayPort, USB-C / USB modernos — lo que la hace compatible con periféricos actuales, conexión veloz a internet y dispositivos nuevos.','PLACA0B850',18,24,880.00,870.00,2,5,'1764711596_692f5cacaa197.png',1,0,1,'2025-12-02 21:39:56','2025-12-02 21:39:56',NULL),(193,'PLACA MADRE MSI PRO B840M-B S/V/L DDR5','La MSI PRO B840M-B es una placa madre micro-ATX con socket AM5 que sirve como base moderada para construir un PC con procesador AMD reciente (series Ryzen 7000 / 8000 / 9000). Está diseñada para ofrecer un buen equilibrio entre prestaciones y precio: permite usar memoria DDR5 en dual-channel con soporte hasta ~8000 MHz (OC), lo que le da al sistema agilidad, buen desempeño en multitarea, juegos o trabajo cotidiano. Posee ranura PCIe 4.0 x16 para tarjeta gráfica, ranuras M.2 para SSD NVMe rápidos y puertos SATA para almacenamiento tradicional, combinando velocidad y flexibilidad. Su red integrada de 2.5 Gb y soporte para audio de alta definición la hacen adecuada tanto para gaming como para trabajo, streaming o tareas multimedia. Su formato compacto y funciones esenciales la convierten en una opción práctica para quienes buscan montar una PC actual, equilibrada y funcional sin gastar demasiado en una placa “gama alta”.','PLACB840M-BSV',18,18,360.00,350.00,2,5,'1764712173_692f5eed5dde5.png',1,0,1,'2025-12-02 21:49:33','2025-12-02 21:49:33',NULL),(194,'PLACA MADRE ASUS TUF GAMING B650E PLUS WIFI AM5','La TUF GAMING B650E-PLUS WIFI es una placa madre ATX pensada para construir una PC moderna con procesadores AMD Ryzen recientes sobre socket AM5, combinando compatibilidad, potencia y estabilidad en un diseño robusto de “grado militar”. Al aceptar memorias DDR5 de alta velocidad (y hasta 256 GB), ofrece gran agilidad en multitarea, edición, gaming o tareas exigentes. Con soporte PCIe 5.0 para GPU y una ranura M.2 también PCIe 5.0 para SSD ultrarrápidos, garantiza que tanto gráficos como almacenamiento funcionen a máxima velocidad sin cuellos de botella. Su red integrada (LAN 2.5 Gb + Wi-Fi 6E) y puertos modernos (USB-C 20 Gbps, USB 3.x) aseguran conectividad rápida, versátil y preparada para periféricos actuales. Su alimentación reforzada y sistema térmico optimizado dan estabilidad incluso bajo cargas intensas, mientras su diseño TUF garantiza durabilidad y fiabilidad a largo plazo.','PLACB650E',18,10,820.00,810.00,2,5,'1764712574_692f607e33b00.png',1,0,1,'2025-12-02 21:56:14','2025-12-02 21:56:14',NULL),(195,'PLACA MADRE GIGABYTE B550 EAGLE WIFI6 ATX AST','La B550 EAGLE WIFI6 es una placa madre ATX con socket AM4 pensada para sistemas con procesadores AMD Ryzen de generaciones compatibles. Su diseño con fases de potencia digital 10+3 le da estabilidad para manejar CPUs exigentes y asegurar rendimiento constante. Utiliza memorias DDR4 en cuatro ranuras DIMM, lo que permite montar suficiente RAM para multitarea, edición, juegos o trabajo exigente sin gastar demasiado. Ofrece ranuras modernas: PCIe 4.0 x16 para tarjeta gráfica, dos ranuras M.2 para SSD NVMe — una con soporte PCIe 4.0 — lo que significa almacenamiento rápido y buena compatibilidad con GPUs actuales. Su conectividad incluye red cableada GbE más Wi-Fi 6 con Bluetooth, ofreciendo flexibilidad de conexión sin depender exclusivamente de cable Ethernet. La placa también incorpora opciones de expansión, conectores USB actuales, salidas de video (útil si usas procesador con gráficos integrados), y un diseño orientado a durabilidad gracias a su tecnología Ultra Durable y refuerzos en ranuras PCIe.','PLACB5506ATX',18,24,500.00,490.00,2,5,'1764712923_692f61db57faa.png',1,0,1,'2025-12-02 22:02:03','2025-12-02 22:02:03',NULL),(196,'PLACA MADRE ASUS ROG STRIX X870E-E GAMINGG WIFI','La ROG STRIX X870E-E GAMING WiFi es una placa madre de gama alta pensada para procesadores modernos con socket AM5, diseñada para exprimir al máximo CPUs potentes y hardware de nueva generación. Su soporte de memoria DDR5 permite velocidades muy altas y gran capacidad, lo que significa fluidez en multitarea, edición, juegos exigentes o trabajos pesados. Incluye ranuras PCIe 5.0 y múltiples ranuras M.2 (PCIe 5.0 y 4.0) para SSD ultrarrápidos, lo que garantiza que tanto la GPU como el almacenamiento funcionen con el máximo rendimiento sin cuellos de botella. Su sistema de alimentación con fases robustas y componentes premium asegura estabilidad incluso bajo cargas intensas o con CPUs de alta gama. En conectividad, ofrece lo moderno: WiFi 7, red 5 Gb, puertos USB4, salidas de video, audio de alta fidelidad y opciones de expansión diversas — ideal para ensamblar un PC completo, rápido, potente y actualizado.','PLACX870-E',18,10,2080.00,2070.00,2,5,'1764713294_692f634e00d65.jpg',1,0,1,'2025-12-02 22:08:14','2025-12-02 22:08:14',NULL),(197,'PLACA MADRE ASUS PRIME X870 P WIFI7 AM5','La ASUS PRIME X870-P WIFI es una placa madre ATX de última generación con socket AM5 y chipset X870, pensada para aprovechar al máximo los procesadores actuales de AMD Ryzen serie 7000 / 8000 / 9000. Su diseño de alimentación robusto — con etapas de energía potentes — ofrece estabilidad y potencia suficiente para CPUs exigentes, incluso en cargas intensas. Soporta memoria DDR5 en cuatro ranuras, lo que permite tener RAM rápida y abundante (hasta 192 GB) funcionando en dual-channel, ideal para multitarea, edición, juegos o trabajo pesado. Integra múltiples ranuras M.2 — una compatible con PCIe 5.0 y otras con PCIe 4.0/3.0 — garantizando almacenamiento ultrarrápido mediante SSD NVMe. Su ranura PCIe 5.0 x16 está preparada para tarjetas gráficas modernas, asegurando compatibilidad con hardware de vanguardia sin cuellos de botella.\r\n\r\nEn conectividad, incluye red cableada 2.5 Gb, WiFi 7 y puertos USB-C / USB modernos de alta velocidad, lo que permite uso óptimo de internet, periféricos y dispositivos externos actuales. Su sistema de refrigeración y diseño cuidado ayudan a mantener el sistema estable y fresco incluso en uso intensivo.','PLACX870P',18,10,910.00,900.00,2,5,'1764713707_692f64ebd9a02.png',1,0,1,'2025-12-02 22:15:07','2025-12-02 22:15:07',NULL),(198,'PLACA MADRE MSI B760M PROJECT ZERO DDR5 LGA1700','La B760M Project Zero DDR5 es una placa madre moderna con socket LGA 1700 pensada para procesadores Intel de 12.ª, 13.ª o 14.ª generación, concebida para ofrecer un equilibrio entre compatibilidad actual, rendimiento y practicidad. Soporta memoria DDR5 de alta velocidad, lo que permite que tu sistema resulte ágil y responsivo en tareas cotidianas, gaming o trabajo exigente. Su diseño permite instalar una tarjeta gráfica potente, almacenamiento NVMe rápido a través de ranuras M.2, y combinar componentes modernos manteniendo buena estabilidad. También integra conectividad actualizada con red de 2.5 Gb, soporte Wi-Fi 6E (versión con WiFi), puertos USB modernos, salidas de video (HDMI / DisplayPort — si el CPU tiene iGPU), lo que la convierte en una base versátil y funcional para diversos usos. Su factor de forma micro-ATX la hace adecuada tanto para gabinetes compactos como medianos, facilitando montajes más económicos o portables.','PLACB760M',18,18,900.00,890.00,2,5,'1764714342_692f676638242.png',1,0,1,'2025-12-02 22:25:42','2025-12-02 22:25:42',NULL),(199,'PLACA MADRE GIGABYTE B760M DS3H DDR4 LGA 1700','La Gigabyte B760M DS3H DDR4 es una placa madre micro-ATX con socket LGA 1700 diseñada para procesadores Intel de 12.ª y 13.ª generación, ideal para construir una PC funcional, moderna y relativamente económica. Al usar memorias DDR4 en configuración de cuatro ranuras DIMM con soporte dual-channel, ofrece compatibilidad y buen rendimiento en multitarea, ofimática, trabajo diario o gaming moderado. Cuenta con ranuras PCIe 4.0 y dos conectores M.2 para SSD NVMe, lo que permite un almacenamiento veloz y óptimo aprovechamiento de GPU dedicada sin cuellos de botella. Su red integrada 2.5 GbE y puertos modernos (como USB-C, USB 3.x, salidas de video cuando el CPU tenga gráficos integrados) ofrecen conectividad suficiente para internet, periféricos y accesorios actuales. Su diseño de energía — VRM híbrido de 6+2+1 fases — aporta estabilidad al sistema aun con procesadores potentes.','PLACDS3H',18,24,490.00,480.00,2,5,'1764714975_692f69dfceb1b.jpg',1,0,1,'2025-12-02 22:36:15','2025-12-02 22:36:15',NULL),(200,'PLACA MADRE ASUS PRIME B550M-A AC, WI-FI, AM4 AMD','a PRIME B550M-A AC es una placa madre micro-ATX con socket AM4 y chipset B550 diseñada para sistemas con procesadores AMD Ryzen compatibles. Su arquitectura ofrece buen soporte a RAM DDR4 rápida, ranuras PCIe modernas, almacenamiento SSD veloz mediante M.2, conectividad actual con Wi-Fi integrado y un conjunto de conexiones/puertos suficiente para una PC versátil. La placa incluye disipadores en zonas críticas para mantener temperaturas adecuadas, lo que favorece estabilidad incluso bajo uso prolongado, y ofrece funciones de audio, red, y expansión suficientes para montar una máquina equilibrada sin complicaciones. Su formato compacto la hace ideal para PCs de tamaño reducido o medianas, sin sacrificar compatibilidad ni funcionalidad.','PLACB505M-AC',18,10,410.00,400.00,2,5,'1764715546_692f6c1a5e625.jpg',1,0,1,'2025-12-02 22:45:46','2025-12-02 22:45:46',NULL),(201,'PLACA MADRE ASUS ROG STRIX B550-F GAMING WIFI II AM4 AMD','La ROG STRIX B550-F GAMING WIFI II es una placa madre ATX para socket Socket AM4, pensada para procesadores AMD Ryzen de las series compatibles, que combina potencia, compatibilidad y conectividad moderna para un PC completo. Su soporte para memorias DDR4 — con hasta 128 GB — permite que el sistema tenga buena capacidad y fluidez en multitarea, edición, trabajo intensivo o gaming. Al incluir soporte para PCIe 4.0, ranuras M.2 para SSD NVMe y múltiples puertos de expansión, permite montar discos rápidos y tarjetas gráficas modernas sin cuellos de botella, maximizando rendimiento general. Su red integrada con Wi-Fi 6E y LAN 2.5 Gb garantiza conexión estable y rápida, útil para juegos online, streaming o trabajo en red. Además, su sistema de alimentación robusto (12+2 fases) y diseño orientado a estabilidad aseguran que la placa maneje bien CPUs exigentes, manteniendo rendimiento sostenido.','PLACB550-FWS',18,10,770.00,760.00,2,5,'1764716346_692f6f3a01c33.jpg',1,0,1,'2025-12-02 22:59:06','2025-12-02 22:59:06',NULL),(202,'PLACA MADRE ASUS PRIME PRIME A520M-K AM4 AMD','La PRIME A520M-K es una placa madre micro-ATX pensada para armar una PC AMD económica o de gama media con procesadores AMD Ryzen compatibles con socket AM4. Trabaja con memoria DDR4, permitiendo hasta 64 GB en formato dual-channel con buenas velocidades, lo que da una base razonable para multitarea, trabajo, edición ligera, navegación o gaming modesto. Integra soporte para almacenamiento moderno mediante una ranura M.2 y puertos SATA, lo que facilita usar SSDs rápidos o discos tradicionales. Su ranura PCIe x16 permite instalar una tarjeta gráfica dedicada si buscas rendimiento en videojuegos o tareas gráficas. Dispone de salidas de video (HDMI y VGA) útiles si usas un APU con gráficos integrados, USB modernos y audio integrado, garantizando compatibilidad con periféricos, monitores y hardware común sin complicaciones.','PLAC520M',18,10,240.00,230.00,2,5,'1764718109_692f761de1532.png',1,0,1,'2025-12-02 23:28:29','2025-12-02 23:28:29',NULL),(203,'PLACA MADRE MSI PRO B760M-E DDR4 2MODULOS','La MSI PRO B760M-E DDR4 es una placa madre micro-ATX de socket LGA 1700, pensada para procesadores Intel actuales de 12.ª, 13.ª y 14.ª generación, así como CPUs más económicos. Su diseño utiliza memoria DDR4 con dos ranuras DIMM, lo que garantiza compatibilidad con RAM común, estabilidad en dual-channel y facilidad de configuración — ideal para construir una PC sin complicaciones con componentes accesibles.\r\n\r\nOfrece expansión suficiente para una PC moderna: ranura PCIe x16 para una tarjeta gráfica dedicada y ranura PCIe x1 extra para otros componentes; ranura M.2 PCIe 4.0 para SSDs rápidos y múltiples puertos SATA para discos o unidades adicionales. Esto permite combinar buena potencia gráfica con almacenamiento veloz y gran capacidad.\r\n\r\nLas salidas de video HDMI/VGA permiten usar el sistema con monitores si se emplea un CPU con gráficos integrados. La placa incluye soporte para audio de alta definición y red LAN, ofreciendo lo necesario para un equipo funcional, ya sea para trabajo, estudio, oficina, multimedia o gaming/moderado rendimiento, sin gastar en características premium.','PLACB760M-EDDR4',18,18,315.00,305.00,2,5,'1764718640_692f7830efaa3.png',1,0,1,'2025-12-02 23:37:20','2025-12-02 23:37:20',NULL),(204,'PLACA MSI PRO B760M-P DDR5 LGA 1700','La MSI PRO B760M-P DDR5 es una placa madre micro-ATX con socket LGA 1700 y chipset Intel B760, pensada para montar PCs con procesadores Intel recientes. Admite memoria DDR5 con cuatro ranuras DIMM, lo que permite usar RAM rápida y abundante, trayendo fluidez al sistema incluso en tareas exigentes. Dispone de ranura PCIe 4.0 x16 para tarjeta gráfica dedicada y ranuras M.2 PCIe 4.0 (Gen4 x4) para unidades NVMe ultrarrápidas, garantizando velocidad en gráficos y almacenamiento. Ofrece conectividad moderna: varios puertos USB incluyendo USB-C, además de salidas de video (HDMI, DisplayPort, VGA — si el CPU lo permite), soporte de audio HD y red LAN de calidad. Su formato micro-ATX la hace versátil y adecuada para gabinetes compactos o medianos, manteniendo compatibilidad con hardware actual sin gastar tanto como una placa de gama alta.','PLACAB760M-PDDR5',18,18,369.00,359.00,2,5,'1764719214_692f7a6ee3f61.png',1,0,1,'2025-12-02 23:46:54','2025-12-02 23:46:54',NULL),(205,'MAINBOARD ASUS PRIME B760-PLUS, DDR5, LGA 1700','La ASUS Prime B760-PLUS es una placa madre ATX con socket LGA 1700 diseñada para procesadores Intel recientes (12.ª, 13.ª y compatibles). Su compatibilidad con memoria DDR5 permite usar RAM rápida y moderna, lo que aporta agilidad y fluidez al sistema. Integra ranura PCIe 5.0 para GPU, varias ranuras M.2 para SSD NVMe de alta velocidad y múltiples puertos SATA, lo que permite montar un equipo con almacenamiento veloz y expansión cómoda. Tiene red integrada de 2.5 Gb, buena conectividad de puertos (USB-C, USB modernos, salidas de video si el CPU lo permite), lo que permite conectarse sin limitaciones a periféricos y redes modernas. Su diseño está orientado a ofrecer un equilibrio entre compatibilidad, rendimiento, modernidad y funcionalidad','PLACA871W',18,10,710.00,700.00,2,5,'1764719625_692f7c0999676.png',1,0,1,'2025-12-02 23:53:45','2025-12-02 23:53:45',NULL),(206,'PLACA ROG GAMING X MONSTER H61M DDR3','La \"placa rog gaming x monster h61m ddr3\" es una tarjeta madre con chipset Intel H61 y zócalo LGA 1155, diseñada para procesadores Intel de 2ª y 3ª generación. Es compatible con memoria RAM DDR3, soporta un máximo de 16 GB y ofrece ranuras de expansión PCI Express, además de puertos SATA y M.2 para almacenamiento.','PLACH61MD3',18,10,150.00,140.00,2,5,'1764720896_692f81009142a.png',1,0,1,'2025-12-03 00:14:56','2025-12-03 00:14:56',NULL),(207,'PLACA ROG GAMING X MONSTER H81M DDR3 M.2 MICRO','ROG GAMING X MONSTER H81M DDR3 M.2 MICRO se refiere a una placa de formato Micro-ATX con chipset H81 que soporta procesadores Intel de 4ª y 5ª generación (socket LGA 1150) y memoria DDR3. Ofrece conectividad M.2, 4 puertos SATA, 2 ranuras DIMM, un puerto PCIe x16 y salidas de video como HDMI y D-SUB.','PLACH18LM',18,10,155.00,145.00,2,5,'1764721255_692f82673a2c6.png',1,0,1,'2025-12-03 00:20:55','2025-12-03 00:20:55',NULL),(208,'DISCO SOLIDO ADATA, LEGEND 860, 500GB, M.2 NVME PCIE 4.0','El LEGEND 860 es un disco sólido (SSD) de formato M.2 2280 que usa la interfaz moderna PCIe 4.0 x4 con protocolo NVMe, lo que le permite comunicarse con la placa madre mucho más rápido que un disco duro tradicional o un SSD SATA. Su memoria interna es 3D NAND y está diseñado para ofrecer velocidades de lectura secuencial de hasta 5000 MB/s y escritura hasta 3000 MB/s en su versión de 500 GB, con una durabilidad razonable medida en “TBW” para ciclos de escritura — lo que lo convierte en una opción eficiente para sistemas operativos, juegos, programas y trabajo intensivo. Este SSD aprovecha tecnologías modernas de control de errores (ECC / LDPC) y cachés inteligentes (SLC Caching) para mantener estabilidad y velocidad cuando estés escribiendo o leyendo datos intensamente.','DISC860',13,30,210.00,200.00,2,5,'1764787822_6930866ee9f55.png',1,1,1,'2025-12-03 18:50:22','2025-12-15 19:35:57',NULL),(209,'UNIDAD SSD M.2 LEGEND 970 PRO PCIe GEN5 1TB 14,000MB/s','El ADATA LEGEND 970 PRO es un SSD M.2 NVMe de última generación que utiliza la interfaz PCIe 5.0, diseñada para ofrecer velocidades extremas de hasta 14,000 MB/s, lo que lo coloca entre los discos más rápidos del mercado. Su arquitectura interna emplea controladores avanzados y memoria 3D NAND de alta durabilidad, capaz de sostener escrituras continuas sin perder estabilidad térmica gracias a un disipador con diseño activo que mantiene la temperatura bajo control incluso en tareas pesadas. Este modelo está construido para cargas de trabajo profesionales, gaming de alto nivel y sistemas que requieren respuesta instantánea en lectura y escritura, ofreciendo un rendimiento que supera ampliamente a los SSD PCIe 4.0 tradicionales.','DISC970',13,30,670.00,660.00,2,5,'1764788531_6930893312b0b.jpg',1,0,1,'2025-12-03 19:02:11','2025-12-03 19:02:11',NULL),(210,'DISCO SOLIDO SSD 1TB M.2 ADATA, LEGEND 860 GEN 4X4','El LEGEND 860 es un disco de estado sólido tipo M.2 2280 que usa la interfaz moderna PCIe Gen4 x4 con protocolo NVMe, lo que le permite a tu PC comunicarse con el almacenamiento a muy alta velocidad. Su memoria es 3D NAND, con soporte para tecnologías de corrección de errores (LDPC) y caché inteligente (SLC Caching), lo que ayuda a mantener rendimiento y estabilidad aún con uso intensivo. Este SSD ofrece velocidades secuenciales de lectura de hasta ~ 6000 MB/s y escritura hasta ~ 5000 MB/s en su versión de 1 TB — bastante superiores a las de un HDD tradicional o un SSD SATA.','DISC860G',13,30,310.00,300.00,2,5,'1764789222_69308be672fbf.png',1,1,1,'2025-12-03 19:13:42','2025-12-15 19:35:59',NULL),(211,'SSD M.2 NVMe SAMSUNG 990 EVO PLUS 1TB 7150MBPS','El 990 EVO Plus es un SSD en formato M.2 2280 con interfaz NVMe y soporte PCIe 4.0 x4 (compatible también con PCIe 5.0 x2), lo que le permite ofrecer velocidades de lectura secuencial de hasta ~ 7.150 MB/s y escritura de hasta ~ 6.300 MB/s en su versión de 1 TB. Usa memoria flash V-NAND TLC de Samsung, con controladora propia, y no depende de caché DRAM dedicada sino del mecanismo HMB (Host Memory Buffer), lo que mantiene su eficiencia y le permite ofrecer un excelente equilibrio entre velocidad, confiabilidad y durabilidad. Su factor de forma compacto (M.2 2280) facilita la instalación en casi cualquier PC moderna sin ocupar espacio extra, y gracias a NVMe + PCIe 4.0, maximiza el potencial del almacenamiento, lo que lo hace ideal como unidad principal (sistema operativo, programas, juegos) o almacenamiento rápido para edición, diseño, proyectos grandes, etc.','DIS990EVO',13,31,410.00,399.00,2,5,'1764789956_69308ec4b90bf.jpg',1,0,1,'2025-12-03 19:25:56','2025-12-03 19:25:56',NULL),(212,'DISCO SOLIDO SSD 1TB M.2 ADATA, LEGEND 900 NVME','El Legend 900 es un SSD interno en formato M.2 2280 que utiliza interfaz PCIe Gen4 x4 con protocolo NVMe 1.4, lo que le permite transferir datos mucho más rápido que un disco duro o un SSD SATA. Sus memorias 3D NAND, con soporte de caché tipo SLC y corrección de errores (ECC/LDPC), buscan asegurar estabilidad, rapidez y durabilidad aun bajo cargas intensas o uso prolongado. El Legend 900 entrega velocidades secuenciales de lectura de hasta ~ 7000 MB/s y escritura de hasta ~ 5400 MB/s, lo que lo coloca en un nivel superior de rendimiento respecto a SSD más antiguos — ideal para aprovechar PCs modernas, juegos, edición, multitarea, carga rápida de sistemas y programas.','DISC900N',13,30,330.00,320.00,2,5,'1764790433_693090a16c3e5.png',1,1,1,'2025-12-03 19:33:53','2025-12-15 19:36:00',NULL),(213,'DISCO SSD M.2 PCIe 1TB KINGSTON NV3 PCI4 6000mb/s','El Kingston NV3 es un SSD interno en formato M.2 2280 que usa interfaz PCIe 4.0 x4 con protocolo NVMe, lo que le permite transferir datos muchísimo más rápido que un disco duro tradicional y con mejor eficiencia que un SSD SATA. u memoria es 3D NAND, con buenas especificaciones en cuanto a durabilidad (hasta ~320 TBW en la versión de 1 TB) y un diseño pensado para un equilibrio entre desempeño, consumo y eficiencia. Con velocidades secuenciales de lectura de hasta ~ 6000 MB/s y escritura de ~ 4000–5000 MB/s (dependiendo del tamaño y condiciones), el NV3 se ubica en una gama media-alta de SSD NVMe, suficiente para sistemas modernos que buscan rapidez y fluidez en el uso cotidiano, gaming, edición, o manejo de datos pesados.','DISCNV3600',13,23,400.00,390.00,2,5,'1764791231_693093bfd8b6f.jpg',1,0,1,'2025-12-03 19:47:11','2025-12-03 19:47:11',NULL),(214,'DISCO SSD M.2 PCIe 500GB KINGSTON NV3 PCI4','El Kingston NV3 es un SSD interno en formato M.2 2280 que usa la interfaz PCIe 4.0 ×4 con protocolo NVMe, lo que lo posiciona como una solución moderna de almacenamiento que va mucho más allá de un disco duro tradicional: ofrece velocidades de lectura secuencial de hasta ~ 5 000 MB/s y escritura hasta ~ 3 000 MB/s en su versión de 500 GB. Tiene memoria 3D NAND, lo que — en combinación con su controlador NVMe Gen 4x4 — le permite ofrecer buen rendimiento con eficiencia energética, baja generación de calor y una vida útil decente, medida en terabytes escritos (TBW). Su factor de forma compacto (M.2 2280) lo hace ideal para PCs de escritorio o portátiles con ranura M.2, ocupando poco espacio y simplificando la instalación sin cables adicionales.','DISC500GB',13,23,220.00,210.00,2,5,'1764791825_6930961104c6d.jpg',1,0,1,'2025-12-03 19:57:05','2025-12-03 19:57:05',NULL),(215,'DISCO SOLIDO SSD 512GB M.2 ADATA LEGEND 710 PCIE GEN3','El LEGEND 710 es un SSD tipo M.2 2280 que utiliza la interfaz PCIe Gen3 x4 y protocolo NVMe, con memoria 3D NAND, pensado para ofrecer un salto de rendimiento respecto a discos duros tradicionales o SSD SATA. Su rendimiento máximo declarado ronda los ~2400 MB/s en lectura y ~1800 MB/s en escritura secuencial — lo que significa que el acceso a archivos, arranque del sistema operativo, carga de programas o juegos puede ser mucho más rápido que con discos convencionales. Está diseñado con un disipador liviano para ayudar a mantener temperaturas moderadas, lo que contribuye a su estabilidad y durabilidad. El formato M.2 lo hace compacto y fácil de instalar en placas madre modernas con ranura M.2, sin necesidad de cables extra, lo que simplifica la instalación y mantiene el interior del gabinete limpio.','DISC512GB',13,30,210.00,200.00,2,5,'1764792633_69309939c2bce.jpg',1,0,1,'2025-12-03 20:10:33','2025-12-03 20:10:33',NULL),(216,'DISCO DURO SSD CRUCIAL T710 2TB PCIE GEN5 NVME 2280 M.2','El Crucial T710 es un SSD M.2 NVMe de última generación con interfaz PCIe 5.0 y factor de forma 2280, pensado para ofrecer velocidades extremas de lectura y escritura. Sus valores máximos alcanzan hasta ≈ 14 900 MB/s de lectura y ≈ 13 800 MB/s de escritura, gracias a su controlador moderno, memoria NAND de alta densidad y tecnología optimizada. Este SSD no solo ofrece velocidad sino también durabilidad: tiene una alta resistencia al desgaste (medida en TBW – terabytes escritos), soporte de cifrado (AES-256 con TCG Opal 2.01+) y firmware optimizado para tecnologías actuales como DirectStorage, lo que lo hace apto tanto para gaming de última generación como para edición, renderizado, diseño o trabajo profesional.','DISCT710',13,32,670.00,660.00,2,5,'1764793236_69309b947b76f.png',1,1,1,'2025-12-03 20:20:36','2025-12-15 19:35:56',NULL),(217,'DISCO SOLIDO SSD 2TB M.2 ADATA LEGEND 900 PRO NVME','El LEGEND 900 PRO es un SSD de última generación en formato M.2 2280 que usa interfaz PCIe 4.0 x4 con protocolo NVMe. Su memoria es 3D NAND con tecnologías de caché (SLC caching) y corrección de errores (ECC / LDPC), lo que le permite mantener velocidades sostenidas y confiabilidad con el paso del tiempo. Sus velocidades secuenciales son de hasta ≈ 7,400 MB/s en lectura y ≈ 6,500 MB/s en escritura, lo que lo ubica entre los SSD más rápidos de su categoría. Esa potencia se traduce en capacidad de respuesta, carga rápida, transferencias veloces y fluidez notoria en tareas intensivas. Además, su capacidad de 2 TB te brinda un amplio espacio para sistema operativo, programas, juegos, multimedia o proyectos pesados — ideal si no quieres preocuparte por quedar sin espacio pronto.','DISC9002TB',13,30,510.00,500.00,2,5,'1764793686_69309d5644b30.jpg',1,0,1,'2025-12-03 20:28:06','2025-12-03 20:28:06',NULL),(218,'DISCO SSD M.2 PCIe 2TB FURY RENEGADE G5 14200mb/S','El Kingston FURY Renegade G5 es un SSD de última generación con interfaz PCIe 5.0 x4 y formato M.2 2280, pensado para quienes buscan velocidades extremas y gran capacidad. Su memoria flash 3D TLC, combinada con controlador moderno, le permite alcanzar velocidades de lectura de hasta ~ 14 700 MB/s y de escritura de hasta ~ 14 000 MB/s en su versión de 2 TB, cifras que lo sitúan entre los SSD más rápidos disponibles actualmente. Además de la velocidad, ofrece un rendimiento consistente incluso bajo carga intensa, con soporte para altas tasas de operaciones por segundo (IOPS), buena resistencia a desgaste (alto TBW), y compatibilidad con protocolos modernos como NVMe + PCIe 5.0 — lo que lo hace ideal para gaming, edición de video/fotos, diseño 3D, renderizado, software pesado o simplemente fluidez máxima en todo tipo de tareas.','DISCG5142',13,23,940.00,930.00,2,5,'1764794176_69309f4091de5.jpg',1,0,1,'2025-12-03 20:36:16','2025-12-03 20:36:16',NULL),(219,'DISCO SSD M.2 PCIe 1TB FURY RENEGADE G5 14200mb/S','Este SSD es una unidad de estado sólido M.2 con interfaz NVMe PCIe 5.0 x4, una de las tecnologías más avanzadas actualmente para almacenamiento. Ofrece velocidades de lectura y escritura extremadamente altas — ideales para reducir al mínimo los tiempos de espera en carga de sistema, programas o juegos. Su memoria 3D TLC y controlador moderno (SM2508) están optimizados para mantener un rendimiento alto incluso bajo uso intensivo, manejando grandes transferencias de datos, instalación de software pesado, edición, render o multitarea sin cuellos de botella.','DISCG51420',13,23,630.00,620.00,2,5,'1764794622_6930a0feaac71.jpeg',1,0,1,'2025-12-03 20:43:42','2025-12-03 20:43:42',NULL),(220,'SSD M.2 NVMe LEXAR NM790 2TB 7400MBPS GEN4 AST','El Lexar NM790 es un SSD moderno en formato M.2 2280 con interfaz PCIe Gen4×4 y protocolo NVMe, pensado para ofrecer almacenamiento ultrarrápido con velocidades de lectura de hasta ~ 7400 MB/s y escritura de hasta ~ 6500 MB/s. Utiliza memoria 3D TLC y un controlador eficiente (sin DRAM dedicada — usa HMB 3.0 + caché SLC dinámica para mantener un buen rendimiento) lo que le permite equilibrar velocidad, eficiencia energética y costo. Está diseñado para ofrecer un rendimiento muy alto en tareas intensivas, carga rápida de datos, instalación veloz de programas/juegos, y tiempos de respuesta mínimos en general.Además su formato M.2 lo hace compacto y fácil de instalar en placas madre modernas con ranura NVMe, sin necesidad de cables de datos o alimentación aparte.','DISC7400MBPS',13,33,610.00,600.00,2,5,'1764795354_6930a3da6ec94.jpg',1,0,1,'2025-12-03 20:55:54','2025-12-03 20:57:18',NULL),(221,'SSD M.2 NVMe CORSAIR MP700 ELITE 1TB 10000MBPS GEN5','El MP700 Elite es un SSD de nueva generación que usa interfaz PCIe 5.0 x4 + NVMe 2.0 en formato M.2 2280, lo que lo pone en la vanguardia del almacenamiento, Su diseño prioriza velocidad extrema: ofrece hasta 10 000 MB/s de lectura secuencial y 8 500 MB/s de escritura según especificaciones oficiales. Usa memoria 3D TLC NAND con controlador moderno, lo que le permite un balance entre rendimiento, durabilidad y eficiencia energética.','DISCMP700M',13,17,560.00,550.00,2,5,'1764795920_6930a61091320.jpg',1,0,1,'2025-12-03 21:05:20','2025-12-03 21:05:20',NULL),(222,'DISCO SSD 2.5 T-FORCE VULCAN Z 2TB','El Vulcan Z 2TB es un disco de estado sólido (SSD) en formato tradicional 2.5″ con interfaz SATA III. Utiliza memoria 3D NAND (normalmente TLC), lo que le da una vida útil aceptable en comparación a discos mecánicos. Su velocidad de lectura secuencial ronda los ~ 550 MB/s y escritura alrededor de ~ 500 MB/s. No usa interfaz NVMe ni PCIe — por lo que no alcanza las velocidades extremas de los SSD M.2 modernos — pero ofrece un salto grande respecto a un disco duro clásico: tiempos de arranque, carga de programas o sistema operativo, y apertura de archivos serán visiblemente más rápidos. La unidad es resistente a golpes y vibraciones (mejor que un HDD mecánico), con menor consumo y ruido, lo que mejora la confiabilidad y comodidad del sistema.','DISCZ2TB',13,34,430.00,420.00,2,5,'1764796670_6930a8feaad22.jpg',1,0,1,'2025-12-03 21:17:50','2025-12-03 21:17:50',NULL),(223,'UNIDAD SSD M.2 1TB SAMSUNG 9100 PRO 14700 MB/S GEN 5','El Samsung 9100 PRO es un SSD de muy alto rendimiento en formato M.2 2280 que usa la interfaz PCIe 5.0 x4 con protocolo NVMe 2.0, lo que lo posiciona en la punta de la tecnología de almacenamiento. Este modelo es capaz de alcanzar velocidades secuenciales de lectura muy altas — hasta ~ 14 800 MB/s — y de escritura de ~ 13 400 MB/s en condiciones óptimas. Su arquitectura incluye memoria NAND de última generación, controlador avanzado y soporte de NVMe, lo que le permite manejar tanto transferencias grandes como cargas intensivas de datos: ideal para juegos pesados, edición de video, renderizado, proyectos multimedia, trabajo profesional o cargas exigentes.','DISC9100P',13,31,610.00,600.00,2,5,'1764797347_6930aba384c5f.jpg',1,0,1,'2025-12-03 21:29:07','2025-12-03 21:29:07',NULL),(224,'SSD MSI SPATIUM M560, 1TB M.2 PCIe 5.0 NVMe','El MSI SPATIUM M560 es un SSD de última generación en formato M.2 2280 con interfaz PCIe 5.0 x4 y protocolo NVMe 2.0, diseñado para ofrecer almacenamiento ultrarrápido con memorias 3D NAND. Este SSD logra velocidades secuenciales de lectura muy elevadas — hasta ~10 200 MB/s — y escritura alrededor de ~8 400 MB/s, lo que representa un salto importante respecto a SSD más antiguos o discos duros, Internamente, utiliza un controlador moderno, soporta correcciones de errores (ECC / LDPC), funciones de mantenimiento de salud (SMART, TRIM) y ofrece buena durabilidad (alto TBW / MTBF), atributos que buscan equilibrio entre rendimiento, confiabilidad y longevidad.','DISC50NV',13,18,455.00,445.00,2,5,'1764797817_6930ad7995d7e.jpg',1,0,1,'2025-12-03 21:36:57','2025-12-03 21:36:57',NULL),(225,'DISCO SOLIDO SSD 500GB ROG GAMING X M.2 NVME PCIE','Un SSD M.2 NVMe de 500 GB \"ROG GAMING X\" es un disco de estado sólido de alto rendimiento, optimizado para juegos, con interfaz NVMe y conector M.2, que ofrece velocidades de transferencia rápidas para un sistema más ágil y tiempos de carga más cortos. Su capacidad de 500 GB proporciona espacio para juegos y archivos, mientras que sus características como la tecnología de refrigeración y la durabilidad lo hacen ideal para PC de alto rendimiento y portátiles gaming.','DISCXM2500',13,10,190.00,180.00,2,5,'1764798322_6930af720d7c2.jpg',1,0,1,'2025-12-03 21:45:22','2025-12-03 21:45:22',NULL),(226,'DISCO SOLIDO SSD 2TB M.2 ADATA LEGEND 860 NVME/ 6000/MB','El Legend 860 es un SSD en formato M.2 2280 que emplea la interfaz moderna PCIe 4.0 x4 + NVMe — lo que le permite un ancho de banda muy superior al de discos tradicionales o SSD SATA, Con sus memorias 3D NAND y controlador optimizado, está diseñado para ofrecer un equilibrio entre velocidad, capacidad y durabilidad: en su versión de 2 TB da suficiente espacio para sistema operativo, programas, juegos y archivos pesados sin preocuparte por quedarte corto. La velocidad declarada de lectura secuencial de hasta ~ 6000 MB/s (y escritura hasta ~ 5000 MB/s) coloca a esta unidad en un rango de rendimiento alto/moderno, ideal para que el almacenamiento no sea un cuello de botella.','DISC860M2',13,30,510.00,500.00,2,5,'1764798939_6930b1db12053.jpg',1,0,1,'2025-12-03 21:55:39','2025-12-03 21:55:39',NULL),(227,'SSD KINGSTON A400 480GB SATA 2.5\"','El A400 es un SSD de formato tradicional de 2.5\" con interfaz SATA III, diseñado como una mejora directa frente a un disco duro mecánico, Este SSD utiliza memoria NAND 3D y ofrece velocidades de lectura de hasta ~500 MB/s y escritura hasta ~450 MB/s en su versión de 480 GB, lo que resulta un importante salto en velocidad comparado con discos duros antiguos. Al no tener partes móviles, su funcionamiento es más silencioso, resistente a golpes o vibraciones, consume poca energía y genera menos calor — lo que le da durabilidad, confiabilidad y estabilidad para uso diario, tanto en laptops como PCs de escritorio.','DISC480GB',13,23,175.00,165.00,2,5,'1764799403_6930b3ab90250.jpg',1,0,1,'2025-12-03 22:03:23','2025-12-03 22:03:23',NULL),(228,'SSD M.2 NVMe SAMSUNG 990 PRO 2TB 7450MBPS GEN4 AST','El 990 PRO 2 TB es un SSD interno de alto rendimiento que usa la interfaz PCIe 4.0 x4 + NVMe 2.0 en formato M.2 2280. Gracias a su diseño con memoria V-NAND y controlador propietario, ofrece velocidades secuenciales de lectura de hasta ≈ 7 450 MB/s y escritura hasta ≈ 6 900 MB/s, lo que lo coloca entre los SSD más rápidos disponibles actualmente para PCs, Estos datos implican que el flujo de información entre almacenamiento, memoria y CPU/pila interna del equipo será extremadamente fluido, minimizando demoras y pérdidas de rendimiento por “cuellos de botella” en disco. El formato M.2 hace que el SSD sea compacto y fácil de instalar directamente en la placa madre, sin cables de datos ni alimentación extra — lo que ayuda a mantener el interior del gabinete ordenado y simplifica el ensamblado, Además, la versión de 2 TB te ofrece un espacio generoso para sistema operativo, programas, juegos, edición, multimedia o proyectos, eliminando con holgura la necesidad de discos adicionales si buscas capacidad + rapidez.','DISC9902TBS',13,31,800.00,789.00,2,5,'1764800364_6930b76c15611.jpg',1,0,1,'2025-12-03 22:19:24','2025-12-03 22:19:24',NULL),(229,'MEMORIA RAM SODIMM ADATA DDR5 8GB 5600MHZ','La memoria representa un módulo moderno de RAM en formato SODIMM — pensado para laptops, mini-PCs o equipos compactos — que emplea la tecnología DDR5. Con una velocidad de 5600 MHz, ofrece un ancho de banda alto para el sistema, lo que significa que los datos viajan más rápido entre RAM y CPU, favoreciendo fluidez, tiempos de respuesta cortos y buen desempeño general. Opera con bajo voltaje (1.1 V) y tiene latencias ajustadas para su clase (CL46 según ficha técnica), lo que contribuye a un funcionamiento eficiente y estable, Su formato compacto (SODIMM, 262 pines) la hace ideal para portátiles o PCs compactas, donde el espacio es limitado — permitiendo actualizar RAM sin complicaciones físicas.','MEM5600DDR',11,30,170.00,400.00,2,5,'1764801031_6930ba076ed0d.png',1,0,1,'2025-12-03 22:30:31','2025-12-26 13:53:42',NULL),(230,'MEMORIA 32GB DDR5 XPG LANCER RGB BLADE BLACK','La XPG LANCER Blade RGB DDR5 es una memoria RAM de nueva generación — DDR5 — con capacidad de 32 GB (generalmente en kit 2×16 GB), diseñada para ofrecer un alto rendimiento, estabilidad y compatibilidad con PCs modernas. Su diseño incluye un disipador de perfil bajo que facilita su instalación incluso en gabinetes compactos, sin interferir con disipadores grandes de CPU, Opera a frecuencias altas (tipos entre 5600 MHz, 6000 MHz o más, dependiendo del modelo exacto), lo que permite que la comunicación entre RAM y CPU sea muy ágil — esto acelera tareas, reduce tiempos de espera y mejora el desempeño general. La memoria incorpora corrección de errores interna (On-die ECC) y gestión eficiente de energía, lo que añade estabilidad, fiabilidad y eficiencia energética comparada con generaciones anteriores','MEM32GBDDR',11,35,930.00,3000.00,2,5,'1764802889_6930c149d2243.png',1,0,1,'2025-12-03 23:01:29','2025-12-24 14:25:52',NULL),(231,'MEMORIA RAM XPG 8GB 3200MHZ DDR4 HEATSINK RGB','La XPG DDR4 3200 MHz 8 GB es un módulo de RAM de escritorio con interfaz DDR4, diseñado para ofrecer un buen equilibrio entre rendimiento, compatibilidad y costo. Su velocidad de 3200 MHz permite que la comunicación entre la memoria y el procesador sea más fluida y rápida, lo que se traduce en tiempos de respuesta ágil, mejora en carga de programas y generalmente en un sistema más receptivo. Este módulo incluye un disipador (“heatsink”) que ayuda a mantener temperaturas controladas cuando la RAM trabaja intensamente, lo que le da estabilidad incluso en sesiones largas o con carga alta, y suma confiabilidad al sistema. Además integra iluminación RGB — pensada para quienes quieren estética en su PC — lo que permite combinar rendimiento con un diseño atractivo.','MEM8GB3200',11,35,123.00,113.00,2,5,'1764803355_6930c31b264a9.png',1,0,1,'2025-12-03 23:09:15','2025-12-03 23:09:15',NULL),(232,'MEMORIA TEAMGROUP T-FORCE VULCAN DDR5 8GB DDR5-5200','La T-Force Vulcan DDR5 es una memoria RAM de nueva generación, DDR5, con frecuencia de 5200 MHz y latencias relativamente ajustadas, pensada para PCs modernas que buscan buen rendimiento sin gastar demasiado, Incluye un disipador metálico que ayuda a dispersar calor en uso prolongado, lo que incrementa la estabilidad cuando la memoria trabaja intensamente. Trae soporte para perfiles de memoria como Intel XMP 3.0 (y si la placa lo permite, perfiles compatibles con AMD), lo que facilita activar la velocidad deseada con un clic en BIOS sin ajustes manuales complicados. Internamente usa circuitos de administración de energía (PMIC) y soporte de corrección de errores “on-die ECC”, lo que mejora eficiencia, estabilidad y confiabilidad del sistema frente a errores de memoria, especialmente útil para cargas intensas o uso prolongado.','MEM5433MSA',11,34,160.00,2500.00,2,5,'1764804466_6930c772876ae.jpg',1,0,1,'2025-12-03 23:26:38','2025-12-26 13:51:08',NULL),(233,'CASE ASUS TUF GAMING GT302','El ASUS TUF Gaming GT502 es un gabinete de exhibición modular de doble cámara que admite hasta tres posiciones para radiadores.','CASE ASUS',21,10,1000.00,750.00,1,5,'1766513288_694ada882b4d9.png',1,0,1,'2025-12-23 18:08:08','2025-12-23 18:08:08',NULL),(234,'COOLER CASE GAMER VEKTOR AB201 ARGB 4FANS AIRBOOM','El Cooler Case Gamer Vektor AB201 ARGB 4FANS de Airboom es un kit de 4 ventiladores de 120mm para gabinetes de PC gaming, que ofrece una estética mejorada con iluminación ARGB personalizable en los ventiladores y un controlador para efectos, excelente flujo de aire (60CFM) para buena refrigeración, bajo ruido (2.1dB), fácil instalación y bajo consumo, ideal para renovar la estética y la temperatura de tu PC','AB201RGB',23,36,100.00,90.00,2,5,'1766515755_694ae42b9a419.jfif',1,0,1,'2025-12-23 18:49:15','2025-12-23 18:49:15',NULL),(235,'REFRIGERACION LIQUIDA ARC360 RGB GAMER AIRBOOM','La Refrigeración Líquida Airboom ARC360 RGB es un sistema de enfriamiento para PC gamer de 360mm con tres ventiladores ARGB de 120mm, que ofrece alto rendimiento térmico, bajo ruido y una estética personalizable con efectos de luz sincronizables, ideal para CPUs potentes, con amplia compatibilidad y fácil instalación, incluyendo pastas térmicas y radiador de alta disipación para setups exigentes.','ARC360RGB',23,36,260.00,250.00,2,5,'1766516189_694ae5dd9bfe8.jpeg',1,0,1,'2025-12-23 18:56:29','2025-12-23 18:56:29',NULL),(236,'COOLER LIQUIDA THERMALRIGHT WONDER VISION 360 UB ARGB','? Descripción – Cooler Líquida Thermalright Wonder Vision 360 UB ARGB\r\n\r\nLa Thermalright Wonder Vision 360 UB ARGB es una refrigeración líquida AIO (All-In-One) de alto rendimiento diseñada para PCs gamer y estaciones de trabajo exigentes. Cuenta con un radiador de 360 mm con triple ventilador PWM ARGB, una bomba potente y silenciosa y una gran pantalla curva ARGB de 6.67″ en el bloque de la bomba que permite mostrar estadísticas del sistema, imágenes o animaciones personalizadas. Su diseño combina eficiencia térmica avanzada con estética moderna y personalizable, ideal para mantener procesadores de alto rendimiento frescos incluso bajo cargas intensas.','REF36012',23,36,1000.00,990.00,2,5,'1766516837_694ae8658992c.png',1,0,1,'2025-12-23 19:07:17','2025-12-23 19:07:17',NULL),(237,'COOLER LIQUIDA COOLER MASTERLIQUID 360 CORE II','La Cooler Master MasterLiquid 360 Core II es una refrigeración líquida AIO para CPU con radiador de 360 mm diseñada para ofrecer alto rendimiento térmico y estética moderna en sistemas gaming y PCs de alto rendimiento. Cuenta con una bomba de doble cámara refrigerada por líquido, tuberías optimizadas para una instalación sencilla y tres ventiladores PWM de 120 mm con iluminación ARGB que ayudan a mantener temperaturas bajas incluso bajo cargas exigentes. Su diseño incluye detalles estéticos como un efecto espejo infinito en la bomba y soporte para una amplia gama de sockets Intel y AMD, lo que la hace una opción sólida para mejorar la refrigeración y la apariencia interior de tu equipo.','MAS360CO11',23,37,430.00,420.00,2,5,'1766517412_694aeaa44059d.png',1,0,1,'2025-12-23 19:16:52','2025-12-23 19:16:52',NULL),(238,'REFRIGERACION LIQUIDA DEEPCOOL LM360 ARGB WHITE','La Refrigeración Líquida DeepCool LM360 ARGB White es un sistema AIO de enfriamiento líquido para CPU con radiador de 360 mm y diseño blanco premium, pensada para mantener temperaturas bajas en procesadores potentes mientras ofrece una estética gamer con iluminación ARGB sincronizable; incluye tres ventiladores PWM ARGB de 120 mm de alto flujo de aire, una bomba de sexta generación con control PWM y tecnología Anti-Leak para mayor fiabilidad, y una pantalla IPS de 2.4″ en el bloque que puede mostrar temperaturas, GIFs o videos personalizados, compatible con los sockets modernos Intel (LGA 1851/1700/1200/115x) y AMD (AM5/AM4).','LM360ARG',23,19,460.00,450.00,2,5,'1766517782_694aec169e115.png',1,0,1,'2025-12-23 19:23:02','2025-12-23 19:23:02',NULL),(239,'REFRIGERACION LIQUIDA DEEPCOOL LE360 V2 ARGB','La DeepCool LE360 V2 ARGB es una refrigeración líquida AIO de 360 mm diseñada para PCs gamer y de alto rendimiento, que combina alto poder de disipación térmica con iluminación ARGB personalizable, permitiendo mantener el procesador a temperaturas estables incluso en cargas intensas, además de aportar una estética moderna y atractiva al interior del gabinete.','LE360V2',23,19,340.00,330.00,2,5,'1766518479_694aeecf3e917.jfif',1,0,1,'2025-12-23 19:34:39','2025-12-23 19:34:39',NULL),(240,'COOLER LIQUIDA COOLER MASTERLIQUID 360 CORE II','La Cooler Master MasterLiquid 360 Core II es una refrigeración líquida AIO para CPU con radiador de 360 mm y tres ventiladores ARGB, diseñada para ofrecer potente disipación térmica y una estética gamer llamativa, ideal para equipos de alto rendimiento y juegos exigentes.','MAST360XOR',23,37,430.00,420.00,2,5,'1766518770_694aeff2c68cf.jfif',1,0,1,'2025-12-23 19:39:30','2025-12-23 19:39:30',NULL),(241,'DISIPADOR TORRE MSI MAG COREFROZR AA13 ARGB','El disipador torre MSI MAG CoreFrozr AA13 ARGB es un cooler de aire para CPU con iluminación ARGB personalizable, diseñado para ofrecer refrigeración eficiente y estética gamer en una configuración de torre compacta, ideal para mantener procesadores modernos a temperaturas controladas mientras añade un toque visual llamativo al interior de tu PC.','MSIAA13RG',23,18,130.00,120.00,2,5,'1766519053_694af10d5c0b1.jfif',1,0,1,'2025-12-23 19:44:13','2025-12-23 19:44:13',NULL),(242,'REFRIGERACION LIQUIDA DEEPCOOL LS520 WHITE ARGB','La DeepCool LS520 White ARGB es una refrigeración líquida AIO para CPU con diseño blanco premium e iluminación ARGB, pensada para ofrecer eficiente disipación térmica y estética visual atractiva en PCs gamer y sistemas de alto rendimiento con soporte para múltiples efectos de luz sincronizados con la placa base.','PSCCDC520',23,19,360.00,350.00,2,5,'1766519613_694af33da5277.jfif',1,0,1,'2025-12-23 19:53:33','2025-12-23 19:53:33',NULL),(243,'COOLER DE PROCESADOR DEEPCOOL AK500 WHITE','El DeepCool AK500 White es un disipador de aire para CPU de alto rendimiento con diseño blanco elegante, ideal para PCs gamer y sistemas de alto rendimiento que buscan refrigeración eficiente y estética limpia, ofreciendo una solución sólida para mantener tu procesador a temperaturas controladas sin complicaciones.','PROAK500',23,19,280.00,270.00,2,5,'1766519993_694af4b9bc1e6.jpg',1,0,1,'2025-12-23 19:59:53','2025-12-23 19:59:53',NULL),(244,'MOUSE STRIKER WHITE CBX M601W 7200DPI CYBERTEL','El mouse Striker White CBX M601W 7200 DPI de Cybertel es un mouse gamer con cable USB en color blanco diseñado para brindar precisión y control en juegos y uso diario, con iluminación RGB dinámica, siete botones, agarre lateral cómodo y cable trenzado resistente, ideal para jugadores que buscan rendimiento y estilo en su setup.','M601WDPI',17,38,60.00,50.00,2,5,'1766520787_694af7d3ccfe1.jpg',1,0,1,'2025-12-23 20:13:07','2025-12-23 20:13:45',NULL),(245,'MOUSE GAMING WIRELESS ANTRYX SCORPIO 250, DPI 8000,','El Mouse Gaming Wireless Antryx Scorpio 250 es un mouse gamer inalámbrico versátil y ergonómico que permite conectarse por 2.4 GHz, Bluetooth v5.1 o cable USB, ideal para jugadores que buscan movilidad, precisión y comodidad sin sacrificar rendimiento.','ANT250YSX',17,25,140.00,130.00,2,5,'1766521234_694af99257a9b.jfif',1,0,1,'2025-12-23 20:20:34','2025-12-23 20:20:34',NULL),(246,'MOUSE KILLER - CBX M600 NEGRO','El Mouse Gamer Killer CBX M600 Negro de Cybertel es un mouse gamer con cable USB y retroiluminación RGB, diseñado para ofrecer precisión y control en juegos FPS, MOBA o MMO, con botones programables y un agarre cómodo, ideal para jugadores que buscan rendimiento y estilo en su setup.','KILLM600',17,38,60.00,50.00,2,5,'1766521479_694afa8727f6f.jfif',1,0,1,'2025-12-23 20:23:26','2025-12-23 20:24:39',NULL),(247,'MOUSE LOGITECH M90 1000 DPI USB NEGRO','El Mouse Logitech M90 1000 DPI USB Negro es un mouse con cable simple y confiable pensado para uso diario en oficina, estudio o navegación web, con un diseño ambidiestro cómodo y funcional que se conecta por USB y funciona al instante sin necesidad de software, ofreciendo control fluido y preciso gracias a su sensor óptico.','M90100DPI',17,11,40.00,30.00,2,5,'1766521681_694afb510e008.jpg',1,0,1,'2025-12-23 20:28:01','2025-12-23 20:28:01',NULL),(248,'MOUSE ENKORE PIVOT EKM105','El mouse Enkore Pivot EKM105 es un mouse óptico alámbrico sencillo y ergonómico con conexión USB plug & play, ideal para uso diario en oficina, estudio o navegación, que ofrece un movimiento suave y preciso en color negro con diseño cómodo para largas horas de trabajo.','EKM105',17,39,40.00,30.00,2,5,'1766522038_694afcb6c8dec.jfif',1,0,1,'2025-12-23 20:33:58','2025-12-23 20:33:58',NULL),(249,'MOUSE GAMER RAZER VIPER V2 PRO HYPERSPEED DPI 30K BLACK','El Mouse Gaming Razer Viper V2 Pro Hyperspeed 30K DPI Black es un mouse gamer inalámbrico ultraliviano (≈58 g) diseñado para jugadores competitivos, con conectividad inalámbrica Razer HyperSpeed o por cable Speedflex, ofreciendo precisión extrema, respuesta rápida y control preciso para esports y sesiones largas de juego sin retrasos.','V2PRO021',17,12,470.00,460.00,2,5,'1766522334_694afdde1bc09.jpg',1,0,1,'2025-12-23 20:38:54','2025-12-23 20:38:54',NULL),(250,'MOUSE GAMING LOGITECH G502 HERO BLACK 25K DPI','El Mouse Gaming Logitech G502 HERO Black 25K DPI es un mouse gamer con cable USB de alto rendimiento, diseñado para ofrecer precisión extrema, personalización avanzada y estética RGB LIGHTSYNC, ideal para jugadores competitivos y exigentes que necesitan control fino y múltiples funciones programables en sus partidas.','G50525KA',17,11,210.00,200.00,2,5,'1766522722_694aff62672d8.jpg',1,0,1,'2025-12-23 20:45:22','2025-12-23 20:45:22',NULL),(251,'MOUSE GAMER SCYROX V8 BLANCO 8K/30K','El Mouse Gamer Scyrox V8 Blanco 8K / 30K DPI es un mouse gamer inalámbrico ultraligero (~36 g) con diseño ergonómico pensado para jugadores que buscan precisión, velocidad y comodidad, ofreciendo un rendimiento competitivo tanto en juegos rápidos como en tareas diarias con un estilo minimalista sin iluminación RGB.','SCYROV8K',17,40,290.00,280.00,2,5,'1766523253_694b017535004.jfif',1,0,1,'2025-12-23 20:54:13','2025-12-23 20:54:13',NULL),(252,'MOUSE GAMER SCYROX V8 NEGRO 8K/30K DPI/36GR/PAW3950','El Mouse Gamer Scyrox V8 Negro 8K/30K DPI PAW3950 es un mouse gamer inalámbrico ultraligero (~36 g) diseñado para jugadores que buscan respuesta ultra rápida, precisión competitiva y control cómodo, con un diseño ambidiestro ideal para sesiones largas y rendimiento en eSports','SCYV8KDPI',17,40,290.00,280.00,2,5,'1766523528_694b0288533ef.jfif',1,0,1,'2025-12-23 20:58:48','2025-12-23 20:58:48',NULL),(253,'TECLADO LOGITECH PEBBLE 2 K380S WIRELESS/BLUETOOTH','El Teclado Logitech Pebble 2 K380S Wireless/Bluetooth es un teclado compacto, delgado y silencioso diseñado para uso diario tanto en oficina como en casa, que ofrece conectividad inalámbrica por Bluetooth y un diseño elegante, minimalista y portátil ideal para trabajar o estudiar con comodidad en múltiples dispositivos.','F108PRSA',22,11,130.00,120.00,2,5,'1766524067_694b04a374917.jfif',1,0,1,'2025-12-23 21:07:47','2025-12-23 21:07:47',NULL),(254,'TECLADO MACHENIKE K600T','El Teclado Gamer Machenike K600T es un teclado mecánico inalámbrico compacto (75% / 82 teclas) con retroiluminación RGB personalizable y diseño gamer ergonómico, ideal para jugadores y usuarios que buscan rendimiento y estilo; soporta múltiples modos de conexión (USB cableado, inalámbrico 2.4 GHz y Bluetooth) y permite personalizar la experiencia de uso con efectos de luz y funciones avanzadas.','K600T',22,42,270.00,260.00,2,5,'1766524599_694b06b771847.jpg',1,0,1,'2025-12-23 21:16:39','2025-12-23 21:16:39',NULL),(255,'TECLADO MACHENIKE K500-B61 SWITCH ROJO','El Teclado Machenike K500-B61 Switch Rojo es un teclado gamer mecánico con retroiluminación RGB y switches rojos lineales, diseñado para ofrecer una experiencia de escritura suave, rápida y silenciosa, ideal para jugadores y uso diario con estilo gamer.','K500B61',22,42,170.00,160.00,2,5,'1766525263_694b094f65b1b.jfif',1,0,1,'2025-12-23 21:27:43','2025-12-23 21:27:43',NULL),(256,'TECLADO CORSAIR K63 LED AZUL SWITCH CHERRY MX RED MECANICO WIRELESS/BLUETOOTH (PN:90MP0317-BKAA01)','El Teclado Corsair K63 LED Azul (Switch Cherry MX Red) Mecánico Wireless/Bluetooth (PN: 90MP0317-BKAA-01) es un teclado mecánico compacto y versátil especialmente diseñado para gamers y usuarios exigentes, que combina interruptores Cherry MX Red de acción lineal suave con conectividad inalámbrica y Bluetooth, iluminación LED azul y construcción sólida, ofreciendo una experiencia de escritura y juego precisa, cómoda y sin cables.','K63LD12',22,17,270.00,260.00,2,5,'1766525770_694b0b4aeb252.jpg',1,0,1,'2025-12-23 21:36:10','2025-12-23 21:36:10',NULL),(257,'TECLADO ENKORE PATRIOT ENK 1013 RAINBOW MECANICO CONEXION WIRED USB','El Teclado Enkore Patriot ENK-1013 Rainbow Mecánico es un teclado gamer mecánico con iluminación RGB tipo arcoíris y conexión USB cableada, diseñado para ofrecer respuestas rápidas, durabilidad y estilo gamer vibrante, ideal para jugadores y usuarios que buscan precisión y estética llamativa en su setup.','ENK1013AS',22,39,67.00,62.00,2,5,'1766526033_694b0c5108f90.jpg',1,0,1,'2025-12-23 21:40:33','2025-12-23 21:40:33',NULL),(258,'KIT ANTRYX GC-3100 BLACK RGB TECLADO MECANICO SWITCH RED USB + MOUSE WIRED USB (PN:AGC-3100KRE-SP)','El Kit Antryx GC-3100 Black RGB combina un teclado mecánico con switches rojos y un mouse USB cableado, ambos con iluminación RGB, ofreciendo una experiencia gamer completa, cómoda y visualmente atractiva para jugadores que buscan rendimiento y estilo en un pack accesible.','GC3100RGB',22,25,140.00,130.00,2,5,'1766526311_694b0d67da289.jpg',1,0,1,'2025-12-23 21:45:11','2025-12-23 22:13:47','2025-12-23 22:13:47'),(259,'TECLADO ANTRYX MK840L BLACK GRAY RAINBOW SWITCH RED MECANICO WIRED USB (PN:AMK-CS840LKGRE-SP)','El Teclado Antryx MK840L Black Gray Rainbow es un teclado gamer mecánico con switches rojos lineales y retroiluminación RGB tipo arcoíris, diseñado para ofrecer teclado mecánico responsivo y visual atractivo en setups gaming o de productividad, con conexión USB cableada para respuesta inmediata y sin latencia.','MK840L',22,25,120.00,117.00,2,5,'1766526574_694b0e6e6ff35.jpg',1,0,1,'2025-12-23 21:49:34','2025-12-23 21:49:34',NULL),(260,'TECLADO ASUS TUF GAMING K1 RA04 RGB MEMBRANA WIRED USB','El Teclado ASUS TUF Gaming K1 RA04 RGB es un teclado gamer de membrana con iluminación RGB personalizable diseñado para ofrecer una experiencia de escritura suave y silenciosa junto con una estética gamer llamativa, ideal para jugadores y usuarios que buscan comodidad, durabilidad y estilo en un teclado con conexión USB cableada.','TUF29K1',22,10,210.00,207.00,2,5,'1766526870_694b0f960aa35.jpg',1,0,1,'2025-12-23 21:54:30','2025-12-23 21:54:30',NULL),(261,'TECLADO ANTRYX MK ZIGRA EVO BLACK GRAY MECANICO RED SWITCH WIRED USB (PN:AMK-900KRE-SP)','El Teclado Antryx MK Zigra Evo Black Gray Mecánico (Red Switch) Wired USB es un teclado gamer mecánico con switches rojos lineales y diseño robusto en negro y gris, que ofrece una experiencia de escritura suave, rápida y silenciosa con estilo gamer atractivo, ideal para juegos y uso diario con conexión USB cableada para respuesta inmediata.','ANTMK1I19',22,25,170.00,160.00,2,5,'1766527115_694b108b6b9be.jpg',1,0,1,'2025-12-23 21:58:35','2025-12-23 21:58:35',NULL),(262,'TECLADO CYBERTEL STRIKER CBX K1008-3M RGB MECANICO WIRELESS/BLUETOOTH','El Teclado Cybertel Striker CBX K1008-3M es un teclado mecánico gamer RGB, compacto (96 teclas), con triple conectividad (Bluetooth, WiFi 2.4GHz y cable USB-C), ideal para juegos y productividad, destacando por sus switches mecánicos (rojos o azules, según versión), retroiluminación LED RGB personalizable, perilla para control de volumen y efectos, teclas elevadas, sistema anti-ghosting y compatibilidad multiplataforma (Windows, macOS, Android, Linux).','CBXK100',22,38,110.00,103.00,2,5,'1766527924_694b13b4d6722.jpeg',1,0,1,'2025-12-23 22:12:04','2025-12-23 22:12:04',NULL),(263,'TECLADO LOGITECH G PRO X 60 LIGTHSPEED BLACK RGB MECANICO WIRELES/BLUETOOTH/WIRED USB','El Logitech G PRO X 60 LIGHTSPEED es un teclado gamer inalámbrico compacto (60%) para juegos competitivos, con switches ópticos (GX Tactile/Blue), conectividad triple (LIGHTSPEED 2.4GHz, Bluetooth, USB-C), personalización RGB LIGHTSYNC, y funciones avanzadas como KEYCONTROL para macros, ofreciendo portabilidad y alto rendimiento con hasta 65h de batería, ideal para profesionales de esports.','GPRO183M',22,11,680.00,672.00,2,5,'1766528485_694b15e546a92.jpg',1,0,1,'2025-12-23 22:21:25','2025-12-23 22:21:25',NULL),(264,'TARJETA DE VIDEO GIGABYTE AORUS ELITE RADEON RX 9070','La Gigabyte AORUS Elite Radeon RX 9070 XT es una tarjeta gráfica de gama alta de AMD, parte de la línea AORUS, con 16GB de memoria GDDR6 en bus de 256 bits, interfaz PCI-E 5.0, y un robusto sistema de refrigeración WINDFORCE de 3 ventiladores para mantener bajas temperaturas, ofreciendo rendimiento superior en resolución 1440p y defendiéndose bien en 4K gracias a su arquitectura RDNA4, compatibilidad con FSR 4 y tecnologías de IA, ideal para gaming exigente y creación de contenido con un diseño premium, pero requiere buena ventilación y fuente de poder.','RX9070',20,27,3310.00,3300.00,2,5,'1766528971_694b17cb53132.png',1,0,1,'2025-12-23 22:29:31','2025-12-23 22:29:31',NULL),(265,'TARJETA DE VIDEO GIGABYTE RADEON RX9070 GAMING OC','La Gigabyte Radeon RX 9070 Gaming OC es una tarjeta gráfica de gama alta, basada en la arquitectura RDNA 4 de AMD, diseñada para juegos exigentes en 1440p y 4K, con 16GB de memoria GDDR6 y un bus de 256 bits, destacando por su potente sistema de refrigeración WINDFORCE, iluminación RGB personalizable y características como AMD HYPR-RX para optimizar rendimiento y latencia, ofreciendo un gran equilibrio entre potencia, refrigeración y estética moderna para gaming y creación de contenido.','RX9070AS',20,24,2560.00,2550.00,2,5,'1766529664_694b1a8008fb9.jpg',1,0,1,'2025-12-23 22:41:04','2025-12-23 22:41:04',NULL),(266,'TARJETA DE VIDEO RTX 5090 32G GAMING TRIO GDDR7','La MSI GeForce RTX 5090 32G GAMING TRIO es una tarjeta gráfica de gama alta con la arquitectura Blackwell, 32GB de memoria GDDR7 ultrarrápida (28 Gbps), 21,760 núcleos CUDA, bus de 512 bits, PCI Express 5.0 y un diseño TRIO de triple ventilador para una refrigeración superior, ofreciendo rendimiento extremo en 4K y cargas de trabajo creativas, con un consumo de 575W y un conector de 12 pines.','RTX5090G',20,18,10560.00,10550.00,2,5,'1766530186_694b1c8a9c854.jpg',1,0,1,'2025-12-23 22:49:46','2025-12-23 22:49:46',NULL),(267,'TARJETA DE VIDEO GIGABYTE RTX 5070 WINDFORCE SFF 12G','La Gigabyte RTX 5070 WINDFORCE SFF 12G es una tarjeta gráfica compacta basada en la arquitectura Blackwell de NVIDIA, ideal para gaming en 1440p y 4K, con 12GB de memoria GDDR7, sistema de refrigeración Windforce de 3 ventiladores, soporte para DLSS 4 y Ray Tracing, y un diseño SFF (Factor de Forma Pequeño) perfecto para gabinetes compactos, ofreciendo alto rendimiento en un tamaño reducido y eficiente en refrigeración.','RTX5070K1C1',20,24,2610.00,2600.00,2,5,'1766530563_694b1e03ec178.png',1,0,1,'2025-12-23 22:56:03','2025-12-23 22:56:03',NULL),(268,'TARJETA DE VIDEO GIGABYTE RTX 5060 EAGLE MAX OC 8GB','La Gigabyte RTX 5060 Eagle Max OC 8GB es una tarjeta gráfica de nueva generación (arquitectura Blackwell) para gaming 1080p/1440p, con 8GB de memoria GDDR7, interfaz de 128 bits, y refrigeración WINDFORCE de triple ventilador (alterno), que ofrece buen rendimiento gracias a DLSS 4 y un diseño robusto con backplate metálico, ideal para PCs compactos y gaming moderno','RTX6050EA',20,24,1310.00,1300.00,2,5,'1766531102_694b201e79040.jpg',1,0,1,'2025-12-23 23:05:02','2025-12-23 23:05:02',NULL),(269,'TARJETA DE VIDEO GIGABYTE AORUS RTX5080 XTREME','La GIGABYTE AORUS RTX 5080 XTREME es una potente tarjeta gráfica de gama alta basada en la arquitectura NVIDIA Blackwell, que ofrece 16GB de memoria GDDR7 ultrarrápida, núcleos CUDA masivos (10752), y un rendimiento superior para gaming en 4K+ con tecnologías DLSS 4 y Ray Tracing avanzado. Su característica principal es el sistema de refrigeración WATERFORCE AIO, con un radiador de 360mm y ventiladores ARGB, que mantiene la GPU, VRAM y MOSFET fríos para un overclocking extremo, incluyendo una pantalla LCD integrada y un diseño robusto con placa metálica.','RTX5080XT',20,24,6210.00,6200.00,2,5,'1766531636_694b223489861.jpg',1,0,1,'2025-12-23 23:13:56','2025-12-23 23:13:56',NULL),(270,'TARJETA DE VIDEO MSI GEFORCE RTX 5070 Ti 16G INSPIRE 3X OC','La MSI GeForce RTX 5070 Ti 16G INSPIRE 3X OC es una tarjeta gráfica de gama alta para gaming y creación, basada en la arquitectura NVIDIA Blackwell, con 16GB de memoria GDDR7, refrigeración avanzada de 3 ventiladores (STORMFORCE), placa base de cobre niquelado y compatibilidad con tecnologías de IA como DLSS 4, ofreciendo alto rendimiento para 1440p y 4K con Ray Tracing, y un diseño optimizado para PC compactos (SFF).','RTX5070TI',20,18,3910.00,3900.00,2,5,'1766531991_694b2397e732c.jpg',1,0,1,'2025-12-23 23:19:51','2025-12-23 23:19:51',NULL),(271,'TARJETA DE VIDEO GIGABYTE RTX 5060TI EAGLE OC ICE 16GB','La Gigabyte RTX 5060 Ti Eagle OC Ice 16GB es una tarjeta gráfica de gama media-alta basada en la arquitectura NVIDIA Blackwell, destacando por sus 16GB de memoria GDDR7, ideal para juegos en resolución 1080p y 2K (QHD) con DLSS 4, con un potente sistema de refrigeración WINDFORCE, diseño blanco Ice y conectividad PCIe 5.0 para un excelente rendimiento térmico y visual en juegos modernos.','RTX5060EAG',20,24,2060.00,2050.00,2,5,'1766532325_694b24e5e33fe.jpg',1,0,1,'2025-12-23 23:25:25','2025-12-23 23:25:25',NULL),(272,'TARJETA DE VIDEO ASUS GEFORCE RTX 5060 8GB GDDR7','La ASUS GeForce RTX 5060 8GB GDDR7 es una tarjeta gráfica de gama media-baja basada en la arquitectura Blackwell, ideal para gaming en 1080p y algunos juegos en 2K, ofreciendo excelente rendimiento en resolución Full HD con tecnologías IA como DLSS 3 y RT Cores, memoria GDDR7 rápida, un robusto sistema de enfriamiento Axial-Tech de doble o triple ventilador según el modelo (Dual o Prime), y un diseño compacto de 2.5 ranuras para compatibilidad con PCs pequeñas, destacando por su eficiencia y potencia en juegos actuales.','RTX5060Z1T',20,10,1680.00,1670.00,2,5,'1766532659_694b26339765b.png',1,0,1,'2025-12-23 23:30:59','2025-12-23 23:30:59',NULL),(273,'TARJETA DE VIDEO ASROCK AMD RADEON RX 9060 XT 8GB STEEL','La ASRock Radeon RX 9060 XT 8GB Steel Legend es una tarjeta gráfica de gama media-alta para gaming, con 8GB GDDR6, interfaz PCIe 5.0, diseño de triple ventilador (Steel Legend) para buena refrigeración, y conectividad moderna (DisplayPort 2.1a, HDMI 2.1b), enfocada en ofrecer alto rendimiento a 1080p/1440p con tecnologías AMD avanzadas, ideal para jugadores y creadores de contenido que buscan una excelente relación calidad-precio y un diseño robusto.','RX9060V2',20,15,1460.00,1450.00,2,5,'1766533351_694b28e7c8151.png',1,0,1,'2025-12-23 23:42:31','2025-12-23 23:42:31',NULL),(274,'MONITOR ASUS ROG STRIX XG256Q 24.5\" FHD 1920x1080/180HZ/1MS/FREESYNC PREMIUM/COMPATIBLE NVIDIA G-SYNC','El ASUS ROG Strix XG256Q es un monitor gaming Fast IPS de 24.5\" Full HD (1920x1080) enfocado en la velocidad, con una tasa de refresco de 180Hz (OC), tiempo de respuesta de 1ms (GTG), y soporte para AMD FreeSync Premium y NVIDIA G-Sync Compatible, ofreciendo imágenes fluidas y nítidas, certificación DisplayHDR 400 para mejor contraste, tecnologías como ELMB y GamePlus, y diseño ergonómico con soporte para trípode, ideal para gamers competitivos que buscan rendimiento sin interrupciones.','XG256Q',24,10,1225.00,1218.00,2,5,'1766533658_694b2a1a45585.jpg',1,0,1,'2025-12-23 23:47:38','2025-12-23 23:47:38',NULL),(275,'MONITOR ASUS ROG STRIX XG27AQMR 27\" QHD 2560x1440/300HZ/1MS/FREESYNC PREMIUM PRO/COMPATIBLE NVIDIA G-SYNC','El ASUS ROG Strix XG27AQMR es un monitor gamer de 27\" QHD (2560x1440) con panel Fast IPS, que ofrece una velocidad extrema de 300Hz, tiempo de respuesta de 1ms (GTG) y tecnologías como FreeSync Premium Pro y compatibilidad con NVIDIA G-SYNC para eliminar tearing, además de DisplayHDR 600 y una amplia gama de colores DCI-P3 para una imagen vibrante y nítida, ideal para eSports competitivos y juegos inmersivos.','XG27AQMR',24,10,2650.00,2640.00,2,5,'1766534033_694b2b91d4a11.jpg',1,0,1,'2025-12-23 23:53:53','2025-12-23 23:53:53',NULL),(276,'MONITOR ASUS ROG STRIX XG309CM 29.5\" WFHD 2560x1080/220HZ/1MS/FREESYNC PREMIUM/COMPATIBLE NVIDIA G-SYNC','El ASUS ROG Strix XG309CM es un monitor gaming ultrawide de 29.5\" con panel Fast IPS, resolución WFHD (2560x1080), frecuencia de refresco de 220Hz (overclock), tiempo de respuesta de 1ms (GTG) y compatibilidad con G-Sync y FreeSync Premium, ofreciendo imágenes nítidas y fluidas para juegos competitivos, además de características como USB-C, KVM y un soporte con socket para trípode para versatilidad.','XG309CM',24,10,1600.00,1595.00,2,5,'1766534303_694b2c9fb02b2.jpg',1,0,1,'2025-12-23 23:58:23','2025-12-24 00:07:17',NULL),(277,'MONITOR MSI G274CV 27\" CURVO FHD 1920x1080/75HZ/1MS/AMD RADEON FREESYNC','El MSI G274CV es un monitor gamer curvo de 27 pulgadas con resolución Full HD (1920x1080), panel VA, que ofrece una experiencia inmersiva con curvatura 1500R, ideal para juegos gracias a su alta tasa de refresco de 75Hz, tiempo de respuesta de 1ms (MPRT) y tecnología AMD FreeSync para una jugabilidad fluida sin desgarros, además de incluir conectividad DisplayPort y HDMI y un diseño sin bordes.','G274CV',24,18,540.00,530.00,2,5,'1766534783_694b2e7f32a21.png',1,0,1,'2025-12-24 00:06:23','2025-12-24 00:06:23',NULL),(278,'MONITOR ASUS VZ24EHF 23.8\" FHD 1920x1080/100HZ/1MS','El ASUS VZ24EHF es un monitor IPS Full HD de 23.8\" ultradelgado, ideal para trabajo y juegos casuales, que destaca por su fluidez con 100Hz de tasa de refresco y 1ms (MPRT) de respuesta, tecnología Adaptive-Sync (FreeSync) para eliminar tearing, y tecnologías Eye Care certificadas (Flicker-Free, Low Blue Light) para comodidad visual, ofreciendo colores precisos y amplios ángulos de visión, con diseño sin marco y montaje VESA.','VZ24EHF',24,10,320.00,310.00,2,5,'1766535091_694b2fb3e45de.jfif',1,0,1,'2025-12-24 00:11:31','2025-12-24 00:11:31',NULL),(279,'MONITOR ASUS ROG STRIX XG27AQ-W 27\" WQHD 2560x1440/170HZ/1MS/COMPATIBLE NVIDIA G-SYNC','El ASUS ROG Strix XG27AQ-W es un monitor gaming de 27\" WQHD (2560x1440) con panel IPS rápido, que ofrece hasta 170Hz (overclock) y 1ms (GTG) de respuesta, destacando por su compatibilidad G-Sync, tecnología ELMB SYNC para eliminar el ghosting, y certificación DisplayHDR 400 para un buen contraste y color, siendo ideal para gaming competitivo y creación de contenido, aunque su HDR es básico.','XG27AQ-W',24,10,1720.00,1710.00,2,5,'1766535379_694b30d3a9e84.jfif',1,0,1,'2025-12-24 00:16:19','2025-12-24 00:16:19',NULL),(280,'MONITOR ASUS ROG STRIX GAMING XG27AQV 27\" CURVO QHD 2560x1440/170HZ/1MS/FREESYNC PREMIUM/COMPATIBLE NVIDIA G-SYNC','El Asus ROG Strix XG27AQV es un monitor gamer curvo de 27 pulgadas QHD (2560x1440) con panel IPS rápido, diseñado para ofrecer una experiencia de juego fluida y detallada, destacando por su alta tasa de refresco de 170Hz (OC), tiempo de respuesta de 1ms GTG, tecnología Adaptive Sync (FreeSync Premium y G-Sync Compatible), y compatibilidad HDR DisplayHDR 400, ideal para jugadores que buscan inmersión, velocidad y calidad de imagen superior en juegos competitivos y visuales vibrantes.','XG27AQVXA',24,10,1485.00,1475.00,2,5,'1766535596_694b31acd6cb6.jpg',1,0,1,'2025-12-24 00:19:56','2025-12-24 00:19:56',NULL),(281,'MONITOR ASUS ROG STRIX PG279QM 27\" QHD 2560x1440/240HZ/1MS/NVIDIA G-SYNC (PN:90LM0235-B13B0)','El ASUS ROG Strix PG279QM es un monitor gaming de 27\" QHD (2560x1440) con panel Fast IPS, diseñado para profesionales, ofreciendo 240Hz de refresco, 1ms de respuesta (GTG) y tecnología NVIDIA G-Sync con analizador de latencia, además de HDR DisplayHDR 400, cobertura DCI-P3 y puertos DisplayPort, HDMI y USB 3.0, ideal para gaming competitivo fluido y visuales impresionantes.','PG279QM',24,10,3185.00,3175.00,2,5,'1766535890_694b32d204932.jpg',1,0,1,'2025-12-24 00:23:34','2025-12-24 00:24:50',NULL),(282,'MONITOR ASUS ROG SWIFT OLED PG27AQDM 27\" QHD 2560x1440/240HZ/0.003MS/FREESYNC PREMIUM/COMPATIBLE NVIDIA G-SYNC','El ASUS ROG Swift OLED PG27AQDM es un monitor gaming de gama alta que ofrece una experiencia visual superior con su panel OLED de 27 pulgadas, resolución QHD (2560x1440), altísima tasa de refresco de 240Hz y un tiempo de respuesta ultrarrápido de 0.03ms (GTG), brindando colores vibrantes, negros puros y fluidez extrema, ideal para PCs potentes con NVIDIA G-SYNC y FreeSync Premium para gaming sin tirones, con tecnologías extra para proteger el panel OLED y mejorar la gestión del calor.El ASUS ROG Swift OLED PG27AQDM es un monitor gaming de gama alta que ofrece una experiencia visual superior con su panel OLED de 27 pulgadas, resolución QHD (2560x1440), altísima tasa de refresco de 240Hz y un tiempo de respuesta ultrarrápido de 0.03ms (GTG), brindando colores vibrantes, negros puros y fluidez extrema, ideal para PCs potentes con NVIDIA G-SYNC y FreeSync Premium para gaming sin tirones, con tecnologías extra para proteger el panel OLED y mejorar la gestión del calor.','PG27AQDM',24,10,3355.00,3345.00,2,5,'1766536258_694b34425f42f.jfif',1,0,1,'2025-12-24 00:30:58','2025-12-24 00:30:58',NULL),(283,'MONITOR ASUS TUF GAMING VG279Q1A 27\" FHD 1920x1080/165HZ/1MS/FREESYNC PREMIUM (PN:90LM05X0\'B051B0)','El ASUS TUF Gaming VG279Q1A es un monitor gamer de 27 pulgadas Full HD (1920x1080) con panel IPS, enfocado en la velocidad y fluidez para juegos, ofreciendo una tasa de refresco de 165Hz, tiempo de respuesta de 1ms (MPRT) con la tecnología ELMB, y FreeSync Premium para eliminar el desgarro de pantalla, además de incluir altavoces y puertos HDMI/DisplayPort para una experiencia de juego inmersiva y nítida.','VG279Q1A',24,10,745.00,735.00,2,5,'1766536447_694b34ff9a8ce.jfif',1,0,1,'2025-12-24 00:34:07','2025-12-24 00:34:07',NULL),(284,'MEMORIA 32GB (16GBx2) DDR5 G.SKILL TRIDENT Z5 RGB BLACK BUS 6000MHZ','La memoria G.Skill Trident Z5 RGB Black de 32GB (2x16GB) DDR5 a 6000MHz es un kit de RAM de alto rendimiento para PCs de escritorio, ideal para gaming y tareas exigentes, ofreciendo velocidades ultrarrápidas, iluminación RGB personalizable, diseño de disipador negro con estilo deportivo, compatibilidad con perfiles Intel XMP 3.0 y bajo voltaje para una mayor eficiencia, con timings (latencias) agresivos como CL30-40-40-96 para un rendimiento superior en plataformas DDR5.','6000J3040F16GX2-TZ5RK',11,22,1010.00,34000.00,2,5,'1766537575_694b39672902b.jpg',1,0,1,'2025-12-24 00:52:55','2025-12-24 14:27:02',NULL),(285,'MEMORIA 16GB (8GBx2) DDR4 G.SKILL TRIDENT Z INTEL XMP BUS 3200MHZ','La memoria G.Skill Trident Z 16GB (8GBx2) DDR4 3200MHz es un kit de RAM de alto rendimiento para PC, ideal para gaming y tareas exigentes, ofreciendo 16GB en doble canal con una frecuencia de 3200 MHz y latencias bajas (CL16), que se activa vía XMP para una configuración fácil y estable en plataformas Intel (y AMD), destacando por su diseño premium con disipadores de aluminio y a menudo iluminación RGB personalizable para enfriamiento y estilo.','DDR4GSKI',11,22,480.00,478.00,2,5,'1766537944_694b3ad8b4b56.jpg',1,0,1,'2025-12-24 00:59:04','2025-12-24 00:59:04',NULL),(286,'MEMORIA 8GB DDR4 KINGSTON FURY BEAST RGB BLACK BUS 3200MHZ','La memoria Kingston FURY Beast RGB Black de 8GB DDR4 3200MHz es un módulo RAM de alto rendimiento con disipador negro y iluminación RGB personalizable, ideal para gamers y usuarios que buscan mejorar la velocidad en juegos y multitarea, ofreciendo frecuencias de 3200MHz, latencia CL16, compatibilidad con Intel XMP y AMD Ryzen, y tecnología de sincronización de luz (Infrared Sync) para un aspecto visual atractivo, además de estabilidad con ODECC.','DD43200GZ',11,23,100.00,95.00,2,5,'1766538504_694b3d085fcce.jpg',1,0,1,'2025-12-24 01:08:24','2025-12-24 01:08:24',NULL),(287,'MEMORIA 8GB DDR4 T-FORCE DELTA RGB WHITE BUS 3200MHZ','La memoria 8GB DDR4 T-FORCE DELTA RGB WHITE BUS 3200MHZ es un módulo RAM de alto rendimiento para PC de escritorio de la marca Teamgroup, destacando por su diseño blanco con iluminación RGB de 120°, velocidad de 3200MHz (CL16), disipador de calor eficiente, compatibilidad con ASUS Aura Sync y soporte XMP 2.0 para overclock fácil, ideal para gamers que buscan estética y potencia.','DDR4MHZ',11,34,77.00,72.00,2,5,'1766538847_694b3e5fe8236.jpg',1,0,1,'2025-12-24 01:14:07','2025-12-24 01:14:07',NULL),(288,'MEMORIA 16GB DDR5 T-FORCE DELTA BLACK RGB BUS 6000MHZ','La memoria T-Force Delta Black RGB DDR5 16GB 6000MHz es un módulo RAM de alto rendimiento para PC, caracterizado por su gran velocidad (6000MHz) y baja latencia (CL38), ideal para gaming y tareas exigentes, con un diseño negro agresivo, disipador de aluminio, y una iluminación RGB personalizable de 120°. Es DDR5, compatible con Intel XMP 3.0 y AMD EXPO, e incluye un circuito PMIC para una gestión de energía eficiente y estable, con tecnología ECC on-die para mayor confiabilidad del sistema.','TMHX600',11,34,385.00,2900.00,2,5,'1766539490_694b40e27e4f5.jfif',1,0,1,'2025-12-24 01:24:50','2025-12-26 13:52:56',NULL),(289,'MEMORIA 16GB DDR5 T-FORCE DELTA RGB WHITE INTEL XMP BUS 6000MHZ','La memoria T-FORCE DELTA RGB WHITE 16GB DDR5 6000MHz es un módulo RAM de alto rendimiento, color blanco, con iluminación RGB personalizable, diseñado para sistemas Intel (compatible con XMP 3.0), que ofrece 16GB de capacidad, velocidad de 6000 MT/s y latencia CL38 para gaming y tareas exigentes, mejorando la eficiencia con el estándar DDR5.','RGBXMP60',11,34,200.00,2900.00,2,5,'1766539955_694b42b33265f.jpg',1,0,1,'2025-12-24 01:32:35','2025-12-26 13:52:33',NULL),(290,'CASE HYTE Y60 BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER','El HYTE Y60 Negro es un gabinete Mid-Tower ATX de doble cámara, famoso por su diseño panorámico de vidrio templado sin biseles que muestra los componentes, ideal para gaming y estética, viene sin fuente de poder (PSU), incluye 3 ventiladores de 120mm, soporta EATX/ATX, tiene un riser PCIe 4.0 para GPU vertical, y excelente soporte para refrigeración líquida, ofreciendo un look premium y moderno para exhibir tu PC','Y60CASB',21,10,550.00,548.00,2,5,'1766541057_694b4701cf0b4.jpg',1,0,1,'2025-12-24 01:50:57','2025-12-24 01:50:57',NULL),(291,'CASE HYTE Y60 BLACK WHITE SIN FUENTE VIDRIO TEMPLADO MID TOWER','El HYTE Y60 es un gabinete Mid-Tower ATX de doble cámara con un diseño estético premium, destacando por su vidrio templado panorámico de 3 piezas para exhibir componentes y una montura vertical para la GPU (incluye cable riser PCIe 4.0), ideal para mostrar hardware con estética blanco/negro (Black/White), es un chasis moderno sin fuente de poder, optimizado para flujo de aire y refrigeración líquida, perfecto para builds de alto rendimiento y gaming.','HYT60ASQ',21,43,550.00,548.00,2,5,'1766541822_694b49fe7d8d1.jpg',1,0,1,'2025-12-24 02:03:42','2025-12-24 02:03:42',NULL),(292,'CASE HYTE Y40 BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER','El CASE HYTE Y40 BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER es un gabinete ATX Mid Tower moderno y estético, sin fuente de poder, con vidrio templado panorámico que exhibe el interior, soporte para GPU vertical con riser PCIe 4.0 incluido, y excelente flujo de aire para refrigeración, ideal para montajes de PC gaming de alto rendimiento con un diseño elegante y funcional que integra detalles de biselado y ventilación optimizada.','HYT40BLSC',21,43,465.00,463.00,2,5,'1766542342_694b4c0610f8c.jpg',1,0,1,'2025-12-24 02:12:22','2025-12-24 02:12:22',NULL),(293,'CASE HYTE Y40 BLACK RED SIN FUENTE VIDRIO TEMPLADO MID TOWER','El CASE HYTE Y40 BLACK RED es un gabinete Mid-Tower ATX de estética premium, destacando por su vidrio panorámico sin bisel (dos piezas) que muestra tus componentes, ideal para una visualización total; incluye un riser PCIe 4.0 para instalar la GPU verticalmente y ventilación eficiente con ventiladores preinstalados y excelente gestión de cables, ofreciendo un diseño moderno y funcional sin fuente de poder incluida, enfocado en mostrar el hardware con un estilo único y un precio competitivo.','HYT40BR',21,43,490.00,480.00,2,5,'1766542695_694b4d672d6f2.jpg',1,0,1,'2025-12-24 02:18:15','2025-12-24 02:18:15',NULL),(294,'CASE HYTE Y70 TOUCH INFINITE WHITE SIN FUENTE VIDRIO TEMPLADO MID TOWER','El HYTE Y70 Touch Infinite White es un gabinete mid-tower de gama alta para PC que destaca por su pantalla táctil IPS de 14.9 pulgadas integrada, un diseño panorámico de triple vidrio templado y una estética moderna con dos cámaras, ofreciendo una vista inmersiva del hardware, gran soporte para refrigeración (radiadores de hasta 360mm) y un elevador PCIe 4.0 incluido para GPU vertical, ideal para construcciones de alto rendimiento y personalización visual avanzada, sin incluir la fuente de poder (PSU)','HYT70WW',21,43,1440.00,1430.00,2,5,'1766543370_694b500ac272d.jpg',1,0,1,'2025-12-24 02:29:30','2025-12-24 02:29:30',NULL),(295,'CASE HYTE Y70 TOUCH INFINITE BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER','El HYTE Y70 Touch Infinite Black es un gabinete Mid-Tower ATX de doble cámara, sin fuente de poder, que destaca por su innovadora pantalla táctil de 14.9\" 2.5K integrada en el frontal y un diseño panorámico de vidrio templado de 3 piezas, ideal para mostrar el hardware con instalación de GPU vertical (incluye riser PCIe 4.0), ofreciendo estética moderna, gran capacidad de refrigeración (hasta 10 ventiladores) y gestión de cables optimizada para entusiastas del gaming y creadores de contenido.','HYT70TIBB',21,43,1440.00,1430.00,2,5,'1766543869_694b51fd53023.jfif',1,0,1,'2025-12-24 02:37:49','2025-12-24 02:37:49',NULL),(296,'CASE HYTE Y70 PERSONA 3 RELOAD SIN FUENTE VIDRIO TEMPLADO MID TOWER','El Hyte Y70 Persona 3 Reload es un gabinete Mid-Tower de doble cámara, sin fuente de poder, con paneles de vidrio templado que resaltan tu hardware, inspirado en el videojuego Persona 3, ideal para PC gamers de alto rendimiento, ofreciendo gran espacio para GPUs de 4 ranuras y excelente refrigeración para placas ATX/E-ATX.','HYT3P3R',21,43,915.00,905.00,2,5,'1766544619_694b54ebd7bbe.jpg',1,0,1,'2025-12-24 02:50:19','2025-12-24 02:50:19',NULL),(297,'CASE HYTE Y70 BLUEBERRY MILK SIN FUENTE VIDRIO TEMPLADO MID TOWER','El HYTE Y70 Blueberry Milk es un gabinete Mid-Tower ATX de doble cámara con un diseño premium y un llamativo color azul \"Milk\", ideal para mostrar tu hardware con su gran ventana panorámica de cristal templado, es sin fuente de poder y trae incluido un riser PCIe 4.0 x16 para instalar la tarjeta gráfica en vertical, ofreciendo gran capacidad de refrigeración para setups potentes y una gestión de cables superior.','CSHYTEY70BM',21,43,780.00,776.00,2,5,'1766545286_694b5786791a0.jpg',1,0,1,'2025-12-24 03:01:26','2025-12-24 03:01:26',NULL),(298,'CASE HYTE Y70 TOUCH INFINITE RED BLACK SIN FUENTE VIDRIO TEMPLADO MID TOWER','El HYTE Y70 Touch Infinite Red/Black es un gabinete Mid Tower ATX de doble cámara, \"sin fuente\" (No PSU), con un panel táctil IPS de 14.9\" 2.5K integrado, vidrio templado panorámico, y soporte para GPU vertical de 4 ranuras, destacando por su estética moderna, excelente refrigeración y una experiencia de usuario inmersiva al mostrar hardware y widgets, ideal para entusiastas que buscan exhibir su PC y controlar su sistema.','CSHYTEY70TIRB',21,43,1720.00,1711.00,2,5,'1766545925_694b5a059fd20.jpg',1,0,1,'2025-12-24 03:12:05','2025-12-24 03:12:05',NULL);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_comercial` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contacto_nombre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contacto_telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dias_credito` int NOT NULL DEFAULT '0',
  `limite_credito` decimal(12,2) NOT NULL DEFAULT '0.00',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero_reclamo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `consumidor_nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_dni` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_direccion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_telefono` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `es_menor_edad` tinyint(1) DEFAULT '0',
  `apoderado_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apoderado_dni` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apoderado_direccion` text COLLATE utf8mb4_unicode_ci,
  `apoderado_telefono` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apoderado_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_bien` enum('producto','servicio') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'producto',
  `monto_reclamado` decimal(10,2) NOT NULL,
  `descripcion_bien` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_solicitud` enum('reclamo','queja') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'reclamo',
  `detalle_reclamo` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pedido_consumidor` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuesta_proveedor` text COLLATE utf8mb4_unicode_ci,
  `fecha_respuesta` date DEFAULT NULL,
  `estado` enum('pendiente','en_proceso','resuelto','cerrado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo` enum('puntos','descuento','envio_gratis','regalo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `estado` enum('programada','activa','pausada','expirada','cancelada') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'programada',
  `creado_por` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `segmento` enum('todos','nuevos','recurrentes','vip','no_registrados') COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `tipo_descuento` enum('porcentaje','cantidad_fija') COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `minimo_compra` decimal(10,2) DEFAULT '0.00',
  `zonas_aplicables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`),
  KEY `recompensa_id` (`recompensa_id`),
  CONSTRAINT `recompensas_envios_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recompensas_envios_chk_1` CHECK (json_valid(`zonas_aplicables`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `cliente_id` bigint unsigned NOT NULL,
  `pedido_id` bigint unsigned DEFAULT NULL,
  `puntos_otorgados` decimal(10,2) DEFAULT '0.00',
  `beneficio_aplicado` text COLLATE utf8mb4_unicode_ci,
  `fecha_aplicacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `cliente_id` bigint unsigned NOT NULL,
  `popup_id` bigint unsigned NOT NULL,
  `fecha_notificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_visualizacion` timestamp NULL DEFAULT NULL,
  `fecha_cierre` timestamp NULL DEFAULT NULL,
  `estado` enum('enviada','vista','cerrada','expirada') COLLATE utf8mb4_unicode_ci DEFAULT 'enviada',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `imagen_popup` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `texto_boton` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Ver más',
  `url_destino` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mostrar_cerrar` tinyint(1) DEFAULT '1',
  `auto_cerrar_segundos` int DEFAULT NULL,
  `popup_activo` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned DEFAULT NULL,
  `categoria_id` bigint unsigned DEFAULT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `puntos_por_compra` decimal(10,2) DEFAULT '0.00',
  `puntos_por_monto` decimal(10,2) DEFAULT '0.00',
  `puntos_registro` decimal(10,2) DEFAULT '0.00',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `recompensa_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `cantidad` int DEFAULT '1',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `empresa_id` bigint unsigned NOT NULL,
  `fecha_resumen` date NOT NULL,
  `fecha_generacion` date NOT NULL,
  `correlativo` int unsigned NOT NULL,
  `identificador` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad_comprobantes` int unsigned DEFAULT NULL,
  `total_gravado` decimal(12,2) DEFAULT '0.00',
  `total_exonerado` decimal(12,2) DEFAULT '0.00',
  `total_inafecto` decimal(12,2) DEFAULT '0.00',
  `total_igv` decimal(12,2) DEFAULT '0.00',
  `total_general` decimal(12,2) DEFAULT '0.00',
  `xml_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cdr_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('PENDIENTE','ACEPTADO','RECHAZADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `codigo_sunat` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `fecha_procesamiento` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `resumen_id` bigint unsigned NOT NULL,
  `comprobante_id` bigint unsigned NOT NULL,
  `tipo_comprobante` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serie` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero` int unsigned DEFAULT NULL,
  `estado_item` enum('1','2','3') COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `total` decimal(12,2) DEFAULT NULL,
  `igv` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
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
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
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
INSERT INTO `role_has_permissions` VALUES (13,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(38,1),(39,1),(40,1),(41,1),(42,1),(43,1),(44,1),(45,1),(46,1),(47,1),(48,1),(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),(55,1),(56,1),(57,1),(58,1),(59,1),(60,1),(61,1),(62,1),(63,1),(64,1),(65,1),(66,1),(67,1),(68,1),(69,1),(70,1),(71,1),(72,1),(73,1),(74,1),(75,1),(76,1),(77,1),(78,1),(79,1),(80,1),(81,1),(86,1),(87,1),(88,1),(89,1),(90,1),(91,1),(92,1),(93,1),(94,1),(95,1),(96,1),(97,1),(98,1),(99,1),(100,1),(101,1),(102,1),(103,1),(104,1),(105,1),(107,1),(109,1),(111,1),(113,1),(115,1),(117,1),(119,1),(121,1),(123,1),(125,1),(126,1),(127,1),(128,1),(129,1),(130,1),(131,1),(132,1),(133,1),(134,1),(135,1),(136,1),(137,1),(138,1),(139,1),(140,1),(141,1),(142,1),(143,1),(144,1),(145,1),(146,1),(147,1),(148,1),(149,1),(150,1),(151,1),(152,1),(153,1),(154,1),(155,1),(156,1),(157,1),(158,1),(159,1),(160,1),(161,1),(162,1),(163,1),(192,1),(194,1),(196,1),(198,1),(200,1),(202,1),(204,1),(206,1),(208,1),(210,1),(212,1),(214,1),(216,1),(218,1),(220,1),(222,1),(224,1),(226,1),(228,1),(230,1),(232,1),(234,1),(236,1),(238,1),(240,1),(242,1),(244,1),(246,1),(248,1),(250,1),(252,1),(254,1),(256,1),(258,1),(260,1),(262,1),(264,1),(266,1),(268,1),(270,1),(272,1),(274,1),(276,1),(278,1),(280,1),(282,1),(284,1),(286,1),(288,1),(290,1),(292,1),(294,1),(296,1),(298,1),(300,1),(302,1),(304,1),(306,1),(308,1),(310,1),(312,1),(314,1),(316,1),(317,1),(319,1),(320,1),(17,2),(13,3),(20,3),(25,3),(30,3),(38,3),(42,3),(50,3),(54,3),(58,3),(59,3),(64,3),(69,3),(74,3),(76,3),(78,3),(86,3),(92,3),(100,3),(125,3),(130,3),(135,3),(139,3),(152,3),(156,3),(160,3),(105,4),(107,4),(109,4),(111,4),(113,4),(115,4),(117,4),(119,4),(121,4),(123,4),(106,5),(108,5),(110,5),(112,5),(114,5),(116,5),(118,5),(120,5),(122,5),(124,5),(164,6),(165,6),(166,6),(167,6),(168,6),(169,6),(170,6),(171,6),(172,6),(173,6),(174,6),(175,6),(176,6),(177,6),(178,6),(179,6),(180,6),(181,6),(182,6),(183,6),(184,6),(185,6),(186,6),(187,6),(188,6),(189,6),(190,6),(191,6),(193,6),(195,6),(197,6),(199,6),(201,6),(203,6),(205,6),(207,6),(209,6),(211,6),(213,6),(215,6),(217,6),(219,6),(221,6),(223,6),(225,6),(227,6),(229,6),(231,6),(233,6),(235,6),(237,6),(239,6),(241,6),(243,6),(245,6),(247,6),(249,6),(251,6),(253,6),(255,6),(257,6),(259,6),(261,6),(263,6),(265,6),(267,6),(269,6),(271,6),(273,6),(275,6),(277,6),(279,6),(281,6),(283,6),(285,6),(287,6),(289,6),(291,6),(293,6),(295,6),(297,6),(299,6),(301,6),(303,6),(305,6),(307,6),(309,6),(311,6),(313,6),(315,6),(164,7),(166,7),(193,7),(195,7),(197,7),(203,7),(207,7),(211,7),(279,7),(281,7),(283,7),(167,8),(172,8),(173,8),(174,8),(175,8),(176,8),(177,8);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web',
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
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo_comprobante` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '01=Factura, 03=Boleta, 07=Nota Crédito, 08=Nota Débito',
  `serie` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correlativo` int unsigned NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `sede_id` bigint unsigned DEFAULT NULL,
  `caja_id` bigint unsigned DEFAULT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
INSERT INTO `series_comprobantes` VALUES (1,'01','F001',68,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-12-01 17:47:02'),(2,'03','B001',185,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-12-01 17:47:06'),(3,'07','FC01',68,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-12-01 17:47:09'),(4,'07','BC01',185,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-12-01 17:47:13'),(5,'08','FD01',3,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-11-12 22:18:39'),(6,'08','BD01',0,1,NULL,NULL,NULL,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(7,'09','T001',20,1,NULL,NULL,'Serie por defecto Guía de Remisión','2025-10-17 18:19:58','2026-01-09 02:52:02');
/*!40000 ALTER TABLE `series_comprobantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicios` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_servicio` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `precio` decimal(12,2) NOT NULL,
  `mostrar_igv` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Si aplica IGV',
  `unidad_medida` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ZZ' COMMENT 'ZZ=Servicio, NIU=Unidad',
  `tipo_afectacion_igv` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '10' COMMENT '10=Gravado, 20=Exonerado, 30=Inafecto',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `servicios_codigo_servicio_unique` (`codigo_servicio`),
  KEY `servicios_codigo_servicio_index` (`codigo_servicio`),
  KEY `servicios_activo_index` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicios`
--

LOCK TABLES `servicios` WRITE;
/*!40000 ALTER TABLE `servicios` DISABLE KEYS */;
INSERT INTO `servicios` VALUES (1,'SERV-001','Instalación de Software','Servicio de instalación y configuración de software',150.00,1,'ZZ','10',1,'2025-12-01 23:26:13','2025-12-01 23:26:13',NULL),(2,'SERV-002','Mantenimiento de PC','Servicio de mantenimiento preventivo y correctivo de computadoras',80.00,1,'ZZ','10',1,'2025-12-01 23:26:14','2025-12-01 23:26:14',NULL),(3,'SERV-003','Soporte Técnico Remoto','Asistencia técnica remota por hora',50.00,1,'HUR','10',1,'2025-12-01 23:26:14','2025-12-01 23:26:14',NULL),(4,'SERV-004','Configuración de Red','Configuración de redes LAN/WLAN',200.00,1,'ZZ','10',1,'2025-12-01 23:26:15','2025-12-01 23:26:15',NULL),(5,'SERV-005','Desarrollo Web','Desarrollo de sitios web personalizados',1500.00,1,'ZZ','10',1,'2025-12-01 23:26:15','2025-12-01 23:26:15',NULL);
/*!40000 ALTER TABLE `servicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
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
INSERT INTO `sessions` VALUES ('1LakjvIoEYWSdlIsdrqSamrEC7sQ5jd0iagBkW4a',NULL,'38.56.216.90','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUZkdlR1WVNycTc5aktXUzdTZXZxSlZ2S2ptempxazY1cGF5OWJLeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMURZbTRjYk8xT0lkUWdIZVpmTWZZUFZPX1JfY1BaRDFmZ0NwZzM3N05CZ29BSWZhZmE1V0lBMnNUbFRTQ0pET1EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPXdyRGtLUzNGVkZtMHp5QlJDMTZnbldpREJaWmtlTzFRWUl3cUJBN1MiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759008427),('7cBbOW3MWgoXnzJAhRAF4xkdL8lDPaCG70dxj8tI',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoicXJPMEhnajF0cWZiV2w5YjFBZDdZZmVoRVA3eFJWUFQ5Z0xPbmlaUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFUWDg3bE1PbzVhZjdCbk1CcnFqUTl4N0VCUWJfa2tEU1dVU1hVVVk4bktuT2RyWi1wX0laLVl1UFEzbHFnXzhLdlFTTmcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJnN0YXRlPVdLVDNnWEt1OUZNT0tRSWozTkdPVG84OTRyeTRmUW1hRWw4S3NJdE4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1765575938),('9zCeAJmTofdnjvQRMyHzoIqyXeyXQosTu0owcLT8',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMVRDV0c4elVDWW5iRkdSNUNkbW9YcEFOV1VxZ0VuU3JocTIyRHgzMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUJJRVd3Wm1vRV9MSlpwUzBVZmJCSjU5a083M1E2YlctTUx1dEU4LTNrUERsWHNBSnNrZjRZemxzbUVfczdRT1EmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPXltWnZxVU5qQjcyUzVPendnUGI0N01Tcno5S1lqcUpyY3ZaNXUyOFkiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759026506),('BGFTFLPhLJ5RMAjgiGQFJ9D7weBqvntHUxwzazH0',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibmJ5MUtjeG0yamhGZkx3eHh4MlQ0WVhYV0JjSFBqWElhcDVnOXBxQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFUWDg3bE85SW9ub2dnWnJnYnpqMHpLdVE3bnJldk1mOWRmcDhvMVpXMTh0ekJsWmc1VEpyYjVkTGw3cjE3WWUtUWxHSFEmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJTIwb3BlbmlkJnN0YXRlPXVMVUdIUlNLb2Q1OWg2WUpVaTdwcFgyUUpaT2VXQ3p5a2RTdUhnZHQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1767448513),('BWf8lbp3JgOGzZkKzxNlfSDr6ybFEm0NkmnnPPlm',NULL,'181.64.193.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoic2JvbU03UW53MFZuMkpURXBBb3FiOFFINUVubHJ4RzFhMTBIT0xCOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1767369137),('ByVvLUZbWaKcWrwySxu2Vsrk24LGtmghrv5P16gr',NULL,'38.255.107.234','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiV0xwWnNES0QzSkt1RFdvMUR0elZVZ2tSaVlCR29FTk5IYklXVXFNYSI7czo1OiJzdGF0ZSI7czo0MDoiSkZiazVKMXFsSnFTUURZTmhFU0VhTDFINE9kWHJsbDVzRVlIQjlCVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996334),('doYLp8T61tvOXzFZHMxVCprnZAoat8OYC0liEpQh',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkVpVHZzYXRUdzRRM3ZwZjVpSHp2NmxuMFJvVHFWNjdNRUJMRWhiSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFlYzZRVEtheWo3N1ZLa09mSWp6WksxNTVWNThsclNGcmJ4T3hyZnAwbUZRcnNJc1VnQzNLV3h1NUw0allDN2cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJnN0YXRlPWg1Z1B2V1RzNmE0QjZzUkJQOE81SUh1NXNPcG1jZmVmMkx3TE9SMm4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996818),('dPiVDdyuGYY4XSuy7Va6N6SBusfdV3gxLzqosrvF',NULL,'190.232.29.255','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibDhmVFBKUUNxN0JYNmhSa2cxUkdQVWdxbjJtNDEyZDVXN0F6aUliaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUJmcWs1Z3pzMnRYcnVVWG1wUUY2YXJoUHhiNEZBS1pFTXM1UENUWG4zVDVNaVUtTTJuUUNaZFZ5OGdDTC1feVEmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPVBsOG1LTk5JR2FiQ0VSWmxGbTUwSlplODFHWjY2MldxQlU2Q1BxWEoiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759004377),('DrBz18XbrY8CEtVUQKlAMdzlBtZoRWqj8bBeR3Nm',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTlc2OGxSUDUxOUN5Z0k0WjJPdkFRbFJJY1FDMzhpSkdNR2w5YnE4QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTB3UnI2azJLd1gtcmpNNncxZ0RPU0Y0Y1NRRGNhVVVIQWt6cFVTdjU1SmNWQXlsbEdvOERONC11Ni0yVm1sdWcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJTIwb3BlbmlkJnN0YXRlPXRIRDVKbzRUR3dnQ3Y3NjRrME1WMENndEhIdVd0dVZYVFN3ZjlxNEYiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764114242),('fyv3Ho4sELpQ2pSyLlCIvvyO3D6pumK0LumoMoeL',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoieUdSSXMxVWhQbVVrRVd6cDZFRklpZTltQmVsSFRQREt3M0Ridk5VMiI7czo1OiJzdGF0ZSI7czo0MDoiVlZURDVLUHpoMDZZYVBRTlpGWUl6UUlKTnV4d21sbExDRExmMWRQWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996321),('HhqyzQaRuzxK4RBPFaZVMFMjnYHwKFcz3VprVwWi',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUxibjdzWEdOb2RZWnBLN1dSN0gySXg3SGw3TUFuMk1reGlpbFN4aCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTJpWW5mRDdHeXExVGNJMG9WMmRuUVhXV21sSDlBNW5fSkNwMjZYM19jM3VRQmVHTmk2dWRpc0dpS21oeHVEZ2cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPWdBS00zMGVoRkpJRTNqMXpFQ055SDZwd3FCcE9jQ3kya0xzYVp6bGwiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763995181),('hPCeRiEUWSCR29c6sGhyrytv2mdiJI19ac0doPx8',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiV2RNOWoxT1ZXYUxuSnllaDZDYnBHaWhhY25oMDFsZVFoMHR6WnpWaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTEmY29kZT00JTJGMEFiMzJqOTFNdTAtV1ZSY1VrT2pSRks3SlBTUkZEYkFIamtVTmxsSE5xSnNoNHVYdkVOdi0zMjN3TGxaS01lZzh5dUJRR2cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJTIwb3BlbmlkJnN0YXRlPWs2SlRROVZsd2VUQnp5WHkxTnB4eGw1RERoMzExbUkyakFjdnlnTFciO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762276140),('HUmbMiyiWdFVw1mEvbfYSK73ppda9M9cpH3fuClt',NULL,'38.255.107.170','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiV01zUkk1UlhTM2FVekIxakg4NUZJdmw0cFBSd2tHdW8xRDJBRE4xbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762286175),('j3LC4WVweuzKqvCXGzxyf9MW7uaXkRAYCTbiaIY2',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTFBCY0NtQlY1U1I1QlpEVEw0SjZweEVYMHFrQXFaaWFac0xxRGtLZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTEmY29kZT00JTJGMEFiMzJqOTFUUmYzTVhGV1cybzRIekpGMlRGM2xfcG85U1dmbXhTRFM0QW9sODFmQ0l3QlR3TDctb05IenBZTUpKMElQWHcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPW5zVDlwWGszamFsc3p3RU1yQXNPNmdKd0hncGFkSkdCWUZucldHYUYiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762293020),('LCZqaYXCGkLCjVVPgJ8D9toOelQ1GGORY1DOPIfC',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoidXprbHhzRmhUTmJtQXFDNExvR1E2Nks0SVVDMUFsQ0Mxd2RNRzg5MyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFqTEQ3eEk0T1FuRml5LTNpMkdaMHNuYjRBSVZ5QnNhTjFfTVFGV0QyZlh6dHdpOW1wT190UEdTVkY3YjVhM3cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPUJGcTNvYTQ3NFRTNkxXT1huT2ljTXZFczE2RVV3NWpjbnhnN3JVemQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764245633),('Mt6rzDSViIVcsqHc0uCb2HhebRvK3ye2fdoFaVPL',NULL,'201.230.8.125','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2xHSU1JaVFDYVM2Q0dHdk90Z21ROEpKVm1rb1dvQ1JhVDI0UXo2OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTJ0Vlc4bDVZRUpKblhWN2kyUlZGVW1ITUtrM3Q5azA3LWIyRHBDclZvQVlqcHBMQVJ4ZW9Sbm1MMHNITHJES1EmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPUxXYmI3Rm5RYTU1c3dJV0xPY3pWdUI0MmJxYk0wWXRqRW1WNzhZWnMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764269663),('mWhexWPssfQnN83e90Il4NcGDaTMnm87H9QlcoRH',NULL,'181.64.193.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVFA1TGliMXJ2UW8zTERXa3FXbTYzRDhhU3gwalNab2hZTDA0ZmVOVSI7czo1OiJzdGF0ZSI7czo0MDoiekM1aUFTRHBiMDFHUWNJeU1UWVVkNWoxZTE5dFVKNTI3SE9aWm40bCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1767376943),('N8vKMbX1pLAdUbDUshCGahEiO04SNQ3WtsagGBaN',NULL,'38.252.222.61','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiS25kMFB5cG5JQVNsTVhpMTk4MG9vR3NJcmFxNDRGRk9oTVdYdFF4VCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMURPUm1MRHRYMmVLeXFwaGJva3hQR3p4S0lhN3pCOTFaaHVkbkhCbDBZZThoTWl2TE5LT3lSTk15QXlBV0lMQ0EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPTUyR1JybHNTRDhqcUdSazJhbDIyOWxLNTVlTHk1eE0wMUwxSzZiR00iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759024823),('nFpQ62cosXeDetMKytocX5mukueayzPsiEvbSbv3',NULL,'38.25.25.252','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiNFBmSWhWUks3d1hjVXVaN2hTMHRMWDQ2OW4xbjM2QUE1Z0RlVjgwbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFwNUdGTmZvN2l3M1hpWkdvbU1YQkQ4TUY4RFhzUTBwMV84MG40b09IOU04eVFleDQ3bFAtd3loYktIWWpLc3cmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPTM3N0I1MWwyOTB6Z25XdmhMSnpFVHo1b2VlNGM0ZW1SQlFNVWlYV00iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762527772),('NLIS3N0H6Gn5UbbS3bPGnXorrh1Nd0T32DMm7zcg',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVmloWFcxWFlnb1pBcTF6ektFUkZKTXFHZHJDdjUzSzV1R0RZS0ZZUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTFnaVB5cWZ2Ujd4dl8zLUxNWWFTU0lCN2R2OHJWbTVKLWY0OEZSVUlCRVlaTkt4WU1YLUVsZ1Z6d3hTQjFoWXcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPThxUVN5emNIZGNzUGFTT2hlN05uZFVlN1hSSVdtNXlmMW9mUVJ1ZTEiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1764253014),('OejjUu7BMkJ5hlYZwDUkQl2KYni1BS9YIEMmwrOP',NULL,'190.216.191.102','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNW4wWUNYMVcwbUdaOXpGY3dDMlNhRmlPNGUzSUNzVm1FY1M2YnNjaCI7czo1OiJzdGF0ZSI7czo0MDoib2dYeExUV0tSMmh2bUdrMzA3RENTdzVoRE4xcE5OcExOTDlkU05USSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762527773),('OO2a5Tuefkoq0YgbhQc1SHqf53j0OW83JflTfpMh',NULL,'161.132.34.4','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiaXMyaEJtb0Q5Vk1lY3hiTUhxSUtZVmF3eE5CSzdmUmFtb29sRW5MbyI7czo1OiJzdGF0ZSI7czo0MDoiSDc4MGhFUDR4MUdKOGJGUnB5S3RXT0ROTkJ5c3dvVXR0MXVBdnpZNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1765575950),('sdZtAxnzdKKh4V6XH6N5G65X9PDEvKpxsy9xhM9E',NULL,'38.255.107.170','PostmanRuntime/7.49.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWkN5cDVJSWZFQTEwazNzbzhkMExJcTdtSkd0M3ZhZXdnZDlsck4zMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762286792),('tKAtKYb0i7zshjgpHkWU0yO0ftskbg92I3VXRiux',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTzYwSzFHZnk5NnVBcmRvUlFhVUROSG1qMmpxdHFETDdGVzhzeWh3eCI7czo1OiJzdGF0ZSI7czo0MDoiRnVxM05IMGhyTWlBY09Rdm9nQVhIcTYyYTdyVElRYUhER3RqUWpYUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO3M6NToicm91dGUiO3M6MTI6Imdvb2dsZS5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762292922),('UrzTwtoqmO1dbK8Q487ASjblj2eSpkDK7UxIpNJF',NULL,'38.255.107.234','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibHhaWnJvdmtCM21RbDFVQkQwVlVHSFVHbGdZdlp4Tll4WHluZ0pTMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFiMzJqOTF3U3NfamhoQzJpbnJkSnBZQldubGRsWXFEMVQ4UTBESGxHd0ZIc3luVkV4SWtFcHRHX21uN2NRU2xUSUkxLXcmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPURkSXBXN1AxblF5ejl0aWR6eWlpMjBTemM1VGdZaXM3YjNxdkhpNUMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1763996415),('Vfz10DP7bBn4yQlPJ0ET7rBOq8Z3HSr9iowcOf2t',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOVVwN291WUNQRlBJWVVXcllZOGYwc3dSVUpub2hucjFmRHBEbFlYbiI7czo1OiJzdGF0ZSI7czo0MDoiZlZybEZNa3FPUTF2NklUa0tJa2RIcGdBRzNEdWxDakNUd2R1ZFdMWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759160026),('x1LSwwfc5dj2h2S5R1ExUV9UbB8KOZqM4KBKGS0K',NULL,'38.255.107.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVJuSzltRDBMczgyT2d5czQ0bkx1NlJ3MjNZbGx3OExQNTdUaVZSQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTEmY29kZT00JTJGMEFiMzJqOTBIaE9TMUh6UHpUSS12YlMwMlVLRXhTX3F5LWxqM2VIU3dMTUtfQkY4WDR4bmJobklGcmxYVmtPQkdHOXRnTmcmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBvcGVuaWQlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPTB2aHRxdWNtajl4MHo0RlZzYlFBYlB4a2NsTWJqZW9WanZWOFdURE4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762357491),('zTdVeNPmGPZNPffukpabPLqhRO2C26wzUq5oG4L3',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiY1ZwM01FUXA0YmRPYXR4UFV3aTVrQWs5NmJwc2tDSElaWlMxazdyViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUN4dkJrWVJCV21EOEd0MUs2MGZHRHFFcjA3TDJLQy0wNThPQmhabU5iOWFLcmhzOVIzS3dCR1ZER2ZkUUVhR0EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPWkyRVp0R0NkM1poWHFXeEM2b29YenlsalFlalA1UmJVY0R5aDJkTW8iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759246465);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sunat_error_codes`
--

DROP TABLE IF EXISTS `sunat_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sunat_error_codes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `solucion_sugerida` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `comprobante_id` bigint unsigned NOT NULL,
  `tipo_operacion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'enviar',
  `estado` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_ticket` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_enviado` text COLLATE utf8mb4_unicode_ci,
  `xml_respuesta` text COLLATE utf8mb4_unicode_ci,
  `cdr_respuesta` text COLLATE utf8mb4_unicode_ci,
  `hash_firma` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje_sunat` text COLLATE utf8mb4_unicode_ci,
  `errores_sunat` text COLLATE utf8mb4_unicode_ci,
  `detalles_adicionales` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `fecha_respuesta` timestamp NULL DEFAULT NULL,
  `tiempo_respuesta_ms` int DEFAULT NULL,
  `ip_origen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sunat_logs_comprobante_id_index` (`comprobante_id`),
  KEY `sunat_logs_estado_index` (`estado`),
  KEY `sunat_logs_numero_ticket_index` (`numero_ticket`),
  KEY `sunat_logs_fecha_envio_index` (`fecha_envio`),
  KEY `sunat_logs_user_id_index` (`user_id`),
  CONSTRAINT `sunat_logs_comprobante_id_foreign` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sunat_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `sunat_logs_chk_1` CHECK (json_valid(`detalles_adicionales`))
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVA',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: Efectivo, Tarjeta, Yape, Plin',
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: efectivo, tarjeta, transferencia, yape, plin',
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `icono` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clase de icono (phosphor, fontawesome, etc)',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Para ordenar en el frontend',
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `icono` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id_ubigeo` bigint unsigned NOT NULL AUTO_INCREMENT,
  `departamento` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provincia` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `distrito` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Casa',
  `address_line` text COLLATE utf8mb4_unicode_ci,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `province` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Perú',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_addresses_user_id_foreign` (`user_id`) USING BTREE,
  CONSTRAINT `user_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_addresses`
--

LOCK TABLES `user_addresses` WRITE;
/*!40000 ALTER TABLE `user_addresses` DISABLE KEYS */;
INSERT INTO `user_addresses` VALUES (2,35,'Casa','dsfvdsvds','1994','1984','1917','32424','Perú',1,'2025-07-14 07:36:00','2025-07-14 07:36:00'),(3,36,'Casa','Santa Anita','1440','1403','1402',NULL,'Perú',0,'2025-12-26 14:13:04','2025-12-26 14:13:04'),(4,37,'Casa','San Borja','1433','1403','1402',NULL,'Perú',0,'2025-12-27 13:41:32','2025-12-27 13:41:32');
/*!40000 ALTER TABLE `user_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_cliente_direcciones`
--

DROP TABLE IF EXISTS `user_cliente_direcciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_cliente_direcciones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_cliente_id` bigint unsigned NOT NULL,
  `nombre_destinatario` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion_completa` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_ubigeo` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_postal` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `predeterminada` tinyint(1) NOT NULL DEFAULT '0',
  `activa` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_cliente_id` (`user_cliente_id`) USING BTREE,
  KEY `idx_predeterminada` (`predeterminada`) USING BTREE,
  KEY `idx_activa` (`activa`) USING BTREE,
  KEY `idx_ubigeo` (`id_ubigeo`) USING BTREE,
  CONSTRAINT `fk_user_cliente_direcciones_user_cliente` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_cliente_direcciones`
--

LOCK TABLES `user_cliente_direcciones` WRITE;
/*!40000 ALTER TABLE `user_cliente_direcciones` DISABLE KEYS */;
INSERT INTO `user_cliente_direcciones` VALUES (17,25,'José Alonso Morales Yangua','jdsdf',NULL,'2076',NULL,NULL,1,1,'2025-09-22 15:45:55','2025-09-22 15:45:55'),(19,27,'CARMEN ROSA LOPEZ GUERRERO','sfjskf',NULL,'635',NULL,NULL,1,1,'2025-09-22 17:18:40','2025-09-22 17:18:40'),(23,33,'JOHNY HUALLPA LOPEZ','sjfsf',NULL,'121',NULL,NULL,1,1,'2025-09-23 14:05:29','2025-09-23 14:05:29');
/*!40000 ALTER TABLE `user_cliente_direcciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_clientes`
--

DROP TABLE IF EXISTS `user_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_clientes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombres` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('masculino','femenino','otro') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_documento_id` bigint unsigned NOT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `verification_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verification_code` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_first_google_login` tinyint(1) DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `cliente_facturacion_id` bigint unsigned DEFAULT NULL COMMENT 'Referencia a tabla clientes para facturación',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_clientes`
--

LOCK TABLES `user_clientes` WRITE;
/*!40000 ALTER TABLE `user_clientes` DISABLE KEYS */;
INSERT INTO `user_clientes` VALUES (24,'Linder Lopez','Google','linsalo19b@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758555690','$2y$12$m6zXZwb/t0MPe9vrOSHhkOQArN00CyhqhoFGfgePNChom8QfdauZK','2025-09-22 08:41:30',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-22 08:41:30','2025-09-22 08:41:30'),(25,'José Alonso','Morales Yangua','chinchayjuan95@gmail.com','958478546',NULL,NULL,1,'73894795','$2y$12$VUbmaehtn8oFASYItw4Pg.EfJSaY2XYdQ61yorJegYzoRkkDye2DO',NULL,'q8J45LOckJWatOwbFO2jtDY3yweoxfNrD8EV2y8BakcdW2vCYQ77Rr88GyFE','8ICZNK',0,NULL,NULL,0,NULL,'2025-09-22 15:45:55','2025-09-22 15:45:55'),(27,'CARMEN ROSA','LOPEZ GUERRERO','cristiancamacaro360@gmail.com','94545436',NULL,NULL,1,'45674798','$2y$12$wva3gOCZLC5W89IOvvEzOeye/z6QQJr1k/A.NLPx4JlcD50KFrAna','2025-09-22 17:20:06',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-22 17:18:40','2025-09-22 17:20:06'),(30,'manuel aguado sierra','Google','umbrellasrl@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758641126','$2y$12$xzgJrZ8Pi5q3U8BuyOX/2OgbPTHEHSoVMe6v9X1JYoBxF3I3VZ5Yy','2025-09-23 08:25:26',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-23 08:25:26','2025-09-23 08:25:26'),(31,'kiyotaka hitori','Google','kiyotakahitori@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758647650','$2y$12$0wuYQJgC6GNFjgSnUxHuwOsstPJB5W3ryvpFdCUVDHPlN2RiMAUTS','2025-09-23 10:14:10',NULL,NULL,1,NULL,'/storage/clientes/1758647667_31.jpg',1,NULL,'2025-09-23 10:14:10','2025-09-23 10:14:27'),(33,'JOHNY','HUALLPA LOPEZ','anasilvia123vv@gmail.com','98545968',NULL,NULL,1,'44355989','$2y$12$jIhb7muvSY8oh47lGoIeSOwwXPG/qTRc1rzsNpO0fYk7qgzG99yme','2025-09-23 14:05:48',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-23 14:05:29','2025-09-23 14:05:48'),(34,'Alexander','Google','pieromorales1033@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759004376','$2y$12$Rs7OGG2u79yCz8ZRyCLMDeeuLBwBnKG.VIFP8oe/wnIhcVL4qE3u6','2025-09-27 13:19:36',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 13:19:36','2025-09-27 13:19:36'),(35,'Victor Canchari','Google','vcanchari38@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759024821','$2y$12$FaEL2UIE/CiJ7bQFD2NeRO1svLcVpNVnm5WYUS8sdA1hDaAX3jrTG','2025-09-27 19:00:21',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 19:00:21','2025-09-27 19:00:21'),(36,'Manuel Aguado','Google','systemcraft.pe@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759026505','$2y$12$9XNCRDImq9Z0sxRYA3FCxu2xQfdGd8O8e6eGOB034l.zL5GDNsIte','2025-09-27 19:28:25',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 19:28:25','2025-09-27 19:28:25'),(37,'EMER RODRIGO','YARLEQUE ZAPATA','rodrigoyarleque7@gmail.com','+51 993 321 920',NULL,NULL,1,'77425200','$2y$12$HrZBPY7Ru6IGzT0DFbwzEOdP1.nCr09x4HMQmu/YelOrQYEi7A12i','2025-10-29 23:37:52',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-29 10:32:20','2025-10-29 23:37:52'),(39,'ROGGER CESAR','CCORAHUA CORONADO','adan2025zapata@gmail.com','+51 993 321 920',NULL,NULL,1,'73425200','$2y$12$ajZvx2/5kc2HWyBfy.HQPu.VwpExk2LGLT60afjzjOHWltsAY4jLe',NULL,'qyQPs5p7lCPR5gKbPQjQuwyiKKe4gkYsUGQoxq9x8L55pjQsK6Of9xWpP2km','E02HCQ',0,NULL,NULL,0,NULL,'2025-09-29 10:38:53','2025-09-29 10:38:53'),(41,'rodrigo Emer','Google','emer17rodrigo@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1763996413','$2y$12$HPAu0jeDHmSEoJf6XLerteYQPPZpQbEUqjf/fXQA1qFsh6gql0NF2','2025-11-24 15:00:13',NULL,NULL,1,NULL,NULL,1,NULL,'2025-11-24 15:00:13','2025-11-24 15:00:13'),(42,'alondra quiroz loarte','Google','alquilo30@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1764269660','$2y$12$RUuQKCNjiDsT.N6z/rsUkOJngUt1CjrtiFXIvAv74oh3s/0Pjwije','2025-11-27 18:54:20',NULL,NULL,1,NULL,NULL,1,NULL,'2025-11-27 18:54:20','2025-11-27 18:54:20'),(49,'JOSEFA DEL PILAR','CHUMO SERRATO','yarlequerodrigo9@gmail.com','+51 993 321 920',NULL,NULL,1,'41214484','$2y$12$2ARsPdJQQsWK.eh7fl90geC7nBFAGVVNMh93KpWlvIEm7WbbZdGa.','2025-12-24 15:25:11',NULL,NULL,0,NULL,NULL,1,NULL,'2025-12-24 15:24:54','2025-12-24 15:25:11');
/*!40000 ALTER TABLE `user_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_horarios`
--

DROP TABLE IF EXISTS `user_horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_horarios` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `dia_semana` enum('lunes','martes','miercoles','jueves','viernes','sabado','domingo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `es_descanso` tinyint(1) DEFAULT '0',
  `fecha_especial` date DEFAULT NULL,
  `comentarios` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_horarios_user_dia` (`user_id`,`dia_semana`) USING BTREE,
  KEY `idx_user_horarios_fecha_especial` (`fecha_especial`) USING BTREE,
  KEY `idx_user_horarios_activo` (`activo`) USING BTREE,
  KEY `idx_user_horarios_disponibilidad` (`user_id`,`dia_semana`,`activo`) USING BTREE,
  CONSTRAINT `fk_user_horarios_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_hora_fin_mayor_inicio` CHECK ((`hora_fin` > `hora_inicio`))
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_horarios`
--

LOCK TABLES `user_horarios` WRITE;
/*!40000 ALTER TABLE `user_horarios` DISABLE KEYS */;
INSERT INTO `user_horarios` VALUES (32,36,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58'),(33,36,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58'),(34,36,'sabado','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58'),(35,36,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58'),(36,36,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58'),(37,36,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58'),(38,36,'domingo','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva - agregar',1,'2025-12-26 14:13:58','2025-12-26 14:13:58');
/*!40000 ALTER TABLE `user_horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_motorizados`
--

DROP TABLE IF EXISTS `user_motorizados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_motorizados` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `motorizado_id` bigint unsigned NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Usuario de login (ej: MOT-001)',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Usuario activo/inactivo',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
INSERT INTO `user_motorizados` VALUES (4,5,'akame17ga20kill@gmail.com','$2y$12$fT6q2KAEARTqRBfPYvcpK.5B/zk8N8Ml7ivqGgHCG.GLVTOtHWaca',1,'2025-09-29 08:56:53',NULL,'2025-09-29 08:56:03','2025-09-29 08:56:53'),(5,6,'magus@gmail.com','$2y$12$rdMF0OxL3txJKYuwKd5rV.hAQZ4LBJqRsFj83QwTK7irLzVX4gxPi',1,'2025-11-24 21:29:06',NULL,'2025-11-24 21:28:37','2026-01-03 13:50:27');
/*!40000 ALTER TABLE `user_motorizados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name_father` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name_mother` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date NOT NULL,
  `genero` enum('masculino','femenino','otro') COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_profiles_document_number_unique` (`document_number`) USING BTREE,
  KEY `user_profiles_user_id_foreign` (`user_id`) USING BTREE,
  CONSTRAINT `user_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
INSERT INTO `user_profiles` VALUES (3,35,'swedfsdvc','dsfvdfvs','sdfvdsf','993321920','3','77425200','2025-06-06','masculino','/storage/avatars/avatar_35_1749229676.jpg','2025-06-06 15:07:56','2025-06-06 15:07:56'),(4,36,'Manuel','Aguado','Sierra','972781904','1','42799312','1984-10-21','masculino','/storage/avatars/avatar_36_1766758384.jpg','2025-12-26 14:13:04','2025-12-26 14:13:04'),(5,37,'Leo','cgs',NULL,'972781904','1','42785159','1996-02-27','masculino',NULL,'2025-12-27 13:41:32','2025-12-27 13:41:32');
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `users_email_unique` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin Usuario','admin@example.com',NULL,'$2y$12$1HlGmMzDtit03XChNUfyh.2V1gpHtzwN/BdsJX4XRBvg/b0BGECd2',NULL,1,'2025-05-21 13:07:04','2025-05-21 18:08:35'),(29,'AlexanderFitgh','shinji@gmail.com',NULL,'$2y$12$GmHHsqbKf5SzTFsy.FKIVObmV1iy6H9mhUJH3gg6jvrs0OJrXFBee',NULL,1,'2025-06-03 23:05:50','2025-06-03 23:05:50'),(31,'Jonas','akdkre@gmail.com',NULL,'$2y$12$kUGXM6nNttS56LTXuWv6DeYko29OKB4ljrUIlLanp7PNqug4bSXnq',NULL,1,'2025-06-03 23:18:50','2025-06-03 23:18:50'),(32,'Test User','test@example.com','2025-06-05 16:59:56','$2y$12$LSvxM6fDnM5sPphz02V7F.f9lMK9HHPnio9Ky1TMxWK7K1X3lhMYm','u0CJ3CuGQu',1,'2025-06-05 16:59:56','2025-06-05 16:59:56'),(35,'emer1','kiyotakahitori@gmail.com',NULL,'7817b0c8a26139a4f1f3623c2932e7d016dd59b1',NULL,1,'2025-06-06 15:07:56','2025-06-06 15:07:56'),(36,'Tío Razor','manuel.aguado@magustechnologies.com',NULL,'$2y$12$LckilKodrE0AJTIWuXxkruw2bkQhSeJEsivNjvwG4ZqQAma.i2nsG',NULL,1,'2025-12-26 14:13:04','2025-12-26 14:13:04'),(37,'Leo','cgs@admin.com',NULL,'$2y$12$4.QNdP4Ea2iTMLEt9xhVW.bH1BMNiAIWHO6RkeQSH2gL/cbME3fPe',NULL,1,'2025-12-27 13:41:32','2025-12-27 13:41:32');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilidad_mensual`
--

DROP TABLE IF EXISTS `utilidad_mensual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilidad_mensual` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `mes` int NOT NULL,
  `anio` int NOT NULL,
  `total_ventas` decimal(12,2) NOT NULL,
  `total_costos` decimal(12,2) NOT NULL,
  `utilidad_bruta` decimal(12,2) NOT NULL,
  `margen_bruto_porcentaje` decimal(5,2) NOT NULL,
  `gastos_operativos` decimal(12,2) NOT NULL,
  `utilidad_operativa` decimal(12,2) NOT NULL,
  `margen_operativo_porcentaje` decimal(5,2) NOT NULL,
  `otros_ingresos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `otros_gastos` decimal(12,2) NOT NULL DEFAULT '0.00',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `producto_id` bigint unsigned NOT NULL,
  `fecha` date NOT NULL,
  `cantidad_vendida` int NOT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint unsigned NOT NULL,
  `comprobante_id` bigint unsigned DEFAULT NULL,
  `fecha_venta` date NOT NULL,
  `total_venta` decimal(12,2) NOT NULL,
  `costo_total` decimal(12,2) NOT NULL,
  `utilidad_bruta` decimal(12,2) NOT NULL,
  `margen_porcentaje` decimal(5,2) NOT NULL,
  `gastos_operativos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `utilidad_neta` decimal(12,2) NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `periodo` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Formato: YYYY-MM',
  `ingresos_totales` decimal(12,2) NOT NULL DEFAULT '0.00',
  `costos_ventas` decimal(12,2) NOT NULL DEFAULT '0.00',
  `gastos_operativos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `gastos_administrativos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `gastos_financieros` decimal(12,2) NOT NULL DEFAULT '0.00',
  `otros_ingresos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `otros_egresos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `utilidad_bruta` decimal(12,2) NOT NULL DEFAULT '0.00',
  `utilidad_operativa` decimal(12,2) NOT NULL DEFAULT '0.00',
  `utilidad_neta` decimal(12,2) NOT NULL DEFAULT '0.00',
  `margen_bruto` decimal(5,2) DEFAULT '0.00' COMMENT 'Porcentaje',
  `margen_operativo` decimal(5,2) DEFAULT '0.00' COMMENT 'Porcentaje',
  `margen_neto` decimal(5,2) DEFAULT '0.00' COMMENT 'Porcentaje',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venta_detalle_id` bigint unsigned NOT NULL COMMENT 'Detalle de venta (producto)',
  `venta_metodo_pago_id` bigint unsigned NOT NULL COMMENT 'Método de pago usado',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint unsigned NOT NULL,
  `tipo_item` enum('PRODUCTO','SERVICIO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PRODUCTO',
  `producto_id` bigint unsigned DEFAULT NULL,
  `servicio_id` bigint unsigned DEFAULT NULL,
  `codigo_producto` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_producto` text COLLATE utf8mb4_unicode_ci,
  `cantidad` decimal(12,4) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL COMMENT 'Precio unitario con IGV',
  `precio_sin_igv` decimal(12,2) NOT NULL COMMENT 'Precio unitario sin IGV',
  `descuento_unitario` decimal(12,2) NOT NULL DEFAULT '0.00',
  `subtotal_linea` decimal(12,2) NOT NULL COMMENT 'cantidad * precio_sin_igv - descuento',
  `igv_linea` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_linea` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_venta_id` (`venta_id`) USING BTREE,
  KEY `idx_producto_id` (`producto_id`) USING BTREE,
  KEY `venta_detalles_servicio_id_index` (`servicio_id`),
  KEY `venta_detalles_tipo_item_index` (`tipo_item`),
  CONSTRAINT `fk_venta_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_venta_detalles_venta_id` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `venta_detalles_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON UPDATE CASCADE
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint unsigned NOT NULL,
  `metodo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_venta` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL COMMENT 'Cliente del e-commerce',
  `fecha_venta` datetime NOT NULL,
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Sin IGV',
  `igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `descuento_total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','FACTURADO','ANULADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `comprobante_id` bigint unsigned DEFAULT NULL COMMENT 'Comprobante generado',
  `requiere_factura` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cliente pidió factura',
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'Usuario que registró (puede ser null para ventas web)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint unsigned NOT NULL,
  `cuenta_contable` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `debe` decimal(10,2) NOT NULL DEFAULT '0.00',
  `haber` decimal(10,2) NOT NULL DEFAULT '0.00',
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo` enum('PAGO_CLIENTE','PAGO_PROVEEDOR','DEPOSITO','TRANSFERENCIA','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_operacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `banco` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cuenta_origen` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cuenta_destino` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `archivo_voucher` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cuenta_por_cobrar_id` bigint unsigned DEFAULT NULL,
  `cuenta_por_pagar_id` bigint unsigned DEFAULT NULL,
  `venta_id` bigint unsigned DEFAULT NULL,
  `compra_id` bigint unsigned DEFAULT NULL,
  `estado` enum('PENDIENTE','VERIFICADO','RECHAZADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
  `verificado_por` bigint unsigned DEFAULT NULL,
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
/*!50001 VIEW `v_formas_envio_detalle` AS select `fe`.`id` AS `id`,`fe`.`departamento_id` AS `departamento_id`,`d`.`nombre` AS `departamento_nombre`,`fe`.`provincia_id` AS `provincia_id`,`p`.`nombre` AS `provincia_nombre`,`fe`.`distrito_id` AS `distrito_id`,`dist`.`nombre` AS `distrito_nombre`,`fe`.`costo` AS `costo`,`fe`.`activo` AS `activo`,`fe`.`created_at` AS `created_at`,`fe`.`updated_at` AS `updated_at`,(case when (`fe`.`distrito_id` is not null) then concat(`dist`.`nombre`,', ',`p`.`nombre`,', ',`d`.`nombre`) when (`fe`.`provincia_id` is not null) then concat(`p`.`nombre`,', ',`d`.`nombre`) else `d`.`nombre` end) AS `ubicacion_completa` from (((`forma_envios` `fe` left join `ubigeo_inei` `d` on((`fe`.`departamento_id` = concat(`d`.`departamento`,`d`.`provincia`,`d`.`distrito`)))) left join `ubigeo_inei` `p` on((`fe`.`provincia_id` = concat(`p`.`departamento`,`p`.`provincia`,`p`.`distrito`)))) left join `ubigeo_inei` `dist` on((`fe`.`distrito_id` = concat(`dist`.`departamento`,`dist`.`provincia`,`dist`.`distrito`)))) */;
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
/*!50001 VIEW `v_motorizados_activos` AS select `m`.`id` AS `id`,`m`.`numero_unidad` AS `numero_unidad`,`m`.`nombre_completo` AS `nombre_completo`,`m`.`foto_perfil` AS `foto_perfil`,`m`.`tipo_documento_id` AS `tipo_documento_id`,`m`.`numero_documento` AS `numero_documento`,`m`.`licencia_numero` AS `licencia_numero`,`m`.`licencia_categoria` AS `licencia_categoria`,`m`.`telefono` AS `telefono`,`m`.`correo` AS `correo`,`m`.`direccion_detalle` AS `direccion_detalle`,`m`.`ubigeo` AS `ubigeo`,`m`.`vehiculo_marca` AS `vehiculo_marca`,`m`.`vehiculo_modelo` AS `vehiculo_modelo`,`m`.`vehiculo_ano` AS `vehiculo_ano`,`m`.`vehiculo_cilindraje` AS `vehiculo_cilindraje`,`m`.`vehiculo_color_principal` AS `vehiculo_color_principal`,`m`.`vehiculo_color_secundario` AS `vehiculo_color_secundario`,`m`.`vehiculo_placa` AS `vehiculo_placa`,`m`.`vehiculo_motor` AS `vehiculo_motor`,`m`.`vehiculo_chasis` AS `vehiculo_chasis`,`m`.`comentario` AS `comentario`,`m`.`registrado_por` AS `registrado_por`,`m`.`user_motorizado_id` AS `user_motorizado_id`,`m`.`estado` AS `estado`,`m`.`created_at` AS `created_at`,`m`.`updated_at` AS `updated_at`,`um`.`username` AS `username`,`um`.`is_active` AS `user_active`,`um`.`last_login_at` AS `last_login_at`,`me`.`estado` AS `estado_actual`,`me`.`latitud` AS `latitud`,`me`.`longitud` AS `longitud`,`me`.`ultima_actividad` AS `ultima_actividad` from ((`motorizados` `m` left join `user_motorizados` `um` on((`m`.`user_motorizado_id` = `um`.`id`))) left join `motorizado_estados` `me` on((`m`.`id` = `me`.`motorizado_id`))) where ((`m`.`estado` = 1) and ((`um`.`is_active` = 1) or (`um`.`is_active` is null))) */;
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
/*!50001 VIEW `vista_estadisticas_cookies` AS select count(0) AS `total_usuarios`,sum((case when (`cookies_preferences`.`consintio_todo` = 1) then 1 else 0 end)) AS `aceptaron_todo`,sum((case when (`cookies_preferences`.`rechazo_todo` = 1) then 1 else 0 end)) AS `rechazaron_todo`,sum((case when (`cookies_preferences`.`personalizado` = 1) then 1 else 0 end)) AS `personalizaron`,sum((case when (`cookies_preferences`.`cookies_analiticas` = 1) then 1 else 0 end)) AS `aceptaron_analiticas`,sum((case when (`cookies_preferences`.`cookies_marketing` = 1) then 1 else 0 end)) AS `aceptaron_marketing`,sum((case when (`cookies_preferences`.`cookies_funcionales` = 1) then 1 else 0 end)) AS `aceptaron_funcionales`,avg(`cookies_preferences`.`numero_actualizaciones`) AS `promedio_actualizaciones`,round(((sum((case when (`cookies_preferences`.`consintio_todo` = 1) then 1 else 0 end)) / count(0)) * 100),2) AS `porcentaje_aceptacion_total`,round(((sum((case when (`cookies_preferences`.`cookies_analiticas` = 1) then 1 else 0 end)) / count(0)) * 100),2) AS `porcentaje_analiticas`,round(((sum((case when (`cookies_preferences`.`cookies_marketing` = 1) then 1 else 0 end)) / count(0)) * 100),2) AS `porcentaje_marketing`,cast(max(`cookies_preferences`.`created_at`) as date) AS `ultima_preferencia_registrada` from `cookies_preferences` where ((`cookies_preferences`.`fecha_expiracion` > now()) or (`cookies_preferences`.`fecha_expiracion` is null)) */;
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

-- Dump completed on 2026-01-10  0:36:59
