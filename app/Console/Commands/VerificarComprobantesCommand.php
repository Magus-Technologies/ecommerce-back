<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;

class VerificarComprobantesCommand extends Command
{
    protected $signature = 'comprobantes:verificar';
    protected $description = 'Verificar estado de comprobantes y PDFs';

    public function handle(): int
    {
        $comprobantes = Comprobante::latest()->take(5)->get();
        
        $this->info('Últimos 5 comprobantes:');
        $this->line('');
        
        foreach ($comprobantes as $comp) {
            $tipo = $comp->tipo_comprobante === '01' ? 'Factura' : 'Boleta';
            $pdf = !empty($comp->pdf_base64) ? 'SÍ' : 'NO';
            $xml = !empty($comp->xml_firmado) ? 'SÍ' : 'NO';
            
            $this->line("ID: {$comp->id} | {$tipo} {$comp->numero_completo} | Estado: {$comp->estado} | PDF: {$pdf} | XML: {$xml}");
        }
        
        return self::SUCCESS;
    }
}
