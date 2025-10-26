<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use Illuminate\Support\Facades\Storage;

class DescargarPdfCommand extends Command
{
    protected $signature = 'comprobante:descargar-pdf {id : ID del comprobante}';
    protected $description = 'Descargar PDF de un comprobante via API';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        $comprobante = Comprobante::find($id);
        if (!$comprobante) {
            $this->error("Comprobante no encontrado: ID {$id}");
            return self::FAILURE;
        }

        $this->info("Descargando PDF para: {$comprobante->numero_completo}");
        
        try {
            // Simular llamada a la API
            $controller = new \App\Http\Controllers\Facturacion\FacturacionManualController(
                app(\App\Services\GreenterService::class)
            );
            
            $response = $controller->descargarPdf($id);
            
            if ($response->getStatusCode() === 200) {
                $this->info("✅ PDF descargado exitosamente");
                $this->line("Tamaño: " . strlen($response->getContent()) . " bytes");
                
                // Guardar archivo localmente
                $filename = "comprobante_{$comprobante->numero_completo}.pdf";
                $path = storage_path("app/public/{$filename}");
                
                file_put_contents($path, $response->getContent());
                $this->line("Archivo guardado en: {$path}");
                
            } else {
                $this->error("❌ Error al descargar PDF: " . $response->getStatusCode());
                return self::FAILURE;
            }
            
        } catch (\Exception $e) {
            $this->error("Error al descargar PDF: " . $e->getMessage());
            return self::FAILURE;
        }
        
        return self::SUCCESS;
    }
}
