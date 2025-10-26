<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use App\Models\SunatLog;
use App\Services\GreenterService;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class MaintenanceTasks extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'facturacion:maintenance 
                            {--task=all : Tarea específica (all, retry-failed, cleanup-logs, backup-files, check-certificate)}
                            {--days=30 : Días para limpieza de logs}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Tareas de mantenimiento del sistema de facturación electrónica';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $task = $this->option('task');
        $days = $this->option('days');

        $this->info('🔧 MANTENIMIENTO DEL SISTEMA DE FACTURACIÓN');
        $this->info('============================================');
        $this->newLine();

        switch ($task) {
            case 'retry-failed':
                $this->retryFailedInvoices();
                break;
            case 'cleanup-logs':
                $this->cleanupLogs($days);
                break;
            case 'backup-files':
                $this->backupFiles();
                break;
            case 'check-certificate':
                $this->checkCertificate();
                break;
            case 'all':
            default:
                $this->retryFailedInvoices();
                $this->cleanupLogs($days);
                $this->backupFiles();
                $this->checkCertificate();
                break;
        }

        $this->newLine();
        $this->info('✅ Mantenimiento completado');
        return 0;
    }

    /**
     * Reintentar facturas fallidas
     */
    private function retryFailedInvoices()
    {
        $this->info('🔄 Reintentando facturas fallidas...');
        
        $failedInvoices = Comprobante::where('estado', 'ERROR')
            ->where('created_at', '>=', Carbon::now()->subDays(7))
            ->get();

        if ($failedInvoices->isEmpty()) {
            $this->line('✅ No hay facturas fallidas para reintentar');
            return;
        }

        $this->line("📊 Encontradas {$failedInvoices->count()} facturas fallidas");

        $successCount = 0;
        $errorCount = 0;

        foreach ($failedInvoices as $comprobante) {
            try {
                $this->line("🔄 Reintentando: {$comprobante->serie}-{$comprobante->correlativo}");
                
                $greenterService = new GreenterService();
                $resultado = $greenterService->generarFactura($comprobante->id, null, 1, '127.0.0.1');
                
                $comprobante->refresh();
                if ($comprobante->estado === 'ACEPTADO' || $comprobante->estado === 'RECHAZADO') {
                    $successCount++;
                    $this->line("✅ {$comprobante->estado}: {$comprobante->serie}-{$comprobante->correlativo}");
                } else {
                    $errorCount++;
                    $this->line("❌ Error: {$comprobante->serie}-{$comprobante->correlativo}");
                }
            } catch (\Exception $e) {
                $errorCount++;
                $this->line("❌ Excepción: {$comprobante->serie}-{$comprobante->correlativo} - {$e->getMessage()}");
            }
        }

        $this->line("📊 Resultado: {$successCount} exitosos, {$errorCount} errores");
    }

    /**
     * Limpiar logs antiguos
     */
    private function cleanupLogs($days)
    {
        $this->info("🧹 Limpiando logs antiguos (más de {$days} días)...");
        
        $cutoffDate = Carbon::now()->subDays($days);
        
        // Limpiar logs de SUNAT antiguos
        $deletedLogs = SunatLog::where('created_at', '<', $cutoffDate)->delete();
        $this->line("✅ Eliminados {$deletedLogs} logs de SUNAT antiguos");

        // Limpiar logs de Laravel antiguos
        $logPath = storage_path('logs/laravel.log');
        if (file_exists($logPath) && filesize($logPath) > 50 * 1024 * 1024) { // 50MB
            $this->line("📄 Log de Laravel muy grande, rotando...");
            $backupPath = storage_path('logs/laravel-' . date('Y-m-d-H-i-s') . '.log');
            rename($logPath, $backupPath);
            touch($logPath);
            $this->line("✅ Log rotado a: {$backupPath}");
        }

        // Limpiar archivos XML temporales
        $xmlFiles = Storage::files('temp');
        $deletedXml = 0;
        foreach ($xmlFiles as $file) {
            if (Storage::lastModified($file) < $cutoffDate->timestamp) {
                Storage::delete($file);
                $deletedXml++;
            }
        }
        $this->line("✅ Eliminados {$deletedXml} archivos XML temporales");
    }

    /**
     * Hacer backup de archivos importantes
     */
    private function backupFiles()
    {
        $this->info('💾 Creando backup de archivos importantes...');
        
        $backupDir = storage_path('backups/' . date('Y-m-d'));
        if (!is_dir($backupDir)) {
            mkdir($backupDir, 0755, true);
        }

        // Backup de certificados
        $certPath = config('services.greenter.cert_path');
        if (file_exists($certPath)) {
            $certBackup = $backupDir . '/certificate-' . date('H-i-s') . '.pem';
            copy($certPath, $certBackup);
            $this->line("✅ Certificado respaldado: {$certBackup}");
        }

        // Backup de configuración
        $configBackup = $backupDir . '/config-' . date('H-i-s') . '.json';
        $config = [
            'ambiente' => config('services.greenter.ambiente'),
            'ruc' => config('services.company.ruc'),
            'fecha_backup' => now()->toISOString(),
            'version' => '1.0.0'
        ];
        file_put_contents($configBackup, json_encode($config, JSON_PRETTY_PRINT));
        $this->line("✅ Configuración respaldada: {$configBackup}");

        // Limpiar backups antiguos (más de 30 días)
        $oldBackups = glob(storage_path('backups/*'));
        $deletedBackups = 0;
        foreach ($oldBackups as $backup) {
            if (is_dir($backup) && filemtime($backup) < Carbon::now()->subDays(30)->timestamp) {
                $this->deleteDirectory($backup);
                $deletedBackups++;
            }
        }
        $this->line("✅ Eliminados {$deletedBackups} backups antiguos");
    }

    /**
     * Verificar certificado
     */
    private function checkCertificate()
    {
        $this->info('🔐 Verificando certificado digital...');
        
        $certPath = config('services.greenter.cert_path');
        
        if (!file_exists($certPath)) {
            $this->error("❌ Certificado no encontrado: {$certPath}");
            return;
        }

        $certContent = file_get_contents($certPath);
        
        // Verificar que es un certificado válido
        if (!str_contains($certContent, '-----BEGIN CERTIFICATE-----')) {
            $this->error('❌ El archivo no parece ser un certificado válido');
            return;
        }

        // Verificar fecha de expiración
        $certInfo = openssl_x509_parse($certContent);
        if ($certInfo) {
            $expiryDate = Carbon::createFromTimestamp($certInfo['validTo_time_t']);
            $daysUntilExpiry = Carbon::now()->diffInDays($expiryDate, false);
            
            if ($daysUntilExpiry < 0) {
                $this->error("❌ Certificado EXPIRADO hace " . abs($daysUntilExpiry) . " días");
            } elseif ($daysUntilExpiry < 30) {
                $this->warn("⚠️ Certificado expira en {$daysUntilExpiry} días");
            } else {
                $this->line("✅ Certificado válido, expira en {$daysUntilExpiry} días");
            }
            
            $this->line("📅 Fecha de expiración: {$expiryDate->format('d/m/Y H:i:s')}");
        } else {
            $this->error('❌ No se pudo parsear el certificado');
        }
    }

    /**
     * Eliminar directorio recursivamente
     */
    private function deleteDirectory($dir)
    {
        if (!is_dir($dir)) {
            return false;
        }
        
        $files = array_diff(scandir($dir), ['.', '..']);
        foreach ($files as $file) {
            $path = $dir . DIRECTORY_SEPARATOR . $file;
            is_dir($path) ? $this->deleteDirectory($path) : unlink($path);
        }
        return rmdir($dir);
    }
}