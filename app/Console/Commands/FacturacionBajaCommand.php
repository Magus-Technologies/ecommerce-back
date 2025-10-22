<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use App\Services\GreenterService;

class FacturacionBajaCommand extends Command
{
    protected $signature = 'facturacion:baja {ids* : IDs de comprobantes} {--motivo=Error en emisión}';
    protected $description = 'Enviar Comunicación de Baja (RA) para comprobantes específicos';

    public function handle(): int
    {
        $ids = array_map('intval', (array)$this->argument('ids'));
        $motivo = (string)$this->option('motivo');

        /** @var GreenterService $greenter */
        $greenter = App::make(GreenterService::class);
        $res = $greenter->enviarComunicacionBaja($ids, $motivo);

        if (!empty($res['success'])) {
            $data = $res['data'] ?? [];
            $this->info($res['message'] ?? 'Comunicación de baja enviada');
            $this->line('Comprobantes: ' . ($data['cantidad_comprobantes'] ?? count($ids)));
            $this->line('Motivo: ' . ($data['motivo'] ?? $motivo));
            $this->line('Ticket: ' . ($data['ticket'] ?? 'N/A'));
            return self::SUCCESS;
        }

        $this->error($res['message'] ?? 'Error al enviar comunicación de baja');
        if (!empty($res['error'])) {
            $this->line('Detalle: ' . $res['error']);
        }
        return self::FAILURE;
    }
}


