<?php

$baseUrl = 'https://magus-ecommerce.com/ecommerce-back/public/api';

$cajaId = 3; // Caja Principal ya creada (CAJA-001)
echo "✅ Usando caja existente ID: $cajaId\n\n";

// ── PASO 2: Aperturar la caja ──────────────────────────────────────────────
$payload2 = json_encode([
    'caja_id'       => $cajaId,
    'monto_inicial' => 500.00,
    'observaciones' => 'Apertura inicial',
]);

$ch2 = curl_init("$baseUrl/contabilidad/cajas/aperturar");
curl_setopt_array($ch2, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST           => true,
    CURLOPT_POSTFIELDS     => $payload2,
    CURLOPT_HTTPHEADER     => ['Content-Type: application/json', 'Accept: application/json'],
    CURLOPT_SSL_VERIFYPEER => false,
]);

$response2 = curl_exec($ch2);
$status2   = curl_getinfo($ch2, CURLINFO_HTTP_CODE);
curl_close($ch2);

$apertura = json_decode($response2, true);

echo "=== APERTURAR CAJA ===\n";
echo "Status: $status2\n";
echo "Respuesta: " . json_encode($apertura, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n\n";

if ($status2 === 201) {
    echo "✅ Caja aperturada correctamente con S/ 500.00\n";
} else {
    echo "⚠️  La caja fue creada pero no se pudo aperturar.\n";
}
