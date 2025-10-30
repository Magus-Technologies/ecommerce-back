<?php

namespace App\Console\Commands;

use App\Models\Cliente;
use App\Models\Producto;
use App\Models\Venta;
use App\Models\VentaMetodoPago;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class TestPagosMixtos extends Command
{
    protected $signature = 'test:pagos-mixtos';

    protected $description = 'Prueba la funcionalidad de pagos mixtos en ventas';

    public function handle()
    {
        $this->info('=== PRUEBA DE PAGOS MIXTOS ===');
        $this->newLine();

        // 1. Verificar estructura de base de datos
        $this->info('1. Verificando estructura de base de datos...');
        try {
            if (! DB::getSchemaBuilder()->hasTable('venta_metodos_pago')) {
                $this->error('La tabla venta_metodos_pago no existe');

                return 1;
            }
            $this->info('✓ Tabla venta_metodos_pago existe');

            $columns = ['id', 'venta_id', 'metodo', 'monto', 'referencia'];
            foreach ($columns as $column) {
                if (! DB::getSchemaBuilder()->hasColumn('venta_metodos_pago', $column)) {
                    $this->error("Falta la columna: {$column}");

                    return 1;
                }
            }
            $this->info('✓ Todas las columnas necesarias existen');
            $this->newLine();

        } catch (\Exception $e) {
            $this->error('Error: '.$e->getMessage());

            return 1;
        }

        // 2. Obtener un producto de prueba
        $this->info('2. Obteniendo producto de prueba...');
        try {
            $producto = Producto::where('stock', '>', 5)->first();

            if (! $producto) {
                $this->error('No hay productos con stock disponible');

                return 1;
            }

            $this->info("✓ Producto seleccionado: {$producto->nombre} (ID: {$producto->id})");
            $this->info("  Precio: S/ {$producto->precio_venta}");
            $this->info("  Stock: {$producto->stock}");
            $this->newLine();

        } catch (\Exception $e) {
            $this->error('Error: '.$e->getMessage());

            return 1;
        }

        // 3. Crear o buscar cliente de prueba
        $this->info('3. Preparando cliente de prueba...');
        try {
            $cliente = Cliente::firstOrCreate(
                ['numero_documento' => '99999999'],
                [
                    'tipo_documento' => '1',
                    'razon_social' => 'Cliente Prueba Pagos Mixtos',
                    'nombre_comercial' => 'Cliente Prueba',
                    'direccion' => 'Av. Test 123',
                    'email' => 'test@example.com',
                    'activo' => true,
                ]
            );
            $this->info("✓ Cliente: {$cliente->razon_social} (ID: {$cliente->id})");
            $this->newLine();

        } catch (\Exception $e) {
            $this->error('Error: '.$e->getMessage());

            return 1;
        }

        // 4. Crear venta con pago mixto
        $this->info('4. Creando venta con pago mixto...');

        DB::beginTransaction();
        try {
            $cantidad = 2;
            $precioUnitario = $producto->precio_venta;
            $subtotalLinea = round($precioUnitario * $cantidad / 1.18, 2);
            $igvLinea = round($subtotalLinea * 0.18, 2);
            $totalLinea = $subtotalLinea + $igvLinea;

            $total = $totalLinea;
            $mitad = round($total / 2, 2);
            $otraMitad = $total - $mitad;

            $this->info("Total de la venta: S/ {$total}");
            $this->info("Pago 1 (EFECTIVO): S/ {$mitad}");
            $this->info("Pago 2 (TARJETA): S/ {$otraMitad}");
            $this->newLine();

            // Crear venta
            $venta = Venta::create([
                'cliente_id' => $cliente->id,
                'fecha_venta' => now(),
                'subtotal' => $subtotalLinea,
                'igv' => $igvLinea,
                'descuento_total' => 0,
                'total' => $total,
                'estado' => 'PENDIENTE',
                'requiere_factura' => false,
                'metodo_pago' => 'MIXTO',
                'observaciones' => 'Venta de prueba con pagos mixtos',
                'user_id' => 1,
            ]);

            // Crear detalle
            $venta->detalles()->create([
                'producto_id' => $producto->id,
                'codigo_producto' => $producto->codigo ?? 'PROD-'.$producto->id,
                'nombre_producto' => $producto->nombre,
                'descripcion_producto' => $producto->descripcion ?? 'Sin descripción',
                'cantidad' => $cantidad,
                'precio_unitario' => $precioUnitario,
                'precio_sin_igv' => round($precioUnitario / 1.18, 2),
                'descuento_unitario' => 0,
                'subtotal_linea' => $subtotalLinea,
                'igv_linea' => $igvLinea,
                'total_linea' => $totalLinea,
            ]);

            // Crear métodos de pago
            VentaMetodoPago::create([
                'venta_id' => $venta->id,
                'metodo' => 'EFECTIVO',
                'monto' => $mitad,
                'referencia' => null,
            ]);

            VentaMetodoPago::create([
                'venta_id' => $venta->id,
                'metodo' => 'TARJETA',
                'monto' => $otraMitad,
                'referencia' => 'VISA-1234',
            ]);

            DB::commit();

            $this->info('✓ Venta creada exitosamente');
            $this->info("  ID: {$venta->id}");
            $this->info("  Código: {$venta->codigo_venta}");
            $this->info("  Total: S/ {$venta->total}");
            $this->info("  Método de pago: {$venta->metodo_pago}");
            $this->newLine();

        } catch (\Exception $e) {
            DB::rollback();
            $this->error('Error: '.$e->getMessage());

            return 1;
        }

        // 5. Verificar en la base de datos
        $this->info('5. Verificando en la base de datos...');

        $ventaVerificada = Venta::with('metodosPago')->find($venta->id);

        if (! $ventaVerificada) {
            $this->error('No se encontró la venta en la base de datos');

            return 1;
        }

        $this->info('✓ Venta encontrada en BD');
        $this->info("  Métodos de pago en BD: {$ventaVerificada->metodosPago->count()}");

        foreach ($ventaVerificada->metodosPago as $mp) {
            $this->info("    - {$mp->metodo}: S/ {$mp->monto}".
                       ($mp->referencia ? " ({$mp->referencia})" : ''));
        }
        $this->newLine();

        // 6. Probar accessors del modelo
        $this->info('6. Probando accessors del modelo...');
        $this->info('  es_pago_mixto: '.($ventaVerificada->es_pago_mixto ? 'Sí' : 'No'));
        $this->info("  metodo_pago_display: {$ventaVerificada->metodo_pago_display}");
        $this->newLine();

        // 7. Probar pago simple (retrocompatibilidad)
        $this->info('7. Probando pago simple (retrocompatibilidad)...');

        DB::beginTransaction();
        try {
            $ventaSimple = Venta::create([
                'cliente_id' => $cliente->id,
                'fecha_venta' => now(),
                'subtotal' => round($producto->precio_venta / 1.18, 2),
                'igv' => round($producto->precio_venta / 1.18 * 0.18, 2),
                'descuento_total' => 0,
                'total' => $producto->precio_venta,
                'estado' => 'PENDIENTE',
                'requiere_factura' => false,
                'metodo_pago' => 'EFECTIVO',
                'observaciones' => 'Venta de prueba pago simple',
                'user_id' => 1,
            ]);

            $ventaSimple->detalles()->create([
                'producto_id' => $producto->id,
                'codigo_producto' => $producto->codigo ?? 'PROD-'.$producto->id,
                'nombre_producto' => $producto->nombre,
                'descripcion_producto' => $producto->descripcion ?? 'Sin descripción',
                'cantidad' => 1,
                'precio_unitario' => $producto->precio_venta,
                'precio_sin_igv' => round($producto->precio_venta / 1.18, 2),
                'descuento_unitario' => 0,
                'subtotal_linea' => round($producto->precio_venta / 1.18, 2),
                'igv_linea' => round($producto->precio_venta / 1.18 * 0.18, 2),
                'total_linea' => $producto->precio_venta,
            ]);

            DB::commit();

            $this->info('✓ Venta simple creada exitosamente');
            $this->info("  ID: {$ventaSimple->id}");
            $this->info("  Método de pago: {$ventaSimple->metodo_pago}");
            $this->info('  es_pago_mixto: '.($ventaSimple->es_pago_mixto ? 'Sí' : 'No'));
            $this->newLine();

        } catch (\Exception $e) {
            DB::rollback();
            $this->error('Error: '.$e->getMessage());

            return 1;
        }

        // 8. Estadísticas finales
        $this->info('8. Estadísticas finales...');
        $totalVentasMixtas = Venta::where('metodo_pago', 'MIXTO')->count();
        $totalMetodosPago = VentaMetodoPago::count();

        $this->info("  Total ventas con pago mixto: {$totalVentasMixtas}");
        $this->info("  Total registros de métodos de pago: {$totalMetodosPago}");
        $this->newLine();

        $this->info('=== TODAS LAS PRUEBAS COMPLETADAS EXITOSAMENTE ===');
        $this->info('');
        $this->info('IDs de ventas creadas para verificación:');
        $this->info("  - Venta mixta: {$venta->id}");
        $this->info("  - Venta simple: {$ventaSimple->id}");

        return 0;
    }
}
