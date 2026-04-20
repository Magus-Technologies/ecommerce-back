<?php

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

$userEmail = 'admin@magus.com';

$user = User::where('email', $userEmail)->first();

if (!$user) {
    $user = User::create([
        'name' => 'Administrador Total',
        'email' => $userEmail,
        'password' => Hash::make('password123'),
        'is_enabled' => 1,
    ]);
    echo "Usuario creado exitosamente.\n";
} else {
    echo "EL usuario ya existía, se saltó la creación.\n";
}

// Buscar o crear los roles superadmin para cada guard
$guards = ['web', 'api', 'sanctum'];
$roles = [];

foreach ($guards as $guard) {
    try {
        // Intentar primero con 'superadmin'
        $roleName = 'superadmin';
        $role = Role::where('name', $roleName)->where('guard_name', $guard)->first();

        if (!$role) {
            try {
                $role = Role::create(['name' => $roleName, 'guard_name' => $guard]);
            } catch (\Exception $e) {
                // Si falla por nombre duplicado, usar un nombre específico para el guard
                $roleName = "superadmin-$guard";
                $role = Role::firstOrCreate(['name' => $roleName, 'guard_name' => $guard]);
            }
        }

        $roles[] = $role;

        // Obtener permisos específicos para este guard
        $permissions = Permission::where('guard_name', $guard)->pluck('name')->toArray();
        if (!empty($permissions)) {
            $role->syncPermissions($permissions);
            echo "Permisos sincronizados para el rol '$roleName' en guard '$guard'.\n";
        }
    } catch (\Exception $e) {
        echo "Error procesando guard '$guard': " . $e->getMessage() . "\n";
    }
}

// Asignar los roles al usuario
foreach ($roles as $role) {
    if (!$user->hasRole($role->name, $role->guard_name)) {
        $user->assignRole($role);
        echo "Rol '{$role->name}' (guard: {$role->guard_name}) asignado al usuario.\n";
    } else {
        echo "El usuario ya tenía el rol '{$role->name}' (guard: {$role->guard_name}).\n";
    }
}

echo "\nAdministrador configurado con éxito.\n";
echo "Email: $userEmail\n";
echo "Contraseña: password123\n";

