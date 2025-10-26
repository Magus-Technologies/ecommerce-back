<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use App\Services\GuiaRemisionService;
use App\Models\GuiaRemision;

class GuiaRemisionEnviarCommand extends Command
{
    /** @var string */
    protected $signature = 'guia:enviar {id : ID de la guía de remisión}';

    /** @var string */
    protected $description = 'Enviar a SUNAT una guía de remisión existente por ID';

    public function handle(): int
    {
        $id = (int)$this->argument('id');

        /** @var GuiaRemision|null $guia */
        $guia = GuiaRemision::with('cliente', 'detalles.producto')->find($id);
        if (!$guia) {
            $this->error('Guía de remisión no encontrada: ID ' . $id);
            return self::FAILURE;
        }

        /** @var GuiaRemisionService $service */
        $service = App::make(GuiaRemisionService::class);
        $result = $service->enviarGuiaRemision($guia);

        if (!empty($result['success'])) {
            $guia = $result['data']['guia'] ?? $guia->fresh();
            $this->info('Enviada correctamente.');
            $this->line('Número: ' . ($guia->numero_completo ?? ($guia->serie.'-'.$guia->correlativo)));
            $this->line('Estado: ' . ($guia->estado ?? ''));
            if (!empty($guia->mensaje_sunat)) {
                $this->line('SUNAT: ' . $guia->mensaje_sunat);
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
