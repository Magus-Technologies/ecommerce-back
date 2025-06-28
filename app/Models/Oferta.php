<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Oferta extends Model
{
    use HasFactory;

    protected $fillable = [
        'titulo', 'subtitulo', 'descripcion', 'tipo_oferta_id',
        'tipo_descuento', 'valor_descuento', 'precio_minimo',
        'fecha_inicio', 'fecha_fin', 'imagen', 'banner_imagen',
        'color_fondo', 'texto_boton', 'enlace_url', 'limite_uso',
        'usos_actuales', 'activo', 'mostrar_countdown', 'mostrar_en_slider',
        'mostrar_en_banner', 'prioridad'
    ];

    protected $casts = [
        'fecha_inicio' => 'datetime',
        'fecha_fin' => 'datetime',
        'activo' => 'boolean',
        'mostrar_countdown' => 'boolean',
        'mostrar_en_slider' => 'boolean',
        'mostrar_en_banner' => 'boolean',
        'valor_descuento' => 'decimal:2',
        'precio_minimo' => 'decimal:2'
    ];

    // ✅ ACCESSORS CORREGIDOS PARA QUE APAREZCAN EN EL JSON
    protected $appends = ['imagen_url', 'banner_imagen_url'];

    // Relaciones
    public function tipoOferta()
    {
        return $this->belongsTo(TipoOferta::class);
    }

    public function productos()
    {
        return $this->hasMany(OfertaProducto::class);
    }

    // ✅ ACCESSORS CORREGIDOS
    public function getImagenUrlAttribute()
    {
        if (!$this->imagen) {
            return null;
        }
        
        // Si ya contiene la URL completa, devolverla tal como está
        if (str_starts_with($this->imagen, 'http')) {
            return $this->imagen;
        }
        
        return asset('storage/' . $this->imagen);
    }

    public function getBannerImagenUrlAttribute()
    {
        if (!$this->banner_imagen) {
            return null;
        }
        
        // Si ya contiene la URL completa, devolverla tal como está
        if (str_starts_with($this->banner_imagen, 'http')) {
            return $this->banner_imagen;
        }
        
        return asset('storage/' . $this->banner_imagen);
    }

    // Scopes
    public function scopeActivas($query)
    {
        return $query->where('activo', true)
                    ->where('fecha_inicio', '<=', now())
                    ->where('fecha_fin', '>=', now());
    }

    public function scopeFlashSales($query)
    {
        return $query->where('mostrar_countdown', true);
    }

    public function scopeParaSlider($query)
    {
        return $query->where('mostrar_en_slider', true);
    }

    public function scopeParaBanner($query)
    {
        return $query->where('mostrar_en_banner', true);
    }

    // Métodos de utilidad
    public function calcularPrecioOferta($precioOriginal)
    {
        if ($this->tipo_descuento === 'porcentaje') {
            return $precioOriginal * (1 - $this->valor_descuento / 100);
        }
        return max(0, $precioOriginal - $this->valor_descuento);
    }

    public function estaVigente()
    {
        return $this->activo && 
               $this->fecha_inicio <= now() && 
               $this->fecha_fin >= now();
    }
}