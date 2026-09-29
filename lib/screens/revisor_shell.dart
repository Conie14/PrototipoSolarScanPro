import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/revisor_drawer.dart';
import 'revisor_dashboard_screen.dart';
import 'revisor_validacion_screen.dart';
import 'revisor_observaciones_screen.dart';
import 'revisor_decision_screen.dart';
import 'revisor_measurements_screen.dart';
import 'revisor_evidence_screen.dart';
import 'revisor_review_queue_screen.dart';

/// Shell de navegación del rol Revisor: header + drawer + bottom nav +
/// flujo de validación (Dashboard → Validación → Observaciones/Decisión).
class RevisorShell extends StatefulWidget {
  const RevisorShell({super.key});

  @override
  State<RevisorShell> createState() => _RevisorShellState();
}

class _RevisorShellState extends State<RevisorShell> {
  final String _route = 'dashboard';
  int _navIndex = 0;

  void _abrirProyecto(String proyectoId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RevisorValidacionScreen(
        proyectoId: proyectoId,
        onSolicitarCorrecciones: () => _irAObservaciones(proyectoId),
        onAprobar: () => _irADecision(proyectoId),
      ),
    ));
  }

  void _irAObservaciones(String proyectoId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RevisorObservacionesScreen(
        proyectoId: proyectoId,
        onGuardado: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Observaciones guardadas')));
        },
        onSolicitarCorrecciones: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Correcciones solicitadas para $proyectoId')));
        },
      ),
    ));
  }

  void _irADecision(String proyectoId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RevisorDecisionScreen(
        proyectoId: proyectoId,
        onDecision: (aprobado) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(aprobado
                ? 'Proyecto $proyectoId aprobado correctamente'
                : 'Proyecto $proyectoId rechazado'),
          ));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: RevisorDrawer(currentRoute: _route, onNavigate: (_) {}),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('SolarScan Pro',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: switch (_navIndex) {
        1 => RevisorMeasurementsBody(onAbrirProyecto: _abrirProyecto),
        2 => RevisorEvidenceBody(onAbrirProyecto: _abrirProyecto),
        3 => RevisorReviewQueueBody(onDecidir: _irADecision),
        _ => RevisorDashboardBody(onAbrirProyecto: _abrirProyecto),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.fact_check_outlined), label: 'Cola'),
          NavigationDestination(icon: Icon(Icons.speed_outlined), label: 'Mediciones'),
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: 'Evidencia'),
          NavigationDestination(icon: Icon(Icons.rate_review_outlined), label: 'Revisión'),
        ],
      ),
    );
  }
}
