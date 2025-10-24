# Plan de Implementación - Sistema de PDF Compliant con SUNAT

- [x] 1. Crear servicio de generación de PDF y estructura base


  - Crear PdfGeneratorService con interfaz y métodos principales
  - Implementar validación de comprobantes y manejo de errores básico
  - Crear clases de datos (PdfResult, CompanyData, TemplateData)
  - _Requirements: 7.1, 7.2, 7.3_

- [ ] 2. Implementar proveedor de datos de empresa
  - [x] 2.1 Crear CompanyDataProvider para obtener información de empresa



    - Implementar obtención de datos desde configuración y base de datos
    - Agregar soporte para logo de empresa y datos de contacto
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

  - [ ] 2.2 Configurar datos de empresa en el sistema
    - Agregar variables de entorno para datos de empresa
    - Crear migración para tabla de configuración de empresa si es necesario
    - _Requirements: 1.1, 1.2, 1.3_

- [ ] 3. Crear motor de plantillas HTML
  - [ ] 3.1 Implementar TemplateEngine con soporte para múltiples plantillas
    - Crear sistema de plantillas con Blade/HTML
    - Implementar carga y validación de plantillas
    - Agregar sistema de fallback entre plantillas
    - _Requirements: 7.4, 6.1, 6.2_




  - [ ] 3.2 Crear plantilla principal compliant con SUNAT
    - Diseñar plantilla HTML con todos los elementos requeridos
    - Incluir secciones para empresa, cliente, productos y totales
    - Implementar diseño profesional y responsive
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.5, 6.1, 6.2, 6.3, 6.4, 6.5_

  - [ ] 3.3 Crear plantilla de fallback simplificada
    - Implementar plantilla simplificada pero compliant
    - Asegurar que incluya elementos mínimos requeridos por SUNAT
    - _Requirements: 7.4, 2.1, 2.2, 2.3, 2.4, 2.5_

  - [ ] 3.4 Crear plantilla de emergencia mínima
    - Implementar plantilla ultra simple para casos de emergencia
    - Garantizar generación exitosa en cualquier escenario
    - _Requirements: 7.4_

- [ ] 4. Implementar tabla de productos detallada
  - [ ] 4.1 Crear componente de tabla de productos
    - Implementar tabla con todas las columnas requeridas por SUNAT
    - Incluir código, descripción, unidad, cantidad, precios e impuestos
    - Agregar formato apropiado para números y monedas
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_

  - [ ] 4.2 Implementar cálculo y formato de totales
    - Crear sección de totales con operación gravada, IGV y total
    - Implementar conversión de números a letras
    - Agregar soporte para descuentos si aplica
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ] 5. Agregar información legal y códigos de verificación
  - [ ] 5.1 Implementar generador de códigos QR
    - Crear QrCodeGenerator para generar códigos QR de verificación
    - Implementar URL de consulta SUNAT
    - Integrar códigos QR en las plantillas
    - _Requirements: 4.2, 4.4_

  - [ ] 5.2 Agregar información legal requerida
    - Incluir código hash del XML en el PDF
    - Agregar leyenda de representación impresa
    - Mostrar estado del CDR cuando esté disponible
    - Incluir URL de consulta SUNAT
    - _Requirements: 4.1, 4.3, 4.4, 4.5_

- [ ] 6. Implementar motor de renderizado PDF robusto
  - [ ] 6.1 Crear PdfRenderer con múltiples motores
    - Implementar soporte para DomPDF como motor principal
    - Agregar fallback a otros motores si están disponibles
    - Crear sistema de detección automática de motores disponibles
    - _Requirements: 7.4, 6.5_

  - [ ] 6.2 Integrar sistema de fallback completo
    - Implementar cascada de fallback: DomPDF → HTML2PDF → HTML simple
    - Agregar logging detallado de intentos y errores
    - Garantizar que siempre se genere algún tipo de documento
    - _Requirements: 7.1, 7.4, 7.5_

- [ ] 7. Actualizar GreenterService para usar nuevo generador
  - [ ] 7.1 Refactorizar método generarPdf en GreenterService
    - Reemplazar implementación actual con llamada a PdfGeneratorService
    - Mantener compatibilidad con código existente
    - Agregar manejo mejorado de errores
    - _Requirements: 7.1, 7.2, 7.3, 7.5_

  - [ ] 7.2 Actualizar métodos relacionados con PDF
    - Modificar generarPdfSimple y generarPdfEmergencia para usar nuevo sistema
    - Asegurar que todos los métodos usen el nuevo generador
    - _Requirements: 7.1, 7.4_

- [ ] 8. Mejorar endpoint de generación de PDF
  - [ ] 8.1 Actualizar VentasController::generarPdf
    - Integrar nuevo PdfGeneratorService en el controlador
    - Mejorar respuestas de error con información más detallada
    - Agregar validaciones adicionales
    - _Requirements: 7.2, 7.3_

  - [ ] 8.2 Agregar endpoint de regeneración forzada
    - Crear endpoint para regenerar PDF forzadamente
    - Permitir selección de plantilla específica
    - Agregar opciones de configuración en la respuesta
    - _Requirements: 7.3, 7.5_

- [ ] 9. Implementar configuración y personalización
  - [ ] 9.1 Crear sistema de configuración
    - Agregar archivo de configuración para PDF
    - Implementar variables de entorno para personalización
    - Crear comando artisan para configuración inicial
    - _Requirements: 1.1, 1.2, 1.3, 1.4_

  - [ ] 9.2 Agregar soporte para logos y branding
    - Implementar carga y validación de logos de empresa
    - Crear sistema de almacenamiento de assets
    - Agregar redimensionamiento automático de imágenes
    - _Requirements: 1.4, 6.3_

- [ ]* 10. Testing y validación
  - [ ]* 10.1 Crear tests unitarios para PdfGeneratorService
    - Escribir tests para generación exitosa y manejo de errores
    - Probar diferentes tipos de comprobantes
    - Validar sistema de fallback
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

  - [ ]* 10.2 Crear tests de integración
    - Probar flujo completo desde controlador
    - Validar generación con datos reales
    - Probar diferentes escenarios de error
    - _Requirements: 7.1, 7.2, 7.3, 7.5_

  - [ ]* 10.3 Crear tests de validación SUNAT
    - Verificar que PDFs cumplen requisitos legales
    - Validar presencia de todos los elementos obligatorios
    - Probar con diferentes tipos de comprobantes
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 2.4, 2.5, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ] 11. Documentación y comando de prueba
  - [ ] 11.1 Crear comando artisan de prueba
    - Implementar comando para probar generación de PDF
    - Agregar opciones para diferentes tipos de comprobantes
    - Incluir validación de configuración
    - _Requirements: 7.5_

  - [ ] 11.2 Actualizar documentación del sistema
    - Documentar nuevas funcionalidades y configuración
    - Crear guía de troubleshooting
    - Agregar ejemplos de uso
    - _Requirements: 7.2, 7.3_