<?php

namespace App\Services;

use Illuminate\Support\Facades\Storage;

class CompanyDataProvider
{
    /**
     * Obtener información completa de la empresa
     */
    public function getCompanyInfo(): array
    {
        return [
            'ruc' => config('empresa.ruc', env('EMPRESA_RUC', '20123456789')),
            'razon_social' => config('empresa.razon_social', env('EMPRESA_RAZON_SOCIAL', 'MI EMPRESA SAC')),
            'nombre_comercial' => config('empresa.nombre_comercial', env('EMPRESA_NOMBRE_COMERCIAL', 'MI EMPRESA')),
            'direccion_fiscal' => config('empresa.direccion', env('EMPRESA_DIRECCION', 'Av. Principal 123, Lima, Perú')),
            'distrito' => config('empresa.distrito', env('EMPRESA_DISTRITO', 'Lima')),
            'provincia' => config('empresa.provincia', env('EMPRESA_PROVINCIA', 'Lima')),
            'departamento' => config('empresa.departamento', env('EMPRESA_DEPARTAMENTO', 'Lima')),
            'telefono' => config('empresa.telefono', env('EMPRESA_TELEFONO', '+51 1 234-5678')),
            'email' => config('empresa.email', env('EMPRESA_EMAIL', 'contacto@miempresa.com')),
            'web' => config('empresa.web', env('EMPRESA_WEB', 'www.miempresa.com')),
            'logo_path' => $this->getLogoPath()
        ];
    }

    /**
     * Obtener ruta del logo de la empresa
     */
    public function getLogoPath(): ?string
    {
        // Rutas a verificar en orden de prioridad
        $possiblePaths = [
            // Ruta específica mencionada por el usuario
            public_path('assets/images/logo/logo3.png'),
            
            // Rutas de configuración
            public_path(config('empresa.logo_path', env('EMPRESA_LOGO_PATH', 'images/logo-empresa.png'))),
            
            // Rutas alternativas comunes
            public_path('assets/images/logo.png'),
            public_path('assets/images/logo/logo.png'),
            public_path('images/logo.png'),
            public_path('images/logo3.png'),
            public_path('assets/logo.png'),
            storage_path('app/public/logo.png'),
            storage_path('app/public/images/logo.png'),
            storage_path('app/public/assets/images/logo/logo3.png')
        ];
        
        foreach ($possiblePaths as $path) {
            if (file_exists($path)) {
                \Log::info('Logo encontrado en: ' . $path);
                return $path;
            }
        }
        
        \Log::warning('Logo no encontrado en ninguna ruta', [
            'rutas_verificadas' => $possiblePaths
        ]);
        
        return null;
    }

    /**
     * Obtener información de contacto
     */
    public function getContactInfo(): array
    {
        return [
            'telefono' => config('empresa.telefono', env('EMPRESA_TELEFONO')),
            'email' => config('empresa.email', env('EMPRESA_EMAIL')),
            'web' => config('empresa.web', env('EMPRESA_WEB')),
            'whatsapp' => config('empresa.whatsapp', env('EMPRESA_WHATSAPP'))
        ];
    }

    /**
     * Verificar si la configuración de empresa está completa
     */
    public function isConfigurationComplete(): array
    {
        $companyInfo = $this->getCompanyInfo();
        $missing = [];

        if (empty($companyInfo['ruc'])) {
            $missing[] = 'RUC de la empresa';
        }

        if (empty($companyInfo['razon_social'])) {
            $missing[] = 'Razón social';
        }

        if (empty($companyInfo['direccion_fiscal'])) {
            $missing[] = 'Dirección fiscal';
        }

        return [
            'complete' => empty($missing),
            'missing' => $missing,
            'has_logo' => !is_null($companyInfo['logo_path'])
        ];
    }
}