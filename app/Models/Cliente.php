<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cliente extends Model
{
    use HasFactory;

    protected $table = 'clientes';
    protected $primaryKey = 'id_cliente';
    public $timestamps = false;

    protected $fillable = [
        'tipo_documento_id',
        'numero_documento',
        'nombres',
        'apellidos',
        'email',
        'telefono',
        'fecha_nacimiento',
        'genero',
        'contrasena_hash',
        'foto',
        'tipo_login',
        'fecha_registro',
        'estado'
    ];

    protected $casts = [
        'fecha_nacimiento' => 'date',
        'fecha_registro' => 'datetime',
        'estado' => 'boolean'
    ];

    protected $appends = ['nombre_completo'];

    public function getNombreCompletoAttribute()
    {
        return $this->nombres . ' ' . $this->apellidos;
    }

    public function tipoDocumento()
    {
        return $this->belongsTo(DocumentType::class, 'tipo_documento_id', 'id');
    }

    public function direcciones()
    {
        return $this->hasMany(ClienteDireccion::class, 'id_cliente', 'id_cliente');
    }

    public function direccionPrincipal()
    {
        return $this->hasOne(ClienteDireccion::class, 'id_cliente', 'id_cliente')
                    ->where('predeterminada', 1);
    }
}
