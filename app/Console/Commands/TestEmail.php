<?php

namespace App\Console\Commands;

use App\Mail\ComprobanteEmail;
use App\Models\Comprobante;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;

class TestEmail extends Command
{
    protected $signature = 'test:email {email} {--comprobante_id=}';
    protected $description = 'Probar envío de email con configuración SMTP';

    public function handle()
    {
        $email = $this->argument('email');
        $comprobanteId = $this->option('comprobante_id');

        $this->info('===========================================');
        $this->info('PRUEBA DE CONFIGURACIÓN DE EMAIL');
        $this->info('===========================================');
        $this->newLine();

        // Mostrar configuración actual
        $this->info('Configuración SMTP:');
        $this->line('  MAIL_MAILER: ' . config('mail.default'));
        $this->line('  MAIL_HOST: ' . config('mail.mailers.smtp.host'));
        $this->line('  MAIL_PORT: ' . config('mail.mailers.smtp.port'));
        $this->line('  MAIL_USERNAME: ' . config('mail.mailers.smtp.username'));
        $this->line('  MAIL_ENCRYPTION: ' . (config('mail.mailers.smtp.encryption') ?? 'none'));
        $this->line('  MAIL_FROM_ADDRESS: ' . config('mail.from.address'));
        $this->line('  MAIL_FROM_NAME: ' . config('mail.from.name'));
        $this->newLine();

        try {
            if ($comprobanteId) {
                // Enviar con comprobante real
                $comprobante = Comprobante::with(['cliente', 'detalles'])->findOrFail($comprobanteId);
                $this->info("Enviando comprobante #{$comprobante->id} ({$comprobante->numero_completo}) a {$email}...");
                
                // Regenerar PDF con QR actualizado antes de enviar
                try {
                    $this->line('  Regenerando PDF con código QR...');
                    $pdfService = app(\App\Services\PdfGeneratorService::class);
                    $pdfService->generarPdfSunat($comprobante->fresh());
                    $comprobante = $comprobante->fresh(); // Recargar con PDF actualizado
                    $this->line('  ✓ PDF regenerado con QR');
                } catch (\Exception $pdfError) {
                    $this->warn('  ⚠ No se pudo regenerar PDF: ' . $pdfError->getMessage());
                    $this->line('  Usando PDF existente...');
                }
                
                Mail::to($email)->send(new ComprobanteEmail($comprobante, 'Email de prueba desde comando artisan'));
            } else {
                // Enviar email de prueba simple
                $this->info("Enviando email de prueba a {$email}...");
                
                Mail::raw('Este es un email de prueba desde Laravel. Si recibes este mensaje, la configuración SMTP está funcionando correctamente.', function ($message) use ($email) {
                    $message->to($email)
                            ->subject('Prueba de Email - Laravel');
                });
            }

            $this->newLine();
            $this->info('✓ Email enviado exitosamente!');
            $this->info('Revisa la bandeja de entrada (y spam) de: ' . $email);
            
            return 0;

        } catch (\Exception $e) {
            $this->newLine();
            $this->error('✗ Error al enviar email:');
            $this->error($e->getMessage());
            $this->newLine();
            
            $this->warn('Posibles causas:');
            $this->line('  1. Credenciales SMTP incorrectas');
            $this->line('  2. Puerto bloqueado por firewall');
            $this->line('  3. Servidor SMTP no permite la conexión');
            $this->line('  4. Necesitas usar "Contraseña de aplicación" (Gmail)');
            $this->line('  5. Configuración SSL/TLS incorrecta');
            
            return 1;
        }
    }
}
