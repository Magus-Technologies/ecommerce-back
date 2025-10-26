<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Comprobante;
use App\Models\ComprobanteDetalle;
use Barryvdh\DomPDF\Facade\Pdf;

class GenerarPdfSimpleCommand extends Command
{
    protected $signature = 'pdf:generar-simple {id : ID del comprobante}';
    protected $description = 'Generar PDF simple de un comprobante';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        
        $comprobante = Comprobante::with(['detalles.producto', 'cliente'])->find($id);
        if (!$comprobante) {
            $this->error("Comprobante no encontrado: ID {$id}");
            return self::FAILURE;
        }

        $this->info("Generando PDF simple para: {$comprobante->numero_completo}");
        
        try {
            // Preparar datos para el PDF
            $datos = [
                'comprobante' => $comprobante,
                'detalles' => $comprobante->detalles,
                'empresa' => [
                    'nombre' => config('services.company.name', 'TU EMPRESA S.A.C.'),
                    'ruc' => config('services.company.ruc', '20123456789'),
                    'direccion' => config('services.company.address', 'AV. PRINCIPAL 123, LIMA'),
                ]
            ];

            // Generar PDF
            $pdf = Pdf::loadView('pdf.comprobante-simple', $datos);
            $pdf->setPaper('A4', 'portrait');

            // Guardar PDF
            $filename = "comprobante_{$comprobante->numero_completo}.pdf";
            $path = storage_path("app/public/{$filename}");
            
            $pdf->save($path);

            // Actualizar comprobante con PDF en base64
            $pdfContent = $pdf->output();
            $comprobante->update([
                'pdf_base64' => base64_encode($pdfContent)
            ]);

            $this->info("✅ PDF generado exitosamente");
            $this->line("Archivo guardado en: {$path}");
            $this->line("Tamaño: " . round(strlen($pdfContent) / 1024, 2) . " KB");
            $this->line("PDF también guardado en base64 en la base de datos");
            
            return self::SUCCESS;
            
        } catch (\Exception $e) {
            $this->error("Error al generar PDF: " . $e->getMessage());
            return self::FAILURE;
        }
    }
}
