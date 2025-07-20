<?php

namespace App\Mail;

use App\Models\User;
use App\Models\UserCliente;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class WelcomeEmail extends Mailable
{
    use Queueable, SerializesModels;

    public $user;
    public $userType;
    
    /**
     * Create a new message instance.
     */
    public function __construct()
    {
        $this->user = $user;
        // Determinar el tipo de usuario basado en el modelo
        $this->userType = $user instanceof UserCliente ? 'cliente' : 'admin';

    }

    public function build()
    {
        return $this->subject('¡Bienvenido a MarketPro - Tu tienda especializada en tecnología!')
                    ->view('emails.welcome')
                    ->with([
                        'user' => $this->user,
                        'userType' => $this->userType
                    ]);
    }

}
