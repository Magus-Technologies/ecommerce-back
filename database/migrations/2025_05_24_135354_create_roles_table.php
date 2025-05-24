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
        Schema::create('roles', function (Blueprint $table) {
            $table->id(); // equivale a bigint(20) unsigned AUTO_INCREMENT PRIMARY KEY
            $table->string('nombre')->unique(); // varchar(255) + UNIQUE KEY
            $table->timestamps(); // created_at y updated_at como timestamps NULL DEFAULT NULL
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('roles');
    }
};
