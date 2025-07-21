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

    public function __construct(UserCliente $cliente, $verificationUrl, $verificationCode)
    {
        $this->cliente = $cliente;
        $this->verificationUrl = $verificationUrl;
        $this->verificationCode = $verificationCode; // ← NUEVO PARÁMETRO
    }

    public function build()
    {
        return $this->subject('Verifica tu cuenta en MarketPro')
                    ->view('emails.email-verification')
                    ->with([
                        'user' => $this->cliente, // ← Mantener como estaba
                        'verificationUrl' => $this->verificationUrl,
                        'verificationCode' => $this->verificationCode // ← NUEVO
                    ]);
    }

}
