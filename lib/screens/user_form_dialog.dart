import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modal "Crear usuario" / "Editar usuario" recreado desde Figma.
/// Devuelve {'nombre': ..., 'rol': ...} al guardar, o null si se cancela.
class UserFormDialog extends StatefulWidget {
  final String title;
  final String? nombreInicial;
  final String? rolInicial;

  const UserFormDialog({
    super.key,
    required this.title,
    this.nombreInicial,
    this.rolInicial,
  });

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidosCtrl;
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _rol = 'Técnico';
  bool _acceso = true;

  static const _roles = ['Técnico', 'Supervisor', 'Revisor', 'Admin'];

  @override
  void initState() {
    super.initState();
    final partes = (widget.nombreInicial ?? '').split(' ');
    _nombreCtrl = TextEditingController(text: partes.isNotEmpty ? partes.first : '');
    _apellidosCtrl =
        TextEditingController(text: partes.length > 1 ? partes.sublist(1).join(' ') : '');
    if (widget.rolInicial != null) _rol = widget.rolInicial!;
  }

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
            // Header
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.person_add_alt_1, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.title,
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
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Field(label: 'Nombre', hint: 'Ej. Carlos Alejandro', controller: _nombreCtrl),
                    const SizedBox(height: 20),
                    _Field(label: 'Apellidos', hint: 'Ej. Mendoza', controller: _apellidosCtrl),
                    const SizedBox(height: 20),
                    _Field(
                        label: 'Correo Electrónico',
                        hint: 'carlos.m@solarscan.pro',
                        controller: _correoCtrl),
                    const SizedBox(height: 20),
                    _Field(
                        label: 'Contraseña',
                        hint: '••••••••••',
                        controller: _passCtrl,
                        obscure: true),
                    const SizedBox(height: 20),
                    const Text('Rol del Sistema',
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
                          value: _rol,
                          isExpanded: true,
                          items: _roles
                              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                              .toList(),
                          onChanged: (v) => setState(() => _rol = v!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3F3),
                        border: Border.all(color: AppColors.border.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(17),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Acceso al Sistema',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary)),
                                Text('Permitir ingreso a la plataforma',
                                    style: TextStyle(
                                        fontSize: 14, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Switch(
                            value: _acceso,
                            activeColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            onChanged: (v) => setState(() => _acceso = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer
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
                      final nombreCompleto =
                          '${_nombreCtrl.text.trim()} ${_apellidosCtrl.text.trim()}'.trim();
                      if (nombreCompleto.isEmpty) return;
                      Navigator.of(context)
                          .pop({'nombre': nombreCompleto, 'rol': _rol});
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
  final bool obscure;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
  });

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
          obscureText: obscure,
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
