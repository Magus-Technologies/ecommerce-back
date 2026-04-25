<?php
/**
 * Script para crear y aperturar cajas
 * Uso: 
 *   - Crear caja: POST /crear_caja.php?action=crear
 *   - Aperturar caja: POST /crear_caja.php?action=aperturar
 */

require 'vendor/autoload.php';

use Illuminate\Database\Capsule\Manager as DB;
use App\Models\Caja;
use App\Models\CajaMovimiento;

// Cargar configuración de Laravel
$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

header('Content-Type: application/json');

try {
    $action = $_GET['action'] ?? $_POST['action'] ?? null;

    if ($action === 'crear') {
        // Crear nueva caja
        $nombre = $_POST['nombre'] ?? null;
        
        if (!$nombre) {
            http_response_code(400);
            echo json_encode(['error' => 'El nombre de la caja es requerido']);
            exit;
        }

        $codigo = strtoupper(substr($nombre, 0, 20));
        
        $caja = Caja::create([
            'nombre' => $nombre,
            'codigo' => $codigo,
            'tienda_id' => 1,
            'activo' => true
        ]);

        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'Caja creada correctamente',
            'data' => $caja
        ]);

    } elseif ($action === 'aperturar') {
        // Aperturar caja
        $caja_id = $_POST['caja_id'] ?? null;
        $monto_inicial = $_POST['monto_inicial'] ?? null;
        $observaciones = $_POST['observaciones'] ?? '';

        if (!$caja_id || !$monto_inicial) {
            http_response_code(400);
            echo json_encode(['error' => 'caja_id y monto_inicial son requeridos']);
            exit;
        }

        // Verificar que la caja existe
        $caja = Caja::find($caja_id);
        if (!$caja) {
            http_response_code(404);
            echo json_encode(['error' => 'Caja no encontrada']);
            exit;
        }

        // Verificar que no haya caja abierta
        $cajaAbierta = CajaMovimiento::where('caja_id', $caja_id)
            ->where('estado', 'ABIERTA')
            ->exists();

        if ($cajaAbierta) {
            http_response_code(400);
            echo json_encode(['error' => 'Ya existe una caja abierta']);
            exit;
        }

        $movimiento = CajaMovimiento::create([
            'caja_id' => $caja_id,
            'user_id' => 1, // Admin user
            'tipo' => 'APERTURA',
            'fecha' => now()->toDateString(),
            'hora' => now()->toTimeString(),
            'monto_inicial' => $monto_inicial,
            'observaciones' => $observaciones,
            'estado' => 'ABIERTA'
        ]);

        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'Caja aperturada correctamente',
            'data' => $movimiento
        ]);

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Acción no válida. Use: crear o aperturar']);
    }

} catch (\Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error: ' . $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine()
    ]);
}
