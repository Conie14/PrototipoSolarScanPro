import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tecnico_hallazgo_form_screen.dart';

/// "Técnico - Registro de Hallazgos" (Figma 1:6273), pantalla completa
/// dentro del flujo de levantamiento.
class TecnicoHallazgosScreen extends StatefulWidget {
  final VoidCallback onFinalizarCierre;
  const TecnicoHallazgosScreen({super.key, required this.onFinalizarCierre});

  @override
  State<TecnicoHallazgosScreen> createState() => _TecnicoHallazgosScreenState();
}

class _TecnicoHallazgosScreenState extends State<TecnicoHallazgosScreen> {
  final _notasCtrl = TextEditingController();
  final List<Hallazgo> _hallazgos = [
    const Hallazgo(
      codigo: 'INV-001',
      titulo: 'Panel con fisuras severas',
      descripcion:
          'Se detectaron múltiples grietas en el panel serial #45920-A. Requiere reemplazo inmediato.',
      severidad: 'Alto',
      categoria: 'Estructural',
      ubicacion: 'Sector 4, Array B',
    ),
    const Hallazgo(
      codigo: 'CAB-042',
      titulo: 'Cableado expuesto',
      descripcion:
          'Aislamiento degradado en la conexión del inversor B. Se recomienda encintado térmico preventivo.',
      severidad: 'Medio',
      categoria: 'Eléctrico',
      ubicacion: 'Inversor B',
    ),
    const Hallazgo(
      codigo: 'EST-011',
      titulo: 'Suciedad acumulada',
      descripcion: 'Polvo ligero en el sector noroeste. No afecta significativamente el rendimiento por ahora.',
      severidad: 'Bajo',
      categoria: 'Limpieza',
      ubicacion: 'Sector noroeste',
    ),
  ];

  Future<void> _agregarHallazgo() async {
    final resultado = await Navigator.of(context).push<Hallazgo>(
      MaterialPageRoute(builder: (_) => const TecnicoHallazgoFormScreen()),
    );
    if (resultado != null) setState(() => _hallazgos.add(resultado));
  }

  Future<void> _editarHallazgo(int index) async {
    final resultado = await Navigator.of(context).push<Hallazgo>(
      MaterialPageRoute(builder: (_) => TecnicoHallazgoFormScreen(hallazgoInicial: _hallazgos[index])),
    );
    if (resultado != null) setState(() => _hallazgos[index] = resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Hallazgos y Observaciones',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hallazgos Registrados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                TextButton.icon(
                  onPressed: _agregarHallazgo,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar Hallazgo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _hallazgos.length; i++) ...[
              _HallazgoCard(hallazgo: _hallazgos[i], onTap: () => _editarHallazgo(i)),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            const Text('Observaciones Generales',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _notasCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escriba observaciones adicionales...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Evidencia Adicional',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.upload_file_outlined, color: AppColors.textMuted, size: 28),
                  SizedBox(height: 8),
                  Text('Toque para adjuntar documentos PDF o imágenes',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  SizedBox(height: 4),
                  Text('Max 10MB por archivo',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Borrador guardado')));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Guardar Borrador'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onFinalizarCierre,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Finalizar Cierre'),
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

class _HallazgoCard extends StatelessWidget {
  final Hallazgo hallazgo;
  final VoidCallback onTap;
  const _HallazgoCard({required this.hallazgo, required this.onTap});

  Color get _bg {
    switch (hallazgo.severidad) {
      case 'Alto':
        return AppColors.severityHighBg;
      case 'Medio':
        return AppColors.severityMediumBg;
      default:
        return AppColors.severityLowBg;
    }
  }

  Color get _text {
    switch (hallazgo.severidad) {
      case 'Alto':
        return AppColors.severityHighText;
      case 'Medio':
        return Colors.white;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(999)),
                  child: Text(hallazgo.codigo,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _text)),
                ),
                const Spacer(),
                Text(hallazgo.severidad,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 8),
            Text(hallazgo.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(hallazgo.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
