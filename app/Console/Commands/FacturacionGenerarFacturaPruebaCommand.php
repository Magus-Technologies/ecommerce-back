<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\App;
use App\Http\Controllers\Facturacion\TestFacturacionController;

class FacturacionGenerarFacturaPruebaCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'facturacion:generar-factura-prueba';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Genera y envía a SUNAT BETA una factura de prueba (Greenter)';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        // Reusar la lógica del controlador de pruebas
        /** @var TestFacturacionController $controller */
        $controller = App::make(TestFacturacionController::class);

        $response = $controller->generarFacturaPrueba();

        // Si es una respuesta JSON de Laravel, mostrar mensaje y datos básicos
        if (method_exists($response, 'getStatusCode')) {
            $status = $response->getStatusCode();
            $data = $response->getData(true);

            if (!empty($data['success'])) {
                $this->info($data['message'] ?? 'Factura de prueba generada con éxito');
                if (!empty($data['data'])) {
                    $info = $data['data'];
                    $this->line('ID: ' . ($info['comprobante_id'] ?? 'N/A'));
                    $this->line('Número: ' . ($info['numero_completo'] ?? 'N/A'));
                    $this->line('Estado: ' . ($info['estado'] ?? 'N/A'));
                    if (!empty($info['urls'])) {
                        $this->line('PDF: ' . ($info['urls']['descargar_pdf'] ?? ''));
                        $this->line('XML: ' . ($info['urls']['descargar_xml'] ?? ''));
                    }
                }
                return self::SUCCESS;
            }

            $this->error(($data['message'] ?? 'Error al generar factura de prueba') . ' (HTTP ' . $status . ')');
            if (!empty($data['error'])) {
                $this->line('Detalle: ' . (is_string($data['error']) ? $data['error'] : json_encode($data['error'])));
            }
            return self::FAILURE;
        }

        $this->error('No se pudo procesar la respuesta al generar la factura de prueba');
        return self::FAILURE;
    }
}


