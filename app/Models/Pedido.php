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
        'user_cliente_id',
        'fecha_pedido',
        'subtotal',
        'igv',
        'descuento_total',
        'total',
        'estado_pedido_id',
        'metodo_pago',
        'observaciones',
        'direccion_envio',
        'telefono_contacto',
        'user_id'
    ];

    protected $casts = [
        'subtotal' => 'decimal:2',
        'igv' => 'decimal:2',
        'descuento_total' => 'decimal:2',
        'total' => 'decimal:2',
        'fecha_pedido' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    // Relación con Cliente (para ventas tradicionales)
    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'cliente_id');
    }

    // Relación con UserCliente (para e-commerce)
    public function userCliente()
    {
        return $this->belongsTo(UserCliente::class, 'user_cliente_id');
    }

    // Relación con Estado del Pedido
    public function estadoPedido()
    {
        return $this->belongsTo(EstadoPedido::class, 'estado_pedido_id');
    }

    // Relación con Usuario que creó el pedido
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    // Relación con Detalles del Pedido
    public function detalles()
    {
        return $this->hasMany(PedidoDetalle::class, 'pedido_id');
    }

    // Accessor para obtener el nombre del cliente
    public function getClienteNombreAttribute()
    {
        if ($this->userCliente) {
            return $this->userCliente->nombres . ' ' . $this->userCliente->apellidos;
        }
        
        if ($this->cliente) {
            return $this->cliente->razon_social ?: $this->cliente->nombre_comercial;
        }
        
        return 'Cliente no especificado';
    }

    // Accessor para obtener el tipo de pedido
    public function getTipoPedidoAttribute()
    {
        return $this->user_cliente_id ? 'E-commerce' : 'Tradicional';
    }
}