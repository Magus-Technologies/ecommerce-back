<?php

namespace App\Http\Controllers;

use App\Models\Oferta;
use App\Models\TipoOferta;
use App\Models\Cupon;
use App\Models\OfertaProducto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class OfertasController extends Controller
{
    // ==================== MÉTODOS PÚBLICOS ====================
    
    public function ofertasPublicas()
    {
        $ofertas = Oferta::with(['tipoOferta', 'productos.producto'])
            ->activas()
            ->orderBy('prioridad', 'desc')
            ->get()
            ->map(function ($oferta) {
                return [
                    'id' => $oferta->id,
                    'titulo' => $oferta->titulo,
                    'subtitulo' => $oferta->subtitulo,
                    'descripcion' => $oferta->descripcion,
                    'tipo_descuento' => $oferta->tipo_descuento,
                    'valor_descuento' => $oferta->valor_descuento,
                    'fecha_inicio' => $oferta->fecha_inicio ? $oferta->fecha_inicio->format('c') : null,
                    'fecha_fin' => $oferta->fecha_fin ? $oferta->fecha_fin->format('c') : null,
                    'imagen_url' => $oferta->imagen_url,
                    'banner_imagen_url' => $oferta->banner_imagen_url,
                    'color_fondo' => $oferta->color_fondo,
                    'texto_boton' => $oferta->texto_boton,
                    'enlace_url' => $oferta->enlace_url,
                    'mostrar_countdown' => $oferta->mostrar_countdown,
                    'productos' => $oferta->productos->map(function ($productoOferta) use ($oferta) {
                        $producto = $productoOferta->producto;
                        return [
                            'id' => $producto->id,
                            'nombre' => $producto->nombre,
                            'precio_original' => $producto->precio_venta,
                            'precio_oferta' => $productoOferta->precio_oferta ?? $oferta->calcularPrecioOferta($producto->precio_venta),
                            'stock_oferta' => $productoOferta->stock_oferta,
                            'vendidos_oferta' => $productoOferta->vendidos_oferta,
                            'imagen_url' => $producto->imagen_url,
                        ];
                    })
                ];
            });

        return response()->json($ofertas);
    }

    public function flashSales()
    {
        $flashSales = Oferta::with(['productos.producto'])
            ->activas()
            ->flashSales()
            ->orderBy('prioridad', 'desc')
            ->get()
            ->map(function ($oferta) {
                return [
                    'id' => $oferta->id,
                    'titulo' => $oferta->titulo,
                    'descripcion' => $oferta->descripcion,
                    'fecha_fin' => $oferta->fecha_fin ? $oferta->fecha_fin->format('c') : null,
                    'banner_imagen_url' => $oferta->banner_imagen_url,
                    'color_fondo' => $oferta->color_fondo,
                    'texto_boton' => $oferta->texto_boton,
                    'enlace_url' => $oferta->enlace_url,
                ];
            });

        return response()->json($flashSales);
    }

    public function productosEnOferta()
    {
        $productos = OfertaProducto::with(['producto.categoria', 'producto.marca', 'oferta'])
            ->whereHas('oferta', function ($query) {
                $query->activas();
            })
            ->get()
            ->map(function ($productoOferta) {
                $producto = $productoOferta->producto;
                $oferta = $productoOferta->oferta;
                
                $precioOferta = $productoOferta->precio_oferta ?? $oferta->calcularPrecioOferta($producto->precio_venta);
                $descuentoPorcentaje = round((($producto->precio_venta - $precioOferta) / $producto->precio_venta) * 100);

                return [
                    'id' => $producto->id,
                    'nombre' => $producto->nombre,
                    'precio_original' => $producto->precio_venta,
                    'precio_oferta' => $precioOferta,
                    'descuento_porcentaje' => $descuentoPorcentaje,
                    'stock_oferta' => $productoOferta->stock_oferta,
                    'vendidos_oferta' => $productoOferta->vendidos_oferta,
                    'imagen_url' => $producto->imagen_url,
                    'fecha_fin_oferta' => $oferta->fecha_fin ? $oferta->fecha_fin->format('c') : null,
                    'es_flash_sale' => $oferta->mostrar_countdown,
                    'categoria' => $producto->categoria->nombre ?? null,
                    'marca' => $producto->marca->nombre ?? null,
                ];
            });

        return response()->json($productos);
    }

    public function validarCupon(Request $request)
    {
        $request->validate([
            'codigo' => 'required|string',
            'total' => 'required|numeric|min:0'
        ]);

        $codigo = $request->input('codigo');
        $total = $request->input('total', 0);

        $cupon = Cupon::where('codigo', $codigo)
            ->disponibles()
            ->first();

        if (!$cupon) {
            return response()->json([
                'valido' => false, 
                'mensaje' => 'Cupón no válido o expirado'
            ]);
        }

        if (!$cupon->puedeUsarse($total)) {
            if ($cupon->compra_minima && $total < $cupon->compra_minima) {
                return response()->json([
                    'valido' => false, 
                    'mensaje' => "Compra mínima requerida: $" . number_format($cupon->compra_minima, 2)
                ]);
            }

            return response()->json([
                'valido' => false, 
                'mensaje' => 'Cupón no disponible'
            ]);
        }

        $descuento = $cupon->calcularDescuento($total);

        return response()->json([
            'valido' => true,
            'cupon' => [
                'id' => $cupon->id,
                'codigo' => $cupon->codigo,
                'titulo' => $cupon->titulo,
                'tipo_descuento' => $cupon->tipo_descuento,
                'valor_descuento' => $cupon->valor_descuento
            ],
            'descuento' => $descuento,
            'total_con_descuento' => $total - $descuento
        ]);
    }

    // ==================== MÉTODOS ADMINISTRATIVOS ====================

    public function index()
    {
        $ofertas = Oferta::with(['tipoOferta', 'productos'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($ofertas);
    }

    public function store(Request $request)
    {
        $request->validate([
            'titulo' => 'required|string|max:255',
            'tipo_descuento' => 'required|in:porcentaje,cantidad_fija',
            'valor_descuento' => 'required|numeric|min:0',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'banner_imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);

        $data = $request->all();

        // Manejar subida de imágenes
        if ($request->hasFile('imagen')) {
            $data['imagen'] = $request->file('imagen')->store('ofertas', 'public');
        }

        if ($request->hasFile('banner_imagen')) {
            $data['banner_imagen'] = $request->file('banner_imagen')->store('ofertas/banners', 'public');
        }

        $oferta = Oferta::create($data);

        return response()->json($oferta->load('tipoOferta'), 201);
    }

    public function show($id)
    {
        $oferta = Oferta::with(['tipoOferta', 'productos.producto'])
            ->findOrFail($id);

        return response()->json($oferta);
    }

    public function update(Request $request, $id)
    {
        $oferta = Oferta::findOrFail($id);

        $request->validate([
            'titulo' => 'required|string|max:255',
            'tipo_descuento' => 'required|in:porcentaje,cantidad_fija',
            'valor_descuento' => 'required|numeric|min:0',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
            'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'banner_imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);

        $data = $request->all();

        // Manejar subida de imágenes
        if ($request->hasFile('imagen')) {
            // Eliminar imagen anterior
            if ($oferta->imagen) {
                Storage::disk('public')->delete($oferta->imagen);
            }
            $data['imagen'] = $request->file('imagen')->store('ofertas', 'public');
        }

        if ($request->hasFile('banner_imagen')) {
            // Eliminar imagen anterior
            if ($oferta->banner_imagen) {
                Storage::disk('public')->delete($oferta->banner_imagen);
            }
            $data['banner_imagen'] = $request->file('banner_imagen')->store('ofertas/banners', 'public');
        }

        $oferta->update($data);

        return response()->json($oferta->load('tipoOferta'));
    }

    public function destroy($id)
    {
        $oferta = Oferta::findOrFail($id);

        // Eliminar imágenes
        if ($oferta->imagen) {
            Storage::disk('public')->delete($oferta->imagen);
        }
        if ($oferta->banner_imagen) {
            Storage::disk('public')->delete($oferta->banner_imagen);
        }

        $oferta->delete();

        return response()->json(['message' => 'Oferta eliminada correctamente']);
    }

    public function tiposOfertas()
    {
        $tipos = TipoOferta::activos()->get();
        return response()->json($tipos);
    }
}