import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _ProyectoStat {
  final String nombre, cliente, tecnico, estado, mes;
  final double tiempoDias;
  final int fotos, videos, documentos, mediciones, hallazgos;
  final double avance;
  const _ProyectoStat({
    required this.nombre,
    required this.cliente,
    required this.tecnico,
    required this.estado,
    required this.mes,
    required this.tiempoDias,
    required this.fotos,
    required this.videos,
    required this.documentos,
    required this.mediciones,
    required this.hallazgos,
    required this.avance,
  });
}

class _TecnicoStat {
  final String nombre;
  final int realizados, pendientes, evidencias, correcciones;
  final double tiempoPromHito;
  const _TecnicoStat({
    required this.nombre,
    required this.realizados,
    required this.pendientes,
    required this.tiempoPromHito,
    required this.evidencias,
    required this.correcciones,
  });
}

/// "Estadísticas" (Documento de Requerimientos, sección 28): tres vistas —
/// por Proyecto, por Técnico y por Empresa — con filtros por Fecha, Cliente,
/// Técnico, Proyecto y Estado. Ítem del drawer de Admin sin frame exacto en
/// Figma; construido con el mismo lenguaje visual del rol.
class AdminEstadisticasBody extends StatefulWidget {
  const AdminEstadisticasBody({super.key});

  @override
  State<AdminEstadisticasBody> createState() => _AdminEstadisticasBodyState();
}

class _AdminEstadisticasBodyState extends State<AdminEstadisticasBody>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  static const _proyectos = [
    _ProyectoStat(
        nombre: 'Planta Solar Alpha', cliente: 'EnerTech Corp', tecnico: 'J. Miller',
        estado: 'En progreso', mes: 'Jul', tiempoDias: 3.2, fotos: 48, videos: 6,
        documentos: 12, mediciones: 20, hallazgos: 4, avance: 0.78),
    _ProyectoStat(
        nombre: 'Tejados Sur M-22', cliente: 'Logisur S.A.', tecnico: 'S. Connor',
        estado: 'Pendiente Revisión', mes: 'Ago', tiempoDias: 2.1, fotos: 30, videos: 4,
        documentos: 9, mediciones: 15, hallazgos: 2, avance: 0.92),
    _ProyectoStat(
        nombre: 'Planta Solar Norte', cliente: 'EnerTech Corp', tecnico: 'A. Gómez',
        estado: 'Completado', mes: 'Jun', tiempoDias: 4.5, fotos: 60, videos: 8,
        documentos: 15, mediciones: 22, hallazgos: 6, avance: 1.0),
    _ProyectoStat(
        nombre: 'Farmacia Sector 4', cliente: 'Grupo Sáenz', tecnico: 'J. Miller',
        estado: 'En progreso', mes: 'Sep', tiempoDias: 1.8, fotos: 22, videos: 3,
        documentos: 7, mediciones: 10, hallazgos: 1, avance: 0.45),
  ];

  static const _tecnicos = [
    _TecnicoStat(nombre: 'J. Miller', realizados: 12, pendientes: 2, tiempoPromHito: 2.4, evidencias: 340, correcciones: 5),
    _TecnicoStat(nombre: 'S. Connor', realizados: 9, pendientes: 1, tiempoPromHito: 3.1, evidencias: 265, correcciones: 3),
    _TecnicoStat(nombre: 'A. Gómez', realizados: 15, pendientes: 0, tiempoPromHito: 1.9, evidencias: 410, correcciones: 2),
  ];

  static const _porMes = [
    ('Jun', 0.55), ('Jul', 0.7), ('Ago', 0.65), ('Sep', 0.9),
  ];

  String _filtroCliente = 'Todos';
  String _filtroTecnico = 'Todos';
  String _filtroProyecto = 'Todos';
  String _filtroEstado = 'Todos';
  String _filtroMes = 'Todos';

  List<String> get _clientes => ['Todos', ..._proyectos.map((p) => p.cliente).toSet()];
  List<String> get _tecnicoNombres => ['Todos', ..._proyectos.map((p) => p.tecnico).toSet()];
  List<String> get _proyectoNombres => ['Todos', ..._proyectos.map((p) => p.nombre).toSet()];
  static const _estados = ['Todos', 'En progreso', 'Pendiente Revisión', 'Completado'];
  List<String> get _meses => ['Todos', ..._proyectos.map((p) => p.mes).toSet()];

  List<_ProyectoStat> get _proyectosFiltrados => _proyectos.where((p) {
        if (_filtroCliente != 'Todos' && p.cliente != _filtroCliente) return false;
        if (_filtroTecnico != 'Todos' && p.tecnico != _filtroTecnico) return false;
        if (_filtroProyecto != 'Todos' && p.nombre != _filtroProyecto) return false;
        if (_filtroEstado != 'Todos' && p.estado != _filtroEstado) return false;
        if (_filtroMes != 'Todos' && p.mes != _filtroMes) return false;
        return true;
      }).toList();

  List<_TecnicoStat> get _tecnicosFiltrados => _tecnicos.where((t) {
        if (_filtroTecnico != 'Todos' && t.nombre != _filtroTecnico) return false;
        return true;
      }).toList();

  bool get _hayFiltrosActivos =>
      _filtroCliente != 'Todos' ||
      _filtroTecnico != 'Todos' ||
      _filtroProyecto != 'Todos' ||
      _filtroEstado != 'Todos' ||
      _filtroMes != 'Todos';

  void _limpiarFiltros() => setState(() {
        _filtroCliente = 'Todos';
        _filtroTecnico = 'Todos';
        _filtroProyecto = 'Todos';
        _filtroEstado = 'Todos';
        _filtroMes = 'Todos';
      });

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Estadísticas',
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.64, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Rendimiento operativo por proyecto, técnico y empresa.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _FiltrosBar(
          clientes: _clientes,
          tecnicos: _tecnicoNombres,
          proyectos: _proyectoNombres,
          estados: _estados,
          meses: _meses,
          filtroCliente: _filtroCliente,
          filtroTecnico: _filtroTecnico,
          filtroProyecto: _filtroProyecto,
          filtroEstado: _filtroEstado,
          filtroMes: _filtroMes,
          hayFiltrosActivos: _hayFiltrosActivos,
          onLimpiar: _limpiarFiltros,
          onClienteChanged: (v) => setState(() => _filtroCliente = v),
          onTecnicoChanged: (v) => setState(() => _filtroTecnico = v),
          onProyectoChanged: (v) => setState(() => _filtroProyecto = v),
          onEstadoChanged: (v) => setState(() => _filtroEstado = v),
          onMesChanged: (v) => setState(() => _filtroMes = v),
        ),
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Por Proyecto'),
            Tab(text: 'Por Técnico'),
            Tab(text: 'Por Empresa'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _TabProyecto(proyectos: _proyectosFiltrados),
              _TabTecnico(tecnicos: _tecnicosFiltrados),
              _TabEmpresa(proyectos: _proyectos, porMes: _porMes),
            ],
          ),
        ),
      ],
    );
  }
}

class _FiltrosBar extends StatelessWidget {
  final List<String> clientes, tecnicos, proyectos, estados, meses;
  final String filtroCliente, filtroTecnico, filtroProyecto, filtroEstado, filtroMes;
  final bool hayFiltrosActivos;
  final VoidCallback onLimpiar;
  final ValueChanged<String> onClienteChanged, onTecnicoChanged, onProyectoChanged, onEstadoChanged, onMesChanged;

  const _FiltrosBar({
    required this.clientes,
    required this.tecnicos,
    required this.proyectos,
    required this.estados,
    required this.meses,
    required this.filtroCliente,
    required this.filtroTecnico,
    required this.filtroProyecto,
    required this.filtroEstado,
    required this.filtroMes,
    required this.hayFiltrosActivos,
    required this.onLimpiar,
    required this.onClienteChanged,
    required this.onTecnicoChanged,
    required this.onProyectoChanged,
    required this.onEstadoChanged,
    required this.onMesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FiltroDropdown(icon: Icons.calendar_today_outlined, label: 'Fecha', value: filtroMes, opciones: meses, onChanged: onMesChanged),
            const SizedBox(width: 8),
            _FiltroDropdown(icon: Icons.apartment_outlined, label: 'Cliente', value: filtroCliente, opciones: clientes, onChanged: onClienteChanged),
            const SizedBox(width: 8),
            _FiltroDropdown(icon: Icons.badge_outlined, label: 'Técnico', value: filtroTecnico, opciones: tecnicos, onChanged: onTecnicoChanged),
            const SizedBox(width: 8),
            _FiltroDropdown(icon: Icons.work_outline, label: 'Proyecto', value: filtroProyecto, opciones: proyectos, onChanged: onProyectoChanged),
            const SizedBox(width: 8),
            _FiltroDropdown(icon: Icons.flag_outlined, label: 'Estado', value: filtroEstado, opciones: estados, onChanged: onEstadoChanged),
            if (hayFiltrosActivos) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onLimpiar,
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Limpiar'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FiltroDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> opciones;
  final ValueChanged<String> onChanged;
  const _FiltroDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.opciones,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activo = value != 'Todos';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: activo ? AppColors.primaryLight.withValues(alpha: 0.12) : AppColors.surface,
        border: Border.all(color: activo ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.expand_more, size: 16),
          borderRadius: BorderRadius.circular(8),
          style: TextStyle(fontSize: 12, color: activo ? AppColors.primary : AppColors.textSecondary),
          items: opciones
              .map((o) => DropdownMenuItem(
                    value: o,
                    child: Row(
                      children: [
                        Icon(icon, size: 14, color: activo ? AppColors.primary : AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(o == 'Todos' ? '$label: Todos' : o),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}

class _TabProyecto extends StatelessWidget {
  final List<_ProyectoStat> proyectos;
  const _TabProyecto({required this.proyectos});

  @override
  Widget build(BuildContext context) {
    if (proyectos.isEmpty) return const _SinResultados();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: proyectos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final p = proyectos[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(p.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                  ),
                  Text('${(p.avance * 100).round()}%',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
                ],
              ),
              Text('${p.cliente} · Técnico: ${p.tecnico}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _MetricaChip(Icons.timer_outlined, '${p.tiempoDias} días', 'Levantamiento'),
                  _MetricaChip(Icons.photo_camera_outlined, '${p.fotos}', 'Fotografías'),
                  _MetricaChip(Icons.videocam_outlined, '${p.videos}', 'Videos'),
                  _MetricaChip(Icons.description_outlined, '${p.documentos}', 'Documentos'),
                  _MetricaChip(Icons.speed_outlined, '${p.mediciones}', 'Mediciones'),
                  _MetricaChip(Icons.report_gmailerrorred_outlined, '${p.hallazgos}', 'Hallazgos'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabTecnico extends StatelessWidget {
  final List<_TecnicoStat> tecnicos;
  const _TabTecnico({required this.tecnicos});

  @override
  Widget build(BuildContext context) {
    if (tecnicos.isEmpty) return const _SinResultados();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: tecnicos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final t = tecnicos[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person, size: 16, color: Colors.white)),
                  const SizedBox(width: 10),
                  Text(t.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _MetricaChip(Icons.check_circle_outline, '${t.realizados}', 'Realizados'),
                  _MetricaChip(Icons.pending_actions_outlined, '${t.pendientes}', 'Pendientes'),
                  _MetricaChip(Icons.timer_outlined, '${t.tiempoPromHito} días', 'Prom. por hito'),
                  _MetricaChip(Icons.collections_outlined, '${t.evidencias}', 'Evidencias'),
                  _MetricaChip(Icons.rule_outlined, '${t.correcciones}', 'Correcciones'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabEmpresa extends StatelessWidget {
  final List<_ProyectoStat> proyectos;
  final List<(String, double)> porMes;
  const _TabEmpresa({required this.proyectos, required this.porMes});

  @override
  Widget build(BuildContext context) {
    final activos = proyectos.where((p) => p.estado == 'En progreso' || p.estado == 'Pendiente Revisión').length;
    final cerrados = proyectos.where((p) => p.estado == 'Completado').length;
    final atrasados = proyectos.where((p) => p.tiempoDias > 4.0 && p.estado != 'Completado').length;
    final hallazgosCriticos = proyectos.fold<int>(0, (acc, p) => acc + (p.hallazgos >= 4 ? 1 : 0));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _MiniKpi(value: '$activos', label: 'Proyectos activos', accent: AppColors.kpiBlue),
              _MiniKpi(value: '$cerrados', label: 'Proyectos cerrados', accent: AppColors.statusApprovedText),
              _MiniKpi(value: '$atrasados', label: 'Proyectos atrasados', accent: AppColors.error),
              _MiniKpi(value: '$hallazgosCriticos', label: 'Hallazgos críticos', accent: AppColors.kpiOrange),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Levantamientos por período',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: porMes.map((m) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 110 * m.$2,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(m.$1, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_alt_off_outlined, size: 32, color: AppColors.textMuted),
            SizedBox(height: 8),
            Text('Ningún registro coincide con los filtros seleccionados.',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _MetricaChip extends StatelessWidget {
  final IconData icon;
  final String valor;
  final String label;
  const _MetricaChip(this.icon, this.valor, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('$valor ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final String value;
  final String label;
  final Color accent;
  const _MiniKpi({required this.value, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 28, height: 4, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
