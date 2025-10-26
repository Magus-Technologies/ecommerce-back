<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NotificacionEnviada extends Model
{
    use HasFactory;

    protected $table = 'notificaciones_enviadas';

    protected $fillable = [
        'venta_id',
        'tipo',
        'destinatario',
        'mensaje',
        'estado',
        'error_mensaje',
        'fecha_envio',
    ];

    protected $casts = [
        'fecha_envio' => 'datetime',
    ];

    /**
     * Relación con Venta
     */
    public function venta()
    {
        return $this->belongsTo(Venta::class);
    }
}
