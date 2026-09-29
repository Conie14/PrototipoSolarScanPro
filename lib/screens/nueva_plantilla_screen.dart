import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/campo_formulario.dart';

const _tiposDisponibles = [
  (TipoCampoFormulario.texto, 'Texto libre', Icons.short_text),
  (TipoCampoFormulario.numero, 'Número', Icons.numbers),
  (TipoCampoFormulario.seleccion, 'Selección (opciones)', Icons.list_alt_outlined),
  (TipoCampoFormulario.siNo, 'Sí / No', Icons.check_circle_outline),
  (TipoCampoFormulario.foto, 'Fotografía', Icons.camera_alt_outlined),
  (TipoCampoFormulario.firma, 'Firma', Icons.draw_outlined),
];

String _etiquetaTipo(TipoCampoFormulario t) =>
    _tiposDisponibles.firstWhere((e) => e.$1 == t, orElse: () => _tiposDisponibles.first).$2;

IconData _iconoTipo(TipoCampoFormulario t) =>
    _tiposDisponibles.firstWhere((e) => e.$1 == t, orElse: () => _tiposDisponibles.first).$3;

class NuevaPlantillaResultado {
  final String nombre;
  final String rol;
  final List<CampoFormulario> campos;
  const NuevaPlantillaResultado({required this.nombre, required this.rol, required this.campos});
}

/// Constructor de plantillas: el Admin define el nombre, el rol al que se
/// asigna, y agrega una a una las preguntas que la plantilla solicitará en
/// campo — incluyendo su tipo de respuesta (texto, número, selección con
/// opciones propias, sí/no, fotografía o firma) y si es obligatoria.
class NuevaPlantillaScreen extends StatefulWidget {
  const NuevaPlantillaScreen({super.key});

  @override
  State<NuevaPlantillaScreen> createState() => _NuevaPlantillaScreenState();
}

class _NuevaPlantillaScreenState extends State<NuevaPlantillaScreen> {
  final _nombreCtrl = TextEditingController();
  String _rol = 'Técnico';
  final List<CampoFormulario> _preguntas = [];

  final _etiquetaCtrl = TextEditingController();
  final _opcionesCtrl = TextEditingController();
  TipoCampoFormulario _tipoNuevo = TipoCampoFormulario.texto;
  bool _obligatorioNuevo = true;

  static const _roles = ['Técnico', 'Supervisor', 'Revisor', 'Admin'];

  void _agregarPregunta() {
    final etiqueta = _etiquetaCtrl.text.trim();
    if (etiqueta.isEmpty) return;
    final opciones = _tipoNuevo == TipoCampoFormulario.seleccion
        ? _opcionesCtrl.text.split(',').map((o) => o.trim()).where((o) => o.isNotEmpty).toList()
        : const <String>[];
    if (_tipoNuevo == TipoCampoFormulario.seleccion && opciones.length < 2) return;

    setState(() {
      _preguntas.add(CampoFormulario(
        id: 'campo_${_preguntas.length}_${DateTime.now().millisecondsSinceEpoch}',
        etiqueta: etiqueta,
        tipo: _tipoNuevo,
        opciones: opciones,
        obligatorio: _obligatorioNuevo,
      ));
      _etiquetaCtrl.clear();
      _opcionesCtrl.clear();
      _tipoNuevo = TipoCampoFormulario.texto;
      _obligatorioNuevo = true;
    });
  }

  void _eliminarPregunta(int i) => setState(() => _preguntas.removeAt(i));

  bool get _puedeCrear => _nombreCtrl.text.trim().isNotEmpty && _preguntas.isNotEmpty;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _etiquetaCtrl.dispose();
    _opcionesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Nueva Plantilla',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nombre de la plantilla',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            TextField(
              controller: _nombreCtrl,
              onChanged: (_) => setState(() {}),
              decoration: _decoration('Ej. Inspección de Bodegas'),
            ),
            const SizedBox(height: 16),
            const Text('Rol asignado', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _rol,
                  isExpanded: true,
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setState(() => _rol = v!),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
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
                  const Text('Agregar pregunta', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _etiquetaCtrl,
                    decoration: _decoration('Texto de la pregunta...'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Tipo de respuesta', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tiposDisponibles.map((t) {
                      final seleccionado = _tipoNuevo == t.$1;
                      return ChoiceChip(
                        avatar: Icon(t.$3, size: 16, color: seleccionado ? AppColors.primary : AppColors.textMuted),
                        label: Text(t.$2, style: const TextStyle(fontSize: 12)),
                        selected: seleccionado,
                        onSelected: (_) => setState(() => _tipoNuevo = t.$1),
                        selectedColor: AppColors.primaryLight.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                            color: seleccionado ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal),
                      );
                    }).toList(),
                  ),
                  if (_tipoNuevo == TipoCampoFormulario.seleccion) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _opcionesCtrl,
                      decoration: _decoration('Opciones separadas por coma. Ej: Lámina, Teja, Concreto'),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Switch(
                        value: _obligatorioNuevo,
                        onChanged: (v) => setState(() => _obligatorioNuevo = v),
                        activeThumbColor: AppColors.primary,
                      ),
                      const Text('Es obligatoria', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _agregarPregunta,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Agregar Pregunta'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Preguntas de la plantilla (${_preguntas.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            if (_preguntas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Aún no ha agregado ninguna pregunta.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ),
            for (var i = 0; i < _preguntas.length; i++) ...[
              _PreguntaTile(campo: _preguntas[i], numero: i + 1, onEliminar: () => _eliminarPregunta(i)),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _puedeCrear
                ? () => Navigator.of(context).pop(NuevaPlantillaResultado(
                      nombre: _nombreCtrl.text.trim(),
                      rol: _rol,
                      campos: List.of(_preguntas),
                    ))
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.border,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Crear Plantilla', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        isDense: true,
        hintText: hint,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      );
}

class _PreguntaTile extends StatelessWidget {
  final CampoFormulario campo;
  final int numero;
  final VoidCallback onEliminar;
  const _PreguntaTile({required this.campo, required this.numero, required this.onEliminar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.background,
            child: Text('$numero', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(campo.etiqueta, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Badge(icon: _iconoTipo(campo.tipo), texto: _etiquetaTipo(campo.tipo)),
                    _Badge(
                      icon: campo.obligatorio ? Icons.priority_high : Icons.remove,
                      texto: campo.obligatorio ? 'Obligatoria' : 'Opcional',
                    ),
                  ],
                ),
                if (campo.opciones.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Opciones: ${campo.opciones.join(', ')}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
            onPressed: onEliminar,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String texto;
  const _Badge({required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(texto, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
