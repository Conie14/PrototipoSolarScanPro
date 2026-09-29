import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Visita {
  final String fecha;
  final String hora;
  final String proyecto;
  final String tecnico;
  final String tipo;
  const _Visita(this.fecha, this.hora, this.proyecto, this.tecnico, this.tipo);
}

/// "Agenda de Campo" del rol Supervisor — visitas programadas agrupadas
/// por fecha.
class SupervisorAgendaBody extends StatelessWidget {
  final VoidCallback onNuevaVisita;
  const SupervisorAgendaBody({super.key, required this.onNuevaVisita});

  static const _visitas = [
    _Visita('Hoy · 24 Oct', '09:00', 'Planta Solar Alpha', 'J. Miller', 'Mantenimiento'),
    _Visita('Hoy · 24 Oct', '14:30', 'Planta Solar Norte', 'Alan Gómez', 'Levantamiento Inicial'),
    _Visita('Mañana · 25 Oct', '10:00', 'Tejados Sur M-22', 'S. Connor', 'Auditoría'),
    _Visita('Vie · 27 Oct', '08:30', 'Valley Ridge Installation', 'S. Connor', 'Revisión de Garantía'),
  ];

  List<Widget> _buildLista() {
    final widgets = <Widget>[];
    String? grupoActual;
    for (final v in _visitas) {
      if (grupoActual != v.fecha) {
        if (grupoActual != null) widgets.add(const SizedBox(height: 8));
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(v.fecha,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ));
        grupoActual = v.fecha;
      }
      widgets.add(_VisitaTile(visita: v));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Agenda de Campo',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Visitas programadas para tu equipo técnico.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              ..._buildLista(),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: onNuevaVisita,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _VisitaTile extends StatelessWidget {
  final _Visita visita;
  const _VisitaTile({required this.visita});

  @override
  Widget build(BuildContext context) {
    final v = visita;
    return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        alignment: Alignment.center,
                        child: Text(v.hora,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 32, color: AppColors.border),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.proyecto,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            Text('${v.tecnico} · ${v.tipo}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
    );
  }
}
