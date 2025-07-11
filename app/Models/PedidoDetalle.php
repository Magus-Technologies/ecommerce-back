<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PedidoDetalle extends Model
{
    use HasFactory;

    protected $table = 'pedido_detalles';

    protected $fillable = [
        'pedido_id',
        'producto_id',
        'cantidad',
        'precio_unitario',
        'subtotal'
    ];

    protected $casts = [
        'cantidad' => 'integer',
        'precio_unitario' => 'decimal:2',
        'subtotal' => 'decimal:2'
    ];

    public function pedido()
    {
        return $this->belongsTo(Pedido::class, 'pedido_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }
}
