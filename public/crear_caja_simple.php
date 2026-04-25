<?php
/**
 * Script simple para crear y aperturar cajas
 */

header('Content-Type: application/json');

try {
    // Cargar variables de entorno desde .env
    $envFile = __DIR__ . '/../.env';
    if (file_exists($envFile)) {
        $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos($line, '=') !== false && strpos($line, '#') !== 0) {
                list($key, $value) = explode('=', $line, 2);
                $key = trim($key);
                $value = trim($value, '\'"');
                putenv("$key=$value");
            }
        }
    }

    // Conexión a base de datos
    $host = getenv('DB_HOST') ?: 'localhost';
    $db = getenv('DB_DATABASE') ?: 'ecommerce';
    $user = getenv('DB_USERNAME') ?: 'root';
    $pass = getenv('DB_PASSWORD') ?: '';

    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $action = $_GET['action'] ?? $_POST['action'] ?? null;

    if ($action === 'crear') {
        $nombre = $_POST['nombre'] ?? null;
        
        if (!$nombre) {
            http_response_code(400);
            echo json_encode(['error' => 'El nombre de la caja es requerido']);
            exit;
        }

        $codigo = strtoupper(substr($nombre, 0, 20));
        
        $stmt = $pdo->prepare("INSERT INTO cajas (nombre, codigo, tienda_id, activo, created_at, updated_at) VALUES (?, ?, 1, 1, NOW(), NOW())");
        $stmt->execute([$nombre, $codigo]);
        
        $caja_id = $pdo->lastInsertId();

        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'Caja creada correctamente',
            'data' => [
                'id' => $caja_id,
                'nombre' => $nombre,
                'codigo' => $codigo
            ]
        ]);

    } elseif ($action === 'aperturar') {
        $caja_id = $_POST['caja_id'] ?? null;
        $monto_inicial = $_POST['monto_inicial'] ?? null;
        $observaciones = $_POST['observaciones'] ?? '';

        if (!$caja_id || !$monto_inicial) {
            http_response_code(400);
            echo json_encode(['error' => 'caja_id y monto_inicial son requeridos']);
            exit;
        }

        // Verificar que la caja existe
        $stmt = $pdo->prepare("SELECT id FROM cajas WHERE id = ?");
        $stmt->execute([$caja_id]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'Caja no encontrada']);
            exit;
        }

        // Verificar que no haya caja abierta
        $stmt = $pdo->prepare("SELECT id FROM caja_movimientos WHERE caja_id = ? AND estado = 'ABIERTA'");
        $stmt->execute([$caja_id]);
        if ($stmt->fetch()) {
            http_response_code(400);
            echo json_encode(['error' => 'Ya existe una caja abierta']);
            exit;
        }

        $stmt = $pdo->prepare("INSERT INTO caja_movimientos (caja_id, user_id, tipo, fecha, hora, monto_inicial, observaciones, estado, created_at, updated_at) VALUES (?, 1, 'APERTURA', CURDATE(), CURTIME(), ?, ?, 'ABIERTA', NOW(), NOW())");
        $stmt->execute([$caja_id, $monto_inicial, $observaciones]);
        
        $movimiento_id = $pdo->lastInsertId();

        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'Caja aperturada correctamente',
            'data' => [
                'id' => $movimiento_id,
                'caja_id' => $caja_id,
                'monto_inicial' => $monto_inicial,
                'estado' => 'ABIERTA'
            ]
        ]);

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Acción no válida. Use: crear o aperturar']);
    }

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error de base de datos: ' . $e->getMessage()
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error: ' . $e->getMessage()
    ]);
}
