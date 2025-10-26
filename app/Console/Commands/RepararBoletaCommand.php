<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use Illuminate\Support\Facades\DB;

class RepararBoletaCommand extends Command
{
    protected $signature = 'boleta:reparar {id : ID de la boleta}';
    protected $description = 'Reparar valores de una boleta directamente en BD';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        try {
            // Actualizar directamente en BD
            DB::table('comprobantes')
                ->where('id', $id)
                ->update([
                    'operacion_gravada' => 100.00,
                    'total_igv' => 18.00,
                    'importe_total' => 118.00,
                    'updated_at' => now()
                ]);

            $this->info("✅ Boleta reparada en BD: ID {$id}");
            
            // Verificar
            $comp = Comprobante::find($id);
            $this->line("Operación Gravada: {$comp->operacion_gravada}");
            $this->line("Total IGV: {$comp->total_igv}");
            $this->line("Importe Total: {$comp->importe_total}");
            
            return self::SUCCESS;
            
        } catch (\Exception $e) {
            $this->error("Error al reparar boleta: " . $e->getMessage());
            return self::FAILURE;
        }
    }
}
