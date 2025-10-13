<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Artisan;

class SwitchToProduction extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'facturacion:switch-production 
                            {--cert-path= : Ruta al certificado de producción}
                            {--ruc= : RUC de la empresa}
                            {--user= : Usuario SOL de producción}
                            {--password= : Contraseña SOL de producción}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Cambiar configuración de facturación electrónica a ambiente de producción SUNAT';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('🚀 Cambiando a ambiente de PRODUCCIÓN SUNAT...');
        $this->newLine();

        // Verificar que se proporcionen los datos necesarios
        $certPath = $this->option('cert-path');
        $ruc = $this->option('ruc');
        $user = $this->option('user');
        $password = $this->option('password');

        if (!$certPath || !$ruc || !$user || !$password) {
            $this->error('❌ Faltan parámetros requeridos. Uso:');
            $this->line('php artisan facturacion:switch-production --cert-path=ruta/cert.pem --ruc=20123456789 --user=USUARIO_SOL --password=CLAVE_SOL');
            return 1;
        }

        // Verificar que el certificado existe
        if (!File::exists($certPath)) {
            $this->error("❌ El certificado no existe en: {$certPath}");
            return 1;
        }

        // Crear backup del .env actual
        $this->info('📋 Creando backup del .env actual...');
        $envPath = base_path('.env');
        $backupPath = base_path('.env.backup.' . date('Y-m-d-H-i-s'));
        File::copy($envPath, $backupPath);
        $this->line("✅ Backup creado: {$backupPath}");

        // Leer .env actual
        $envContent = File::get($envPath);

        // Actualizar variables de ambiente
        $this->info('⚙️ Actualizando configuración de producción...');
        
        $updates = [
            'GREENTER_AMBIENTE=produccion',
            "GREENTER_FE_USER={$user}",
            "GREENTER_FE_PASSWORD={$password}",
            "GREENTER_CERT_PATH={$certPath}",
            "COMPANY_RUC={$ruc}",
        ];

        foreach ($updates as $update) {
            $key = explode('=', $update)[0];
            $value = explode('=', $update, 2)[1];
            
            if (str_contains($envContent, $key)) {
                $envContent = preg_replace("/^{$key}=.*$/m", $update, $envContent);
            } else {
                $envContent .= "\n{$update}";
            }
            
            $this->line("✅ {$key} = {$value}");
        }

        // Guardar .env actualizado
        File::put($envPath, $envContent);

        // Limpiar cache de configuración
        $this->info('🧹 Limpiando cache de configuración...');
        Artisan::call('config:clear');
        Artisan::call('config:cache');

        $this->newLine();
        $this->info('✅ Configuración de PRODUCCIÓN aplicada exitosamente!');
        $this->newLine();
        
        $this->warn('⚠️  IMPORTANTE:');
        $this->line('• Verifica que el certificado sea válido y no esté vencido');
        $this->line('• Realiza una prueba con una factura real');
        $this->line('• Monitorea los logs para detectar errores');
        $this->line('• Ten un plan de rollback listo');
        $this->newLine();

        $this->info('🧪 Para probar la configuración:');
        $this->line('php artisan facturacion:test-produccion');

        return 0;
    }
}