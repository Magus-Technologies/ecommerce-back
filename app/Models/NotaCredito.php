<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NotaCredito extends Model
{
    use HasFactory;

    protected $fillable = [
        'comprobante_referencia_id',
        'tipo_nota_credito',
        'motivo',
        'descripcion',
        'serie',
        'numero',
        'numero_completo',
        'fecha_emision',
        'hora_emision',
        'subtotal',
        'total_igv',
        'total',
        'moneda',
        'estado',
        'user_id'
    ];

    protected $casts = [
        'fecha_emision' => 'date',
        'hora_emision' => 'datetime',
        'subtotal' => 'decimal:2',
        'total_igv' => 'decimal:2',
        'total' => 'decimal:2',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    // Relaciones
    public function comprobanteReferencia()
    {
        return $this->belongsTo(Comprobante::class, 'comprobante_referencia_id');
    }

    public function comprobante()
    {
        // Relación con el comprobante generado para esta nota de crédito
        return $this->hasOne(Comprobante::class, 'nota_credito_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Scopes
    public function scopePendientes($query)
    {
        return $query->where('estado', 'PENDIENTE');
    }

    public function scopeEnviadas($query)
    {
        return $query->where('estado', 'ENVIADO');
    }

    public function scopeAceptadas($query)
    {
        return $query->where('estado', 'ACEPTADO');
    }

    // Accessors
    public function getTipoNotaCreditoNombreAttribute()
    {
        $tipos = [
            '07' => 'Nota de Crédito'
        ];

        return $tipos[$this->tipo_nota_credito] ?? 'Desconocido';
    }
}
