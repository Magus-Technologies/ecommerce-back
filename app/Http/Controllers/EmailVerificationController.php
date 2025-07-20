<?php

namespace App\Http\Controllers;

use App\Models\UserCliente;
use App\Mail\WelcomeEmail;
use App\Mail\EmailVerificationMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class EmailVerificationController extends Controller
{
    public function verify(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string'
        ]);

        $user = UserCliente::where('email', $request->email)
                          ->where('verification_token', $request->token)
                          ->first();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Token de verificación inválido o expirado'
            ], 400);
        }

        // Verificar la cuenta
        $user->update([
            'email_verified_at' => now(),
            'verification_token' => null,
            'estado' => true
        ]);

        // Enviar correo de bienvenida después de la verificación
        Mail::to($user->email)->send(new WelcomeEmail($user));

        return response()->json([
            'status' => 'success',
            'message' => 'Cuenta verificada exitosamente. ¡Ya puedes iniciar sesión!'
        ]);
    }

    public function resendVerification(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $user = UserCliente::where('email', $request->email)
                          ->whereNull('email_verified_at')
                          ->first();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Usuario no encontrado o ya verificado'
            ], 404);
        }

        // Generar nuevo token
        $verificationToken = Str::random(60);
        $user->update(['verification_token' => $verificationToken]);

        // Crear URL de verificación
        $verificationUrl = env('FRONTEND_URL') . "/verify-email?token={$verificationToken}&email=" . urlencode($user->email);

        // Enviar correo
        Mail::to($user->email)->send(new EmailVerificationMail($user, $verificationUrl));

        return response()->json([
            'status' => 'success',
            'message' => 'Código de verificación reenviado exitosamente'
        ]);
    }

    public function verifyByLink(Request $request)
    {
        $token = $request->query('token');
        $email = $request->query('email');

        if (!$token || !$email) {
            return redirect(env('FRONTEND_URL') . '/verify-email?error=invalid_link');
        }

        $user = UserCliente::where('email', $email)
                          ->where('verification_token', $token)
                          ->first();

        if (!$user) {
            return redirect(env('FRONTEND_URL') . '/verify-email?error=invalid_token');
        }

        // Verificar la cuenta
        $user->update([
            'email_verified_at' => now(),
            'verification_token' => null,
            'estado' => true
        ]);

        // Enviar correo de bienvenida
        Mail::to($user->email)->send(new WelcomeEmail($user));

        return redirect(env('FRONTEND_URL') . '/account?verified=true');
    }
}
