<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Schema;

class VerificarEstructuraCommand extends Command
{
    protected $signature = 'estructura:verificar {tabla : Nombre de la tabla}';
    protected $description = 'Verificar estructura de una tabla';

    public function handle(): int
    {
        $tabla = $this->argument('tabla');
        
        $columns = Schema::getColumnListing($tabla);
        
        $this->info("Columnas de la tabla {$tabla}:");
        foreach($columns as $column) {
            $this->line("- {$column}");
        }
        
        return self::SUCCESS;
    }
}
