<?php

namespace App\Mail;

use App\Models\UserCliente;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class EmailVerificationMail extends Mailable
{
    use Queueable, SerializesModels;

    public $cliente;
    public $verificationUrl;
    public $verificationCode;

    public $template;

    public function __construct(UserCliente $cliente, $verificationUrl, $verificationCode, $template = null)
    {
        $this->cliente = $cliente;
        $this->verificationUrl = $verificationUrl;
        $this->verificationCode = $verificationCode;
        $this->template = $template;
    }

    // Antes de: return $this->subject($subject)
    // Después de: public function build()
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
                : "Verifica tu cuenta en {$nombreEmpresa}";

            return $this->subject($subject)
                        ->view('emails.email-verification-dynamic')
                        ->with([
                            'user' => $this->cliente,
                            'verificationUrl' => $this->verificationUrl,
                            'verificationCode' => $this->verificationCode,
                            'template' => $this->template,
                            'empresaInfo' => $empresaInfo
                        ]);
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('Error en EmailVerificationMail::build()', [
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]);

            // Fallback seguro
            return $this->subject('Verifica tu cuenta')
                        ->view('emails.email-verification-dynamic')
                        ->with([
                            'user' => $this->cliente,
                            'verificationUrl' => $this->verificationUrl,
                            'verificationCode' => $this->verificationCode,
                            'template' => $this->template,
                            'empresaInfo' => null
                        ]);
        }
    }

}
