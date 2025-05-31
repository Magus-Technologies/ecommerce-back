<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Role;  

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. Eliminar roles duplicados que tengan nombre 'admin' o 'usuarios'
        Role::whereIn('nombre', ['admin', 'usuarios'])->delete();

        // 2. Actualizar rol con id 1 a 'admin' (si existe)
        $rol1 = Role::find(1);
        if ($rol1) {
            $rol1->nombre = 'admin';
            $rol1->save();
        }

        // 3. Actualizar rol con id 2 a 'usuarios' (si existe)
        $rol2 = Role::find(2);
        if ($rol2) {
            $rol2->nombre = 'usuarios';
            $rol2->save();
        }

        // 4. Eliminar roles con id 3 y 4 si existen
        Role::whereIn('id', [3, 4])->delete();
    }
}
