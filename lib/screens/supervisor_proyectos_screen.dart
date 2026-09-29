import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/proyectos_ejemplo.dart';
import 'dashboard_proyecto_screen.dart';

class _ProyectoSupervisado {
  final String nombre;
  final String tecnico;
  final String estado;
  final Color estadoBg;
  final Color estadoColor;
  final String? proyectoEjemploId;
  const _ProyectoSupervisado(this.nombre, this.tecnico, this.estado, this.estadoBg, this.estadoColor,
      {this.proyectoEjemploId});
}

/// "Gestión de Proyectos" del rol Supervisor — vista de supervisión (no de
/// alta como en Admin): progreso de cada proyecto asignado a su equipo.
class SupervisorProyectosBody extends StatelessWidget {
  final void Function(String proyecto) onVerRevision;
  const SupervisorProyectosBody({super.key, required this.onVerRevision});

  static final _proyectos = [
    _ProyectoSupervisado(ProyectosEjemplo.plantaSolarAlpha.nombre, ProyectosEjemplo.plantaSolarAlpha.tecnico,
        'En progreso', AppColors.statusPendingBg, AppColors.statusPendingText,
        proyectoEjemploId: ProyectosEjemplo.plantaSolarAlpha.id),
    _ProyectoSupervisado(ProyectosEjemplo.tejadosSur.nombre, ProyectosEjemplo.tejadosSur.tecnico,
        'Pendiente Revisión', AppColors.statusCorrectionBg, AppColors.statusCorrectionText,
        proyectoEjemploId: ProyectosEjemplo.tejadosSur.id),
    _ProyectoSupervisado(ProyectosEjemplo.plantaSolarNorte.nombre, ProyectosEjemplo.plantaSolarNorte.tecnico,
        'Completado', AppColors.statusApprovedBg, AppColors.statusApprovedText,
        proyectoEjemploId: ProyectosEjemplo.plantaSolarNorte.id),
    _ProyectoSupervisado(ProyectosEjemplo.farmaciaSector4.nombre, ProyectosEjemplo.farmaciaSector4.tecnico,
        'En progreso', AppColors.statusPendingBg, AppColors.statusPendingText,
        proyectoEjemploId: ProyectosEjemplo.farmaciaSector4.id),
    _ProyectoSupervisado(ProyectosEjemplo.valleyRidge.nombre, ProyectosEjemplo.valleyRidge.tecnico,
        'Pendiente Revisión', AppColors.statusCorrectionBg, AppColors.statusCorrectionText,
        proyectoEjemploId: ProyectosEjemplo.valleyRidge.id),
    _ProyectoSupervisado(ProyectosEjemplo.residencial.nombre, ProyectosEjemplo.residencial.tecnico,
        'Pendiente Revisión', AppColors.statusCorrectionBg, AppColors.statusCorrectionText,
        proyectoEjemploId: ProyectosEjemplo.residencial.id),
    _ProyectoSupervisado(ProyectosEjemplo.industrial.nombre, ProyectosEjemplo.industrial.tecnico,
        'En progreso', AppColors.statusPendingBg, AppColors.statusPendingText,
        proyectoEjemploId: ProyectosEjemplo.industrial.id),
    _ProyectoSupervisado(ProyectosEjemplo.solarFarmExpansion.nombre, ProyectosEjemplo.solarFarmExpansion.tecnico,
        'Completado', AppColors.statusApprovedBg, AppColors.statusApprovedText,
        proyectoEjemploId: ProyectosEjemplo.solarFarmExpansion.id),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestión de Proyectos',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Progreso de los proyectos asignados a tu equipo de campo.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (final p in _proyectos) ...[
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
                        Text(p.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('Técnico: ${p.tecnico}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: p.estadoBg, borderRadius: BorderRadius.circular(999)),
                        child: Text(p.estado,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: p.estadoColor)),
                      ),
                      if (p.estado == 'Pendiente Revisión') ...[
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: () => onVerRevision(p.nombre),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                          child: const Text('Ver Revisión', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () {
                          final ejemplo = ProyectosEjemplo.porId(p.proyectoEjemploId);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ejemplo != null
                                ? DashboardProyectoScreen.deEjemplo(ejemplo)
                                : DashboardProyectoScreen(nombreEmpresa: p.nombre.toUpperCase()),
                          ));
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: const Text('Ver Dashboard', style: TextStyle(fontSize: 12)),
                      ),
                    ],
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
