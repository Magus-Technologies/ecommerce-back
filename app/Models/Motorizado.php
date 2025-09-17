<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Motorizado extends Model
{
    use HasFactory;

    protected $table = 'motorizados';

    protected $fillable = [
        'numero_unidad',
        'nombre_completo',
        'foto_perfil',
        'tipo_documento_id',
        'numero_documento',
        'licencia_numero',
        'licencia_categoria',
        'telefono',
        'correo',
        'direccion_detalle',
        'ubigeo',
        'vehiculo_marca',
        'vehiculo_modelo',
        'vehiculo_ano',
        'vehiculo_cilindraje',
        'vehiculo_color_principal',
        'vehiculo_color_secundario',
        'vehiculo_placa',
        'vehiculo_motor',
        'vehiculo_chasis',
        'comentario',
        'registrado_por',
        'estado'
    ];

    protected $casts = [
        'estado' => 'boolean',
        'vehiculo_ano' => 'integer'
    ];

    public function tipoDocumento()
    {
        return $this->belongsTo(DocumentType::class, 'tipo_documento_id');
    }

    public function registradoPor()
    {
        return $this->belongsTo(User::class, 'registrado_por');
    }

    public function ubicacion()
    {
        return $this->belongsTo(UbigeoInei::class, 'ubigeo', 'id_ubigeo');
    }

    public static function getProximoNumeroUnidad()
    {
        $ultimo = self::orderBy('numero_unidad', 'desc')->first();
        if (!$ultimo) {
            return 'MOT-001';
        }
        
        $numero = (int) substr($ultimo->numero_unidad, 4);
        return 'MOT-' . str_pad($numero + 1, 3, '0', STR_PAD_LEFT);
    }

    public function getCategoriasLicencia()
    {
        return [
            'A1' => 'A1 - Motocicletas hasta 125cc',
            'A2a' => 'A2a - Motocicletas de 126cc a 250cc',
            'A2b' => 'A2b - Motocicletas de 251cc a 500cc',
            'A3a' => 'A3a - Motocicletas de 501cc a 800cc',
            'A3b' => 'A3b - Motocicletas de 801cc a 1000cc',
            'A3c' => 'A3c - Motocicletas de más de 1000cc'
        ];
    }
}
