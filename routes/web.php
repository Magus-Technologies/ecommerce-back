<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Models\User;
use App\Models\UserCliente;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;
use App\Http\Controllers\UsuariosController;
use Illuminate\Support\Facades\Mail;
use App\Mail\WelcomeEmail;
use App\Http\Controllers\EmailVerificationController;

Route::get('/', function () {
    return view('welcome');
});



// Agrupamos rutas con middleware de autenticación y rol (editado)
Route::middleware(['auth:sanctum', 'role:superadmin,admin'])->group(function () { // <-- agregado grupo middleware
    Route::get('/usuarios', [UsuariosController::class, 'index']); // <-- ruta protegida de usuarios (editado)
});

Route::get('/auth/google', function(){
    return Socialite::driver('google')->redirect();
})->name('google.login');

Route::get('/auth/google/callback', function() {
    try {
        $googleUser = Socialite::driver('google')->user();

        // Buscar en la tabla user_clientes
        $userCliente = UserCliente::where('email', $googleUser->getEmail())->first();

        $isNewUser = false;
        
        if(!$userCliente) {
            // Crear nuevo cliente con datos de Google
            $userCliente = UserCliente::create([
                'nombres' => $googleUser->getName() ?: 'Usuario',
                'apellidos' => 'Google',
                'email' => $googleUser->getEmail(),
                'password' => bcrypt(uniqid()),
                'tipo_documento_id' => 1,
                'numero_documento' => 'GOOGLE_' . time(),
                'estado' => true,
                'email_verified_at' => now(), // Google users are pre-verified
                'is_first_google_login' => true,
                'foto' => null,
            ]);
            
            $isNewUser = true;
        } else {
            // Verificar si es el primer login con Google
            if (!$userCliente->email_verified_at) {
                $userCliente->update([
                    'email_verified_at' => now(),
                    'estado' => true
                ]);
                $isNewUser = true;
            }
        }

        // Enviar correo de bienvenida solo si es nuevo usuario o primer login
        if ($isNewUser) {
            Mail::to($userCliente->email)->send(new WelcomeEmail($userCliente));
        }

        // Crear token para el cliente
        $token = $userCliente->createToken('auth_token')->plainTextToken;

        // Preparar datos de respuesta
        $userData = [
            'id' => $userCliente->id,
            'nombre_completo' => $userCliente->nombre_completo,
            'email' => $userCliente->email,
            'nombres' => $userCliente->nombres,
            'apellidos' => $userCliente->apellidos,
            'telefono' => $userCliente->telefono,
            'foto' => $userCliente->foto_url,
            'roles' => [],
            'permissions' => [],
            'email_verified_at' => $userCliente->email_verified_at
        ];

        // Redirigir al frontend con el token
        $frontendUrl = 'https://magus-ecommerce.com/';
        return redirect($frontendUrl . '?token=' . $token . '&user=' . urlencode(json_encode($userData)) . '&tipo_usuario=cliente');

    } catch (Exception $e) {
        return redirect(env('FRONTEND_URL') . '/account?error=google_auth_failed');
    }
});

Route::get('/verify-email-link', [EmailVerificationController::class, 'verifyByLink']);


