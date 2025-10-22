<?php

namespace App\Listeners;

use App\Events\VentaCreated;
use App\Services\KardexService;
use App\Services\NotificacionService;
use App\Models\CajaMovimiento;
use App\Models\CajaTransaccion;
use App\Models\UtilidadVenta;
use App\Models\Kardex;
use Illuminate\Support\Facades\Log;

class ProcessVentaCreated
{
    /**
     * Handle the event.
     */
    public function handle(VentaCreated $event)
    {
        $venta = $event->venta;

        try {
            // 1. Registrar en Kardex
            $this->registrarEnKardex($venta);

            // 2. Registrar en Caja (si es efectivo)
            if (in_array(strtolower($venta->metodo_pago), ['efectivo', 'cash'])) {
                $this->registrarEnCaja($venta);
            }

            // 3. Calcular y registrar utilidad
            $this->calcularUtilidad($venta);

            // 4. Enviar notificación al cliente
            $this->enviarNotificacion($venta);

        } catch (\Exception $e) {
            Log::error('Error procesando venta creada: ' . $e->getMessage(), [
                'venta_id' => $venta->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
        }
    }

    /**
     * Registrar movimientos en kardex
     */
    private function registrarEnKardex($venta)
    {
        $kardexService = app(KardexService::class);

        foreach ($venta->detalles as $detalle) {
            try {
                $kardexService->registrarSalidaVenta($venta, $detalle);
                
                Log::info('Kardex registrado para venta', [
                    'venta_id' => $venta->id,
                    'producto_id' => $detalle->producto_id,
                    'cantidad' => $detalle->cantidad
                ]);
            } catch (\Exception $e) {
                Log::error('Error registrando kardex: ' . $e->getMessage(), [
                    'venta_id' => $venta->id,
                    'producto_id' => $detalle->producto_id
                ]);
            }
        }
    }

    /**
     * Registrar transacción en caja
     */
    private function registrarEnCaja($venta)
    {
        // Buscar caja abierta del usuario
        $cajaAbierta = CajaMovimiento::where('estado', 'ABIERTA')
            ->where('user_id', $venta->user_id)
            ->latest()
            ->first();

        if (!$cajaAbierta) {
            Log::warning('No hay caja abierta para registrar venta en efectivo', [
                'venta_id' => $venta->id,
                'user_id' => $venta->user_id
            ]);
            return;
        }

        try {
            CajaTransaccion::create([
                'caja_movimiento_id' => $cajaAbierta->id,
                'tipo' => 'INGRESO',
                'categoria' => 'VENTA',
                'monto' => $venta->total,
                'metodo_pago' => $venta->metodo_pago,
                'referencia' => $venta->codigo_venta,
                'venta_id' => $venta->id,
                'descripcion' => 'Venta ' . $venta->codigo_venta,
                'user_id' => $venta->user_id
            ]);

            Log::info('Transacción registrada en caja', [
                'venta_id' => $venta->id,
                'caja_movimiento_id' => $cajaAbierta->id,
                'monto' => $venta->total
            ]);
        } catch (\Exception $e) {
            Log::error('Error registrando en caja: ' . $e->getMessage(), [
                'venta_id' => $venta->id
            ]);
        }
    }

    /**
     * Calcular y registrar utilidad de la venta
     */
    private function calcularUtilidad($venta)
    {
        try {
            $costoTotal = 0;

            foreach ($venta->detalles as $detalle) {
                // Obtener costo promedio del kardex
                $kardex = Kardex::where('producto_id', $detalle->producto_id)
                    ->latest('id')
                    ->first();

                $costoUnitario = $kardex ? $kardex->costo_promedio : ($detalle->producto->precio_compra ?? 0);
                $costoTotal += $costoUnitario * $detalle->cantidad;
            }

            $utilidadBruta = $venta->total - $costoTotal;
            $margenPorcentaje = $venta->total > 0 ? ($utilidadBruta / $venta->total) * 100 : 0;

            UtilidadVenta::create([
                'venta_id' => $venta->id,
                'fecha_venta' => $venta->fecha_venta,
                'total_venta' => $venta->total,
                'costo_total' => $costoTotal,
                'utilidad_bruta' => $utilidadBruta,
                'margen_porcentaje' => $margenPorcentaje,
                'utilidad_neta' => $utilidadBruta // Por ahora sin gastos operativos
            ]);

            Log::info('Utilidad calculada para venta', [
                'venta_id' => $venta->id,
                'utilidad_bruta' => $utilidadBruta,
                'margen' => round($margenPorcentaje, 2) . '%'
            ]);
        } catch (\Exception $e) {
            Log::error('Error calculando utilidad: ' . $e->getMessage(), [
                'venta_id' => $venta->id
            ]);
        }
    }

    /**
     * Enviar notificación al cliente
     */
    private function enviarNotificacion($venta)
    {
        try {
            $cliente = $venta->cliente ?? $venta->userCliente;

            if (!$cliente) {
                Log::warning('No hay cliente para enviar notificación', [
                    'venta_id' => $venta->id
                ]);
                return;
            }

            // Obtener email del cliente
            $email = null;
            $telefono = null;

            if ($venta->cliente) {
                $email = $venta->cliente->email;
                $telefono = $venta->cliente->telefono;
            } elseif ($venta->userCliente) {
                $email = $venta->userCliente->email;
                $telefono = $venta->userCliente->telefono;
            }

            if (!$email && !$telefono) {
                Log::warning('Cliente sin email ni teléfono', [
                    'venta_id' => $venta->id
                ]);
                return;
            }

            $notificacionService = app(NotificacionService::class);
            $notificacionService->notificarVentaRealizada($venta, $cliente);

            Log::info('Notificación enviada', [
                'venta_id' => $venta->id,
                'email' => $email
            ]);
        } catch (\Exception $e) {
            Log::error('Error enviando notificación: ' . $e->getMessage(), [
                'venta_id' => $venta->id
            ]);
        }
    }
}
