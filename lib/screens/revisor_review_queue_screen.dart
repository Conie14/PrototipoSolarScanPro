import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Pendiente {
  final String proyecto;
  final String id;
  const _Pendiente(this.proyecto, this.id);
}

/// Pestaña "Review" del bottom nav de Revisor — proyectos listos para la
/// decisión final de validación (aprobar / rechazar).
class RevisorReviewQueueBody extends StatelessWidget {
  final void Function(String proyectoId) onDecidir;
  const RevisorReviewQueueBody({super.key, required this.onDecidir});

  static const _pendientes = [
    _Pendiente('TRUPER Monterrey', 'PRJ-2023-8842'),
    _Pendiente('Instalación Familia Rojas', 'PRJ-2023-8472'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Decisiones Pendientes',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Proyectos listos para aprobar o rechazar.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (final p in _pendientes) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.proyecto,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text(p.id, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => onDecidir(p.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Decidir'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
