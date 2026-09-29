import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Técnico - Firma y Sincronización Final" (Figma 1:6086).
/// [TecnicoFirmaBody] no trae Scaffold propio, así se puede usar tanto
/// embebido en una pestaña del shell como empujado con [TecnicoFirmaScreen].
class TecnicoFirmaBody extends StatelessWidget {
  final VoidCallback onFinalizar;
  const TecnicoFirmaBody({super.key, required this.onFinalizar});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cierre de Inspección',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          const Text('Proyecto #492-A · Planta Solar Norte',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          const _SignatureCard(
            icon: Icons.badge_outlined,
            titulo: 'Firma del Técnico',
            nombre: 'Téc. Alejandro R.',
          ),
          const SizedBox(height: 16),
          const _SignatureCard(
            icon: Icons.person_outline,
            titulo: 'Firma del Cliente',
            nombre: 'Representante Legal',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Generando borrador en PDF...')));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: const Text('Generar Borrador PDF'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onFinalizar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Finalizar y Sincronizar',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String nombre;
  const _SignatureCard({required this.icon, required this.titulo, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Firme aquí', style: TextStyle(color: AppColors.placeholder)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nombre, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Firma limpiada')));
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Limpiar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Envoltorio con Scaffold propio para cuando se llega desde el flujo de
/// levantamiento (empujado sobre el shell).
class TecnicoFirmaScreen extends StatelessWidget {
  final VoidCallback onFinalizar;
  const TecnicoFirmaScreen({super.key, required this.onFinalizar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Firma y Sincronización',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: TecnicoFirmaBody(onFinalizar: onFinalizar),
    );
  }
}
