import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _GrupoEvidencia {
  final String proyecto;
  final String id;
  final int fotos;
  const _GrupoEvidencia(this.proyecto, this.id, this.fotos);
}

/// Pestaña "Evidence" del bottom nav de Revisor — galería de evidencia
/// fotográfica agrupada por proyecto en cola de revisión.
class RevisorEvidenceBody extends StatelessWidget {
  final void Function(String proyectoId) onAbrirProyecto;
  const RevisorEvidenceBody({super.key, required this.onAbrirProyecto});

  static const _grupos = [
    _GrupoEvidencia('TRUPER Monterrey', 'PRJ-2023-8842', 24),
    _GrupoEvidencia('Solar Farm Expansion', 'PRJ-2023-089A', 16),
    _GrupoEvidencia('Instalación Familia Rojas', 'PRJ-2023-8472', 31),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Evidencia Fotográfica',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Fotografías capturadas en campo, agrupadas por proyecto.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (final g in _grupos) ...[
            InkWell(
              onTap: () => onAbrirProyecto(g.id),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.proyecto,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text(g.id, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Text('${g.fotos} fotos', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 4 ? 6 : 0),
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.image_outlined, size: 16, color: AppColors.textMuted),
                          ),
                        ),
                      ),
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
