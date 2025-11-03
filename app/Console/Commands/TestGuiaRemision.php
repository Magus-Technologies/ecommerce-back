<?php

namespace App\Console\Commands;

use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;
use Illuminate\Console\Command;

class TestGuiaRemision extends Command
{
    protected $signature = 'test:guia-remision {--tipo=remitente}';

    protected $description = 'Probar creación de guías de remisión';

    public function handle()
    {
        $tipo = $this->option('tipo');

        $this->info("🧪 Probando Guías de Remisión - Tipo: {$tipo}");
        $this->newLine();

        // Verificar requisitos
        if (! $this->verificarRequisitos()) {
            return 1;
        }

        if ($tipo === 'remitente') {
            $this->testGuiaRemitenteConCliente();
            $this->newLine();
            $this->testGuiaRemitenteSinCliente();
        } elseif ($tipo === 'interno') {
            $this->testGuiaInterna();
        }

        return 0;
    }

    private function verificarRequisitos()
    {
        $this->info('📋 Verificando requisitos...');

        // Verificar serie
        $serie = SerieComprobante::where('tipo_comprobante', '09')
            ->where('activo', true)
            ->first();

        if (! $serie) {
            $this->error('❌ No hay serie activa para tipo 09 (Guías de Remisión)');
            $this->info('💡 Crea una serie con: INSERT INTO series_comprobantes (tipo_comprobante, serie, correlativo, activo) VALUES ("09", "T001", 1, 1)');

            return false;
        }

        $this->info("✅ Serie encontrada: {$serie->serie}");

        // Verificar producto
        $producto = Producto::first();
        if (! $producto) {
            $this->error('❌ No hay productos en la base de datos');

            return false;
        }

        $this->info("✅ Producto encontrado: {$producto->nombre}");

        return true;
    }

    private function testGuiaRemitenteConCliente()
    {
        $this->info('🧪 TEST 1: GRE Remitente CON cliente (cliente como destinatario)');
        $this->newLine();

        // Buscar o crear cliente con RUC
        $cliente = Cliente::where('tipo_documento', '6')->first();

        if (! $cliente) {
            $this->warn('⚠️  No hay clientes con RUC, creando uno de prueba...');
            $cliente = Cliente::create([
                'tipo_documento' => '6',
                'numero_documento' => '20123456789',
                'razon_social' => 'Empresa Test SAC',
                'direccion' => 'Av. Test 123',
                'ubigeo' => '150101',
                'email' => 'test@empresa.com',
                'telefono' => '999999999',
            ]);
            $this->info("✅ Cliente creado: {$cliente->razon_social}");
        } else {
            $this->info("✅ Cliente encontrado: {$cliente->razon_social}");
        }

        $producto = Producto::first();

        $data = [
            'cliente_id' => $cliente->id,
            'usar_cliente_como_destinatario' => true,
            'motivo_traslado' => '01',
            'modalidad_traslado' => '01',
            'fecha_inicio_traslado' => now()->format('Y-m-d'),
            'punto_partida_ubigeo' => '150101',
            'punto_partida_direccion' => 'Av. Los Olivos 123, Lima',
            'punto_llegada_ubigeo' => '150131',
            'punto_llegada_direccion' => 'Jr. Las Flores 456, San Isidro',
            'productos' => [
                [
                    'producto_id' => $producto->id,
                    'cantidad' => 5,
                    'peso_unitario' => 1.5,
                ],
            ],
            'numero_bultos' => 1,
            'observaciones' => 'Test - Envío por Olva Courier',
        ];

        $this->info('📤 Enviando request...');
        $this->table(
            ['Campo', 'Valor'],
            [
                ['cliente_id', $data['cliente_id']],
                ['usar_cliente_como_destinatario', 'true'],
                ['modalidad_traslado', '01 (Público/Contratado)'],
                ['productos', count($data['productos']).' producto(s)'],
            ]
        );

        try {
            $response = $this->postGuiaRemision($data);

            if ($response['success']) {
                $this->info('✅ Guía creada exitosamente');
                $guia = $response['data'];
                $this->table(
                    ['Campo', 'Valor'],
                    [
                        ['ID', $guia['id'] ?? 'N/A'],
                        ['Número', ($guia['serie'] ?? 'T001').'-'.str_pad($guia['correlativo'] ?? 0, 8, '0', STR_PAD_LEFT)],
                        ['Estado', $guia['estado'] ?? 'PENDIENTE'],
                        ['Tipo', $guia['tipo_guia'] ?? 'REMITENTE'],
                        ['Requiere SUNAT', ($guia['requiere_sunat'] ?? true) ? 'Sí' : 'No'],
                        ['Peso Total', ($guia['peso_total'] ?? 0).' kg'],
                    ]
                );
            } else {
                $this->error('❌ Error al crear guía');
                $this->error('Mensaje: '.$response['message']);
                if (isset($response['error'])) {
                    $this->error('Error detallado: '.$response['error']);
                }
                if (isset($response['errors'])) {
                    $this->error('Errores de validación:');
                    foreach ($response['errors'] as $field => $errors) {
                        $this->error("  - {$field}: ".implode(', ', $errors));
                    }
                }

                // Mostrar respuesta completa para debug
                $this->newLine();
                $this->warn('📋 Respuesta completa:');
                $this->line(json_encode($response, JSON_PRETTY_PRINT));
            }
        } catch (\Exception $e) {
            $this->error('❌ Excepción: '.$e->getMessage());
        }
    }

    private function testGuiaRemitenteSinCliente()
    {
        $this->info('🧪 TEST 2: GRE Remitente SIN cliente (destinatario manual con DNI)');
        $this->newLine();

        $producto = Producto::first();

        $data = [
            // NO enviamos cliente_id
            'motivo_traslado' => '01',
            'modalidad_traslado' => '01',
            'fecha_inicio_traslado' => now()->format('Y-m-d'),
            'destinatario_tipo_documento' => '1',
            'destinatario_numero_documento' => '76165962',
            'destinatario_razon_social' => 'Victor Raul Canchari Riqui',
            'destinatario_direccion' => 'Av. Lo Herores 231, Lima',
            'destinatario_ubigeo' => '150101',
            'punto_partida_ubigeo' => '150101',
            'punto_partida_direccion' => 'Av. Los Olivos 123, Lima',
            'punto_llegada_ubigeo' => '150101',
            'punto_llegada_direccion' => 'Av. Lo Herores 231, Lima',
            'productos' => [
                [
                    'producto_id' => $producto->id,
                    'cantidad' => 3,
                    'peso_unitario' => 2.0,
                ],
            ],
            'numero_bultos' => 1,
            'observaciones' => 'Test - Destinatario con DNI',
        ];

        $this->info('📤 Enviando request...');
        $this->table(
            ['Campo', 'Valor'],
            [
                ['cliente_id', 'NO ENVIADO (opcional)'],
                ['destinatario_tipo_documento', '1 (DNI)'],
                ['destinatario_numero_documento', $data['destinatario_numero_documento']],
                ['destinatario_razon_social', $data['destinatario_razon_social']],
                ['modalidad_traslado', '01 (Público/Contratado)'],
            ]
        );

        try {
            $response = $this->postGuiaRemision($data);

            if ($response['success']) {
                $this->info('✅ Guía creada exitosamente');
                $guia = $response['data'];
                $this->table(
                    ['Campo', 'Valor'],
                    [
                        ['ID', $guia['id'] ?? 'N/A'],
                        ['Número', ($guia['serie'] ?? 'T001').'-'.str_pad($guia['correlativo'] ?? 0, 8, '0', STR_PAD_LEFT)],
                        ['Estado', $guia['estado'] ?? 'PENDIENTE'],
                        ['Tipo', $guia['tipo_guia'] ?? 'REMITENTE'],
                        ['Cliente ID', $guia['cliente_id'] ?? 'NULL (correcto)'],
                        ['Destinatario', $guia['destinatario_razon_social'] ?? 'N/A'],
                        ['Requiere SUNAT', ($guia['requiere_sunat'] ?? true) ? 'Sí' : 'No'],
                        ['Peso Total', ($guia['peso_total'] ?? 0).' kg'],
                    ]
                );
            } else {
                $this->error('❌ Error al crear guía');
                $this->error('Mensaje: '.$response['message']);
                if (isset($response['error'])) {
                    $this->error('Error detallado: '.$response['error']);
                }
                if (isset($response['errors'])) {
                    $this->error('Errores de validación:');
                    foreach ($response['errors'] as $field => $errors) {
                        $this->error("  - {$field}: ".implode(', ', $errors));
                    }
                }

                // Mostrar respuesta completa para debug
                $this->newLine();
                $this->warn('📋 Respuesta completa:');
                $this->line(json_encode($response, JSON_PRETTY_PRINT));
            }
        } catch (\Exception $e) {
            $this->error('❌ Excepción: '.$e->getMessage());
        }
    }

    private function testGuiaInterna()
    {
        $this->info('🧪 TEST 3: Traslado Interno (sin SUNAT)');
        $this->newLine();

        $producto = Producto::first();

        $data = [
            'motivo_traslado' => '04',
            'fecha_inicio_traslado' => now()->format('Y-m-d'),
            'punto_partida_ubigeo' => '150101',
            'punto_partida_direccion' => 'Almacén Central - Av. Principal 123',
            'punto_llegada_ubigeo' => '150131',
            'punto_llegada_direccion' => 'Almacén Sucursal - Jr. Secundaria 456',
            'productos' => [
                [
                    'producto_id' => $producto->id,
                    'cantidad' => 20,
                    'peso_unitario' => 1.0,
                ],
            ],
            'numero_bultos' => 4,
            'observaciones' => 'Test - Reposición de stock',
        ];

        $this->info('📤 Enviando request...');
        $this->table(
            ['Campo', 'Valor'],
            [
                ['tipo', 'INTERNO'],
                ['motivo_traslado', '04 (Traslado entre establecimientos)'],
                ['requiere_sunat', 'NO'],
                ['productos', count($data['productos']).' producto(s)'],
            ]
        );

        try {
            $response = $this->postGuiaInterna($data);

            if ($response['success']) {
                $this->info('✅ Guía interna creada exitosamente');
                $guia = $response['data'];
                $this->table(
                    ['Campo', 'Valor'],
                    [
                        ['ID', $guia['id'] ?? 'N/A'],
                        ['Número', ($guia['serie'] ?? 'T001').'-'.str_pad($guia['correlativo'] ?? 0, 8, '0', STR_PAD_LEFT)],
                        ['Estado', $guia['estado'] ?? 'PENDIENTE'],
                        ['Tipo', $guia['tipo_guia'] ?? 'INTERNO'],
                        ['Requiere SUNAT', ($guia['requiere_sunat'] ?? false) ? 'Sí' : 'No'],
                        ['Peso Total', ($guia['peso_total'] ?? 0).' kg'],
                    ]
                );
            } else {
                $this->error('❌ Error al crear guía interna');
                $this->error('Mensaje: '.$response['message']);
                if (isset($response['error'])) {
                    $this->error('Error detallado: '.$response['error']);
                }
                if (isset($response['errors'])) {
                    $this->error('Errores de validación:');
                    foreach ($response['errors'] as $field => $errors) {
                        $this->error("  - {$field}: ".implode(', ', $errors));
                    }
                }

                // Mostrar respuesta completa para debug
                $this->newLine();
                $this->warn('📋 Respuesta completa:');
                $this->line(json_encode($response, JSON_PRETTY_PRINT));
            }
        } catch (\Exception $e) {
            $this->error('❌ Excepción: '.$e->getMessage());
        }
    }

    private function postGuiaRemision($data)
    {
        // Simular el request directamente al controlador
        $request = new \Illuminate\Http\Request;
        $request->merge($data);
        $request->setUserResolver(function () {
            return \App\Models\User::first();
        });

        $controller = app(\App\Http\Controllers\Facturacion\GuiasRemisionController::class);
        $response = $controller->storeRemitente($request);

        return json_decode($response->getContent(), true);
    }

    private function postGuiaInterna($data)
    {
        $request = new \Illuminate\Http\Request;
        $request->merge($data);
        $request->setUserResolver(function () {
            return \App\Models\User::first();
        });

        $controller = app(\App\Http\Controllers\Facturacion\GuiasRemisionController::class);
        $response = $controller->storeInterno($request);

        return json_decode($response->getContent(), true);
    }
}
