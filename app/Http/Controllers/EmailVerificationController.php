<?php

namespace App\Http\Controllers;

use App\Models\UserCliente;
use App\Mail\WelcomeEmail;
use App\Mail\EmailVerificationMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Log;

class EmailVerificationController extends Controller
{
    
    public function verify(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string'
        ]);

        $token = trim($request->token);
        $email = $request->email;
        
        // Log para debugging
        Log::info('Verificación solicitada', [
            'email' => $email,
            'token' => $token,
            'token_length' => strlen($token)
        ]);
        
        // Buscar usuario por email primero
        $user = UserCliente::where('email', $email)->first();
        
        if (!$user) {
            Log::error('Usuario no encontrado', ['email' => $email]);
            return response()->json([
                'status' => 'error',
                'message' => 'Usuario no encontrado'
            ], 400);
        }
        
        // Log de los tokens del usuario
        Log::info('Tokens del usuario', [
            'verification_token' => $user->verification_token,
            'verification_code' => $user->verification_code,
            'email_verified_at' => $user->email_verified_at
        ]);
        
        // Verificar si ya está verificado
        if ($user->email_verified_at) {
            return response()->json([
                'status' => 'error',
                'message' => 'La cuenta ya está verificada'
            ], 400);
        }
        
        // Verificar token o código
        $isValid = false;
        
        if (strlen($token) <= 6) {
            // Es un código de verificación (convertir a mayúsculas)
            $tokenUpper = strtoupper($token);
            if ($user->verification_code && $user->verification_code === $tokenUpper) {
                $isValid = true;
                Log::info('Verificación por código exitosa');
            }
        } else {
            // Es un token largo
            if ($user->verification_token && $user->verification_token === $token) {
                $isValid = true;
                Log::info('Verificación por token exitosa');
            }
        }
        
        if (!$isValid) {
            Log::error('Token/código inválido', [
                'token_enviado' => $token,
                'token_bd' => $user->verification_token,
                'codigo_bd' => $user->verification_code
            ]);
            
            return response()->json([
                'status' => 'error',
                'message' => 'Código o token de verificación inválido o expirado'
            ], 400);
        }

        // Verificar la cuenta
        $user->update([
            'email_verified_at' => now(),
            'verification_token' => null,
            'verification_code' => null,
            'estado' => true
        ]);

        Log::info('Cuenta verificada exitosamente', ['user_id' => $user->id]);

        // Enviar correo de bienvenida después de la verificación
        try {
            Log::info('Enviando correo de bienvenida', ['email' => $user->email]);
            Mail::to($user->email)->send(new WelcomeEmail($user));
            Log::info('Correo de bienvenida enviado exitosamente');
        } catch (\Exception $e) {
            Log::error('Error enviando correo de bienvenida: ' . $e->getMessage());
        }


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

        // Generar nuevo token y código
        $verificationToken = Str::random(60);
        $verificationCode = strtoupper(Str::random(6));
        
        $user->update([
            'verification_token' => $verificationToken,
            'verification_code' => $verificationCode
        ]);

        $appUrl = env('APP_URL', 'http://localhost:8000');
        $verificationUrl = rtrim($appUrl, '/') . "/api/verify-email-link?token={$verificationToken}&email=" . urlencode($user->email);

        // Enviar correo
        Mail::to($user->email)->send(new EmailVerificationMail($user, $verificationUrl, $verificationCode));

        return response()->json([
            'status' => 'success',
            'message' => 'Código de verificación reenviado exitosamente'
        ]);
    }

    public function verifyByLink(Request $request)
    {
        $token = $request->query('token');
        $email = $request->query('email');

        Log::info('Verificación por enlace solicitada', [
            'token' => $token,
            'email' => $email
        ]);

        $frontendUrl = env('FRONTEND_URL');
        Log::info('Debug redirect error case', [
            'FRONTEND_URL_raw' => $frontendUrl,
            'redirect_url' => $frontendUrl . '/verify-email?error=invalid_link'
        ]);
        if (!$token || !$email) {
            return redirect(env('FRONTEND_URL') . '/verify-email?error=invalid_link');
        }

        $user = UserCliente::where('email', $email)
                        ->where('verification_token', $token)
                        ->first();

        if (!$user) {
            Log::error('Usuario no encontrado para verificación por enlace');
            return redirect(env('FRONTEND_URL') . '/verify-email?error=invalid_token');
        }

        // Verificar si ya está verificado
        if ($user->email_verified_at) {
            return redirect(env('FRONTEND_URL') . '/account?already_verified=true');
        }

        // Verificar la cuenta
        $user->update([
            'email_verified_at' => now(),
            'verification_token' => null,
            'verification_code' => null,
            'estado' => true
        ]);

        Log::info('Cuenta verificada por enlace exitosamente', ['user_id' => $user->id]);

        // Agrega este debug:
        $frontendUrl = env('FRONTEND_URL');
        Log::info('Debug redirect values', [
            'FRONTEND_URL_raw' => $frontendUrl,
            'FRONTEND_URL_length' => strlen($frontendUrl ?? ''),
            'FRONTEND_URL_empty' => empty($frontendUrl),
            'redirect_url_constructed' => $frontendUrl . '/account?verified=true'
        ]);

        // Enviar correo de bienvenida
        try {
            Mail::to($user->email)->send(new WelcomeEmail($user));
        } catch (\Exception $e) {
            Log::error('Error enviando correo de bienvenida: ' . $e->getMessage());
        }

        // Redirigir al login con mensaje de éxito
        return redirect(env('FRONTEND_URL') . '/account?verified=true');
    }


}
