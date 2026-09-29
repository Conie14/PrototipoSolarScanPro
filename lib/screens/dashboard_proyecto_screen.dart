import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/proyectos_ejemplo.dart';
import '../widgets/visor_foto.dart';
import 'revisor_validacion_screen.dart';
import 'tecnico_hallazgos_screen.dart';

class IndicadorProyecto {
  final String nombre;
  final double avance;
  final IconData icon;
  const IndicadorProyecto(this.nombre, this.avance, this.icon);
}

/// "Dashboard y Trazabilidad" por proyecto (Documento de Requerimientos,
/// sección 27). Reproduce el ejemplo exacto del documento: EMPRESA
/// MONTERREY, avance general 82 %, con los 7 indicadores por módulo y los
/// datos de trazabilidad (última actividad, responsable, pendientes,
/// hallazgos críticos, estado).
class DashboardProyectoScreen extends StatelessWidget {
  final String nombreEmpresa;
  final double avanceGeneral;
  final List<IndicadorProyecto> indicadores;
  final String fechaUltimaActividad;
  final String usuarioResponsable;
  final int pendientes;
  final int hallazgosCriticos;
  final String estado;
  final List<FotoEjemplo> evidencias;
  final String? proyectoId;

  const DashboardProyectoScreen({
    super.key,
    this.nombreEmpresa = 'EMPRESA MONTERREY',
    this.avanceGeneral = 0.82,
    this.indicadores = const [
      IndicadorProyecto('Información', 1.00, Icons.badge_outlined),
      IndicadorProyecto('Documentación', 0.80, Icons.description_outlined),
      IndicadorProyecto('Fotografías', 0.92, Icons.photo_camera_outlined),
      IndicadorProyecto('Videos', 1.00, Icons.videocam_outlined),
      IndicadorProyecto('Mediciones', 0.85, Icons.speed_outlined),
      IndicadorProyecto('Hallazgos', 1.00, Icons.report_gmailerrorred_outlined),
      IndicadorProyecto('Reporte', 0.40, Icons.summarize_outlined),
    ],
    this.fechaUltimaActividad = '14/09/2026 · 10:32 a. m.',
    this.usuarioResponsable = 'J. Martínez (Técnico)',
    this.pendientes = 3,
    this.hallazgosCriticos = 1,
    this.estado = 'En Progreso',
    this.evidencias = const [
      FotoEjemplo('Fachada', Icons.home_work_outlined, AppColors.kpiBlue),
      FotoEjemplo('Tablero Principal', Icons.electrical_services_outlined, AppColors.kpiOrange),
      FotoEjemplo('Módulos FV', Icons.solar_power_outlined, AppColors.kpiBrown),
      FotoEjemplo('Medidor', Icons.speed_outlined, AppColors.primary),
      FotoEjemplo('Cubierta', Icons.roofing_outlined, AppColors.kpiBlue),
    ],
    this.proyectoId,
  });

  /// Construye el dashboard con los datos y fotografías reales de uno de
  /// los proyectos de ejemplo completos (ver `proyectos_ejemplo.dart`).
  factory DashboardProyectoScreen.deEjemplo(ProyectoEjemplo p, {String estado = 'En Progreso'}) {
    return DashboardProyectoScreen(
      nombreEmpresa: p.nombre.toUpperCase(),
      estado: estado,
      usuarioResponsable: '${p.tecnico} (Técnico)',
      evidencias: p.fotos,
      proyectoId: p.id,
    );
  }

  (Color, Color) get _estadoColores => switch (estado) {
        'Aprobado' || 'Cerrado' => (AppColors.statusApprovedBg, AppColors.statusApprovedText),
        'En Corrección' || 'Atrasado' => (AppColors.severityHighBg, AppColors.severityHighText),
        _ => (AppColors.statusPendingBg, AppColors.statusPendingText),
      };

  @override
  Widget build(BuildContext context) {
    final porcentaje = (avanceGeneral * 100).round();
    final (estadoBg, estadoFg) = _estadoColores;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Dashboard del Proyecto',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 96,
                          height: 96,
                          child: CircularProgressIndicator(
                            value: avanceGeneral,
                            strokeWidth: 10,
                            backgroundColor: AppColors.background,
                            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        ),
                        Text('$porcentaje%',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombreEmpresa,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        const Text('Avance general del levantamiento',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: estadoBg, borderRadius: BorderRadius.circular(999)),
                          child: Text(estado,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: estadoFg)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Indicadores por módulo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  for (final ind in indicadores) ...[
                    _IndicadorRow(indicador: ind),
                    if (ind != indicadores.last) const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Trazabilidad',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _MetaRow(icon: Icons.schedule_outlined, label: 'Fecha de última actividad', value: fechaUltimaActividad),
                  const Divider(height: 20),
                  _MetaRow(icon: Icons.person_outline, label: 'Usuario responsable', value: usuarioResponsable),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AlertaKpi(
                    valor: '$pendientes',
                    label: 'Pendientes',
                    icon: Icons.pending_actions_outlined,
                    bg: AppColors.statusPendingBg,
                    fg: AppColors.statusPendingText,
                    onTap: proyectoId == null
                        ? null
                        : () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RevisorValidacionScreen(
                                proyectoId: proyectoId!,
                                onSolicitarCorrecciones: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text('Correcciones solicitadas')));
                                },
                                onAprobar: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text('Levantamiento aprobado')));
                                },
                              ),
                            )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AlertaKpi(
                    valor: '$hallazgosCriticos',
                    label: 'Hallazgos críticos',
                    icon: Icons.warning_amber_rounded,
                    bg: AppColors.severityHighBg,
                    fg: AppColors.severityHighText,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TecnicoHallazgosScreen(
                        onFinalizarCierre: () => Navigator.of(context).pop(),
                      ),
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Evidencia fotográfica',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: evidencias.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => _FotoTile(foto: evidencias[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndicadorRow extends StatelessWidget {
  final IndicadorProyecto indicador;
  const _IndicadorRow({required this.indicador});

  Color get _color {
    if (indicador.avance >= 0.9) return AppColors.statusApprovedText;
    if (indicador.avance >= 0.6) return AppColors.primary;
    return AppColors.severityHighText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(indicador.icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(indicador.nombre,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            ),
            Text('${(indicador.avance * 100).round()}%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: indicador.avance,
            minHeight: 8,
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FotoTile extends StatelessWidget {
  final FotoEjemplo foto;
  const _FotoTile({required this.foto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: foto.asset != null ? () => mostrarFotoAmpliada(context, foto.asset!, etiqueta: foto.etiqueta) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 96,
          height: 110,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (foto.asset != null)
                Image.asset(
                  foto.asset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              else
                _placeholder(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: 0), Colors.black.withValues(alpha: 0.65)],
                    ),
                  ),
                  child: Text(foto.etiqueta,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [foto.color.withValues(alpha: 0.85), foto.color.withValues(alpha: 0.55)],
        ),
      ),
      child: Center(child: Icon(foto.icon, color: Colors.white, size: 26)),
    );
  }
}

class _AlertaKpi extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;
  const _AlertaKpi({
    required this.valor,
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: fg),
                  const Spacer(),
                  Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
                ],
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
