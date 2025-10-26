<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class FacturacionVerificarCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'facturacion:verificar';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Verifica la configuración de facturación electrónica (SUNAT/Greenter)';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $config = [
            'modo' => env('GREENTER_MODE', env('GREENTER_AMBIENTE', 'BETA')),
            'usuario_sunat' => env('GREENTER_FE_USER'),
            'certificado_path' => storage_path('app/' . env('GREENTER_CERT_PATH', 'certificates/certificate.pem')),
            'ruc_empresa' => env('COMPANY_RUC'),
            'nombre_empresa' => env('COMPANY_NAME'),
            'logo_path' => public_path(env('COMPANY_LOGO_PATH', 'logo-empresa.png')),
        ];

        $checks = [
            ['Certificado existe', file_exists($config['certificado_path'])],
            ['Usuario SUNAT configurado', !empty($config['usuario_sunat'])],
            ['RUC empresa configurado', !empty($config['ruc_empresa'])],
        ];

        $this->info('Verificando configuración de facturación electrónica:');
        $this->line('Modo: ' . $config['modo']);
        $this->line('Usuario SUNAT: ' . ($config['usuario_sunat'] ?: '(no configurado)'));
        $this->line('Certificado: ' . $config['certificado_path']);
        $this->line('Empresa: ' . ($config['nombre_empresa'] ?: '(sin nombre)') . ' | RUC: ' . ($config['ruc_empresa'] ?: '(no configurado)'));
        $this->line('Logo: ' . $config['logo_path']);

        $errores = [];
        foreach ($checks as [$label, $ok]) {
            $this->line(($ok ? '✔️' : '❌') . ' ' . $label);
            if (!$ok) {
                $errores[] = $label;
            }
        }

        if (!empty($errores)) {
            $this->error('Configuración incompleta. Revisa: ' . implode(', ', $errores));
            return self::FAILURE;
        }

        $this->info('Configuración correcta para facturación electrónica.');
        return self::SUCCESS;
    }
}


