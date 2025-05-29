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

    // Scope para obtener departamentos
    // Eliminar estos métodos si existen:
    // public static function departamentos()
    // public static function provinciasPorDepartamento()  
    // public static function distritosPorProvincia()

    // No necesitas scopes adicionales, las consultas están directamente en el controlador

   
}
