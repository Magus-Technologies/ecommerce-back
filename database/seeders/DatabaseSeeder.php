<?php

namespace Database\Seeders;

use Spatie\Permission\Models\Permission;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Si la tabla ubigeo_inei está vacía, corre el seeder
        if (\DB::table('ubigeo_inei')->count() === 0) {
            $this->call(UbigeoIneiSeeder::class);
        }

        // Crea un usuario de prueba si no existe
        if (!\App\Models\User::where('email', 'test@example.com')->exists()) {
            \App\Models\User::factory()->create([
                'name' => 'Test User',
                'email' => 'test@example.com',
            ]);
        }

        // Protege el seeder para que solo se ejecute si faltan permisos nuevos
        $permisosNuevos = [
            'usuarios.ver',
            'usuarios.create',
            'usuarios.show',
            'usuarios.edit',
            'usuarios.delete',
            'productos.ver',
            'productos.create',
            'productos.show',
            'productos.edit',
            'productos.delete',
            'categorias.ver',
            'categorias.create',
            'categorias.show',
            'categorias.edit',
            'categorias.delete',
        ];

        $faltanPermisos = collect($permisosNuevos)->filter(function ($permiso) {
            return !Permission::where('name', $permiso)->exists();
        });

        if ($faltanPermisos->isNotEmpty()) {
            $this->call(ActualizarPermisosSeeder::class);
        } else {
            $this->command->warn('🚫 Los permisos estandarizados ya existen. Seeder "ActualizarPermisosSeeder" no se ejecutó.');
        }

        $this->call(EliminarPermisosAntiguosSeeder::class);

    }
}
