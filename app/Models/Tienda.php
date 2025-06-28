<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tienda extends Model
{
    use HasFactory;

    protected $fillable = [
        'nombre',
        'descripcion',
        'direccion',
        'telefono',
        'email',
        'activo'
    ];

    protected $casts = [
        'activo' => 'boolean'
    ];

    public function pedidos()
    {
        return $this->hasMany(Pedido::class, 'tienda_id');
    }
}
