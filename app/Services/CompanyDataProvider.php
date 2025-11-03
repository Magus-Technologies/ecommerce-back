<?php

namespace App\Services;

use App\Models\EmpresaInfo;
use Illuminate\Support\Facades\Log;

class CompanyDataProvider
{
    /**
     * Obtener información completa de la empresa desde la BD
     */
    public function getCompanyInfo(): array
    {
        try {
            $empresa = EmpresaInfo::first();

            if (!$empresa) {
                Log::warning('No se encontró información de empresa en la BD');
                return $this->getDefaultCompanyInfo();
            }

            return [
                'ruc' => $empresa->ruc ?? '00000000000',
                'razon_social' => $empresa->razon_social ?? $empresa->nombre_empresa ?? 'EMPRESA NO CONFIGURADA',
                'nombre_comercial' => $empresa->nombre_empresa ?? $empresa->razon_social ?? 'Empresa',
                'direccion_fiscal' => $empresa->direccion ?? 'Dirección no configurada',
                'distrito' => $empresa->distrito ?? null,
                'provincia' => $empresa->provincia ?? null,
                'departamento' => $empresa->departamento ?? null,
                'ubigeo' => $empresa->ubigeo ?? null,
                'telefono' => $empresa->telefono ?? $empresa->celular ?? null,
                'email' => $empresa->email ?? null,
                'web' => $empresa->website ?? null,
                'logo_path' => $this->getLogoPath($empresa->logo),
            ];

        } catch (\Exception $e) {
            Log::error('Error al obtener información de empresa desde BD', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return $this->getDefaultCompanyInfo();
        }
    }

    /**
     * Valores por defecto si no hay datos en BD
     */
    private function getDefaultCompanyInfo(): array
    {
        return [
            'ruc' => '20123456789',
            'razon_social' => 'MI EMPRESA SAC',
            'nombre_comercial' => 'MI EMPRESA',
            'direccion_fiscal' => 'Av. Principal 123, Lima, Perú',
            'distrito' => 'Lima',
            'provincia' => 'Lima',
            'departamento' => 'Lima',
            'telefono' => '+51 1 234-5678',
            'email' => 'contacto@miempresa.com',
            'web' => 'www.miempresa.com',
            'logo_path' => null,
        ];
    }

    /**
     * Obtener ruta del logo de la empresa
     */
    public function getLogoPath(?string $logoFromDb = null): ?string
    {
        // Si hay logo en BD, intentar usarlo primero
        if ($logoFromDb) {
            $dbPath = public_path($logoFromDb);
            if (file_exists($dbPath)) {
                Log::info('Logo encontrado desde BD: ' . $dbPath);
                return $dbPath;
            }
            
            // También intentar con storage
            $storagePath = storage_path('app/public/' . $logoFromDb);
            if (file_exists($storagePath)) {
                Log::info('Logo encontrado en storage: ' . $storagePath);
                return $storagePath;
            }
        }

        // Rutas alternativas
        $possiblePaths = [
            public_path('assets/images/logo/logo3.png'),
            public_path('assets/images/logo.png'),
            public_path('images/logo.png'),
            storage_path('app/public/logo.png'),
        ];

        foreach ($possiblePaths as $path) {
            if (file_exists($path)) {
                Log::info('Logo encontrado en ruta alternativa: ' . $path);
                return $path;
            }
        }

        Log::warning('Logo no encontrado');
        return null;
    }

    /**
     * Obtener información de contacto
     */
    public function getContactInfo(): array
    {
        try {
            $empresa = EmpresaInfo::first();
            
            if (!$empresa) {
                return [
                    'telefono' => null,
                    'email' => null,
                    'web' => null,
                    'whatsapp' => null,
                ];
            }

            return [
                'telefono' => $empresa->telefono ?? $empresa->celular,
                'email' => $empresa->email,
                'web' => $empresa->website,
                'whatsapp' => $empresa->whatsapp,
            ];
        } catch (\Exception $e) {
            Log::error('Error al obtener contacto de empresa', ['error' => $e->getMessage()]);
            return [
                'telefono' => null,
                'email' => null,
                'web' => null,
                'whatsapp' => null,
            ];
        }
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
            'has_logo' => ! is_null($companyInfo['logo_path']),
        ];
    }
}
