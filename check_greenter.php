<?php
require 'vendor/autoload.php';

echo "Verificando clases de Greenter para Guías de Remisión:\n\n";

$classes = [
    'Greenter\Model\Despatch\Despatch',
    'Greenter\Model\Despatch\Shipment',
    'Greenter\Model\Despatch\Direction',
    'Greenter\Model\Despatch\Driver',
];

foreach ($classes as $class) {
    $exists = class_exists($class);
    echo ($exists ? '✓' : '✗') . " {$class}\n";
}

echo "\n\nMétodos de Despatch:\n";
if (class_exists('Greenter\Model\Despatch\Despatch')) {
    $ref = new ReflectionClass('Greenter\Model\Despatch\Despatch');
    foreach ($ref->getMethods() as $method) {
        if (strpos($method->name, 'set') === 0) {
            echo "  - {$method->name}\n";
        }
    }
}

echo "\n\nMétodos de Shipment:\n";
if (class_exists('Greenter\Model\Despatch\Shipment')) {
    $ref = new ReflectionClass('Greenter\Model\Despatch\Shipment');
    foreach ($ref->getMethods() as $method) {
        if (strpos($method->name, 'set') === 0) {
            echo "  - {$method->name}\n";
        }
    }
}

echo "\n\nMétodos de DespatchDetail:\n";
if (class_exists('Greenter\Model\Despatch\DespatchDetail')) {
    $ref = new ReflectionClass('Greenter\Model\Despatch\DespatchDetail');
    foreach ($ref->getMethods() as $method) {
        if (strpos($method->name, 'set') === 0) {
            echo "  - {$method->name}\n";
        }
    }
}
