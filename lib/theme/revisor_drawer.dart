import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/login_screen.dart';

/// Drawer lateral del rol Revisor, recreado desde Figma
/// ("Revisor - Menú Lateral de Navegación").
class RevisorDrawer extends StatelessWidget {
  final String currentRoute;
  final void Function(String route) onNavigate;

  const RevisorDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

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
                  child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ing. Roberto Morales',
                          style: TextStyle(
                              color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                      Text('Revisor Senior',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: currentRoute == 'dashboard' ? AppColors.background : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.work_outline, color: AppColors.primary),
                    title: const Text('Proyectos',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                    onTap: () {
                      Navigator.of(context).pop();
                      onNavigate('dashboard');
                    },
                  ),
                ),
              ],
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
