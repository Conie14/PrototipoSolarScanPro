import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/campo_formulario.dart';
import 'plantilla_preview_screen.dart';
import 'nueva_plantilla_screen.dart';

class _Plantilla {
  final String nombre;
  final String rol;
  final int campos;
  final List<CampoFormulario>? campoDefs;
  const _Plantilla(this.nombre, this.rol, this.campos, {this.campoDefs});
}

/// "Gestión de Plantillas" — ítem del drawer de Admin sin frame exacto en
/// Figma; construido con el mismo lenguaje visual (lista de tarjetas) que
/// el resto del rol.
class AdminPlantillasBody extends StatefulWidget {
  const AdminPlantillasBody({super.key});

  @override
  State<AdminPlantillasBody> createState() => _AdminPlantillasBodyState();
}

class _AdminPlantillasBodyState extends State<AdminPlantillasBody> {
  final List<_Plantilla> _plantillas = [
    const _Plantilla('Estudio de Viabilidad FV', 'Supervisor', 8),
    const _Plantilla('Inspección FV Residencial', 'Técnico', 18),
    const _Plantilla('Mantenimiento Preventivo', 'Técnico', 12),
    const _Plantilla('Validación de Levantamiento', 'Revisor', 9),
    const _Plantilla('Checklist de Visita de Campo', 'Supervisor', 7),
  ];

  Future<void> _crearPlantilla() async {
    final result = await Navigator.of(context).push<NuevaPlantillaResultado>(
      MaterialPageRoute(builder: (_) => const NuevaPlantillaScreen()),
    );
    if (result != null) {
      setState(() => _plantillas.add(
          _Plantilla(result.nombre, result.rol, result.campos.length, campoDefs: result.campos)));
    }
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
              const Text('Gestión de Plantillas',
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.64, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Formularios reutilizables para inspecciones y levantamientos.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              for (var i = 0; i < _plantillas.length; i++) ...[
                _PlantillaTile(
                  plantilla: _plantillas[i],
                  onAbrir: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PlantillaPreviewScreen(
                      nombre: _plantillas[i].nombre,
                      rol: _plantillas[i].rol,
                      camposPersonalizados: _plantillas[i].campoDefs,
                    ),
                  )),
                  onDuplicar: () {
                    final p = _plantillas[i];
                    setState(() => _plantillas.insert(
                        i + 1, _Plantilla('${p.nombre} (copia)', p.rol, p.campos, campoDefs: p.campoDefs)));
                  },
                  onEliminar: () => setState(() => _plantillas.removeAt(i)),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: _crearPlantilla,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _PlantillaTile extends StatelessWidget {
  final _Plantilla plantilla;
  final VoidCallback onAbrir;
  final VoidCallback onDuplicar;
  final VoidCallback onEliminar;
  const _PlantillaTile({
    required this.plantilla,
    required this.onAbrir,
    required this.onDuplicar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onAbrir,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.dashboard_customize_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plantilla.nombre,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('Rol: ${plantilla.rol} · ${plantilla.campos} campos',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, size: 18, color: AppColors.textSecondary),
                    onPressed: onDuplicar,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                    onPressed: onEliminar,
                  ),
                ],
              ),
              const Divider(height: 20),
              const Row(
                children: [
                  Icon(Icons.play_circle_outline, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('Ver ejemplo: cómo solicita y captura la información',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  Spacer(),
                  Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
