import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Información General del Sitio, con campos condicionales según la
/// respuesta a "¿Existe sistema FV?" (Documento de Requerimientos, sección 9).
/// Primer paso del levantamiento, antes de la captura de evidencia.
class TecnicoInfoGeneralScreen extends StatefulWidget {
  final VoidCallback onSiguiente;
  const TecnicoInfoGeneralScreen({super.key, required this.onSiguiente});

  @override
  State<TecnicoInfoGeneralScreen> createState() => _TecnicoInfoGeneralScreenState();
}

class _TecnicoInfoGeneralScreenState extends State<TecnicoInfoGeneralScreen> {
  bool? _existeSistemaFV;
  final _numModulosCtrl = TextEditingController();
  final _fabricanteCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _potenciaCtrl = TextEditingController();
  final _numInversoresCtrl = TextEditingController();
  String _canalizacion = 'Superficial';
  bool _requiereTablerosAsociados = true;

  static const _canalizaciones = ['Superficial', 'Empotrada', 'Subterránea', 'Aérea'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Información General',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información del Sitio',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Complete los datos generales antes de iniciar la captura de evidencia.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
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
                  const Text('¿Existe sistema FV?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: true,
                          groupValue: _existeSistemaFV,
                          activeColor: AppColors.primary,
                          onChanged: (v) => setState(() => _existeSistemaFV = v),
                          title: const Text('Sí'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: false,
                          groupValue: _existeSistemaFV,
                          activeColor: AppColors.primary,
                          onChanged: (v) => setState(() => _existeSistemaFV = v),
                          title: const Text('No'),
                        ),
                      ),
                    ],
                  ),
                  if (_existeSistemaFV == true) ...[
                    const Divider(height: 24, color: AppColors.border),
                    const _FieldLabel('Número de módulos'),
                    TextField(
                        controller: _numModulosCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _dec()),
                    const SizedBox(height: 14),
                    const _FieldLabel('Fabricante'),
                    TextField(controller: _fabricanteCtrl, decoration: _dec()),
                    const SizedBox(height: 14),
                    const _FieldLabel('Modelo'),
                    TextField(controller: _modeloCtrl, decoration: _dec()),
                    const SizedBox(height: 14),
                    const _FieldLabel('Potencia (W)'),
                    TextField(
                        controller: _potenciaCtrl, keyboardType: TextInputType.number, decoration: _dec()),
                    const SizedBox(height: 14),
                    const _FieldLabel('Número de inversores'),
                    TextField(
                        controller: _numInversoresCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _dec()),
                    const SizedBox(height: 14),
                    const _FieldLabel('Canalización'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _canalizaciones.map((c) {
                        final sel = _canalizacion == c;
                        return ChoiceChip(
                          label: Text(c),
                          selected: sel,
                          onSelected: (_) => setState(() => _canalizacion = c),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textPrimary),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                      value: _requiereTablerosAsociados,
                      onChanged: (v) => setState(() => _requiereTablerosAsociados = v ?? true),
                      title: const Text('Registrar tableros asociados en este levantamiento'),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Estos campos aparecen porque indicó que sí existe un sistema fotovoltaico. '
                      'Se ocultarán automáticamente si cambia la respuesta a "No".',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                    ),
                  ] else if (_existeSistemaFV == false) ...[
                    const Divider(height: 24, color: AppColors.border),
                    const Text(
                      'No se solicitarán datos del sistema FV para este levantamiento.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _existeSistemaFV == null
                    ? null
                    : () => widget.onSiguiente(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Continuar a Captura de Evidencia',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _dec() => InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }
}
