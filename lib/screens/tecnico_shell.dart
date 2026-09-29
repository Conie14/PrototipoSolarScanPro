import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/tecnico_drawer.dart';
import 'tecnico_dashboard_screen.dart';
import 'tecnico_detalle_proyecto_screen.dart';
import 'tecnico_proyectos_screen.dart';
import 'tecnico_info_general_screen.dart';
import 'tecnico_documentos_screen.dart';
import 'tecnico_captura_screen.dart';
import 'tecnico_mediciones_screen.dart';
import 'tecnico_hallazgos_screen.dart';
import 'tecnico_validacion_screen.dart';
import 'tecnico_firma_screen.dart';

/// Shell de navegación del rol Técnico: header + drawer + bottom nav +
/// flujo de levantamiento (Detalle → Fotos → Mediciones → Hallazgos → Firma).
class TecnicoShell extends StatefulWidget {
  const TecnicoShell({super.key});

  @override
  State<TecnicoShell> createState() => _TecnicoShellState();
}

class _TecnicoShellState extends State<TecnicoShell> {
  String _route = 'dashboard';
  String? _filtroProyectos;

  static const _routeToIndex = {'dashboard': 0, 'proyectos': 1, 'sincronizacion': 2};

  void _irA(String route) => setState(() {
        _route = route;
        if (route == 'proyectos') _filtroProyectos = null;
      });

  void _abrirProyectos({String? filtro}) {
    setState(() {
      _route = 'proyectos';
      _filtroProyectos = filtro;
    });
  }

  void _abrirProyecto(TecnicoProyecto p) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TecnicoDetalleProyectoScreen(
        proyecto: p,
        onIniciarLevantamiento: () => _iniciarLevantamiento(proyectoId: p.id),
      ),
    ));
  }

  void _abrirProyectoPorId(String id) {
    final p = kTecnicoProyectos.firstWhere((p) => p.id == id, orElse: () => kTecnicoProyectos.first);
    _abrirProyecto(p);
  }

  Future<void> _mostrarNuevaVisitaDialog() async {
    String proyecto = kTecnicoProyectos.first.nombre;
    String tipo = 'Visita No Programada';
    final notasCtrl = TextEditingController();

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Nueva Visita No Programada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Proyecto', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: proyecto,
                  isExpanded: true,
                  items: kTecnicoProyectos
                      .map((p) => DropdownMenuItem(value: p.nombre, child: Text(p.nombre)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => proyecto = v!),
                ),
                const SizedBox(height: 12),
                const Text('Motivo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: tipo,
                  isExpanded: true,
                  items: const [
                    'Visita No Programada',
                    'Emergencia',
                    'Seguimiento de Cliente',
                    'Revisión Adicional',
                  ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setDialogState(() => tipo = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notasCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(hintText: 'Notas (opcional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Iniciar Visita'),
            ),
          ],
        ),
      ),
    );

    if (confirmado == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Visita iniciada: $tipo · $proyecto')));
      await _iniciarLevantamiento();
    }
  }

  Future<void> _iniciarLevantamiento({String? proyectoId}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TecnicoInfoGeneralScreen(
        onSiguiente: () => _pushDocumentos(context, proyectoId),
      ),
    ));
  }

  void _pushDocumentos(BuildContext ctx, String? proyectoId) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => TecnicoDocumentosScreen(onSiguiente: () => _pushCaptura(ctx, proyectoId)),
    ));
  }

  void _pushCaptura(BuildContext ctx, String? proyectoId) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => TecnicoCapturaScreen(
        proyectoId: proyectoId,
        onSiguiente: () => _pushMediciones(ctx),
      ),
    ));
  }

  void _pushMediciones(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => TecnicoMedicionesScreen(onSiguiente: () => _pushHallazgos(ctx)),
    ));
  }

  void _pushHallazgos(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => TecnicoHallazgosScreen(onFinalizarCierre: () => _pushValidacion(ctx)),
    ));
  }

  void _pushValidacion(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => TecnicoValidacionScreen(onFinalizarVisita: () => _pushFirma(ctx)),
    ));
  }

  void _pushFirma(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => TecnicoFirmaScreen(
        onFinalizar: () {
          Navigator.of(ctx).popUntil((route) => route.isFirst);
          setState(() => _route = 'dashboard');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Levantamiento sincronizado correctamente')),
          );
        },
      ),
    ));
  }

  Widget _buildBody() {
    switch (_route) {
      case 'proyectos':
        return TecnicoProyectosListBody(
          filtroEstado: _filtroProyectos,
          onAbrirProyecto: _abrirProyecto,
        );
      case 'sincronizacion':
        return TecnicoFirmaBody(
          onFinalizar: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sincronizado correctamente')),
            );
          },
        );
      default:
        return TecnicoDashboardBody(
          onVerProyecto: _abrirProyectoPorId,
          onNuevaVisita: _mostrarNuevaVisitaDialog,
          onAsignados: () => _abrirProyectos(filtro: 'Asignado'),
          onCompletados: () => _abrirProyectos(filtro: 'Completado'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TecnicoDrawer(currentRoute: _route, onNavigate: _irA),
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
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _routeToIndex[_route] ?? 0,
        onDestinationSelected: (i) {
          _irA(switch (i) {
            1 => 'proyectos',
            2 => 'sincronizacion',
            _ => 'dashboard',
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.work_outline), label: 'Proyectos'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Sincronizar'),
        ],
      ),
    );
  }
}
