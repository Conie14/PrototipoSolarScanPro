import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Descarga {
  final String nombre;
  final String tipo;
  final String fecha;
  final String tamano;
  final IconData icon;
  const _Descarga(this.nombre, this.tipo, this.fecha, this.tamano, this.icon);
}

/// "Descargas" — ítem del drawer de Admin sin frame exacto en Figma;
/// construido con el mismo lenguaje visual (lista de tarjetas) que el
/// resto del rol.
class AdminDescargasBody extends StatelessWidget {
  const AdminDescargasBody({super.key});

  static const _reportes = [
    _Descarga('Informe de Levantamiento - Planta Solar Alpha', 'PDF', '24 Oct 2026', '2.4 MB',
        Icons.picture_as_pdf_outlined),
    _Descarga('Reporte de Hallazgos - Tejados Sur M-22', 'PDF', '22 Oct 2026', '1.1 MB',
        Icons.picture_as_pdf_outlined),
    _Descarga('Exportación de Usuarios y Roles', 'XLSX', '18 Oct 2026', '340 KB',
        Icons.table_chart_outlined),
    _Descarga('Historial de Mediciones - Q3 2026', 'CSV', '10 Oct 2026', '890 KB',
        Icons.insert_drive_file_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Descargas',
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.64, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Reportes y exportaciones generadas por el sistema.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          for (final d in _reportes) ...[
            _DescargaTile(descarga: d),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _DescargaTile extends StatelessWidget {
  final _Descarga descarga;
  const _DescargaTile({required this.descarga});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Icon(descarga.icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(descarga.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${descarga.tipo} · ${descarga.fecha} · ${descarga.tamano}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Descargando ${descarga.nombre}...')));
            },
          ),
        ],
      ),
    );
  }
}
