<?php
require 'vendor/autoload.php';

echo "Verificando API REST de GRE:\n\n";

$classes = [
    'Greenter\Gre\Api\CpeApi',
    'Greenter\Gre\Api\AuthApi',
    'Greenter\Gre\Model\CpeDocument',
];

foreach ($classes as $class) {
    $exists = class_exists($class);
    echo ($exists ? '✓' : '✗') . " {$class}\n";
}

echo "\n\nMétodos de CpeApi:\n";
if (class_exists('Greenter\Gre\Api\CpeApi')) {
    $ref = new ReflectionClass('Greenter\Gre\Api\CpeApi');
    foreach ($ref->getMethods(ReflectionMethod::IS_PUBLIC) as $method) {
        if (!$method->isConstructor()) {
            echo "  - {$method->name}\n";
        }
    }
}

echo "\n\nMétodos de AuthApi:\n";
if (class_exists('Greenter\Gre\Api\AuthApi')) {
    $ref = new ReflectionClass('Greenter\Gre\Api\AuthApi');
    foreach ($ref->getMethods(ReflectionMethod::IS_PUBLIC) as $method) {
        if (!$method->isConstructor()) {
            echo "  - {$method->name}\n";
        }
    }
}
