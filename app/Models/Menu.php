<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    use HasFactory;

    protected $table = 'menus';

    protected $fillable = [
        'nombre',
        'url',
        'icono',
        'orden',
        'padre_id',
        'tipo',
        'target',
        'visible',
    ];

    protected $casts = [
        'visible' => 'boolean',
        'orden' => 'integer',
        'padre_id' => 'integer',
    ];

    // ============================================
    // RELACIONES
    // ============================================

    /**
     * Relación: Un menú puede tener un padre (menú principal)
     */
    public function padre()
    {
        return $this->belongsTo(Menu::class, 'padre_id');
    }

    /**
     * Relación: Un menú puede tener muchos hijos (submenús)
     */
    public function hijos()
    {
        return $this->hasMany(Menu::class, 'padre_id')->orderBy('orden');
    }

    // ============================================
    // SCOPES
    // ============================================

    /**
     * Scope: Obtener solo menús visibles
     */
    public function scopeVisible($query)
    {
        return $query->where('visible', true);
    }

    /**
     * Scope: Obtener solo menús principales (sin padre)
     */
    public function scopePrincipales($query)
    {
        return $query->whereNull('padre_id');
    }

    /**
     * Scope: Obtener menús por tipo
     */
    public function scopePorTipo($query, $tipo)
    {
        return $query->where('tipo', $tipo);
    }

    /**
     * Scope: Ordenar por campo orden
     */
    public function scopeOrdenado($query)
    {
        return $query->orderBy('orden');
    }

    // ============================================
    // MÉTODOS
    // ============================================

    /**
     * Obtener menús en estructura jerárquica
     */
    public static function obtenerMenusJerarquicos($tipo = 'header', $soloVisibles = false)
    {
        $query = self::principales()
            ->porTipo($tipo)
            ->with(['hijos' => function ($q) use ($soloVisibles) {
                $q->ordenado();
                if ($soloVisibles) {
                    $q->visible();
                }
            }])
            ->ordenado();

        if ($soloVisibles) {
            $query->visible();
        }

        return $query->get();
    }

    /**
     * Verificar si el menú tiene submenús
     */
    public function tieneHijos()
    {
        return $this->hijos()->count() > 0;
    }

    /**
     * Verificar si es un submenú
     */
    public function esSubmenu()
    {
        return !is_null($this->padre_id);
    }
}
