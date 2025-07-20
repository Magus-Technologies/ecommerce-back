<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserProfile;
use App\Models\UserAddress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Mail;
use App\Mail\EmailVerificationMail;
use Illuminate\Support\Facades\Log;


class UserRegistrationController extends Controller
{
    public function store(Request $request)
    {
        // LOG: Datos recibidos inicialmente
        Log::info('UserController@store - Iniciando registro de usuario', [
            'request_data' => $request->all(),
            'has_addresses' => $request->has('addresses'),
            'addresses_count' => is_array($request->addresses) ? count($request->addresses) : 0
        ]);

        // Convierte is_default a booleano real para cada dirección
        if ($request->has('addresses') && is_array($request->addresses)) {
            $addresses = $request->addresses;
            
            Log::info('UserController@store - Procesando direcciones', [
                'addresses_before' => $addresses
            ]);

            foreach ($addresses as &$address) {
                if (isset($address['is_default'])) {
                    $originalValue = $address['is_default'];
                    $address['is_default'] = filter_var($address['is_default'], FILTER_VALIDATE_BOOLEAN);
                    Log::debug('UserController@store - Conversión is_default', [
                        'original' => $originalValue,
                        'converted' => $address['is_default']
                    ]);
                } else {
                    $address['is_default'] = false;
                    Log::debug('UserController@store - is_default no existe, establecido a false');
                }
            }

            // Reemplaza el valor en el request para que el validador trabaje con booleanos reales
            $request->merge(['addresses' => $addresses]);
            
            Log::info('UserController@store - Direcciones procesadas', [
                'addresses_after' => $addresses
            ]);
        }

        Log::info('UserController@store - Iniciando validación');

        // Validación
        $validator = Validator::make($request->all(), [
            // Datos de usuario
            'name' => 'required|string|max:255|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:8',
            'role' => 'required|string|exists:roles,name', // ← Ahora valida que el nombre del rol exista
            
            // Datos de perfil
            'first_name' => 'required|string|max:255',
            'apellido_paterno' => 'required|string|max:255',
            'apellido_materno' => 'nullable|string|max:255',
            'phone' => 'required|string|max:20',
            'document_type' => 'required|exists:document_types,id',
            'document_number' => 'required|string|max:20',
            'birth_date' => 'required|date',
            'gender' => 'required|in:M,F',
            
            // Avatar
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            
            // Direcciones
            'addresses' => 'required|array|min:1',
            'addresses.*.label' => 'required|string|max:255',
            'addresses.*.detalle_direccion' => 'required|string|max:255',
            'addresses.*.district' => 'required|string',
            'addresses.*.province' => 'required|string',
            'addresses.*.department' => 'required|string',
            'addresses.*.postal_code' => 'nullable|string|max:255',
            'addresses.*.country' => 'required|string|max:255',
            'addresses.*.is_default' => 'boolean',
        ]);

        if ($validator->fails()) {
            Log::warning('UserController@store - Validación fallida', [
                'errors' => $validator->errors()->toArray()
            ]);
            
            return response()->json([
                'status' => 'error',
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        Log::info('UserController@store - Validación exitosa, iniciando transacción');

        try {
            DB::beginTransaction();
            Log::info('UserController@store - Transacción iniciada');

            // 1. Crear usuario
            Log::info('UserController@store - Creando usuario', [
                'name' => $request->name,
                'email' => $request->email,
                'role' => $request->role
            ]);

            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                // Eliminado: 'role_id' porque ahora usamos Spatie
                'is_enabled' => 1
            ]);

            Log::info('UserController@store - Usuario creado', [
                'user_id' => $user->id,
                'user' => $user->toArray()
            ]);

            // 2. Manejar avatar si existe
            $avatarUrl = null;
            if ($request->hasFile('avatar')) {
                Log::info('UserController@store - Procesando avatar', [
                    'avatar_size' => $request->file('avatar')->getSize(),
                    'avatar_name' => $request->file('avatar')->getClientOriginalName()
                ]);
                
                $avatarUrl = $this->uploadAvatar($request->file('avatar'), $user->id);
                
                Log::info('UserController@store - Avatar procesado', [
                    'avatar_url' => $avatarUrl
                ]);
            } else {
                Log::info('UserController@store - No hay avatar para procesar');
            }

            // 3. Crear perfil de usuario
            $gender = $request->gender === 'M' ? 'masculino' : ($request->gender === 'F' ? 'femenino' : 'otro');
            
            Log::info('UserController@store - Creando perfil de usuario', [
                'user_id' => $user->id,
                'first_name' => $request->first_name,
                'gender_original' => $request->gender,
                'gender_converted' => $gender,
                'document_type' => $request->document_type,
                'document_number' => $request->document_number
            ]);
            
            $profile = UserProfile::create([
                'user_id' => $user->id,
                'first_name' => $request->first_name,
                'last_name_father' => $request->apellido_paterno,
                'last_name_mother' => $request->apellido_materno,
                'phone' => $request->phone,
                'document_type' => $request->document_type,
                'document_number' => $request->document_number,
                'birth_date' => $request->birth_date,
                'genero' => $gender,
                'avatar_url' => $avatarUrl
            ]);

            Log::info('UserController@store - Perfil creado', [
                'profile_id' => $profile->id,
                'profile' => $profile->toArray()
            ]);

            // 4. Asignar rol usando Spatie
            Log::info('UserController@store - Asignando rol', [
                'user_id' => $user->id,
                'role' => $request->role
            ]);
            
            $user->assignRole($request->role); // ← AGREGAR esta línea
            
            Log::info('UserController@store - Rol asignado exitosamente', [
                'user_roles' => $user->roles->pluck('name')->toArray()
            ]);

            // 4. Crear direcciones
            Log::info('UserController@store - Creando direcciones', [
                'addresses_count' => count($request->addresses),
                'addresses_data' => $request->addresses
            ]);

            foreach ($request->addresses as $index => $addressData) {
                Log::debug('UserController@store - Creando dirección', [
                    'index' => $index,
                    'address_data' => $addressData
                ]);

                $address = UserAddress::create([
                    'user_id' => $user->id,
                    'label' => $addressData['label'],
                    'address_line' => $addressData['detalle_direccion'],
                    'city' => $addressData['district'],
                    'province' => $addressData['province'],
                    'department' => $addressData['department'],
                    'postal_code' => $addressData['postal_code'] ?? null,
                    'country' => $addressData['country'],
                    'is_default' => $addressData['is_default'] ?? false
                ]);

                Log::debug('UserController@store - Dirección creada', [
                    'address_id' => $address->id,
                    'address' => $address->toArray()
                ]);
            }

            Log::info('UserController@store - Todas las direcciones creadas exitosamente');

            DB::commit();
            Log::info('UserController@store - Transacción completada exitosamente');

            $userWithRelations = $user->load(['roles', 'profile', 'addresses']);
            Log::info('UserController@store - Usuario final con relaciones', [
                'user_with_relations' => $userWithRelations->toArray()
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Usuario registrado exitosamente',
                'user' => $userWithRelations
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            
            Log::error('UserController@store - Error durante el registro', [
                'error_message' => $e->getMessage(),
                'error_trace' => $e->getTraceAsString(),
                'request_data' => $request->all()
            ]);
            
            return response()->json([
                'status' => 'error',
                'message' => 'Error al registrar usuario: ' . $e->getMessage()
            ], 500);
        }
    }

    public function uploadAvatar($file, $userId)
    {
        try {
            $fileName = 'avatar_' . $userId . '_' . time() . '.' . $file->getClientOriginalExtension();
            
            // Verificar que el directorio existe
            $avatarsPath = storage_path('app/public/avatars');
            error_log('🔍 Verificando directorio: ' . $avatarsPath);
            
            if (!is_dir($avatarsPath)) {
                error_log('📁 Creando directorio: ' . $avatarsPath);
                if (!mkdir($avatarsPath, 0755, true)) {
                    throw new \Exception("No se pudo crear el directorio de avatars");
                }
            }
            
            // Verificar permisos del directorio
            if (!is_writable($avatarsPath)) {
                throw new \Exception("El directorio de avatars no tiene permisos de escritura");
            }
            
            // Intentar guardar el archivo usando move() directamente
            $destinationPath = $avatarsPath . DIRECTORY_SEPARATOR . $fileName;
            error_log('📦 Intentando guardar en: ' . $destinationPath);
            
            if ($file->move($avatarsPath, $fileName)) {
                error_log('✅ Archivo movido correctamente');
                
                // Verificar que el archivo existe
                if (file_exists($destinationPath)) {
                    error_log('✅ Archivo confirmado en disco');
                    return '/storage/avatars/' . $fileName;
                } else {
                    throw new \Exception("El archivo se movió pero no se encuentra en disco");
                }
            } else {
                throw new \Exception("No se pudo mover el archivo");
            }
            
        } catch (\Exception $e) {
            error_log('❌ Error en uploadAvatar: ' . $e->getMessage());
            throw $e;
        }
    }

}
