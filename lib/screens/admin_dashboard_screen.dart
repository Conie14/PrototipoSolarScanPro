import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/admin_drawer.dart';
import 'admin_placeholder_screen.dart';
import 'gestion_usuarios_screen.dart';
import 'gestion_clientes_screen.dart';
import 'gestion_proyectos_screen.dart';
import 'admin_estadisticas_screen.dart';
import 'admin_parametros_screen.dart';
import 'admin_descargas_screen.dart';
import 'admin_historial_screen.dart';
import 'admin_plantillas_screen.dart';

/// Shell de navegación del rol Admin: header + drawer + contenido según ruta.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  String _route = 'dashboard';
  int _navIndex = 0;

  Widget _buildBody() {
    switch (_route) {
      case 'dashboard':
        return AdminDashboardBody(onNavigate: (r) => setState(() => _route = r));
      case 'usuarios':
        return const GestionUsuariosBody();
      case 'clientes':
        return const GestionClientesBody();
      case 'proyectos':
        return const GestionProyectosBody();
      case 'estadisticas':
        return const AdminEstadisticasBody();
      case 'parametros':
        return const AdminParametrosBody();
      case 'descargas':
        return const AdminDescargasBody();
      case 'historial':
        return const AdminHistorialBody();
      case 'plantillas':
        return const AdminPlantillasBody();
      default:
        return AdminPlaceholderBody(route: _route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(
        currentRoute: _route,
        onNavigate: (route) => setState(() => _route = route),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.grid_view_rounded, color: AppColors.primary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'SolarScan Pro',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              radius: 16,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) {
          setState(() {
            _navIndex = i;
            _route = switch (i) {
              0 => 'dashboard',
              1 => 'usuarios',
              2 => 'plantillas',
              3 => 'estadisticas',
              _ => 'dashboard',
            };
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.people_outline), label: 'Usuarios'),
          NavigationDestination(
              icon: Icon(Icons.description_outlined), label: 'Plantillas'),
          NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined), label: 'Estadísticas'),
        ],
      ),
    );
  }
}

/// Contenido de la pantalla "Dashboard Admin" (sin su propio Scaffold,
/// vive dentro del AdminShell).
class AdminDashboardBody extends StatelessWidget {
  final void Function(String route) onNavigate;
  const AdminDashboardBody({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.64,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Resumen general del sistema y métricas operativas.',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => onNavigate('proyectos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nuevo Proyecto'),
              ),
              OutlinedButton.icon(
                onPressed: () => onNavigate('usuarios'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                icon: const Icon(Icons.person_add_alt_1, size: 16),
                label: const Text('Añadir Usuario'),
              ),
              OutlinedButton(
                onPressed: () => onNavigate('parametros'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Icon(Icons.settings, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _KpiCard(
            accent: AppColors.kpiOrange,
            icon: Icons.apartment,
            iconBg: const Color(0xFFFFDCC3),
            iconColor: AppColors.kpiOrange,
            label: 'Proyectos Activos',
            value: '142',
            footer: '+12% este mes',
            footerIcon: Icons.trending_up,
            onTap: () => onNavigate('proyectos'),
          ),
          const SizedBox(height: 16),
          _KpiCard(
            accent: AppColors.kpiBlue,
            icon: Icons.groups_2,
            iconBg: const Color(0xFFD7E3FF),
            iconColor: AppColors.kpiBlue,
            label: 'Usuarios en Campo',
            value: '87',
            footer: '65 online ahora',
            footerIcon: Icons.sync,
            onTap: () => onNavigate('usuarios'),
          ),
          const SizedBox(height: 16),
          _KpiCard(
            accent: AppColors.kpiBrown,
            icon: Icons.domain,
            iconBg: const Color(0xFFFFE7C2),
            iconColor: AppColors.kpiBrown,
            label: 'Clientes Corp.',
            value: '34',
            footer: '2 renovaciones pdtes.',
            footerIcon: Icons.check_circle_outline,
            onTap: () => onNavigate('clientes'),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final String footer;
  final IconData footerIcon;
  final VoidCallback? onTap;

  const _KpiCard({
    required this.accent,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.footer,
    required this.footerIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 8, color: accent),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(icon, color: iconColor, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.64,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(footerIcon, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      footer,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
