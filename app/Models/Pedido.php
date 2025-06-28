<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pedido extends Model
{
    use HasFactory;

    protected $fillable = [
        'codigo_pedido',
        'cliente_id',
        'direccion_id',
        'tienda_id',
        'estado_pedido_id',
        'metodo_pago_id',
        'subtotal',
        'igv',
        'descuento_total',
        'total',
        'requiere_factura',
        'observaciones',
        'moneda',
        'tipo_cambio'
    ];

    protected $casts = [
        'subtotal' => 'decimal:2',
        'igv' => 'decimal:2',
        'descuento_total' => 'decimal:2',
        'total' => 'decimal:2',
        'tipo_cambio' => 'decimal:2',
        'requiere_factura' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    public function cliente()
    {
        return $this->belongsTo(UserCliente::class, 'cliente_id');
    }

    public function direccion()
    {
        return $this->belongsTo(UserClienteDireccion::class, 'direccion_id');
    }

    public function tienda()
    {
        return $this->belongsTo(Tienda::class, 'tienda_id');
    }

    public function estadoPedido()
    {
        return $this->belongsTo(EstadoPedido::class, 'estado_pedido_id');
    }

    public function metodoPago()
    {
        return $this->belongsTo(MetodoPago::class, 'metodo_pago_id');
    }

    public function detalles()
    {
        return $this->hasMany(PedidoDetalle::class, 'pedido_id');
    }
}
