<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use App\Services\GreenterService;

class FacturacionResumenDiarioCommand extends Command
{
    protected $signature = 'facturacion:resumen {fecha : YYYY-MM-DD} {ids* : IDs de comprobantes a incluir}';
    protected $description = 'Generar y enviar Resumen Diario a SUNAT con IDs de comprobantes';

    public function handle(): int
    {
        $fecha = (string)$this->argument('fecha');
        $ids = array_map('intval', (array)$this->argument('ids'));

        /** @var GreenterService $greenter */
        $greenter = App::make(GreenterService::class);
        $res = $greenter->generarResumenDiario($fecha, $ids);

        if (!empty($res['success'])) {
            $data = $res['data'] ?? [];
            $this->info($res['message'] ?? 'Resumen diario enviado');
            $this->line('Fecha: ' . ($data['fecha'] ?? $fecha));
            $this->line('Comprobantes: ' . ($data['cantidad_comprobantes'] ?? count($ids)));
            $this->line('Ticket: ' . ($data['ticket'] ?? 'N/A'));
            return self::SUCCESS;
        }

        $this->error($res['message'] ?? 'Error al generar resumen diario');
        if (!empty($res['error'])) {
            $this->line('Detalle: ' . $res['error']);
        }
        return self::FAILURE;
    }
}


