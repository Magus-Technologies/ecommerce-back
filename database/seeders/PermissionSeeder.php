<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class PermissionSeeder extends Seeder
{
    public function run()
    {
        // Crear permisos
        $permissions = [
            // Usuarios
            'usuarios.ver',
            'usuarios.create',
            'usuarios.edit',
            'usuarios.delete',
            'usuarios.show',

            // Productos
            'productos.ver',
            'productos.create',
            'productos.edit',
            'productos.delete',

            // Categorías
            'categorias.ver',
            'categorias.create',
            'categorias.edit',
            'categorias.delete',

            // Marcas
            'marcas.ver',
            'marcas.create',
            'marcas.edit',
            'marcas.delete',

            // Secciones
            'secciones.ver',
            'secciones.create',
            'secciones.edit',
            'secciones.delete',

            // Banners
            'banners.ver',
            'banners.create',
            'banners.edit',
            'banners.delete',

            // Banners Promocionales
            'banners_promocionales.ver',
            'banners_promocionales.create',
            'banners_promocionales.edit',
            'banners_promocionales.delete',

            // Clientes
            'clientes.ver',
            'clientes.show',
            'clientes.edit',
            'clientes.delete',

            // Pedidos
            'pedidos.ver',
            'pedidos.show',
            'pedidos.edit',
            'pedidos.delete',

            // Ofertas
            'ofertas.ver',
            'ofertas.create',
            'ofertas.edit',
            'ofertas.delete',

            // Cupones
            'cupones.ver',
            'cupones.create',
            'cupones.edit',
            'cupones.delete',
            // horarios
            'horarios.ver',
            'horarios.create',
            'horarios.edit',
            'horarios.delete',

            'empresa_info.ver',
            'empresa_info.edit',


        ];

        foreach ($permissions as $permission) {
            Permission::firstOrCreate([
                'name' => $permission,
                'guard_name' => 'web'
            ]);
        }

        // Crear rol superadmin si no existe
        $superadmin = Role::firstOrCreate([
            'name' => 'superadmin',
            'guard_name' => 'web'
        ]);

        // Asignar todos los permisos al superadmin
        $superadmin->givePermissionTo($permissions);
    }
}
