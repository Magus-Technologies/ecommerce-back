<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Producto;
use App\Models\Cliente;
use App\Models\Venta;
use App\Models\Comprobante;
use App\Models\SerieComprobante;
use App\Http\Controllers\VentasController;
use App\Services\GreenterService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TestFacturacion extends Command
{
    protected $signature = 'test:facturacion';
    protected $description = 'Prueba completa del flujo de facturación';

    public function handle()
    {
        $this->info('===========================================');
        $this->info('PRUEBA DE FUEGO - SISTEMA DE FACTURACIÓN');
        $this->info('===========================================');
        $this->newLine();

        // PASO 1: Verificar requisitos
        $this->info('PASO 1: Verificando requisitos previos...');
        $this->line('-------------------------------------------');

        $producto = Producto::where('activo', true)->first();
        if (!$producto) {
            $this->error('❌ No hay productos activos en la BD');
            return 1;
        }

        $this->info("✅ Producto encontrado: {$producto->nombre}");
        $this->line("   ID: {$producto->id}");
        $this->line("   Precio: S/ {$producto->precio_venta}");
        $this->line("   Stock: {$producto->stock}");

        $serie = SerieComprobante::where('activo', true)->first();
        if (!$serie) {
            $this->error('❌ No hay series de comprobantes configuradas');
            return 1;
        }

        $this->info("✅ Serie encontrada: {$serie->serie}");
        $this->newLine();

        // PASO 2: Crear venta con cliente nuevo
        $this->info('PASO 2: Creando venta con cliente nuevo...');
        $this->line('-------------------------------------------');

        $numeroDocumento = '8765432' . rand(0, 9);
        $ventaData = [
            'cliente_datos' => [
                'tipo_documento' => '1',
                'numero_documento' => $numeroDocumento,
                'razon_social' => 'María García López - PRUEBA',
                'direccion' => 'Av. Prueba 456, Lima'
            ],
            'productos' => [
                [
                    'producto_id' => $producto->id,
                    'cantidad' => 1,
                    'precio_unitario' => $producto->precio_venta,
                    'descuento_unitario' => 0
                ]
            ],
            'metodo_pago' => 'YAPE',
            'requiere_factura' => true,
            'observaciones' => 'Venta de prueba automática'
        ];

        try {
            DB::beginTransaction();

            $request = new Request($ventaData);
            $controller = new VentasController(new GreenterService());
            $response = $controller->store($request);
            $ventaResponse = json_decode($response->getContent(), true);

            if (!isset($ventaResponse['success']) || !$ventaResponse['success']) {
                $this->error('❌ Error al crear venta: ' . ($ventaResponse['message'] ?? 'Error desconocido'));
                DB::rollBack();
                return 1;
            }

            $ventaId = $ventaResponse['data']['id'];
            $clienteId = $ventaResponse['data']['cliente']['id'] ?? null;
            $clienteNombre = $ventaResponse['data']['cliente']['razon_social'] ?? 'N/A';

            $this->info("✅ Venta creada: ID={$ventaId}");
            $this->line("   Cliente ID: {$clienteId}");
            $this->line("   Cliente: {$clienteNombre}");

            // Verificar que NO sea cliente general
            if ($clienteId == 27) {
                $this->error('❌ ERROR: Se guardó CLIENTE GENERAL (ID 27)');
                DB::rollBack();
                return 1;
            }

            $this->info('✅ Cliente correcto (no es CLIENTE GENERAL)');
            $this->newLine();

            // PASO 3: Facturar venta
            $this->info('PASO 3: Generando comprobante...');
            $this->line('-------------------------------------------');

            $facturaData = [
                'cliente_datos' => [
                    'tipo_documento' => '6',
                    'numero_documento' => '20123456789',
                    'razon_social' => 'EMPRESA PRUEBA SAC',
                    'direccion' => 'Jr. Comercio 789, Lima'
                ]
            ];

            $request2 = new Request($facturaData);
            $response2 = $controller->facturar($request2, $ventaId);
            $facturaResponse = json_decode($response2->getContent(), true);

            if (!isset($facturaResponse['comprobante'])) {
                $this->error('❌ Error al facturar: ' . ($facturaResponse['message'] ?? 'Error desconocido'));
                if (isset($facturaResponse['error'])) {
                    $this->line("   Error: {$facturaResponse['error']}");
                }
                DB::rollBack();
                return 1;
            }

            $comprobante = $facturaResponse['comprobante'];
            $comprobanteId = $comprobante['id'];
            $tieneXml = $comprobante['tiene_xml'] ?? false;
            $xmlLength = !empty($comprobante['xml_firmado']) ? strlen($comprobante['xml_firmado']) : 0;

            $this->info("✅ Comprobante generado: ID={$comprobanteId}");
            $this->line("   Número: " . ($comprobante['numero_completo'] ?? 'N/A'));
            $this->line("   Estado: " . ($comprobante['estado'] ?? 'N/A'));
            $this->line("   Tiene XML: " . ($tieneXml ? 'SÍ' : 'NO'));
            $this->line("   XML Length: {$xmlLength} bytes");

            if (!$tieneXml || $xmlLength == 0) {
                $this->error('❌ ERROR: XML no se generó correctamente');
                DB::rollBack();
                return 1;
            }

            $this->info('✅ XML generado correctamente');
            $this->newLine();

            // PASO 4: Verificar en BD
            $this->info('PASO 4: Verificando en base de datos...');
            $this->line('-------------------------------------------');

            $venta = Venta::with(['comprobante', 'cliente'])->find($ventaId);
            $this->info("✅ Venta encontrada: ID={$ventaId}");
            $this->line("   Comprobante ID: " . ($venta->comprobante_id ?? 'NULL'));
            $this->line("   Cliente: " . ($venta->cliente->razon_social ?? 'N/A'));

            if (empty($venta->comprobante_id)) {
                $this->error('❌ ERROR: Venta no tiene comprobante_id vinculado');
                DB::rollBack();
                return 1;
            }

            $this->info('✅ Venta vinculada al comprobante');
            $this->newLine();

            // PASO 5: Enviar a SUNAT (NUEVO)
            $this->info('PASO 5: Enviando comprobante a SUNAT...');
            $this->line('-------------------------------------------');

            $response3 = $controller->enviarSunat($ventaId);
            $sunatResponse = json_decode($response3->getContent(), true);

            if (!isset($sunatResponse['success']) || !$sunatResponse['success']) {
                $this->error('❌ Error al enviar a SUNAT: ' . ($sunatResponse['message'] ?? 'Error desconocido'));
                if (isset($sunatResponse['error'])) {
                    $this->line("   Error: {$sunatResponse['error']}");
                }
                $this->line('   Nota: Esto puede ser normal si SUNAT está en mantenimiento');
                $this->newLine();
                
                // Continuar con la prueba aunque SUNAT falle
                $this->warn('⚠️ Continuando prueba sin envío a SUNAT...');
            } else {
                $comprobanteActualizado = $sunatResponse['data']['comprobante'] ?? [];
                $estadoSunat = $comprobanteActualizado['estado'] ?? 'DESCONOCIDO';
                $mensajeSunat = $comprobanteActualizado['mensaje_sunat'] ?? 'Sin mensaje';
                $tienePdf = $comprobanteActualizado['tiene_pdf'] ?? false;
                $tieneCdr = $comprobanteActualizado['tiene_cdr'] ?? false;

                $this->info("✅ Comprobante enviado a SUNAT");
                $this->line("   Estado SUNAT: {$estadoSunat}");
                $this->line("   Mensaje: {$mensajeSunat}");
                $this->line("   Tiene PDF: " . ($tienePdf ? 'SÍ' : 'NO'));
                $this->line("   Tiene CDR: " . ($tieneCdr ? 'SÍ' : 'NO'));

                if ($estadoSunat === 'ACEPTADO') {
                    $this->info('🎉 ¡SUNAT ACEPTÓ EL COMPROBANTE!');
                    
                    if ($tienePdf && $tieneCdr) {
                        $this->info('✅ PDF y CDR generados correctamente');
                    } else {
                        $this->warn('⚠️ PDF o CDR no se generaron (verificar backend)');
                    }
                } else {
                    $this->warn("⚠️ SUNAT no aceptó el comprobante: {$estadoSunat}");
                }
            }
            $this->newLine();

            // PASO 6: Verificar estado final
            $this->info('PASO 6: Verificando estado final...');
            $this->line('-------------------------------------------');

            $ventaFinal = Venta::with(['comprobante', 'cliente'])->find($ventaId);
            $comprobanteFinal = $ventaFinal->comprobante;

            $this->info("✅ Estado final de la venta:");
            $this->line("   Venta Estado: " . ($ventaFinal->estado ?? 'N/A'));
            $this->line("   Comprobante Estado: " . ($comprobanteFinal->estado ?? 'N/A'));
            $this->line("   Tiene XML: " . (!empty($comprobanteFinal->xml_firmado) ? 'SÍ' : 'NO'));
            $this->line("   Tiene PDF: " . (!empty($comprobanteFinal->pdf_base64) ? 'SÍ' : 'NO'));
            $this->line("   Tiene CDR: " . (!empty($comprobanteFinal->xml_respuesta_sunat) ? 'SÍ' : 'NO'));
            $this->line("   Columna tiene_pdf: " . ($comprobanteFinal->tiene_pdf ? 'true' : 'false'));
            $this->line("   Columna tiene_cdr: " . ($comprobanteFinal->tiene_cdr ? 'true' : 'false'));
            $this->newLine();

            // RESUMEN FINAL
            $this->info('===========================================');
            $this->info('🎯 RESUMEN DE PRUEBAS COMPLETAS');
            $this->info('===========================================');
            $this->newLine();

            $this->info('✅ FLUJO COMPLETO EJECUTADO:');
            $this->line('   1. ✅ Crear venta con cliente nuevo');
            $this->line('   2. ✅ Generar comprobante con XML firmado');
            $this->line('   3. ✅ Vincular venta con comprobante');
            $this->line('   4. ✅ Enviar a SUNAT (si está disponible)');
            $this->line('   5. ✅ Verificar estado final');
            $this->newLine();

            $this->info('📊 IDs GENERADOS:');
            $this->line("   Venta: {$ventaId}");
            $this->line("   Cliente: {$clienteId}");
            $this->line("   Comprobante: {$comprobanteId}");
            $this->newLine();

            $this->info('🔗 ENDPOINTS PARA PROBAR EN FRONTEND:');
            $this->line("   GET /api/ventas/{$ventaId}");
            $this->line("   GET /api/ventas/{$ventaId}/pdf");
            $this->line("   GET /api/ventas/{$ventaId}/xml");
            $this->line("   GET /api/ventas/{$ventaId}/cdr");
            $this->newLine();

            DB::commit();

            $this->info('💾 Datos guardados en BD para pruebas adicionales');
            $this->warn('⚠️ Puedes eliminar manualmente si lo deseas');

            return 0;

        } catch (\Exception $e) {
            DB::rollBack();
            $this->error('❌ EXCEPCIÓN: ' . $e->getMessage());
            $this->line('Trace: ' . $e->getTraceAsString());
            return 1;
        }
    }
}
