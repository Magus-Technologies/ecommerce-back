# Requisitos - Sistema de PDF Compliant con SUNAT

## Introducción

El sistema actual de facturación electrónica genera PDFs básicos que no cumplen con todos los requisitos legales y profesionales establecidos por SUNAT para comprobantes electrónicos. Se requiere mejorar el sistema de generación de PDF para que incluya todos los elementos obligatorios y opcionales que garanticen el cumplimiento normativo y una presentación profesional.

## Requisitos Previos y Dependencias

### Requisitos del Sistema

- PHP >= 8.2
- Composer >= 2.0
- MySQL >= 8.0
- Node.js >= 18.0
- npm >= 9.0

### Extensiones PHP Requeridas

Las siguientes extensiones PHP deben estar habilitadas en `php.ini`:

```ini
extension=gd
extension=intl
extension=xsl
extension=soap
extension=curl
extension=dom
extension=openssl
extension=zlib
extension=mbstring
extension=json
extension=fileinfo
extension=zip
```

### Instalación de Dependencias

Ejecutar los siguientes comandos en el orden especificado:

#### 1. Instalar dependencias PHP (Composer)

```bash
composer require barryvdh/laravel-dompdf dompdf/dompdf greenter/greenter greenter/report greenter/htmltopdf bacon/bacon-qr-code luecano/numero-a-letras --no-interaction
```

#### 2. Instalar dependencias Node.js

```bash
npm install
```

#### 3. Publicar configuraciones de Laravel

```bash
php artisan vendor:publish --provider="Barryvdh\DomPDF\ServiceProvider"
```

#### 4. Crear estructura de directorios

```bash
# Windows (PowerShell)
New-Item -ItemType Directory -Force -Path "storage\app\certificates"
New-Item -ItemType Directory -Force -Path "storage\app\public\comprobantes\pdf"
New-Item -ItemType Directory -Force -Path "storage\app\public\comprobantes\xml"
New-Item -ItemType Directory -Force -Path "storage\app\public\comprobantes\cdr"

# Linux/Mac
mkdir -p storage/app/certificates
mkdir -p storage/app/public/comprobantes/{pdf,xml,cdr}
```

#### 5. Configurar variables de entorno (.env)

Agregar las siguientes variables al archivo `.env`:

```env
# ========================================
# FACTURACIÓN ELECTRÓNICA - GREENTER
# ========================================
# Modo: BETA (pruebas) o PRODUCCION
GREENTER_MODE=BETA
GREENTER_AMBIENTE=beta

# Credenciales SUNAT SOL (pruebas BETA - usuario público)
GREENTER_FE_USER=20000000001MODDATOS
GREENTER_FE_PASSWORD=MODDATOS

# Certificado digital
# Para BETA: Se usa automáticamente el certificado de prueba de Greenter
# Para PRODUCCION: Configurar la ruta al certificado real (.pfx o .pem)
GREENTER_CERT_PATH=certificates/certificate.pem
GREENTER_CLAVE_SOL=

# ========================================
# DATOS DE LA EMPRESA (PRUEBAS)
# ========================================
COMPANY_RUC=20000000001
COMPANY_NAME="EMPRESA DE PRUEBAS S.A.C."
COMPANY_ADDRESS="AV. PRINCIPAL 123"
COMPANY_DISTRICT=LIMA
COMPANY_PROVINCE=LIMA
COMPANY_DEPARTMENT=LIMA
COMPANY_UBIGEO=150101

# Logo para PDFs (opcional, mejorar presentación)
COMPANY_LOGO_PATH=logo-empresa.png
EMPRESA_LOGO_PATH=images/logo-empresa.png
EMPRESA_WEB=www.miempresa.com

# Configuración PDF
PDF_DEFAULT_ENGINE=dompdf
PDF_CACHE_ENABLED=true
PDF_CACHE_TTL=3600
QR_ENABLED=true
QR_SIZE=150
QR_VERIFICATION_URL=https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp
```

#### 6. Obtener certificado digital

Para ambiente de pruebas (BETA):
- Usuario SOL: `MODDATOS`
- Clave SOL: `MODDATOS`
- Certificado: Greenter usa automáticamente su certificado de prueba cuando `GREENTER_MODE=BETA`
- **IMPORTANTE**: El certificado debe estar en `storage/app/certificates/certificate.pem`

Para ambiente de producción:
1. Obtener certificado digital (.pfx o .p12) de SUNAT
2. Convertir a formato .pem:
```bash
openssl pkcs12 -in certificado.pfx -out storage/app/certificates/certificate.pem -nodes
```
3. Actualizar `.env`:
```env
GREENTER_MODE=PRODUCCION
GREENTER_AMBIENTE=produccion
GREENTER_FE_USER=TU_RUC_USUARIO_SOL
GREENTER_FE_PASSWORD=TU_CLAVE_SOL
GREENTER_CERT_PATH=certificates/certificate.pem
COMPANY_RUC=TU_RUC_EMPRESA
```

#### 7. Limpiar caché de configuración

```bash
php artisan config:clear
php artisan cache:clear
```

#### 8. Verificar instalación

```bash
# Verificar extensiones PHP
php -m | findstr "gd intl xsl soap"

# Verificar dependencias Composer
composer show | findstr "greenter dompdf qr-code"

# Verificar permisos de directorios
php artisan storage:link
```

### Dependencias Instaladas

Las siguientes librerías serán instaladas:

- `barryvdh/laravel-dompdf` (^3.1) - Wrapper de DomPDF para Laravel
- `dompdf/dompdf` (^3.1) - Motor de generación de PDFs desde HTML
- `greenter/greenter` (^5.1) - Librería de facturación electrónica SUNAT
- `greenter/report` - Generación de reportes PDF para comprobantes
- `greenter/htmltopdf` - Conversión HTML a PDF para Greenter
- `bacon/bacon-qr-code` (^2.0) - Generación de códigos QR
- `luecano/numero-a-letras` (^4.0) - Conversión de números a letras en español

### Orden de Ejecución Recomendado

1. Verificar requisitos del sistema (PHP, extensiones)
2. Instalar dependencias Composer
3. Instalar dependencias npm
4. Crear estructura de directorios
5. Configurar variables de entorno
6. Obtener/configurar certificado digital
7. Publicar configuraciones
8. Limpiar caché
9. Verificar instalación

## Glosario

- **SUNAT**: Superintendencia Nacional de Aduanas y de Administración Tributaria del Perú
- **PDF_Generator**: Servicio responsable de generar documentos PDF de comprobantes electrónicos
- **Comprobante_Electronico**: Documento fiscal digital (factura, boleta, nota de crédito/débito)
- **CDR**: Constancia de Recepción emitida por SUNAT
- **QR_Code**: Código QR que permite verificar la autenticidad del comprobante
- **Hash_Code**: Código hash único del XML firmado digitalmente
- **Template_Engine**: Motor de plantillas para generar el HTML del PDF
- **Company_Data**: Información de la empresa emisora del comprobante

## Requisitos

### Requisito 1

**User Story:** Como usuario del sistema de facturación, quiero que los PDFs generados incluyan toda la información de la empresa emisora, para que cumplan con los requisitos legales de SUNAT.

#### Acceptance Criteria

1. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir el RUC de la empresa emisora
2. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la razón social completa de la empresa
3. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la dirección fiscal de la empresa
4. WHERE el Company_Data incluye un logo, THE PDF_Generator SHALL mostrar el logo de la empresa en el encabezado
5. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la información de contacto de la empresa

### Requisito 2

**User Story:** Como usuario del sistema, quiero que el PDF muestre el tipo específico de comprobante según SUNAT, para que sea claro qué tipo de documento fiscal es.

#### Acceptance Criteria

1. WHEN el Comprobante_Electronico es tipo "01", THE PDF_Generator SHALL mostrar "FACTURA ELECTRÓNICA"
2. WHEN el Comprobante_Electronico es tipo "03", THE PDF_Generator SHALL mostrar "BOLETA DE VENTA ELECTRÓNICA"
3. WHEN el Comprobante_Electronico es tipo "07", THE PDF_Generator SHALL mostrar "NOTA DE CRÉDITO ELECTRÓNICA"
4. WHEN el Comprobante_Electronico es tipo "08", THE PDF_Generator SHALL mostrar "NOTA DE DÉBITO ELECTRÓNICA"
5. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL mostrar el número completo del comprobante en formato serie-correlativo

### Requisito 3

**User Story:** Como usuario del sistema, quiero que el PDF incluya el detalle completo de productos con todas las columnas requeridas, para que cumpla con los estándares de facturación electrónica.

#### Acceptance Criteria

1. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir una tabla con el código del producto
2. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la descripción completa del producto
3. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la unidad de medida
4. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la cantidad
5. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir el precio unitario sin IGV
6. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir el valor de venta por línea
7. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir el IGV por línea
8. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir el total por línea

### Requisito 4

**User Story:** Como usuario del sistema, quiero que el PDF incluya toda la información legal requerida por SUNAT, para que el comprobante sea válido y verificable.

#### Acceptance Criteria

1. WHEN el Comprobante_Electronico tiene Hash_Code, THE PDF_Generator SHALL incluir el código hash del XML
2. WHERE el Comprobante_Electronico tiene QR_Code, THE PDF_Generator SHALL incluir el código QR generado
3. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la leyenda "Representación impresa del comprobante electrónico"
4. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL incluir la URL de consulta SUNAT
5. WHERE el Comprobante_Electronico tiene CDR, THE PDF_Generator SHALL incluir el estado del CDR

### Requisito 5

**User Story:** Como usuario del sistema, quiero que el PDF muestre los totales detallados según los estándares de SUNAT, para que sea claro el desglose de impuestos y totales.

#### Acceptance Criteria

1. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL mostrar la operación gravada como base imponible
2. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL mostrar el IGV calculado al 18%
3. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL mostrar el total en números
4. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL mostrar el total en letras en formato "SON: [MONTO] CON [CENTAVOS]/100 SOLES"
5. WHERE el comprobante incluye descuentos, THE PDF_Generator SHALL mostrar los descuentos aplicados

### Requisito 6

**User Story:** Como usuario del sistema, quiero que el PDF tenga un diseño profesional y legible, para que represente adecuadamente la imagen de la empresa.

#### Acceptance Criteria

1. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL usar un diseño con encabezado, cuerpo y pie de página claramente definidos
2. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL usar fuentes legibles y tamaños apropiados
3. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL usar colores que mantengan la legibilidad en impresión
4. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL organizar la información en secciones lógicas
5. WHEN el PDF_Generator genera un comprobante, THE PDF_Generator SHALL asegurar que el PDF sea imprimible en formato A4

### Requisito 7

**User Story:** Como desarrollador del sistema, quiero que el generador de PDF sea robusto y maneje errores apropiadamente, para que el sistema sea confiable.

#### Acceptance Criteria

1. WHEN el PDF_Generator falla al generar un PDF, THE PDF_Generator SHALL registrar el error en los logs del sistema
2. WHEN el PDF_Generator no puede acceder a los datos del comprobante, THE PDF_Generator SHALL retornar un mensaje de error específico
3. WHEN el PDF_Generator genera un PDF exitosamente, THE PDF_Generator SHALL actualizar el estado del comprobante
4. IF el Template_Engine no está disponible, THEN THE PDF_Generator SHALL usar un template de respaldo
5. WHEN el PDF_Generator completa la generación, THE PDF_Generator SHALL validar que el archivo PDF sea válido
# 🛒 Sistema de E-commerce con Angular y Laravel

Un sistema completo de comercio electrónico con frontend en Angular 18 y backend en Laravel 12, que incluye gestión de productos, pedidos, usuarios y un sistema de tracking avanzado para envíos a provincia.

## 📋 Características principales

### 🌟 Frontend (Angular 18)
- ✅ Tienda online con catálogo de productos
- ✅ Sistema de autenticación de usuarios
- ✅ Carrito de compras y checkout
- ✅ Panel de administración completo
- ✅ Gestión de direcciones con ubigeo
- ✅ Tracking visual para pedidos a provincia
- ✅ Sistema de reclamos (libro de reclamaciones)
- ✅ Diseño responsive con Bootstrap 5

### 🚀 Backend (Laravel 12)
- ✅ API RESTful completa
- ✅ Sistema de autenticación JWT
- ✅ Gestión de productos y categorías
- ✅ Procesamiento de pedidos
- ✅ Sistema de tracking de pedidos
- ✅ Gestión de usuarios y roles
- ✅ Base de datos MySQL

## 🛠️ Requisitos del sistema

Antes de comenzar, asegúrate de tener instalado:

### Para el Backend (Laravel 12):
- **PHP >= 8.2**
- **Composer** (Gestor de dependencias de PHP)
- **MySQL >= 8.0** o MariaDB
- **Apache** o **Nginx**

### Para el Frontend (Angular):
- **Node.js >= 18.0**
- **npm >= 9.0** o **yarn**
- **Angular CLI >= 18**

### Herramientas adicionales:
- **Git** (para clonar el repositorio)
- **Visual Studio Code** (editor recomendado)

---

## 📥 Instalación paso a paso

### 🗂️ 1. Estructura del proyecto
```
eccomert/
├── ecommerce-bak-magus/     # Backend Laravel
├── ecommerce-front/         # Frontend Angular
└── README.md               # Este archivo
```

### 🔧 2. Configuración del Backend (Laravel)

#### 2.1 Navegar al directorio del backend
```bash
cd ecommerce-bak-magus
```

#### 2.2 Instalar dependencias de PHP
```bash
composer install
# o también puedes usar:
composer i
```

#### 2.3 Configurar variables de entorno
```bash
# Copiar el archivo de configuración
cp .env.example .env

# Generar la clave de la aplicación
php artisan key:generate
```

#### 2.4 Configurar la base de datos
Edita el archivo `.env` con tus credenciales de base de datos:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ecommerce_db
DB_USERNAME=tu_usuario
DB_PASSWORD=tu_contraseña
```

#### 2.5 Crear la base de datos
Crea una base de datos MySQL llamada `ecommerce_db` (o el nombre que pusiste en DB_DATABASE):
```sql
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 2.6 Ejecutar migraciones y seeders
```bash
# Ejecutar migraciones
php artisan migrate

# Ejecutar seeders (datos de prueba)
php artisan db:seed
```

#### 2.7 Configurar JWT (Autenticación)
```bash
# Instalar JWT
composer require tymon/jwt-auth

# Publicar configuración
php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"

# Generar clave JWT
php artisan jwt:secret
```

#### 2.8 Crear enlaces simbólicos para archivos
```bash
php artisan storage:link
```

#### 2.9 Iniciar el servidor de desarrollo
```bash
php artisan serve
```
El backend estará disponible en: `http://localhost:8000`

### 🎨 3. Configuración del Frontend (Angular)

#### 3.1 Navegar al directorio del frontend
```bash
cd ../ecommerce-front
```

#### 3.2 Instalar Node.js y Angular CLI
Si no tienes Node.js instalado:
1. Descarga desde: https://nodejs.org/
2. Instala Angular CLI globalmente:
```bash
npm install -g @angular/cli@18
```

#### 3.3 Instalar dependencias del proyecto
```bash
npm install
# o también puedes usar:
npm i
```

#### 3.4 Configurar el entorno
Verifica que el archivo `src/environments/environment.ts` tenga la URL correcta del backend:
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8000/api'
};
```

#### 3.5 Iniciar el servidor de desarrollo
```bash
ng serve
```
El frontend estará disponible en: `http://localhost:4200`

---

## 🚀 Primeros pasos

### 👤 Usuarios por defecto

El sistema viene con usuarios pre-configurados:

#### Administrador
- **Email**: `admin@ecommerce.com`
- **Contraseña**: `password123`
- **Acceso**: Panel de administración completo

#### Cliente de prueba
- **Email**: `cliente@test.com`
- **Contraseña**: `password123`
- **Acceso**: Tienda y cuenta de cliente

### 🛍️ Cómo usar el sistema

1. **Acceder a la tienda**: Ve a `http://localhost:4200`
2. **Navegar productos**: Explora el catálogo de productos
3. **Crear cuenta**: Regístrate como nuevo cliente
4. **Realizar compra**: Agrega productos al carrito y procede al checkout
5. **Panel admin**: Accede con credenciales de admin para gestionar productos y pedidos

---

## 🔧 Configuración avanzada

### 📧 Configurar correos electrónicos
En el archivo `.env` del backend, configura tu servicio de correo:
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu-email@gmail.com
MAIL_PASSWORD=tu-app-password
MAIL_ENCRYPTION=tls
```

### 🌍 Configurar ubigeo (Perú)
El sistema incluye datos completos de ubigeo peruano:
- Departamentos
- Provincias  
- Distritos

Los datos se cargan automáticamente con los seeders.

### 🚚 Sistema de tracking
El sistema incluye tracking avanzado para pedidos:
- **Pedidos normales**: Pendiente → Confirmado → En Preparación → Enviado → Entregado
- **Pedidos a provincia**: Pendiente → Confirmado → En Recepción → Enviado a Provincia → Entregado

---

## 🐛 Solución de problemas comunes

### Error: "Class not found"
```bash
# En el directorio del backend
composer dump-autoload
```

### Error: "No application encryption key"
```bash
# En el directorio del backend  
php artisan key:generate
```

### Error: "SQLSTATE[42S02]: Base table or table doesn't exist"
```bash
# En el directorio del backend
php artisan migrate:fresh --seed
```

### Error: "ng command not found"
```bash
# Instalar Angular CLI globalmente
npm install -g @angular/cli@18
```

### Error: "Cannot GET /api/*"
Verifica que el servidor de Laravel esté ejecutándose en `http://localhost:8000`

### Problemas de CORS
Si hay problemas de CORS entre frontend y backend, verifica:
1. Laravel esté corriendo en el puerto 8000
2. Angular esté corriendo en el puerto 4200
3. La configuración de CORS en `config/cors.php`

---

## 📁 Estructura de archivos importantes

### Backend (Laravel)
```
ecommerce-bak-magus/
├── app/
│   ├── Http/Controllers/    # Controladores API
│   ├── Models/             # Modelos Eloquent
│   └── ...
├── database/
│   ├── migrations/         # Migraciones de BD
│   └── seeders/           # Datos de prueba
├── routes/
│   └── api.php            # Rutas de la API
└── .env                   # Variables de entorno
```

### Frontend (Angular)
```
ecommerce-front/
├── src/
│   ├── app/
│   │   ├── components/    # Componentes reutilizables
│   │   ├── pages/        # Páginas principales
│   │   ├── services/     # Servicios para API
│   │   └── models/       # Interfaces TypeScript
│   └── environments/     # Configuración de entornos
└── angular.json          # Configuración de Angular
```

---

## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## 📝 Notas importantes

- ⚠️ Este es un proyecto de desarrollo, no usar en producción sin configuraciones adicionales de seguridad
- 🔐 Cambiar todas las contraseñas por defecto en producción
- 🛡️ Configurar HTTPS en producción
- 📊 Configurar backup automático de la base de datos
- 🚀 Usar un servidor web como Apache o Nginx en producción

---

## 📞 Soporte

Si encuentras algún problema durante la instalación:

1. Revisa esta guía paso a paso
2. Verifica que todos los requisitos estén instalados
3. Consulta los logs de errores:
   - Backend: `storage/logs/laravel.log`
   - Frontend: Consola del navegador (F12)

---

## 📄 Licencia

Este proyecto es de uso educativo y de desarrollo.

---

**¡Listo para comenzar! 🎉**

Ahora tienes un sistema de e-commerce completo funcionando en tu máquina local. Puedes empezar a explorar las funcionalidades, agregar productos, realizar pedidos de prueba y personalizar el sistema según tus necesidades.