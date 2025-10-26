<?php

namespace App\Services;

use App\Models\Comprobante;
use App\Models\Venta;
use App\Models\NotaCredito;
use App\Models\NotaDebito;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

/**
 * Servicio de Exportación a formato TXT
 * Genera archivos de texto plano según los formatos del PLE (Programa de Libros Electrónicos) de SUNAT
 */
class ExportacionTxtService
{
    /**
     * Exportar Registro de Ventas e Ingresos (Formato 14.1)
     * Según las especificaciones de SUNAT para PLE
     *
     * @param string $periodo Período en formato YYYYMM (ejemplo: 202501)
     * @param string $ruc RUC del contribuyente
     * @return array
     */
    public function exportarRegistroVentas($periodo, $ruc)
    {
        try {
            // Parsear período
            $year = substr($periodo, 0, 4);
            $month = substr($periodo, 4, 2);

            $fechaInicio = Carbon::createFromFormat('Y-m-d', "{$year}-{$month}-01")->startOfMonth();
            $fechaFin = Carbon::createFromFormat('Y-m-d', "{$year}-{$month}-01")->endOfMonth();

            // Obtener comprobantes del período
            $comprobantes = Comprobante::whereBetween('fecha_emision', [
                $fechaInicio->format('Y-m-d'),
                $fechaFin->format('Y-m-d')
            ])
            ->whereIn('estado', ['ACEPTADO', 'ANULADO'])
            ->orderBy('fecha_emision')
            ->orderBy('serie')
            ->orderBy('correlativo')
            ->get();

            // Generar contenido TXT
            $contenido = $this->generarContenidoRegistroVentas($comprobantes, $periodo, $ruc);

            // Generar nombre de archivo según formato SUNAT
            // LE + RUC + AAAAMMDD + LIBRO + CODIGO_OPORTUNIDAD + INDICADOR_OPERACION + CONTENIDO + MONEDA + INDICADOR_LIBRO + .txt
            $fechaGeneracion = now()->format('Ymd');
            $nombreArchivo = "LE{$ruc}{$periodo}00140100001111.txt";

            return [
                'success' => true,
                'contenido' => $contenido,
                'nombre_archivo' => $nombreArchivo,
                'total_registros' => count($comprobantes),
                'periodo' => $periodo
            ];

        } catch (\Exception $e) {
            Log::error('Error exportando registro de ventas TXT: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Generar contenido del archivo TXT para Registro de Ventas (Formato 14.1)
     */
    private function generarContenidoRegistroVentas($comprobantes, $periodo, $ruc)
    {
        $lineas = [];
        $correlativo = 1;

        foreach ($comprobantes as $comprobante) {
            // Formato 14.1 tiene 41 campos separados por |
            $campos = [
                // Campo 1: Período
                $periodo . '00',

                // Campo 2: Correlativo único (CUO)
                str_pad($correlativo, 10, '0', STR_PAD_LEFT),

                // Campo 3: Correlativo del asiento contable (M)
                'M' . str_pad($correlativo, 9, '0', STR_PAD_LEFT),

                // Campo 4: Fecha de emisión
                Carbon::parse($comprobante->fecha_emision)->format('d/m/Y'),

                // Campo 5: Fecha de vencimiento o pago
                Carbon::parse($comprobante->fecha_emision)->format('d/m/Y'),

                // Campo 6: Tipo de comprobante (01=Factura, 03=Boleta, 07=NC, 08=ND)
                $comprobante->tipo_comprobante,

                // Campo 7: Serie del comprobante
                $comprobante->serie,

                // Campo 8: Número del comprobante
                str_pad($comprobante->correlativo, 8, '0', STR_PAD_LEFT),

                // Campo 9: Número final (en rango, sino vacio)
                '',

                // Campo 10: Tipo de documento del cliente
                $this->convertirTipoDocumento($comprobante->cliente_tipo_documento),

                // Campo 11: Número de documento del cliente
                $comprobante->cliente_numero_documento ?? '',

                // Campo 12: Apellidos y nombres o denominación
                $this->limpiarTexto($comprobante->cliente_razon_social ?? ''),

                // Campo 13: Valor facturado de exportación (si aplica)
                '0.00',

                // Campo 14: Base imponible operaciones gravadas
                number_format($comprobante->operacion_gravada ?? 0, 2, '.', ''),

                // Campo 15: Descuento base imponible
                '0.00',

                // Campo 16: IGV
                number_format($comprobante->total_igv ?? 0, 2, '.', ''),

                // Campo 17: Descuento IGV
                '0.00',

                // Campo 18: Importe exonerado
                number_format($comprobante->operacion_exonerada ?? 0, 2, '.', ''),

                // Campo 19: Importe inafecto
                number_format($comprobante->operacion_inafecta ?? 0, 2, '.', ''),

                // Campo 20: ISC (Impuesto Selectivo al Consumo)
                '0.00',

                // Campo 21: Base imponible arroz pilado
                '0.00',

                // Campo 22: Impuesto arroz pilado
                '0.00',

                // Campo 23: ICBPER (Impuesto bolsas plásticas)
                number_format($comprobante->total_icbper ?? 0, 2, '.', ''),

                // Campo 24: Otros cargos
                '0.00',

                // Campo 25: Importe total
                number_format($comprobante->importe_total ?? 0, 2, '.', ''),

                // Campo 26: Código de moneda (PEN=S/, USD=$)
                $comprobante->moneda ?? 'PEN',

                // Campo 27: Tipo de cambio (si es USD)
                '1.000',

                // Campo 28: Fecha emisión documento modificado (para NC/ND)
                $this->obtenerFechaDocumentoModificado($comprobante),

                // Campo 29: Tipo documento modificado
                $this->obtenerTipoDocumentoModificado($comprobante),

                // Campo 30: Serie documento modificado
                $this->obtenerSerieDocumentoModificado($comprobante),

                // Campo 31: Número documento modificado
                $this->obtenerNumeroDocumentoModificado($comprobante),

                // Campo 32: Identificación contrato o proyecto
                '',

                // Campo 33: Error tipo 1
                '',

                // Campo 34: Indicador comprobante cancelación
                '1', // 1=Cancelado

                // Campo 35: Estado (0=Activo, 1=Anulado, 8=Anulado error SUNAT, 9=Anulado otros)
                $comprobante->estado === 'ANULADO' ? '1' : '0',

                // Campo 36-41: Campos adicionales (vacíos por defecto)
                '', '', '', '', '', ''
            ];

            // Unir campos con pipe |
            $lineas[] = implode('|', $campos) . '|';
            $correlativo++;
        }

        return implode("\n", $lineas);
    }

    /**
     * Exportar Registro de Compras (Formato 8.1)
     */
    public function exportarRegistroCompras($periodo, $ruc)
    {
        try {
            $year = substr($periodo, 0, 4);
            $month = substr($periodo, 4, 2);

            $fechaInicio = Carbon::createFromFormat('Y-m-d', "{$year}-{$month}-01")->startOfMonth();
            $fechaFin = Carbon::createFromFormat('Y-m-d', "{$year}-{$month}-01")->endOfMonth();

            // Obtener compras del período
            $compras = \App\Models\Compra::whereBetween('fecha_emision', [
                $fechaInicio->format('Y-m-d'),
                $fechaFin->format('Y-m-d')
            ])
            ->orderBy('fecha_emision')
            ->get();

            $contenido = $this->generarContenidoRegistroCompras($compras, $periodo, $ruc);

            $fechaGeneracion = now()->format('Ymd');
            $nombreArchivo = "LE{$ruc}{$periodo}00080100001111.txt";

            return [
                'success' => true,
                'contenido' => $contenido,
                'nombre_archivo' => $nombreArchivo,
                'total_registros' => count($compras),
                'periodo' => $periodo
            ];

        } catch (\Exception $e) {
            Log::error('Error exportando registro de compras TXT: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Generar contenido del archivo TXT para Registro de Compras (Formato 8.1)
     */
    private function generarContenidoRegistroCompras($compras, $periodo, $ruc)
    {
        $lineas = [];
        $correlativo = 1;

        foreach ($compras as $compra) {
            $campos = [
                // Campo 1: Período
                $periodo . '00',

                // Campo 2: Correlativo único
                str_pad($correlativo, 10, '0', STR_PAD_LEFT),

                // Campo 3: Correlativo asiento contable
                'M' . str_pad($correlativo, 9, '0', STR_PAD_LEFT),

                // Campo 4: Fecha de emisión
                Carbon::parse($compra->fecha_emision)->format('d/m/Y'),

                // Campo 5: Fecha de vencimiento
                Carbon::parse($compra->fecha_emision)->format('d/m/Y'),

                // Campo 6: Tipo de comprobante
                $compra->tipo_comprobante ?? '01',

                // Campo 7: Serie
                $compra->serie ?? '',

                // Campo 8: Año DUA o DSI
                '',

                // Campo 9: Número del comprobante
                $compra->numero_comprobante ?? '',

                // Campo 10: Número final (rango)
                '',

                // Campo 11: Tipo documento proveedor
                $compra->proveedor_tipo_documento ?? '6',

                // Campo 12: Número documento proveedor
                $compra->proveedor_ruc ?? '',

                // Campo 13: Apellidos y nombres
                $this->limpiarTexto($compra->proveedor_razon_social ?? ''),

                // Campo 14-37: Montos y valores (base imponible, IGV, etc.)
                number_format($compra->base_imponible ?? 0, 2, '.', ''),
                number_format($compra->igv ?? 0, 2, '.', ''),
                '0.00', '0.00', '0.00', '0.00',
                number_format($compra->total ?? 0, 2, '.', ''),
                $compra->moneda ?? 'PEN',
                '1.000',
                '', '', '', '', '', '', '', '', '', '', '', '', '', '',

                // Campo 38: Estado
                $compra->estado === 'ANULADO' ? '1' : '0',

                // Campos finales
                '', '', ''
            ];

            $lineas[] = implode('|', $campos) . '|';
            $correlativo++;
        }

        return implode("\n", $lineas);
    }

    /**
     * Exportar Libro Diario (Formato 5.1)
     */
    public function exportarLibroDiario($periodo, $ruc)
    {
        try {
            $contenido = ""; // Implementación simplificada
            $nombreArchivo = "LE{$ruc}{$periodo}00050100001111.txt";

            return [
                'success' => true,
                'contenido' => $contenido,
                'nombre_archivo' => $nombreArchivo,
                'mensaje' => 'Libro Diario - Formato simplificado'
            ];

        } catch (\Exception $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    // ===== MÉTODOS AUXILIARES =====

    /**
     * Convertir tipo de documento del cliente al código SUNAT
     */
    private function convertirTipoDocumento($tipo)
    {
        $mapeo = [
            '0' => '0',  // Sin documento
            '1' => '1',  // DNI
            '4' => '4',  // Carnet de extranjería
            '6' => '6',  // RUC
            '7' => '7',  // Pasaporte
        ];

        return $mapeo[$tipo] ?? '0';
    }

    /**
     * Limpiar texto para formato TXT (sin caracteres especiales)
     */
    private function limpiarTexto($texto)
    {
        // Remover caracteres especiales y pipes
        $texto = str_replace(['|', "\n", "\r", "\t"], ' ', $texto);

        // Convertir caracteres especiales
        $texto = mb_strtoupper($texto, 'UTF-8');

        return trim($texto);
    }

    /**
     * Obtener fecha del documento modificado (para NC/ND)
     */
    private function obtenerFechaDocumentoModificado($comprobante)
    {
        if (in_array($comprobante->tipo_comprobante, ['07', '08'])) {
            if ($comprobante->comprobanteReferencia) {
                return Carbon::parse($comprobante->comprobanteReferencia->fecha_emision)->format('d/m/Y');
            }
        }
        return '';
    }

    /**
     * Obtener tipo del documento modificado
     */
    private function obtenerTipoDocumentoModificado($comprobante)
    {
        if (in_array($comprobante->tipo_comprobante, ['07', '08'])) {
            return $comprobante->comprobanteReferencia->tipo_comprobante ?? '';
        }
        return '';
    }

    /**
     * Obtener serie del documento modificado
     */
    private function obtenerSerieDocumentoModificado($comprobante)
    {
        if (in_array($comprobante->tipo_comprobante, ['07', '08'])) {
            return $comprobante->comprobanteReferencia->serie ?? '';
        }
        return '';
    }

    /**
     * Obtener número del documento modificado
     */
    private function obtenerNumeroDocumentoModificado($comprobante)
    {
        if (in_array($comprobante->tipo_comprobante, ['07', '08'])) {
            if ($comprobante->comprobanteReferencia) {
                return str_pad($comprobante->comprobanteReferencia->correlativo, 8, '0', STR_PAD_LEFT);
            }
        }
        return '';
    }

    /**
     * Exportar reporte de ventas simple en TXT
     */
    public function exportarReporteVentasSimple($fechaInicio, $fechaFin)
    {
        try {
            $ventas = Venta::whereBetween('created_at', [$fechaInicio, $fechaFin])
                ->with(['cliente', 'detalles.producto'])
                ->orderBy('created_at')
                ->get();

            $lineas = [];
            $lineas[] = "REPORTE DE VENTAS";
            $lineas[] = "Período: {$fechaInicio} al {$fechaFin}";
            $lineas[] = str_repeat("=", 120);
            $lineas[] = "";

            $formato = "%-12s %-20s %-40s %15s %15s";
            $lineas[] = sprintf($formato, "FECHA", "NÚMERO", "CLIENTE", "SUBTOTAL", "TOTAL");
            $lineas[] = str_repeat("-", 120);

            $totalGeneral = 0;
            foreach ($ventas as $venta) {
                $lineas[] = sprintf(
                    $formato,
                    Carbon::parse($venta->created_at)->format('d/m/Y'),
                    $venta->codigo_venta ?? $venta->id,
                    mb_substr($venta->cliente->razon_social ?? 'PÚBLICO GENERAL', 0, 40),
                    'S/ ' . number_format($venta->subtotal, 2),
                    'S/ ' . number_format($venta->total, 2)
                );
                $totalGeneral += $venta->total;
            }

            $lineas[] = str_repeat("-", 120);
            $lineas[] = sprintf($formato, "", "", "TOTAL GENERAL:", "", "S/ " . number_format($totalGeneral, 2));
            $lineas[] = "";
            $lineas[] = "Total de ventas: " . count($ventas);
            $lineas[] = "Generado: " . now()->format('d/m/Y H:i:s');

            $contenido = implode("\n", $lineas);
            $nombreArchivo = "reporte-ventas-{$fechaInicio}-{$fechaFin}.txt";

            return [
                'success' => true,
                'contenido' => $contenido,
                'nombre_archivo' => $nombreArchivo,
                'total_registros' => count($ventas),
                'total_monto' => $totalGeneral
            ];

        } catch (\Exception $e) {
            Log::error('Error exportando reporte de ventas TXT: ' . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
}
