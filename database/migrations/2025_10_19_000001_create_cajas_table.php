<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Tabla de cajas (puntos de venta)
        Schema::create('cajas', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 100);
            $table->string('codigo', 20)->unique();
            $table->foreignId('tienda_id')->nullable()->constrained('tiendas')->nullOnDelete();
            $table->boolean('activo')->default(true);
            $table->timestamps();
        });

        // Tabla de aperturas/cierres de caja
        Schema::create('caja_movimientos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('caja_id')->constrained('cajas')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->enum('tipo', ['APERTURA', 'CIERRE']);
            $table->date('fecha');
            $table->time('hora');
            $table->decimal('monto_inicial', 12, 2)->default(0);
            $table->decimal('monto_final', 12, 2)->nullable();
            $table->decimal('monto_sistema', 12, 2)->nullable();
            $table->decimal('diferencia', 12, 2)->nullable();
            $table->text('observaciones')->nullable();
            $table->enum('estado', ['ABIERTA', 'CERRADA'])->default('ABIERTA');
            $table->timestamps();
            
            $table->index(['caja_id', 'fecha']);
            $table->index('estado');
        });

        // Tabla de transacciones de caja
        Schema::create('caja_transacciones', function (Blueprint $table) {
            $table->id();
            $table->foreignId('caja_movimiento_id')->constrained('caja_movimientos')->cascadeOnDelete();
            $table->enum('tipo', ['INGRESO', 'EGRESO']);
            $table->enum('categoria', ['VENTA', 'COBRO', 'GASTO', 'RETIRO', 'OTRO']);
            $table->decimal('monto', 12, 2);
            $table->string('metodo_pago', 50); // efectivo, tarjeta, transferencia
            $table->string('referencia', 100)->nullable();
            $table->foreignId('venta_id')->nullable()->constrained('ventas')->nullOnDelete();
            $table->foreignId('comprobante_id')->nullable()->constrained('comprobantes')->nullOnDelete();
            $table->text('descripcion')->nullable();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->timestamps();
            
            $table->index(['caja_movimiento_id', 'tipo']);
            $table->index('categoria');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('caja_transacciones');
        Schema::dropIfExists('caja_movimientos');
        Schema::dropIfExists('cajas');
    }
};
