<?php
// app/Models/EmpresaInfo.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EmpresaInfo extends Model
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
        'logo',
        'descripcion',
        'facebook',
        'instagram', 
        'twitter',
        'youtube',
        'whatsapp',
        'horario_atencion'
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
}
