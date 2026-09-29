import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/proyectos_ejemplo.dart';
import '../widgets/visor_foto.dart';

/// "Supervisor - Revisión de Levantamiento" (Figma 1:7213 / 1:6796).
class RevisionLevantamientoBody extends StatelessWidget {
  final String proyecto;
  const RevisionLevantamientoBody({super.key, this.proyecto = 'PRJ-9921A'});

  @override
  Widget build(BuildContext context) {
    final ejemplo = ProyectosEjemplo.porNombre(proyecto);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revisión de Solar: $proyecto',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text('Completado Por: ${ejemplo?.tecnico ?? 'Alex Rivera'} en Octubre 24 de 2026',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          _Card(
            title: 'Información del Sitio',
            icon: Icons.location_on_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KeyValue('Cliente', ejemplo?.cliente ?? 'Corporación Solar del Norte'),
                _KeyValue('Dirección', ejemplo?.direccion ?? 'Zona Industrial, Nave 4'),
                _KeyValue('Técnico', ejemplo?.tecnico ?? 'Alex Rivera'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Mediciones Clave',
            icon: Icons.bolt_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KeyValue('Voc promedio', '480 V'),
                _KeyValue('Isc promedio', '9.1 A'),
                _KeyValue('Potencia total', '9.2 kW'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Evidencia Fotográfica',
            icon: Icons.photo_library_outlined,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: ejemplo != null
                  ? [
                      for (final f in ejemplo.fotos)
                        GestureDetector(
                          onTap: () => mostrarFotoAmpliada(context, f.asset!, etiqueta: f.etiqueta),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              f.asset!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.background,
                                child: Icon(f.icon, color: AppColors.textMuted, size: 18),
                              ),
                            ),
                          ),
                        ),
                    ]
                  : List.generate(
                      6,
                      (i) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_outlined, color: AppColors.textMuted, size: 18),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Acciones',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Correcciones solicitadas')));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.undo, size: 18),
                  label: const Text('Solicitar Ajustes'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Levantamiento aprobado y enviado a Revisor')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Aprobar y Enviar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _Card({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  const _KeyValue(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          Text(value,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
