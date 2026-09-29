import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'user_form_dialog.dart';

class GestionUsuariosBody extends StatefulWidget {
  const GestionUsuariosBody({super.key});

  @override
  State<GestionUsuariosBody> createState() => _GestionUsuariosBodyState();
}

class _GestionUsuariosBodyState extends State<GestionUsuariosBody> {
  final List<_Usuario> _usuarios = List.generate(
    5,
    (_) => const _Usuario(iniciales: 'JD', nombre: 'Juan Díaz', rol: 'Técnico', activo: true),
  );

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
                'Gestión de Usuarios',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.64,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Administre accesos y roles del equipo técnico.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar usuarios...',
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
              for (final u in _usuarios) ...[
                _UsuarioTile(
                  usuario: u,
                  onEdit: () async {
                    final result = await showDialog<Map<String, String>>(
                      context: context,
                      builder: (_) => UserFormDialog(
                        title: 'Editar usuario',
                        nombreInicial: u.nombre,
                        rolInicial: u.rol,
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        final i = _usuarios.indexOf(u);
                        _usuarios[i] = _Usuario(
                          iniciales: _initials(result['nombre']!),
                          nombre: result['nombre']!,
                          rol: result['rol']!,
                          activo: u.activo,
                        );
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onPressed: () async {
              final result = await showDialog<Map<String, String>>(
                context: context,
                builder: (_) => const UserFormDialog(title: 'Crear usuario'),
              );
              if (result != null) {
                setState(() {
                  _usuarios.add(_Usuario(
                    iniciales: _initials(result['nombre']!),
                    nombre: result['nombre']!,
                    rol: result['rol']!,
                    activo: true,
                  ));
                });
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '??';
    final first = parts[0][0];
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
}

class _Usuario {
  final String iniciales;
  final String nombre;
  final String rol;
  final bool activo;
  const _Usuario({
    required this.iniciales,
    required this.nombre,
    required this.rol,
    required this.activo,
  });
}

class _UsuarioTile extends StatelessWidget {
  final _Usuario usuario;
  final VoidCallback onEdit;
  const _UsuarioTile({required this.usuario, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAE8E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              usuario.iniciales,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(usuario.nombre,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(usuario.rol,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEDED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              usuario.activo ? 'Activo' : 'Inactivo',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  color: AppColors.textSecondary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.textSecondary,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
