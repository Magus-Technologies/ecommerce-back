<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{{ $tipo_comprobante }} {{ $numero_completo }}</title>
    <style>
        /* CSS optimizado para DomPDF */
        body { 
            font-family: Arial, sans-serif; 
            font-size: 12px; 
            margin: 0;
            padding: 20px;
            line-height: 1.4;
        }
        
        .header { 
            border-bottom: 2px solid #333; 
            padding-bottom: 15px; 
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .empresa-logo { 
            float: left; 
            width: 120px; 
            margin-right: 20px;
        }
        
        .empresa-logo img {
            max-width: 100px;
            max-height: 80px;
        }
        
        .empresa-datos { 
            float: right; 
            text-align: right; 
            width: 300px;
        }
        
        .empresa-datos h2 {
            margin: 0 0 5px 0;
            font-size: 16px;
            color: #333;
        }
        
        .empresa-datos p {
            margin: 2px 0;
            font-size: 11px;
        }
        
        .comprobante-titulo { 
            text-align: center; 
            font-size: 18px; 
            font-weight: bold; 
            margin: 20px 0;
            padding: 15px;
            background-color: #f0f0f0;
            border: 2px solid #333;
            clear: both;
        }
        
        .cliente-section {
            margin: 20px 0;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
        }
        
        .cliente-section h3 {
            margin: 0 0 10px 0;
            font-size: 14px;
            color: #333;
        }
        
        .cliente-datos {
            display: table;
            width: 100%;
        }
        
        .cliente-col {
            display: table-cell;
            width: 50%;
            vertical-align: top;
            padding-right: 20px;
        }
        
        .tabla-productos { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 20px 0; 
            font-size: 11px;
        }
        
        .tabla-productos th, .tabla-productos td { 
            border: 1px solid #ddd; 
            padding: 8px; 
            text-align: left;
        }
        
        .tabla-productos th {
            background-color: #f2f2f2;
            font-weight: bold;
            text-align: center;
        }
        
        .tabla-productos .text-center { text-align: center; }
        .tabla-productos .text-right { text-align: right; }
        
        .totales-section {
            margin-top: 30px;
            overflow: hidden;
        }
        
        .totales { 
            float: right; 
            width: 350px; 
        }
        
        .totales table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        
        .totales td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }
        
        .totales .total-final {
            font-weight: bold;
            font-size: 14px;
            border-top: 2px solid #333 !important;
            background-color: #f0f0f0;
        }
        
        .total-letras {
            margin-top: 10px;
            font-size: 10px;
            font-weight: bold;
            padding: 8px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            text-align: center;
        }
        
        .footer { 
            margin-top: 50px; 
            border-top: 2px solid #333; 
            padding-top: 20px; 
            font-size: 10px;
            clear: both;
            overflow: hidden;
        }
        
        .qr-section { 
            float: left; 
            width: 150px;
            text-align: center;
        }
        
        .qr-section img {
            max-width: 120px;
            max-height: 120px;
        }
        
        .info-legal { 
            float: right; 
            width: 400px;
            background-color: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
        }
        
        .info-legal h4 {
            margin: 0 0 10px 0;
            font-size: 12px;
            color: #333;
        }
        
        .info-legal p {
            margin: 5px 0;
            line-height: 1.3;
        }
        
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .text-left { text-align: left; }
        
        .clearfix { clear: both; }
        
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
        @if(!empty($datos_empresa['logo_path']) && file_exists($datos_empresa['logo_path']))
        <div class="empresa-logo">
            <img src="{{ $datos_empresa['logo_path'] }}" alt="Logo Empresa">
        </div>
        @endif
        
        <div class="empresa-datos">
            <h2>{{ $datos_empresa['razon_social'] }}</h2>
            <p><strong>RUC:</strong> {{ $datos_empresa['ruc'] }}</p>
            <p>{{ $datos_empresa['direccion_fiscal'] }}</p>
            @if(!empty($datos_empresa['distrito']))
                <p>{{ $datos_empresa['distrito'] }} - {{ $datos_empresa['provincia'] }} - {{ $datos_empresa['departamento'] }}</p>
            @endif
            @if(!empty($datos_empresa['telefono']))
                <p><strong>Tel:</strong> {{ $datos_empresa['telefono'] }}</p>
            @endif
            @if(!empty($datos_empresa['email']))
                <p><strong>Email:</strong> {{ $datos_empresa['email'] }}</p>
            @endif
            @if(!empty($datos_empresa['web']))
                <p><strong>Web:</strong> {{ $datos_empresa['web'] }}</p>
            @endif
        </div>
        <div class="clearfix"></div>
    </div>

    <!-- TÍTULO ESPECÍFICO DEL COMPROBANTE -->
    <div class="comprobante-titulo">
        {{ $tipo_comprobante }}<br>
        {{ $numero_completo }}
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
                <th style="width: 10%;">Código</th>
                <th style="width: 35%;">Descripción</th>
                <th style="width: 8%;">Unidad</th>
                <th style="width: 8%;">Cantidad</th>
                <th style="width: 12%;">P. Unitario</th>
                <th style="width: 12%;">Valor Venta</th>
                <th style="width: 10%;">IGV</th>
                <th style="width: 12%;">Total</th>
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
                <td class="text-right">S/ {{ $producto['igv_linea'] }}</td>
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
                @if(strpos($codigo_qr, '<svg') === 0)
                    <!-- QR como SVG -->
                    {!! $codigo_qr !!}
                @else
                    <!-- QR como imagen PNG -->
                    <img src="data:image/png;base64,{{ base64_encode($codigo_qr) }}" alt="Código QR">
                @endif
                <p><strong>Código QR</strong><br>Consulta SUNAT</p>
            @else
                <div style="width: 120px; height: 120px; border: 2px solid #333; text-align: center; line-height: 30px; font-size: 10px; padding: 10px;">
                    <strong>Código QR</strong><br>
                    SUNAT<br>
                    Consulta online
                </div>
            @endif
        </div>
        
        <div class="info-legal">
            <h4>INFORMACIÓN LEGAL</h4>
            <p><strong>{{ $info_legal['leyenda_legal'] }}</strong></p>
            <p><strong>Hash del XML:</strong> {{ $info_legal['hash_xml'] }}</p>
            <p><strong>Consulte la validez en:</strong><br>{{ $info_legal['url_consulta'] }}</p>
            @if(!empty($info_legal['estado_cdr']))
                <p><strong>Estado CDR:</strong> {{ $info_legal['estado_cdr'] }}</p>
            @endif
            <p><strong>Fecha de generación:</strong> {{ now()->format('d/m/Y H:i:s') }}</p>
        </div>
        <div class="clearfix"></div>
    </div>
</body>
</html>