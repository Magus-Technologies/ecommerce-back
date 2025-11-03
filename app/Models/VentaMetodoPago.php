<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VentaMetodoPago extends Model
{
    protected $table = 'venta_metodos_pago';

    protected $fillable = [
        'venta_id',
        'metodo',
        'monto',
        'referencia'
    ];

    protected $casts = [
        'monto' => 'decimal:2',
    ];

    /**
     * Relación con Venta
     */
    public function venta()
    {
        return $this->belongsTo(Venta::class);
    }
}
