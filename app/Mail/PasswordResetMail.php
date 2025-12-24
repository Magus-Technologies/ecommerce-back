<?php

namespace App\Mail;

use App\Models\UserCliente;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class PasswordResetMail extends Mailable
{
    use Queueable, SerializesModels;

    public $user;
    public $resetUrl;
    public $template;

    /**
     * Create a new message instance.
     */
    public function __construct(UserCliente $user, $resetUrl, $template = null)
    {
        $this->user = $user;
        $this->resetUrl = $resetUrl;
        $this->template = $template;
    }

    public function build()
    {
        try {
            $empresaInfo = \App\Models\EmpresaInfo::first();

            // Manejar caso donde no existe empresa_info
            if (!$empresaInfo) {
                $empresaInfo = (object)[
                    'nombre_empresa' => config('app.name', 'Ecommerce Magus'),
                    'logo' => null,
                    'direccion' => '',
                    'telefono' => '',
                    'email' => config('mail.from.address')
                ];
            }

            // Limpiar caracteres UTF-8 problemáticos del nombre de empresa
            $nombreEmpresa = mb_convert_encoding($empresaInfo->nombre_empresa ?? 'Ecommerce Magus', 'UTF-8', 'UTF-8');

            $subject = $this->template && $this->template->subject
                ? $this->template->subject
                : "Recuperación de contraseña - {$nombreEmpresa}";

            return $this->subject($subject)
                        ->view('emails.password-reset-dynamic')
                        ->with([
                            'user' => $this->user,
                            'resetUrl' => $this->resetUrl,
                            'template' => $this->template,
                            'empresaInfo' => $empresaInfo
                        ]);
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('Error en PasswordResetMail::build()', [
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]);

            // Fallback seguro
            return $this->subject('Recuperación de contraseña')
                        ->view('emails.password-reset-dynamic')
                        ->with([
                            'user' => $this->user,
                            'resetUrl' => $this->resetUrl,
                            'template' => $this->template,
                            'empresaInfo' => null
                        ]);
        }
    }
}
