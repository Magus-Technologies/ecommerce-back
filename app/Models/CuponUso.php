<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CuponUso extends Model
{
    use HasFactory;

    protected $table = 'cupon_usos';

    protected $fillable = [
        'cupon_id',
        'user_cliente_id',
        'venta_id',
        'descuento_aplicado',
        'total_compra'
    ];

    protected $casts = [
        'descuento_aplicado' => 'decimal:2',
        'total_compra' => 'decimal:2',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    // Relaciones
    public function cupon()
    {
        return $this->belongsTo(Cupon::class, 'cupon_id');
    }

    public function userCliente()
    {
        return $this->belongsTo(UserCliente::class, 'user_cliente_id');
    }

    public function venta()
    {
        return $this->belongsTo(Venta::class, 'venta_id');
    }

    // Scopes
    public function scopePorCliente($query, $userClienteId)
    {
        return $query->where('user_cliente_id', $userClienteId);
    }

    public function scopePorCupon($query, $cuponId)
    {
        return $query->where('cupon_id', $cuponId);
    }

    // Método estático para verificar si un cliente ya usó un cupón
    public static function clienteYaUsoCupon($cuponId, $userClienteId)
    {
        return self::where('cupon_id', $cuponId)
            ->where('user_cliente_id', $userClienteId)
            ->exists();
    }

    // Método para registrar el uso de un cupón
    public static function registrarUso($cuponId, $userClienteId, $descuentoAplicado, $totalCompra, $ventaId = null)
    {
        return self::create([
            'cupon_id' => $cuponId,
            'user_cliente_id' => $userClienteId,
            'venta_id' => $ventaId,
            'descuento_aplicado' => $descuentoAplicado,
            'total_compra' => $totalCompra
        ]);
    }
}
