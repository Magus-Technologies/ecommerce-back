<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\DB;
use App\Services\GuiaRemisionService;
use App\Models\GuiaRemision;
use App\Models\GuiaRemisionDetalle;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;

class GuiaRemisionGenerarPruebaCommand extends Command
{
    protected $signature = 'guia:generar-prueba';
    protected $description = 'Genera y envía a SUNAT BETA una guía de remisión de prueba';

    public function handle(): int
    {
        try {
            DB::beginTransaction();

            // 1. Verificar o crear cliente de prueba
            $cliente = Cliente::firstOrCreate(
                ['numero_documento' => '20000000001'],
                [
                    'tipo_documento' => '6',
                    'razon_social' => 'EMPRESA DE PRUEBAS S.A.C.',
                    'direccion' => 'AV. FICTICIA 123, LIMA',
                    'email' => 'pruebas@ejemplo.com',
                    'telefono' => '999999999',
                    'activo' => true
                ]
            );

            // 2. Verificar o crear producto de prueba
            $categoria = \App\Models\Categoria::first();
            if (!$categoria) {
                $categoria = \App\Models\Categoria::create([
                    'nombre' => 'Categoría de Prueba',
                    'descripcion' => 'Categoría para pruebas de guías',
                    'activo' => true
                ]);
            }
            
            $producto = Producto::firstOrCreate(
                ['codigo_producto' => 'PROD-GUIA-001'],
                [
                    'nombre' => 'PRODUCTO DE PRUEBA - GUÍA',
                    'descripcion' => 'Producto para pruebas de guías de remisión',
                    'precio_compra' => 50.00,
                    'precio_venta' => 100.00,
                    'stock' => 50,
                    'activo' => true,
                    'categoria_id' => $categoria->id,
                ]
            );

            // 3. Verificar o crear serie de guía de remisión
            $serie = SerieComprobante::firstOrCreate(
                [
                    'tipo_comprobante' => '09',
                    'serie' => 'T001'
                ],
                [
                    'correlativo' => 1,
                    'activo' => true,
                    'descripcion' => 'Serie por defecto Guía de Remisión'
                ]
            );

            $correlativo = $serie->siguienteCorrelativo();

            // 4. Crear guía de remisión
            $guia = GuiaRemision::create([
                'tipo_comprobante' => '09',
                'serie' => $serie->serie,
                'correlativo' => $correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'fecha_inicio_traslado' => now()->format('Y-m-d'),
                'cliente_id' => $cliente->id,
                'cliente_tipo_documento' => $cliente->tipo_documento,
                'cliente_numero_documento' => $cliente->numero_documento,
                'cliente_razon_social' => $cliente->razon_social,
                'cliente_direccion' => $cliente->direccion,
                'destinatario_tipo_documento' => '1',
                'destinatario_numero_documento' => '12345678',
                'destinatario_razon_social' => 'DESTINATARIO DE PRUEBA',
                'destinatario_direccion' => 'AV. DESTINO 456, LIMA',
                'destinatario_ubigeo' => '150101',
                'motivo_traslado' => '01',
                'modalidad_traslado' => '01',
                'peso_total' => 10.00,
                'numero_bultos' => 1,
                'modo_transporte' => '01',
                'numero_placa' => 'ABC-123',
                'conductor_dni' => '87654321',
                'conductor_nombres' => 'CONDUCTOR DE PRUEBA',
                'punto_partida_ubigeo' => '150101',
                'punto_partida_direccion' => 'AV. ORIGEN 123, LIMA',
                'punto_llegada_ubigeo' => '150101',
                'punto_llegada_direccion' => 'AV. DESTINO 456, LIMA',
                'observaciones' => 'Guía de remisión de prueba',
                'estado' => 'PENDIENTE',
                'user_id' => 1
            ]);

            // 5. Crear detalle de la guía
            GuiaRemisionDetalle::create([
                'guia_remision_id' => $guia->id,
                'item' => 1,
                'producto_id' => $producto->id,
                'codigo_producto' => $producto->codigo_producto,
                'descripcion' => $producto->nombre,
                'unidad_medida' => 'KGM',
                'cantidad' => 5.00,
                'peso_unitario' => 2.00,
                'peso_total' => 10.00,
                'observaciones' => 'Producto de prueba para guía'
            ]);

            DB::commit();

            $this->info('Guía de remisión de prueba creada: ' . $guia->numero_completo);

            // 6. Enviar a SUNAT BETA
            /** @var GuiaRemisionService $service */
            $service = App::make(GuiaRemisionService::class);
            $result = $service->enviarGuiaRemision($guia);

            if ($result['success']) {
                $guia->refresh();
                $this->info('¡Guía de remisión enviada a SUNAT BETA exitosamente!');
                $this->line('ID: ' . $guia->id);
                $this->line('Número: ' . $guia->numero_completo);
                $this->line('Estado: ' . $guia->estado);
                if ($guia->mensaje_sunat) {
                    $this->line('SUNAT: ' . $guia->mensaje_sunat);
                }
                return self::SUCCESS;
            } else {
                $this->error('Guía creada pero hubo error al enviar a SUNAT');
                $this->line('Error: ' . ($result['error'] ?? 'Desconocido'));
                return self::FAILURE;
            }

        } catch (\Exception $e) {
            DB::rollBack();
            $this->error('Error al generar guía de remisión de prueba: ' . $e->getMessage());
            return self::FAILURE;
        }
    }
}
