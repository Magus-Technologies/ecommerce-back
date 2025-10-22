<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use App\Services\GreenterService;
use App\Models\Comprobante;

class FacturacionEnviarCommand extends Command
{
    /** @var string */
    protected $signature = 'facturacion:enviar {id : ID del comprobante}';

    /** @var string */
    protected $description = 'Enviar a SUNAT un comprobante existente por ID';

    public function handle(): int
    {
        $id = (int)$this->argument('id');

        /** @var Comprobante|null $comprobante */
        $comprobante = Comprobante::with('cliente', 'detalles')->find($id);
        if (!$comprobante) {
            $this->error('Comprobante no encontrado: ID ' . $id);
            return self::FAILURE;
        }

        /** @var GreenterService $greenter */
        $greenter = App::make(GreenterService::class);
        $result = $greenter->enviarComprobante($comprobante);

        if (!empty($result['success'])) {
            $comp = $result['data']['comprobante'] ?? $comprobante->fresh();
            $this->info('Enviado correctamente.');
            $this->line('Número: ' . ($comp->numero_completo ?? ($comp->serie.'-'.$comp->correlativo)));
            $this->line('Estado: ' . ($comp->estado ?? ''));
            if (!empty($comp->mensaje_sunat)) {
                $this->line('SUNAT: ' . $comp->mensaje_sunat);
            }
            return self::SUCCESS;
        }

        $this->error('Error al enviar: ' . ($result['error'] ?? 'Desconocido'));
        if (!empty($result['codigo_error'])) {
            $this->line('Código: ' . $result['codigo_error']);
        }
        return self::FAILURE;
    }
}


