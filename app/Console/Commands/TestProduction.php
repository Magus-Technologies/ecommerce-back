<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\GreenterService;
use App\Models\Comprobante;
use App\Models\Cliente;
use App\Models\SerieComprobante;

class TestProduction extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'facturacion:test-produccion 
                            {--force : Forzar prueba sin confirmación}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Probar facturación electrónica en ambiente de producción SUNAT';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('🧪 PRUEBA DE FACTURACIÓN EN PRODUCCIÓN SUNAT');
        $this->info('============================================');
        $this->newLine();

        // Verificar ambiente
        $ambiente = config('services.greenter.ambiente');
        if ($ambiente !== 'produccion') {
            $this->error('❌ No estás en ambiente de producción!');
            $this->line('Ambiente actual: ' . $ambiente);
            $this->line('Para cambiar a producción: php artisan facturacion:switch-production');
            return 1;
        }

        $this->info("✅ Ambiente: {$ambiente}");
        $this->info("✅ RUC: " . config('services.company.ruc'));
        $this->info("✅ Usuario SOL: " . config('services.greenter.fe_user'));
        $this->newLine();

        // Confirmación de seguridad
        if (!$this->option('force')) {
            $this->warn('⚠️  ADVERTENCIA: Esta es una prueba REAL en SUNAT PRODUCCIÓN');
            $this->warn('⚠️  Se generará una factura REAL que será enviada a SUNAT');
            $this->newLine();
            
            if (!$this->confirm('¿Estás seguro de continuar?')) {
                $this->info('❌ Prueba cancelada por el usuario');
                return 0;
            }
        }

        try {
            // Crear cliente de prueba
            $this->info('👤 Creando cliente de prueba...');
            $cliente = Cliente::firstOrCreate(
                ['numero_documento' => '12345678901'],
                [
                    'tipo_documento' => '6', // RUC
                    'razon_social' => 'EMPRESA DE PRUEBA SAC',
                    'direccion' => 'AV. PRUEBA 123, LIMA',
                    'email' => 'prueba@empresa.com',
                    'telefono' => '987654321'
                ]
            );
            $this->line("✅ Cliente: {$cliente->razon_social}");

            // Obtener serie
            $serie = SerieComprobante::where('tipo_comprobante', '01')
                ->where('activo', true)
                ->first();
            
            if (!$serie) {
                $this->error('❌ No hay series de factura configuradas');
                return 1;
            }

            // Actualizar correlativo
            $serie->correlativo += 1;
            $serie->save();
            $correlativo = str_pad($serie->correlativo, 6, '0', STR_PAD_LEFT);

            // Crear comprobante de prueba
            $this->info('📄 Creando comprobante de prueba...');
            $comprobante = Comprobante::create([
                'cliente_id' => $cliente->id,
                'user_id' => 1,
                'tipo_comprobante' => '01', // Factura
                'serie' => $serie->serie,
                'correlativo' => $correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'cliente_tipo_documento' => $cliente->tipo_documento,
                'cliente_numero_documento' => $cliente->numero_documento,
                'cliente_razon_social' => $cliente->razon_social,
                'cliente_direccion' => $cliente->direccion,
                'moneda' => 'PEN',
                'operacion_gravada' => 100.00,
                'operacion_exonerada' => 0.00,
                'operacion_inafecta' => 0.00,
                'total_igv' => 18.00,
                'total_descuentos' => 0.00,
                'importe_total' => 118.00,
                'estado' => 'PENDIENTE',
                'origen' => 'PRUEBA_PRODUCCION',
                'metodo_pago' => 'Efectivo',
                'referencia_pago' => 'TEST-PROD-' . time()
            ]);

            $this->line("✅ Comprobante: {$comprobante->serie}-{$comprobante->correlativo}");

            // Crear detalle
            $this->info('📋 Creando detalle del comprobante...');
            $comprobante->detalles()->create([
                'item' => 1,
                'producto_id' => 1,
                'codigo_producto' => 'PROD001',
                'descripcion' => 'PRODUCTO DE PRUEBA - PRODUCCIÓN',
                'unidad_medida' => 'NIU',
                'cantidad' => 1,
                'valor_unitario' => 84.75,
                'precio_unitario' => 100.00,
                'valor_venta' => 84.75,
                'igv' => 15.25,
                'total' => 100.00,
                'porcentaje_igv' => 18.00,
                'tipo_afectacion_igv' => '10'
            ]);

            // Enviar a SUNAT
            $this->info('🚀 Enviando a SUNAT PRODUCCIÓN...');
            $this->warn('⏳ Esto puede tomar varios segundos...');
            
            $greenterService = new GreenterService();
            $resultado = $greenterService->generarFactura($comprobante->id, null, 1, '127.0.0.1');

            $this->newLine();
            $this->info('📊 RESULTADO DE LA PRUEBA:');
            $this->info('==========================');
            
            // Recargar comprobante
            $comprobante->refresh();
            
            $this->line("📄 Comprobante: {$comprobante->serie}-{$comprobante->correlativo}");
            $this->line("📅 Fecha: {$comprobante->fecha_emision}");
            $this->line("💰 Total: S/ {$comprobante->importe_total}");
            $this->line("📊 Estado: {$comprobante->estado}");
            
            if ($comprobante->estado === 'ACEPTADO') {
                $this->info('✅ ¡FACTURA ACEPTADA POR SUNAT!');
                $this->line("🎫 Ticket: {$comprobante->numero_ticket}");
                $this->line("🔐 Hash: " . substr($comprobante->hash_firma, 0, 20) . '...');
            } elseif ($comprobante->estado === 'RECHAZADO') {
                $this->error('❌ FACTURA RECHAZADA POR SUNAT');
                $this->line("📝 Errores: {$comprobante->errores_sunat}");
            } else {
                $this->warn("⚠️ Estado: {$comprobante->estado}");
            }

            $this->newLine();
            $this->info('🎉 PRUEBA DE PRODUCCIÓN COMPLETADA');
            $this->line('Revisa los logs para más detalles: storage/logs/laravel.log');

        } catch (\Exception $e) {
            $this->error('❌ ERROR EN LA PRUEBA:');
            $this->error($e->getMessage());
            $this->line('Archivo: ' . $e->getFile());
            $this->line('Línea: ' . $e->getLine());
            return 1;
        }

        return 0;
    }
}