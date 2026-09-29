import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/login_screen.dart';

/// Drawer lateral del rol Técnico, recreado desde Figma
/// ("Técnico - Menú Lateral de Navegación").
class TecnicoDrawer extends StatelessWidget {
  final String currentRoute;
  final void Function(String route) onNavigate;

  const TecnicoDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  static const _items = [
    _Item('dashboard', Icons.grid_view_rounded, 'Dashboard', null),
    _Item('proyectos', Icons.work_outline, 'Mis Proyectos', null),
    _Item('sincronizacion', Icons.sync, 'Sincronización Pendiente', '3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      width: 288,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Alan Gomez',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _items.map((item) {
                final selected = item.route == currentRoute;
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.background : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    leading: Icon(item.icon,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    trailing: item.badge == null
                        ? null
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.badge!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onNavigate(item.route);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error)),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Item {
  final String route;
  final IconData icon;
  final String label;
  final String? badge;
  const _Item(this.route, this.icon, this.label, this.badge);
}
