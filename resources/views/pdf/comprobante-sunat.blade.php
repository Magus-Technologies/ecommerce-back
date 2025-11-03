<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{{ $tipo_comprobante }} {{ $numero_completo }}</title>
    <style>
        /* CSS optimizado para DomPDF - Sin gradientes ni sombras */
        @page {
            margin: 15mm 10mm;
        }

        body {
            font-family: Arial, sans-serif;
            font-size: 9px;
            margin: 0;
            padding: 0;
            line-height: 1.3;
            color: #333;
        }

        .header {
            border-bottom: 2px solid #333;
            padding-bottom: 8px;
            margin-bottom: 10px;
        }

        .header table {
            border-collapse: collapse;
        }

        .header td {
            border: none;
        }

        .comprobante-titulo {
            text-align: center;
            font-size: 16px;
            font-weight: bold;
            margin: 8px 0;
            padding: 8px;
            background-color: #4a5568;
            color: white;
            clear: both;
        }

        .comprobante-titulo .tipo {
            font-size: 14px;
            display: block;
            margin-bottom: 3px;
        }

        .comprobante-titulo .numero {
            font-size: 12px;
            letter-spacing: 1px;
        }

        .cliente-section {
            margin: 8px 0;
            padding: 8px;
            background-color: #f5f5f5;
            border-left: 3px solid #4a5568;
        }

        .cliente-section h3 {
            margin: 0 0 6px 0;
            font-size: 10px;
            color: #000;
            font-weight: bold;
            text-transform: uppercase;
        }

        .cliente-datos {
            display: table;
            width: 100%;
        }

        .cliente-col {
            display: table-cell;
            width: 50%;
            vertical-align: top;
            padding-right: 10px;
        }

        .cliente-col p {
            margin: 3px 0;
            line-height: 1.4;
            font-size: 8px;
        }

        .tabla-productos {
            width: 100%;
            border-collapse: collapse;
            margin: 10px 0;
            font-size: 8px;
        }

        .tabla-productos th,
        .tabla-productos td {
            border: 1px solid #ccc;
            padding: 4px 3px;
            text-align: left;
        }

        .tabla-productos thead {
            background-color: #4a5568;
        }

        .tabla-productos th {
            color: white;
            font-weight: bold;
            text-align: center;
            font-size: 8px;
        }

        .tabla-productos tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .tabla-productos .text-center { text-align: center; }
        .tabla-productos .text-right { text-align: right; }

        .totales-section {
            margin-top: 10px;
            overflow: hidden;
        }

        .totales {
            float: right;
            width: 250px;
            background: white;
            border: 1px solid #ccc;
            padding: 8px;
        }

        .totales table {
            width: 100%;
            border-collapse: collapse;
            font-size: 9px;
        }

        .totales td {
            padding: 4px 6px;
            border-bottom: 1px solid #eee;
        }

        .totales tr:last-child td {
            border-bottom: none;
        }

        .totales .total-final {
            font-weight: bold;
            font-size: 11px;
            border-top: 2px solid #333 !important;
            background-color: #4a5568;
            color: white;
            padding: 6px !important;
        }

        .total-letras {
            margin-top: 8px;
            font-size: 8px;
            font-weight: bold;
            padding: 6px;
            background-color: #f5f5f5;
            border-left: 2px solid #4a5568;
            text-align: left;
        }

        .footer {
            margin-top: 15px;
            border-top: 2px solid #333;
            padding-top: 10px;
            font-size: 8px;
            clear: both;
            overflow: hidden;
        }

        .qr-section {
            float: left;
            width: 100px;
            text-align: center;
            padding: 5px;
            background: white;
            border: 1px solid #ccc;
        }

        .qr-section img {
            max-width: 90px;
            max-height: 90px;
            border: 1px solid #ccc;
        }

        .qr-section p {
            margin: 5px 0 0 0;
            font-size: 7px;
            color: #666;
        }

        .info-legal {
            float: right;
            width: 320px;
            background-color: #f5f5f5;
            padding: 8px;
            border: 1px solid #ccc;
        }

        .info-legal h4 {
            margin: 0 0 6px 0;
            font-size: 9px;
            color: #000;
            font-weight: bold;
            text-transform: uppercase;
            border-bottom: 1px solid #4a5568;
            padding-bottom: 4px;
        }

        .info-legal p {
            margin: 4px 0;
            line-height: 1.3;
            font-size: 7px;
        }

        .info-legal strong {
            color: #000;
        }

        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .text-left { text-align: left; }

        .clearfix { clear: both; }

        /* Evitar saltos de página no deseados */
        .cliente-section,
        .tabla-productos,
        .totales-section {
            page-break-inside: avoid;
        }

        /* Estilos para impresión */
        @media print {
            body { margin: 0; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>
    <!-- ENCABEZADO CON DATOS EMPRESA -->
    <div class="header">
        <table style="width: 100%; border: 0;">
            <tr>
                <td style="width: 100px; vertical-align: top; padding: 0;">
                    @if(!empty($datos_empresa['logo_path']) && file_exists($datos_empresa['logo_path']))
                        <img src="{{ $datos_empresa['logo_path'] }}" alt="Logo" style="max-width: 70px; max-height: 60px; border: 1px solid #ccc;">
                    @endif
                </td>
                <td style="vertical-align: top; text-align: center; padding: 0 10px;">
                    <h2 style="margin: 0 0 4px 0; font-size: 14px; color: #000; font-weight: bold;">{{ $datos_empresa['razon_social'] }}</h2>
                    <p style="margin: 2px 0; font-size: 11px; font-weight: bold; color: #c00;">RUC: {{ $datos_empresa['ruc'] }}</p>
                    <p style="margin: 2px 0; font-size: 8px; color: #333;">{{ $datos_empresa['direccion_fiscal'] }}</p>
                    @if(!empty($datos_empresa['distrito']) && !empty($datos_empresa['provincia']))
                        <p style="margin: 2px 0; font-size: 8px; color: #333;">{{ $datos_empresa['distrito'] }} - {{ $datos_empresa['provincia'] }}@if(!empty($datos_empresa['departamento'])) - {{ $datos_empresa['departamento'] }}@endif</p>
                    @endif
                </td>
                <td style="width: 150px; vertical-align: top; text-align: right; padding: 0; font-size: 8px;">
                    @if(!empty($datos_empresa['telefono']))
                        <p style="margin: 2px 0;">Tel: {{ $datos_empresa['telefono'] }}</p>
                    @endif
                    @if(!empty($datos_empresa['email']))
                        <p style="margin: 2px 0;">{{ $datos_empresa['email'] }}</p>
                    @endif
                    @if(!empty($datos_empresa['web']))
                        <p style="margin: 2px 0;">{{ $datos_empresa['web'] }}</p>
                    @endif
                </td>
            </tr>
        </table>
    </div>

    <!-- TÍTULO ESPECÍFICO DEL COMPROBANTE -->
    <div class="comprobante-titulo">
        <span class="tipo">{{ $tipo_comprobante }}</span>
        <span class="numero">{{ $numero_completo }}</span>
    </div>

    <!-- DATOS DEL CLIENTE -->
    <div class="cliente-section">
        <h3>DATOS DEL CLIENTE</h3>
        <div class="cliente-datos">
            <div class="cliente-col">
                <p><strong>Cliente:</strong> {{ $datos_cliente['razon_social'] }}</p>
                <p><strong>{{ $datos_cliente['tipo_documento'] === '6' ? 'RUC' : 'DNI' }}:</strong> {{ $datos_cliente['numero_documento'] }}</p>
            </div>
            <div class="cliente-col">
                <p><strong>Dirección:</strong> {{ $datos_cliente['direccion'] }}</p>
                <p><strong>Fecha Emisión:</strong> {{ \Carbon\Carbon::parse($fecha_emision)->format('d/m/Y') }}</p>
            </div>
        </div>
    </div>

    <!-- DETALLE DE PRODUCTOS -->
    @if(!empty($productos))
    <table class="tabla-productos">
        <thead>
            <tr>
                <th style="width: 8%;">Cód.</th>
                <th style="width: 38%;">Descripción</th>
                <th style="width: 7%;">Und.</th>
                <th style="width: 7%;">Cant.</th>
                <th style="width: 13%;">P. Unit.</th>
                <th style="width: 13%;">V. Venta</th>
                <th style="width: 14%;">Total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($productos as $producto)
            <tr>
                <td class="text-center">{{ $producto['codigo'] }}</td>
                <td>{{ $producto['descripcion'] }}</td>
                <td class="text-center">{{ $producto['unidad_medida'] }}</td>
                <td class="text-center">{{ $producto['cantidad'] }}</td>
                <td class="text-right">S/ {{ $producto['precio_unitario'] }}</td>
                <td class="text-right">S/ {{ $producto['valor_venta'] }}</td>
                <td class="text-right">S/ {{ $producto['total_linea'] }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
    @endif

    <!-- TOTALES DETALLADOS -->
    <div class="totales-section">
        <div class="totales">
            <table>
                <tr>
                    <td><strong>Operación Gravada:</strong></td>
                    <td class="text-right"><strong>S/ {{ $totales['operacion_gravada'] }}</strong></td>
                </tr>
                <tr>
                    <td><strong>IGV (18%):</strong></td>
                    <td class="text-right"><strong>S/ {{ $totales['igv_18'] }}</strong></td>
                </tr>
                @if(!empty($totales['descuentos']))
                <tr>
                    <td><strong>Descuento:</strong></td>
                    <td class="text-right"><strong>- S/ {{ $totales['descuentos'] }}</strong></td>
                </tr>
                @endif
                <tr class="total-final">
                    <td><strong>TOTAL:</strong></td>
                    <td class="text-right"><strong>S/ {{ $totales['total_numeros'] }}</strong></td>
                </tr>
            </table>
            
            <div class="total-letras">
                {{ $totales['total_letras'] }}
            </div>
        </div>
        <div class="clearfix"></div>
    </div>

    <!-- PIE DE PÁGINA CON INFORMACIÓN LEGAL -->
    <div class="footer">
        <div class="qr-section">
            @if(!empty($codigo_qr))
                @php
                    // El QR viene como binario, necesita codificarse para data URL
                    if (strpos($codigo_qr, '<svg') === 0) {
                        // Es SVG, renderizar directamente
                        $qrOutput = $codigo_qr;
                    } else {
                        // Es imagen PNG binaria, codificar a base64
                        $qrBase64 = is_string($codigo_qr) && !ctype_print($codigo_qr)
                            ? base64_encode($codigo_qr)
                            : $codigo_qr;
                        $qrOutput = '<img src="data:image/png;base64,' . $qrBase64 . '" alt="Código QR" style="max-width: 90px; max-height: 90px;">';
                    }
                @endphp
                {!! $qrOutput !!}
                <p><strong>Código QR SUNAT</strong></p>
            @else
                <div style="width: 80px; height: 80px; border: 1px dashed #999; text-align: center; line-height: 20px; font-size: 8px; padding: 5px; background-color: #fafafa;">
                    <strong>Código QR</strong><br>
                    SUNAT
                </div>
            @endif
        </div>

        <div class="info-legal">
            <h4>INFORMACIÓN LEGAL</h4>
            <p><strong>{{ $info_legal['leyenda_legal'] }}</strong></p>
            <p><strong>Hash:</strong> {{ substr($info_legal['hash_xml'], 0, 50) }}...</p>
            <p><strong>Consulte:</strong> https://e-consultaruc.sunat.gob.pe</p>
            @if(!empty($info_legal['estado_cdr']))
                <p><strong>Estado:</strong> {{ $info_legal['estado_cdr'] }}</p>
            @endif
            <p><strong>Generado:</strong> {{ now()->format('d/m/Y H:i') }}</p>
        </div>
        <div class="clearfix"></div>
    </div>
</body>
</html>