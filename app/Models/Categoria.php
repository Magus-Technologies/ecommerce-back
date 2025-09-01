<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Categoria extends Model
{
    use HasFactory;

    protected $table = 'categorias';

    protected $fillable = [
        'nombre',
        'id_seccion',
        'descripcion',
        'imagen',
        'activo'
    ];

    protected $casts = [
        'activo' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    // Relación con productos
    public function productos()
    {
        return $this->hasMany(Producto::class, 'categoria_id');
    }

    // Relación con sección
    public function seccion()
    {
        return $this->belongsTo(Seccion::class, 'id_seccion');
    }

    // Scope para categorías activas
    public function scopeActivas($query)
    {
        return $query->where('activo', true);
    }

    // Accessor para la URL completa de la imagen
    public function getImagenUrlAttribute()
    {
        if ($this->imagen) {
            return asset('storage/categorias/' . $this->imagen);
        }
        return null;
    }

    // Accessor para contar productos
    public function getProductosCountAttribute()
    {
        return $this->productos()->count();
    }

    // Accessor para contar productos activos
    public function getProductosActivosCountAttribute()
    {
        return $this->productos()->where('activo', true)->count();
    }

    // Método para verificar si se puede eliminar
    public function puedeEliminar()
    {
        return $this->productos()->count() === 0;
    }

    // Boot method para eventos del modelo
    protected static function boot()
    {
        parent::boot();

        // Evento antes de eliminar - MÉTODO MANUAL
        static::deleting(function ($categoria) {
            // Eliminar imagen si existe
            if ($categoria->imagen) {
                $rutaImagen = public_path('storage/categorias/' . $categoria->imagen);
                if (file_exists($rutaImagen)) {
                    unlink($rutaImagen);
                }
            }
        });
    }
}