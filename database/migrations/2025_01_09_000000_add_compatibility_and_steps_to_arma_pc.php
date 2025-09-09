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
        // 1. Agregar campos adicionales a arma_pc_configuracion para información de pasos
        Schema::table('arma_pc_configuracion', function (Blueprint $table) {
            $table->string('nombre_paso')->default('');
            $table->text('descripcion_paso')->nullable();
            $table->boolean('es_requerido')->default(true);
        });

        // 2. Crear tabla para compatibilidades entre categorías
        Schema::create('categoria_compatibilidades', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('categoria_principal_id');
            $table->unsignedBigInteger('categoria_compatible_id');
            $table->timestamps();

            // Indices y foreign keys
            $table->foreign('categoria_principal_id')->references('id')->on('categorias')->onDelete('cascade');
            $table->foreign('categoria_compatible_id')->references('id')->on('categorias')->onDelete('cascade');
            
            // Una categoría no puede ser compatible consigo misma
            $table->check('categoria_principal_id != categoria_compatible_id');
            
            // Evitar duplicados
            $table->unique(['categoria_principal_id', 'categoria_compatible_id'], 'categoria_compatibilidades_unique');
            
            // Índices para consultas rápidas
            $table->index('categoria_principal_id');
            $table->index('categoria_compatible_id');
        });

        // 3. Actualizar datos existentes con nombres de pasos por defecto
        DB::table('arma_pc_configuracion')->update([
            'nombre_paso' => DB::raw("CONCAT('Paso ', orden)"),
            'descripcion_paso' => 'Selecciona un componente de esta categoría',
            'es_requerido' => true
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Eliminar tabla de compatibilidades
        Schema::dropIfExists('categoria_compatibilidades');
        
        // Eliminar columnas agregadas a arma_pc_configuracion
        Schema::table('arma_pc_configuracion', function (Blueprint $table) {
            $table->dropColumn(['nombre_paso', 'descripcion_paso', 'es_requerido']);
        });
    }
};