<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Models\User;
use App\Models\UserCliente;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;
use App\Http\Controllers\UsuariosController;


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

        // Buscar en la tabla user_clientes en lugar de users
        $userCliente = UserCliente::where('email', $googleUser->getEmail())->first();

        if(!$userCliente) {
            // Crear nuevo cliente con datos de Google
            $userCliente = UserCliente::create([
                'nombres' => $googleUser->getName() ?: 'Usuario',
                'apellidos' => 'Google', // Valor por defecto ya que Google no separa apellidos
                'email' => $googleUser->getEmail(),
                'password' => bcrypt(uniqid()), // Password temporal
                'tipo_documento_id' => 1, // DNI por defecto, puedes ajustar según tu lógica
                'numero_documento' => 'GOOGLE_' . time(), // Temporal hasta que complete su perfil
                'estado' => true,
                'foto_url' => $userCliente->foto_url,
            ]);
        }

        // Crear token para el cliente
        $token = $userCliente->createToken('auth_token')->plainTextToken;

        // Preparar datos de respuesta similar al login tradicional
        $userData = [
            'id' => $userCliente->id,
            'nombre_completo' => $userCliente->nombre_completo,
            'email' => $userCliente->email,
            'nombres' => $userCliente->nombres,
            'apellidos' => $userCliente->apellidos,
            'telefono' => $userCliente->telefono,
            'foto' => $userCliente->foto_url,
            'roles' => [],
            'permissions' => []
        ];

        // Redirigir al frontend con el token como parámetro
        $frontendUrl = env('FRONTEND_URL');
        return redirect($frontendUrl . '?token=' . $token . '&user=' . urlencode(json_encode($userData)) . '&tipo_usuario=cliente');

    } catch (Exception $e) {
        return redirect(env('FRONTEND_URL') . '/account?error=google_auth_failed');
    }
});