<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\GuiaRemision;
use App\Services\GuiaRemisionService;

class TestEnviarGuiaSunat extends Command
{
    protected $signature = 'test:enviar-guia {id}';
    protected $description = 'Probar envío de guía de remisión a SUNAT';

    public function handle()
    {
        $id = $this->argument('id');
        
        $this->info("🧪 Probando envío de guía #{$id} a SUNAT");
        $this->newLine();

        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto'])->findOrFail($id);
            
            $this->info("📋 Guía encontrada:");
            $this->table(
                ['Campo', 'Valor'],
                [
                    ['Número', $guia->serie . '-' . str_pad($guia->correlativo, 8, '0', STR_PAD_LEFT)],
                    ['Tipo', $guia->tipo_guia],
                    ['Estado', $guia->estado],
                    ['Requiere SUNAT', $guia->requiere_sunat ? 'Sí' : 'No'],
                ]
            );

            if (!$guia->requiere_sunat) {
                $this->error('❌ Esta guía no requiere envío a SUNAT (Traslado Interno)');
                return 1;
            }

            if (!$guia->puedeEnviar()) {
                $this->error('❌ La guía no puede ser enviada en su estado actual');
                return 1;
            }

            $this->info('📤 Enviando a SUNAT...');
            
            $service = app(GuiaRemisionService::class);
            $resultado = $service->enviarGuiaRemision($guia);

            if ($resultado['success']) {
                $this->info('✅ Guía enviada exitosamente a SUNAT');
                $this->newLine();
                
                $guiaActualizada = GuiaRemision::find($id);
                $this->table(
                    ['Campo', 'Valor'],
                    [
                        ['Estado', $guiaActualizada->estado],
                        ['Mensaje SUNAT', $guiaActualizada->mensaje_sunat ?? 'N/A'],
                        ['Hash', $guiaActualizada->codigo_hash ?? 'N/A'],
                    ]
                );
            } else {
                $this->error('❌ Error al enviar a SUNAT');
                $this->error('Mensaje: ' . $resultado['error']);
                if (isset($resultado['codigo_error'])) {
                    $this->error('Código: ' . $resultado['codigo_error']);
                }
            }

        } catch (\Exception $e) {
            $this->error('❌ Excepción: ' . $e->getMessage());
            $this->error('Archivo: ' . $e->getFile() . ':' . $e->getLine());
            return 1;
        }

        return 0;
    }
}
