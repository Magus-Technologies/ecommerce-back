<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserCliente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Mail;
use App\Mail\EmailVerificationMail;
use App\Mail\WelcomeEmail;

class AdminController extends Controller
{
    /**
     * Login unificado para usuarios admin y clientes
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $email = $request->email;
        $password = $request->password;

        // PASO 1: Intentar login como ADMIN primero
        if (Auth::guard('web')->attempt(['email' => $email, 'password' => $password])) {
            $user = Auth::guard('web')->user();
            
            // Verificar que el usuario esté habilitado
            if (!$user->is_enabled) {
                Auth::guard('web')->logout();
                return response()->json([
                    'message' => 'Usuario deshabilitado',
                    'errors' => ['email' => ['Tu cuenta está deshabilitada']]
                ], 401);
            }

            $token = $user->createToken('admin_token')->plainTextToken;

            return response()->json([
                'status' => 'success',
                'message' => 'Login exitoso',
                'tipo_usuario' => 'admin',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'roles' => $user->getRoleNames(),
                    'permissions' => $user->getAllPermissions()->pluck('name'),
                ],
                'token' => $token,
            ]);
        }

        // PASO 2: Si no es admin, intentar login como CLIENTE
        $cliente = UserCliente::where('email', $email)->first();

        if ($cliente && Hash::check($password, $cliente->password)) {
            // Verificar que el cliente esté activo
            if (!$cliente->estado) {
                return response()->json([
                    'message' => 'Cuenta de cliente deshabilitada',
                    'errors' => ['email' => ['Tu cuenta está deshabilitada']]
                ], 401);
            }

            // NUEVO: Verificar si el email está verificado
            if (!$cliente->email_verified_at) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Debes verificar tu correo electrónico antes de iniciar sesión.',
                    'requires_verification' => true
                ], 403);
            }


            $token = $cliente->createToken('cliente_token')->plainTextToken;

            return response()->json([
                'status' => 'success',
                'message' => 'Login exitoso',
                'tipo_usuario' => 'cliente',
                'user' => [
                    'id' => $cliente->id,
                    'nombre_completo' => $cliente->nombre_completo,
                    'nombres' => $cliente->nombres,
                    'apellidos' => $cliente->apellidos,
                    'email' => $cliente->email,
                    'telefono' => $cliente->telefono,
                    'numero_documento' => $cliente->numero_documento,
                    'tipo_documento' => $cliente->tipoDocumento?->nombre,
                    'puede_facturar' => $cliente->puedeFacturar(),
                    'foto_url' => $cliente->foto_url,
                    'email_verified_at' => $cliente->email_verified_at
                ],
                'token' => $token,
            ]);
        }

        // PASO 3: Si no encuentra en ninguna tabla
        return response()->json([
            'message' => 'Las credenciales proporcionadas son incorrectas.',
            'errors' => ['email' => ['Las credenciales proporcionadas son incorrectas.']]
        ], 401);
    }

  public function checkEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $emailExists = UserCliente::where('email', $request->email)->exists() || 
                      User::where('email', $request->email)->exists();

        return response()->json([
            'exists' => $emailExists,
            'message' => $emailExists ? 'Este correo ya está registrado' : 'Correo disponible'
        ]);
    }

    /**
     * Verificar si el número de documento ya existe
     */
    public function checkDocumento(Request $request)
    {
        $request->validate([
            'numero_documento' => 'required|string'
        ]);

        $documentoExists = UserCliente::where('numero_documento', $request->numero_documento)->exists();

        return response()->json([
            'exists' => $documentoExists,
            'message' => $documentoExists ? 'Este número de documento ya está registrado' : 'Documento disponible'
        ]);
    }

    /**
     * Registro de nuevos clientes - FUNCIÓN COMPLETA ACTUALIZADA
     */
        /**
     * Registro de nuevos clientes - FUNCIÓN COMPLETA ACTUALIZADA
     */
    public function register(Request $request)
    {
        // Validaciones con mensajes personalizados
        $request->validate([
            'nombres' => 'required|string|max:255',
            'apellidos' => 'required|string|max:255',
            'email' => 'required|email|unique:user_clientes,email|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
            'telefono' => 'nullable|string|max:20',
            'tipo_documento_id' => 'required|exists:document_types,id',
            'numero_documento' => 'required|string|max:20|unique:user_clientes,numero_documento',
            'fecha_nacimiento' => 'nullable|date|before:today',
            'genero' => 'nullable|in:masculino,femenino,otro',
            
            // Datos de dirección (opcional)
            'direccion_completa' => 'nullable|string',
            'ubigeo' => 'nullable|string|exists:ubigeo_inei,id_ubigeo'
        ], [
            // Mensajes personalizados
            'email.unique' => 'Este correo electrónico ya está registrado.',
            'numero_documento.unique' => 'Este número de documento ya está registrado.',
            'ubigeo.string' => 'El código de ubicación debe ser válido.',
            'ubigeo.exists' => 'La ubicación seleccionada no es válida.',
            'password.confirmed' => 'Las contraseñas no coinciden.',
            'password.min' => 'La contraseña debe tener al menos 8 caracteres.',
            'email.email' => 'Ingresa un correo electrónico válido.',
            'tipo_documento_id.exists' => 'El tipo de documento seleccionado no es válido.',
        ]);

        // Convertir ubigeo a string si viene como número
        $ubigeo = $request->ubigeo ? (string) $request->ubigeo : null;

        try {
            // Generar token de verificación
            $verificationToken = Str::random(60);

            // Crear cliente (INACTIVO hasta verificar email)
            $cliente = UserCliente::create([
                'nombres' => $request->nombres,
                'apellidos' => $request->apellidos,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'telefono' => $request->telefono,
                'tipo_documento_id' => $request->tipo_documento_id,
                'numero_documento' => $request->numero_documento,
                'fecha_nacimiento' => $request->fecha_nacimiento,
                'genero' => $request->genero,
                'estado' => false, // INACTIVO hasta verificar
                'verification_token' => $verificationToken // NUEVO
            ]);

            // Crear dirección si se proporciona
            if ($request->direccion_completa && $ubigeo) {
                $cliente->direcciones()->create([
                    'nombre_destinatario' => $cliente->nombre_completo,
                    'direccion_completa' => $request->direccion_completa,
                    'id_ubigeo' => $ubigeo,
                    'predeterminada' => true,
                    'activa' => true
                ]);
            }

            // Crear URL de verificación
            $verificationUrl = env('FRONTEND_URL', 'http://localhost:4200') . "/verify-email?token={$verificationToken}&email=" . urlencode($cliente->email);

            // Enviar correo de verificación
            Mail::to($cliente->email)->send(new EmailVerificationMail($cliente, $verificationUrl));

            return response()->json([
                'status' => 'success',
                'message' => 'Cliente registrado exitosamente. Revisa tu correo para verificar tu cuenta.',
                'requires_verification' => true,
                'user' => [
                    'id' => $cliente->id,
                    'nombre_completo' => $cliente->nombre_completo,
                    'nombres' => $cliente->nombres,
                    'apellidos' => $cliente->apellidos,
                    'email' => $cliente->email,
                    'telefono' => $cliente->telefono,
                    'numero_documento' => $cliente->numero_documento,
                    'tipo_documento' => $cliente->tipoDocumento?->nombre,
                ],
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al registrar cliente',
                'error' => $e->getMessage()
            ], 500);
        }
    }



    /**
     * Obtener información del usuario autenticado (admin o cliente)
     */
    public function user(Request $request)
    {
        $user = $request->user();

        // Verificar si es un usuario admin o cliente
        if ($user instanceof User) {
            // Usuario admin
            return response()->json([
                'status' => 'success',
                'tipo_usuario' => 'admin',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'roles' => $user->getRoleNames(),
                    'permissions' => $user->getAllPermissions()->pluck('name'),
                ],
            ]);
        } elseif ($user instanceof UserCliente) {
            // Cliente del e-commerce
            return response()->json([
                'status' => 'success',
                'tipo_usuario' => 'cliente',
                'user' => [
                    'id' => $user->id,
                    'nombre_completo' => $user->nombre_completo,
                    'nombres' => $user->nombres,
                    'apellidos' => $user->apellidos,
                    'email' => $user->email,
                    'telefono' => $user->telefono,
                    'numero_documento' => $user->numero_documento,
                    'tipo_documento' => $user->tipoDocumento?->nombre,
                    'puede_facturar' => $user->puedeFacturar(),
                    'foto_url' => $user->foto_url,
                    'email_verified_at' => $user->email_verified_at
                ],
            ]);
        }

        return response()->json(['message' => 'Usuario no válido'], 401);
    }

    /**
     * Logout unificado
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Logout exitoso',
        ]);
    }

    /**
     * Refrescar permisos del usuario autenticado (solo admin)
     */
    public function refreshPermissions(Request $request)
    {
        $user = $request->user();
        
        if (!$user instanceof User) {
            return response()->json(['message' => 'Solo usuarios admin pueden refrescar permisos'], 403);
        }
        
        $user->load('roles.permissions');

        return response()->json([
            'status' => 'success',
            'permissions' => $user->getAllPermissions()->pluck('name')
        ]);
    }
}