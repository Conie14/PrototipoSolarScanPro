import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/login_screen.dart';

class SupervisorDrawer extends StatelessWidget {
  final String currentRoute;
  final void Function(String route) onNavigate;

  const SupervisorDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  static const _items = [
    _Item('dashboard', Icons.grid_view_rounded, 'Dashboard'),
    _Item('proyectos', Icons.work_outline, 'Gestión de Proyectos'),
    _Item('agenda', Icons.event_outlined, 'Agenda de Campo'),
    _Item('revisiones', Icons.fact_check_outlined, 'Revisiones Pendientes'),
    _Item('reportes', Icons.summarize_outlined, 'Gestión de Reportes'),
    _Item('historial', Icons.history, 'Historial de Levantamientos'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      width: 288,
      child: Column(
        children: [
          const SizedBox(height: 24),
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
                  child: const Icon(Icons.supervisor_account, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Supervisor',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    Text('Industrial Inspection Suite',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(right: 16),
              children: _items.map((item) {
                final selected = item.route == currentRoute;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryLight : Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                  ),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(12))),
                    leading: Icon(item.icon,
                        color: selected ? Colors.white : AppColors.textSecondary),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                        color: selected ? Colors.white : AppColors.textSecondary,
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
            leading: const Icon(Icons.logout, color: Color(0xFFBA1A1A)),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Color(0xFFBA1A1A))),
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
  const _Item(this.route, this.icon, this.label);
}
