<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $comprobante->tipo_comprobante === '01' ? 'Factura' : 'Boleta' }} - {{ $comprobante->numero_completo }}</title>
    <style>
        @page {
            margin: 20px;
            size: A4;
        }
        
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #333;
            font-size: 12px;
            line-height: 1.4;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #2c5aa0;
            padding-bottom: 20px;
        }
        
        .company-name {
            font-size: 24px;
            font-weight: bold;
            color: #2c5aa0;
            margin-bottom: 5px;
        }
        
        .company-details {
            font-size: 10px;
            color: #666;
        }
        
        .document-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        
        .document-title {
            font-size: 20px;
            font-weight: bold;
            color: #2c5aa0;
        }
        
        .document-number {
            font-size: 16px;
            font-weight: bold;
        }
        
        .client-info {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-weight: bold;
            color: #2c5aa0;
            margin-bottom: 10px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
        }
        
        .details-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        
        .details-table th,
        .details-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        
        .details-table th {
            background-color: #f5f5f5;
            font-weight: bold;
        }
        
        .totals {
            float: right;
            width: 300px;
            margin-top: 20px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        
        .total-final {
            font-weight: bold;
            font-size: 14px;
            border-top: 2px solid #2c5aa0;
            padding-top: 10px;
            margin-top: 10px;
        }
        
        .footer {
            margin-top: 50px;
            text-align: center;
            font-size: 10px;
            color: #666;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="company-name">{{ $empresa['nombre'] }}</div>
        <div class="company-details">
            RUC: {{ $empresa['ruc'] }}<br>
            {{ $empresa['direccion'] }}
        </div>
    </div>

    <!-- Document Info -->
    <div class="document-info">
        <div>
            <div class="document-title">
                {{ $comprobante->tipo_comprobante === '01' ? 'FACTURA ELECTRÓNICA' : 'BOLETA DE VENTA ELECTRÓNICA' }}
            </div>
            <div class="document-number">{{ $comprobante->numero_completo }}</div>
        </div>
        <div>
            <strong>Fecha de Emisión:</strong><br>
            {{ \Carbon\Carbon::parse($comprobante->fecha_emision)->format('d/m/Y') }}
        </div>
    </div>

    <!-- Client Info -->
    <div class="client-info">
        <div class="section-title">DATOS DEL CLIENTE</div>
        <strong>{{ $comprobante->cliente_razon_social }}</strong><br>
        {{ $comprobante->cliente_tipo_documento === '6' ? 'RUC' : 'DNI' }}: {{ $comprobante->cliente_numero_documento }}<br>
        {{ $comprobante->cliente_direccion }}
    </div>

    <!-- Details Table -->
    <div class="section-title">DETALLE DE PRODUCTOS/SERVICIOS</div>
    <table class="details-table">
        <thead>
            <tr>
                <th>Item</th>
                <th>Código</th>
                <th>Descripción</th>
                <th>Cantidad</th>
                <th>Precio Unit.</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($detalles as $detalle)
            <tr>
                <td>{{ $detalle->item }}</td>
                <td>{{ $detalle->codigo_producto }}</td>
                <td>{{ $detalle->descripcion }}</td>
                <td>{{ number_format($detalle->cantidad, 2) }}</td>
                <td>S/ {{ number_format($detalle->precio_unitario, 2) }}</td>
                <td>S/ {{ number_format($detalle->precio_total, 2) }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <!-- Totals -->
    <div class="totals">
        <div class="total-row">
            <span>Subtotal:</span>
            <span>S/ {{ number_format($comprobante->operacion_gravada, 2) }}</span>
        </div>
        <div class="total-row">
            <span>IGV (18%):</span>
            <span>S/ {{ number_format($comprobante->total_igv, 2) }}</span>
        </div>
        <div class="total-row total-final">
            <span>TOTAL:</span>
            <span>S/ {{ number_format($comprobante->importe_total, 2) }}</span>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>Este documento ha sido generado electrónicamente por el sistema de facturación.</p>
        <p>Representación impresa de un comprobante electrónico.</p>
    </div>
</body>
</html>
