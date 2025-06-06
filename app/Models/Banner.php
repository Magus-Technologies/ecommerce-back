<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Banner extends Model
{
    use HasFactory;

    protected $fillable = [
        'titulo',
        'subtitulo',
        'descripcion',
        'texto_boton',
        'enlace_url', // ✅ CAMBIAR DE enlace_boton A enlace_url
        'precio_desde',
        'imagen_url',
        'orden',
        'activo'
    ];

    protected $casts = [
        'precio_desde' => 'decimal:2',
        'activo' => 'boolean',
        'orden' => 'integer'
    ];

    // Scope para obtener solo banners activos
    public function scopeActivos($query)
    {
        return $query->where('activo', true);
    }

    // Scope para ordenar por orden
    public function scopeOrdenados($query)
    {
        return $query->orderBy('orden', 'asc');
    }

    // Accessor para la URL completa de la imagen
    public function getImagenCompletaAttribute()
    {
        if ($this->imagen_url) {
            // Si la imagen ya tiene una URL completa, la devolvemos tal como está
            if (filter_var($this->imagen_url, FILTER_VALIDATE_URL)) {
                return $this->imagen_url;
            }
            // Si no, construimos la URL completa
            return asset('storage/' . $this->imagen_url);
        }
        
        // Imagen por defecto si no hay imagen
        return asset('assets/images/thumbs/banner-img-default.png');
    }

    // Método para eliminar la imagen anterior al actualizar
    public function eliminarImagenAnterior($nuevaImagen = null)
    {
        if ($this->imagen_url && $this->imagen_url !== $nuevaImagen) {
            // Solo eliminar si no es una URL externa
            if (!filter_var($this->imagen_url, FILTER_VALIDATE_URL)) {
                Storage::disk('public')->delete($this->imagen_url);
            }
        }
    }
}