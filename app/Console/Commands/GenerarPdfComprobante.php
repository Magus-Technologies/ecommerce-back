<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use App\Services\GreenterService;

class GenerarPdfComprobante extends Command
{
    protected $signature = 'comprobante:generar-pdf {comprobante_id}';
    protected $description = 'Generar PDF para un comprobante específico';

    public function handle()
    {
        $comprobanteId = $this->argument('comprobante_id');
        
        $this->info("Generando PDF para comprobante ID: {$comprobanteId}");
        $this->line('-------------------------------------------');

        try {
            $comprobante = Comprobante::with('cliente')->find($comprobanteId);
            
            if (!$comprobante) {
                $this->error("❌ Comprobante no encontrado: {$comprobanteId}");
                return 1;
            }

            $this->info("✅ Comprobante encontrado:");
            $this->line("   Número: " . ($comprobante->numero_completo ?? 'N/A'));
            $this->line("   Estado: " . ($comprobante->estado ?? 'N/A'));
            $this->line("   Tiene XML: " . (!empty($comprobante->xml_firmado) ? 'SÍ' : 'NO'));
            $this->line("   Tiene PDF: " . (!empty($comprobante->pdf_base64) ? 'SÍ' : 'NO'));

            if (empty($comprobante->xml_firmado)) {
                $this->error("❌ El comprobante no tiene XML firmado");
                return 1;
            }

            $greenterService = new GreenterService();
            
            // Construir documento Greenter
            $documento = $greenterService->construirDocumentoGreenter($comprobante, $comprobante->cliente);
            
            $this->info("📄 Generando PDF...");
            
            // Generar PDF
            $resultado = $greenterService->generarPdf($comprobante, $documento);
            
            if ($resultado) {
                $comprobanteActualizado = $comprobante->fresh();
                $this->info("✅ PDF generado exitosamente");
                $this->line("   Tiene PDF ahora: " . (!empty($comprobanteActualizado->pdf_base64) ? 'SÍ' : 'NO'));
                $this->line("   Tamaño PDF: " . strlen($comprobanteActualizado->pdf_base64 ?? '') . " bytes (base64)");
                
                return 0;
            } else {
                $this->error("❌ Error al generar PDF");
                return 1;
            }

        } catch (\Exception $e) {
            $this->error("❌ Excepción: " . $e->getMessage());
            $this->line("Archivo: " . $e->getFile());
            $this->line("Línea: " . $e->getLine());
            return 1;
        }
    }
}