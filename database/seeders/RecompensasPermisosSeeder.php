<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class RecompensasPermisosSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Crear permisos del módulo de recompensas
        $this->crearPermisos();
        
        // Asignar permisos según el tipo de usuario
        $this->asignarPermisosPorRol();
        
        $this->command->info(' Permisos del módulo de recompensas configurados correctamente');
    }
    
    /**
     * Crear los permisos necesarios para el módulo de recompensas
     */
    private function crearPermisos(): void
    {
        $permisos = [
            [
                'name' => 'recompensas.ver',
                'guard_name' => 'web',
                'description' => 'Ver módulo de recompensas y consultar información'
            ],
            [
                'name' => 'recompensas.create',
                'guard_name' => 'web', 
                'description' => 'Crear nuevas recompensas'
            ],
            [
                'name' => 'recompensas.edit',
                'guard_name' => 'web',
                'description' => 'Editar y configurar recompensas existentes'
            ],
            [
                'name' => 'recompensas.delete',
                'guard_name' => 'web',
                'description' => 'Eliminar o desactivar recompensas'
            ]
        ];
        
        foreach ($permisos as $permiso) {
            Permission::firstOrCreate(
                ['name' => $permiso['name'], 'guard_name' => $permiso['guard_name']],
                ['description' => $permiso['description']]
            );
        }
        
        $this->command->info('📋 Permisos creados: ' . implode(', ', array_column($permisos, 'name')));
    }
    
    /**
     * Asignar permisos según el rol del usuario
     */
    private function asignarPermisosPorRol(): void
    {
        // Configuración de permisos por rol - SOLO SUPERADMIN por ahora
        $configuracionRoles = [
            'superadmin' => [
                'permisos' => ['recompensas.ver', 'recompensas.create', 'recompensas.edit', 'recompensas.delete'],
                'descripcion' => 'Acceso completo al módulo de recompensas'
            ]
            // Temporalmente deshabilitados otros roles
            // 'admin' => [
            //     'permisos' => ['recompensas.ver', 'recompensas.create', 'recompensas.edit'],
            //     'descripcion' => 'Gestión completa excepto eliminación'
            // ],
            // 'vendedor' => [
            //     'permisos' => ['recompensas.ver'],
            //     'descripcion' => 'Solo consulta y visualización'
            // ]
        ];
        
        foreach ($configuracionRoles as $rol => $config) {
            $this->asignarPermisosAUsuarios($rol, $config['permisos'], $config['descripcion']);
        }
        
        // Revocar permisos de recompensas de otros roles
        $this->revocarPermisosOtrosRoles();
    }
    
    /**
     * Asignar permisos a usuarios de un rol específico
     */
    private function asignarPermisosAUsuarios(string $rol, array $permisos, string $descripcion): void
    {
        // Buscar usuarios por diferentes métodos posibles
        $usuarios = collect();
        
        // Método 1: Buscar por campo 'role' si existe
        try {
            $usuariosPorRole = User::where('role', $rol)->get();
            $usuarios = $usuarios->merge($usuariosPorRole);
        } catch (\Exception $e) {
            // Campo 'role' no existe, continuar con otros métodos
        }
        
        // Método 2: Buscar por roles de Spatie si están configurados
        try {
            $usuariosPorSpatie = User::role($rol)->get();
            $usuarios = $usuarios->merge($usuariosPorSpatie);
        } catch (\Exception $e) {
            // Roles de Spatie no configurados, continuar
        }
        
        // Método 3: Buscar por email que contenga el rol (fallback)
        if ($usuarios->isEmpty()) {
            $usuariosPorEmail = User::where('email', 'like', "%{$rol}%")->get();
            $usuarios = $usuarios->merge($usuariosPorEmail);
        }
        
        // Eliminar duplicados
        $usuarios = $usuarios->unique('id');
        
        if ($usuarios->isNotEmpty()) {
            foreach ($usuarios as $usuario) {
                try {
                    // Revocar permisos existentes del módulo de recompensas
                    $permisosRecompensas = Permission::where('name', 'like', 'recompensas.%')->pluck('name');
                    $usuario->revokePermissionTo($permisosRecompensas->toArray());
                    
                    // Asignar nuevos permisos
                    $usuario->givePermissionTo($permisos);
                    
                    $this->command->info(" {$rol}: {$usuario->email} - {$descripcion}");
                    $this->command->info("   Permisos: " . implode(', ', $permisos));
                    
                } catch (\Exception $e) {
                    $this->command->error(" Error asignando permisos a {$usuario->email}: " . $e->getMessage());
                }
            }
        } else {
            $this->command->warn("  No se encontraron usuarios con rol '{$rol}'");
            $this->command->info("   Permisos que se asignarían: " . implode(', ', $permisos));
            $this->command->info("   Descripción: {$descripcion}");
        }
    }
    
    /**
     * Revocar permisos de recompensas de otros roles (admin, vendedor)
     */
    private function revocarPermisosOtrosRoles(): void
    {
        $rolesSinPermisos = ['admin', 'vendedor'];
        $permisosRecompensas = ['recompensas.ver', 'recompensas.create', 'recompensas.edit', 'recompensas.delete'];
        
        foreach ($rolesSinPermisos as $rol) {
            $usuarios = collect();
            
            // Buscar usuarios por diferentes métodos
            try {
                $usuariosPorRole = User::where('role', $rol)->get();
                $usuarios = $usuarios->merge($usuariosPorRole);
            } catch (\Exception $e) {
                // Campo 'role' no existe, continuar
            }
            
            try {
                $usuariosPorSpatie = User::role($rol)->get();
                $usuarios = $usuarios->merge($usuariosPorSpatie);
            } catch (\Exception $e) {
                // Roles de Spatie no configurados
            }
            
            if ($usuarios->isEmpty()) {
                $usuariosPorEmail = User::where('email', 'like', "%{$rol}%")->get();
                $usuarios = $usuarios->merge($usuariosPorEmail);
            }
            
            $usuarios = $usuarios->unique('id');
            
            foreach ($usuarios as $usuario) {
                try {
                    // Revocar todos los permisos de recompensas
                    $usuario->revokePermissionTo($permisosRecompensas);
                    $this->command->info(" 🔒 Permisos de recompensas revocados para {$rol}: {$usuario->email}");
                } catch (\Exception $e) {
                    $this->command->error(" ❌ Error revocando permisos a {$usuario->email}: " . $e->getMessage());
                }
            }
        }
    }
    
    /**
     * Mostrar resumen de la configuración
     */
    public function mostrarResumen(): void
    {
        $this->command->info('\nRESUMEN DE CONFIGURACIÓN DE PERMISOS:');
        $this->command->info('==========================================');
        
        $roles = ['superadmin', 'admin', 'vendedor'];
        
        foreach ($roles as $rol) {
            $usuarios = User::where('role', $rol)
                ->orWhere('email', 'like', "%{$rol}%")
                ->get();
                
            $this->command->info("\n🔹 {$rol}:");
            
            if ($usuarios->isNotEmpty()) {
                foreach ($usuarios as $usuario) {
                    $permisos = $usuario->getPermissionsViaRoles()
                        ->merge($usuario->getDirectPermissions())
                        ->where('name', 'like', 'recompensas.%')
                        ->pluck('name')
                        ->toArray();
                        
                    $this->command->info("   👤 {$usuario->email}");
                    $this->command->info("      Permisos: " . (empty($permisos) ? 'Ninguno' : implode(', ', $permisos)));
                }
            } else {
                $this->command->info("   ⚠️  No hay usuarios con este rol");
            }
        }
        
        $this->command->info('\n FUNCIONALIDADES POR ROL:');
        $this->command->info('============================');
        $this->command->info('SuperAdmin: Dashboard completo + CRUD completo + Configuraciones + Estadísticas');
        $this->command->info('Admin: SIN ACCESO al módulo de recompensas (temporalmente deshabilitado)');
        $this->command->info('Vendedor: SIN ACCESO al módulo de recompensas (temporalmente deshabilitado)');
        $this->command->info('');
        $this->command->info('CONFIGURACIÓN ACTUAL: Solo SUPERADMIN tiene acceso al módulo de recompensas');
    }
}