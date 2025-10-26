<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\PdfGeneratorService;
use App\Services\CompanyDataProvider;
use App\Models\Comprobante;
use App\Models\Venta;

class TestPdfSunat extends Command
{
    protected $signature = 'pdf:test-sunat {venta_id?} {--template=primary}';
    protected $description = 'Probar generación de PDF SUNAT compliant';

    public function handle()
    {
        $this->info('🔍 Probando sistema de PDF SUNAT...');
        
        // Verificar configuración de empresa
        $this->testCompanyConfiguration();
        
        // Verificar logo
        $this->testLogo();
        
        // Probar generación de PDF
        if ($ventaId = $this->argument('venta_id')) {
            $this->testPdfGeneration($ventaId);
        } else {
            $this->info('💡 Para probar con una venta específica: php artisan pdf:test-sunat {venta_id}');
        }
    }

    private function testCompanyConfiguration()
    {
        $this->info("\n📋 Verificando configuración de empresa...");
        
        $provider = new CompanyDataProvider();
        $companyData = $provider->getCompanyInfo();
        $config = $provider->isConfigurationComplete();
        
        $this->table(['Campo', 'Valor'], [
            ['RUC', $companyData['ruc']],
            ['Razón Social', $companyData['razon_social']],
            ['Dirección', $companyData['direccion_fiscal']],
            ['Teléfono', $companyData['telefono'] ?? 'No configurado'],
            ['Email', $companyData['email'] ?? 'No configurado'],
        ]);
        
        if ($config['complete']) {
            $this->info('✅ Configuración de empresa completa');
        } else {
            $this->warn('⚠️  Configuración incompleta. Faltan: ' . implode(', ', $config['missing']));
        }
    }

    private function testLogo()
    {
        $this->info("\n🖼️  Verificando logo de empresa...");
        
        $provider = new CompanyDataProvider();
        $logoPath = $provider->getLogoPath();
        
        if ($logoPath) {
            $this->info("✅ Logo encontrado: {$logoPath}");
            $this->info("📏 Tamaño: " . $this->formatBytes(filesize($logoPath)));
        } else {
            $this->warn('⚠️  Logo no encontrado');
            $this->info('💡 Coloca tu logo en: public/assets/images/logo/logo3.png');
        }
    }

    private function testPdfGeneration($ventaId)
    {
        $this->info("\n🔄 Probando generación de PDF para venta ID: {$ventaId}");
        
        try {
            $venta = Venta::with(['comprobante.cliente', 'comprobante.detalles'])->findOrFail($ventaId);
            
            if (!$venta->comprobante) {
                $this->error('❌ La venta no tiene comprobante asociado');
                return;
            }
            
            $comprobante = $venta->comprobante;
            $this->info("📄 Comprobante: {$comprobante->serie}-{$comprobante->correlativo}");
            $this->info("👤 Cliente: {$comprobante->cliente_razon_social}");
            $this->info("💰 Total: S/ {$comprobante->importe_total}");
            
            // Generar PDF
            $pdfService = new PdfGeneratorService();
            $resultado = $pdfService->generarPdfSunat($comprobante);
            
            $this->info('✅ PDF generado exitosamente');
            $this->table(['Elemento', 'Estado'], [
                ['Template usado', $resultado['template_usado']],
                ['Tamaño PDF', $this->formatBytes($resultado['pdf_size_bytes'])],
                ['Datos empresa', $resultado['elementos_incluidos']['datos_empresa'] ? '✅' : '❌'],
                ['Tipo comprobante', $resultado['elementos_incluidos']['tipo_comprobante_especifico'] ? '✅' : '❌'],
                ['Detalle productos', $resultado['elementos_incluidos']['detalle_productos_completo'] ? '✅' : '❌'],
                ['Info legal SUNAT', $resultado['elementos_incluidos']['informacion_legal_sunat'] ? '✅' : '❌'],
                ['Totales detallados', $resultado['elementos_incluidos']['totales_detallados'] ? '✅' : '❌'],
                ['Código QR', $resultado['elementos_incluidos']['codigo_qr'] ? '✅' : '❌'],
                ['Hash XML', $resultado['elementos_incluidos']['hash_xml'] ? '✅' : '❌'],
            ]);
            
        } catch (\Exception $e) {
            $this->error('❌ Error: ' . $e->getMessage());
            $this->info('🔍 Detalles: ' . $e->getFile() . ':' . $e->getLine());
        }
    }

    private function formatBytes($bytes, $precision = 2)
    {
        $units = array('B', 'KB', 'MB', 'GB', 'TB');
        
        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }
        
        return round($bytes, $precision) . ' ' . $units[$i];
    }
}