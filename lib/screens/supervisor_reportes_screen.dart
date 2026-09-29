import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Reporte {
  final String nombre;
  final String proyecto;
  final String fecha;
  final IconData icon;
  const _Reporte(this.nombre, this.proyecto, this.fecha, this.icon);
}

/// "Gestión de Reportes" del rol Supervisor — reportes finales generados
/// por el equipo de campo, listos para descargar o compartir.
class SupervisorReportesBody extends StatelessWidget {
  const SupervisorReportesBody({super.key});

  static const _reportes = [
    _Reporte('Informe Final de Levantamiento', 'Planta Solar Alpha', '24 Oct 2026', Icons.picture_as_pdf_outlined),
    _Reporte('Reporte de Hallazgos Críticos', 'Planta Solar Norte', '22 Oct 2026', Icons.report_outlined),
    _Reporte('Certificado de Inspección', 'Tejados Sur M-22', '18 Oct 2026', Icons.verified_outlined),
    _Reporte('Reporte Fotográfico Completo', 'Farmacia Sector 4', '15 Oct 2026', Icons.photo_library_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestión de Reportes',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Reportes finales generados por tu equipo de campo.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (final r in _reportes) ...[
            Container(
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
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                    child: Icon(r.icon, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.nombre, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('${r.proyecto} · ${r.fecha}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Compartiendo "${r.nombre}"...')));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_outlined, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Descargando "${r.nombre}"...')));
                    },
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
