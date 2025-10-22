<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Models\Comprobante;
use App\Models\ComprobanteDetalle;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;

class CrearBoletaPruebaCommand extends Command
{
    protected $signature = 'boleta:crear-prueba';
    protected $description = 'Crear una boleta de prueba con datos correctos';

    public function handle(): int
    {
        try {
            DB::beginTransaction();

            // 1. Verificar o crear cliente de prueba
            $cliente = Cliente::firstOrCreate(
                ['numero_documento' => '12345678'],
                [
                    'tipo_documento' => '1',
                    'razon_social' => 'CLIENTE DE PRUEBA',
                    'direccion' => 'AV. PRUEBA 123, LIMA',
                    'email' => 'cliente@prueba.com',
                    'telefono' => '999999999',
                    'activo' => true
                ]
            );

            // 2. Verificar o crear producto de prueba
            $categoria = \App\Models\Categoria::first();
            if (!$categoria) {
                $categoria = \App\Models\Categoria::create([
                    'nombre' => 'Categoría de Prueba',
                    'descripcion' => 'Categoría para pruebas',
                    'activo' => true
                ]);
            }
            
            $producto = Producto::firstOrCreate(
                ['codigo_producto' => 'PROD-BOLETA-001'],
                [
                    'nombre' => 'PRODUCTO DE PRUEBA - BOLETA',
                    'descripcion' => 'Producto para pruebas de boletas',
                    'precio_compra' => 50.00,
                    'precio_venta' => 100.00,
                    'stock' => 100,
                    'activo' => true,
                    'categoria_id' => $categoria->id,
                ]
            );

            // 3. Verificar serie de boleta
            $serie = SerieComprobante::where('tipo_comprobante', '03')
                                   ->where('activo', true)
                                   ->first();

            if (!$serie) {
                $this->error('No hay series activas para boletas');
                return self::FAILURE;
            }

            $correlativo = $serie->siguienteCorrelativo();

            // 4. Crear boleta
            $boleta = Comprobante::create([
                'tipo_comprobante' => '03',
                'serie' => $serie->serie,
                'correlativo' => $correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'cliente_id' => $cliente->id,
                'cliente_tipo_documento' => $cliente->tipo_documento,
                'cliente_numero_documento' => $cliente->numero_documento,
                'cliente_razon_social' => $cliente->razon_social,
                'cliente_direccion' => $cliente->direccion,
                'subtotal' => 100.00,
                'igv' => 18.00,
                'total' => 118.00,
                'mto_imp_venta' => 118.00,
                'importe_total' => 118.00,
                'estado' => 'PENDIENTE',
                'user_id' => 1
            ]);

            // 5. Crear detalle
            ComprobanteDetalle::create([
                'comprobante_id' => $boleta->id,
                'item' => 1,
                'producto_id' => $producto->id,
                'codigo_producto' => $producto->codigo_producto,
                'descripcion' => $producto->nombre,
                'unidad_medida' => 'NIU',
                'cantidad' => 1.00,
                'valor_unitario' => 84.75, // Precio sin IGV
                'valor_venta' => 84.75, // Valor de venta sin IGV
                'precio_unitario' => 100.00,
                'precio_total' => 100.00,
                'igv' => 18.00,
                'total' => 118.00,
                'importe_total' => 118.00
            ]);

            DB::commit();

            $this->info("✅ Boleta de prueba creada: {$boleta->numero_completo}");
            $this->line("ID: {$boleta->id}");
            $this->line("Cliente: {$cliente->razon_social}");
            $this->line("Total: S/ {$boleta->total}");
            
            return self::SUCCESS;

        } catch (\Exception $e) {
            DB::rollBack();
            $this->error("Error al crear boleta de prueba: " . $e->getMessage());
            return self::FAILURE;
        }
    }
}
