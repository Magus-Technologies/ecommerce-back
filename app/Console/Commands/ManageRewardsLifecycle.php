<?php

namespace App\Console\Commands;

use App\Models\Recompensa;
use App\Services\RecompensaService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class ManageRewardsLifecycle extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'rewards:manage-lifecycle 
                            {--dry-run : Ejecutar en modo de prueba sin hacer cambios}
                            {--force : Forzar la ejecución sin confirmación}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Gestiona automáticamente el ciclo de vida de las recompensas (activar/desactivar según fechas)';

    protected RecompensaService $recompensaService;

    /**
     * Create a new command instance.
     */
    public function __construct(RecompensaService $recompensaService)
    {
        parent::__construct();
        $this->recompensaService = $recompensaService;
    }

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $isDryRun = $this->option('dry-run');
        $isForced = $this->option('force');

        $this->info('Iniciando gestión del ciclo de vida de recompensas...');
        
        if ($isDryRun) {
            $this->warn('MODO DE PRUEBA - No se realizarán cambios reales');
        }

        try {
            $ahora = now();
            $resultados = [
                'activadas' => 0,
                'desactivadas' => 0,
                'errores' => []
            ];

            // 1. Activar recompensas que deben iniciar hoy
            $this->info('\n Verificando recompensas para activar...');
            $resultadosActivacion = $this->activarRecompensasPendientes($ahora, $isDryRun);
            $resultados['activadas'] = $resultadosActivacion['activadas'];
            $resultados['errores'] = array_merge($resultados['errores'], $resultadosActivacion['errores']);

            // 2. Desactivar recompensas vencidas
            $this->info('\n Verificando recompensas vencidas...');
            $resultadosDesactivacion = $this->desactivarRecompensasVencidas($ahora, $isDryRun);
            $resultados['desactivadas'] = $resultadosDesactivacion['desactivadas'];
            $resultados['errores'] = array_merge($resultados['errores'], $resultadosDesactivacion['errores']);

            // 3. Limpiar recompensas vencidas (usando el servicio)
            if (!$isDryRun) {
                $this->info('\n Limpiando recompensas vencidas...');
                $limpiezaCount = $this->recompensaService->limpiarRecompensasVencidas();
                if ($limpiezaCount > 0) {
                    $this->info(" {$limpiezaCount} recompensas adicionales marcadas como inactivas");
                }
            }

            // 4. Generar reporte de próximas activaciones/desactivaciones
            $this->info('\n Generando reporte de próximas activaciones...');
            $this->generarReporteProximasActivaciones();

            // 5. Mostrar resumen final
            $this->mostrarResumenFinal($resultados, $isDryRun);

            // 6. Registrar en logs
            $this->registrarEnLogs($resultados, $isDryRun);

            return Command::SUCCESS;

        } catch (\Exception $e) {
            $this->error(" Error ejecutando gestión de ciclo de vida: {$e->getMessage()}");
            Log::error('Error en ManageRewardsLifecycle: ' . $e->getMessage(), [
                'exception' => $e,
                'dry_run' => $isDryRun
            ]);
            return Command::FAILURE;
        }
    }

    /**
     * Activar recompensas que deben iniciar
     */
    private function activarRecompensasPendientes(Carbon $ahora, bool $isDryRun): array
    {
        $resultados = ['activadas' => 0, 'errores' => []];

        // Buscar recompensas inactivas que deben activarse hoy
        $recompensasParaActivar = Recompensa::where('activo', false)
            ->whereDate('fecha_inicio', '<=', $ahora->toDateString())
            ->whereDate('fecha_fin', '>=', $ahora->toDateString())
            ->get();

        if ($recompensasParaActivar->isEmpty()) {
            $this->info('   ℹ  No hay recompensas pendientes de activación');
            return $resultados;
        }

        $this->info("  Encontradas {$recompensasParaActivar->count()} recompensas para activar");

        foreach ($recompensasParaActivar as $recompensa) {
            try {
                if (!$isDryRun) {
                    $recompensa->update(['activo' => true]);
                }

                $this->line("   {$recompensa->nombre} (ID: {$recompensa->id}) - Activada");
                $resultados['activadas']++;

            } catch (\Exception $e) {
                $error = "Error activando recompensa {$recompensa->id}: {$e->getMessage()}";
                $this->error("    {$error}");
                $resultados['errores'][] = $error;
            }
        }

        return $resultados;
    }

    /**
     * Desactivar recompensas vencidas
     */
    private function desactivarRecompensasVencidas(Carbon $ahora, bool $isDryRun): array
    {
        $resultados = ['desactivadas' => 0, 'errores' => []];

        // Buscar recompensas activas que ya vencieron
        $recompensasVencidas = Recompensa::where('activo', true)
            ->whereDate('fecha_fin', '<', $ahora->toDateString())
            ->get();

        if ($recompensasVencidas->isEmpty()) {
            $this->info(' i     No hay recompensas vencidas para desactivar');
            return $resultados;
        }

        $this->info("Encontradas {$recompensasVencidas->count()} recompensas vencidas");

        foreach ($recompensasVencidas as $recompensa) {
            try {
                if (!$isDryRun) {
                    $recompensa->update(['activo' => false]);
                }

                $diasVencida = $ahora->diffInDays($recompensa->fecha_fin);
                $this->line("{$recompensa->nombre} (ID: {$recompensa->id}) - Desactivada (vencida hace {$diasVencida} días)");
                $resultados['desactivadas']++;

            } catch (\Exception $e) {
                $error = "Error desactivando recompensa {$recompensa->id}: {$e->getMessage()}";
                $this->error("{$error}");
                $resultados['errores'][] = $error;
            }
        }

        return $resultados;
    }

    /**
     * Generar reporte de próximas activaciones/desactivaciones
     */
    private function generarReporteProximasActivaciones(): void
    {
        $proximosDias = 7; // Próximos 7 días
        $fechaLimite = now()->addDays($proximosDias);

        // Próximas activaciones
        $proximasActivaciones = Recompensa::where('activo', false)
            ->whereBetween('fecha_inicio', [now()->addDay(), $fechaLimite])
            ->orderBy('fecha_inicio')
            ->get(['id', 'nombre', 'fecha_inicio', 'tipo']);

        // Próximas desactivaciones
        $proximasDesactivaciones = Recompensa::where('activo', true)
            ->whereBetween('fecha_fin', [now(), $fechaLimite])
            ->orderBy('fecha_fin')
            ->get(['id', 'nombre', 'fecha_fin', 'tipo']);

        if ($proximasActivaciones->isNotEmpty()) {
            $this->info("\n📈 Próximas activaciones (siguientes {$proximosDias} días):");
            foreach ($proximasActivaciones as $recompensa) {
                $dias = now()->diffInDays($recompensa->fecha_inicio);
                $this->line("   🟢 {$recompensa->nombre} - {$recompensa->fecha_inicio->format('d/m/Y')} (en {$dias} días)");
            }
        }

        if ($proximasDesactivaciones->isNotEmpty()) {
            $this->info("\n📉 Próximas desactivaciones (siguientes {$proximosDias} días):");
            foreach ($proximasDesactivaciones as $recompensa) {
                $dias = now()->diffInDays($recompensa->fecha_fin);
                $this->line("   🔴 {$recompensa->nombre} - {$recompensa->fecha_fin->format('d/m/Y')} (en {$dias} días)");
            }
        }

        if ($proximasActivaciones->isEmpty() && $proximasDesactivaciones->isEmpty()) {
            $this->info("   ℹ️  No hay cambios programados para los próximos {$proximosDias} días");
        }
    }

    /**
     * Mostrar resumen final
     */
    private function mostrarResumenFinal(array $resultados, bool $isDryRun): void
    {
        $this->info('\n RESUMEN DE EJECUCIÓN:');
        $this->info("Recompensas activadas: {$resultados['activadas']}");
        $this->info("Recompensas desactivadas: {$resultados['desactivadas']}");
        $this->info("Errores encontrados: " . count($resultados['errores']));

        if (!empty($resultados['errores'])) {
            $this->warn('\nERRORES DETALLADOS:');
            foreach ($resultados['errores'] as $error) {
                $this->error("   • {$error}");
            }
        }

        if ($isDryRun) {
            $this->warn('\n RECORDATORIO: Esta fue una ejecución de prueba. No se realizaron cambios reales.');
        } else {
            $this->info('\n Gestión de ciclo de vida completada exitosamente.');
        }
    }

    /**
     * Registrar resultados en logs
     */
    private function registrarEnLogs(array $resultados, bool $isDryRun): void
    {
        $logData = [
            'dry_run' => $isDryRun,
            'activadas' => $resultados['activadas'],
            'desactivadas' => $resultados['desactivadas'],
            'errores_count' => count($resultados['errores']),
            'errores' => $resultados['errores'],
            'executed_at' => now()->toISOString()
        ];

        if ($isDryRun) {
            Log::info('Gestión de ciclo de vida de recompensas (DRY RUN)', $logData);
        } else {
            Log::info('Gestión de ciclo de vida de recompensas ejecutada', $logData);
        }
    }

    /**
     * Obtener estadísticas actuales del sistema
     */
    private function mostrarEstadisticasActuales(): void
    {
        $estadisticas = [
            'total' => Recompensa::count(),
            'activas' => Recompensa::where('activo', true)->count(),
            'vigentes' => Recompensa::where('activo', true)
                ->where('fecha_inicio', '<=', now())
                ->where('fecha_fin', '>=', now())
                ->count(),
            'vencidas' => Recompensa::where('fecha_fin', '<', now())->count(),
            'futuras' => Recompensa::where('fecha_inicio', '>', now())->count()
        ];

        $this->info('\nESTADÍSTICAS ACTUALES:');
        $this->info("Total de recompensas: {$estadisticas['total']}");
        $this->info("Activas: {$estadisticas['activas']}");
        $this->info("Vigentes: {$estadisticas['vigentes']}");
        $this->info("Vencidas: {$estadisticas['vencidas']}");
        $this->info("Futuras: {$estadisticas['futuras']}");
    }
}