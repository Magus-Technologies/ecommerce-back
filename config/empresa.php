<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Información de la Empresa
    |--------------------------------------------------------------------------
    |
    | Configuración de los datos de la empresa para facturación electrónica
    | y generación de PDFs compliant con SUNAT.
    |
    */

    'ruc' => env('EMPRESA_RUC', '20123456789'),

    'razon_social' => env('EMPRESA_RAZON_SOCIAL', 'MI EMPRESA SAC'),

    'nombre_comercial' => env('EMPRESA_NOMBRE_COMERCIAL', 'MI EMPRESA'),

    'direccion' => env('EMPRESA_DIRECCION', 'Av. Principal 123, Lima, Perú'),

    'distrito' => env('EMPRESA_DISTRITO', 'Lima'),

    'provincia' => env('EMPRESA_PROVINCIA', 'Lima'),

    'departamento' => env('EMPRESA_DEPARTAMENTO', 'Lima'),

    'ubigueo' => env('EMPRESA_UBIGUEO', '150101'), // Lima-Lima-Lima

    /*
    |--------------------------------------------------------------------------
    | Información de Contacto
    |--------------------------------------------------------------------------
    */

    'telefono' => env('EMPRESA_TELEFONO', '+51 1 234-5678'),

    'email' => env('EMPRESA_EMAIL', 'contacto@miempresa.com'),

    'web' => env('EMPRESA_WEB', 'www.miempresa.com'),

    'whatsapp' => env('EMPRESA_WHATSAPP', '+51987654321'),

    /*
    |--------------------------------------------------------------------------
    | Logo y Branding
    |--------------------------------------------------------------------------
    */

    'logo_path' => env('EMPRESA_LOGO_PATH', 'images/logo-empresa.png'),

    /*
    |--------------------------------------------------------------------------
    | Configuración PDF
    |--------------------------------------------------------------------------
    */

    'pdf' => [
        'default_engine' => env('PDF_DEFAULT_ENGINE', 'dompdf'),
        'template_path' => env('PDF_TEMPLATE_PATH', 'resources/views/pdf'),
        'cache_enabled' => env('PDF_CACHE_ENABLED', true),
        'cache_ttl' => env('PDF_CACHE_TTL', 3600),

        'templates' => [
            'primary' => 'pdf.comprobante-sunat',
            'fallback' => 'pdf.comprobante-simple',
            'emergency' => 'pdf.comprobante-minimo',
        ],

        'options' => [
            'paper_size' => 'A4',
            'orientation' => 'portrait',
            'margin' => '10mm',
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Configuración QR
    |--------------------------------------------------------------------------
    */

    'qr' => [
        'enabled' => env('QR_ENABLED', true),
        'size' => env('QR_SIZE', 150),
        'margin' => env('QR_MARGIN', 1),
        'verification_url' => env('QR_VERIFICATION_URL', 'https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp'),
    ],
];
