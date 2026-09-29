import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NuevaVisitaScreen extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onAgendada;
  final String? proyectoInicial;
  const NuevaVisitaScreen({
    super.key,
    required this.onCancel,
    required this.onAgendada,
    this.proyectoInicial,
  });

  @override
  State<NuevaVisitaScreen> createState() => _NuevaVisitaScreenState();
}

class _NuevaVisitaScreenState extends State<NuevaVisitaScreen> {
  late String? _proyecto = widget.proyectoInicial;
  String? _tecnico;
  String _tipoVisita = 'Levantamiento Inicial';
  bool _equipoEspecial = false;
  final _notasCtrl = TextEditingController();

  static const _proyectosBase = ['Planta Solar Alpha', 'Tejados Sur M-22', 'Planta Solar Norte'];
  List<String> get _proyectos => [
        ..._proyectosBase,
        if (widget.proyectoInicial != null && !_proyectosBase.contains(widget.proyectoInicial))
          widget.proyectoInicial!,
      ];
  static const _tecnicos = ['J. Miller', 'S. Connor', 'A. Gómez'];
  static const _tipos = [
    'Levantamiento Inicial',
    'Mantenimiento',
    'Auditoría',
    'Revisión de Garantía',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: widget.onCancel,
        ),
        title: const Text('Nueva Visita',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Detalles de la Visita',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Divider(height: 32, color: Color(0xFFE4E2E2)),
              _Dropdown(
                label: 'Proyecto',
                hint: 'Seleccione un proyecto...',
                value: _proyecto,
                items: _proyectos,
                onChanged: (v) => setState(() => _proyecto = v),
              ),
              const SizedBox(height: 24),
              _Dropdown(
                label: 'Técnico Asignado',
                hint: 'Seleccione un técnico...',
                value: _tecnico,
                items: _tecnicos,
                onChanged: (v) => setState(() => _tecnico = v),
              ),
              const SizedBox(height: 24),
              const Text('Fecha Programada', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFF6B7280)),
                  alignment: Alignment.centerLeft,
                ),
                icon: const Icon(Icons.calendar_today_outlined, size: 16),
                label: const Text('mm/dd/yyyy'),
              ),
              const SizedBox(height: 24),
              const Text('Hora Estimada', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () async {
                  await showTimePicker(context: context, initialTime: TimeOfDay.now());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFF6B7280)),
                  alignment: Alignment.centerLeft,
                ),
                icon: const Icon(Icons.access_time, size: 16),
                label: const Text('--:-- --'),
              ),
              const SizedBox(height: 24),
              const Text('Tipo de Visita', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              for (final t in _tipos)
                RadioListTile<String>(
                  value: t,
                  groupValue: _tipoVisita,
                  onChanged: (v) => setState(() => _tipoVisita = v!),
                  title: Text(t),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  tileColor: Colors.white,
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _equipoEspecial,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _equipoEspecial = v ?? false),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Requiere Equipo Especial',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          Text('Dron, cámara térmica, equipo de medición avanzada.',
                              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Instrucciones Especiales para el Técnico', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                controller: _notasCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ingrese detalles específicos, códigos de acceso, o precauciones de seguridad...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  onPressed: widget.onAgendada,
                  icon: const Icon(Icons.event_available, size: 16),
                  label: const Text('Agendar Visita'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: Color(0xFF727785), width: 2),
                  ),
                  onPressed: widget.onCancel,
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF6B7280))),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint, style: const TextStyle(color: Color(0xFF6B7280))),
              isExpanded: true,
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
