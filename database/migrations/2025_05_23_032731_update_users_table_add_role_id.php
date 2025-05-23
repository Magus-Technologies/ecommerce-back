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
            $table->dropColumn('role'); // ❌ Eliminamos columna vieja "role" (string)

            $table->unsignedBigInteger('role_id')->nullable()->after('email'); // ✅ Agregamos columna "role_id"
            $table->foreign('role_id')->references('id')->on('roles')->onDelete('set null'); // ✅ Creamos clave foránea
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
             // Comentamos o eliminamos esta línea porque la foreign key no existe y da error:
            // $table->dropForeign(['role_id']); // ❌ ERROR si no existe foreign key
            
            $table->dropColumn('role_id'); // 🔁 Eliminamos la columna nueva "role_id"
            $table->string('role')->nullable(); 
        });
    }
};
