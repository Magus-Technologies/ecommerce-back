<?php

namespace App\Models\Models;
use Spatie\Permission\Models\Role as SpatieRole;

use Illuminate\Database\Eloquent\Model;

class CustomRole extends Model
{
    protected $table = 'roles'; // Usa tu tabla
    protected $fillable = ['nombre']; // Usa tu campo personalizado

    // Sobreescribe los métodos de Spatie para usar 'nombre' en vez de 'name'
    public function getNameAttribute()
    {
        return $this->attributes['nombre'];
    }

    public function setNameAttribute($value)
    {
        $this->attributes['nombre'] = $value;
    }
}
