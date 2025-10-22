<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use App\Models\ComprobanteDetalle;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;
use Illuminate\Support\Facades\DB;

class CrearBoletaProductoRealCommand extends Command
{
    protected $signature = 'boleta:crear-producto-real {producto_id}';
    protected $description = 'Crea una boleta con un producto real del catálogo.';

    public function handle()
    {
        $productoId = $this->argument('producto_id');
        
        DB::beginTransaction();
        try {
            // 1. Verificar que el producto existe
            $producto = Producto::find($productoId);
            if (!$producto) {
                $this->error("Producto con ID {$productoId} no encontrado.");
                return self::FAILURE;
            }

            $this->info("Producto seleccionado: {$producto->nombre}");
            $this->line("Precio: S/ {$producto->precio_venta}");
            $this->line("Stock disponible: {$producto->stock}");

            // 2. Obtener o crear cliente
            $cliente = Cliente::firstOrCreate(
                ['numero_documento' => '12345678'],
                [
                    'tipo_documento' => '1', // DNI
                    'razon_social' => 'Juan Pérez García',
                    'direccion' => 'AV. JAVIER PRADO 123, SAN ISIDRO, LIMA',
                    'email' => 'juan.perez@email.com',
                    'telefono' => '987654321'
                ]
            );

            // 3. Obtener serie para boletas
            $serie = SerieComprobante::where('tipo_comprobante', '03')->first();
            if (!$serie) {
                $this->error("No se encontró una serie activa para boletas (tipo '03').");
                return self::FAILURE;
            }

            $correlativo = $serie->siguienteCorrelativo();

            // 4. Calcular totales
            $precioVenta = (float)$producto->precio_venta;
            $subtotal = $precioVenta / 1.18; // Precio sin IGV
            $igv = $precioVenta - $subtotal;
            $total = $precioVenta;

            // 5. Crear boleta
            $boleta = new Comprobante();
            $boleta->tipo_comprobante = '03';
            $boleta->serie = $serie->serie;
            $boleta->correlativo = $correlativo;
            $boleta->fecha_emision = now()->format('Y-m-d');
            $boleta->cliente_id = $cliente->id;
            $boleta->cliente_tipo_documento = $cliente->tipo_documento;
            $boleta->cliente_numero_documento = $cliente->numero_documento;
            $boleta->cliente_razon_social = $cliente->razon_social;
            $boleta->cliente_direccion = $cliente->direccion;
            $boleta->moneda = 'PEN';
            $boleta->operacion_gravada = round($subtotal, 2);
            $boleta->operacion_exonerada = 0.00;
            $boleta->operacion_inafecta = 0.00;
            $boleta->operacion_gratuita = 0.00;
            $boleta->total_igv = round($igv, 2);
            $boleta->total_descuentos = 0.00;
            $boleta->total_otros_cargos = 0.00;
            $boleta->importe_total = round($total, 2);
            $boleta->observaciones = "Venta de {$producto->nombre}";
            $boleta->estado = 'PENDIENTE';
            $boleta->user_id = 1;
            $boleta->save();

            // 6. Crear detalle
            ComprobanteDetalle::create([
                'comprobante_id' => $boleta->id,
                'item' => 1,
                'producto_id' => $producto->id,
                'codigo_producto' => $producto->codigo_producto,
                'descripcion' => $producto->nombre,
                'unidad_medida' => 'NIU',
                'cantidad' => 1.00,
                'valor_unitario' => round($subtotal, 2),
                'valor_venta' => round($subtotal, 2),
                'precio_unitario' => round($precioVenta, 2),
                'precio_total' => round($precioVenta, 2),
                'igv' => round($igv, 2),
                'total' => round($total, 2),
                'importe_total' => round($total, 2)
            ]);

            DB::commit();

            $this->info("✅ Boleta creada exitosamente: {$boleta->numero_completo}");
            $this->line("ID: {$boleta->id}");
            $this->line("Cliente: {$cliente->razon_social}");
            $this->line("Producto: {$producto->nombre}");
            $this->line("Subtotal: S/ {$boleta->operacion_gravada}");
            $this->line("IGV: S/ {$boleta->total_igv}");
            $this->line("Total: S/ {$boleta->importe_total}");
            $this->line("Estado: {$boleta->estado}");

            return self::SUCCESS;

        } catch (\Exception $e) {
            DB::rollBack();
            $this->error("Error al crear boleta: " . $e->getMessage());
            return self::FAILURE;
        }
    }
}
