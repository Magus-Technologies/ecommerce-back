<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Empresa extends Model
{
    use HasFactory;

    protected $table = 'empresa_info';

    protected $fillable = [
        'nombre_empresa',
        'ruc',
        'razon_social',
        'direccion',
        'telefono',
        'celular',
        'email',
        'website',
        'whatsapp',
        'logo'
    ];

    /**
     * Obtener la primera empresa (por defecto)
     */
    public static function obtenerEmpresa()
    {
        return self::first();
    }
}