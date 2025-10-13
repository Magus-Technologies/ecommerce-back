<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Events\OnPaymentConfirmed;
use App\Models\Compra;
use App\Models\User;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class WebhookController extends Controller
{
    /**
     * Webhook para recibir notificaciones de pago confirmado
     */
    public function webhookPago(Request $request): JsonResponse
    {
        try {
            Log::info("Webhook de pago recibido", [
                'headers' => $request->headers->all(),
                'body' => $request->all()
            ]);

            // Validar datos del webhook
            $validator = Validator::make($request->all(), [
                'compra_id' => 'required|integer|exists:compras,id',
                'estado_pago' => 'required|string|in:confirmado,aprobado,completado',
                'metodo_pago' => 'required|string',
                'referencia_pago' => 'nullable|string',
                'monto' => 'required|numeric|min:0',
                'fecha_pago' => 'required|date',
                'signature' => 'nullable|string' // Para validar autenticidad del webhook
            ]);

            if ($validator->fails()) {
                Log::warning("Webhook de pago con datos inválidos", [
                    'errors' => $validator->errors()
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'Datos del webhook inválidos',
                    'errors' => $validator->errors()
                ], 422);
            }

            $data = $validator->validated();

            // Buscar la compra
            $compra = Compra::with('user')->findOrFail($data['compra_id']);

            // Verificar que la compra esté en estado apropiado
            if ($compra->estado_compra_id !== 2) { // Debe estar aprobada
                Log::warning("Compra no está en estado apropiado para procesar pago", [
                    'compra_id' => $compra->id,
                    'estado_actual' => $compra->estado_compra_id
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'La compra no está en estado apropiado para procesar el pago'
                ], 422);
            }

            // Verificar que el monto coincida
            if (abs($compra->total - $data['monto']) > 0.01) {
                Log::warning("Monto del webhook no coincide con el total de la compra", [
                    'compra_id' => $compra->id,
                    'monto_compra' => $compra->total,
                    'monto_webhook' => $data['monto']
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'El monto del pago no coincide con el total de la compra'
                ], 422);
            }

            // Validar firma del webhook (opcional, para seguridad)
            if (isset($data['signature']) && !$this->validarFirmaWebhook($request, $data['signature'])) {
                Log::warning("Firma del webhook inválida", [
                    'compra_id' => $compra->id
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'Firma del webhook inválida'
                ], 401);
            }

            // Actualizar estado de la compra a pagada
            $compra->update([
                'estado_compra_id' => 3, // Pagada
                'metodo_pago' => $data['metodo_pago'],
                'fecha_pago' => $data['fecha_pago']
            ]);

            // Disparar evento de pago confirmado
            event(new OnPaymentConfirmed(
                $compra,
                $compra->user,
                $data['metodo_pago'],
                $data['referencia_pago'] ?? null
            ));

            Log::info("Webhook de pago procesado exitosamente", [
                'compra_id' => $compra->id,
                'cliente_id' => $compra->user->id,
                'monto' => $data['monto']
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pago procesado exitosamente',
                'compra_id' => $compra->id,
                'estado' => 'facturacion_iniciada'
            ]);

        } catch (\Exception $e) {
            Log::error("Error procesando webhook de pago", [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'request_data' => $request->all()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error interno del servidor',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Webhook para Culqi
     */
    public function webhookCulqi(Request $request): JsonResponse
    {
        try {
            Log::info("Webhook Culqi recibido", [
                'headers' => $request->headers->all(),
                'body' => $request->all()
            ]);

            // Validar firma de Culqi
            if (!$this->validarFirmaCulqi($request)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Firma de Culqi inválida'
                ], 401);
            }

            $data = $request->all();

            // Buscar compra por referencia
            $compra = Compra::where('referencia_pago', $data['id'])->first();

            if (!$compra) {
                Log::warning("Compra no encontrada para referencia Culqi", [
                    'referencia' => $data['id']
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'Compra no encontrada'
                ], 404);
            }

            // Procesar según el estado del cargo
            if ($data['type'] === 'charge.succeeded') {
                return $this->procesarPagoCulqi($compra, $data);
            } elseif ($data['type'] === 'charge.failed') {
                return $this->procesarPagoFallidoCulqi($compra, $data);
            }

            return response()->json([
                'success' => true,
                'message' => 'Webhook procesado'
            ]);

        } catch (\Exception $e) {
            Log::error("Error procesando webhook Culqi", [
                'error' => $e->getMessage(),
                'request_data' => $request->all()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Error interno del servidor'
            ], 500);
        }
    }

    /**
     * Procesar pago exitoso de Culqi
     */
    private function procesarPagoCulqi($compra, $data)
    {
        $compra->update([
            'estado_compra_id' => 3, // Pagada
            'metodo_pago' => 'Culqi',
            'fecha_pago' => now(),
            'referencia_pago' => $data['id']
        ]);

        // Disparar evento
        event(new OnPaymentConfirmed(
            $compra,
            $compra->user,
            'Culqi',
            $data['id']
        ));

        return response()->json([
            'success' => true,
            'message' => 'Pago Culqi procesado exitosamente'
        ]);
    }

    /**
     * Procesar pago fallido de Culqi
     */
    private function procesarPagoFallidoCulqi($compra, $data)
    {
        $compra->update([
            'estado_compra_id' => 4, // Pago fallido
            'observaciones' => 'Pago fallido: ' . ($data['failure_message'] ?? 'Error desconocido')
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Pago fallido registrado'
        ]);
    }

    /**
     * Validar firma del webhook
     */
    private function validarFirmaWebhook(Request $request, string $signature): bool
    {
        $secret = config('services.webhook.secret');
        if (!$secret) {
            return true; // Si no hay secret configurado, permitir
        }

        $payload = $request->getContent();
        $expectedSignature = hash_hmac('sha256', $payload, $secret);

        return hash_equals($expectedSignature, $signature);
    }

    /**
     * Validar firma de Culqi
     */
    private function validarFirmaCulqi(Request $request): bool
    {
        $secret = config('services.culqi.webhook_secret');
        if (!$secret) {
            return true; // Si no hay secret configurado, permitir
        }

        $signature = $request->header('Culqi-Signature');
        $payload = $request->getContent();
        $expectedSignature = hash_hmac('sha256', $payload, $secret);

        return hash_equals($expectedSignature, $signature);
    }
}