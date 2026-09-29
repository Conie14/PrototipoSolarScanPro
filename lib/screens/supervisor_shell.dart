import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/supervisor_drawer.dart';
import 'supervisor_dashboard_screen.dart';
import 'nueva_visita_screen.dart';
import 'revision_levantamiento_screen.dart';
import 'supervisor_proyectos_screen.dart';
import 'supervisor_agenda_screen.dart';
import 'supervisor_reportes_screen.dart';
import 'supervisor_historial_screen.dart';

class SupervisorShell extends StatefulWidget {
  const SupervisorShell({super.key});

  @override
  State<SupervisorShell> createState() => _SupervisorShellState();
}

class _SupervisorShellState extends State<SupervisorShell> {
  String _route = 'dashboard';
  bool _nuevaVisita = false;
  String? _proyectoParaVisita;
  String _proyectoEnRevision = 'PRJ-9921A';

  static const _bottomNavRoutes = ['dashboard', 'proyectos', 'reportes', 'historial'];

  void _abrirNuevaVisita({String? proyecto}) {
    setState(() {
      _proyectoParaVisita = proyecto;
      _nuevaVisita = true;
    });
  }

  void _abrirRevision(String proyecto) {
    setState(() {
      _proyectoEnRevision = proyecto;
      _route = 'revisiones';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_nuevaVisita) {
      return NuevaVisitaScreen(
        proyectoInicial: _proyectoParaVisita,
        onCancel: () => setState(() => _nuevaVisita = false),
        onAgendada: () {
          setState(() => _nuevaVisita = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita agendada correctamente')),
          );
        },
      );
    }

    return Scaffold(
      drawer: SupervisorDrawer(
        currentRoute: _route,
        onNavigate: (route) => setState(() => _route = route),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('SolarScan Pro',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('No tienes notificaciones nuevas')));
            },
          ),
        ],
      ),
      body: switch (_route) {
        'dashboard' => SupervisorDashboardBody(
            onNuevaVisita: _abrirNuevaVisita,
            onVisitar: (p) => _abrirNuevaVisita(proyecto: p),
            onRevisar: _abrirRevision,
          ),
        'proyectos' => SupervisorProyectosBody(onVerRevision: _abrirRevision),
        'agenda' => SupervisorAgendaBody(onNuevaVisita: _abrirNuevaVisita),
        'revisiones' => RevisionLevantamientoBody(proyecto: _proyectoEnRevision),
        'reportes' => const SupervisorReportesBody(),
        'historial' => const SupervisorHistorialBody(),
        _ => SupervisorDashboardBody(
            onNuevaVisita: _abrirNuevaVisita,
            onVisitar: (p) => _abrirNuevaVisita(proyecto: p),
            onRevisar: _abrirRevision,
          ),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomNavRoutes.contains(_route) ? _bottomNavRoutes.indexOf(_route) : 0,
        onDestinationSelected: (i) => setState(() => _route = _bottomNavRoutes[i]),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.work_outline), label: 'Proyectos'),
          NavigationDestination(
              icon: Icon(Icons.summarize_outlined), label: 'Reportes'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }
}
