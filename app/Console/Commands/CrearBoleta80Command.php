<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Models\Comprobante;
use App\Models\ComprobanteDetalle;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;

class CrearBoleta80Command extends Command
{
    protected $signature = 'boleta:crear-80';
    protected $description = 'Crear boleta número 80 con datos completos';

    public function handle(): int
    {
        try {
            DB::beginTransaction();

            // 1. Verificar o crear cliente de prueba
            $cliente = Cliente::firstOrCreate(
                ['numero_documento' => '87654321'],
                [
                    'tipo_documento' => '1',
                    'razon_social' => 'CLIENTE BOLETA 80',
                    'direccion' => 'AV. BOLETA 80, LIMA',
                    'email' => 'boleta80@prueba.com',
                    'telefono' => '987654321',
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
                ['codigo_producto' => 'PROD-BOLETA-80'],
                [
                    'nombre' => 'PRODUCTO BOLETA 80',
                    'descripcion' => 'Producto especial para boleta 80',
                    'precio_compra' => 80.00,
                    'precio_venta' => 100.00,
                    'stock' => 50,
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

            // 4. Crear boleta con ID específico 80
            $boleta = new Comprobante();
            $boleta->id = 80; // Forzar ID 80
            $boleta->tipo_comprobante = '03';
            $boleta->serie = $serie->serie;
            $boleta->correlativo = $correlativo;
            // numero_completo se genera automáticamente
            $boleta->fecha_emision = now()->format('Y-m-d');
            $boleta->cliente_id = $cliente->id;
            $boleta->cliente_tipo_documento = $cliente->tipo_documento;
            $boleta->cliente_numero_documento = $cliente->numero_documento;
            $boleta->cliente_razon_social = $cliente->razon_social;
            $boleta->cliente_direccion = $cliente->direccion;
            $boleta->moneda = 'PEN';
            $boleta->operacion_gravada = 100.00;
            $boleta->operacion_exonerada = 0.00;
            $boleta->operacion_inafecta = 0.00;
            $boleta->operacion_gratuita = 0.00;
            $boleta->total_igv = 18.00;
            $boleta->total_descuentos = 0.00;
            $boleta->total_otros_cargos = 0.00;
            $boleta->importe_total = 118.00;
            $boleta->observaciones = 'Boleta de prueba número 80';
            $boleta->estado = 'PENDIENTE';
            $boleta->user_id = 1;
            $boleta->save();

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

            $this->info("✅ Boleta 80 creada exitosamente: {$boleta->numero_completo}");
            $this->line("ID: {$boleta->id}");
            $this->line("Cliente: {$cliente->razon_social}");
            $this->line("Total: S/ {$boleta->importe_total}");
            $this->line("Estado: {$boleta->estado}");
            
            return self::SUCCESS;

        } catch (\Exception $e) {
            DB::rollBack();
            $this->error("Error al crear boleta 80: " . $e->getMessage());
            return self::FAILURE;
        }
    }
}
