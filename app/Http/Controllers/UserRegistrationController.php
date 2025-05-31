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

class UserRegistrationController extends Controller
{
    public function store(Request $request)
    {
        // Convierte is_default a booleano real para cada dirección
        if ($request->has('addresses') && is_array($request->addresses)) {
            $addresses = $request->addresses;

            foreach ($addresses as &$address) {
                if (isset($address['is_default'])) {
                    $address['is_default'] = filter_var($address['is_default'], FILTER_VALIDATE_BOOLEAN);
                } else {
                    $address['is_default'] = false;
                }
            }

            // Reemplaza el valor en el request para que el validador trabaje con booleanos reales
            $request->merge(['addresses' => $addresses]);
        }

        // Validación
        $validator = Validator::make($request->all(), [
            // Datos de usuario
            'name' => 'required|string|max:255|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:8',
            'role' => 'required|exists:roles,id',
            
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
            return response()->json([
                'status' => 'error',
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            DB::beginTransaction();

            // 1. Crear usuario
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role_id' => $request->role,
                'is_enabled' => 1
            ]);

            // 2. Manejar avatar si existe
            $avatarUrl = null;
            if ($request->hasFile('avatar')) {
                $avatarUrl = $this->uploadAvatar($request->file('avatar'), $user->id);
            }

            // 3. Crear perfil de usuario
            $gender = $request->gender === 'M' ? 'masculino' : ($request->gender === 'F' ? 'femenino' : 'otro');
            
            UserProfile::create([
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

            // 4. Crear direcciones
            foreach ($request->addresses as $addressData) {
                UserAddress::create([
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
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Usuario registrado exitosamente',
                'user' => $user->load(['role', 'profile', 'addresses'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            
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

    public function buscarDocInfo($dni)
    {
        $token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InN5c3RlbWNyYWZ0LnBlQGdtYWlsLmNvbSJ9.yuNS5hRaC0hCwymX_PjXRoSZJWLNNBeOdlLRSUGlHGA';
        
        try {
            // Validar y sanitizar el documento
            $doc = filter_var($dni, FILTER_SANITIZE_STRING);
            
            if (strlen($doc) == 8) {
                $url = 'https://dniruc.apisperu.com/api/v1/dni/' . $doc . '?token=' . $token;
            } else {
                $url = 'https://dniruc.apisperu.com/api/v1/ruc/' . $doc . '?token=' . $token;
            }
        
            $data = $this->apiRequest($url);
            
            if (isset($data['data'])) {
                if (strlen($doc) == 8) {
                    $data["data"]["nombre"] = $data["data"]["nombres"] . " " . $data["data"]["apellidoPaterno"] . " " . $data["data"]["apellidoMaterno"];
                } else {
                    $data["data"]["nombre"] = $data["data"]["razonSocial"];
                }
            }
        
            return response()->json($data);
            
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Error al consultar RENIEC: ' . $e->getMessage()
            ], 500);
        }
    }

    private function apiRequest($url)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if (curl_errno($ch)) {
            curl_close($ch);
            throw new \Exception('Error CURL: ' . curl_error($ch));
        }
        
        curl_close($ch);
        
        if ($httpCode !== 200) {
            throw new \Exception('Error HTTP: ' . $httpCode);
        }
        
        return json_decode($response, true);
    }
}
