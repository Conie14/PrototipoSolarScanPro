import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Hallazgo {
  final String codigo;
  final String titulo;
  final String descripcion;
  final String severidad; // Alto, Medio, Bajo
  final String categoria;
  final String ubicacion;

  const Hallazgo({
    required this.codigo,
    required this.titulo,
    required this.descripcion,
    required this.severidad,
    required this.categoria,
    required this.ubicacion,
  });
}

/// "Técnico - Registrar Nuevo Hallazgo" / "Editar Hallazgo" (Figma 1:9013 / 1:9097).
/// Un mismo formulario reutilizado para crear y editar.
class TecnicoHallazgoFormScreen extends StatefulWidget {
  final Hallazgo? hallazgoInicial;
  const TecnicoHallazgoFormScreen({super.key, this.hallazgoInicial});

  @override
  State<TecnicoHallazgoFormScreen> createState() => _TecnicoHallazgoFormScreenState();
}

class _TecnicoHallazgoFormScreenState extends State<TecnicoHallazgoFormScreen> {
  static const _categorias = ['Estructural', 'Eléctrico', 'Limpieza', 'Seguridad'];
  static const _severidades = ['Alto', 'Medio', 'Bajo'];

  late final _tituloCtrl = TextEditingController(text: widget.hallazgoInicial?.titulo ?? '');
  late final _descripcionCtrl =
      TextEditingController(text: widget.hallazgoInicial?.descripcion ?? '');
  late final _ubicacionCtrl = TextEditingController(text: widget.hallazgoInicial?.ubicacion ?? '');
  late String _categoria = widget.hallazgoInicial?.categoria ?? _categorias.first;
  late String _severidad = widget.hallazgoInicial?.severidad ?? _severidades.first;

  bool get _editando => widget.hallazgoInicial != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_editando ? 'Editar Hallazgo' : 'Registrar Nuevo Hallazgo',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Documente detalles técnicos y evidencia del hallazgo en el sitio.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            const _FieldLabel('Título del hallazgo'),
            TextField(
              controller: _tituloCtrl,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Categoría'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categorias.map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: _categoria == c,
                  onSelected: (_) => setState(() => _categoria = c),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _categoria == c ? Colors.white : AppColors.textPrimary),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Nivel de severidad'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _severidades.map((s) {
                final selected = _severidad == s;
                final color = _severidadColor(s);
                return ChoiceChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (_) => setState(() => _severidad = s),
                  selectedColor: color,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Descripción detallada'),
            TextField(
              controller: _descripcionCtrl,
              maxLines: 4,
              decoration: _inputDecoration(hint: 'Describa el hallazgo...'),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Ubicación específica'),
            TextField(
              controller: _ubicacionCtrl,
              decoration: _inputDecoration(hint: 'Ej. Sector 4, Array B, Panel 12'),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Adjuntar evidencia'),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Abriendo cámara...')));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Foto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Abriendo selector de archivos...')));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.attach_file, size: 18),
                    label: const Text('Archivo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: const Text('Guardar Hallazgo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _guardar() {
    if (_tituloCtrl.text.trim().isEmpty) return;
    Navigator.of(context).pop(
      Hallazgo(
        codigo: widget.hallazgoInicial?.codigo ?? 'NEW-${DateTime.now().millisecondsSinceEpoch % 1000}',
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        severidad: _severidad,
        categoria: _categoria,
        ubicacion: _ubicacionCtrl.text.trim(),
      ),
    );
  }

  static Color _severidadColor(String s) {
    switch (s) {
      case 'Alto':
        return AppColors.severityHighText;
      case 'Medio':
        return AppColors.severityMediumBg;
      default:
        return AppColors.textSecondary;
    }
  }

  static InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }
}
