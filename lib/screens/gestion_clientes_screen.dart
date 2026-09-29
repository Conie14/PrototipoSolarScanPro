import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GestionClientesBody extends StatefulWidget {
  const GestionClientesBody({super.key});

  @override
  State<GestionClientesBody> createState() => _GestionClientesBodyState();
}

class _GestionClientesBodyState extends State<GestionClientesBody> {
  final List<_Cliente> _clientes = [
    const _Cliente(
      iniciales: 'EE',
      color: AppColors.primaryLight,
      nombre: 'EcoEnergía S.A.',
      id: 'ID: B-12345678',
      contacto: 'Carlos Mendoza',
      direccion: 'Av. del Sol 450, Madrid',
    ),
    const _Cliente(
      iniciales: 'SP',
      color: Color(0xFFB85A00),
      nombre: 'SolarPro Tech',
      id: 'ID: A-98765432',
      contacto: 'Laura Gómez',
      direccion: 'Polígono Ind. Norte, Nave 3, Barcelona',
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
                'Clientes Corporativos',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.64,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Gestione la cartera de empresas para inspecciones solares.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar clientes...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < _clientes.length; i++) ...[
                _ClienteCard(
                  cliente: _clientes[i],
                  onEdit: () async {
                    final result = await showDialog<_Cliente>(
                      context: context,
                      builder: (_) => _ClienteFormDialog(clienteInicial: _clientes[i]),
                    );
                    if (result != null) setState(() => _clientes[i] = result);
                  },
                  onVerDetalles: () => _mostrarDetalles(context, _clientes[i]),
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
              final result = await showDialog<_Cliente>(
                context: context,
                builder: (_) => const _ClienteFormDialog(),
              );
              if (result != null) {
                setState(() => _clientes.add(result));
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalles(BuildContext context, _Cliente c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(c.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.id,
                style: const TextStyle(
                    fontFamily: 'monospace', fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            _DetalleRow('Contacto', c.contacto),
            _DetalleRow('Dirección', c.direccion),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
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

class _Cliente {
  final String iniciales;
  final Color color;
  final String nombre;
  final String id;
  final String contacto;
  final String direccion;
  const _Cliente({
    required this.iniciales,
    required this.color,
    required this.nombre,
    required this.id,
    required this.contacto,
    required this.direccion,
  });
}

class _ClienteCard extends StatelessWidget {
  final _Cliente cliente;
  final VoidCallback onEdit;
  final VoidCallback onVerDetalles;
  const _ClienteCard({required this.cliente, required this.onEdit, required this.onVerDetalles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cliente.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(cliente.iniciales,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cliente.nombre,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text(cliente.id,
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.textSecondary,
                onPressed: onEdit,
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE4E2E2)),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 12),
              Text(cliente.contacto, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 12),
              Expanded(child: Text(cliente.direccion, style: const TextStyle(fontSize: 14))),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE4E2E2)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onVerDetalles,
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('Ver Detalles',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClienteFormDialog extends StatefulWidget {
  final _Cliente? clienteInicial;
  const _ClienteFormDialog({this.clienteInicial});

  @override
  State<_ClienteFormDialog> createState() => _ClienteFormDialogState();
}

class _ClienteFormDialogState extends State<_ClienteFormDialog> {
  late final _nombreCtrl = TextEditingController(text: widget.clienteInicial?.nombre ?? '');
  late final _idCtrl =
      TextEditingController(text: widget.clienteInicial?.id.replaceFirst('ID: ', '') ?? '');
  late final _contactoCtrl = TextEditingController(text: widget.clienteInicial?.contacto ?? '');
  late final _direccionCtrl = TextEditingController(text: widget.clienteInicial?.direccion ?? '');

  bool get _editando => widget.clienteInicial != null;

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
                  const Icon(Icons.business_center_outlined,
                      size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_editando ? 'Editar Cliente' : 'Registrar Cliente',
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
                    _Field(label: 'Nombre de la Empresa', hint: 'Ej. EcoEnergía S.A.', controller: _nombreCtrl),
                    const SizedBox(height: 20),
                    _Field(label: 'ID Fiscal', hint: 'Ej. B-12345678', controller: _idCtrl),
                    const SizedBox(height: 20),
                    _Field(label: 'Persona de Contacto', hint: 'Ej. Carlos Mendoza', controller: _contactoCtrl),
                    const SizedBox(height: 20),
                    _Field(label: 'Dirección', hint: 'Av. del Sol 450, Madrid', controller: _direccionCtrl),
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
                      Navigator.of(context).pop(_Cliente(
                        iniciales: _initials(_nombreCtrl.text),
                        color: widget.clienteInicial?.color ?? AppColors.primaryLight,
                        nombre: _nombreCtrl.text.trim(),
                        id: 'ID: ${_idCtrl.text.trim()}',
                        contacto: _contactoCtrl.text.trim(),
                        direccion: _direccionCtrl.text.trim(),
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

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '??';
    return parts.first.substring(0, 1).toUpperCase() +
        (parts.length > 1 ? parts[1].substring(0, 1).toUpperCase() : '');
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
