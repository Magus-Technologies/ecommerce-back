<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;


return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {

        // Insertar los roles si no existen aún
        DB::table('roles')->insertOrIgnore([
            ['nombre' => 'superadmin'],
            ['nombre' => 'admin'],
            ['nombre' => 'soporte'],
            ['nombre' => 'cliente'],
        ]);

        // Obtener el ID del rol 'superadmin'
        $superadminId = DB::table('roles')->where('nombre', 'superadmin')->value('id');

        // Asignar ese rol al usuario con ID 1 (puedes cambiar este ID si necesitas otro)
        DB::table('users')->where('id', 1)->update(['role_id' => $superadminId]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Restaurar columna 'role' con texto si quieres revertir
        // o simplemente limpiar role_id
        DB::table('users')->update(['role_id' => null]);

        // (Opcional) eliminar los roles insertados
        DB::table('roles')->whereIn('nombre', [
            'superadmin', 'admin', 'soporte', 'cliente'
        ])->delete();
    }
};
