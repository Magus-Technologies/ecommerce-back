<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;

class VerificarPdfCommand extends Command
{
    protected $signature = 'pdf:verificar {id : ID del comprobante}';
    protected $description = 'Verificar estado del PDF de un comprobante';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        $comp = Comprobante::find($id);
        if (!$comp) {
            $this->error("Comprobante no encontrado: ID {$id}");
            return self::FAILURE;
        }

        $this->info("Comprobante: {$comp->numero_completo}");
        $this->line("PDF generado: " . (!empty($comp->pdf_base64) ? 'SÍ (' . strlen($comp->pdf_base64) . ' caracteres)' : 'NO'));
        $this->line("XML generado: " . (!empty($comp->xml_firmado) ? 'SÍ' : 'NO'));
        $this->line("Estado: {$comp->estado}");
        
        if (!empty($comp->pdf_base64)) {
            $this->info("✅ PDF disponible para descarga");
            $this->line("Tamaño real: " . round(strlen(base64_decode($comp->pdf_base64)) / 1024, 2) . " KB");
        } else {
            $this->warn("⚠️ PDF no generado aún");
        }
        
        return self::SUCCESS;
    }
}
