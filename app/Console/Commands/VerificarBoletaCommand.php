<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;

class VerificarBoletaCommand extends Command
{
    protected $signature = 'boleta:verificar {id : ID de la boleta}';
    protected $description = 'Verificar datos de una boleta específica';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        $comp = Comprobante::find($id);
        if (!$comp) {
            $this->error("Boleta no encontrada: ID {$id}");
            return self::FAILURE;
        }

        $this->info("Boleta: {$comp->numero_completo}");
        $this->line("Subtotal: {$comp->subtotal}");
        $this->line("IGV: {$comp->igv}");
        $this->line("Total: {$comp->total}");
        $this->line("MtoImpVenta: {$comp->mto_imp_venta}");
        $this->line("Estado: {$comp->estado}");
        
        // Verificar cálculos
        $subtotal = (float)$comp->subtotal;
        $igv = (float)$comp->igv;
        $total = (float)$comp->total;
        $mtoImpVenta = (float)$comp->mto_imp_venta;
        
        $this->line("");
        $this->line("Verificación de cálculos:");
        $this->line("Subtotal + IGV = " . ($subtotal + $igv));
        $this->line("Total esperado = " . $total);
        $this->line("MtoImpVenta = " . $mtoImpVenta);
        
        if (abs(($subtotal + $igv) - $total) > 0.01) {
            $this->error("❌ Error en cálculo: Subtotal + IGV ≠ Total");
        } else {
            $this->info("✅ Cálculos correctos");
        }
        
        return self::SUCCESS;
    }
}
