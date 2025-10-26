<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class ContabilidadPermissionsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Resetear caché de permisos
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        // ============================================
        // PERMISOS DE CONTABILIDAD
        // ============================================

        $permissions = [
            // CAJAS
            'contabilidad.cajas.ver' => 'Ver cajas y reportes de caja',
            'contabilidad.cajas.create' => 'Crear nuevas cajas',
            'contabilidad.cajas.edit' => 'Aperturar, cerrar caja y registrar transacciones',

            // KARDEX
            'contabilidad.kardex.ver' => 'Ver kardex e inventario valorizado',
            'contabilidad.kardex.edit' => 'Hacer ajustes de inventario',

            // CUENTAS POR COBRAR
            'contabilidad.cxc.ver' => 'Ver cuentas por cobrar y antigüedad',
            'contabilidad.cxc.create' => 'Crear cuentas por cobrar',
            'contabilidad.cxc.edit' => 'Registrar pagos de clientes',

            // CUENTAS POR PAGAR
            'contabilidad.cxp.ver' => 'Ver cuentas por pagar y antigüedad',
            'contabilidad.cxp.create' => 'Crear cuentas por pagar',
            'contabilidad.cxp.edit' => 'Registrar pagos a proveedores',

            // PROVEEDORES
            'contabilidad.proveedores.ver' => 'Ver proveedores',
            'contabilidad.proveedores.create' => 'Crear proveedores',
            'contabilidad.proveedores.edit' => 'Editar proveedores',

            // CAJA CHICA
            'contabilidad.caja_chica.ver' => 'Ver caja chica y rendiciones',
            'contabilidad.caja_chica.create' => 'Crear caja chica',
            'contabilidad.caja_chica.edit' => 'Registrar gastos y reposiciones',

            // FLUJO DE CAJA
            'contabilidad.flujo_caja.ver' => 'Ver flujo de caja y proyecciones',
            'contabilidad.flujo_caja.create' => 'Crear proyecciones de flujo',
            'contabilidad.flujo_caja.edit' => 'Registrar montos reales',

            // REPORTES
            'contabilidad.reportes.ver' => 'Ver todos los reportes contables',

            // UTILIDADES
            'contabilidad.utilidades.ver' => 'Ver utilidades y rentabilidad',
            'contabilidad.utilidades.create' => 'Registrar gastos operativos',
            'contabilidad.utilidades.edit' => 'Calcular utilidades mensuales',

            // VOUCHERS
            'contabilidad.vouchers.ver' => 'Ver vouchers/bauchers de pago',
            'contabilidad.vouchers.create' => 'Registrar vouchers',
            'contabilidad.vouchers.edit' => 'Editar y verificar vouchers',
            'contabilidad.vouchers.delete' => 'Eliminar vouchers',
        ];

        // Crear permisos
        foreach ($permissions as $name => $description) {
            Permission::firstOrCreate(
                ['name' => $name],
                ['guard_name' => 'api']
            );
        }

        $this->command->info('✅ Permisos de contabilidad creados correctamente');

        // ============================================
        // ASIGNAR PERMISOS A ROLES
        // ============================================

        // ROL: Administrador - Acceso total
        $adminRole = Role::where('name', 'Administrador')->first();
        if ($adminRole) {
            $adminRole->givePermissionTo(array_keys($permissions));
            $this->command->info('✅ Permisos asignados al rol Administrador');
        }

        // ROL: Gerente - Acceso total a contabilidad
        $gerenteRole = Role::where('name', 'Gerente')->first();
        if ($gerenteRole) {
            $gerenteRole->givePermissionTo(array_keys($permissions));
            $this->command->info('✅ Permisos asignados al rol Gerente');
        }

        // ROL: Contador - Acceso completo a contabilidad
        $contadorRole = Role::firstOrCreate(
            ['name' => 'Contador'],
            ['guard_name' => 'api']
        );
        $contadorRole->givePermissionTo(array_keys($permissions));
        $this->command->info('✅ Permisos asignados al rol Contador');

        // ROL: Cajero - Solo cajas
        $cajeroRole = Role::firstOrCreate(
            ['name' => 'Cajero'],
            ['guard_name' => 'api']
        );
        $cajeroRole->givePermissionTo([
            Permission::findByName('contabilidad.cajas.ver', 'api'),
            Permission::findByName('contabilidad.cajas.edit', 'api'),
        ]);
        $this->command->info('✅ Permisos asignados al rol Cajero');

        // ROL: Vendedor - Ver reportes y CxC
        $vendedorRole = Role::where('name', 'Vendedor')->where('guard_name', 'api')->first();
        if ($vendedorRole) {
            $vendedorRole->givePermissionTo([
                Permission::findByName('contabilidad.cxc.ver', 'api'),
                Permission::findByName('contabilidad.cxc.edit', 'api'),
                Permission::findByName('contabilidad.reportes.ver', 'api'),
            ]);
            $this->command->info('✅ Permisos asignados al rol Vendedor');
        }

        // ROL: Compras - Proveedores y CxP
        $comprasRole = Role::firstOrCreate(
            ['name' => 'Compras'],
            ['guard_name' => 'api']
        );
        $comprasRole->givePermissionTo([
            Permission::findByName('contabilidad.proveedores.ver', 'api'),
            Permission::findByName('contabilidad.proveedores.create', 'api'),
            Permission::findByName('contabilidad.proveedores.edit', 'api'),
            Permission::findByName('contabilidad.cxp.ver', 'api'),
            Permission::findByName('contabilidad.cxp.create', 'api'),
            Permission::findByName('contabilidad.cxp.edit', 'api'),
            Permission::findByName('contabilidad.kardex.ver', 'api'),
        ]);
        $this->command->info('✅ Permisos asignados al rol Compras');

        $this->command->info('');
        $this->command->info('🎉 Seeder de permisos de contabilidad completado');
    }
}
