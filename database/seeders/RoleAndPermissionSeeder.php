<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RoleAndPermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
        {
            $permisos = [
            'ver productos',
            'crear productos',
            'editar productos',
            'eliminar productos',
            'ver usuarios',
            'asignar roles',
        ];

        foreach ($permisos as $permiso) {
            Permission::firstOrCreate(['name' => $permiso]);
        }

        $admin = Role::firstOrCreate(['name' => 'admin']);
        $vendedor = Role::firstOrCreate(['name' => 'vendedor']);

        // Asignar permisos al rol admin
        $admin->syncPermissions($permisos);

        // Solo ver y editar productos para vendedor
        $vendedor->syncPermissions([
            'ver productos',
            'editar productos',
        ]);
    }
}
