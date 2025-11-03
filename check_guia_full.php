<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$guia = \App\Models\GuiaRemision::find(18);

if ($guia) {
    echo "ID: {$guia->id}\n";
    echo "Serie-Correlativo: {$guia->serie}-{$guia->correlativo}\n";
    echo "Estado: {$guia->estado}\n";
    echo "Mensaje SUNAT: {$guia->mensaje_sunat}\n";
    echo "Tiene XML: " . ($guia->xml_firmado ? "SÍ (" . strlen($guia->xml_firmado) . " bytes)" : "NO") . "\n";
    echo "Tiene PDF: " . ($guia->pdf_base64 ? "SÍ" : "NO") . "\n";
    echo "Hash: {$guia->codigo_hash}\n";
} else {
    echo "Guía no encontrada\n";
}
