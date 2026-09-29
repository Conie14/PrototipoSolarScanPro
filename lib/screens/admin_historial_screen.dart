import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Evento {
  final String actor;
  final String accion;
  final String fecha;
  final IconData icon;
  final Color color;
  const _Evento(this.actor, this.accion, this.fecha, this.icon, this.color);
}

/// "Historial" — ítem del drawer de Admin sin frame exacto en Figma;
/// construido como bitácora de actividad con el mismo lenguaje visual
/// (tarjetas + timeline) que el resto del rol.
class AdminHistorialBody extends StatelessWidget {
  const AdminHistorialBody({super.key});

  static const _eventos = [
    _Evento('Ing. Roberto Morales', 'aprobó el levantamiento de TRUPER Monterrey', 'Hace 2 horas',
        Icons.check_circle_outline, AppColors.statusApprovedText),
    _Evento('Alan Gómez', 'registró un hallazgo de severidad Alta en Planta Solar Norte',
        'Hace 5 horas', Icons.report_problem_outlined, AppColors.severityHighText),
    _Evento('J. Martínez', 'creó el proyecto "Planta Solar Alpha"', 'Ayer', Icons.work_outline,
        AppColors.primary),
    _Evento('A. Gómez', 'agendó una nueva visita de campo', 'Ayer', Icons.event_outlined,
        AppColors.kpiBrown),
    _Evento('Ing. Roberto Morales', 'solicitó correcciones en Solar Farm Expansion',
        'Hace 2 días', Icons.undo, AppColors.error),
    _Evento('Admin', 'creó el usuario "Juan Díaz" con rol Técnico', 'Hace 3 días',
        Icons.person_add_alt_1, AppColors.kpiBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historial',
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.64, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Bitácora de actividad reciente en el sistema.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          for (var i = 0; i < _eventos.length; i++)
            _EventoTile(evento: _eventos[i], esUltimo: i == _eventos.length - 1),
        ],
      ),
    );
  }
}

class _EventoTile extends StatelessWidget {
  final _Evento evento;
  final bool esUltimo;
  const _EventoTile({required this.evento, required this.esUltimo});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: evento.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(evento.icon, size: 16, color: evento.color),
              ),
              if (!esUltimo) Expanded(child: Container(width: 2, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      children: [
                        TextSpan(text: evento.actor, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${evento.accion}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(evento.fecha, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
