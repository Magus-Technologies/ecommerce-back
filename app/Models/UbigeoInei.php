<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UbigeoInei extends Model
{
    protected $table = 'ubigeo_inei';
    protected $primaryKey = 'id_ubigeo';
    
    protected $fillable = [
        'id_ubigeo',
        'departamento',
        'provincia',
        'distrito',
        'nombre'
    ];

    // Accessors para obtener nombres en lugar de códigos
    public function getDepartamentoNombreAttribute()
    {
        return $this->getNombreUbigeo($this->departamento . '000000');
    }

    public function getProvinciaNombreAttribute()
    {
        return $this->getNombreUbigeo($this->departamento . $this->provincia . '000');
    }

    public function getDistritoNombreAttribute()
    {
        return $this->nombre; // El nombre del distrito ya está en el campo 'nombre'
    }

    private function getNombreUbigeo($codigoUbigeo)
    {
        $ubigeo = static::where('id_ubigeo', $codigoUbigeo)->first();
        return $ubigeo ? $ubigeo->nombre : 'N/A';
    }

    // Scope para obtener departamentos
    // Eliminar estos métodos si existen:
    // public static function departamentos()
    // public static function provinciasPorDepartamento()  
    // public static function distritosPorProvincia()

    // No necesitas scopes adicionales, las consultas están directamente en el controlador
   
}
