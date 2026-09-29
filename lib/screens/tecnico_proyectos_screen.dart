import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TecnicoProyecto {
  final String id;
  final String nombre;
  final String cliente;
  final String contacto;
  final String direccion;
  final String estado; // Asignado, En Progreso, Completado
  const TecnicoProyecto({
    required this.id,
    required this.nombre,
    required this.cliente,
    required this.contacto,
    required this.direccion,
    required this.estado,
  });
}

const kTecnicoProyectos = [
  TecnicoProyecto(
    id: 'PRJ-2023-8472',
    nombre: 'Instalación Familia Rojas',
    cliente: 'Carlos Rojas Villalobos',
    contacto: '+506 8832-1940',
    direccion: '150m Norte de la Iglesia Católica, Santa Ana, San José',
    estado: 'Completado',
  ),
  TecnicoProyecto(
    id: 'PRJ-2023-492A',
    nombre: 'Planta Solar Norte',
    cliente: 'EnerTech Corp',
    contacto: '+506 2233-4455',
    direccion: 'Zona Industrial, Nave 4, Alajuela',
    estado: 'Asignado',
  ),
  TecnicoProyecto(
    id: 'PRJ-2023-A91',
    nombre: 'Farmacia Sector 4',
    cliente: 'Farmacias del Valle S.A.',
    contacto: '+506 8811-2233',
    direccion: 'Av. Central, Sector 4, Heredia',
    estado: 'Asignado',
  ),
  TecnicoProyecto(
    id: 'PRJ-2023-B22',
    nombre: 'Valley Ridge Installation',
    cliente: 'Valley Ridge Corp',
    contacto: '+506 8899-1122',
    direccion: 'Ruta 27, Km 12, Puntarenas',
    estado: 'Asignado',
  ),
  TecnicoProyecto(
    id: 'PRJ-2023-8842',
    nombre: 'TRUPER Monterrey',
    cliente: 'Truper Herramientas S.A.',
    contacto: '+52 81 4455-2200',
    direccion: 'Parque Industrial, Monterrey, Nuevo León',
    estado: 'Asignado',
  ),
  TecnicoProyecto(
    id: 'PRJ-2023-089A',
    nombre: 'Solar Farm Expansion',
    cliente: 'Grupo Energético del Pacífico',
    contacto: '+506 2299-5050',
    direccion: 'Guanacaste, Costa Rica',
    estado: 'Completado',
  ),
];

/// Lista de "Mis Proyectos" del Técnico. Se puede filtrar por estado
/// (usado por las tarjetas "Asignados"/"Completados" del dashboard).
class TecnicoProyectosListBody extends StatelessWidget {
  final String? filtroEstado;
  final void Function(TecnicoProyecto proyecto) onAbrirProyecto;
  const TecnicoProyectosListBody({super.key, this.filtroEstado, required this.onAbrirProyecto});

  @override
  Widget build(BuildContext context) {
    final proyectos = filtroEstado == null
        ? kTecnicoProyectos
        : kTecnicoProyectos.where((p) => p.estado == filtroEstado).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(filtroEstado == null ? 'Mis Proyectos' : 'Proyectos · $filtroEstado',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.48, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Proyectos asignados a tu cuenta de técnico.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          if (proyectos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No hay proyectos en este estado.', style: TextStyle(color: AppColors.textMuted)),
              ),
            ),
          for (final p in proyectos) ...[
            InkWell(
              onTap: () => onAbrirProyecto(p),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      p.estado == 'Completado' ? Icons.check_circle : Icons.hourglass_top,
                      color: p.estado == 'Completado' ? AppColors.statusApprovedText : AppColors.statusPendingText,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.nombre,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('${p.id} · ${p.estado}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
