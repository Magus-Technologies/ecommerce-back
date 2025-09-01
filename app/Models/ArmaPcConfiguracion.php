<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ArmaPcConfiguracion extends Model
{
    use HasFactory;

    protected $table = 'arma_pc_configuracion';

    protected $fillable = [
        'categoria_id',
        'orden',
        'activo'
    ];

    protected $casts = [
        'activo' => 'boolean',
        'orden' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    /**
     * Relación con la categoría
     */
    public function categoria()
    {
        return $this->belongsTo(Categoria::class);
    }

    /**
     * Scope para configuraciones activas
     */
    public function scopeActivas($query)
    {
        return $query->where('activo', true);
    }

    /**
     * Scope para ordenar por orden
     */
    public function scopeOrdenado($query)
    {
        return $query->orderBy('orden', 'asc');
    }

    /**
     * Método estático para obtener categorías configuradas
     */
    public static function getCategoriasConfiguradas()
    {
        return self::activas()
            ->ordenado()
            ->with(['categoria' => function($query) {
                $query->activas()
                      ->withCount(['productos' => function($q) {
                          $q->where('activo', true)->where('stock', '>', 0);
                      }]);
            }])
            ->get()
            ->map(function($config) {
                $categoria = $config->categoria;
                if ($categoria) {
                    // Agregar la URL completa de la imagen
                    if ($categoria->imagen) {
                        $categoria->img = asset('storage/categorias/' . $categoria->imagen);
                    }
                    return $categoria;
                }
                return null;
            })
            ->filter(); // Eliminar nulls
    }

    /**
     * Boot method para eventos del modelo
     */
    protected static function boot()
    {
        parent::boot();

        // Cuando se crea una nueva configuración, asegurar orden único
        static::creating(function ($configuracion) {
            if (!$configuracion->orden) {
                $maxOrden = self::max('orden') ?? 0;
                $configuracion->orden = $maxOrden + 1;
            }
        });
    }
}