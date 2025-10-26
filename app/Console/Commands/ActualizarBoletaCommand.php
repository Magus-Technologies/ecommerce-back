<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;

class ActualizarBoletaCommand extends Command
{
    protected $signature = 'boleta:actualizar {id : ID de la boleta}';
    protected $description = 'Actualizar valores de una boleta';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        $comp = Comprobante::find($id);
        if (!$comp) {
            $this->error("Boleta no encontrada: ID {$id}");
            return self::FAILURE;
        }

        $comp->update([
            'subtotal' => 100.00,
            'igv' => 18.00,
            'total' => 118.00,
            'mto_imp_venta' => 118.00,
            'importe_total' => 118.00
        ]);

        $this->info("✅ Boleta actualizada: {$comp->numero_completo}");
        $this->line("Subtotal: {$comp->subtotal}");
        $this->line("IGV: {$comp->igv}");
        $this->line("Total: {$comp->total}");
        
        return self::SUCCESS;
    }
}
