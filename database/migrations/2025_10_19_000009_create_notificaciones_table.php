<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notificaciones', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained('users')->cascadeOnDelete();
            $table->string('email')->nullable();
            $table->string('telefono')->nullable();
            $table->enum('tipo', [
                'VENTA_REALIZADA',
                'PAGO_RECIBIDO',
                'COMPROBANTE_GENERADO',
                'CUENTA_POR_COBRAR',
                'RECORDATORIO_PAGO',
                'VOUCHER_VERIFICADO',
                'PEDIDO_ENVIADO',
                'OTRO',
            ]);
            $table->enum('canal', ['EMAIL', 'WHATSAPP', 'SMS', 'SISTEMA']);
            $table->string('asunto', 255);
            $table->text('mensaje');
            $table->json('datos_adicionales')->nullable();
            $table->enum('estado', ['PENDIENTE', 'ENVIADO', 'FALLIDO'])->default('PENDIENTE');
            $table->timestamp('enviado_at')->nullable();
            $table->text('error')->nullable();
            $table->integer('intentos')->default(0);
            $table->timestamps();

            $table->index(['user_id', 'estado']);
            $table->index(['tipo', 'canal']);
            $table->index('estado');
        });

        Schema::create('plantillas_notificacion', function (Blueprint $table) {
            $table->id();
            $table->string('codigo', 50)->unique();
            $table->string('nombre', 100);
            $table->enum('tipo', [
                'VENTA_REALIZADA',
                'PAGO_RECIBIDO',
                'COMPROBANTE_GENERADO',
                'CUENTA_POR_COBRAR',
                'RECORDATORIO_PAGO',
                'VOUCHER_VERIFICADO',
                'PEDIDO_ENVIADO',
                'OTRO',
            ]);
            $table->enum('canal', ['EMAIL', 'WHATSAPP', 'SMS']);
            $table->string('asunto', 255)->nullable();
            $table->text('contenido');
            $table->json('variables')->nullable(); // Variables disponibles: {nombre}, {monto}, etc
            $table->boolean('activo')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('plantillas_notificacion');
        Schema::dropIfExists('notificaciones');
    }
};
