<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$guia = \App\Models\GuiaRemision::find(18);

if ($guia) {
    echo "ID: {$guia->id}\n";
    echo "Fecha emisión: {$guia->fecha_emision}\n";
    echo "Fecha traslado: {$guia->fecha_inicio_traslado}\n";
    echo "Serie-Correlativo: {$guia->serie}-{$guia->correlativo}\n";
    echo "Tipo: {$guia->tipo}\n";
    echo "Modalidad traslado: {$guia->modalidad_traslado}\n";
    echo "Motivo traslado: {$guia->motivo_traslado}\n";
} else {
    echo "Guía no encontrada\n";
}
