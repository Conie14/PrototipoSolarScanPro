import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'estructura_carpetas_screen.dart';

class SupervisorDashboardBody extends StatelessWidget {
  final VoidCallback onNuevaVisita;
  final void Function(String proyecto) onVisitar;
  final void Function(String proyecto) onRevisar;
  const SupervisorDashboardBody({
    super.key,
    required this.onNuevaVisita,
    required this.onVisitar,
    required this.onRevisar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.64,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Resumen general del sistema y métricas operativas.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onNuevaVisita,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Nueva Visita'),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar proyecto...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              filled: true,
              fillColor: const Color(0xFFEFEDED),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF5F3F3),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: const Text('Proyectos recientes', style: TextStyle(fontSize: 16)),
                ),
                _ProjectItem(
                  codigo: 'PRJ-2023-A91',
                  nombre: 'Farmacia Sector 4',
                  tecnico: 'J. Miller',
                  estado: 'Captura en Progreso',
                  progreso: 0.45,
                  color: AppColors.primary,
                  accion: 'Revisar',
                  onAccion: () => onRevisar('Farmacia Sector 4'),
                ),
                _ProjectItem(
                  codigo: 'PRJ-2023-B22',
                  nombre: 'Valley Ridge Installation',
                  tecnico: 'S. Connor',
                  estado: 'En revisión',
                  progreso: 0.90,
                  color: AppColors.kpiBrown,
                  accion: 'Visitar',
                  onAccion: () => onVisitar('Valley Ridge Installation'),
                ),
                _ProjectItem(
                  codigo: 'PRJ-2023-B23',
                  nombre: 'Valley Ridge Río',
                  tecnico: 'S. Connor',
                  estado: 'Aprobado',
                  progreso: 0.85,
                  color: AppColors.kpiBrown,
                  accion: 'Visitar',
                  onAccion: () => onVisitar('Valley Ridge Río'),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Generando PDF de resumen...')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Generar PDF', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const EstructuraCarpetasScreen(nombreProyecto: 'Proyectos Recientes'),
                  )),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  icon: const Icon(Icons.folder_zip_outlined, size: 18),
                  label: const Text('Exportar ZIP', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  final String codigo;
  final String nombre;
  final String tecnico;
  final String estado;
  final double progreso;
  final Color color;
  final String accion;
  final VoidCallback onAccion;
  final bool showDivider;

  const _ProjectItem({
    required this.codigo,
    required this.nombre,
    required this.tecnico,
    required this.estado,
    required this.progreso,
    required this.color,
    required this.accion,
    required this.onAccion,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showDivider
          ? const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)))
          : null,
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(codigo,
              style: const TextStyle(
                  fontFamily: 'monospace', color: AppColors.primary, fontSize: 14)),
          const SizedBox(height: 4),
          Text(nombre,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.badge_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('Tech: $tecnico',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(estado, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              Text('${(progreso * 100).round()}%',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: const Color(0xFFE4E2E2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 2),
              ),
              onPressed: onAccion,
              child: Text(accion),
            ),
          ),
        ],
      ),
    );
  }
}
