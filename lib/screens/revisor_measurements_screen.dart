import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Medicion {
  final String proyecto;
  final String id;
  final int ok;
  final int total;
  const _Medicion(this.proyecto, this.id, this.ok, this.total);
}

/// Pestaña "Measurements" del bottom nav de Revisor — resumen de mediciones
/// eléctricas pendientes de validar por proyecto.
class RevisorMeasurementsBody extends StatelessWidget {
  final void Function(String proyectoId) onAbrirProyecto;
  const RevisorMeasurementsBody({super.key, required this.onAbrirProyecto});

  static const _mediciones = [
    _Medicion('TRUPER Monterrey', 'PRJ-2023-8842', 16, 18),
    _Medicion('Solar Farm Expansion', 'PRJ-2023-089A', 9, 12),
    _Medicion('Instalación Familia Rojas', 'PRJ-2023-8472', 20, 20),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mediciones Eléctricas',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Estado de las mediciones capturadas por proyecto en revisión.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (final m in _mediciones) ...[
            InkWell(
              onTap: () => onAbrirProyecto(m.id),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.speed_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.proyecto,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(m.id, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${m.ok}/${m.total}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: m.ok == m.total
                                    ? AppColors.statusApprovedText
                                    : AppColors.statusPendingText)),
                        const Text('dentro de rango', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
