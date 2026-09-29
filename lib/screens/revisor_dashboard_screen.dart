import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Revisor - Dashboard Técnico Principal" (Figma 1:6949).
class RevisorDashboardBody extends StatelessWidget {
  final void Function(String proyectoId) onAbrirProyecto;
  const RevisorDashboardBody({super.key, required this.onAbrirProyecto});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard de Revisión',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Visión general del estado de proyectos y cola de trabajo.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  icon: Icons.hourglass_top,
                  bg: AppColors.statusPendingBg,
                  iconColor: AppColors.statusPendingText,
                  value: '12',
                  label: 'Pendientes',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  icon: Icons.build_outlined,
                  bg: AppColors.statusCorrectionBg,
                  iconColor: AppColors.statusCorrectionText,
                  value: '4',
                  label: 'En Corrección',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  icon: Icons.check_circle_outline,
                  bg: AppColors.statusApprovedBg,
                  iconColor: AppColors.statusApprovedText,
                  value: '28',
                  label: 'Aprobados',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Cola de Proyectos Prioritaria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _QueueCard(
            accent: AppColors.kpiBrown,
            nombre: 'TRUPER Monterrey',
            id: 'PRJ-2023-8842',
            estado: 'En Revisión',
            onTap: () => onAbrirProyecto('PRJ-2023-8842'),
          ),
          const SizedBox(height: 12),
          _QueueCard(
            accent: AppColors.kpiBlue,
            nombre: 'Instalación Familia Rojas',
            id: 'PRJ-2023-8472',
            estado: 'En Revisión',
            onTap: () => onAbrirProyecto('PRJ-2023-8472'),
          ),
          const SizedBox(height: 12),
          _QueueCard(
            accent: AppColors.statusPendingBg,
            nombre: 'Solar Farm Expansion',
            id: 'PRJ-2023-089A',
            estado: 'Pendiente',
            onTap: () => onAbrirProyecto('PRJ-2023-089A'),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String value;
  final String label;
  const _StatusCard({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          Text('$label\nproyectos',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  final Color accent;
  final String nombre;
  final String id;
  final String estado;
  final VoidCallback onTap;
  const _QueueCard({
    required this.accent,
    required this.nombre,
    required this.id,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(width: 6, height: 72, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(id, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(estado),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
