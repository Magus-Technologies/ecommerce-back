<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Primero borrar el índice normal, no la FK porque no existe
            $table->dropIndex('users_role_id_foreign');

            // Luego borrar la columna
            $table->dropColumn('role_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->bigInteger('role_id')->unsigned()->nullable();

            // Si quieres recrear el índice también
            $table->index('role_id', 'users_role_id_foreign');
        });
    }
};
