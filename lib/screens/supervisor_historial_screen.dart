import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Levantamiento {
  final String proyecto;
  final String tecnico;
  final String fecha;
  final String estado;
  final Color estadoBg;
  final Color estadoColor;
  const _Levantamiento(
      this.proyecto, this.tecnico, this.fecha, this.estado, this.estadoBg, this.estadoColor);
}

/// "Historial de Levantamientos" del rol Supervisor — registro de todos
/// los levantamientos completados por el equipo de campo.
class SupervisorHistorialBody extends StatelessWidget {
  const SupervisorHistorialBody({super.key});

  static const _historial = [
    _Levantamiento('Planta Solar Norte', 'A. Gómez', '20 Oct 2026', 'Aprobado',
        AppColors.statusApprovedBg, AppColors.statusApprovedText),
    _Levantamiento('Instalación Familia Rojas', 'Alan Gómez', '18 Oct 2026', 'Aprobado',
        AppColors.statusApprovedBg, AppColors.statusApprovedText),
    _Levantamiento('Tejados Sur M-22', 'S. Connor', '15 Oct 2026', 'Correcciones Solicitadas',
        AppColors.statusCorrectionBg, AppColors.statusCorrectionText),
    _Levantamiento('Planta Solar Beta', 'J. Miller', '10 Oct 2026', 'Aprobado',
        AppColors.statusApprovedBg, AppColors.statusApprovedText),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historial de Levantamientos',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Registro completo de levantamientos finalizados.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (final h in _historial) ...[
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
                        Text(h.proyecto, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('${h.tecnico} · ${h.fecha}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: h.estadoBg, borderRadius: BorderRadius.circular(999)),
                    child: Text(h.estado,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: h.estadoColor)),
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
