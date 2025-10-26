<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use App\Models\Comprobante;

class FacturacionDescargarCommand extends Command
{
    /** @var string */
    protected $signature = 'facturacion:descargar {id : ID del comprobante} {--tipo=all : pdf|xml|cdr|all}';

    /** @var string */
    protected $description = 'Exportar PDF/XML/CDR de un comprobante a storage/app/public/comprobantes/';

    public function handle(): int
    {
        $id = (int)$this->argument('id');
        $tipo = strtolower((string)$this->option('tipo'));

        /** @var Comprobante|null $comp */
        $comp = Comprobante::find($id);
        if (!$comp) {
            $this->error('Comprobante no encontrado: ID ' . $id);
            return self::FAILURE;
        }

        $baseName = ($comp->numero_completo ?? ($comp->serie.'-'.$comp->correlativo));
        $dir = 'public/comprobantes/' . $baseName;
        Storage::makeDirectory($dir);

        $exported = [];

        if ($tipo === 'pdf' || $tipo === 'all') {
            if (!empty($comp->pdf_base64)) {
                $pdf = base64_decode($comp->pdf_base64);
                Storage::put($dir . '/' . $baseName . '.pdf', $pdf);
                $exported[] = 'PDF';
            } else {
                $this->warn('No hay PDF almacenado en la BD para este comprobante.');
            }
        }

        if ($tipo === 'xml' || $tipo === 'all') {
            if (!empty($comp->xml_firmado)) {
                Storage::put($dir . '/' . $baseName . '.xml', $comp->xml_firmado);
                $exported[] = 'XML';
            } else {
                $this->warn('No hay XML firmado almacenado para este comprobante.');
            }
        }

        if ($tipo === 'cdr' || $tipo === 'all') {
            if (!empty($comp->xml_respuesta_sunat)) {
                Storage::put($dir . '/' . $baseName . '-CDR.zip', $comp->xml_respuesta_sunat);
                $exported[] = 'CDR';
            } else {
                $this->warn('No hay CDR almacenado para este comprobante.');
            }
        }

        if (!empty($exported)) {
            $this->info('Exportado: ' . implode(', ', $exported));
            $this->line('Ruta: storage/app/' . $dir);
            $this->line('Si creaste el symlink: public/storage/comprobantes/' . $baseName);
            return self::SUCCESS;
        }

        $this->error('No se exportó ningún archivo.');
        return self::FAILURE;
    }
}


