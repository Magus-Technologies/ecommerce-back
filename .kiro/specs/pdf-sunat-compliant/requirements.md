# Requisitos - Sistema de PDF Compliant con SUNAT

## Introducción

El sistema actual de facturación electrónica genera PDFs básicos que no cumplen con todos los requisitos legales y profesionales establecidos por SUNAT para comprobantes electrónicos. Se requiere mejorar el sistema de generación de PDF para que incluya todos los elementos obligatorios y opcionales que garanticen el cumplimiento normativo y una presentación profesional.

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