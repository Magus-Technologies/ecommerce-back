<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use App\Services\GreenterService;

class FacturacionConsultarTicketCommand extends Command
{
    protected $signature = 'facturacion:ticket {ticket : Número de ticket SUNAT}';
    protected $description = 'Consultar estado de ticket SUNAT (resumen/baja)';

    public function handle(): int
    {
        $ticket = (string)$this->argument('ticket');
        /** @var GreenterService $greenter */
        $greenter = App::make(GreenterService::class);
        $res = $greenter->consultarTicket($ticket);
        if (!empty($res['success'])) {
            $data = $res['data'];
            $this->info('Ticket: ' . $data['ticket']);
            $this->line('Estado: ' . $data['estado']);
            $this->line('Código SUNAT: ' . ($data['codigo_sunat'] ?? ''));
            $this->line('Mensaje: ' . ($data['mensaje_sunat'] ?? ''));
            return self::SUCCESS;
        }
        $this->error($res['message'] ?? 'Error consultando ticket');
        if (!empty($res['error'])) {
            $this->line('Detalle: ' . $res['error']);
        }
        return self::FAILURE;
    }
}


