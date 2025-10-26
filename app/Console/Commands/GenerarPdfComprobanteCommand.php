<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use App\Services\GreenterService;

class GenerarPdfComprobanteCommand extends Command
{
    protected $signature = 'comprobante:generar-pdf {id : ID del comprobante}';
    protected $description = 'Generar PDF para un comprobante específico';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        $comprobante = Comprobante::find($id);
        if (!$comprobante) {
            $this->error("Comprobante no encontrado: ID {$id}");
            return self::FAILURE;
        }

        $this->info("Generando PDF para: {$comprobante->numero_completo}");
        
        try {
            $greenterService = app(GreenterService::class);
            
            // Obtener cliente
            $cliente = $comprobante->cliente;
            if (!$cliente) {
                $this->error("Cliente no encontrado para el comprobante");
                return self::FAILURE;
            }
            
            // Construir documento Greenter
            $documento = $greenterService->construirDocumentoGreenter($comprobante, $cliente);
            
            // Generar PDF
            $greenterService->generarPdf($comprobante, $documento);
            
            $comprobante->refresh();
            
            if (!empty($comprobante->pdf_base64)) {
                $this->info("✅ PDF generado exitosamente");
                $this->line("Tamaño: " . strlen($comprobante->pdf_base64) . " caracteres (base64)");
                $this->line("Tamaño real: " . round(strlen(base64_decode($comprobante->pdf_base64)) / 1024, 2) . " KB");
            } else {
                $this->error("❌ No se pudo generar el PDF");
                return self::FAILURE;
            }
            
        } catch (\Exception $e) {
            $this->error("Error al generar PDF: " . $e->getMessage());
            return self::FAILURE;
        }
        
        return self::SUCCESS;
    }
}
