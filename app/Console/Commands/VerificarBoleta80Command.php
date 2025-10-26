<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;

class VerificarBoleta80Command extends Command
{
    protected $signature = 'boleta:verificar-80';
    protected $description = 'Verificar boleta número 80';

    public function handle(): int
    {
        $comp = Comprobante::find(80);
        if (!$comp) {
            $this->error("Boleta 80 no encontrada");
            return self::FAILURE;
        }

        $this->info("Boleta 80:");
        $this->line("ID: {$comp->id}");
        $this->line("Número: {$comp->numero_completo}");
        $this->line("Operación Gravada: {$comp->operacion_gravada}");
        $this->line("Total IGV: {$comp->total_igv}");
        $this->line("Importe Total: {$comp->importe_total}");
        $this->line("Estado: {$comp->estado}");
        $this->line("Cliente: {$comp->cliente_razon_social}");
        
        return self::SUCCESS;
    }
}
