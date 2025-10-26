<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{{ $tipo_comprobante }} {{ $numero_completo }}</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            font-size: 12px; 
            margin: 20px;
            line-height: 1.4;
        }
        .header { 
            text-align: center;
            border-bottom: 2px solid #333; 
            padding-bottom: 15px; 
            margin-bottom: 20px;
        }
        .comprobante-titulo { 
            text-align: center; 
            font-size: 16px; 
            font-weight: bold; 
            margin: 15px 0;
            background-color: #f0f0f0;
            padding: 10px;
            border: 1px solid #ccc;
        }
        .info-section {
            margin: 15px 0;
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
        }
        .tabla-productos { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 20px 0; 
        }
        .tabla-productos th, .tabla-productos td { 
            border: 1px solid #ddd; 
            padding: 8px; 
            text-align: left;
        }
        .tabla-productos th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        .totales { 
            float: right; 
            width: 300px; 
            margin-top: 20px;
        }
        .totales table {
            width: 100%;
            border-collapse: collapse;
        }
        .totales td {
            padding: 5px;
            border-bottom: 1px solid #ddd;
        }
        .total-final {
            font-weight: bold;
            font-size: 14px;
            border-top: 2px solid #333 !important;
        }
        .footer { 
            margin-top: 50px; 
            border-top: 1px solid #ccc; 
            padding-top: 15px; 
            font-size: 10px;
            clear: both;
        }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
    </style>
</head>
<body>
    <!-- ENCABEZADO SIMPLIFICADO -->
    <div class="header">
        <h2>{{ $datos_empresa['razon_social'] }}</h2>
        <p><strong>RUC:</strong> {{ $datos_empresa['ruc'] }}</p>
        <p>{{ $datos_empresa['direccion_fiscal'] }}</p>
    </div>

    <!-- TÍTULO DEL COMPROBANTE -->
    <div class="comprobante-titulo">
        {{ $tipo_comprobante }}<br>
        {{ $numero_completo }}
    </div>

    <!-- DATOS DEL CLIENTE -->
    <div class="info-section">
        <strong>Cliente:</strong> {{ $datos_cliente['razon_social'] }}<br>
        <strong>{{ $datos_cliente['tipo_documento'] === '6' ? 'RUC' : 'DNI' }}:</strong> {{ $datos_cliente['numero_documento'] }}<br>
        <strong>Fecha:</strong> {{ \Carbon\Carbon::parse($fecha_emision)->format('d/m/Y') }}
    </div>

    <!-- PRODUCTOS -->
    @if(!empty($productos))
    <table class="tabla-productos">
        <thead>
            <tr>
                <th>Descripción</th>
                <th>Cantidad</th>
                <th>P. Unitario</th>
                <th>IGV</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($productos as $producto)
            <tr>
                <td>{{ $producto['descripcion'] }}</td>
                <td class="text-center">{{ $producto['cantidad'] }}</td>
                <td class="text-right">S/ {{ $producto['precio_unitario'] }}</td>
                <td class="text-right">S/ {{ $producto['igv_linea'] }}</td>
                <td class="text-right">S/ {{ $producto['total_linea'] }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
    @endif

    <!-- TOTALES -->
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
            <tr class="total-final">
                <td><strong>TOTAL:</strong></td>
                <td class="text-right"><strong>S/ {{ $totales['total_numeros'] }}</strong></td>
            </tr>
        </table>
        <div style="margin-top: 10px; font-size: 10px; font-weight: bold;">
            {{ $totales['total_letras'] }}
        </div>
    </div>

    <!-- PIE DE PÁGINA -->
    <div class="footer">
        <div style="background-color: #f9f9f9; padding: 10px; border: 1px solid #ddd;">
            <strong>{{ $info_legal['leyenda_legal'] }}</strong><br>
            <strong>Hash:</strong> {{ $info_legal['hash_xml'] }}<br>
            <strong>Consulte en:</strong> {{ $info_legal['url_consulta'] }}
        </div>
    </div>
</body>
</html>