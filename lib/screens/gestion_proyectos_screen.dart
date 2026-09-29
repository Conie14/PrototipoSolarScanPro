import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/proyectos_ejemplo.dart';
import 'dashboard_proyecto_screen.dart';

class GestionProyectosBody extends StatefulWidget {
  const GestionProyectosBody({super.key});

  @override
  State<GestionProyectosBody> createState() => _GestionProyectosBodyState();
}

class _GestionProyectosBodyState extends State<GestionProyectosBody> {
  final List<_Proyecto> _proyectos = [
    for (final p in ProyectosEjemplo.todos)
      _Proyecto(
        accent: p.accent,
        nombre: p.nombre,
        tipo: p.tipo,
        cliente: p.cliente,
        supervisor: p.supervisor,
        proyectoEjemploId: p.id,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Proyectos Activos',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.64,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar proyecto...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF727785)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < _proyectos.length; i++) ...[
                _ProyectoCard(
                  proyecto: _proyectos[i],
                  onEdit: () async {
                    final result = await showDialog<_Proyecto>(
                      context: context,
                      builder: (_) => _ProyectoFormDialog(proyectoInicial: _proyectos[i]),
                    );
                    if (result != null) setState(() => _proyectos[i] = result);
                  },
                  onVerDetalles: () => _mostrarDetalles(context, _proyectos[i]),
                ),
                const SizedBox(height: 16),
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
            onPressed: () async {
              final result = await showDialog<_Proyecto>(
                context: context,
                builder: (_) => const _ProyectoFormDialog(),
              );
              if (result != null) {
                setState(() => _proyectos.add(result));
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalles(BuildContext context, _Proyecto p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(p.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.tipo,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            _DetalleRow('Cliente', p.cliente),
            _DetalleRow('Supervisor Asignado', p.supervisor),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              final ejemplo = ProyectosEjemplo.porId(p.proyectoEjemploId);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ejemplo != null
                    ? DashboardProyectoScreen.deEjemplo(ejemplo)
                    : DashboardProyectoScreen(nombreEmpresa: p.cliente.toUpperCase()),
              ));
            },
            icon: const Icon(Icons.dashboard_outlined, size: 16),
            label: const Text('Ver Dashboard'),
          ),
        ],
      ),
    );
  }
}

class _DetalleRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetalleRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _Proyecto {
  final Color accent;
  final String nombre;
  final String tipo;
  final String cliente;
  final String supervisor;
  final String? proyectoEjemploId;
  const _Proyecto({
    required this.accent,
    required this.nombre,
    required this.tipo,
    required this.cliente,
    required this.supervisor,
    this.proyectoEjemploId,
  });
}

class _ProyectoCard extends StatelessWidget {
  final _Proyecto proyecto;
  final VoidCallback onEdit;
  final VoidCallback onVerDetalles;
  const _ProyectoCard({required this.proyecto, required this.onEdit, required this.onVerDetalles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 8, color: proyecto.accent),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(proyecto.nombre,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(proyecto.tipo,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      color: AppColors.textSecondary,
                      onPressed: onEdit,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CLIENTE',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                  color: AppColors.textSecondary)),
                          Text(proyecto.cliente,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SUPERVISOR',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                  color: AppColors.textSecondary)),
                          Text(proyecto.supervisor,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFFF5F3F3),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onVerDetalles,
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                child: const Text('Ver Detalles',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProyectoFormDialog extends StatefulWidget {
  final _Proyecto? proyectoInicial;
  const _ProyectoFormDialog({this.proyectoInicial});

  @override
  State<_ProyectoFormDialog> createState() => _ProyectoFormDialogState();
}

class _ProyectoFormDialogState extends State<_ProyectoFormDialog> {
  late final _nombreCtrl = TextEditingController(text: widget.proyectoInicial?.nombre ?? '');
  late final _clienteCtrl = TextEditingController(text: widget.proyectoInicial?.cliente ?? '');
  late final _supervisorCtrl = TextEditingController(text: widget.proyectoInicial?.supervisor ?? '');
  late String _tipo = _tipos.firstWhere(
    (t) => t.toUpperCase() == widget.proyectoInicial?.tipo,
    orElse: () => _tipos.first,
  );

  bool get _editando => widget.proyectoInicial != null;

  static const _tipos = [
    'Viabilidad FV',
    'Mantenimiento',
    'Inspección Inicial',
    'Auditoría Final',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 512),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.work_outline, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_editando ? 'Editar Proyecto' : 'Nuevo Proyecto',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Field(label: 'Nombre del Proyecto', hint: 'Ej. Planta Solar Alpha', controller: _nombreCtrl),
                    const SizedBox(height: 20),
                    _Field(label: 'Cliente', hint: 'Ej. EnerTech Corp', controller: _clienteCtrl),
                    const SizedBox(height: 20),
                    _Field(label: 'Supervisor Asignado', hint: 'Ej. J. Martínez', controller: _supervisorCtrl),
                    const SizedBox(height: 20),
                    const Text('Tipo de Proyecto',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF727785)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _tipo,
                          isExpanded: true,
                          items: _tipos
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (v) => setState(() => _tipo = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE4E2E2))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_nombreCtrl.text.trim().isEmpty) return;
                      Navigator.of(context).pop(_Proyecto(
                        accent: widget.proyectoInicial?.accent ?? AppColors.primary,
                        nombre: _nombreCtrl.text.trim(),
                        tipo: _tipo.toUpperCase(),
                        cliente: _clienteCtrl.text.trim(),
                        supervisor: _supervisorCtrl.text.trim(),
                      ));
                    },
                    icon: const Icon(Icons.save_outlined, size: 15),
                    label: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const _Field({required this.label, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF727785)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF727785)),
            ),
          ),
        ),
      ],
    );
  }
}
