<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class GuiaRemision extends Model
{
    use HasFactory;

    protected $table = 'guias_remision';

    protected $fillable = [
        'tipo_comprobante',
        'serie',
        'correlativo',
        'fecha_emision',
        'fecha_inicio_traslado',
        'cliente_id',
        'cliente_tipo_documento',
        'cliente_numero_documento',
        'cliente_razon_social',
        'cliente_direccion',
        'destinatario_tipo_documento',
        'destinatario_numero_documento',
        'destinatario_razon_social',
        'destinatario_direccion',
        'destinatario_ubigeo',
        'motivo_traslado',
        'modalidad_traslado',
        'peso_total',
        'numero_bultos',
        'modo_transporte',
        'numero_placa',
        'numero_licencia',
        'conductor_dni',
        'conductor_nombres',
        'punto_partida_ubigeo',
        'punto_partida_direccion',
        'punto_llegada_ubigeo',
        'punto_llegada_direccion',
        'observaciones',
        'estado',
        'xml_firmado',
        'xml_respuesta_sunat',
        'mensaje_sunat',
        'codigo_hash',
        'numero_ticket',
        'fecha_aceptacion',
        'errores_sunat',
        'user_id',
        'created_at',
        'updated_at'
    ];

    protected $casts = [
        'fecha_emision' => 'date',
        'fecha_inicio_traslado' => 'date',
        'fecha_aceptacion' => 'datetime',
        'peso_total' => 'decimal:2',
        'numero_bultos' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    // Relaciones
    public function cliente()
    {
        return $this->belongsTo(Cliente::class);
    }

    public function detalles()
    {
        return $this->hasMany(GuiaRemisionDetalle::class);
    }

    public function usuario()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    // Accessors
    public function getNumeroCompletoAttribute()
    {
        return $this->serie . '-' . str_pad($this->correlativo, 8, '0', STR_PAD_LEFT);
    }

    public function getTipoComprobanteNombreAttribute()
    {
        return 'Guía de Remisión';
    }

    public function getEstadoNombreAttribute()
    {
        $estados = [
            'PENDIENTE' => 'Pendiente',
            'ENVIADO' => 'Enviado',
            'ACEPTADO' => 'Aceptado',
            'RECHAZADO' => 'Rechazado',
            'ANULADO' => 'Anulado'
        ];

        return $estados[$this->estado] ?? 'Desconocido';
    }

    // Scopes
    public function scopeActivas($query)
    {
        return $query->whereIn('estado', ['PENDIENTE', 'ENVIADO', 'ACEPTADO']);
    }

    public function scopePorEstado($query, $estado)
    {
        return $query->where('estado', $estado);
    }

    public function scopePorFecha($query, $fechaInicio, $fechaFin = null)
    {
        $query->whereDate('fecha_emision', '>=', $fechaInicio);
        
        if ($fechaFin) {
            $query->whereDate('fecha_emision', '<=', $fechaFin);
        }
        
        return $query;
    }

    // Métodos de utilidad
    public function puedeEnviar()
    {
        return $this->estado === 'PENDIENTE';
    }

    public function puedeReenviar()
    {
        return in_array($this->estado, ['RECHAZADO', 'PENDIENTE']);
    }

    public function puedeAnular()
    {
        return in_array($this->estado, ['PENDIENTE', 'ACEPTADO']);
    }

    public function tieneArchivos()
    {
        return !empty($this->xml_firmado) || !empty($this->xml_respuesta_sunat);
    }

    // Métodos estáticos
    public static function tiposComprobante()
    {
        return [
            '09' => 'Guía de Remisión'
        ];
    }

    public static function modalidadesTraslado()
    {
        return [
            '01' => 'Venta',
            '02' => 'Compra',
            '04' => 'Traslado entre establecimientos de la misma empresa',
            '08' => 'Importación',
            '09' => 'Exportación',
            '13' => 'Otros'
        ];
    }

    public static function modosTransporte()
    {
        return [
            '01' => 'Transporte público',
            '02' => 'Transporte privado'
        ];
    }
}
