<?php

namespace App\Http\Controllers\Facturacion;

use App\Http\Controllers\Controller;
use App\Models\GuiaRemision;
use App\Models\GuiaRemisionDetalle;
use App\Models\Cliente;
use App\Models\Producto;
use App\Models\SerieComprobante;
use App\Services\GuiaRemisionService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class GuiasRemisionController extends Controller
{
    protected $guiaRemisionService;

    public function __construct(GuiaRemisionService $guiaRemisionService)
    {
        $this->guiaRemisionService = $guiaRemisionService;
    }

    /**
     * Obtener tipos de guía disponibles
     */
    public function tipos(): JsonResponse
    {
        try {
            $tipos = GuiaRemision::tiposGuia();

            return response()->json([
                'success' => true,
                'data' => $tipos
            ]);
        } catch (\Exception $e) {
            Log::error('Error obteniendo tipos de guía: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener tipos de guía',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Listar guías de remisión
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = GuiaRemision::with(['cliente', 'detalles.producto']);

            // Filtros
            if ($request->has('tipo_guia')) {
                $query->where('tipo_guia', $request->tipo_guia);
            }

            if ($request->has('estado')) {
                $query->where('estado', $request->estado);
            }

            if ($request->has('fecha_inicio')) {
                $query->whereDate('fecha_emision', '>=', $request->fecha_inicio);
            }

            if ($request->has('fecha_fin')) {
                $query->whereDate('fecha_emision', '<=', $request->fecha_fin);
            }

            if ($request->has('cliente_id')) {
                $query->where('cliente_id', $request->cliente_id);
            }

            if ($request->has('serie')) {
                $query->where('serie', $request->serie);
            }

            // Ordenamiento
            $query->orderBy('created_at', 'desc');

            // Paginación
            $perPage = $request->get('per_page', 15);
            $guias = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $guias
            ]);

        } catch (\Exception $e) {
            Log::error('Error listando guías de remisión: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al listar guías de remisión',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Crear guía de remisión - GRE Remitente
     */
    public function storeRemitente(Request $request): JsonResponse
    {
        return $this->storeGuia($request, 'REMITENTE');
    }

    /**
     * Crear guía de remisión - Traslado Interno
     */
    public function storeInterno(Request $request): JsonResponse
    {
        return $this->storeGuia($request, 'INTERNO');
    }

    /**
     * Crear nueva guía de remisión (método genérico)
     */
    public function store(Request $request): JsonResponse
    {
        $tipoGuia = $request->input('tipo_guia', 'REMITENTE');
        return $this->storeGuia($request, $tipoGuia);
    }

    /**
     * Método privado para crear guía según tipo
     */
    private function storeGuia(Request $request, string $tipoGuia): JsonResponse
    {
        try {
            // Validaciones base - Comunes para todos los tipos
            $rules = [
                'cliente_id' => 'nullable|exists:clientes,id',
                'usar_cliente_como_destinatario' => 'nullable|boolean',
                'motivo_traslado' => 'required|string|max:2',
                'fecha_inicio_traslado' => 'required|date',
                'punto_partida_ubigeo' => 'required|string|size:6|regex:/^[0-9]{6}$/',
                'punto_partida_direccion' => 'required|string|max:200',
                'punto_llegada_ubigeo' => 'required|string|size:6|regex:/^[0-9]{6}$/',
                'punto_llegada_direccion' => 'required|string|max:200',
                'productos' => 'required|array|min:1',
                'productos.*.producto_id' => 'required|exists:productos,id',
                'productos.*.cantidad' => 'required|numeric|min:0.01',
                'productos.*.peso_unitario' => 'required|numeric|min:0.01',
                'productos.*.observaciones' => 'nullable|string|max:500',
                'numero_bultos' => 'nullable|integer|min:1',
                'observaciones' => 'nullable|string|max:500',
            ];

            // Validaciones específicas por tipo de guía
            if ($tipoGuia === 'REMITENTE') {
                // GRE Remitente - Requiere destinatario y modalidad
                $rules['modalidad_traslado'] = 'required|string|max:2';

                // Si usa el cliente como destinatario
                if ($request->input('usar_cliente_como_destinatario')) {
                    $rules['cliente_id'] = 'required|exists:clientes,id';
                } else {
                    // Si no usa el cliente como destinatario, cliente_id es opcional
                    $rules['cliente_id'] = 'nullable|exists:clientes,id';
                    // Pero los datos del destinatario son obligatorios
                    $rules['destinatario_tipo_documento'] = 'required|string|max:1';
                    $rules['destinatario_numero_documento'] = 'required|string|max:20';
                    $rules['destinatario_razon_social'] = 'required|string|max:200';
                    $rules['destinatario_direccion'] = 'required|string|max:200';
                    $rules['destinatario_ubigeo'] = 'required|string|size:6|regex:/^[0-9]{6}$/';
                }

                // Si es transporte privado, requiere datos del vehículo y conductor
                if ($request->modalidad_traslado === '02') {
                    $rules['modo_transporte'] = 'nullable|string|max:2';
                    $rules['numero_placa'] = 'required|string|max:20';
                    $rules['conductor_dni'] = 'required|string|max:8';
                    $rules['conductor_nombres'] = 'required|string|max:200';
                }

            } elseif ($tipoGuia === 'INTERNO') {
                // Traslado Interno - Campos mínimos (no requiere SUNAT)
                // Solo requiere puntos de origen/destino y productos
                $rules['destinatario_tipo_documento'] = 'nullable|string|max:1';
                $rules['destinatario_numero_documento'] = 'nullable|string|max:20';
                $rules['destinatario_razon_social'] = 'nullable|string|max:200';
                $rules['destinatario_direccion'] = 'nullable|string|max:200';
                $rules['destinatario_ubigeo'] = 'nullable|string|size:6|regex:/^[0-9]{6}$/';
            }

            // Validaciones de negocio adicionales
            if ($tipoGuia === 'REMITENTE' && $request->input('usar_cliente_como_destinatario')) {
                if (!$request->cliente_id) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Debes seleccionar un cliente cuando usas "El cliente es el destinatario"',
                        'errors' => ['cliente_id' => ['El cliente es requerido']]
                    ], 422);
                }
                
                $cliente = Cliente::find($request->cliente_id);
                if ($cliente && $cliente->tipo_documento !== '6') {
                    return response()->json([
                        'success' => false,
                        'message' => 'El cliente debe tener RUC para ser usado como destinatario',
                        'errors' => ['cliente_id' => ['El cliente debe tener RUC (no DNI) para ser el destinatario']]
                    ], 422);
                }
            }

            $validator = Validator::make($request->all(), $rules);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Datos de validación incorrectos',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            // Obtener cliente (si aplica)
            $cliente = null;
            if ($request->cliente_id) {
                $cliente = Cliente::findOrFail($request->cliente_id);
            }

            // Determinar tipo de comprobante según tipo de guía
            // Para ecommerce solo usamos tipo '09' (GRE Remitente e Interno)
            $tipoComprobante = '09';

            // Obtener serie para guías de remisión
            $serie = SerieComprobante::where('tipo_comprobante', $tipoComprobante)
                                   ->where('activo', true)
                                   ->first();

            if (!$serie) {
                throw new \Exception("No hay series activas para guías de remisión tipo {$tipoComprobante}");
            }

            // Generar correlativo
            $correlativo = $serie->siguienteCorrelativo();

            // Determinar si requiere SUNAT
            $requiereSunat = $tipoGuia !== 'INTERNO';

            // Usar cliente como destinatario si se especifica
            $destinatarioData = [];
            if ($request->input('usar_cliente_como_destinatario') && $cliente) {
                $destinatarioData = [
                    'destinatario_tipo_documento' => $cliente->tipo_documento,
                    'destinatario_numero_documento' => $cliente->numero_documento,
                    'destinatario_razon_social' => $cliente->razon_social,
                    'destinatario_direccion' => $cliente->direccion,
                    'destinatario_ubigeo' => $cliente->ubigeo, // Asumiendo que el cliente tiene ubigeo
                ];
            } else {
                $destinatarioData = [
                    'destinatario_tipo_documento' => $request->destinatario_tipo_documento,
                    'destinatario_numero_documento' => $request->destinatario_numero_documento,
                    'destinatario_razon_social' => $request->destinatario_razon_social,
                    'destinatario_direccion' => $request->destinatario_direccion,
                    'destinatario_ubigeo' => $request->destinatario_ubigeo,
                ];
            }


            // Crear guía de remisión
            $guiaData = [
                'tipo_comprobante' => $tipoComprobante,
                'tipo_guia' => $tipoGuia,
                'requiere_sunat' => $requiereSunat,
                'serie' => $serie->serie,
                'correlativo' => $correlativo,
                'fecha_emision' => now()->format('Y-m-d'),
                'fecha_inicio_traslado' => $request->fecha_inicio_traslado,
                'cliente_id' => $cliente ? $cliente->id : null,
                'cliente_tipo_documento' => $cliente ? $cliente->tipo_documento : null,
                'cliente_numero_documento' => $cliente ? $cliente->numero_documento : null,
                'cliente_razon_social' => $cliente ? $cliente->razon_social : null,
                'cliente_direccion' => $cliente ? $cliente->direccion : null,
                'motivo_traslado' => $request->motivo_traslado,
                'modalidad_traslado' => $request->modalidad_traslado ?? '02', // Por defecto privado
                'peso_total' => $request->peso_total ?? 0,
                'numero_bultos' => $request->numero_bultos ?? 1,
                'modo_transporte' => $request->modo_transporte ?? '01', // Por defecto terrestre
                'numero_placa' => $request->numero_placa,
                'conductor_dni' => $request->conductor_dni,
                'conductor_nombres' => $request->conductor_nombres,
                'punto_partida_ubigeo' => $request->punto_partida_ubigeo,
                'punto_partida_direccion' => $request->punto_partida_direccion,
                'punto_llegada_ubigeo' => $request->punto_llegada_ubigeo,
                'punto_llegada_direccion' => $request->punto_llegada_direccion,
                'observaciones' => $request->observaciones,
                'estado' => GuiaRemision::ESTADO_PENDIENTE,
                'user_id' => auth()->id() ?? 1
            ];

            $guiaData = array_merge($guiaData, $destinatarioData);

            $guia = GuiaRemision::create($guiaData);

            // Crear detalles
            $pesoTotal = 0;
            foreach ($request->productos as $index => $productoData) {
                $producto = Producto::findOrFail($productoData['producto_id']);
                $pesoItem = $productoData['cantidad'] * $productoData['peso_unitario'];
                $pesoTotal += $pesoItem;

                GuiaRemisionDetalle::create([
                    'guia_remision_id' => $guia->id,
                    'item' => $index + 1,
                    'producto_id' => $producto->id,
                    'codigo_producto' => $producto->codigo_producto,
                    'descripcion' => $producto->nombre,
                    'unidad_medida' => 'KGM',
                    'cantidad' => $productoData['cantidad'],
                    'peso_unitario' => $productoData['peso_unitario'],
                    'peso_total' => $pesoItem,
                    'observaciones' => $productoData['observaciones'] ?? null
                ]);
            }

            // Actualizar peso total
            $guia->update(['peso_total' => $pesoTotal]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => "Guía de remisión {$tipoGuia} creada exitosamente",
                'data' => $guia->load(['cliente', 'detalles.producto'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Error creando guía de remisión {$tipoGuia}: " . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al crear guía de remisión',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar guía de remisión específica
     */
    public function show($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto', 'usuario'])
                              ->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $guia
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Guía de remisión no encontrada',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Generar XML firmado (y PDF automáticamente)
     */
    public function generarXml($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto'])->findOrFail($id);

            // Validar que esté en estado PENDIENTE
            if ($guia->estado !== GuiaRemision::ESTADO_PENDIENTE) {
                return response()->json([
                    'success' => false,
                    'message' => 'Solo se puede generar XML de guías en estado PENDIENTE'
                ], 400);
            }

            // Validar si requiere SUNAT
            if (!$guia->requiere_sunat) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta guía de remisión no requiere XML (Traslado Interno)'
                ], 400);
            }

            $resultado = $this->guiaRemisionService->generarXml($guia);

            if ($resultado['success']) {
                return response()->json([
                    'success' => true,
                    'message' => 'XML y PDF generados exitosamente',
                    'data' => $guia->fresh()
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al generar XML',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            Log::error('Error generando XML: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al generar XML',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar guía de remisión a SUNAT
     */
    public function enviarSunat($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto'])->findOrFail($id);

            // Validar si requiere envío a SUNAT
            if (!$guia->requiere_sunat) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta guía de remisión no requiere envío a SUNAT (Traslado Interno)'
                ], 400);
            }

            // Validar que tenga XML generado
            if (!$guia->tiene_xml) {
                return response()->json([
                    'success' => false,
                    'message' => 'Debe generar el XML antes de enviar a SUNAT'
                ], 400);
            }

            // Validar estado
            if ($guia->estado !== GuiaRemision::ESTADO_PENDIENTE) {
                return response()->json([
                    'success' => false,
                    'message' => 'La guía de remisión no puede ser enviada en su estado actual'
                ], 400);
            }

            $resultado = $this->guiaRemisionService->enviarGuiaRemision($guia);

            if ($resultado['success']) {
                return response()->json([
                    'success' => true,
                    'message' => 'Guía de remisión enviada a SUNAT exitosamente',
                    'data' => $guia->fresh()
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Error al enviar guía de remisión a SUNAT',
                    'error' => $resultado['error']
                ], 500);
            }

        } catch (\Exception $e) {
            Log::error('Error enviando guía de remisión: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar guía de remisión',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ver XML (obtiene URL)
     */
    public function verXml($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (empty($guia->xml_firmado)) {
                return response()->json([
                    'success' => false,
                    'message' => 'No hay XML disponible para esta guía de remisión'
                ], 404);
            }

            $url = url("/api/guias-remision/{$id}/ver-xml-archivo");

            return response()->json([
                'success' => true,
                'data' => [
                    'url' => $url,
                    'filename' => $guia->numero_completo . '.xml'
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener XML',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ver archivo XML (sirve el XML desde backend)
     */
    public function verArchivoXml($id)
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (empty($guia->xml_firmado)) {
                abort(404, 'No hay XML disponible');
            }

            $xmlContent = base64_decode($guia->xml_firmado);

            return response($xmlContent, 200)
                ->header('Content-Type', 'application/xml')
                ->header('Content-Disposition', 'inline; filename="' . $guia->numero_completo . '.xml"');

        } catch (\Exception $e) {
            abort(500, 'Error al mostrar XML: ' . $e->getMessage());
        }
    }

    /**
     * Obtener estadísticas de guías de remisión
     */
    public function estadisticas(Request $request): JsonResponse
    {
        try {
            $fechaInicio = $request->get('fecha_inicio', now()->startOfMonth());
            $fechaFin = $request->get('fecha_fin', now()->endOfMonth());

            $estadisticas = [
                'total_guias' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])->count(),
                'guias_pendientes' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                 ->where('estado', GuiaRemision::ESTADO_PENDIENTE)->count(),
                'guias_aceptadas' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                ->where('estado', GuiaRemision::ESTADO_ACEPTADO)->count(),
                'guias_rechazadas' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                 ->where('estado', GuiaRemision::ESTADO_RECHAZADO)->count(),
                'peso_total_transportado' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                                        ->where('estado', GuiaRemision::ESTADO_ACEPTADO)
                                                        ->sum('peso_total'),
                // Estadísticas por tipo
                'por_tipo' => [
                    'remitente' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                              ->where('tipo_guia', 'REMITENTE')->count(),
                    'interno' => GuiaRemision::whereBetween('fecha_emision', [$fechaInicio, $fechaFin])
                                            ->where('tipo_guia', 'INTERNO')->count()
                ]
            ];

            return response()->json([
                'success' => true,
                'data' => $estadisticas
            ]);

        } catch (\Exception $e) {
            Log::error('Error obteniendo estadísticas: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener estadísticas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Descargar CDR
     */
    public function descargarCdr($id)
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (empty($guia->xml_respuesta_sunat)) {
                return response()->json([
                    'success' => false,
                    'message' => 'No hay CDR disponible. La guía debe ser aceptada por SUNAT primero.'
                ], 404);
            }

            $filename = 'R-' . $guia->numero_completo . '.xml';
            $cdrContent = base64_decode($guia->xml_respuesta_sunat);

            return response($cdrContent, 200)
                ->header('Content-Type', 'application/xml')
                ->header('Content-Disposition', 'attachment; filename="' . $filename . '"');

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al descargar CDR',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ver PDF
     */
    public function verPdf($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (empty($guia->pdf_base64)) {
                return response()->json([
                    'success' => false,
                    'message' => 'No hay PDF disponible'
                ], 404);
            }

            $url = url("/api/guias-remision/{$id}/ver-pdf-archivo");

            return response()->json([
                'success' => true,
                'data' => [
                    'url' => $url,
                    'filename' => $guia->numero_completo . '.pdf'
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener PDF',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ver archivo PDF
     */
    public function verArchivoPdf($id)
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (empty($guia->pdf_base64)) {
                abort(404, 'No hay PDF disponible');
            }

            $pdfContent = base64_decode($guia->pdf_base64);

            return response($pdfContent, 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="' . $guia->numero_completo . '.pdf"');

        } catch (\Exception $e) {
            abort(500, 'Error al mostrar PDF: ' . $e->getMessage());
        }
    }

    /**
     * Generar PDF
     */
    public function generarPdf($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente', 'detalles.producto'])->findOrFail($id);

            $this->guiaRemisionService->generarPdf($guia);

            return response()->json([
                'success' => true,
                'message' => 'PDF generado exitosamente',
                'data' => [
                    'url' => url("/api/guias-remision/{$id}/ver-pdf-archivo"),
                    'filename' => $guia->numero_completo . '.pdf'
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Error generando PDF: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al generar PDF',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Buscar guías
     */
    public function buscar(Request $request): JsonResponse
    {
        try {
            $query = GuiaRemision::with(['cliente', 'detalles.producto']);

            $search = $request->get('q', $request->get('search'));

            if ($search) {
                $query->where(function ($q) use ($search) {
                    $q->where('serie', 'LIKE', "%{$search}%")
                      ->orWhere('correlativo', 'LIKE', "%{$search}%")
                      ->orWhereRaw("CONCAT(serie, '-', LPAD(correlativo, 8, '0')) LIKE ?", ["%{$search}%"])
                      ->orWhere('destinatario_razon_social', 'LIKE', "%{$search}%")
                      ->orWhere('destinatario_numero_documento', 'LIKE', "%{$search}%")
                      ->orWhere('numero_placa', 'LIKE', "%{$search}%")
                      ->orWhereHas('cliente', function ($clienteQuery) use ($search) {
                          $clienteQuery->where('razon_social', 'LIKE', "%{$search}%")
                                      ->orWhere('numero_documento', 'LIKE', "%{$search}%");
                      });
                });
            }

            $query->orderBy('created_at', 'desc');

            $perPage = $request->get('per_page', 15);
            $guias = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $guias
            ]);

        } catch (\Exception $e) {
            Log::error('Error buscando guías: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al buscar guías',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Pendientes de envío
     */
    public function pendientesEnvio(Request $request): JsonResponse
    {
        try {
            $query = GuiaRemision::with(['cliente', 'detalles.producto'])
                                ->where('requiere_sunat', true)
                                ->where('estado', GuiaRemision::ESTADO_PENDIENTE);

            $perPage = $request->get('per_page', 15);
            $guias = $query->orderBy('created_at', 'asc')->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $guias
            ]);

        } catch (\Exception $e) {
            Log::error('Error obteniendo pendientes: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener pendientes',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Rechazadas
     */
    public function rechazadas(Request $request): JsonResponse
    {
        try {
            $query = GuiaRemision::with(['cliente', 'detalles.producto'])
                                ->where('estado', GuiaRemision::ESTADO_RECHAZADO);

            $perPage = $request->get('per_page', 15);
            $guias = $query->orderBy('created_at', 'desc')->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $guias
            ]);

        } catch (\Exception $e) {
            Log::error('Error obteniendo rechazadas: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener rechazadas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Actualizar guía de remisión
     */
    public function update(Request $request, $id): JsonResponse
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            // Solo se puede editar si está PENDIENTE y NO tiene XML generado
            if ($guia->estado !== GuiaRemision::ESTADO_PENDIENTE) {
                return response()->json([
                    'success' => false,
                    'message' => 'Solo se pueden editar guías en estado PENDIENTE'
                ], 400);
            }

            if ($guia->tiene_xml) {
                return response()->json([
                    'success' => false,
                    'message' => 'No se puede editar una guía que ya tiene XML generado'
                ], 400);
            }

            $rules = [
                'fecha_inicio_traslado' => 'sometimes|date',
                'motivo_traslado' => 'sometimes|string|max:2',
                'modalidad_traslado' => 'sometimes|string|max:2',
                'punto_partida_ubigeo' => 'sometimes|string|size:6',
                'punto_partida_direccion' => 'sometimes|string|max:200',
                'punto_llegada_ubigeo' => 'sometimes|string|size:6',
                'punto_llegada_direccion' => 'sometimes|string|max:200',
                'numero_bultos' => 'sometimes|integer|min:1',
                'observaciones' => 'nullable|string|max:500',
                'numero_placa' => 'sometimes|string|max:20',
                'conductor_dni' => 'sometimes|string|max:8',
                'conductor_nombres' => 'sometimes|string|max:200',
            ];

            $validator = Validator::make($request->all(), $rules);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Datos de validación incorrectos',
                    'errors' => $validator->errors()
                ], 422);
            }

            $guia->update($request->only([
                'fecha_inicio_traslado',
                'motivo_traslado',
                'modalidad_traslado',
                'punto_partida_ubigeo',
                'punto_partida_direccion',
                'punto_llegada_ubigeo',
                'punto_llegada_direccion',
                'numero_bultos',
                'observaciones',
                'numero_placa',
                'conductor_dni',
                'conductor_nombres',
            ]));

            return response()->json([
                'success' => true,
                'message' => 'Guía actualizada exitosamente',
                'data' => $guia->fresh()->load(['cliente', 'detalles.producto'])
            ]);

        } catch (\Exception $e) {
            Log::error('Error actualizando guía: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar guía',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Actualizar estado logístico
     */
    public function actualizarEstadoLogistico(Request $request, $id): JsonResponse
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'estado_logistico' => 'required|in:pendiente,en_transito,entregado,devuelto,anulado'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Estado logístico inválido',
                    'errors' => $validator->errors()
                ], 422);
            }

            $guia->update([
                'estado_logistico' => $request->estado_logistico
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Estado logístico actualizado',
                'data' => $guia->fresh()
            ]);

        } catch (\Exception $e) {
            Log::error('Error actualizando estado logístico: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar estado logístico',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Consultar estado en SUNAT
     */
    public function consultarSunat($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::findOrFail($id);

            if (!$guia->requiere_sunat) {
                return response()->json([
                    'success' => false,
                    'message' => 'Esta guía no requiere consulta en SUNAT'
                ], 400);
            }

            // Aquí implementarías la consulta real a SUNAT
            // Por ahora retornamos el estado actual
            return response()->json([
                'success' => true,
                'message' => 'Consulta realizada',
                'data' => [
                    'estado' => $guia->estado,
                    'mensaje_sunat' => $guia->mensaje_sunat,
                    'fecha_aceptacion' => $guia->fecha_aceptacion
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Error consultando SUNAT: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al consultar SUNAT',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener datos para email
     */
    public function obtenerDatosEmail($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente'])->findOrFail($id);

            $emailDestinatario = $guia->cliente ? $guia->cliente->email : null;

            return response()->json([
                'success' => true,
                'data' => [
                    'email_destinatario' => $emailDestinatario,
                    'asunto' => 'Guía de Remisión ' . $guia->numero_completo,
                    'mensaje' => "Estimado cliente,\n\nAdjuntamos la Guía de Remisión {$guia->numero_completo}.\n\nSaludos cordiales.",
                    'guia' => $guia
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener datos',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar por email
     */
    public function enviarEmail(Request $request, $id): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'email' => 'required|email',
                'mensaje' => 'nullable|string|max:1000',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Datos inválidos',
                    'errors' => $validator->errors()
                ], 422);
            }

            $guia = GuiaRemision::with(['cliente'])->findOrFail($id);

            // Validar que tenga PDF generado
            if (!$guia->tiene_pdf) {
                return response()->json([
                    'success' => false,
                    'message' => 'La guía no tiene PDF generado'
                ], 400);
            }

            // URLs públicas
            $urlPdf = url("/api/guias-remision/{$id}/ver-pdf-archivo");
            $urlXml = $guia->tiene_xml ? url("/api/guias-remision/{$id}/ver-xml") : null;
            $urlCdr = $guia->tiene_cdr ? url("/api/guias-remision/{$id}/ver-cdr") : null;

            // Mensaje personalizado o por defecto
            $mensajeTexto = $request->mensaje ?? "Estimado cliente, adjuntamos su Guía de Remisión {$guia->serie}-{$guia->correlativo}.";

            // Enviar email (implementar con Mail::send)
            \Mail::send('emails.guia-remision', [
                'guia' => $guia,
                'mensaje' => $mensajeTexto,
                'url_pdf' => $urlPdf,
                'url_xml' => $urlXml,
                'url_cdr' => $urlCdr,
            ], function ($message) use ($request, $guia) {
                $message->to($request->email)
                    ->subject("Guía de Remisión {$guia->serie}-{$guia->correlativo}");
            });

            Log::info('Guía enviada por email', [
                'guia_id' => $guia->id,
                'email' => $request->email
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Email enviado exitosamente',
                'data' => [
                    'email' => $request->email,
                    'url_pdf' => $urlPdf,
                    'url_xml' => $urlXml,
                    'url_cdr' => $urlCdr,
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Error enviando email: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar email',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener datos para WhatsApp
     */
    public function obtenerDatosWhatsApp($id): JsonResponse
    {
        try {
            $guia = GuiaRemision::with(['cliente'])->findOrFail($id);

            $telefono = $guia->cliente ? $guia->cliente->telefono : null;
            $urlPdf = url("/api/guias-remision/{$id}/ver-pdf-archivo");

            $mensaje = "Hola! Te enviamos la Guía de Remisión {$guia->numero_completo}.\n\n";
            $mensaje .= "Puedes verla aquí: {$urlPdf}";

            return response()->json([
                'success' => true,
                'data' => [
                    'telefono' => $telefono,
                    'mensaje' => $mensaje,
                    'url_pdf' => $urlPdf,
                    'guia' => $guia
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener datos',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar por WhatsApp
     */
    public function enviarWhatsApp(Request $request, $id): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'telefono' => 'required|string|max:20',
                'mensaje' => 'nullable|string|max:1000',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Datos inválidos',
                    'errors' => $validator->errors()
                ], 422);
            }

            $guia = GuiaRemision::with(['cliente'])->findOrFail($id);

            // Validar que tenga PDF generado
            if (!$guia->tiene_pdf) {
                return response()->json([
                    'success' => false,
                    'message' => 'La guía no tiene PDF generado'
                ], 400);
            }

            // Limpiar número de teléfono
            $telefono = preg_replace('/[^0-9]/', '', $request->telefono);
            
            // Asegurar que tenga código de país (Perú: +51)
            if (!str_starts_with($telefono, '51') && strlen($telefono) === 9) {
                $telefono = '51' . $telefono;
            }

            // URLs públicas
            $urlPdf = url("/api/guias-remision/{$id}/ver-pdf-archivo");

            // Mensaje personalizado o por defecto
            $mensajeTexto = $request->mensaje ?? "Hola! Te enviamos la Guía de Remisión {$guia->serie}-{$guia->correlativo}.";
            $mensajeCompleto = $mensajeTexto . "\n\n📄 Ver guía: " . $urlPdf;

            // Generar link de WhatsApp
            $whatsappUrl = "https://wa.me/{$telefono}?text=" . urlencode($mensajeCompleto);

            Log::info('Guía enviada por WhatsApp', [
                'guia_id' => $guia->id,
                'telefono' => $telefono
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Link de WhatsApp generado exitosamente',
                'data' => [
                    'whatsapp_url' => $whatsappUrl,
                    'telefono' => $telefono,
                    'mensaje' => $mensajeCompleto,
                    'url_pdf' => $urlPdf,
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Error enviando WhatsApp: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar WhatsApp',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Validar ubigeo
     */
    public function validarUbigeo(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'ubigeo' => 'required|string|size:6|regex:/^[0-9]{6}$/'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Ubigeo inválido',
                    'errors' => $validator->errors()
                ], 422);
            }

            $ubigeo = $request->ubigeo;
            $departamento = substr($ubigeo, 0, 2);
            $provincia = substr($ubigeo, 2, 2);
            $distrito = substr($ubigeo, 4, 2);

            $valido = $departamento !== '00' && $provincia !== '00' && $distrito !== '00';

            return response()->json([
                'success' => true,
                'data' => [
                    'valido' => $valido,
                    'ubigeo' => $ubigeo,
                    'departamento' => $departamento,
                    'provincia' => $provincia,
                    'distrito' => $distrito,
                    'mensaje' => $valido ? 'Ubigeo válido' : 'Ubigeo inválido'
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al validar ubigeo',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Validar RUC transportista
     */
    public function validarRucTransportista(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'ruc' => 'required|string|size:11|regex:/^[0-9]{11}$/'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'RUC inválido',
                    'errors' => $validator->errors()
                ], 422);
            }

            $ruc = $request->ruc;
            $valido = in_array(substr($ruc, 0, 2), ['10', '20']);

            return response()->json([
                'success' => true,
                'data' => [
                    'valido' => $valido,
                    'ruc' => $ruc,
                    'mensaje' => $valido ? 'RUC válido' : 'RUC inválido'
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al validar RUC',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Validar placa
     */
    public function validarPlaca(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'placa' => 'required|string|max:20'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Placa inválida',
                    'errors' => $validator->errors()
                ], 422);
            }

            $placa = strtoupper(trim($request->placa));

            $formatoAntiguo = preg_match('/^[A-Z]{3}-[0-9]{3}$/', $placa);
            $formatoNuevo = preg_match('/^[A-Z]{3}-[0-9]{4}$/', $placa);

            $valido = $formatoAntiguo || $formatoNuevo;

            return response()->json([
                'success' => true,
                'data' => [
                    'valido' => $valido,
                    'placa' => $placa,
                    'formato' => $formatoNuevo ? 'nuevo' : ($formatoAntiguo ? 'antiguo' : 'invalido'),
                    'mensaje' => $valido ? 'Placa válida' : 'Formato inválido (ABC-123 o ABC-1234)'
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al validar placa',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
