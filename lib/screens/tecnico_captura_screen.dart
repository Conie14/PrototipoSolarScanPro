import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/proyectos_ejemplo.dart';
import '../widgets/visor_foto.dart';

/// "Técnico - Captura de Fotos y Video" (Figma 1:6386), pantalla completa
/// dentro del flujo de levantamiento.
class TecnicoCapturaScreen extends StatefulWidget {
  final VoidCallback onSiguiente;
  final String? proyectoId;
  const TecnicoCapturaScreen({super.key, required this.onSiguiente, this.proyectoId});

  @override
  State<TecnicoCapturaScreen> createState() => _TecnicoCapturaScreenState();
}

class _TecnicoCapturaScreenState extends State<TecnicoCapturaScreen> {
  late final _ejemplo = ProyectosEjemplo.porId(widget.proyectoId);
  late int _fotosTomadas = _ejemplo?.fotos.length ?? 0;

  void _tomarFoto(int index) {
    if (_ejemplo != null) return;
    setState(() => _fotosTomadas = (_fotosTomadas + 1).clamp(0, 3));
  }

  @override
  Widget build(BuildContext context) {
    final totalRequeridas = _ejemplo?.fotos.length ?? 3;
    final faltan = totalRequeridas - _fotosTomadas;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Captura de Evidencia',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Información General',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  const _InfoLine(label: 'Ubicación', value: 'Sector 4, Array B, Panel Group 12'),
                  const _InfoLine(label: 'ID de proyecto', value: 'INV-404-XYZ'),
                  const _InfoLine(
                    label: 'Notas técnicas',
                    value: 'Sombra leve detectada por estructura cercana en horas de la mañana.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                const Text('20.6596° N, 103.3496° W',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                const Text('14 Oct 2023 10:42 AM',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fotografías Requeridas ($_fotosTomadas/3)',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                if (faltan > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.statusCorrectionBg, borderRadius: BorderRadius.circular(999)),
                    child: Text('FALTAN $faltan',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.statusCorrectionText)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: List.generate(_ejemplo != null ? _ejemplo!.fotos.length : 4, (i) {
                final tomada = i < _fotosTomadas;
                final foto = _ejemplo != null && i < _ejemplo!.fotos.length ? _ejemplo!.fotos[i] : null;
                return InkWell(
                  onTap: foto?.asset != null
                      ? () => mostrarFotoAmpliada(context, foto!.asset!, etiqueta: foto.etiqueta)
                      : () => _tomarFoto(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: foto?.asset != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                foto!.asset!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(foto.icon, color: AppColors.textMuted, size: 28),
                              ),
                              const Positioned(
                                right: 6,
                                top: 6,
                                child: Icon(Icons.check_circle, color: Colors.white, size: 20),
                              ),
                            ],
                          )
                        : Center(
                            child: Icon(
                              tomada ? Icons.check_circle : Icons.add_a_photo_outlined,
                              color: tomada ? AppColors.statusApprovedText : AppColors.textMuted,
                              size: 28,
                            ),
                          ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text('Grabación de Entorno',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1C1C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.videocam_outlined, color: Colors.white54, size: 36),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      child: const Icon(Icons.fiber_manual_record, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Abriendo galería del dispositivo...')));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Galería'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onSiguiente,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
