-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_bak_magus2
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
  `nombre_paso` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `descripcion_paso` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `es_requerido` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `arma_pc_configuracion_categoria_id_unique` (`categoria_id`) USING BTREE,
  KEY `arma_pc_configuracion_activo_orden_index` (`activo`,`orden`) USING BTREE,
  KEY `arma_pc_configuracion_categoria_id_foreign` (`categoria_id`) USING BTREE,
  CONSTRAINT `arma_pc_configuracion_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arma_pc_configuracion`
--

LOCK TABLES `arma_pc_configuracion` WRITE;
/*!40000 ALTER TABLE `arma_pc_configuracion` DISABLE KEYS */;
INSERT INTO `arma_pc_configuracion` VALUES (4,13,1,1,'2025-09-09 10:51:22','2025-09-09 10:51:22','Discos','Selecciona un componente de esta categoría',1),(5,11,2,1,'2025-09-09 10:51:22','2025-09-09 10:51:22','RAM','Selecciona un componente de esta categoría',1);
/*!40000 ALTER TABLE `arma_pc_configuracion` ENABLE KEYS */;
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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_banner_producto` (`banner_oferta_id`,`producto_id`) USING BTREE,
  KEY `producto_id` (`producto_id`) USING BTREE,
  CONSTRAINT `banner_oferta_producto_ibfk_1` FOREIGN KEY (`banner_oferta_id`) REFERENCES `banners_ofertas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `banner_oferta_producto_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner_oferta_producto`
--

LOCK TABLES `banner_oferta_producto` WRITE;
/*!40000 ALTER TABLE `banner_oferta_producto` DISABLE KEYS */;
INSERT INTO `banner_oferta_producto` VALUES (1,1,63,10.00,'2025-10-03 09:18:52','2025-10-03 09:18:52'),(2,1,66,15.00,'2025-10-03 09:19:03','2025-10-03 09:19:03'),(3,1,62,20.00,'2025-10-03 09:19:13','2025-10-03 09:19:13'),(4,1,71,10.00,'2025-10-03 09:19:27','2025-10-03 09:19:27'),(5,1,67,30.00,'2025-10-03 09:19:37','2025-10-03 09:19:37');
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
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `texto_boton` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Explorar Tienda',
  `precio_desde` decimal(10,2) DEFAULT NULL,
  `imagen_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enlace_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '/shop',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `orden` int NOT NULL DEFAULT '0',
  `tipo_banner` enum('principal','horizontal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'principal' COMMENT 'Tipo de banner: principal (carrusel) u horizontal (banners de página)',
  `posicion_horizontal` enum('debajo_ofertas_especiales','debajo_categorias','debajo_ventas_flash') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Posición del banner horizontal en el index (solo aplica si tipo_banner=horizontal)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `banners_activo_orden_index` (`activo`,`orden`) USING BTREE,
  KEY `idx_banners_tipo_posicion` (`tipo_banner`,`posicion_horizontal`,`activo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
INSERT INTO `banners` VALUES (9,'Banner 1758895369674',NULL,NULL,'Ver más',NULL,'banners/1758889393_68d685b124ddc.webp','/product-details/15',1,1,'principal',NULL,'2025-09-26 05:23:13','2025-09-26 07:02:48'),(10,'Banner 1758889408145',NULL,NULL,'Ver más',NULL,'banners/1758889407_68d685bfb3406.webp','/shop',1,1,'principal',NULL,'2025-09-26 05:23:27','2025-09-26 05:23:27'),(13,'Banner 1758890742019',NULL,NULL,'Ver más',NULL,'banners/1758890743_68d68af718d53.png','/shop',1,1,'principal',NULL,'2025-09-26 05:45:43','2025-09-26 05:45:43'),(14,'Banner 1758890938835',NULL,NULL,'Ver más',NULL,'banners/1758890939_68d68bbb85b5c.png','/shop',1,1,'principal',NULL,'2025-09-26 05:46:44','2025-09-26 05:48:59'),(16,'Banner Debajo de Ofertas Especiales',NULL,NULL,'Ver más',NULL,'banners/1759616332_68e19d4c517d5.webp','/shop',1,2,'horizontal','debajo_ofertas_especiales','2025-10-04 15:18:52','2025-10-04 15:18:52'),(17,'Banner Debajo de Categorías',NULL,NULL,'Ver más',NULL,'banners/1759616415_68e19d9fb6722.webp','/shop',1,1,'horizontal','debajo_categorias','2025-10-04 15:20:15','2025-10-04 15:20:15');
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
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Imagen de fondo del banner flash sale',
  `color_boton` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Color hexadecimal del botón',
  `texto_boton` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Compra ahora',
  `enlace_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_activo_fechas` (`activo`,`fecha_inicio`,`fecha_fin`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners_flash_sales`
--

LOCK TABLES `banners_flash_sales` WRITE;
/*!40000 ALTER TABLE `banners_flash_sales` DISABLE KEYS */;
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
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `prioridad` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `precio` decimal(8,2) DEFAULT NULL,
  `texto_boton` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'Comprar ahora',
  `imagen_url` varchar(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `enlace_url` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '/shop',
  `orden` int NOT NULL DEFAULT '1',
  `animacion_delay` int NOT NULL DEFAULT '400',
  `color_fondo` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '#ffffff',
  `color_boton` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '#0d6efd',
  `color_texto` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '#212529',
  `color_badge_nombre` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '#0d6efd',
  `color_badge_precio` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '#28a745',
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
INSERT INTO `banners_promocionales` VALUES (2,'Amd Ryzen 7',500.00,'Ir a la oferta','banners_promocionales/1758851690_68d5f26aac356.jpg','https://www.plazavea.com.pe/panaderia-y-pasteleria/pan-de-la-casa?srsltid=AfmBOoo9YK35mmSlRKy_JC302mvr-VBURC10nZC2iNz8dcDNSFqBIhL8',1,400,'#ffffff','#ff1100','#ffffff','#0d6efd','#28a745',1,'2025-06-07 11:49:44','2025-09-30 08:15:24'),(3,'Laptop Asus TUF',300.00,'LAPTOP ASUS TUF','banners_promocionales/1759245539_68dbf4e342d7f.jpg','/shop',1,300,'#ffea00','#fa0000','#000000','#0d6efd','#28a745',1,'2025-06-07 11:51:35','2025-10-01 14:15:21'),(4,'lenovo',300.00,'Comprar ahora','banners_promocionales/1751659647_6868347fa4a7c.png','/shop',1,300,'#ffffff','#0d6efd','#212529','#0d6efd','#28a745',1,'2025-06-07 11:53:48','2025-07-04 18:14:32'),(6,'OFERTA GAMER',600.00,'Comprar ahora','banners_promocionales/1751659657_68683489c4c4f.png','/shop',1,400,'#ffffff','#0d6efd','#212529','#0d6efd','#28a745',1,'2025-06-07 12:49:36','2025-07-04 18:14:43');
/*!40000 ALTER TABLE `banners_promocionales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel_cache_recompensas_dashboard_2025-09-25-21','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:6;s:21:\"conversiones_por_tipo\";a:0:{}}}',1758857034),('laravel_cache_recompensas_dashboard_2025-09-26-11','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:6;s:21:\"conversiones_por_tipo\";a:0:{}}}',1758908192),('laravel_cache_recompensas_dashboard_2025-09-26-19','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:6;s:21:\"conversiones_por_tipo\";a:0:{}}}',1758936017),('laravel_cache_recompensas_dashboard_2025-09-27-14','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:6;s:21:\"conversiones_por_tipo\";a:0:{}}}',1759006223),('laravel_cache_recompensas_dashboard_2025-09-27-21','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:8;s:21:\"conversiones_por_tipo\";a:0:{}}}',1759028481),('laravel_cache_recompensas_dashboard_2025-10-02-21','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:10;s:21:\"conversiones_por_tipo\";a:0:{}}}',1759460842),('laravel_cache_recompensas_dashboard_2025-10-03-11','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:10;s:21:\"conversiones_por_tipo\";a:0:{}}}',1759511834),('laravel_cache_recompensas_dashboard_2025-10-04-11','a:6:{s:17:\"resumen_ejecutivo\";a:5:{s:16:\"aplicaciones_mes\";i:0;s:20:\"clientes_activos_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;s:11:\"crecimiento\";a:3:{s:12:\"aplicaciones\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:8:\"clientes\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}s:6:\"puntos\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:22:\"participacion_clientes\";d:0;}s:20:\"metricas_principales\";a:6:{s:19:\"recompensas_totales\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:20:\"utilizacion_promedio\";d:0;s:19:\"efectividad_general\";d:0;s:12:\"roi_estimado\";a:3:{s:14:\"costo_estimado\";d:0;s:18:\"beneficio_estimado\";d:0;s:14:\"roi_porcentaje\";i:0;}}s:20:\"tendencias_mensuales\";a:0:{}s:15:\"top_recompensas\";a:0:{}s:16:\"segmentacion_uso\";a:0:{}s:16:\"conversion_rates\";a:4:{s:13:\"tasa_adopcion\";d:0;s:16:\"clientes_activos\";i:0;s:16:\"clientes_totales\";i:10;s:21:\"conversiones_por_tipo\";a:0:{}}}',1759598848),('laravel_cache_recompensas_estadisticas_2025-09-25-21','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-09-26T02:23:40.364455Z\";s:11:\"cache_hasta\";s:27:\"2025-09-26T04:23:40.364704Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1758860620),('laravel_cache_recompensas_estadisticas_2025-09-26-09','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-09-26T14:29:20.240941Z\";s:11:\"cache_hasta\";s:27:\"2025-09-26T16:29:20.241103Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1758904160),('laravel_cache_recompensas_estadisticas_2025-09-26-11','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-09-26T16:36:38.189426Z\";s:11:\"cache_hasta\";s:27:\"2025-09-26T18:36:38.189648Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1758911798),('laravel_cache_recompensas_estadisticas_2025-09-26-19','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-09-27T00:20:11.473483Z\";s:11:\"cache_hasta\";s:27:\"2025-09-27T02:20:11.473707Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1758939611),('laravel_cache_recompensas_estadisticas_2025-09-27-14','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-09-27T19:50:05.044651Z\";s:11:\"cache_hasta\";s:27:\"2025-09-27T21:50:05.044936Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759009805),('laravel_cache_recompensas_estadisticas_2025-09-27-21','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-09-28T02:01:10.837314Z\";s:11:\"cache_hasta\";s:27:\"2025-09-28T04:01:10.837860Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759032070),('laravel_cache_recompensas_estadisticas_2025-10-02-10','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-10-02T15:33:52.132387Z\";s:11:\"cache_hasta\";s:27:\"2025-10-02T17:33:52.132657Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759426432),('laravel_cache_recompensas_estadisticas_2025-10-02-21','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-10-03T02:07:16.848715Z\";s:11:\"cache_hasta\";s:27:\"2025-10-03T04:07:16.849640Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759464436),('laravel_cache_recompensas_estadisticas_2025-10-03-11','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-10-03T16:16:22.623200Z\";s:11:\"cache_hasta\";s:27:\"2025-10-03T18:16:22.623474Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759515382),('laravel_cache_recompensas_estadisticas_2025-10-06-05','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:1;s:19:\"recompensas_activas\";i:1;s:20:\"recompensas_vigentes\";i:1;s:15:\"tasa_activacion\";d:100;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:1;s:7:\"activas\";i:1;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:1:{i:0;O:8:\"stdClass\":5:{s:2:\"id\";i:1;s:6:\"nombre\";s:17:\"Descuentos de 10%\";s:4:\"tipo\";s:9:\"descuento\";s:18:\"total_aplicaciones\";i:0;s:15:\"clientes_unicos\";i:0;}}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-10-06T10:51:25.879815Z\";s:11:\"cache_hasta\";s:27:\"2025-10-06T12:51:25.879939Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759755085),('laravel_cache_recompensas_estadisticas_2025-10-06-09','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:3;s:19:\"recompensas_activas\";i:3;s:20:\"recompensas_vigentes\";i:3;s:15:\"tasa_activacion\";d:100;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:3;s:7:\"activas\";i:3;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:3:{i:0;O:8:\"stdClass\":5:{s:2:\"id\";i:3;s:6:\"nombre\";s:37:\"Descuentos de 10% por compras del 300\";s:4:\"tipo\";s:9:\"descuento\";s:18:\"total_aplicaciones\";i:0;s:15:\"clientes_unicos\";i:0;}i:1;O:8:\"stdClass\":5:{s:2:\"id\";i:2;s:6:\"nombre\";s:17:\"Descuentos de 10%\";s:4:\"tipo\";s:9:\"descuento\";s:18:\"total_aplicaciones\";i:0;s:15:\"clientes_unicos\";i:0;}i:2;O:8:\"stdClass\":5:{s:2:\"id\";i:1;s:6:\"nombre\";s:17:\"Descuentos de 10%\";s:4:\"tipo\";s:9:\"descuento\";s:18:\"total_aplicaciones\";i:0;s:15:\"clientes_unicos\";i:0;}}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-10-06T14:21:23.861690Z\";s:11:\"cache_hasta\";s:27:\"2025-10-06T16:21:23.861803Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759767683),('laravel_cache_recompensas_estadisticas_2025-10-06-10','a:6:{s:7:\"resumen\";a:4:{s:17:\"total_recompensas\";i:0;s:19:\"recompensas_activas\";i:0;s:20:\"recompensas_vigentes\";i:0;s:15:\"tasa_activacion\";i:0;}s:8:\"por_tipo\";a:4:{s:6:\"puntos\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:9:\"descuento\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:12:\"envio_gratis\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}s:6:\"regalo\";a:4:{s:5:\"total\";i:0;s:7:\"activas\";i:0;s:16:\"aplicaciones_mes\";i:0;s:20:\"puntos_otorgados_mes\";i:0;}}s:10:\"mes_actual\";a:4:{s:12:\"aplicaciones\";i:0;s:16:\"puntos_otorgados\";N;s:21:\"clientes_beneficiados\";i:0;s:30:\"promedio_puntos_por_aplicacion\";d:0;}s:24:\"comparativa_mes_anterior\";a:3:{s:12:\"aplicaciones\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:8:\"clientes\";a:3:{s:6:\"actual\";d:0;s:8:\"anterior\";d:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}s:6:\"puntos\";a:3:{s:6:\"actual\";i:0;s:8:\"anterior\";i:0;s:9:\"tendencia\";a:3:{s:10:\"porcentaje\";i:0;s:9:\"direccion\";s:7:\"estable\";s:10:\"diferencia\";i:0;}}}s:19:\"top_recompensas_mes\";a:0:{}s:8:\"metadata\";a:3:{s:11:\"generado_en\";s:27:\"2025-10-06T15:31:43.299624Z\";s:11:\"cache_hasta\";s:27:\"2025-10-06T17:31:43.299861Z\";s:16:\"periodo_analisis\";s:17:\"Últimos 12 meses\";}}',1759771903),('laravel_cache_recompensas_tipos_disponibles','a:2:{s:5:\"tipos\";a:4:{i:0;a:4:{s:5:\"value\";s:6:\"puntos\";s:5:\"label\";s:17:\"Sistema de Puntos\";s:11:\"descripcion\";s:54:\"Acumula puntos por compras y canjéalos por beneficios\";s:20:\"campos_configuracion\";a:3:{i:0;a:6:{s:5:\"campo\";s:17:\"puntos_por_compra\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:32:\"Puntos otorgados por cada compra\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}i:1;a:6:{s:5:\"campo\";s:16:\"puntos_por_monto\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:27:\"Puntos por cada sol gastado\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}i:2;a:6:{s:5:\"campo\";s:15:\"puntos_registro\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:31:\"Puntos otorgados al registrarse\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}}}i:1;a:4:{s:5:\"value\";s:9:\"descuento\";s:5:\"label\";s:10:\"Descuentos\";s:11:\"descripcion\";s:48:\"Aplica descuentos por porcentaje o cantidad fija\";s:20:\"campos_configuracion\";a:3:{i:0;a:5:{s:5:\"campo\";s:14:\"tipo_descuento\";s:4:\"tipo\";s:4:\"enum\";s:8:\"opciones\";a:2:{i:0;s:10:\"porcentaje\";i:1;s:13:\"cantidad_fija\";}s:11:\"descripcion\";s:27:\"Tipo de descuento a aplicar\";s:9:\"requerido\";b:1;}i:1;a:6:{s:5:\"campo\";s:15:\"valor_descuento\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:19:\"Valor del descuento\";s:9:\"requerido\";b:1;s:3:\"min\";d:0.01;s:3:\"max\";d:9999.99;}i:2;a:6:{s:5:\"campo\";s:13:\"compra_minima\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:24:\"Compra mínima requerida\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}}}i:2;a:4:{s:5:\"value\";s:12:\"envio_gratis\";s:5:\"label\";s:15:\"Envío Gratuito\";s:11:\"descripcion\";s:51:\"Ofrece envío gratuito con condiciones específicas\";s:20:\"campos_configuracion\";a:2:{i:0;a:6:{s:5:\"campo\";s:13:\"minimo_compra\";s:4:\"tipo\";s:7:\"decimal\";s:11:\"descripcion\";s:35:\"Compra mínima para envío gratuito\";s:9:\"requerido\";b:0;s:3:\"min\";i:0;s:3:\"max\";d:9999.99;}i:1;a:4:{s:5:\"campo\";s:16:\"zonas_aplicables\";s:4:\"tipo\";s:4:\"json\";s:11:\"descripcion\";s:37:\"Zonas donde aplica el envío gratuito\";s:9:\"requerido\";b:0;}}}i:3;a:4:{s:5:\"value\";s:6:\"regalo\";s:5:\"label\";s:19:\"Productos de Regalo\";s:11:\"descripcion\";s:41:\"Otorga productos específicos como regalo\";s:20:\"campos_configuracion\";a:2:{i:0;a:4:{s:5:\"campo\";s:11:\"producto_id\";s:4:\"tipo\";s:7:\"integer\";s:11:\"descripcion\";s:25:\"ID del producto a regalar\";s:9:\"requerido\";b:1;}i:1;a:6:{s:5:\"campo\";s:8:\"cantidad\";s:4:\"tipo\";s:7:\"integer\";s:11:\"descripcion\";s:31:\"Cantidad del producto a regalar\";s:9:\"requerido\";b:1;s:3:\"min\";i:1;s:3:\"max\";i:100;}}}}s:7:\"estados\";a:5:{i:0;a:3:{s:5:\"value\";s:10:\"programada\";s:5:\"label\";s:10:\"Programada\";s:11:\"descripcion\";s:32:\"Recompensa creada pero no activa\";}i:1;a:3:{s:5:\"value\";s:6:\"activa\";s:5:\"label\";s:6:\"Activa\";s:11:\"descripcion\";s:30:\"Recompensa activa y disponible\";}i:2;a:3:{s:5:\"value\";s:7:\"pausada\";s:5:\"label\";s:7:\"Pausada\";s:11:\"descripcion\";s:32:\"Recompensa temporalmente pausada\";}i:3;a:3:{s:5:\"value\";s:8:\"expirada\";s:5:\"label\";s:8:\"Expirada\";s:11:\"descripcion\";s:29:\"Recompensa expirada por fecha\";}i:4;a:3:{s:5:\"value\";s:9:\"cancelada\";s:5:\"label\";s:9:\"Cancelada\";s:11:\"descripcion\";s:36:\"Recompensa cancelada permanentemente\";}}}',1759851107),('laravel_cache_spatie.permission.cache','a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:143:{i:0;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:12:\"usuarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:1;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:15:\"usuarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:2;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:13:\"usuarios.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:3;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:13:\"usuarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:4;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:15:\"usuarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:5;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:13:\"productos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:6;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:16:\"productos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:7;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:14:\"productos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:8;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:14:\"productos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:9;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:16:\"productos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:10;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:14:\"categorias.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:11;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:17:\"categorias.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:12;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:15:\"categorias.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:13;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:15:\"categorias.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:14;a:4:{s:1:\"a\";i:29;s:1:\"b\";s:17:\"categorias.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:15;a:4:{s:1:\"a\";i:30;s:1:\"b\";s:11:\"banners.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:16;a:4:{s:1:\"a\";i:31;s:1:\"b\";s:14:\"banners.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:17;a:4:{s:1:\"a\";i:32;s:1:\"b\";s:12:\"banners.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:18;a:4:{s:1:\"a\";i:33;s:1:\"b\";s:14:\"banners.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:19;a:4:{s:1:\"a\";i:38;s:1:\"b\";s:25:\"banners_promocionales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:20;a:4:{s:1:\"a\";i:39;s:1:\"b\";s:28:\"banners_promocionales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:21;a:4:{s:1:\"a\";i:40;s:1:\"b\";s:26:\"banners_promocionales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:22;a:4:{s:1:\"a\";i:41;s:1:\"b\";s:28:\"banners_promocionales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:23;a:4:{s:1:\"a\";i:42;s:1:\"b\";s:12:\"clientes.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:24;a:3:{s:1:\"a\";i:43;s:1:\"b\";s:15:\"clientes.create\";s:1:\"c\";s:3:\"web\";}i:25;a:4:{s:1:\"a\";i:44;s:1:\"b\";s:13:\"clientes.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:26;a:4:{s:1:\"a\";i:45;s:1:\"b\";s:13:\"clientes.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:27;a:4:{s:1:\"a\";i:46;s:1:\"b\";s:15:\"clientes.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:28;a:4:{s:1:\"a\";i:47;s:1:\"b\";s:13:\"marcas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:29;a:4:{s:1:\"a\";i:48;s:1:\"b\";s:13:\"marcas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:30;a:4:{s:1:\"a\";i:49;s:1:\"b\";s:11:\"marcas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:31;a:4:{s:1:\"a\";i:50;s:1:\"b\";s:10:\"marcas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:32;a:4:{s:1:\"a\";i:51;s:1:\"b\";s:14:\"pedidos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:33;a:4:{s:1:\"a\";i:52;s:1:\"b\";s:12:\"pedidos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:34;a:4:{s:1:\"a\";i:53;s:1:\"b\";s:12:\"pedidos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:35;a:4:{s:1:\"a\";i:54;s:1:\"b\";s:11:\"pedidos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:36;a:4:{s:1:\"a\";i:55;s:1:\"b\";s:16:\"secciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:37;a:4:{s:1:\"a\";i:56;s:1:\"b\";s:16:\"secciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:38;a:4:{s:1:\"a\";i:57;s:1:\"b\";s:14:\"secciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:39;a:4:{s:1:\"a\";i:58;s:1:\"b\";s:13:\"secciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:40;a:4:{s:1:\"a\";i:59;s:1:\"b\";s:11:\"cupones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:41;a:3:{s:1:\"a\";i:60;s:1:\"b\";s:12:\"cupones.show\";s:1:\"c\";s:3:\"web\";}i:42;a:4:{s:1:\"a\";i:61;s:1:\"b\";s:12:\"cupones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:43;a:4:{s:1:\"a\";i:62;s:1:\"b\";s:14:\"cupones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:44;a:4:{s:1:\"a\";i:63;s:1:\"b\";s:14:\"cupones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:45;a:4:{s:1:\"a\";i:64;s:1:\"b\";s:11:\"ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:46;a:4:{s:1:\"a\";i:65;s:1:\"b\";s:12:\"ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:47;a:3:{s:1:\"a\";i:66;s:1:\"b\";s:12:\"ofertas.show\";s:1:\"c\";s:3:\"web\";}i:48;a:4:{s:1:\"a\";i:67;s:1:\"b\";s:14:\"ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:49;a:4:{s:1:\"a\";i:68;s:1:\"b\";s:14:\"ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:50;a:4:{s:1:\"a\";i:69;s:1:\"b\";s:12:\"horarios.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:51;a:4:{s:1:\"a\";i:70;s:1:\"b\";s:15:\"horarios.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:52;a:3:{s:1:\"a\";i:71;s:1:\"b\";s:13:\"horarios.show\";s:1:\"c\";s:3:\"web\";}i:53;a:4:{s:1:\"a\";i:72;s:1:\"b\";s:13:\"horarios.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:54;a:4:{s:1:\"a\";i:73;s:1:\"b\";s:15:\"horarios.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:55;a:4:{s:1:\"a\";i:74;s:1:\"b\";s:16:\"empresa_info.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:56;a:4:{s:1:\"a\";i:75;s:1:\"b\";s:17:\"empresa_info.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:57;a:4:{s:1:\"a\";i:76;s:1:\"b\";s:17:\"envio_correos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:58;a:4:{s:1:\"a\";i:77;s:1:\"b\";s:18:\"envio_correos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:59;a:4:{s:1:\"a\";i:78;s:1:\"b\";s:12:\"reclamos.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:60;a:4:{s:1:\"a\";i:79;s:1:\"b\";s:13:\"reclamos.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:61;a:4:{s:1:\"a\";i:80;s:1:\"b\";s:13:\"reclamos.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:62;a:4:{s:1:\"a\";i:81;s:1:\"b\";s:15:\"reclamos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:63;a:4:{s:1:\"a\";i:86;s:1:\"b\";s:16:\"cotizaciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:64;a:4:{s:1:\"a\";i:87;s:1:\"b\";s:17:\"cotizaciones.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:65;a:4:{s:1:\"a\";i:88;s:1:\"b\";s:19:\"cotizaciones.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:66;a:4:{s:1:\"a\";i:89;s:1:\"b\";s:17:\"cotizaciones.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:67;a:4:{s:1:\"a\";i:90;s:1:\"b\";s:19:\"cotizaciones.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:68;a:3:{s:1:\"a\";i:91;s:1:\"b\";s:20:\"cotizaciones.aprobar\";s:1:\"c\";s:3:\"web\";}i:69;a:4:{s:1:\"a\";i:92;s:1:\"b\";s:11:\"compras.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:70;a:4:{s:1:\"a\";i:93;s:1:\"b\";s:12:\"compras.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:71;a:3:{s:1:\"a\";i:94;s:1:\"b\";s:14:\"compras.create\";s:1:\"c\";s:3:\"web\";}i:72;a:4:{s:1:\"a\";i:95;s:1:\"b\";s:12:\"compras.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:73;a:4:{s:1:\"a\";i:96;s:1:\"b\";s:14:\"compras.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:74;a:4:{s:1:\"a\";i:97;s:1:\"b\";s:15:\"compras.aprobar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:75;a:4:{s:1:\"a\";i:98;s:1:\"b\";s:20:\"envio_correos.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:76;a:4:{s:1:\"a\";i:99;s:1:\"b\";s:20:\"envio_correos.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:77;a:4:{s:1:\"a\";i:100;s:1:\"b\";s:15:\"motorizados.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:78;a:4:{s:1:\"a\";i:101;s:1:\"b\";s:18:\"motorizados.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:79;a:4:{s:1:\"a\";i:102;s:1:\"b\";s:16:\"motorizados.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:80;a:4:{s:1:\"a\";i:103;s:1:\"b\";s:16:\"motorizados.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:81;a:4:{s:1:\"a\";i:104;s:1:\"b\";s:18:\"motorizados.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:82;a:4:{s:1:\"a\";i:105;s:1:\"b\";s:22:\"pedidos.motorizado.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:83;a:4:{s:1:\"a\";i:106;s:1:\"b\";s:22:\"pedidos.motorizado.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:84;a:4:{s:1:\"a\";i:107;s:1:\"b\";s:36:\"pedidos.motorizado.actualizar_estado\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:85;a:4:{s:1:\"a\";i:108;s:1:\"b\";s:36:\"pedidos.motorizado.actualizar_estado\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:86;a:4:{s:1:\"a\";i:109;s:1:\"b\";s:36:\"pedidos.motorizado.confirmar_entrega\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:87;a:4:{s:1:\"a\";i:110;s:1:\"b\";s:36:\"pedidos.motorizado.confirmar_entrega\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:88;a:4:{s:1:\"a\";i:111;s:1:\"b\";s:21:\"motorizado.perfil.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:89;a:4:{s:1:\"a\";i:112;s:1:\"b\";s:21:\"motorizado.perfil.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:90;a:4:{s:1:\"a\";i:113;s:1:\"b\";s:24:\"motorizado.perfil.editar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:91;a:4:{s:1:\"a\";i:114;s:1:\"b\";s:24:\"motorizado.perfil.editar\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:92;a:4:{s:1:\"a\";i:115;s:1:\"b\";s:20:\"motorizado.rutas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:93;a:4:{s:1:\"a\";i:116;s:1:\"b\";s:20:\"motorizado.rutas.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:94;a:4:{s:1:\"a\";i:117;s:1:\"b\";s:31:\"motorizado.ubicacion.actualizar\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:95;a:4:{s:1:\"a\";i:118;s:1:\"b\";s:31:\"motorizado.ubicacion.actualizar\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:96;a:4:{s:1:\"a\";i:119;s:1:\"b\";s:27:\"motorizado.estadisticas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:97;a:4:{s:1:\"a\";i:120;s:1:\"b\";s:27:\"motorizado.estadisticas.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:98;a:4:{s:1:\"a\";i:121;s:1:\"b\";s:19:\"motorizado.chat.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:99;a:4:{s:1:\"a\";i:122;s:1:\"b\";s:19:\"motorizado.chat.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:100;a:4:{s:1:\"a\";i:123;s:1:\"b\";s:29:\"motorizado.notificaciones.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:4;}}i:101;a:4:{s:1:\"a\";i:124;s:1:\"b\";s:29:\"motorizado.notificaciones.ver\";s:1:\"c\";s:7:\"sanctum\";s:1:\"r\";a:1:{i:0;i:5;}}i:102;a:4:{s:1:\"a\";i:125;s:1:\"b\";s:19:\"email_templates.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:103;a:4:{s:1:\"a\";i:126;s:1:\"b\";s:20:\"email_templates.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:104;a:4:{s:1:\"a\";i:127;s:1:\"b\";s:22:\"email_templates.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:105;a:4:{s:1:\"a\";i:128;s:1:\"b\";s:20:\"email_templates.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:106;a:4:{s:1:\"a\";i:129;s:1:\"b\";s:22:\"email_templates.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:107;a:4:{s:1:\"a\";i:130;s:1:\"b\";s:10:\"ventas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:108;a:4:{s:1:\"a\";i:131;s:1:\"b\";s:11:\"ventas.show\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:109;a:4:{s:1:\"a\";i:132;s:1:\"b\";s:13:\"ventas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:110;a:4:{s:1:\"a\";i:133;s:1:\"b\";s:11:\"ventas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:111;a:4:{s:1:\"a\";i:134;s:1:\"b\";s:13:\"ventas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:112;a:4:{s:1:\"a\";i:135;s:1:\"b\";s:9:\"roles.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:113;a:4:{s:1:\"a\";i:136;s:1:\"b\";s:12:\"roles.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:114;a:4:{s:1:\"a\";i:137;s:1:\"b\";s:10:\"roles.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:115;a:4:{s:1:\"a\";i:138;s:1:\"b\";s:12:\"roles.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:116;a:3:{s:1:\"a\";i:139;s:1:\"b\";s:15:\"recompensas.ver\";s:1:\"c\";s:3:\"web\";}i:117;a:3:{s:1:\"a\";i:140;s:1:\"b\";s:18:\"recompensas.create\";s:1:\"c\";s:3:\"web\";}i:118;a:3:{s:1:\"a\";i:141;s:1:\"b\";s:16:\"recompensas.show\";s:1:\"c\";s:3:\"web\";}i:119;a:3:{s:1:\"a\";i:142;s:1:\"b\";s:16:\"recompensas.edit\";s:1:\"c\";s:3:\"web\";}i:120;a:3:{s:1:\"a\";i:143;s:1:\"b\";s:18:\"recompensas.delete\";s:1:\"c\";s:3:\"web\";}i:121;a:3:{s:1:\"a\";i:144;s:1:\"b\";s:20:\"recompensas.activate\";s:1:\"c\";s:3:\"web\";}i:122;a:3:{s:1:\"a\";i:145;s:1:\"b\";s:21:\"recompensas.analytics\";s:1:\"c\";s:3:\"web\";}i:123;a:3:{s:1:\"a\";i:146;s:1:\"b\";s:21:\"recompensas.segmentos\";s:1:\"c\";s:3:\"web\";}i:124;a:3:{s:1:\"a\";i:147;s:1:\"b\";s:21:\"recompensas.productos\";s:1:\"c\";s:3:\"web\";}i:125;a:3:{s:1:\"a\";i:148;s:1:\"b\";s:18:\"recompensas.puntos\";s:1:\"c\";s:3:\"web\";}i:126;a:3:{s:1:\"a\";i:149;s:1:\"b\";s:22:\"recompensas.descuentos\";s:1:\"c\";s:3:\"web\";}i:127;a:3:{s:1:\"a\";i:150;s:1:\"b\";s:18:\"recompensas.envios\";s:1:\"c\";s:3:\"web\";}i:128;a:3:{s:1:\"a\";i:151;s:1:\"b\";s:19:\"recompensas.regalos\";s:1:\"c\";s:3:\"web\";}i:129;a:4:{s:1:\"a\";i:152;s:1:\"b\";s:17:\"configuracion.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:130;a:4:{s:1:\"a\";i:153;s:1:\"b\";s:20:\"configuracion.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:131;a:4:{s:1:\"a\";i:154;s:1:\"b\";s:18:\"configuracion.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:132;a:4:{s:1:\"a\";i:155;s:1:\"b\";s:20:\"configuracion.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:133;a:4:{s:1:\"a\";i:156;s:1:\"b\";s:23:\"banners_flash_sales.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:134;a:4:{s:1:\"a\";i:157;s:1:\"b\";s:26:\"banners_flash_sales.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:135;a:4:{s:1:\"a\";i:158;s:1:\"b\";s:24:\"banners_flash_sales.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:136;a:4:{s:1:\"a\";i:159;s:1:\"b\";s:26:\"banners_flash_sales.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:137;a:4:{s:1:\"a\";i:160;s:1:\"b\";s:19:\"banners_ofertas.ver\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:138;a:4:{s:1:\"a\";i:161;s:1:\"b\";s:22:\"banners_ofertas.create\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:139;a:4:{s:1:\"a\";i:162;s:1:\"b\";s:20:\"banners_ofertas.edit\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:140;a:4:{s:1:\"a\";i:163;s:1:\"b\";s:22:\"banners_ofertas.delete\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:141;a:4:{s:1:\"a\";i:164;s:1:\"b\";s:18:\"recompensas.popups\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:142;a:4:{s:1:\"a\";i:165;s:1:\"b\";s:26:\"recompensas.notificaciones\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}}s:5:\"roles\";a:4:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:10:\"superadmin\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:5:\"admin\";s:1:\"c\";s:3:\"web\";}i:2;a:3:{s:1:\"a\";i:4;s:1:\"b\";s:10:\"motorizado\";s:1:\"c\";s:3:\"web\";}i:3;a:3:{s:1:\"a\";i:5;s:1:\"b\";s:14:\"motorizado-app\";s:1:\"c\";s:7:\"sanctum\";}}}',1759848956);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cart_items_user_id_foreign` (`user_id`) USING BTREE,
  KEY `cart_items_user_cliente_id_foreign` (`user_cliente_id`) USING BTREE,
  KEY `cart_items_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `cart_items_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `cart_items_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `cart_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `check_user_type` CHECK ((((`user_id` is not null) and (`user_cliente_id` is null)) or ((`user_id` is null) and (`user_cliente_id` is not null))))
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (38,1,NULL,16,1,'2025-09-30 08:32:40','2025-09-30 08:32:40'),(39,NULL,36,16,1,'2025-09-30 08:34:44','2025-09-30 08:38:08'),(40,1,NULL,100,1,'2025-10-01 18:29:25','2025-10-01 18:29:25'),(41,1,NULL,66,2,'2025-10-03 09:21:42','2025-10-06 06:50:42'),(42,1,NULL,74,1,'2025-10-04 09:19:23','2025-10-04 09:19:23');
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
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
  CONSTRAINT `categoria_compatibilidades_ibfk_1` FOREIGN KEY (`categoria_principal_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `categoria_compatibilidades_ibfk_2` FOREIGN KEY (`categoria_compatible_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
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
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_categoria_seccion` (`id_seccion`) USING BTREE,
  CONSTRAINT `fk_categoria_seccion` FOREIGN KEY (`id_seccion`) REFERENCES `secciones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (11,1,'Memoria RAM',NULL,'1758851506_68d5f1b25b941.png',1,'2025-07-18 07:47:49','2025-10-01 12:29:59'),(13,1,'Discos',NULL,'1758851433_68d5f1692d93c.png',1,'2025-07-18 07:48:12','2025-09-25 18:50:33'),(17,3,'Mouse',NULL,'1759185236_68db0954a9998.png',1,'2025-09-29 15:33:56','2025-09-29 15:33:56'),(18,1,'Placa Madre',NULL,'1759185526_68db0a76ca3bc.png',1,'2025-09-29 15:38:46','2025-09-29 15:38:46'),(19,1,'Procesador',NULL,'1759185621_68db0ad576a43.png',1,'2025-09-29 15:40:21','2025-09-29 15:40:21'),(20,1,'Tarjeta Gráfica',NULL,'1759185700_68db0b249fdc6.png',1,'2025-09-29 15:41:40','2025-09-29 15:41:40'),(21,1,'Case Gamer',NULL,'1759185867_68db0bcb6afb3.png',1,'2025-09-29 15:44:27','2025-09-29 15:44:27'),(22,3,'Teclado',NULL,'1759334418_68dd50125b9c2.webp',1,'2025-10-01 09:00:18','2025-10-01 09:00:18'),(23,1,'Refrigeración Liquida',NULL,'1759337230_68dd5b0e93437.jpg',1,'2025-10-01 09:47:10','2025-10-01 09:47:10');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '1=DNI, 6=RUC, 4=CE, 7=PASAPORTE',
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre completo o razón social',
  `nombre_comercial` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubigeo` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código UBIGEO INEI',
  `distrito` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
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
  `codigo_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `compra_detalles_compra_id_foreign` (`compra_id`) USING BTREE,
  KEY `compra_detalles_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `compra_detalles_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `compra_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
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
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint unsigned DEFAULT NULL,
  `fecha_cambio` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `compra_tracking_compra_id_foreign` (`compra_id`) USING BTREE,
  KEY `compra_tracking_estado_compra_id_foreign` (`estado_compra_id`) USING BTREE,
  KEY `compra_tracking_usuario_id_foreign` (`usuario_id`) USING BTREE,
  KEY `compra_tracking_fecha_cambio` (`fecha_cambio`) USING BTREE,
  CONSTRAINT `compra_tracking_compra_id_foreign` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `compra_tracking_estado_compra_id_foreign` FOREIGN KEY (`estado_compra_id`) REFERENCES `estados_compra` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `compra_tracking_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
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
  `codigo_compra` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cotizacion_id` bigint unsigned DEFAULT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `fecha_compra` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `estado_compra_id` bigint unsigned NOT NULL,
  `metodo_pago` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `direccion_envio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono_contacto` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forma_envio` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT '0.00',
  `departamento_id` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_id` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_id` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_completa` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  CONSTRAINT `compras_aprobada_por_foreign` FOREIGN KEY (`aprobada_por`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `compras_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `compras_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `compras_estado_compra_id_foreign` FOREIGN KEY (`estado_compra_id`) REFERENCES `estados_compra` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `compras_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `compras_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras`
--

LOCK TABLES `compras` WRITE;
/*!40000 ALTER TABLE `compras` DISABLE KEYS */;
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
  `codigo_producto` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `unidad_medida` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NIU' COMMENT 'NIU=Número de unidades',
  `cantidad` decimal(12,4) NOT NULL,
  `valor_unitario` decimal(12,4) NOT NULL COMMENT 'Precio sin IGV',
  `precio_unitario` decimal(12,4) NOT NULL COMMENT 'Precio con IGV',
  `descuento` decimal(12,2) NOT NULL DEFAULT '0.00',
  `valor_venta` decimal(12,2) NOT NULL COMMENT 'cantidad * valor_unitario - descuento',
  `porcentaje_igv` decimal(5,2) NOT NULL DEFAULT '18.00',
  `igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tipo_afectacion_igv` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '10' COMMENT '10=Gravado, 20=Exonerado, 30=Inafecto',
  `importe_total` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_comprobante_id` (`comprobante_id`) USING BTREE,
  KEY `idx_producto_id` (`producto_id`) USING BTREE,
  KEY `idx_item` (`comprobante_id`,`item`) USING BTREE,
  CONSTRAINT `fk_detalles_comprobante_id` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `tipo_comprobante` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '01=Factura, 03=Boleta, 07=NC, 08=ND',
  `serie` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `correlativo` int unsigned NOT NULL,
  `numero_completo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (concat(`serie`,_utf8mb4'-',lpad(`correlativo`,8,_utf8mb4'0'))) STORED,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `cliente_id` bigint unsigned NOT NULL,
  `cliente_tipo_documento` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_razon_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `moneda` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PEN',
  `operacion_gravada` decimal(12,2) NOT NULL DEFAULT '0.00',
  `operacion_exonerada` decimal(12,2) NOT NULL DEFAULT '0.00',
  `operacion_inafecta` decimal(12,2) NOT NULL DEFAULT '0.00',
  `operacion_gratuita` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_descuentos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_otros_cargos` decimal(12,2) NOT NULL DEFAULT '0.00',
  `importe_total` decimal(12,2) NOT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `comprobante_referencia_id` bigint unsigned DEFAULT NULL,
  `tipo_nota` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código de tipo de nota de crédito/débito',
  `motivo_nota` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `estado` enum('PENDIENTE','ENVIADO','ACEPTADO','RECHAZADO','ANULADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `codigo_hash` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_firmado` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `xml_respuesta_sunat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `pdf_base64` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `mensaje_sunat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL COMMENT 'Usuario que creó el comprobante',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_serie_correlativo` (`serie`,`correlativo`) USING BTREE,
  KEY `idx_numero_completo` (`numero_completo`) USING BTREE,
  KEY `idx_cliente_id` (`cliente_id`) USING BTREE,
  KEY `idx_fecha_emision` (`fecha_emision`) USING BTREE,
  KEY `idx_estado` (`estado`) USING BTREE,
  KEY `idx_tipo_comprobante` (`tipo_comprobante`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `fk_comprobantes_referencia_id` (`comprobante_referencia_id`) USING BTREE,
  CONSTRAINT `fk_comprobantes_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_comprobantes_referencia_id` FOREIGN KEY (`comprobante_referencia_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_comprobantes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comprobantes`
--

LOCK TABLES `comprobantes` WRITE;
/*!40000 ALTER TABLE `comprobantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comprobantes` ENABLE KEYS */;
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
  `codigo_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cotizacion_detalles_cotizacion_id_foreign` (`cotizacion_id`) USING BTREE,
  KEY `cotizacion_detalles_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `cotizacion_detalles_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cotizacion_id` bigint unsigned NOT NULL,
  `estado_cotizacion_id` bigint unsigned NOT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint unsigned DEFAULT NULL,
  `fecha_cambio` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cotizacion_tracking_cotizacion_id_foreign` (`cotizacion_id`) USING BTREE,
  KEY `cotizacion_tracking_estado_cotizacion_id_foreign` (`estado_cotizacion_id`) USING BTREE,
  KEY `cotizacion_tracking_usuario_id_foreign` (`usuario_id`) USING BTREE,
  KEY `cotizacion_tracking_fecha_cambio` (`fecha_cambio`) USING BTREE,
  CONSTRAINT `cotizacion_tracking_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `cotizacion_tracking_estado_cotizacion_id_foreign` FOREIGN KEY (`estado_cotizacion_id`) REFERENCES `estados_cotizacion` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cotizacion_tracking_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_cotizacion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `fecha_cotizacion` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `estado_cotizacion_id` bigint unsigned NOT NULL,
  `metodo_pago_preferido` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `direccion_envio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono_contacto` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forma_envio` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT '0.00',
  `departamento_id` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_id` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_id` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_completa` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo_cotizacion` (`codigo_cotizacion`) USING BTREE,
  KEY `cotizaciones_cliente_id_foreign` (`cliente_id`) USING BTREE,
  KEY `cotizaciones_user_cliente_id_foreign` (`user_cliente_id`) USING BTREE,
  KEY `cotizaciones_estado_cotizacion_id_foreign` (`estado_cotizacion_id`) USING BTREE,
  KEY `cotizaciones_user_id_foreign` (`user_id`) USING BTREE,
  KEY `cotizaciones_fecha_cotizacion` (`fecha_cotizacion`) USING BTREE,
  KEY `cotizaciones_estado_fecha` (`estado_cotizacion_id`,`fecha_cotizacion`) USING BTREE,
  CONSTRAINT `cotizaciones_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `cotizaciones_estado_cotizacion_id_foreign` FOREIGN KEY (`estado_cotizacion_id`) REFERENCES `estados_cotizacion` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cotizaciones_user_cliente_id_foreign` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `cotizaciones_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
-- Table structure for table `cupones`
--

DROP TABLE IF EXISTS `cupones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupones` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_descuento` enum('porcentaje','cantidad_fija') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupones`
--

LOCK TABLES `cupones` WRITE;
/*!40000 ALTER TABLE `cupones` DISABLE KEYS */;
INSERT INTO `cupones` VALUES (2,'descuentouser','Decuento de bienvenida','hello','porcentaje',21.00,222.00,'2025-07-30 21:18:00','2025-07-31 22:19:00',1,0,0,1,'2025-07-18 11:15:32','2025-07-30 13:34:07');
/*!40000 ALTER TABLE `cupones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_types`
--

DROP TABLE IF EXISTS `document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `global_colors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `greeting` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `main_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `secondary_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `footer_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `benefits_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `product_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `button_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `button_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `nombre_empresa` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `celular` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `facebook` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instagram` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `twitter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `youtube` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_atencion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
INSERT INTO `empresa_info` VALUES (1,'Magus Technologies','12348921372','MAGUS TECHNOLOGIES','santa anita','993321920','993321920','maguado@magustechnologies.com','https://magussystems.com/','empresa/logos/AERqD3yJqdYUzae8RYBR5GJ7W7ml4PpyLN4sUaMM.png','hello',NULL,NULL,NULL,NULL,NULL,NULL,'2025-07-22 07:25:59','2025-09-24 07:37:21');
/*!40000 ALTER TABLE `empresa_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_compra`
--

DROP TABLE IF EXISTS `estados_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_compra` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '#6c757d',
  `orden` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `estados_compra_nombre_unique` (`nombre`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '#6c757d',
  `orden` int DEFAULT '0',
  `permite_conversion` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `estados_cotizacion_nombre_unique` (`nombre`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `nombre_estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
-- Table structure for table `forma_envios`
--

DROP TABLE IF EXISTS `forma_envios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forma_envios` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: Delivery en Lima, Recojo en tienda',
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: delivery, recojo_tienda, envio_provincia',
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `costo` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Costo de envío',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Para ordenar en el frontend',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo` (`codigo`) USING BTREE,
  UNIQUE KEY `forma_envios_codigo_unique` (`codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forma_envios`
--

LOCK TABLES `forma_envios` WRITE;
/*!40000 ALTER TABLE `forma_envios` DISABLE KEYS */;
/*!40000 ALTER TABLE `forma_envios` ENABLE KEYS */;
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
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cambiado_por` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pedido_id` (`pedido_id`) USING BTREE,
  KEY `estado_anterior_id` (`estado_anterior_id`) USING BTREE,
  KEY `nuevo_estado_id` (`nuevo_estado_id`) USING BTREE,
  KEY `cambiado_por` (`cambiado_por`) USING BTREE,
  CONSTRAINT `historial_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `historial_pedido_ibfk_2` FOREIGN KEY (`estado_anterior_id`) REFERENCES `estados_pedido` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `historial_pedido_ibfk_3` FOREIGN KEY (`nuevo_estado_id`) REFERENCES `estados_pedido` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `historial_pedido_ibfk_4` FOREIGN KEY (`cambiado_por`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
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
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
-- Table structure for table `marcas_productos`
--

DROP TABLE IF EXISTS `marcas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas_productos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
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
INSERT INTO `marcas_productos` VALUES (9,'ASTRO','ASTRO GAMING','1758726183_68d408277dd13.png',1,'2025-09-24 07:51:19','2025-09-24 08:03:03'),(10,'ASUS','ASUS GAMING','1758726367_68d408df54eb9.png',1,'2025-09-24 08:02:39','2025-09-24 08:06:30'),(11,'LOGITECH','LOGITECH GAMING','1758726341_68d408c51586f.png',1,'2025-09-24 08:05:41','2025-09-24 08:05:41'),(12,'RAZER','RAZER GAMING','1758727508_68d40d54ce0af.png',1,'2025-09-24 08:11:22','2025-09-24 08:25:08'),(13,'REDRAGON','REDRAGON GAMING','1758727654_68d40de61ea5c.jpg',1,'2025-09-24 08:27:34','2025-09-24 08:27:34'),(14,'INTEL','INTEL GAMING','1758727972_68d40f244daac.png',1,'2025-09-24 08:32:52','2025-09-24 08:32:52'),(15,'AMD','AMD GAMING','1758728112_68d40fb01ee89.jpg',1,'2025-09-24 08:35:12','2025-09-24 08:35:12'),(16,'NVIDIA','NVIDIA GAMING','1758728434_68d410f25690d.png',1,'2025-09-24 08:40:34','2025-09-24 08:40:34'),(17,'CORSAIR','CORSAIR GAMING','1759333080_68dd4ad80ec78.png',1,'2025-10-01 08:35:08','2025-10-01 08:38:00'),(18,'MSI','MSI GAMING','1759334819_68dd51a352803.png',1,'2025-10-01 09:05:49','2025-10-01 09:06:59'),(19,'DEEPCOOL','DEEPCOOL GAMING','1759337316_68dd5b64a9979.webp',1,'2025-10-01 09:48:36','2025-10-01 09:48:36'),(20,'GAMEMAX','GAMEMAX GAMING','1759352211_68dd9593bf6e9.png',1,'2025-10-01 13:56:51','2025-10-01 13:56:51'),(21,'LIAN LI','LIAN LI GAMING','1759352360_68dd9628c7ba7.jpg',1,'2025-10-01 13:59:20','2025-10-01 13:59:20'),(22,'G. SKILL','G. SKILL GAMING','1759352458_68dd968a195ff.png',1,'2025-10-01 14:00:58','2025-10-01 14:00:58'),(23,'KINGSTON','KINGSTON GAMING','1759352641_68dd97418c1a8.jpg',1,'2025-10-01 14:02:15','2025-10-01 14:04:01'),(24,'GIGABYTE','GIGABYTE GAMING','1759352769_68dd97c1e1478.png',1,'2025-10-01 14:06:09','2025-10-01 14:06:09'),(25,'ANTRYX','ANTRYX GAMING','1759352998_68dd98a6416de.jpg',1,'2025-10-01 14:09:10','2025-10-01 14:09:58'),(26,'Seagate','Seagate Gaming','1759759412_68e3cc348d410.jpg',1,'2025-10-06 07:03:32','2025-10-06 07:03:32'),(27,'AORUS','AORUS GAMING','1759759657_68e3cd291fb66.jpg',1,'2025-10-06 07:07:37','2025-10-06 07:07:37');
/*!40000 ALTER TABLE `marcas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_pago` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_05_21_141516_create_personal_access_tokens_table',1),(5,'2025_05_23_212502_create_user_profiles_table',1),(6,'2025_05_23_212626_create_user_addresses_table',1),(7,'2025_05_23_223135_add_last_names_to_user_profiles_table',1),(8,'2025_05_24_135354_create_roles_table',1),(9,'2025_05_24_224316_add_is_enabled_to_users_table',1),(10,'2025_05_25_040524_create_ubigeo_inei_table',1),(11,'2025_05_26_120602_create_document_types_table',1),(12,'2025_05_26_225958_remove_address_line_from_user_addresses_table',1),(13,'2025_05_27_223827_create_categorias_table',1),(14,'2025_05_27_223837_create_productos_table',1);
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
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`) USING BTREE,
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE,
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
INSERT INTO `model_has_permissions` VALUES (139,'App\\Models\\User',1),(140,'App\\Models\\User',1),(141,'App\\Models\\User',1),(142,'App\\Models\\User',1),(144,'App\\Models\\User',1),(145,'App\\Models\\User',1),(146,'App\\Models\\User',1),(147,'App\\Models\\User',1),(148,'App\\Models\\User',1),(149,'App\\Models\\User',1),(150,'App\\Models\\User',1),(151,'App\\Models\\User',1),(139,'App\\Models\\User',29),(141,'App\\Models\\User',29),(145,'App\\Models\\User',29),(139,'App\\Models\\User',31),(140,'App\\Models\\User',31),(141,'App\\Models\\User',31),(142,'App\\Models\\User',31),(143,'App\\Models\\User',31),(144,'App\\Models\\User',31),(145,'App\\Models\\User',31),(146,'App\\Models\\User',31),(147,'App\\Models\\User',31),(148,'App\\Models\\User',31),(149,'App\\Models\\User',31),(150,'App\\Models\\User',31),(151,'App\\Models\\User',31),(139,'App\\Models\\User',35),(141,'App\\Models\\User',35),(145,'App\\Models\\User',35);
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
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`) USING BTREE,
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE,
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES (1,'App\\Models\\User',1),(5,'App\\Models\\UserMotorizado',1),(5,'App\\Models\\UserMotorizado',2),(5,'App\\Models\\UserMotorizado',3),(5,'App\\Models\\UserMotorizado',4),(3,'App\\Models\\User',29),(1,'App\\Models\\User',31),(3,'App\\Models\\User',35);
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
  `estado` enum('disponible','ocupado','en_ruta','descanso','offline') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'offline',
  `latitud` decimal(10,8) DEFAULT NULL COMMENT 'Ubicacion actual',
  `longitud` decimal(11,8) DEFAULT NULL COMMENT 'Ubicacion actual',
  `ultima_actividad` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_motorizado_id` (`motorizado_id`) USING BTREE,
  KEY `idx_estado` (`estado`) USING BTREE,
  KEY `idx_ultima_actividad` (`ultima_actividad`) USING BTREE,
  CONSTRAINT `motorizado_estados_ibfk_1` FOREIGN KEY (`motorizado_id`) REFERENCES `motorizados` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Estados y ubicacion en tiempo real de motorizados';
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
  `numero_unidad` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_completo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto_perfil` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_documento_id` bigint unsigned NOT NULL,
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `licencia_numero` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `licencia_categoria` enum('A1','A2a','A2b','A3a','A3b','A3c') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion_detalle` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubigeo` bigint unsigned NOT NULL,
  `vehiculo_marca` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_modelo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_ano` year NOT NULL,
  `vehiculo_cilindraje` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_color_principal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_color_secundario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehiculo_placa` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_motor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehiculo_chasis` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `registrado_por` bigint unsigned NOT NULL,
  `user_motorizado_id` bigint unsigned DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `numero_documento` (`numero_documento`) USING BTREE,
  UNIQUE KEY `correo` (`correo`) USING BTREE,
  UNIQUE KEY `vehiculo_placa` (`vehiculo_placa`) USING BTREE,
  KEY `fk_motorizados_tipo_documento` (`tipo_documento_id`) USING BTREE,
  KEY `fk_motorizados_registrado_por` (`registrado_por`) USING BTREE,
  KEY `fk_motorizados_ubigeo` (`ubigeo`) USING BTREE,
  KEY `idx_user_motorizado_id` (`user_motorizado_id`) USING BTREE,
  KEY `idx_motorizados_estado` (`estado`) USING BTREE,
  KEY `idx_motorizados_numero_unidad` (`numero_unidad`) USING BTREE,
  CONSTRAINT `fk_motorizados_registrado_por` FOREIGN KEY (`registrado_por`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_motorizados_tipo_documento` FOREIGN KEY (`tipo_documento_id`) REFERENCES `document_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_motorizados_ubigeo` FOREIGN KEY (`ubigeo`) REFERENCES `ubigeo_inei` (`id_ubigeo`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `motorizados_ibfk_1` FOREIGN KEY (`user_motorizado_id`) REFERENCES `user_motorizados` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motorizados`
--

LOCK TABLES `motorizados` WRITE;
/*!40000 ALTER TABLE `motorizados` DISABLE KEYS */;
INSERT INTO `motorizados` VALUES (1,'MOT-001','Pablito de los Backyardingas Luján Carrión','http://magus-ecommerce.com/ecommerce-back/public/storage/motorizados/fotos/1758377290_WhatsApp Image 2025-08-15 at 6.41.46 PM.jpeg',1,'73584788','CK - 64545','A2b','968745845','pablito033@gmail.com','Surco',1417,'Yamaha','Crkf3131',2016,'155c','Azul',NULL,'ASE- 45654','LRC - 9165155','VIM - 95485454','No sabe manejar',1,NULL,1,'2025-09-18 13:01:31','2025-09-20 07:08:10'),(4,'MOT-003','Manuel','http://magus-ecommerce.com/ecommerce-back/public/storage/motorizados/fotos/1758668772_541970920_10232150863409137_1521389980038021455_n.jpg',1,'42799312','47429292','A1','987161736','systemcraft.pe@gmail.com','Santa Anita',1440,'Susuki','R6',2025,'1500cc','plomo',NULL,'f6f6','877ff6f78','uf7f7f7f','Entro a trabajar el 04 octubre',1,3,1,'2025-09-23 16:06:12','2025-09-23 16:06:12'),(5,'MOT-004','SEBASTIAN',NULL,1,'77422200','352432vfd','A1','+51 993 321 920','akame17ga20kill@gmail.com','dfvdsdsfvds',1088,'dfsvds','sdfvds',2002,'dfsvbdfsv','svfds','dvsf','dsfvdsv','dfvs','fvds','dfsvsdfvfd',1,4,1,'2025-09-29 08:56:02','2025-09-29 08:56:03');
/*!40000 ALTER TABLE `motorizados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofertas`
--

DROP TABLE IF EXISTS `ofertas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ofertas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_oferta_id` int unsigned DEFAULT NULL,
  `tipo_descuento` enum('porcentaje','cantidad_fija') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `precio_minimo` decimal(10,2) DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner_imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color_fondo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '#3B82F6',
  `texto_boton` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Compra ahora',
  `enlace_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '/shop',
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
  CONSTRAINT `ofertas_ibfk_1` FOREIGN KEY (`tipo_oferta_id`) REFERENCES `tipos_ofertas` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
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
  CONSTRAINT `ofertas_productos_ibfk_1` FOREIGN KEY (`oferta_id`) REFERENCES `ofertas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `ofertas_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofertas_productos`
--

LOCK TABLES `ofertas_productos` WRITE;
/*!40000 ALTER TABLE `ofertas_productos` DISABLE KEYS */;
INSERT INTO `ofertas_productos` VALUES (10,3,19,76.00,10,0,'2025-10-02 08:30:36','2025-10-02 08:30:36');
/*!40000 ALTER TABLE `ofertas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
INSERT INTO `password_reset_tokens` VALUES ('koenjisuzune@gmail.com','$2y$12$.48wHwduy1gHPt.UcSR.ROr8J1uPjkS8ozqZwQE9KWRiTNBn6nIDu','2025-07-08 21:20:51'),('chinchayjuan95@gmail.com','$2y$12$l/vz8ZcWMB6O1fiEwCR7fuFpgzgTT0w5t5uHLFbtIdVaYjdJ3tWXO','2025-08-14 19:10:43'),('ladysct11@gmail.com','$2y$12$kpPC/w8wIIpSCXjs3SMGvumU1QPNFvbX.qEdQdQfSIkhA6J2EKK6K','2025-09-29 08:33:15'),('anasilvia123vv@gmail.com','$2y$12$JwBHsFyJ7TdnmRwGsFqv2.0UIZVkgSmqoi2g9udi6LpcH5qlcCqQq','2025-09-29 09:01:31'),('rodrigoyarleque7@gmail.com','$2y$12$I2tyxy6Zyr6lfHZ3bM7kgONLwgrkYlz6Thjwi98yE05OfJjCkss8m','2025-09-29 11:05:40'),('kiyotakahitori@gmail.com','$2y$12$i8zYrlJkLp5d7sgCSaLgN.2fD8l2nU69WtVPwIDU1A98y0bGtGoIK','2025-10-01 10:49:54');
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
  `codigo_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `estado_asignacion` enum('asignado','aceptado','en_camino','entregado','cancelado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'asignado',
  `fecha_asignacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aceptacion` timestamp NULL DEFAULT NULL,
  `fecha_inicio` timestamp NULL DEFAULT NULL COMMENT 'Cuando inicia el viaje',
  `fecha_entrega` timestamp NULL DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_pedido_motorizado_activo` (`pedido_id`,`motorizado_id`) USING BTREE,
  KEY `idx_pedido_id` (`pedido_id`) USING BTREE,
  KEY `idx_motorizado_id` (`motorizado_id`) USING BTREE,
  KEY `idx_estado_asignacion` (`estado_asignacion`) USING BTREE,
  KEY `idx_fecha_asignacion` (`fecha_asignacion`) USING BTREE,
  KEY `asignado_por` (`asignado_por`) USING BTREE,
  CONSTRAINT `pedido_motorizado_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `pedido_motorizado_ibfk_2` FOREIGN KEY (`motorizado_id`) REFERENCES `motorizados` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `pedido_motorizado_ibfk_3` FOREIGN KEY (`asignado_por`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Asignacion de pedidos a motorizados';
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
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint unsigned NOT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pedido_tracking_pedido_id_foreign` (`pedido_id`) USING BTREE,
  KEY `pedido_tracking_estado_pedido_id_foreign` (`estado_pedido_id`) USING BTREE,
  KEY `pedido_tracking_usuario_id_foreign` (`usuario_id`) USING BTREE,
  CONSTRAINT `pedido_tracking_estado_pedido_id_foreign` FOREIGN KEY (`estado_pedido_id`) REFERENCES `estados_pedido` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `pedido_tracking_pedido_id_foreign` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `pedido_tracking_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
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
  `codigo_pedido` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `cotizacion_id` bigint unsigned DEFAULT NULL,
  `tipo_pedido` enum('directo','desde_cotizacion') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'directo',
  `fecha_pedido` datetime NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `estado_pedido_id` bigint unsigned NOT NULL,
  `metodo_pago` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `direccion_envio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono_contacto` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cliente_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forma_envio` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT '0.00',
  `departamento_id` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_id` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_id` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `departamento_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_completa` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  KEY `pedidos_cotizacion_id_foreign` (`cotizacion_id`) USING BTREE,
  CONSTRAINT `pedidos_cotizacion_id_foreign` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (13,'usuarios.ver','web','2025-06-01 01:11:16','2025-06-05 16:59:57'),(16,'usuarios.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(17,'usuarios.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(18,'usuarios.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(19,'usuarios.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(20,'productos.ver','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(21,'productos.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(22,'productos.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(23,'productos.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(24,'productos.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(25,'categorias.ver','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(26,'categorias.create','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(27,'categorias.show','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(28,'categorias.edit','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(29,'categorias.delete','web','2025-06-05 16:59:57','2025-06-05 16:59:57'),(30,'banners.ver','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(31,'banners.create','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(32,'banners.edit','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(33,'banners.delete','web','2025-06-19 16:11:44','2025-06-19 16:11:44'),(38,'banners_promocionales.ver','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(39,'banners_promocionales.create','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(40,'banners_promocionales.edit','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(41,'banners_promocionales.delete','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(42,'clientes.ver','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(43,'clientes.create','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(44,'clientes.show','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(45,'clientes.edit','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(46,'clientes.delete','web','2025-06-21 22:28:44','2025-06-21 22:28:44'),(47,'marcas.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(48,'marcas.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(49,'marcas.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(50,'marcas.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(51,'pedidos.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(52,'pedidos.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(53,'pedidos.show','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(54,'pedidos.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(55,'secciones.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(56,'secciones.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(57,'secciones.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(58,'secciones.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(59,'cupones.ver','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(60,'cupones.show','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(61,'cupones.edit','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(62,'cupones.delete','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(63,'cupones.create','web','2025-06-30 12:37:16','2025-06-30 12:37:16'),(64,'ofertas.ver','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(65,'ofertas.edit','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(66,'ofertas.show','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(67,'ofertas.create','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(68,'ofertas.delete','web','2025-06-30 12:45:02','2025-06-30 12:45:02'),(69,'horarios.ver','web','2025-07-14 07:28:35','2025-07-14 07:28:35'),(70,'horarios.create','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(71,'horarios.show','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(72,'horarios.edit','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(73,'horarios.delete','web','2025-07-14 07:28:36','2025-07-14 07:28:36'),(74,'empresa_info.ver','web','2025-07-19 06:52:57','2025-07-19 06:52:57'),(75,'empresa_info.edit','web','2025-07-19 06:52:57','2025-07-19 06:52:57'),(76,'envio_correos.ver','web','2025-08-14 17:54:08','2025-08-14 17:54:08'),(77,'envio_correos.edit','web','2025-08-14 17:54:19','2025-08-14 17:54:19'),(78,'reclamos.ver','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(79,'reclamos.show','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(80,'reclamos.edit','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(81,'reclamos.delete','web','2025-09-01 13:42:16','2025-09-01 13:42:16'),(86,'cotizaciones.ver','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(87,'cotizaciones.show','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(88,'cotizaciones.create','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(89,'cotizaciones.edit','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(90,'cotizaciones.delete','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(91,'cotizaciones.aprobar','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(92,'compras.ver','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(93,'compras.show','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(94,'compras.create','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(95,'compras.edit','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(96,'compras.delete','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(97,'compras.aprobar','web','2025-09-17 03:02:30','2025-09-17 03:02:30'),(98,'envio_correos.create','web','2025-09-16 20:07:13','2025-09-16 20:07:13'),(99,'envio_correos.delete','web','2025-09-16 20:07:13','2025-09-16 20:07:13'),(100,'motorizados.ver','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(101,'motorizados.create','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(102,'motorizados.show','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(103,'motorizados.edit','web','2025-09-16 20:10:26','2025-09-16 20:10:26'),(104,'motorizados.delete','web','2025-09-16 20:13:05','2025-09-16 20:13:05'),(105,'pedidos.motorizado.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(106,'pedidos.motorizado.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(107,'pedidos.motorizado.actualizar_estado','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(108,'pedidos.motorizado.actualizar_estado','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(109,'pedidos.motorizado.confirmar_entrega','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(110,'pedidos.motorizado.confirmar_entrega','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(111,'motorizado.perfil.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(112,'motorizado.perfil.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(113,'motorizado.perfil.editar','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(114,'motorizado.perfil.editar','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(115,'motorizado.rutas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(116,'motorizado.rutas.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(117,'motorizado.ubicacion.actualizar','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(118,'motorizado.ubicacion.actualizar','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(119,'motorizado.estadisticas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(120,'motorizado.estadisticas.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(121,'motorizado.chat.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(122,'motorizado.chat.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(123,'motorizado.notificaciones.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(124,'motorizado.notificaciones.ver','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45'),(125,'email_templates.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(126,'email_templates.show','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(127,'email_templates.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(128,'email_templates.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(129,'email_templates.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(130,'ventas.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(131,'ventas.show','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(132,'ventas.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(133,'ventas.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(134,'ventas.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(135,'roles.ver','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(136,'roles.create','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(137,'roles.edit','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(138,'roles.delete','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(139,'recompensas.ver','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(140,'recompensas.create','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(141,'recompensas.show','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(142,'recompensas.edit','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(143,'recompensas.delete','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(144,'recompensas.activate','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(145,'recompensas.analytics','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(146,'recompensas.segmentos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(147,'recompensas.productos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(148,'recompensas.puntos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(149,'recompensas.descuentos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(150,'recompensas.envios','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(151,'recompensas.regalos','web','2025-09-25 19:20:07','2025-09-25 19:20:07'),(152,'configuracion.ver','web','2025-10-01 09:48:34','2025-10-01 09:48:34'),(153,'configuracion.create','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(154,'configuracion.edit','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(155,'configuracion.delete','web','2025-10-01 09:48:35','2025-10-01 09:48:35'),(156,'banners_flash_sales.ver','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(157,'banners_flash_sales.create','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(158,'banners_flash_sales.edit','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(159,'banners_flash_sales.delete','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(160,'banners_ofertas.ver','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(161,'banners_ofertas.create','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(162,'banners_ofertas.edit','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(163,'banners_ofertas.delete','web','2025-10-03 09:16:39','2025-10-03 09:16:39'),(164,'recompensas.popups','web','2025-10-06 07:55:56','2025-10-06 07:55:56'),(165,'recompensas.notificaciones','web','2025-10-06 07:55:56','2025-10-06 07:55:56');
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
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`) USING BTREE,
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=244 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (4,'App\\Models\\User',1,'auth_token','8f4fcd36aec6e8130083429a06243bc1641af0ecfbd9243dd5e83df7bae1786f','[\"*\"]','2025-06-06 15:08:00',NULL,'2025-06-06 14:53:46','2025-06-06 15:08:00'),(5,'App\\Models\\User',1,'auth_token','74b6c21260891055a70eccb26735e97d57f9f835944352ff62f723421cb5d8dd','[\"*\"]','2025-06-06 16:03:42',NULL,'2025-06-06 14:55:09','2025-06-06 16:03:42'),(6,'App\\Models\\User',1,'auth_token','744ca78aa44496a4ccc50a29ca6a15ac3f8618751a2a696bfce752f1fc062e17','[\"*\"]','2025-06-06 16:25:33',NULL,'2025-06-06 16:05:49','2025-06-06 16:25:33'),(19,'App\\Models\\UserCliente',1,'cliente_token','60989d38106b9316eb8678ddc3bd0c3697e21d536a4d1144ef999025e4f3275f','[\"*\"]',NULL,NULL,'2025-06-19 14:19:03','2025-06-19 14:19:03'),(22,'App\\Models\\UserCliente',2,'cliente_token','687175aa5df11ec748948acb23373c2dc990146962f227cf9ec30c059c98d7ed','[\"*\"]',NULL,NULL,'2025-06-19 15:25:53','2025-06-19 15:25:53'),(29,'App\\Models\\UserCliente',3,'cliente_token','db7ce46df909698d7b41949808581814c4f308d08d96fc144879e845585079a2','[\"*\"]',NULL,NULL,'2025-06-23 19:36:35','2025-06-23 19:36:35'),(37,'App\\Models\\User',1,'admin_token','1caf6bf018ea1a00457167d8d2426c4eb197bd4e99e416eb9c8f215bb6d66e7d','[\"*\"]','2025-06-30 12:47:31',NULL,'2025-06-30 12:46:19','2025-06-30 12:47:31'),(40,'App\\Models\\User',1,'admin_token','86d76b8819ea43ab9300497e682816b15fcb29c0f80773f389e6c151385b82fc','[\"*\"]','2025-07-05 13:59:12',NULL,'2025-07-05 13:59:10','2025-07-05 13:59:12'),(43,'App\\Models\\UserCliente',4,'cliente_token','9d1ac1230cc9f5e410875ebe38e73c5ec3eee6e9c715c7219e7ca5ea3c853870','[\"*\"]',NULL,NULL,'2025-07-05 20:26:29','2025-07-05 20:26:29'),(44,'App\\Models\\UserCliente',4,'auth_token','dced180bfc593b10d68995beb42f16dee7668e9841671b652f77e3958bdd5891','[\"*\"]',NULL,NULL,'2025-07-06 11:48:36','2025-07-06 11:48:36'),(45,'App\\Models\\UserCliente',4,'auth_token','b7d48ef1eeee919ed326b015ab98756d2c6095934b4a5096d77120c138a7d49c','[\"*\"]',NULL,NULL,'2025-07-06 11:58:36','2025-07-06 11:58:36'),(46,'App\\Models\\UserCliente',4,'auth_token','52e04aba84e4cf8f3ab6b522bad1b4fd3529ac216fa46eff102174bd059a103b','[\"*\"]',NULL,NULL,'2025-07-06 12:00:50','2025-07-06 12:00:50'),(49,'App\\Models\\UserCliente',4,'auth_token','68a7ae5305c6bee694e4fd5c7f39e5890f565c3996b1da86830bdb1b9c9c7754','[\"*\"]',NULL,NULL,'2025-07-06 13:03:13','2025-07-06 13:03:13'),(51,'App\\Models\\UserCliente',5,'cliente_token','890d752f34f61c902014f081e075cb1d7c4852ed7f72186f5cd37e5fce6df759','[\"*\"]',NULL,NULL,'2025-07-08 21:20:38','2025-07-08 21:20:38'),(62,'App\\Models\\User',1,'admin_token','7ea7ad9514959726f25963b3b547cdfc3e68b1112712c04d5e762a49eba58fd9','[\"*\"]','2025-07-11 15:03:36',NULL,'2025-07-11 15:00:06','2025-07-11 15:03:36'),(66,'App\\Models\\UserCliente',3,'auth_token','907c881583064cc503cf4ae3dbf90a8ceb983458533cf4bd2ec3e7eb3712b3cb','[\"*\"]',NULL,NULL,'2025-07-11 20:35:13','2025-07-11 20:35:13'),(67,'App\\Models\\UserCliente',4,'auth_token','bf330d25cf90acb2032d589206307144a3d9cd1ba44f0fab5ea4e898229ca297','[\"*\"]',NULL,NULL,'2025-07-11 23:46:31','2025-07-11 23:46:31'),(70,'App\\Models\\User',1,'admin_token','cd76d143710dac9271017ee4e23174939759a04ac33fdd9e7cbb4eeff3e15772','[\"*\"]','2025-07-14 00:51:14',NULL,'2025-07-14 00:51:05','2025-07-14 00:51:14'),(72,'App\\Models\\User',1,'admin_token','2154a61002d3017078113a8588a5bc3c77585b2a52b3198485c0b56431b79427','[\"*\"]','2025-07-14 07:43:54',NULL,'2025-07-14 07:36:21','2025-07-14 07:43:54'),(77,'App\\Models\\User',1,'admin_token','f9ff984b68d3898908f791dd3e34463f6b6b1ba1f6d58f0b6e6b9ce716d89bd4','[\"*\"]','2025-07-16 14:21:07',NULL,'2025-07-16 14:21:03','2025-07-16 14:21:07'),(78,'App\\Models\\User',1,'admin_token','150db278f254dd606190f73656b5f6e0393811f889042443c1b0a50a172e95ef','[\"*\"]','2025-07-16 17:43:46',NULL,'2025-07-16 15:17:53','2025-07-16 17:43:46'),(83,'App\\Models\\User',1,'admin_token','993828ecddc03aa1ee2bdc0215a1b332afe3858cac6e0562424f8619e666675a','[\"*\"]','2025-07-20 19:26:02',NULL,'2025-07-20 19:25:49','2025-07-20 19:26:02'),(87,'App\\Models\\User',1,'admin_token','96f578aaa56372f292fbc0e59e4b1aba6c4b11b4254ecb588ce8bc5b4bab1895','[\"*\"]',NULL,NULL,'2025-07-21 17:30:39','2025-07-21 17:30:39'),(88,'App\\Models\\User',1,'admin_token','5c4c11a37cd9892fd090954ad1d38726f80b5b91621c2edfdef5bca166d820c0','[\"*\"]','2025-07-21 17:36:50',NULL,'2025-07-21 17:30:55','2025-07-21 17:36:50'),(90,'App\\Models\\User',1,'admin_token','b2a89c1f02a99410860ab7c442b07e0735ea97a5908af3c0fbb3c2c54a683604','[\"*\"]','2025-07-21 17:54:20',NULL,'2025-07-21 17:37:24','2025-07-21 17:54:20'),(91,'App\\Models\\User',1,'admin_token','2fd667e7fd6ac08eed8ca31226b926eace4bfc9898224c3b4b3003def7794c49','[\"*\"]',NULL,NULL,'2025-07-21 17:40:27','2025-07-21 17:40:27'),(92,'App\\Models\\User',1,'admin_token','f20f446272e44612d56d884f15a439c269f389625abba96817e5f07e4e639fa3','[\"*\"]','2025-07-21 17:52:55',NULL,'2025-07-21 17:40:37','2025-07-21 17:52:55'),(94,'App\\Models\\User',1,'admin_token','ad7f84335226034ab164eed0f5b5e3f10249ab116046fd72152396e3abd426b4','[\"*\"]','2025-07-21 18:47:42',NULL,'2025-07-21 18:13:06','2025-07-21 18:47:42'),(95,'App\\Models\\User',1,'admin_token','5b048aa6ab4043233a71262ce5d7cca172d4f8c5035e2940fa2910a8c6a348af','[\"*\"]','2025-07-21 20:41:27',NULL,'2025-07-21 19:07:30','2025-07-21 20:41:27'),(96,'App\\Models\\User',1,'admin_token','2f480e8d6d2647d9ff50852c9c20675bb73bf89d22df9fdad3aeea7628779645','[\"*\"]','2025-07-21 19:30:04',NULL,'2025-07-21 19:29:57','2025-07-21 19:30:04'),(98,'App\\Models\\User',1,'admin_token','880e19f2824211b07ef2a60a8feb3750c22fb7cd2beaa23d880b53577fa57efe','[\"*\"]','2025-07-21 21:02:11',NULL,'2025-07-21 20:18:24','2025-07-21 21:02:11'),(99,'App\\Models\\User',1,'admin_token','0c3b8719c1c8fe7132f81032df3dae9b30815bf5e8b82f66044ce4a10d2a5e3d','[\"*\"]','2025-07-22 07:26:56',NULL,'2025-07-22 07:24:13','2025-07-22 07:26:56'),(100,'App\\Models\\User',1,'admin_token','e8230545d2897115b6da740cea5cd0a1ffb8a72f8a83a96140a6c245fbb42ca9','[\"*\"]','2025-07-22 16:28:55',NULL,'2025-07-22 16:25:01','2025-07-22 16:28:55'),(101,'App\\Models\\User',1,'admin_token','7036282da78c49de8c73e2976cf3b6a6ea94eafbeede07152b8d98438eafe845','[\"*\"]','2025-07-22 16:30:12',NULL,'2025-07-22 16:27:24','2025-07-22 16:30:12'),(103,'App\\Models\\UserCliente',15,'cliente_token','8f5ef3665296f0b55c41531996b8c6c3fd5b432005eae8d7c3b7d2f05460eefb','[\"*\"]',NULL,NULL,'2025-07-24 15:16:52','2025-07-24 15:16:52'),(104,'App\\Models\\User',1,'admin_token','cb277db29a46841f8b66c7f95f82360b3a392c34729cbd82f0285af1b16e39de','[\"*\"]','2025-07-24 15:22:08',NULL,'2025-07-24 15:21:19','2025-07-24 15:22:08'),(106,'App\\Models\\User',1,'admin_token','b7a85cd149e6302e0995de9a810b89f25742ce8703760953f74a2ec016bfa7b0','[\"*\"]','2025-07-30 14:02:34',NULL,'2025-07-30 13:56:52','2025-07-30 14:02:34'),(107,'App\\Models\\User',1,'admin_token','6ccbfa1d89fb43c71d2af2b19f915690111d35154fc1c1f1b8ec9aabf8d1255c','[\"*\"]','2025-07-30 14:07:01',NULL,'2025-07-30 14:06:13','2025-07-30 14:07:01'),(108,'App\\Models\\User',1,'admin_token','735884c3b152fb5c0bda6f1974e68d1de379676947039eb141bfe00d305f183d','[\"*\"]','2025-08-15 13:53:36',NULL,'2025-08-01 16:07:28','2025-08-15 13:53:36'),(109,'App\\Models\\User',1,'admin_token','7c76a275c0008bc8cb965db622fc1069be4e49a8c51b61cf0a1730191fe5d3d0','[\"*\"]','2025-08-14 19:10:29',NULL,'2025-08-14 18:00:19','2025-08-14 19:10:29'),(110,'App\\Models\\User',1,'admin_token','16b287b0f727a012ac30fb672545debac244e624a5fed526356bb72d5ac303a0','[\"*\"]','2025-08-14 20:13:53',NULL,'2025-08-14 19:46:15','2025-08-14 20:13:53'),(111,'App\\Models\\User',1,'admin_token','d0fa5e1b4b7f2217ef5fa1b840af52521133336cef5f4af08a64f94ea06b7e5b','[\"*\"]','2025-10-06 08:16:51',NULL,'2025-08-15 09:39:11','2025-10-06 08:16:51'),(113,'App\\Models\\User',1,'admin_token','9b6c64de7fbb30e893a84680f60dd73c87f4ea7678f1a841defd752e9b7210fb','[\"*\"]','2025-08-19 06:15:58',NULL,'2025-08-16 10:16:17','2025-08-19 06:15:58'),(114,'App\\Models\\UserCliente',3,'cliente_token','e71654541326a40b0c78de84e28c7dbe74a715ec685bd6738214e25f920d25ac','[\"*\"]','2025-08-22 15:43:28',NULL,'2025-08-22 12:24:14','2025-08-22 15:43:28'),(116,'App\\Models\\User',1,'admin_token','4d1918d2e897d91fd1ba9e35274c552ac568ba873e351d2722be3f12b935b7d3','[\"*\"]','2025-09-01 11:55:04',NULL,'2025-09-01 06:55:41','2025-09-01 11:55:04'),(120,'App\\Models\\User',1,'admin_token','66e1f4c894f4f46b0562e5dde878854e6ee23057bade0878da201452ae0a95c2','[\"*\"]','2025-09-02 14:30:48',NULL,'2025-09-02 14:29:58','2025-09-02 14:30:48'),(123,'App\\Models\\UserCliente',21,'auth_token','baf8edec9af883f8d9ae91738e187cd858084058da96e5c2510527f8cd9eb3fe','[\"*\"]',NULL,NULL,'2025-09-07 20:08:06','2025-09-07 20:08:06'),(124,'App\\Models\\UserCliente',21,'auth_token','5dd197ee8640061b735a6fed7a5d6cf01abb670824ad11091aca4654e94de6a1','[\"*\"]',NULL,NULL,'2025-09-07 20:11:27','2025-09-07 20:11:27'),(125,'App\\Models\\UserCliente',21,'cliente_token','ab8b6a68ac7f2de4b6c839d2d63eb60323621b7d9bd5cc86edb17c7aa66f7ac4','[\"*\"]','2025-09-09 13:41:14',NULL,'2025-09-08 05:33:17','2025-09-09 13:41:14'),(138,'App\\Models\\User',1,'admin_token','fa8e9206f44fe4da1b8c250edfecb65553d85a099d779883f1b6473d7dbe8e1e','[\"*\"]','2025-09-16 20:57:48',NULL,'2025-09-16 20:44:16','2025-09-16 20:57:48'),(139,'App\\Models\\UserCliente',22,'auth_token','b004b92b094cfba1a69970c56e22e1934b82b4c9ad3f97ef1a48e0775a5eeaa6','[\"*\"]',NULL,NULL,'2025-09-18 10:45:08','2025-09-18 10:45:08'),(142,'App\\Models\\UserCliente',4,'auth_token','fc019d01512299e18d2ebe886e673ee23d7279e8547b93c09f95a4fc3d524bfb','[\"*\"]',NULL,NULL,'2025-09-18 16:02:11','2025-09-18 16:02:11'),(143,'App\\Models\\UserCliente',4,'auth_token','55cdb3975d71f6018c21b9d472428e0f2700aaf8bdb04f35dd6044b8a697e49a','[\"*\"]',NULL,NULL,'2025-09-18 16:02:54','2025-09-18 16:02:54'),(144,'App\\Models\\UserCliente',4,'auth_token','3b268de24d46a9e550c5bd613f96bf0e9bb6dcc5b169ac5d575579b6968786e1','[\"*\"]',NULL,NULL,'2025-09-18 16:03:15','2025-09-18 16:03:15'),(145,'App\\Models\\UserCliente',4,'auth_token','0f664a6102c4bc4cbac811c2eb9c1db3accd0cbe41b0485d0b15d178fa2860c8','[\"*\"]',NULL,NULL,'2025-09-18 16:04:56','2025-09-18 16:04:56'),(146,'App\\Models\\UserCliente',4,'auth_token','72f249d67022798ff78b9b1145971286ee7d846f9a9ed44839abf2c6e0769f6d','[\"*\"]',NULL,NULL,'2025-09-18 16:05:03','2025-09-18 16:05:03'),(147,'App\\Models\\UserCliente',4,'auth_token','8d11acbda58f0273824bf7652b8044fd79090aeff81229753100a0e6e0a16c20','[\"*\"]',NULL,NULL,'2025-09-18 16:34:44','2025-09-18 16:34:44'),(148,'App\\Models\\UserCliente',4,'auth_token','4fe87c278c1ece0ebb4d91cf98a977686402fe5b151a0c629f37c1f4bb7c1ca1','[\"*\"]',NULL,NULL,'2025-09-18 16:50:11','2025-09-18 16:50:11'),(149,'App\\Models\\UserCliente',4,'auth_token','d6c38ab8d2d7b47383e203e238c707c01b1fb3324266f31bd632c81739546c19','[\"*\"]',NULL,NULL,'2025-09-18 16:53:04','2025-09-18 16:53:04'),(150,'App\\Models\\UserCliente',4,'auth_token','be2609afbba1c418f7ef57901578f67af46fce7d126e694c8b484ee1ec5c2824','[\"*\"]',NULL,NULL,'2025-09-18 17:06:40','2025-09-18 17:06:40'),(151,'App\\Models\\UserCliente',4,'auth_token','cc3092d48fa238d13ccfb6209ec7a3fdf56696232521c949dcb1e3b4b53f7b56','[\"*\"]',NULL,NULL,'2025-09-18 17:38:01','2025-09-18 17:38:01'),(153,'App\\Models\\UserCliente',4,'auth_token','91705e5ab5a08c99acce328cb738b1cd6bb033dd0073c48a39ba1050fd54ca0a','[\"*\"]',NULL,NULL,'2025-09-19 11:04:48','2025-09-19 11:04:48'),(154,'App\\Models\\UserCliente',4,'auth_token','f8efbbcb7816b7b7e11198b06e05a1515bee1d54afd09ef7e41e183fe57536f6','[\"*\"]',NULL,NULL,'2025-09-19 13:59:23','2025-09-19 13:59:23'),(158,'App\\Models\\User',1,'admin_token','982fecff465dcf11514d62cc3bb5acc61aeffb0c9234b211bc0cde7e151ff93a','[\"*\"]','2025-10-04 15:33:29',NULL,'2025-09-20 07:43:06','2025-10-04 15:33:29'),(159,'App\\Models\\UserCliente',3,'cliente_token','9b9cfbf83fbe08d3c5302ca8dc2a4ab8ea34eadec76053f53dd4b8e21787f2de','[\"*\"]','2025-09-22 08:20:25',NULL,'2025-09-22 08:00:07','2025-09-22 08:20:25'),(162,'App\\Models\\UserMotorizado',2,'motorizado_token','f559dd0a5e0824e3a5931f96fddd08eb575041fd0e21670bd74f34dbff66fd91','[\"*\"]','2025-09-22 08:45:16',NULL,'2025-09-22 08:45:15','2025-09-22 08:45:16'),(163,'App\\Models\\UserMotorizado',2,'motorizado_token','bfee38ebfc3ce87a18ead59b5174186baf945b99b9f1b0285304e78c1b60ab5e','[\"*\"]','2025-09-22 08:45:21',NULL,'2025-09-22 08:45:21','2025-09-22 08:45:21'),(164,'App\\Models\\UserMotorizado',2,'motorizado_token','1614f5729dd2d4a937c5901c34942a8489d9b9f7d95b59de841f7dbeaf4788bd','[\"*\"]','2025-09-22 08:45:24',NULL,'2025-09-22 08:45:22','2025-09-22 08:45:24'),(168,'App\\Models\\User',1,'admin_token','bd2829570b93a7490d1b750bdd65800e6f52d75484ba3305be38a5380747f01f','[\"*\"]','2025-09-23 13:24:20',NULL,'2025-09-23 13:24:19','2025-09-23 13:24:20'),(175,'App\\Models\\User',1,'admin_token','9b2ebcb36e17ab6e3a7be01de8c402c802eacc16c60994818e4206806eae1ef3','[\"*\"]','2025-09-26 05:20:19',NULL,'2025-09-24 07:55:58','2025-09-26 05:20:19'),(176,'App\\Models\\User',1,'admin_token','b1d41640bec2e3b10b7fff12d65a5e2dea2b1596ecf29daf50d9238325273348','[\"*\"]','2025-09-25 18:55:04',NULL,'2025-09-25 18:44:57','2025-09-25 18:55:04'),(178,'App\\Models\\User',1,'admin_token','8eb07561bb99c0b12a483a8e63e66274c1db554d821683b875307b9b5efbf8fd','[\"*\"]','2025-09-26 05:24:04',NULL,'2025-09-26 05:22:18','2025-09-26 05:24:04'),(180,'App\\Models\\User',1,'admin_token','bacfefad2159f9d2939a834c7609d9d2c7b40ea8659cda094c2b3d0d0950cb18','[\"*\"]','2025-09-26 05:49:06',NULL,'2025-09-26 05:45:02','2025-09-26 05:49:06'),(181,'App\\Models\\User',1,'admin_token','e73a6787e0e74eed561a15b62f0bcafa6b55e9f48d0e81d7337d1fb4b15a4b7f','[\"*\"]','2025-09-26 06:46:06',NULL,'2025-09-26 06:45:51','2025-09-26 06:46:06'),(186,'App\\Models\\User',1,'admin_token','f0749aef86de1150567760c2056f03f26201732162a5f40673d7c7e810ae18eb','[\"*\"]','2025-09-26 14:45:09',NULL,'2025-09-26 14:28:47','2025-09-26 14:45:09'),(188,'App\\Models\\UserCliente',31,'auth_token','2b3dcf78965d8810ff60ad2e88b77d544496b6ce32861f817094951d9c8b7435','[\"*\"]',NULL,NULL,'2025-09-27 12:46:42','2025-09-27 12:46:42'),(194,'App\\Models\\User',1,'admin_token','e4400ef6897f879485bd01e2de9da1c3682a8709e53a58647bb4c3865dde58d4','[\"*\"]','2025-09-28 13:39:55',NULL,'2025-09-27 19:00:51','2025-09-28 13:39:55'),(197,'App\\Models\\User',1,'admin_token','aeae39ce4e4b95dea4f79a90f8a226519e5d7d921ec1f10a0622c4771ced04ed','[\"*\"]','2025-09-30 19:40:05',NULL,'2025-09-27 19:31:57','2025-09-30 19:40:05'),(204,'App\\Models\\User',1,'admin_token','276f0575f7bf728d388a73e61871ff65054a5293f39fe1a4027bb4eb8f55b1cc','[\"*\"]','2025-09-29 16:10:18',NULL,'2025-09-29 10:47:13','2025-09-29 16:10:18'),(209,'App\\Models\\User',1,'admin_token','9c12615c952aec4edd571be15d70297ca312cf9af14c74500ffa41fa3a370d17','[\"*\"]','2025-10-01 14:11:49',NULL,'2025-10-01 07:55:30','2025-10-01 14:11:49'),(213,'App\\Models\\User',1,'admin_token','bf0f3c70899a37668d9ea07764c24d8a01c3e04f4d5da062a1d0dff743d3a1b6','[\"*\"]','2025-10-01 11:56:20',NULL,'2025-10-01 11:55:00','2025-10-01 11:56:20'),(214,'App\\Models\\User',1,'admin_token','64b62e5a717dd5e54dc165f389363f00597ad25cd8ef2d5a2355af1d02115d2f','[\"*\"]','2025-10-06 08:17:16',NULL,'2025-10-01 14:13:11','2025-10-06 08:17:16'),(216,'App\\Models\\User',1,'admin_token','b9be3b6ae44b52b49dea12bad647446aae66c454f31c72a90e8f259016f3a0c0','[\"*\"]','2025-10-02 10:21:13',NULL,'2025-10-02 10:20:56','2025-10-02 10:21:13'),(217,'App\\Models\\User',1,'admin_token','9f462cb7aad400085c251d006025cd257c4bf671e8f15c86ce0bada587d67e50','[\"*\"]','2025-10-02 19:07:50',NULL,'2025-10-02 19:07:09','2025-10-02 19:07:50'),(218,'App\\Models\\User',1,'admin_token','efb945ccbb1c3e7ab06a199cf0132aaf5b8f48f043276b5402d046ce6bd71fdb','[\"*\"]','2025-10-03 09:35:12',NULL,'2025-10-03 09:18:12','2025-10-03 09:35:12'),(219,'App\\Models\\User',1,'admin_token','eddf9c55e17a83417e0965d5d7bd68e0bc9e137563e2821bfe3c591641da48f9','[\"*\"]','2025-10-03 11:50:14',NULL,'2025-10-03 11:05:34','2025-10-03 11:50:14'),(222,'App\\Models\\User',1,'admin_token','3e0c9f8d8a42f21c4c3b215a7481b6efb9f1f77639db300460da856e329bdb44','[\"*\"]','2025-10-04 16:01:32',NULL,'2025-10-04 13:53:03','2025-10-04 16:01:32'),(223,'App\\Models\\User',1,'admin_token','1a67b02a9b6bca349919032a5c78447815c8d13ae63e1c77a90e08e94edaf50e','[\"*\"]','2025-10-04 15:15:34',NULL,'2025-10-04 15:13:22','2025-10-04 15:15:34'),(224,'App\\Models\\User',1,'admin_token','7c7c97a9938d8f571fb9426b86be3ebe4f821b03edba4e6f7f88b0dd237980c7','[\"*\"]','2025-10-04 15:20:31',NULL,'2025-10-04 15:18:08','2025-10-04 15:20:31'),(225,'App\\Models\\User',1,'admin_token','741ccbedb45d8dbc65b99b2b533d9b37d1cc8dd75be7980ab4ae954b73e58d10','[\"*\"]','2025-10-04 17:26:22',NULL,'2025-10-04 17:25:39','2025-10-04 17:26:22'),(226,'App\\Models\\User',1,'admin_token','7d078f56d65618369bd2cc6daf51f40e03474e4762e8f7d45e76a78623eba558','[\"*\"]','2025-10-06 07:13:34',NULL,'2025-10-06 06:50:41','2025-10-06 07:13:34'),(231,'App\\Models\\User',1,'admin_token','d0364f26e17e8a49e7e86b90d5227df2830f4656d9c7f7fec5732791eb140457','[\"*\"]','2025-10-06 08:49:10',NULL,'2025-10-06 08:30:12','2025-10-06 08:49:10'),(234,'App\\Models\\User',1,'admin_token','1fa6d1dc6142ce8c450f6b2c6827c2079ffdbd45d5b3262bc3dc5254a02358fa','[\"*\"]','2025-10-06 04:15:41',NULL,'2025-10-06 03:50:16','2025-10-06 04:15:41');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
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
  `descripcion_detallada` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `caracteristicas_tecnicas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `instrucciones_uso` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `garantia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `politicas_devolucion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `dimensiones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `imagenes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `videos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `producto_detalles_producto_id_foreign` (`producto_id`) USING BTREE,
  CONSTRAINT `producto_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_detalles`
--

LOCK TABLES `producto_detalles` WRITE;
/*!40000 ALTER TABLE `producto_detalles` DISABLE KEYS */;
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
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `codigo_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_id` bigint unsigned NOT NULL,
  `marca_id` bigint unsigned DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `stock_minimo` int NOT NULL DEFAULT '5',
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  KEY `idx_productos_deleted_at` (`deleted_at`) USING BTREE,
  CONSTRAINT `productos_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `productos_marca_id_foreign` FOREIGN KEY (`marca_id`) REFERENCES `marcas_productos` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (16,'PROCESADOR INTEL CORE i7-14700K, Cache 33 MB, Hasta 5.6 Ghz.','El Intel Core i7-14700K es un procesador premium de 14ª generación diseñado para entusiastas y profesionales. Con 20 núcleos híbridos y frecuencia turbo de hasta 5.6GHz, ofrece un rendimiento sobresaliente en multitarea, productividad y gaming de alta gama.','i7',19,14,50.00,100.00,40,2,'1759246238_68dbf79ea47c9.jpg',1,0,1,'2025-09-30 08:30:38','2025-10-06 07:10:03',NULL),(17,'PROCESADOR AMD RYZEN 9 9950X, Cache 64 MB, Hasta 5.7 Ghz, AM5','AMD Ryzen 9 9950X es el abanderado de esta última generación de procesadores en la cual se vuelve a reducir el proceso de fabricación, pasando de 5 nm a 4 nm FinFET, una vez más construidos por TSMC.','ryzen',19,15,20.00,50.00,10,2,'1759285944_68dc92b8c4d6b.jpg',1,0,1,'2025-09-30 19:32:24','2025-10-06 07:09:38',NULL),(18,'PROCESADOR AMD RYZEN 7 9700X, Cache 32 MB, Hasta 5.5 Ghz, AM5','Durante décadas, AMD ha estado a la vanguardia de la tecnología para superar los límites de lo que la IA puede lograr; ahora, tú puedes experimentar la potencia de tu propia tecnología de inteligencia artificial increíblemente avanzada8. Prepárate para darle la bienvenida al futuro con nuevas capacidades que solo AMD Ryzen puede proporcionar. No importa si habilitas la mejor plataforma de IA con Ryzen Serie 9000 o AMD Ryzen AI con procesadores seleccionados Ryzen Serie 8000G, esto es la clave para desbloquear experiencias de IA mágicas en tu PC.','AMD',19,15,10.00,80.00,14,2,'1759286136_68dc93782d9cc.jpg',1,0,1,'2025-09-30 19:35:36','2025-10-06 07:09:27',NULL),(19,'MOUSE GAMING CORSAIR KATAR PRO, HASTA 12400 Dpi, 6 Botones Programables, Rgb, Negro','Disfrute del diseño ligero y del rendimiento de peso pesado del ratón ultraligero para juegos CORSAIR KATAR PRO. Solo pesa 69 g, tiene una forma simétrica compacta y cuenta con un sensor óptico preciso de 12.400 ppp.','CORSAIR',17,17,50.00,95.00,10,5,'1759331595_68dd450b0a7e3.png',1,0,1,'2025-10-01 08:13:15','2025-10-01 09:09:51',NULL),(20,'MOUSE RAZER DEATHADDER ESSENTIAL, 6400 DPI, SWITCH MECHANICAL, BLACK','El Razer DeathAdder Essential conserva el diseño ergonómico clásico que ha sido un sello distintivo de las generaciones anteriores de Razer DeathAdder. Su cuerpo elegante y distintivo está diseñado para la comodidad que te permite mantener un nivel alto de rendimiento a lo largo de largas maratones de juego, para que nunca flaquees en el fragor de la batalla.','RAZER',17,12,50.00,95.00,10,5,'1759331806_68dd45de38c6f.jpg',1,0,1,'2025-10-01 08:16:46','2025-10-06 07:06:09',NULL),(21,'MOUSE LOGITECH G PRO 2 LIGTHSPEED WIRELESS, HERO 2, 44K Dpi, RGB, WHITE','Diseñado con profesionales y fabricado para ganar, el mouse inalámbrico Logitech G PRO 2 LIGHTSPEED es un mouse simétrico y ambidiestro con botones laterales magnéticos personalizables que ofrece un rendimiento ultrarrápido y preciso y un estilo personalizable para jugadores competitivos.','LOGITECH',17,11,150.00,360.00,10,5,'1759331955_68dd4673a7c16.jpg',1,0,1,'2025-10-01 08:19:15','2025-10-06 07:05:45',NULL),(22,'SDFASDF','ASDASD','SDFSADF',13,NULL,10.00,100.00,10,5,'1759333161_68dd4b2910693.jpg',1,0,1,'2025-10-01 08:39:21','2025-10-01 09:08:17','2025-10-01 09:08:17'),(23,'MOUSE INALAMBRICO/BT GAMING RAZER BASILISK V3 PRO, 35K DPi, BLACK','Lleva tu inmersión al máximo con el Razer Basilisk V3 Pro 35K: un ratón gaming RGB ergonómico inalámbrico más avanzado y personalizable que nunca. Con nuestro sensor y rueda de desplazamiento más precisos y opciones de configuración más detalladas, jugar a tu manera acaba de adquirir un significado totalmente nuevo.','001',17,12,400.00,500.00,20,5,'1759333360_68dd4bf0c8734.jpg',1,0,1,'2025-10-01 08:41:53','2025-10-01 09:10:33',NULL),(24,'MOUSE INALAMBRICO/BT GAMING RAZER BASILISK V3 PRO, 35K DPi, WHITE','Lleva tu inmersión al máximo con el Razer Basilisk V3 Pro 35K: un ratón gaming RGB ergonómico inalámbrico más avanzado y personalizable que nunca. Con nuestro sensor y rueda de desplazamiento más precisos y opciones de configuración más detalladas, jugar a tu manera acaba de adquirir un significado totalmente nuevo.','002',17,12,350.00,550.00,10,5,'1759333428_68dd4c3427c0a.png',1,0,1,'2025-10-01 08:43:48','2025-10-06 07:05:36',NULL),(25,'MOUSE LOGITECH PRO 2 LIGTHSPEED WIRELESS, HERO 2, 44K DPi, RGB BLACK','Diseñado con profesionales y fabricado para ganar, el mouse inalámbrico Logitech G PRO 2 LIGHTSPEED es un mouse simétrico y ambidiestro con botones laterales magnéticos personalizables que ofrece un rendimiento ultrarrápido y preciso y un estilo personalizable para jugadores competitivos.','1010',17,11,200.00,350.00,10,5,'1759333589_68dd4cd5df3a7.jpg',1,0,1,'2025-10-01 08:46:29','2025-10-06 07:05:52',NULL),(26,'MOUSE RAZER BASILISK V3, 26K DPi, CHROMA BLACK','Experimenta un nuevo nivel de inmersión, personalización y precisión con el Razer Basilisk V3 35K, nuestro ratón gaming RGB con cable más avanzado. Con un sensor de última generación y una rueda de desplazamiento diseñada para una configuración más detallada, ahora tienes todo lo que necesitas para crear el escenario perfecto para jugar.','1012',17,12,150.00,210.00,10,5,'1759333704_68dd4d489e345.jpg',1,0,1,'2025-10-01 08:48:24','2025-10-06 07:06:02',NULL),(27,'MOUSE RAZER DEATHADDER ESSENTIAL, 6400 DPI, SWITCH MECHANICAL, WHITE','El Razer DeathAdder Essential conserva el diseño ergonómico clásico que ha sido un sello distintivo de las generaciones anteriores de Razer DeathAdder. Su cuerpo elegante y distintivo está diseñado para la comodidad que te permite mantener un nivel alto de rendimiento a lo largo de largas maratones de juego, para que nunca flaquees en el fragor de la batalla.','10123',17,12,90.00,105.00,10,5,'1759333840_68dd4dd0e6a7c.jpg',1,0,1,'2025-10-01 08:50:40','2025-10-06 07:06:50',NULL),(28,'MOUSE GAMING MSI FORGE GM300, 7200 DPI, RGB','Conmutadores de mouse duraderos : años de juego con conmutadores con capacidad para más de 10 millones de clics.\r\nSensor de mouse óptico preciso : hasta 7200 DPI para brindar un seguimiento preciso.\r\nDP I ajustable : 4 ajustes preestablecidos de DPI para ajustar su precisión en cada situación.\r\nDiseño simétrico : adecuado para estilos de agarre con palma y garra, y amigable para usuarios zurdos.\r\nLED RGB : ilumine el ambiente jugando con efectos predefinidos para lograr el ambiente preferido.','1001',17,18,90.00,105.00,10,5,'1759334097_68dd4ed1b7297.jpg',1,0,1,'2025-10-01 08:54:57','2025-10-01 09:10:22',NULL),(29,'MOUSE GAMING INALAMBRICO/BT ASUS P709 ROG KERIS WL AIMPOINT','Mouse inalámbrico RGB: 75 gramos\r\nSensor óptico ROG AimPoint: 36,000 ppp\r\nConectividad trimodo\r\nTecnología inalámbrica ROG SpeedNova\r\nSwitches de mouse intercambiables\r\nMicroswitches ROG\r\nBotones PBT\r\nROG Paracord\r\nPies de mouse 100% PTFE\r\nCinco botones programables','ASUS',17,10,90.00,270.00,10,5,'1759334264_68dd4f7821515.jpg',1,0,1,'2025-10-01 08:57:44','2025-10-01 09:09:57',NULL),(30,'TECLADO MSI FORGE GK600 TKL WIRELESS SKY, RGB','El MSI FORGE GK600 TKL WIRELESS es un teclado versátil con modos inalámbrico, Bluetooth y con cable de 2,4 GHz. Cuenta con interruptores mecánicos lineales intercambiables al instante, cubiertas de teclas PBT duraderas, juntas de amortiguación del sonido y una pantalla de 1,06 pulgadas. Con iluminación RGB y una batería de 4000 mAh, es ideal para gamers y creadores.','MSI',22,NULL,110.00,220.00,10,5,'1759334557_68dd509dcc5d1.jpg',1,0,1,'2025-10-01 09:02:37','2025-10-01 09:02:37',NULL),(31,'TECLADO RAZER HUNTSMAN V3 PRO MINI, 60%, SWITCHES OPTICOS ANALOGICOS GEN2, WHITE','Experimenta una capacidad de respuesta imbatible a un nivel nunca visto con el Razer Huntsman V3 Pro Mini, un teclado reducido al 60 % equipado con nuestros últimos switches ópticos analógicos. Superequipado con el modo de activación rápida y Razer™ Snap Tap, ejecuta entradas más sensibles a velocidades inigualables. Personalízalo aún más con el accionamiento ajustable para optimizar su ventaja competitiva.','10011',22,NULL,300.00,550.00,10,5,'1759334641_68dd50f18bf48.jpg',1,0,1,'2025-10-01 09:04:01','2025-10-01 09:04:01',NULL),(32,'TECLADO GAMING LOGITECH G915 X LIGHTSPEED TKL, INALAMBRICO, RGB, BLACK','Logitech G915 X LIGHTSPEED TKL ofrece velocidad, precisión y personalización icónicas con un diseño elegante y sin tenacillas. Este teclado inalámbrico para juegos cuenta con conectividad tri-mode, KEYCONTROL, interruptores mecánicos GL y LIGHTSYNC RGB.','100112',22,11,300.00,700.00,10,5,'1759334699_68dd512bad9cf.jpg',1,0,1,'2025-10-01 09:04:59','2025-10-01 09:09:36',NULL),(33,'TECLADO GAMING LOGITECH G915 X LIGHTSPEED TKL, INALAMBRICO, RGB, BLACK','Experimenta una capacidad de respuesta imbatible a un nivel nunca visto con el Razer Huntsman V3 Pro Mini, un teclado reducido al 60 % equipado con nuestros últimos switches ópticos analógicos. Superequipado con el modo de activación rápida y Razer™ Snap Tap, ejecuta entradas más sensibles a velocidades inigualables. Personalízalo aún más con el accionamiento ajustable para optimizar su ventaja competitiva.','1001323',22,NULL,300.00,700.00,10,5,'1759334860_68dd51cc13ade.jpg',1,0,1,'2025-10-01 09:07:40','2025-10-01 09:08:07','2025-10-01 09:08:07'),(34,'TECLADO RAZER HUNTSMAN V3 PRO MINI, 60%, SWITCHES OPTICOS ANALOGICOS GEN2, RGB, BLACK','Experimenta una capacidad de respuesta imbatible a un nivel nunca visto con el Razer Huntsman V3 Pro Mini, un teclado reducido al 60 % equipado con nuestros últimos switches ópticos analógicos. Superequipado con el modo de activación rápida y Razer™ Snap Tap, ejecuta entradas más sensibles a velocidades inigualables. Personalízalo aún más con el accionamiento ajustable para optimizar su ventaja competitiva.','100145',22,NULL,300.00,590.00,10,5,'1759335177_68dd5309de61d.jpg',1,0,1,'2025-10-01 09:12:57','2025-10-01 09:12:57',NULL),(35,'TECLADO RAZER BLACKWIDOW V4, MECANICO, SWITCH GREEN, RGB BLACK','Disfruta de tu zona de juego a pleno rendimiento con el centro de control perfecto para la configuración de tu PC. Repleto de teclas macro y multimedia, accede a comandos y accesos directos avanzados, mientras aumentas la inmersión con un teclado mecánico muy evolucionado que va a por todas con Razer Chroma™ RGB.','1001456',22,NULL,300.00,600.00,10,5,'1759335252_68dd535479111.jpg',1,0,1,'2025-10-01 09:14:12','2025-10-01 09:14:12',NULL),(36,'TECLADO RAZER BLACKWIDOW V4 PRO, MECANICO, SWITCH YELLOW, RGB BLACK','Mejora tu juego con una pieza central que mejora todo tu equipo. Adéntrate en la siguiente fase de la evolución de las zonas de juego con el teclado mecánico gaming definitivo. Asume el mando con un conjunto de características diseñadas para un control avanzado y mejora tu inmersión con el Razer Chroma™ RGB completo.','1001457',22,NULL,300.00,800.00,10,5,'1759335361_68dd53c13a471.jpg',1,0,1,'2025-10-01 09:16:01','2025-10-01 09:16:01',NULL),(37,'TECLADO MECANICO INALAMBRICO ANTRYX MK845 TRIX, SWITCH BLUE','Factor de forma TKL, tamaño compacto manteniendo la funcionalidad\r\nRetroiluminación y luz de teclas personalizables en color RGB\r\n20 efectos de iluminación preestablecidos, el usuario puede ajustar el brillo de la luz de fondo, la velocidad de respiración, la dirección de la luz de fondo y otros efectos de iluminación\r\nIluminación de 7 colores y 2 efectos en la barra lateral\r\nInterruptor mecánico Outemu para una mayor capacidad de respuesta, sonido de clic audible y retroalimentación táctil nítida y precisa para el mejor rendimiento de juego\r\n3 modos de conectividad, con conexión inalámbrica de 2,4 Ghz, Bluetooth v5.0 y cable USB, este teclado inalámbrico para juegos que ya no limita la forma en que puede conectarse. Además, en modo Bluetooth, puedes conectar hasta 3 dispositivos.\r\nTodas las teclas con tecnología antighosting, cada pulsación de tecla se detecta correctamente\r\nLas teclas moldeadas por inyección de doble disparo ofrecen una retroiluminación clara y uniforme y letras que no se rayan\r\nSoftware personalizable 3 perfiles y macros\r\n12 funciones multimedia y de oficina\r\nIncluye un juego completo de keycaps full Negro para que puedas personalizar a tu gusto','100036',22,25,120.00,200.00,10,5,'1759335476_68dd54346080b.jpg',1,0,1,'2025-10-01 09:17:56','2025-10-06 07:13:17',NULL),(38,'TECLADO GAMING LOGITECH G915 X LIGHTSPEED TKL, INALAMBRICO, RGB, BLACK','Logitech G915 X LIGHTSPEED TKL ofrece velocidad, precisión y personalización icónicas con un diseño elegante y sin tenacillas. Este teclado inalámbrico para juegos cuenta con conectividad tri-mode, KEYCONTROL, interruptores mecánicos GL y LIGHTSYNC RGB.','1000368',22,11,400.00,700.00,10,5,'1759335569_68dd5491dbeae.jpg',1,0,1,'2025-10-01 09:19:29','2025-10-06 07:13:09',NULL),(39,'TECLADO RAZER ORNATA V3, SWITCH MEMBRANA MECANICA LOW PROFILE CHROMA BLACK','Te presentamos el Razer Ornata V3, un teclado gaming ergonómico de perfil bajo con tecnología Razer Chroma™ RGB. Mejora tu trabajo y tu juego con un teclado híbrido que combina lo mejor de ambos mundos, con un nuevo diseño ultrafino, teclas más duraderas y switches de membrana mecánica únicos.','1000369',22,NULL,400.00,230.00,10,5,'1759335678_68dd54febbaa2.jpg',1,0,1,'2025-10-01 09:21:18','2025-10-01 09:21:18',NULL),(40,'TECLAD MECANICO ANTRYX MK ZIGRA EVO, BLACK/GRAY, SWITCH RED','Retroiluminación y luz de teclas personalizables en color RGB\r\n9 efectos de iluminación preestablecidos, el usuario puede ajustar el brillo de la luz de fondo, la velocidad de respiración, la dirección de la luz de fondo y otros efectos de iluminación\r\nIluminación arcoiris en la barra lateral\r\nInterruptor mecánico Outemu para una mayor capacidad de respuesta, sonido de clic audible y retroalimentación táctil nítida y precisa para el mejor rendimiento de juego\r\nTodas las teclas con tecnología Anti-Ghosting, cada pulsación de tecla se detecta correctamente\r\nLas teclas moldeadas por inyección de doble disparo ofrecen una retroiluminación clara y uniforme y letras que no se rayan\r\nSoftware personalizable 3 perfiles y macros\r\nCubierta superior de aluminio, mejor estética y más resistente\r\n12 funciones multimedia y de oficina\r\nEl reposamuñecas integrado alivia la incomodidad o la fatiga, para que puedas seguir jugando confortablemente ronda tras ronda\r\nIncluye un juego completo de keycaps full Negro para que puedas personalizar a tu gusto','1000370',22,25,100.00,180.00,10,5,'1759335798_68dd55761e3b9.jpg',1,0,1,'2025-10-01 09:23:18','2025-10-06 07:12:59',NULL),(41,'TECLADO MECANICO LOGITECH PRO X TKL LIGHTSPEED BLACK','Un teclado inalámbrico para juegos en el que confían los campeones diseñado para alcanzar los más altos niveles de juego competitivo. Diseñado con profesionales, concebido para ganar.','1000371',22,NULL,500.00,700.00,10,5,'1759336017_68dd56510e5be.jpg',1,0,1,'2025-10-01 09:26:57','2025-10-01 09:26:57',NULL),(42,'PROCESADOR INTEL CORE ULTRA 9 285, Cache 36MB, Hasta 5.7 Ghz','Intel core ultra 9285','1234',19,14,2000.00,2500.00,10,5,'1759336178_68dd56f252722.jpg',1,0,1,'2025-10-01 09:29:38','2025-10-06 07:10:59',NULL),(43,'PROCESADOR INTEL CORE ULTRA 7 265F, Cache 30 MB, Hasta 5.30 Ghz','Intel core ultra 7 265','12341',19,14,1000.00,1400.00,10,5,'1759336260_68dd5744dbf6f.jpg',1,0,1,'2025-10-01 09:31:00','2025-10-06 07:10:44',NULL),(44,'PROCESADOR INTEL CORE ULTRA 5 225F, Cache 20MB, Hasta 4.90 GHz.','Intel core ultra 5 225F','12342',19,14,500.00,740.00,10,5,'1759336323_68dd578347070.jpg',1,0,1,'2025-10-01 09:32:03','2025-10-06 07:10:22',NULL),(45,'PROCESADOR INTEL CORE ULTRA 5 225, Cache 20MB, Hasta 4.90 GHz.','Intel core ultra 5 225','12343',19,14,500.00,800.00,10,5,'1759336383_68dd57bf0ec10.jpg',1,0,1,'2025-10-01 09:33:03','2025-10-06 07:10:14',NULL),(46,'PROCESADOR INTEL CORE ULTRA 7 265KF, Cache 30 MB, Hasta 5.50 Ghz','Intel core ultra 7 265KF','12344',19,14,1000.00,1300.00,10,5,'1759336448_68dd580075e61.jpg',1,0,1,'2025-10-01 09:34:08','2025-10-06 07:10:50',NULL),(47,'PROCESADOR INTEL CORE ULTRA 5 245KF, Cache 24 MB, Hasta 5.2 Ghz.','Intel core ultra 5 245KF','12345',19,14,1000.00,1200.00,10,5,'1759336521_68dd584925206.jpg',1,0,1,'2025-10-01 09:35:21','2025-10-06 07:10:33',NULL),(48,'PROCESADOR INTEL CORE i7-14700F, Cache 33 MB, Hasta 5.40 Ghz.','Intel core i7 14700F','12346',19,14,1000.00,1300.00,10,5,'1759336597_68dd5895520bd.jpg',1,0,1,'2025-10-01 09:36:37','2025-10-06 07:09:55',NULL),(49,'PROCESADOR INTEL CORE i3-14100. Cache 12 MB, Hasta 4.70 Ghz.','Intel core i3 14100','12347',19,14,400.00,500.00,10,5,'1759336677_68dd58e5c9bcf.jpg',1,0,1,'2025-10-01 09:37:57','2025-10-06 07:09:48',NULL),(50,'PROCESADOR INTEL CORE ULTRA 9 285K, Cache 36MB, Hasta 5.7 Ghz','Intel core ultra 9 285K','12348',19,14,2000.00,2600.00,10,5,'1759336771_68dd594365da2.jpg',1,0,1,'2025-10-01 09:39:31','2025-10-06 07:11:07',NULL),(51,'PROCESADOR AMD RYZEN 7 7800X3D','AMD RYZEN 7 7800X3D','12349',19,15,1200.00,1700.00,10,5,'1759336878_68dd59ae9e0a8.jpg',1,0,1,'2025-10-01 09:41:18','2025-10-06 07:09:18',NULL),(52,'PROCESADOR AMD RYZEN 7 5700X','AMD RYZEN 7 5700X','12350',19,15,500.00,700.00,10,5,'1759336957_68dd59fd6195f.jpg',1,0,1,'2025-10-01 09:42:37','2025-10-06 07:09:08',NULL),(53,'REFRIGERACION LIQUIDA DEEPCOOL MYSTIQUE 360 WH, Pantalla LCD','La serie MYSTIQUE es la nueva línea de refrigeración líquida de DeepCool, con pantallas LCD personalizables. ¡Impón tu estilo en la vida con imágenes personalizadas y gifs animados en la pantalla LCD TFT de 2,8 pulgadas! La bomba también ha sido mejorada y optimizada para proporcionar mejor refrigeración que nunca. El MYSTIQUE 360 WH es la pieza perfecta para completar esas configuraciones en blanco limpio. Personaliza la pantalla TFT de 2,8\" con tu contenido. La pantalla tiene una resolución de 640x480 píxeles muy nítidos, y muestra 16,7 millones de colores de manera perfecta. La orientación de la pantalla se ajustará automáticamente a con los sensores giroscópicos de la MYSTIQUE 360 WH.','125',23,19,500.00,700.00,10,5,'1759337388_68dd5bacecbfb.jpg',1,0,1,'2025-10-01 09:49:48','2025-10-06 07:11:39',NULL),(54,'SISTEMA DE REFRIGERACION LIQUIDA ANTRYX TRITON AEGIS 240 BLACK ARGB','Controlador ARGB incluido con más de 55 efectos de iluminación, regula la intensidad y velocidad de iluminación\r\nEfecto infinito: Iluminación con efecto infinito en BOMBA y VENTILADORES, con ARGB cada LED se controla individualmente, presentando más patrones y más modos de color, Compatible con ASUS AURA, ASROCK ARGB, MSI ARGB, GIGABYTE FUSION\r\nBOMBA DE CÁMARA DOBLE: Aísla el refrigerante calentado para maximizar los resultados del enfriamiento del procesador, nuestra bomba es liviana e impermeable a la oxidación y la corrosión\r\nVentilador ARGB con función PWM: PWM FAN se sincroniza con la placa base para brindar una refrigeración óptima manteniendo un bajo nivel de ruido\r\nEl diseño de 7 HOJAS en los ventiladores proporciona un mayor flujo de aire\r\nMayor iluminación Combina el diseño de 2 efectos de iluminación: ventiladores con iluminación en el centro + Iluminación efecto infinito.\r\nRADIADOR CON ESTILO: El radiador de baja resistencia de diseño personalizado permite una mayor tasa de flujo, eficiencia de intercambio de calor y proporciona un rendimiento de enfriamiento inigualable\r\nCero mantenimientos requeridos, solo instale y listo\r\nFEP TUBING hace que sea un tubo con mangas duradero pero flexible en el exterior para darle un aspecto premium\r\n100 % BLOQUE DE COBRE, la conductividad térmica mejorada y el diseño uniforme distribuyen el calor de manera más óptima\r\nFÁCIL DE INSTALAR: la instalación es rápida y fácil para las plataformas Intel y AMD, con todo lo que necesita directamente en la caja\r\nIntel: LGA 1851, 1700, 2011, 1200, 1151, 1150, 1156, 1155\r\nAMD: AM5, AM4, AM3','126',23,25,150.00,200.00,10,5,'1759337466_68dd5bfa5e9b4.jpg',1,0,1,'2025-10-01 09:51:06','2025-10-06 07:12:18',NULL),(55,'REFRIGERACION LIQUIDA DEEPCOOL LE360 WH V2 ARGB','El LE360 WH V2 se basa en la probada gama LE de DeepCool, con un rendimiento mejorado y un diseño renovado. Su cabezal de bomba esmerilado añade un toque moderno, lo que la convierte en una excelente elección para la refrigeración básica.','127',23,19,250.00,380.00,10,5,'1759337542_68dd5c469e7c4.jpg',1,0,1,'2025-10-01 09:52:22','2025-10-06 07:11:26',NULL),(56,'REFRIGERACION LIQUIDA DEEPCOOL LE240 V2 ARGB','El LE360 WH V2 se basa en la probada gama LE de DeepCool, con un rendimiento mejorado y un diseño renovado. Su cabezal de bomba esmerilado añade un toque moderno, lo que la convierte en una excelente elección para la refrigeración básica.','128',23,19,200.00,270.00,10,5,'1759337618_68dd5c92946bd.jpg',1,0,1,'2025-10-01 09:53:38','2025-10-06 07:11:17',NULL),(57,'REFRIGERACION LIQUIDA DEEPCOOL LE360 V2 ARGB','El LE360 V2 se basa en la probada gama LE de DeepCool, con un rendimiento mejorado y un diseño renovado. Su cabezal de bomba esmerilado añade un toque moderno, lo que la convierte en una excelente elección para la refrigeración básica.','129',23,19,250.00,370.00,10,5,'1759337665_68dd5cc167d1f.jpg',1,0,1,'2025-10-01 09:54:25','2025-10-01 14:07:34',NULL),(58,'REFRIGERACION LIQUIDA LIAN LI GALAHAD II LCD 360, WHITE','Cuenta con una pantalla LCD IPS de 2.88” con una resolución de 480×480\r\nAlimentado por una solución Asetek de 8.5.ª generación para radiador de 360 y una solución Asetek de 8.0.ª generación para radiador de 280, con un motor trifásico que alcanza hasta 3600 RPM.\r\nIncluye funciones de grabación y captura de pantalla para mostrar fácilmente sus contenidos favoritos\r\nAcceda a efectos de pantalla únicos y personalización capa por capa a través de L-Connect 3\r\nVentiladores de radiador ARGB conectables en cadena instalados de fábrica, UNI FAN SL-INF o UNI FAN TL Wireless 280\r\nConector de tubería de 45 grados que permite la rotación de 360 ​​grados de los tubos para una mayor versatilidad de instalación','130',23,21,700.00,900.00,10,5,'1759337748_68dd5d14c4d84.jpg',1,0,1,'2025-10-01 09:55:19','2025-10-06 07:11:53',NULL),(59,'REFRIGERACION LIQUIDA LIAN LI GALAHAD II LCD 360, BLACK','Cuenta con una pantalla LCD IPS de 2.88” con una resolución de 480×480\r\nAlimentado por una solución Asetek de 8.5.ª generación para radiador de 360 y una solución Asetek de 8.0.ª generación para radiador de 280, con un motor trifásico que alcanza hasta 3600 RPM.\r\nIncluye funciones de grabación y captura de pantalla para mostrar fácilmente sus contenidos favoritos\r\nAcceda a efectos de pantalla únicos y personalización capa por capa a través de L-Connect 3\r\nVentiladores de radiador ARGB conectables en cadena instalados de fábrica, UNI FAN SL-INF o UNI FAN TL Wireless 280\r\nConector de tubería de 45 grados que permite la rotación de 360 ​​grados de los tubos para una mayor versatilidad de instalación','150',23,21,700.00,900.00,10,5,'1759337810_68dd5d5258ac6.jpg',1,0,1,'2025-10-01 09:56:50','2025-10-06 07:11:46',NULL),(60,'REFRIGERACION LIQUIDA MONTECH HYPER FLOW ARGB 360, BLACK','Obtenga un rendimiento superior con facilidad\r\n\r\nEl HyperFlow ARGB 360 AIO ofrece una eficiencia de refrigeración excepcional, evitando el sobrecalentamiento y optimizando el rendimiento. Con una vibrante iluminación ARGB, mejora tanto la refrigeración como la estética de su PC, permitiéndole llevar su sistema al límite con confianza.','151',23,21,350.00,471.00,10,5,'1759337913_68dd5db9afac8.jpg',1,0,1,'2025-10-01 09:58:33','2025-10-06 07:12:10',NULL),(61,'REFRIGERACION LIQUIDA MONTECH HYPER FLOW ARGB 240, BLACK','Obtenga un rendimiento super\r\nEl HyperFlow ARGB 240 AIO ofrece una eficiencia de refrigeración excepcional, evitando el sobrecalentamiento y optimizando el rendimiento. Con una vibrante iluminación ARGB, mejora tanto la refrigeración como la estética de su PC, permitiéndole llevar su sistema al límite con confianza.','152',23,21,300.00,400.00,10,5,'1759338016_68dd5e20a292c.jpg',1,0,1,'2025-10-01 10:00:16','2025-10-06 07:12:03',NULL),(62,'CASE DEEPCOOL CH780, V/TEMPLADO','La CH780 es una majestuosa caja premium de formato ATX Max que se enfoca en mostrar la belleza del hardware de alta gama que contiene. El flujo de aire y la compatibilidad del disipador tampoco se ignoran, dado que tienen una amplia gama de combinaciones disponibles. Belleza y flujo de aire sin la necesidad de un panel frontal de rejilla. Economiza un valioso espacio en tu escritorio trasladando la monitorización de las temperaturas y el uso de la CPU y la GPU a la pantalla integrada que se incluye con la caja CH780. Una aplicación fácil de instalar y un cabezal USB 2.0 abierto pondrán la pantalla dual en funcionamiento','123',21,19,500.00,700.00,10,5,'1759339376_68dd63703b5d9.jpg',1,0,1,'2025-10-01 10:22:56','2025-10-06 07:00:32',NULL),(63,'CASE ASUS ROG HYPERION GR701 WHITE, 4 COOLER, V/TEMPLADO, ARGB','El ROG Hyperion GR701 trae un factor X tanto en forma como en función que los constructores de todo el mundo han estado anhelando. Con soporte para radiadores dobles de 420mm, tarjetas de video imponentes, un soporte de tarjeta gráfica de aluminio bidireccional completamente integrado, carga de dispositivos de 60 watts y puertos USB-C frontales dobles para motherboards ROG compatibles, es realmente un gabinete de PC en el codiciado estilo ROG.','124',21,10,1300.00,1700.00,10,5,'1759339439_68dd63af28f73.jpg',1,0,1,'2025-10-01 10:23:59','2025-10-06 06:59:37',NULL),(64,'CASE MONTECH X3 GLASS, WHITE','Seis ventiladores RGB con iluminación fija preinstalados\r\nVidrio templado con giro lateral\r\nOpciones de refrigeración versátiles\r\nCompatibilidad flexible con componentes','414751',21,20,200.00,250.00,10,5,'1759339579_68dd643b0d9bc.jpg',1,0,1,'2025-10-01 10:26:19','2025-10-06 07:01:43',NULL),(65,'CASE MONTECH SKY TWO GX, BLACK','El elegante estuche centrado en el flujo de aire\r\n\r\nInnovador panel frontal de malla metálica\r\nVentiladores ARGB AX140 premium\r\nPanel True E-ATX multifuncional\r\nDiseño único de malla en el lado inferior\r\nSoporte para radiador de 360 ​​mm en la parte superior y frontal\r\nDiseño a prueba de polvo en todos los sentidos\r\nSoporte para montaje vertical de GPU\r\nPuerto USB TYPE-C y 2 puertos USB 3.0\r\nAdmite hasta 11 ventiladores','414752',21,20,300.00,400.00,10,5,'1759339641_68dd64793f0dd.jpg',1,0,1,'2025-10-01 10:27:21','2025-10-06 07:01:33',NULL),(66,'CASE ASUS TUF Gaming GT302 ARGB, BLACK, V/TEMPLADO','TUF Gaming GT302 ARGB incorpora un panel frontal de malla de tipo cuadrado optimizado, que garantiza un flujo de aire sin obstrucciones y una gran porosidad diseñada para maximizar la eficiencia del flujo de aire.','414753',21,10,400.00,525.00,10,5,'1759339740_68dd64dc0c5e2.jpg',1,0,1,'2025-10-01 10:29:00','2025-10-06 07:00:13',NULL),(67,'CASE GAMING GAMEMAX BLADE CONCEPT','¡Lleva tu gaming al siguiente nivel con el Case Gaming GAMEMAX BLADE CONCEPT! Su diseño innovador y futurista redefine el concepto de estética y funcionalidad. Con un cuerpo robusto y detalles vanguardistas, este chasis está diseñado para quienes buscan potencia y estilo en cada partida. Su sistema de ventilación optimizado asegura un rendimiento térmico de alta gama, mientras que sus acabados de alta calidad te ofrecen una construcción sólida y elegante. Además, cuenta con amplias opciones de expansión para que puedas personalizarlo a tu gusto. Si eres un gamer que exige lo mejor, el GAMEMAX BLADE CONCEPT es la elección definitiva para tu próximo equipo. ¡Conquista el campo de batalla con estilo y rendimiento sin igual!','414754',21,20,700.00,950.00,10,5,'1759339786_68dd650af0c58.jpg',1,0,1,'2025-10-01 10:29:46','2025-10-06 07:00:42',NULL),(68,'CASE GAMING GAMEMAX N80 WH, 6 COOLER ARGB, VIDRIO CURVO TEMPLADO','¡Dale poder y estilo a tu equipo con el Case Gaming GAMEMAX N80 BK! Este impresionante chasis blanco es mucho más que una caja para tu PC, es una declaración de intenciones. Equipado con 6 coolers ARGB que te permiten personalizar la iluminación a tu gusto, cada partida será una experiencia única y vibrante. El vidrio curvo templado en el panel lateral no solo ofrece una vista espectacular de tu hardware, sino que también proporciona una estructura resistente y elegante. Su diseño optimizado mejora el flujo de aire y facilita la instalación, convirtiéndolo en la opción ideal para quienes buscan rendimiento y estética. ¡Haz que tu set-up sea tan épico como tus victorias con GAMEMAX N80 WH!','414755',21,20,400.00,570.00,10,5,'1759339926_68dd659673869.jpg',1,0,1,'2025-10-01 10:32:06','2025-10-06 07:01:02',NULL),(69,'CASE GAMING GAMEMAX INFINITY PRO WH, PANORAMICO, 5 COOLER ARGB','¡Transforma tu PC en una obra maestra con el Case Gaming GAMEMAX INFINITY PRO WH! Este elegante y futurista chasis en blanco no solo es un espectáculo visual, sino que también garantiza un rendimiento superior. Con 5 coolers ARGB preinstalados, tu equipo se mantendrá refrigerado mientras iluminas tu escritorio con efectos luminosos deslumbrantes. El vidrio templado en ambos laterales permite una vista panorámica de tu hardware, mientras que su diseño espacioso y optimizado asegura una gestión eficiente del flujo de aire y una instalación sencilla. Ideal para jugadores y entusiastas del PC que buscan estilo, rendimiento y eficiencia. ¡Eleva tu experiencia gaming al siguiente nivel con GAMEMAX!','414756',21,20,300.00,340.00,10,5,'1759340002_68dd65e26abfc.jpg',1,0,1,'2025-10-01 10:33:04','2025-10-06 07:00:52',NULL),(70,'CASE LIAN LI VECTOR V100R White, FAN x4 ARGB, V/TEMPLADO','Chasis de torre media diseñado para visualización de rendimiento y estética inmersiva\r\nAdmite placas base con conexión posterior para optimizar el espacio y una gestión de cables más limpia.\r\nCompatible con formatos de placa base ITX, M-ATX, ATX y E-ATX (ancho < 246 mm)\r\nAdmite hasta 9 ventiladores y admite radiadores de hasta 360 mm para una refrigeración excepcional.\r\nPreinstalado con un soporte de GPU para evitar que se hunda y garantizar la estabilidad.\r\nCuenta con paneles de vidrio templado duales de 4 mm para una visibilidad sin obstáculos de 270°\r\nTira de luz ARGB integrada con 26 LED, personalizable y sincronizable con el software de la placa base\r\nDiseño de gestión de cables sin herramientas con una cámara frontal dedicada','656',21,21,200.00,340.00,100,5,'1759340098_68dd664273e5b.jpg',1,0,1,'2025-10-01 10:34:58','2025-10-06 07:01:20',NULL),(71,'CASE ASUS TUF Gaming GT302 ARGB, WHITE, V/TEMPLADO','TUF Gaming GT302 ARGB incorpora un panel frontal de malla de tipo cuadrado optimizado, que garantiza un flujo de aire sin obstrucciones y una gran porosidad diseñada para maximizar la eficiencia del flujo de aire.','659',21,10,500.00,680.00,10,5,'1759340213_68dd66b50a5bb.jpg',1,0,1,'2025-10-01 10:36:53','2025-10-06 07:00:22',NULL),(72,'CASE LIAN LI O11 DINÁMICO EVO RGB, WHITE, V/TEMPLADO','• Dos tiras de luz en forma de L arriba y abajo con efectos de iluminación acordes.\r\n• Paneles frontales y laterales de vidrio templado con pilar removible para una vista perfecta de los componentes y la iluminación RGB.\r\n• E/S traseras y puntos de montaje de la placa base de 2 alturas ajustables.\r\n• Admite radiadores de hasta 420 mm en la parte superior y radiadores de 360 ​​mm en los laterales e inferior.\r\n• Admite 140 ventiladores de 3 mm en la parte superior, lateral e inferior.\r\n• Fácil gestión de cables con más espacio en la segunda cámara.\r\n• Accesorios opcionales para montaje de GPU vertical o GPU vertical.','660',21,21,500.00,730.00,10,5,'1759340311_68dd6717dabaf.jpg',1,0,1,'2025-10-01 10:38:31','2025-10-06 07:01:11',NULL),(73,'MEM. RAM G.SKILL TRIDENT Z5 ROYAL NEO SILVER AMD EXPO, 32GB (16x2) DDR5 6400 MHZ, CL30','Trident Z5 Royal Neo es la clase de lujo de memoria DDR5 de rendimiento de overclock extremo diseñada para plataformas AMD AM5, que presenta un diseño de joya de la corona con una barra de luz cristalina para una magnífica exhibición de iluminación RGB personalizable y disipadores de calor de aluminio galvanizado con un acabado espejado en colores dorado o plateado.','661',11,22,500.00,750.00,10,5,'1759340541_68dd67fdcc224.jpg',1,0,1,'2025-10-01 10:42:21','2025-10-06 07:04:45',NULL),(74,'MEM. RAM G.SKILL TRIDENT Z5 RGB SILVER, 64GB (32x2) DDR5 6400 MHZ, CL32','La memoria DDR5 de la serie Trident Z5 RGB está diseñada para un rendimiento ultraalto en plataformas DDR5. Con un elegante y estilizado disipador de calor de aluminio, disponible en plata metalizada, negro mate o blanco mate, la memoria DRAM DDR5 de la serie Trident Z5 RGB es la opción ideal para construir un sistema de alto rendimiento.','662',11,22,500.00,1300.00,10,5,'1759340624_68dd68500b124.jpg',1,0,1,'2025-10-01 10:43:44','2025-10-06 07:04:34',NULL),(75,'MEM. RAM SODIMM PATRIOT SIGNATURE LITE 32GB DDR5 5600 Mhz','Los módulos de memoria DDR5 de línea DDR5 de Patriot están diseñados para ofrecer una inmensa mejora del rendimiento para las plataformas Intel de próxima generación. Requerir solo 1.1V de potencia, los módulos de línea DDR5 signature consumen menos potencia y emiten menos calor a pesar del aumento de la frecuencia y la velocidad. Las mejoras de potencia mejoradas incluyen un IC de administración de potencia a bordo (PMIC), que proporciona un mejor control de la regulación de voltaje local al tiempo que ofrece una mayor protección de umbral, monitoreo simultáneo, voltaje inteligente y gestión de energía. La serie DDR5 de línea Signature incluye sensores térmicos a bordo para monitorear y proteger contra problemas térmicos y mejores informes generales. Además, el último ECC en la muerte (código de corrección de errores) mejora aún más la precisión del procesamiento de datos y la estabilidad general de su sistema.','664',11,22,200.00,360.00,10,5,'1759340737_68dd68c1b406a.jpg',1,0,1,'2025-10-01 10:45:37','2025-10-06 07:04:57',NULL),(76,'MEMORIA 48GB (24GBx2) DDR5 KINGSTON FURY RENEGADE RGB INTEL XMP BUS 7200MHz (PN:KF572C38RSAK2-48)','Kingston FURY™ Renegade DDR5 RGB mejora el rendimiento y el estilo del sistema. La memoria ultrarrápida ofrece UDIMM de 8000 MT/s y CUDIMM de 8800 MT y el software FURY CTRL™ ofrece 18 efectos de luz RGB personalizables. Nuestra tecnología patentada Infrared Sync ofrece unas de las luces de PC más suaves y sincronizadas posibles. La Kingston FURY Renegade DDR5 RGB aprovecha al máximo el rendimiento del PC sin comprometer la fiabilidad. Los módulos tienen la certificación XMP 3.0 de Intel®, ofrecen un overclocking muy sencillo y se han probado en fábrica a la velocidad prometida.','665',11,23,200.00,360.00,10,5,'1759347192_68dd81f8d2f51.jpg',1,0,1,'2025-10-01 12:32:50','2025-10-06 07:05:29',NULL),(77,'MEMORIA 24GB DDR5 KINGSTON FURY RENEGADE RGB BUS 7200MHz (PN:KF572C38RSA-24)','Kingston FURY™ Renegade DDR5 RGB mejora el rendimiento y el estilo del sistema. La memoria ultrarrápida ofrece UDIMM de 8000 MT/s y CUDIMM de 8800 MT y el software FURY CTRL™ ofrece 18 efectos de luz RGB personalizables. Nuestra tecnología patentada Infrared Sync ofrece unas de las luces de PC más suaves y sincronizadas posibles. La Kingston FURY Renegade DDR5 RGB aprovecha al máximo el rendimiento del PC sin comprometer la fiabilidad. Los módulos tienen la certificación XMP 3.0 de Intel®, ofrecen un overclocking muy sencillo y se han probado en fábrica a la velocidad prometida.','2585',11,23,100.00,250.00,10,5,'1759347316_68dd827499f35.jpg',1,0,1,'2025-10-01 12:35:16','2025-10-06 07:05:07',NULL),(78,'MEMORIA RAM DDR5 32GB BUS 5200MHZ CORSAIR VENGEANCE BLACK','CORSAIR VENGEANCE DDR5, optimizada para placas base Intel, ofrece las mayores frecuencias y capacidades de la tecnología DDR5 en un módulo compacto de alta calidad que se adapta a su sistema.','25856',11,17,100.00,250.00,10,5,'1759347641_68dd83b9a8b1c.jpg',1,0,1,'2025-10-01 12:40:41','2025-10-01 14:04:35',NULL),(79,'MEMORIA 32GB (16GBx2) DDR5 G.SKILL RIPJAWS S5 BLACK BUS 6000MHz (PN: F5-6000J3636F16GX2-RS5K )','Ripjaws S5 es una serie de memoria DRAM DDR5 de alto rendimiento, fabricada con circuitos integrados de memoria seleccionados manualmente que superaron las rigurosas pruebas de validación de G.SKILL. Cada kit de memoria Ripjaws S5 ofrece un equilibrio ideal entre rendimiento, compatibilidad y estabilidad, y está disponible con disipadores de calor de aluminio en negro mate o blanco mate.','258566',11,22,100.00,250.00,10,5,'1759347742_68dd841e2f41c.jpg',1,0,1,'2025-10-01 12:42:22','2025-10-06 07:05:21',NULL),(80,'VGA GIGABYTE GEFORCE RTX 5060 GAMING OC 8GB GDDR7','El sistema de refrigeración WINDFORCE ofrece un rendimiento térmico excepcional gracias a una combinación de tecnologías de vanguardia. Incorpora gel conductor térmico de grado servidor, innovadores ventiladores Hawk con giro alterno, tubos de calor de cobre compuesto, una placa de cobre, ventiladores activos 3D y refrigeración por pantalla.','258567',20,24,100.00,1500.00,10,5,'1759347916_68dd84ccc3d4f.jpg',1,0,1,'2025-10-01 12:45:16','2025-10-06 08:31:16',NULL),(81,'VGA ASUS GEFORCE NVIDIA RTX 3050 DUAL OC Edition 6GB GDDR6','Con la arquitectura NVIDIA® Ampere más reciente, la ASUS Dual GeForce RTX™ 3050 6G combina un rendimiento térmico dinámico con una amplia compatibilidad. Las soluciones de refrigeración avanzadas de las tarjetas gráficas insignia se integran en esta tarjeta de 20 cm de largo y 2 ranuras, ofreciendo más potencia en menos espacio. Estas mejoras convierten a ASUS Dual en la opción perfecta para gamers que buscan un rendimiento gráfico excepcional en un diseño compacto.','258568',20,10,100.00,750.00,10,5,'1759348037_68dd8545a7a6e.jpg',1,0,1,'2025-10-01 12:47:17','2025-10-06 08:30:42',NULL),(82,'VGA MSI GEFORCE RTX 5060 8GB GAMING OC GDDR7','Sin miedo y audaz, los juegos ofrecen un fuerte rendimiento tanto para los juegos como para la creación de contenido. Combina un aspecto feroz con tecnologías de enfriamiento avanzadas, por lo que es un aliado inquebrantable en el campo de batalla de juegos. El juego es la opción ideal para los jugadores que se esfuerzan por dar todo.','258569',20,18,100.00,1600.00,10,5,'1759348098_68dd85827493e.jpg',1,0,1,'2025-10-01 12:48:18','2025-10-06 08:31:48',NULL),(83,'VGA ASUS PRIME GEFORCE RTX 5050 8GB GDDR6 OC Edition, 128 Bit','Experimente el rendimiento primario con el Prime GeForce RTX 5050, con un diseño de 2.5 ranuras para la compatibilidad expansiva, mejorada por una configuración de triple fan para el diseño de flujo de aire supremo para Enfriamiento supremo. El Prime RTX 5050 presenta un diseño de ranura 2.5 con un diseño cuidadosamente dispuesto para las tuberías de la cubierta, el disipador térmico y el calor para permitir que los tres ventiladores de tecnología axial aprovechen la ventilación del panel lateral del chasis y entreguen óptimos rendimiento térmico.','258571',20,10,100.00,1300.00,10,5,'1759348321_68dd866113419.jpg',1,0,1,'2025-10-01 12:52:01','2025-10-06 08:30:50',NULL),(84,'VGA ASUS DUAL RADEON RX 9060 XT 8GB GDDR6','La ASUS Dual Radeon™ RX 9060 XT combina un potente rendimiento térmico con una amplia compatibilidad. Soluciones de refrigeración avanzadas de tarjetas gráficas de gama alta, incluyendo dos ventiladores Axial-tech para optimizar el flujo de aire hacia el disipador. Diseñada en un formato compacto de 2,5 ranuras, ofrece más potencia en menos espacio. Estas mejoras convierten a la ASUS Dual en la opción perfecta para gamers que buscan un rendimiento gráfico excepcional en un diseño compacto.','258573',20,10,100.00,1550.00,10,5,'1759348715_68dd87ebf2e37.jpg',1,0,1,'2025-10-01 12:58:35','2025-10-06 08:32:07',NULL),(85,'VGA GIGABYTE GEFORCE RTX 5050 GAMING OC 8GB GDDR6, 128 Bit','El sistema de enfriamiento Windforce ofrece un rendimiento térmico excepcional a través de una combinación de tecnologías de vanguardia. Cuenta con gel conductivo térmico de grado de servidor, ventiladores de halcón innovadores con hilado alternativo, tuberías de calor de cobre compuesto, una placa de cobre, ventiladores activos en 3D y enfriamiento de pantalla. La serie de juegos atrae el concepto de Mech Warriors, combinando la armadura futurista con una estética mecánica para ofrecer una protección excepcional y una poderosa durabilidad. Va más allá de las meras apariencias y la funcionalidad, ofreciendo una interpretación profunda de la tecnología futurista.','258574',20,24,100.00,1250.00,10,5,'1759348817_68dd88518847f.jpg',1,0,1,'2025-10-01 13:00:17','2025-10-06 08:31:07',NULL),(86,'VGA MSI NVIDIA GEFORCE RTX 3060 VENTUS 2X 12GB OC GDDR6','VENTUS ofrece un diseño orientado al rendimiento que mantiene lo esencial para cualquier tarea. Su confiable sistema de doble ventilador, integrado en un diseño industrial rígido, permite que esta elegante tarjeta gráfica se adapte a cualquier sistema.','258575',20,18,100.00,1150.00,10,5,'1759348940_68dd88cccba5c.jpg',1,0,1,'2025-10-01 13:02:20','2025-10-06 08:31:58',NULL),(87,'VGA MSI GEFORCE NVIDIA RTX 3050 LOW PROFILE 6GB OC GDDR6','La GeForce RTX™ 3050 de 6 GB está diseñada con la arquitectura NVIDIA Ampere, con núcleos dedicados para trazado de rayos, núcleos tensores de IA y memoria G6 de alta velocidad. ¡Da el salto a GeForce RTX!','258576',20,18,100.00,750.00,10,5,'1759349033_68dd892957de2.jpg',1,0,1,'2025-10-01 13:03:53','2025-10-06 08:31:31',NULL),(88,'VGA ASUS PRIME GEFORCE RTX 5060 8GB GDDR7 OC Edition','Experimenta el rendimiento Primal con la Prime GeForce RTX 5060, una tarjeta GeForce Enthusiast preparada para SFF que presenta un diseño de 2,5 ranuras para una compatibilidad expansiva, mejorada con una configuración de triple ventilador para un diseño de flujo de aire supremo para refrigeración suprema.','258577',20,10,100.00,1550.00,10,5,'1759349176_68dd89b82a0c9.jpg',1,0,1,'2025-10-01 13:06:16','2025-10-06 08:30:58',NULL),(89,'VGA MSI GEFORCE RTX 3050 GAMING X 6GB GDDR6','La última versión de la icónica serie GAMING de MSI vuelve a ofrecer el rendimiento, la eficiencia y el bajo nivel de ruido, una estética que los gamers más exigentes reconocen y en la que confían. Ahora tú también puedes disfrutar de tus juegos favoritos con una potente tarjeta gráfica que se mantiene fresca y silenciosa. Justo como te gusta.','258578',20,18,100.00,750.00,10,5,'1759349349_68dd8a65d9a69.jpg',1,0,1,'2025-10-01 13:09:09','2025-10-06 08:31:41',NULL),(90,'PLACA ASUS PRIME Z690-A DDR5 LGA 1700 (PN:90MB18L0-MVAAY0)','Las placas base de la serie ASUS Prime están diseñadas por expertos para aprovechar al máximo el potencial de los procesadores Intel® de 14.ª, 13.ª y 12.ª generación. Con un diseño de alimentación robusto, soluciones de refrigeración integrales y opciones de ajuste inteligentes, la Prime Z690-A ofrece a usuarios y ensambladores de PC DIY una gama de opciones de ajuste del rendimiento mediante funciones intuitivas de software y firmware.','258579',18,10,100.00,1200.00,10,5,'1759349593_68dd8b5955b0d.jpg',1,0,1,'2025-10-01 13:13:13','2025-10-01 14:06:22',NULL),(91,'PLACA MSI PRO B760M-G DDR5 LGA 1700 (PN:911-7D90-048)','Compatible con procesadores Intel® Core™ de 14.ª, 13.ª y 12.ª generación, Intel® Pentium® Gold y Celeron® para zócalo LGA 1700.\r\nCompatible con memoria DDR5 de doble canal a 6400+ MHz (OC).\r\nCore Boost: Con un diseño premium y potencia digital para soportar más núcleos y ofrecer un mejor rendimiento.\r\nMemory Boost: Tecnología avanzada para ofrecer señales de datos puras y obtener el mejor rendimiento, estabilidad y compatibilidad.\r\nExperiencia ultrarrápida: PCIe 4.0, Lightning Gen4 x4 M.2 con M.2 Shield Frozr.\r\nLAN 2.5G: Solución de red mejorada para uso profesional y multimedia. Ofrece una conexión de red segura, estable y rápida.\r\nAUDIO BOOST: Deleita tus oídos con una calidad de sonido de estudio para una experiencia de juego inmersiva.\r\nSteel Armor: Protege las tarjetas VGA contra flexiones y EMI para un mejor rendimiento, estabilidad y resistencia.','258580',18,18,100.00,450.00,10,5,'1759349725_68dd8bdd81ea9.jpg',1,0,1,'2025-10-01 13:15:25','2025-10-06 07:09:00',NULL),(92,'PLACA ASUS TUF GAMING B760M-PLUS WIFI II DDR5 LGA 1700 (PN:90MB1HE0-M0EAY0)','TUF GAMING B760M-PLUS WIFI II toma todos los elementos esenciales de los últimos procesadores Intel® y los combina con funciones listas para jugar y una durabilidad probada. Diseñada con componentes de calidad militar, una solución de alimentación mejorada y un completo sistema de refrigeración, esta placa base supera las expectativas con un rendimiento sólido como una roca para los juegos maratonianos. Las placas base TUF GAMING también se someten a rigurosas pruebas de resistencia para garantizar que pueden soportar condiciones en las que otras podrían fallar. Estéticamente, este modelo incorpora una placa con el nombre en relieve y elementos de diseño geométrico para reflejar la fiabilidad y estabilidad que definen a la serie TUF GAMING.','258581',18,10,100.00,800.00,10,5,'1759349928_68dd8ca8b6f86.jpg',1,0,1,'2025-10-01 13:18:48','2025-10-06 07:08:11',NULL),(93,'PLACA ASUS PRIME H610M-E DDR5 LGA 1700 (PN:90MB1G10-M0EAY0)','Socket Intel® LGA 1700: Listo para la 14a, 13a y 12a generación de procesadores Intel®.\r\nRefrigeración integral: Disipador térmico PCH y Fan Xpert 2+.\r\nConectividad ultrarrápida: Puerto M.2 de 32 Gbps, Realtek 1 Gb Ethernet y USB 3.2 Gen 1.\r\nIluminación Aura Sync RGB: Puertos direccionables Gen 2 integrados y puerto Aura RGB para tiras de LED RGB, sincronizados fácilmente con hardware compatible con Aura Sync.','258582',18,10,100.00,350.00,10,5,'1759350034_68dd8d1224914.jpg',1,0,1,'2025-10-01 13:20:34','2025-10-06 07:08:02',NULL),(94,'PLACA AORUS B760 ELITE AX DDR4 LGA 1700','Compatible con procesadores Intel ® Core™ 14.º, 13.º y 12.º\r\nRendimiento incomparable: Solución VRM digital de dos fases 12*+1+1\r\nDDR4 de doble canal: 4 DIMM con compatibilidad con módulos de memoria XMP\r\nAlmacenamiento de próxima generación: 3 conectores PCIe 4.0 x4 M.2\r\nDiseño térmico avanzado y protección térmica M.2: para garantizar la estabilidad de la energía del VRM y el rendimiento del SSD M.2\r\nEZ-Latch Plus: Conectores M.2 con liberación rápida y diseño sin tornillos\r\nRedes rápidas: LAN de 2,5 GbE y Wi-Fi 6E 802.11ax\r\nConectividad extendida: USB- C® trasero y frontal de 10 Gb/s, DP, HDMI\r\nVentilador inteligente 6: cuenta con múltiples sensores de temperatura, cabezales de ventilador híbridos con función FAN STOP\r\nQ-Flash Plus: Actualiza la BIOS sin instalar la CPU, la memoria ni la tarjeta gráfica','258583',18,27,100.00,830.00,10,5,'1759350144_68dd8d80bcd86.jpg',1,0,1,'2025-10-01 13:22:24','2025-10-06 07:07:51',NULL),(95,'PLACA GIGABYTE Z790 GAMING X AX DDR5 LGA 1700','Compatible con procesadores Intel ® Core™ 14.º, 13.º y 12.º\r\nRendimiento incomparable: Solución VRM digital de dos fases de 16*+2+1\r\nDDR5 de doble canal: 4 DIMM con compatibilidad con módulos de memoria XMP 3.0\r\nAlmacenamiento de próxima generación: 4 conectores PCIe 4.0 x4 M.2\r\nDiseño térmico avanzado y protección térmica M.2: para garantizar la estabilidad energética del VRM y el rendimiento del SSD M.2\r\nEZ-Latch Plus: Conectores M.2 con liberación rápida y diseño sin tornillos\r\nRedes rápidas: LAN de 2,5 GbE y Wi-Fi 6E 802.11ax\r\nConectividad extendida: DP, HDMI, USB-C® frontal de 10 Gb/s, USB-C® trasero de 20 Gb/s\r\nVentilador inteligente 6: cuenta con múltiples sensores de temperatura, cabezales de ventilador híbridos con función FAN STOP\r\nQ-Flash Plus: Actualiza la BIOS sin instalar la CPU, la memoria ni la tarjeta gráfica','258584',18,24,100.00,1000.00,10,5,'1759350286_68dd8e0ed7064.jpg',1,0,1,'2025-10-01 13:24:46','2025-10-06 07:08:26',NULL),(96,'PLACA MSI MAG Z790 TOMAHAWK MAX WIFI DDR5 LGA 1700 (PN:911-7E25-003)','La MAG Z790 TOMAHAWK MAX WIFI está diseñada para gamers y ofrece una base estable, sólida y duradera para sus PC. Con Wi-Fi 7, LAN 2.5G, DDR5, PCIe 5.0 y el exclusivo M.2 Shield Frozr, es compatible con los procesadores Intel® Core de 14.ª y 13.ª generación.','258585',18,18,100.00,1300.00,10,5,'1759350458_68dd8eba8e774.jpg',1,0,1,'2025-10-01 13:27:38','2025-10-06 07:08:48',NULL),(97,'PLACA GIGABYTE B760M D3HP DDR4 LGA 1700','Compatible con procesadores Intel® Core™ de 14.ª, 13.ª y 12.ª generación\r\nRendimiento inigualable: Solución VRM digital híbrida de 4+1+1 fases\r\nDDR4 de doble canal: 4 DIMM compatibles con módulos de memoria XMP\r\nAlmacenamiento de última generación: 2 conectores PCIe 4.0 x4 M.2\r\nRedes rápidas: LAN GbE\r\nConectividad ampliada: USB-C® frontal de 5 Gb/s, DP, HDMI, D-Sub\r\nSmart Fan 6: Incluye múltiples sensores de temperatura, conectores de ventilador híbridos con función FAN STOP\r\nQ-Flash Plus: Actualiza la BIOS sin instalar la CPU, la memoria ni la tarjeta gráfica','258586',18,24,100.00,400.00,10,5,'1759350539_68dd8f0b9f427.jpg',1,0,1,'2025-10-01 13:28:59','2025-10-06 07:08:19',NULL),(98,'PLACA MSI B760 GAMING PLUS WI-FI DDR5 LGA 1700 (PN:911-7D98-032)','B760 GAMING PLUS WIFI está diseñada para ofrecer una conectividad inigualable, herramientas flexibles y una cómoda solución Wi-Fi con memoria DDR5 para los jugadores que lo quieren todo.','258587',18,18,100.00,730.00,10,5,'1759350614_68dd8f5692471.jpg',1,0,1,'2025-10-01 13:30:14','2025-10-06 07:08:39',NULL),(99,'PLACA MSI PRO B760M-E DDR5 LGA 1700 (PN:911-7D48-048)','Compatible con procesadores Intel® Core™ de 14.ª, 13.ª y 12.ª generación, Intel® Pentium® Gold y Celeron® para zócalo LGA 1700\r\nCompatible con memoria DDR5 de doble canal a 6400+ MHz (OC)\r\nCore Boost: Con un diseño premium y potencia digital para admitir más núcleos y ofrecer un mejor rendimiento\r\nMemory Boost: Tecnología avanzada para ofrecer señales de datos puras y obtener el mejor rendimiento, estabilidad y compatibilidad\r\nExperiencia ultrarrápida: PCIe 4.0, Lightning Gen4 x4 M.2\r\nAUDIO BOOST: Deleita tus oídos con una calidad de sonido de estudio para una experiencia de juego inmersiva\r\nSteel Armor: Protege las tarjetas VGA contra flexiones y EMI para un mejor rendimiento, estabilidad y resistencia','258588',18,18,100.00,400.00,10,5,'1759350778_68dd8ffac3c1e.jpg',1,0,1,'2025-10-01 13:32:58','2025-10-06 07:08:54',NULL),(100,'DISCO DURO WESTERN DIGITAL, 2TB SATA 7200 RPM','Dele a su computadora de escritorio un impulso en su rendimiento y almacenamiento al combinar su disco duro con un disco SSD para maximizar la velocidad de acceso a los datos y un disco WD Blue de hasta 6 TB de capacidad adicional.','258589',13,26,100.00,240.00,10,5,'1759351269_68dd91e5c9340.jpg',1,0,1,'2025-10-01 13:41:09','2025-10-06 07:04:24',NULL),(101,'DISCO DURO WESTERN DIGITAL RED PRO NAS, 14TB','La tecnología NASware™, exclusiva de Western Digital, ajusta con precisión los parámetros para que coincidan con las cargas de trabajo del sistema NAS, lo que ayuda a aumentar la confiabilidad y el rendimiento.','258590',13,26,100.00,1250.00,10,5,'1759351355_68dd923baaf02.jpg',1,0,1,'2025-10-01 13:42:35','2025-10-06 07:04:16',NULL),(102,'DISCO DURO SEAGATE SkyHawk SURVEILLANCE, 1TB','El nuevo LaCie Rugged SSD4 es nuestra versión más novedosa de almacenamiento resistente, portátil y de alto rendimiento para transferencias rápidas de archivos y creatividad fluida en cualquier lugar.','258591',13,26,100.00,180.00,10,5,'1759351448_68dd9298c3758.jpg',1,0,1,'2025-10-01 13:44:08','2025-10-06 07:03:44',NULL),(103,'DISCO DURO SEAGATE SKYHAWK SURVEILLANCE, 2TB','El disco duro de vigilancia Seagate SkyHawk incorpora tecnología de vanguardia, diseñada específicamente para las cambiantes demandas de los sistemas de vigilancia modernos. Este disco duro está optimizado para entornos de grabación de video 24/7, gestionando cargas de trabajo intensas con facilidad y fiabilidad. Su eficiente consumo de energía y el Sistema de Gestión de la Salud de Seagate garantizan un rendimiento ultrafiable. Los discos SkyHawk admiten hasta 180 TB de datos al año, con características como sensores de vibración rotacional (RV) integrados para mantener el rendimiento incluso en sistemas de múltiples bahías. Esto garantiza configuraciones de vigilancia escalables y flexibles.','258592',13,26,100.00,230.00,10,5,'1759351535_68dd92ef5c462.jpg',1,0,1,'2025-10-01 13:45:01','2025-10-06 07:03:51',NULL),(104,'DISCO DURO SEAGATE SKYHAWK SURVEILLANCE, 4TB','El disco duro de vigilancia Seagate SkyHawk incorpora tecnología de vanguardia, diseñada específicamente para las cambiantes demandas de los sistemas de vigilancia modernos. Este disco duro está optimizado para entornos de grabación de video 24/7, gestionando cargas de trabajo intensas con facilidad y fiabilidad. Su eficiente consumo de energía y el Sistema de Gestión de la Salud de Seagate garantizan un rendimiento ultrafiable. Los discos SkyHawk admiten hasta 180 TB de datos al año, con características como sensores de vibración rotacional (RV) integrados para mantener el rendimiento incluso en sistemas de múltiples bahías. Esto garantiza configuraciones de vigilancia escalables y flexibles.','51515',13,26,100.00,340.00,10,5,'1759351617_68dd934192051.jpg',1,0,1,'2025-10-01 13:46:57','2025-10-06 07:03:59',NULL),(105,'SSD 1TB KINGSTON KC600 SATA 6.0 2.5\" (PN:SKC600/1024G)','El KC600 de Kingston es una unidad SSD de máxima capacidad diseñada para ofrecer un rendimiento excelente y optimizada para aportar una capacidad de respuesta funcional del sistema con increíbles tiempos de arranque, carga y transferencia. Se presenta en un formatos de 2,5\" y mSATA con interfaz SATA Rev 3.0 retrocompatible. El KC600 utiliza la más avanzada tecnología NAND TLC 3D e incorpora un sofisticado paquete de seguridad que incluye el cifrado de hardware AES de 256 bits, TCG Opal 2.0 y eDrive. Alcanza velocidades de lectura/escritura de hasta 550/520 MB/s1 y puede almacenar sin dificultades hasta 2 TB2 de datos','51516',13,23,100.00,340.00,10,5,'1759351719_68dd93a77dedc.jpg',1,0,1,'2025-10-01 13:48:39','2025-10-06 07:12:30',NULL),(106,'SSD 2TB KINGSTON KC600 SATA 6.0 2.5\" (PN:SKC600/2048G)','El KC600 de Kingston es una unidad SSD de máxima capacidad diseñada para ofrecer un rendimiento excelente y optimizada para aportar una capacidad de respuesta funcional del sistema con increíbles tiempos de arranque, carga y transferencia. Se presenta en un formatos de 2,5\" y mSATA con interfaz SATA Rev 3.0 retrocompatible. El KC600 utiliza la más avanzada tecnología NAND TLC 3D e incorpora un sofisticado paquete de seguridad que incluye el cifrado de hardware AES de 256 bits, TCG Opal 2.0 y eDrive. Alcanza velocidades de lectura/escritura de hasta 550/520 MB/s1 y puede almacenar sin dificultades hasta 2 TB2 de datos','51517',13,23,100.00,840.00,10,5,'1759351786_68dd93eae0aff.jpg',1,0,1,'2025-10-01 13:49:46','2025-10-06 07:12:37',NULL),(107,'SSD 480GB KINGSTON A400 SATA III FORMATO 2.5\" (PN:SA400S37/480G)','La unidad de estado sólido A400 de Kingston es diez veces más rápida que un disco duro estándar, con tiempos de arranque, carga y transferencia lisos con velocidades de lectura optimizados con velocidades de lectura y escritura de hasta 500 MB/s y 450 MB/s. Sin los problemas de un disco duro mecánico, la duradera resistencia a impactos y vibraciones del A400 hace que sea perfecto para portátiles y otros ordenadores móviles.','51518',13,23,100.00,160.00,10,5,'1759351898_68dd945a84fe1.jpg',1,0,1,'2025-10-01 13:51:38','2025-10-01 14:07:58',NULL);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reclamos`
--

DROP TABLE IF EXISTS `reclamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reclamos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero_reclamo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL,
  `consumidor_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_dni` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_telefono` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumidor_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `es_menor_edad` tinyint(1) DEFAULT '0',
  `apoderado_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apoderado_dni` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apoderado_direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `apoderado_telefono` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apoderado_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_bien` enum('producto','servicio') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'producto',
  `monto_reclamado` decimal(10,2) NOT NULL,
  `descripcion_bien` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_solicitud` enum('reclamo','queja') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'reclamo',
  `detalle_reclamo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pedido_consumidor` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuesta_proveedor` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_respuesta` date DEFAULT NULL,
  `estado` enum('pendiente','en_proceso','resuelto','cerrado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
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
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo` enum('puntos','descuento','envio_gratis','regalo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `estado` enum('programada','activa','pausada','expirada','cancelada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'programada',
  `creado_por` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas`
--

LOCK TABLES `recompensas` WRITE;
/*!40000 ALTER TABLE `recompensas` DISABLE KEYS */;
INSERT INTO `recompensas` VALUES (1,'Descuentos de 10%','Descuentos de 10%','descuento','2025-10-06 00:00:00','2025-12-31 00:00:00','activa',1,'2025-10-06 03:51:23','2025-10-06 03:51:23'),(2,'Descuentos de 10%','Descuentos de 10%','descuento','2025-10-06 00:00:00','2025-11-30 00:00:00','activa',1,'2025-10-06 03:52:54','2025-10-06 03:52:54'),(3,'Descuentos de 10% por compras del 300','Descuentos de 10% por compras del 300','descuento','2025-10-06 00:00:00','2025-11-30 00:00:00','activa',1,'2025-10-06 07:21:21','2025-10-06 07:21:21'),(4,'Descuento de Navidad','Obtén un 10% de descuento en tu primera tu primer navidad de clientes','descuento','2025-10-06 00:00:00','2025-12-31 00:00:00','activa',1,'2025-10-06 07:51:25','2025-10-06 07:51:25');
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
  `segmento` enum('todos','nuevos','recurrentes','vip','rango_fechas') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  KEY `cliente_id` (`cliente_id`) USING BTREE,
  CONSTRAINT `recompensas_clientes_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_clientes_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_clientes`
--

LOCK TABLES `recompensas_clientes` WRITE;
/*!40000 ALTER TABLE `recompensas_clientes` DISABLE KEYS */;
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
  `tipo_descuento` enum('porcentaje','cantidad_fija') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `compra_minima` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  CONSTRAINT `recompensas_descuentos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_descuentos`
--

LOCK TABLES `recompensas_descuentos` WRITE;
/*!40000 ALTER TABLE `recompensas_descuentos` DISABLE KEYS */;
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  CONSTRAINT `recompensas_envios_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `beneficio_aplicado` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_aplicacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  KEY `cliente_id` (`cliente_id`) USING BTREE,
  KEY `pedido_id` (`pedido_id`) USING BTREE,
  CONSTRAINT `recompensas_historial_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_historial_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_historial_ibfk_3` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `estado` enum('enviada','vista','cerrada','expirada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'enviada',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_recompensa_id` (`recompensa_id`) USING BTREE,
  KEY `idx_cliente_id` (`cliente_id`) USING BTREE,
  KEY `idx_popup_id` (`popup_id`) USING BTREE,
  CONSTRAINT `recompensas_notificaciones_clientes_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_notificaciones_clientes_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_notificaciones_clientes_ibfk_3` FOREIGN KEY (`popup_id`) REFERENCES `recompensas_popups` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imagen_popup` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `texto_boton` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Ver más',
  `url_destino` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mostrar_cerrar` tinyint(1) DEFAULT '1',
  `auto_cerrar_segundos` int DEFAULT NULL,
  `popup_activo` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_recompensa_id` (`recompensa_id`) USING BTREE,
  KEY `idx_popup_activo` (`popup_activo`) USING BTREE,
  CONSTRAINT `recompensas_popups_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_popups`
--

LOCK TABLES `recompensas_popups` WRITE;
/*!40000 ALTER TABLE `recompensas_popups` DISABLE KEYS */;
INSERT INTO `recompensas_popups` VALUES (1,4,'Descuento de Navidad 10%','Descuento de Navidad 10% por ser tu primera navidad con Ecommerce','1759762825_68e3d989020c0.jfif','Ver más','/recompensas/4',1,10,1,'2025-10-06 08:00:25','2025-10-06 08:00:25');
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  KEY `producto_id` (`producto_id`) USING BTREE,
  KEY `categoria_id` (`categoria_id`) USING BTREE,
  CONSTRAINT `recompensas_productos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_productos_ibfk_3` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_productos`
--

LOCK TABLES `recompensas_productos` WRITE;
/*!40000 ALTER TABLE `recompensas_productos` DISABLE KEYS */;
INSERT INTO `recompensas_productos` VALUES (1,1,NULL,18),(2,2,NULL,18),(3,3,NULL,18),(4,4,NULL,18);
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  CONSTRAINT `recompensas_puntos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `recompensa_id` (`recompensa_id`) USING BTREE,
  KEY `producto_id` (`producto_id`) USING BTREE,
  CONSTRAINT `recompensas_regalos_ibfk_1` FOREIGN KEY (`recompensa_id`) REFERENCES `recompensas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `recompensas_regalos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas_regalos`
--

LOCK TABLES `recompensas_regalos` WRITE;
/*!40000 ALTER TABLE `recompensas_regalos` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas_regalos` ENABLE KEYS */;
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
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
INSERT INTO `role_has_permissions` VALUES (13,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(38,1),(39,1),(40,1),(41,1),(42,1),(44,1),(45,1),(46,1),(47,1),(48,1),(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),(55,1),(56,1),(57,1),(58,1),(59,1),(61,1),(62,1),(63,1),(64,1),(65,1),(67,1),(68,1),(69,1),(70,1),(72,1),(73,1),(74,1),(75,1),(76,1),(77,1),(78,1),(79,1),(80,1),(81,1),(86,1),(87,1),(88,1),(89,1),(90,1),(92,1),(93,1),(95,1),(96,1),(97,1),(98,1),(99,1),(100,1),(101,1),(102,1),(103,1),(104,1),(105,1),(107,1),(109,1),(111,1),(113,1),(115,1),(117,1),(119,1),(121,1),(123,1),(125,1),(126,1),(127,1),(128,1),(129,1),(130,1),(131,1),(132,1),(133,1),(134,1),(135,1),(136,1),(137,1),(138,1),(152,1),(153,1),(154,1),(155,1),(156,1),(157,1),(158,1),(159,1),(160,1),(161,1),(162,1),(163,1),(164,1),(165,1),(17,2),(105,4),(107,4),(109,4),(111,4),(113,4),(115,4),(117,4),(119,4),(121,4),(123,4),(106,5),(108,5),(110,5),(112,5),(114,5),(116,5),(118,5),(120,5),(122,5),(124,5);
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `roles_nombre_unique` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'superadmin','web','2025-05-31 03:49:45','2025-05-31 03:49:45'),(2,'admin','web','2025-05-31 03:49:45','2025-05-31 03:49:45'),(3,'vendedor','web','2025-05-31 03:49:45','2025-05-31 03:49:45'),(4,'motorizado','web','2025-09-19 15:37:45','2025-09-19 15:37:45'),(5,'motorizado-app','sanctum','2025-09-19 15:37:45','2025-09-19 15:37:45');
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
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `tipo_comprobante` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '01=Factura, 03=Boleta, 07=Nota Crédito, 08=Nota Débito',
  `serie` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `correlativo` int unsigned NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_tipo_serie` (`tipo_comprobante`,`serie`) USING BTREE,
  KEY `idx_tipo_comprobante` (`tipo_comprobante`) USING BTREE,
  KEY `idx_activo` (`activo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `series_comprobantes`
--

LOCK TABLES `series_comprobantes` WRITE;
/*!40000 ALTER TABLE `series_comprobantes` DISABLE KEYS */;
INSERT INTO `series_comprobantes` VALUES (1,'01','F001',0,1,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(2,'03','B001',0,1,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(3,'07','FC01',0,1,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(4,'07','BC01',0,1,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(5,'08','FD01',0,1,'2025-06-19 16:12:19','2025-06-19 16:12:19'),(6,'08','BD01',0,1,'2025-06-19 16:12:19','2025-06-19 16:12:19');
/*!40000 ALTER TABLE `series_comprobantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
INSERT INTO `sessions` VALUES ('1LakjvIoEYWSdlIsdrqSamrEC7sQ5jd0iagBkW4a',NULL,'38.56.216.90','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUZkdlR1WVNycTc5aktXUzdTZXZxSlZ2S2ptempxazY1cGF5OWJLeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMURZbTRjYk8xT0lkUWdIZVpmTWZZUFZPX1JfY1BaRDFmZ0NwZzM3N05CZ29BSWZhZmE1V0lBMnNUbFRTQ0pET1EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPXdyRGtLUzNGVkZtMHp5QlJDMTZnbldpREJaWmtlTzFRWUl3cUJBN1MiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759008427),('9zCeAJmTofdnjvQRMyHzoIqyXeyXQosTu0owcLT8',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMVRDV0c4elVDWW5iRkdSNUNkbW9YcEFOV1VxZ0VuU3JocTIyRHgzMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzc1OiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUJJRVd3Wm1vRV9MSlpwUzBVZmJCSjU5a083M1E2YlctTUx1dEU4LTNrUERsWHNBSnNrZjRZemxzbUVfczdRT1EmcHJvbXB0PWNvbnNlbnQmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPXltWnZxVU5qQjcyUzVPendnUGI0N01Tcno5S1lqcUpyY3ZaNXUyOFkiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759026506),('dPiVDdyuGYY4XSuy7Va6N6SBusfdV3gxLzqosrvF',NULL,'190.232.29.255','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibDhmVFBKUUNxN0JYNmhSa2cxUkdQVWdxbjJtNDEyZDVXN0F6aUliaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUJmcWs1Z3pzMnRYcnVVWG1wUUY2YXJoUHhiNEZBS1pFTXM1UENUWG4zVDVNaVUtTTJuUUNaZFZ5OGdDTC1feVEmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPVBsOG1LTk5JR2FiQ0VSWmxGbTUwSlplODFHWjY2MldxQlU2Q1BxWEoiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759004377),('N8vKMbX1pLAdUbDUshCGahEiO04SNQ3WtsagGBaN',NULL,'38.252.222.61','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiS25kMFB5cG5JQVNsTVhpMTk4MG9vR3NJcmFxNDRGRk9oTVdYdFF4VCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMURPUm1MRHRYMmVLeXFwaGJva3hQR3p4S0lhN3pCOTFaaHVkbkhCbDBZZThoTWl2TE5LT3lSTk15QXlBV0lMQ0EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwb3BlbmlkJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8uZW1haWwlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5wcm9maWxlJnN0YXRlPTUyR1JybHNTRDhqcUdSazJhbDIyOWxLNTVlTHk1eE0wMUwxSzZiR00iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759024823),('QrSSuudNPfh7kmqFtnxlApAQ4QSYqMfD9RnnsPV3',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHBYNUt5TXdmWFQyeW9LaWt5d3liTU50MzMyZzlxOHV4MVFMbWZFciI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1759744613),('Vfz10DP7bBn4yQlPJ0ET7rBOq8Z3HSr9iowcOf2t',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOVVwN291WUNQRlBJWVVXcllZOGYwc3dSVUpub2hucjFmRHBEbFlYbiI7czo1OiJzdGF0ZSI7czo0MDoiZlZybEZNa3FPUTF2NklUa0tJa2RIcGdBRzNEdWxDakNUd2R1ZFdMWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NjE6Imh0dHBzOi8vbWFndXMtZWNvbW1lcmNlLmNvbS9lY29tbWVyY2UtYmFjay9wdWJsaWMvYXV0aC9nb29nbGUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759160026),('zTdVeNPmGPZNPffukpabPLqhRO2C26wzUq5oG4L3',NULL,'38.25.11.188','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiY1ZwM01FUXA0YmRPYXR4UFV3aTVrQWs5NmJwc2tDSElaWlMxazdyViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzcyOiJodHRwczovL21hZ3VzLWVjb21tZXJjZS5jb20vZWNvbW1lcmNlLWJhY2svcHVibGljL2F1dGgvZ29vZ2xlL2NhbGxiYWNrP2F1dGh1c2VyPTAmY29kZT00JTJGMEFWR3pSMUN4dkJrWVJCV21EOEd0MUs2MGZHRHFFcjA3TDJLQy0wNThPQmhabU5iOWFLcmhzOVIzS3dCR1ZER2ZkUUVhR0EmcHJvbXB0PW5vbmUmc2NvcGU9ZW1haWwlMjBwcm9maWxlJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwb3BlbmlkJnN0YXRlPWkyRVp0R0NkM1poWHFXeEM2b29YenlsalFlalA1UmJVY0R5aDJkTW8iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1759246465);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiendas`
--

DROP TABLE IF EXISTS `tiendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiendas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVA',
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
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: Efectivo, Tarjeta, Yape, Plin',
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: efectivo, tarjeta, transferencia, yape, plin',
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clase de icono (phosphor, fontawesome, etc)',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Para ordenar en el frontend',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `codigo` (`codigo`) USING BTREE,
  UNIQUE KEY `tipo_pagos_codigo_unique` (`codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_pagos`
--

LOCK TABLES `tipo_pagos` WRITE;
/*!40000 ALTER TABLE `tipo_pagos` DISABLE KEYS */;
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
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `departamento` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `provincia` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `distrito` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Casa',
  `address_line` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Perú',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_addresses_user_id_foreign` (`user_id`) USING BTREE,
  CONSTRAINT `user_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_cliente_id` bigint unsigned NOT NULL,
  `nombre_destinatario` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion_completa` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_ubigeo` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_postal` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombres` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('masculino','femenino','otro') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_documento_id` bigint unsigned NOT NULL,
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `verification_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verification_code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_first_google_login` tinyint(1) DEFAULT '0',
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  CONSTRAINT `fk_user_clientes_tipo_documento` FOREIGN KEY (`tipo_documento_id`) REFERENCES `document_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_clientes`
--

LOCK TABLES `user_clientes` WRITE;
/*!40000 ALTER TABLE `user_clientes` DISABLE KEYS */;
INSERT INTO `user_clientes` VALUES (24,'Linder Lopez','Google','linsalo19b@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758555690','$2y$12$m6zXZwb/t0MPe9vrOSHhkOQArN00CyhqhoFGfgePNChom8QfdauZK','2025-09-22 08:41:30',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-22 08:41:30','2025-09-22 08:41:30'),(25,'José Alonso','Morales Yangua','chinchayjuan95@gmail.com','958478546',NULL,NULL,1,'73894795','$2y$12$VUbmaehtn8oFASYItw4Pg.EfJSaY2XYdQ61yorJegYzoRkkDye2DO',NULL,'q8J45LOckJWatOwbFO2jtDY3yweoxfNrD8EV2y8BakcdW2vCYQ77Rr88GyFE','8ICZNK',0,NULL,NULL,0,NULL,'2025-09-22 15:45:55','2025-09-22 15:45:55'),(27,'CARMEN ROSA','LOPEZ GUERRERO','cristiancamacaro360@gmail.com','94545436',NULL,NULL,1,'45674798','$2y$12$wva3gOCZLC5W89IOvvEzOeye/z6QQJr1k/A.NLPx4JlcD50KFrAna','2025-09-22 17:20:06',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-22 17:18:40','2025-09-22 17:20:06'),(30,'manuel aguado sierra','Google','umbrellasrl@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758641126','$2y$12$xzgJrZ8Pi5q3U8BuyOX/2OgbPTHEHSoVMe6v9X1JYoBxF3I3VZ5Yy','2025-09-23 08:25:26',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-23 08:25:26','2025-09-23 08:25:26'),(31,'kiyotaka hitori','Google','kiyotakahitori@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1758647650','$2a$10$q1d.zy4m7q2Mx7RyV0uFeuXdPj2F5QUGdvmOULLPm7c.PkFcHv3eu','2025-09-23 10:14:10',NULL,NULL,1,NULL,'/storage/clientes/1758647667_31.jpg',1,NULL,'2025-09-23 10:14:10','2025-10-06 10:09:22'),(32,'SUSAN LADY','COBA TORRES','ladysct11@gmail.com','949220756',NULL,NULL,1,'45891483','$2y$12$k9/uqBdd33M8lS8TcLOTZOHsIj94WXe.2tIzBD9R3tBY8OKmB/8Cq','2025-09-23 13:12:20',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-23 13:11:19','2025-09-23 13:12:20'),(33,'JOHNY','HUALLPA LOPEZ','anasilvia123vv@gmail.com','98545968',NULL,NULL,1,'44355989','$2y$12$jIhb7muvSY8oh47lGoIeSOwwXPG/qTRc1rzsNpO0fYk7qgzG99yme','2025-09-23 14:05:48',NULL,NULL,0,NULL,NULL,1,NULL,'2025-09-23 14:05:29','2025-09-23 14:05:48'),(34,'Alexander','Google','pieromorales1033@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759004376','$2y$12$Rs7OGG2u79yCz8ZRyCLMDeeuLBwBnKG.VIFP8oe/wnIhcVL4qE3u6','2025-09-27 13:19:36',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 13:19:36','2025-09-27 13:19:36'),(35,'Victor Canchari','Google','vcanchari38@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759024821','$2y$12$sfjn4.ckquPuHWRmN6Fa6.ReOCE.21oYpSjqrCrjAGUVq9StBX1KS','2025-09-27 19:00:21',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 19:00:21','2025-10-06 03:28:32'),(36,'Manuel Aguado','Google','systemcraft.pe@gmail.com',NULL,NULL,NULL,1,'GOOGLE_1759026505','$2y$12$9XNCRDImq9Z0sxRYA3FCxu2xQfdGd8O8e6eGOB034l.zL5GDNsIte','2025-09-27 19:28:25',NULL,NULL,1,NULL,NULL,1,NULL,'2025-09-27 19:28:25','2025-09-27 19:28:25'),(37,'EMER RODRIGO','YARLEQUE ZAPATA','rodrigoyarleque7@gmail.com','+51 993 321 920',NULL,NULL,1,'77425200','$2y$12$f422GzGKMW8QNvgxzYJv4uACLrkksoWzM8hEXYb2GgPm71ZgKuRj6',NULL,'j5K5qjMM3zeWXDkggVYDQlJEbkHUqZu503mVA5CRTIkUR3btS6A5dWWkn44l','YCZYYI',0,NULL,NULL,1,NULL,'2025-09-29 10:32:20','2025-09-29 10:47:39'),(39,'ROGGER CESAR','CCORAHUA CORONADO','adan2025zapata@gmail.com','+51 993 321 920',NULL,NULL,1,'73425200','$2y$12$ajZvx2/5kc2HWyBfy.HQPu.VwpExk2LGLT60afjzjOHWltsAY4jLe',NULL,'qyQPs5p7lCPR5gKbPQjQuwyiKKe4gkYsUGQoxq9x8L55pjQsK6Of9xWpP2km','E02HCQ',0,NULL,NULL,0,NULL,'2025-09-29 10:38:53','2025-09-29 10:38:53');
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
  `dia_semana` enum('lunes','martes','miercoles','jueves','viernes','sabado','domingo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `es_descanso` tinyint(1) DEFAULT '0',
  `fecha_especial` date DEFAULT NULL,
  `comentarios` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_horarios_user_dia` (`user_id`,`dia_semana`) USING BTREE,
  KEY `idx_user_horarios_fecha_especial` (`fecha_especial`) USING BTREE,
  KEY `idx_user_horarios_activo` (`activo`) USING BTREE,
  KEY `idx_user_horarios_disponibilidad` (`user_id`,`dia_semana`,`activo`) USING BTREE,
  CONSTRAINT `fk_user_horarios_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `chk_hora_fin_mayor_inicio` CHECK ((`hora_fin` > `hora_inicio`))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_horarios`
--

LOCK TABLES `user_horarios` WRITE;
/*!40000 ALTER TABLE `user_horarios` DISABLE KEYS */;
INSERT INTO `user_horarios` VALUES (1,35,'lunes','03:36:00','18:36:00',0,NULL,NULL,1,'2025-07-14 07:36:50','2025-07-14 07:36:50'),(2,1,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(3,1,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(4,1,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(5,1,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(7,1,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(12,29,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(13,29,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:51','2025-07-14 09:17:51'),(14,29,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(15,29,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(16,31,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(17,29,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(18,31,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(19,31,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(20,31,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(21,31,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(22,32,'lunes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(23,32,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(24,32,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(25,32,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(26,32,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(27,35,'martes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(28,35,'jueves','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(29,35,'viernes','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52'),(30,35,'miercoles','08:00:00','17:00:00',0,NULL,'Creado por gestión masiva',1,'2025-07-14 09:17:52','2025-07-14 09:17:52');
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
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Usuario de login (ej: MOT-001)',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Usuario activo/inactivo',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_motorizado_id` (`motorizado_id`) USING BTREE,
  KEY `idx_is_active` (`is_active`) USING BTREE,
  CONSTRAINT `user_motorizados_ibfk_1` FOREIGN KEY (`motorizado_id`) REFERENCES `motorizados` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Credenciales de acceso para motorizados';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_motorizados`
--

LOCK TABLES `user_motorizados` WRITE;
/*!40000 ALTER TABLE `user_motorizados` DISABLE KEYS */;
INSERT INTO `user_motorizados` VALUES (3,4,'systemcraft.pe@gmail.com','$2y$12$d6cFc0WKvI7D4LyLHKF38OPTSEa3jUZK8o3XniiuLYo5yMISDr//S',1,'2025-09-23 16:09:53',NULL,'2025-09-23 16:06:12','2025-09-29 08:53:44'),(4,5,'akame17ga20kill@gmail.com','$2y$12$fT6q2KAEARTqRBfPYvcpK.5B/zk8N8Ml7ivqGgHCG.GLVTOtHWaca',1,'2025-09-29 08:56:53',NULL,'2025-09-29 08:56:03','2025-09-29 08:56:53');
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
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name_father` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name_mother` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date NOT NULL,
  `genero` enum('masculino','femenino','otro') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_profiles_document_number_unique` (`document_number`) USING BTREE,
  KEY `user_profiles_user_id_foreign` (`user_id`) USING BTREE,
  CONSTRAINT `user_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
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
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
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
INSERT INTO `users` VALUES (1,'Admin Usuario','admin@example.com',NULL,'$2y$12$1HlGmMzDtit03XChNUfyh.2V1gpHtzwN/BdsJX4XRBvg/b0BGECd2',NULL,1,'2025-05-21 13:07:04','2025-05-21 18:08:35'),(29,'AlexanderFitgh','shinji@gmail.com',NULL,'$2y$12$GmHHsqbKf5SzTFsy.FKIVObmV1iy6H9mhUJH3gg6jvrs0OJrXFBee',NULL,1,'2025-06-03 23:05:50','2025-06-03 23:05:50'),(31,'Jonas','akdkre@gmail.com',NULL,'$2y$12$kUGXM6nNttS56LTXuWv6DeYko29OKB4ljrUIlLanp7PNqug4bSXnq',NULL,1,'2025-06-03 23:18:50','2025-06-03 23:18:50'),(32,'Test User','test@example.com','2025-06-05 16:59:56','$2y$12$LSvxM6fDnM5sPphz02V7F.f9lMK9HHPnio9Ky1TMxWK7K1X3lhMYm','u0CJ3CuGQu',1,'2025-06-05 16:59:56','2025-06-05 16:59:56'),(35,'emer1','kiyotakahitori@gmail.com',NULL,'$2y$12$jyuQOQtPKDiM7WoGsH//Z.cfI6xQMQ5VCX9nvcFtRRqrh7DihKQpC',NULL,1,'2025-06-06 15:07:56','2025-06-06 15:07:56');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `venta_detalles`
--

DROP TABLE IF EXISTS `venta_detalles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venta_detalles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venta_id` bigint unsigned NOT NULL,
  `producto_id` bigint unsigned NOT NULL,
  `codigo_producto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_producto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_producto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  CONSTRAINT `fk_venta_detalles_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_venta_detalles_venta_id` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venta_detalles`
--

LOCK TABLES `venta_detalles` WRITE;
/*!40000 ALTER TABLE `venta_detalles` DISABLE KEYS */;
/*!40000 ALTER TABLE `venta_detalles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_venta` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` bigint unsigned DEFAULT NULL,
  `user_cliente_id` bigint unsigned DEFAULT NULL COMMENT 'Cliente del e-commerce',
  `fecha_venta` datetime NOT NULL,
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Sin IGV',
  `igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `descuento_total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','FACTURADO','ANULADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `comprobante_id` bigint unsigned DEFAULT NULL COMMENT 'Comprobante generado',
  `requiere_factura` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cliente pidió factura',
  `metodo_pago` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  CONSTRAINT `fk_ventas_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_comprobante_id` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_user_cliente_id` FOREIGN KEY (`user_cliente_id`) REFERENCES `user_clientes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_motorizados_activos`
--

/*!50001 DROP VIEW IF EXISTS `v_motorizados_activos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_motorizados_activos` AS select `m`.`id` AS `id`,`m`.`numero_unidad` AS `numero_unidad`,`m`.`nombre_completo` AS `nombre_completo`,`m`.`foto_perfil` AS `foto_perfil`,`m`.`tipo_documento_id` AS `tipo_documento_id`,`m`.`numero_documento` AS `numero_documento`,`m`.`licencia_numero` AS `licencia_numero`,`m`.`licencia_categoria` AS `licencia_categoria`,`m`.`telefono` AS `telefono`,`m`.`correo` AS `correo`,`m`.`direccion_detalle` AS `direccion_detalle`,`m`.`ubigeo` AS `ubigeo`,`m`.`vehiculo_marca` AS `vehiculo_marca`,`m`.`vehiculo_modelo` AS `vehiculo_modelo`,`m`.`vehiculo_ano` AS `vehiculo_ano`,`m`.`vehiculo_cilindraje` AS `vehiculo_cilindraje`,`m`.`vehiculo_color_principal` AS `vehiculo_color_principal`,`m`.`vehiculo_color_secundario` AS `vehiculo_color_secundario`,`m`.`vehiculo_placa` AS `vehiculo_placa`,`m`.`vehiculo_motor` AS `vehiculo_motor`,`m`.`vehiculo_chasis` AS `vehiculo_chasis`,`m`.`comentario` AS `comentario`,`m`.`registrado_por` AS `registrado_por`,`m`.`user_motorizado_id` AS `user_motorizado_id`,`m`.`estado` AS `estado`,`m`.`created_at` AS `created_at`,`m`.`updated_at` AS `updated_at`,`um`.`username` AS `username`,`um`.`is_active` AS `user_active`,`um`.`last_login_at` AS `last_login_at`,`me`.`estado` AS `estado_actual`,`me`.`latitud` AS `latitud`,`me`.`longitud` AS `longitud`,`me`.`ultima_actividad` AS `ultima_actividad` from ((`motorizados` `m` left join `user_motorizados` `um` on((`m`.`user_motorizado_id` = `um`.`id`))) left join `motorizado_estados` `me` on((`m`.`id` = `me`.`motorizado_id`))) where ((`m`.`estado` = 1) and ((`um`.`is_active` = 1) or (`um`.`is_active` is null))) */;
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

-- Dump completed on 2025-10-06 17:08:33
