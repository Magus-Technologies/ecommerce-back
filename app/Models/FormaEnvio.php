<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FormaEnvio extends Model
{
    protected $fillable = [
        'departamento_id',
        'provincia_id',
        'distrito_id',
        'costo',
        'activo'
    ];

    protected $casts = [
        'costo' => 'decimal:2',
        'activo' => 'boolean'
    ];

    // Scope para obtener solo formas de envío activas
    public function scopeActivas($query)
    {
        return $query->where('activo', true);
    }

    // Relación con departamento (ubigeo_inei)
    public function departamento()
    {
        return $this->hasOne('App\Models\UbigeoInei', 'id_ubigeo', 'departamento_id');
    }

    // Relación con provincia (ubigeo_inei)
    public function provincia()
    {
        return $this->hasOne('App\Models\UbigeoInei', 'id_ubigeo', 'provincia_id');
    }

    // Relación con distrito (ubigeo_inei)
    public function distrito()
    {
        return $this->hasOne('App\Models\UbigeoInei', 'id_ubigeo', 'distrito_id');
    }
}
