import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/login_screen.dart';

/// Drawer lateral de Admin, recreado desde Figma ("Panel Administrativo - Menú Lateral").
/// Reutilizable en todas las pantallas del rol Admin.
class AdminDrawer extends StatelessWidget {
  final String currentRoute;
  final void Function(String route) onNavigate;

  const AdminDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  static const _items = [
    _DrawerItem('dashboard', Icons.grid_view_rounded, 'Dashboard'),
    _DrawerItem('usuarios', Icons.people_outline, 'Gestión de usuarios'),
    _DrawerItem('clientes', Icons.business_center_outlined, 'Gestión de Clientes'),
    _DrawerItem('proyectos', Icons.work_outline, 'Gestión de Proyectos'),
    _DrawerItem('plantillas', Icons.dashboard_customize_outlined, 'Gestion de Plantillas'),
    _DrawerItem('estadisticas', Icons.bar_chart_outlined, 'Estadisticas'),
    _DrawerItem('parametros', Icons.tune, 'Parámetros Generales'),
    _DrawerItem('descargas', Icons.download_outlined, 'Descargas'),
    _DrawerItem('historial', Icons.history, 'Historial'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F3F3),
      width: 288,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    Text('Industrial Inspection Suite',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                  ],
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
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    leading: Icon(item.icon,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: selected
                            ? const Color(0xFF333333)
                            : AppColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(); // cierra el drawer
                      onNavigate(item.route);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFBA1A1A)),
            title: const Text('Cerrar Sesión',
                style: TextStyle(color: Color(0xFFBA1A1A))),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final String route;
  final IconData icon;
  final String label;
  const _DrawerItem(this.route, this.icon, this.label);
}
