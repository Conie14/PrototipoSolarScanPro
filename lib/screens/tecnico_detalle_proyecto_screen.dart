import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tecnico_proyectos_screen.dart';
import 'estructura_carpetas_screen.dart';

/// "Técnico - Detalle y Descarga de Proyecto" (Figma 1:6161).
class TecnicoDetalleProyectoBody extends StatelessWidget {
  final VoidCallback onIniciarLevantamiento;
  final String etiqueta;
  final String nombreProyecto;
  final String idProyecto;
  final String cliente;
  final String contacto;
  final String direccion;

  const TecnicoDetalleProyectoBody({
    super.key,
    required this.onIniciarLevantamiento,
    this.etiqueta = 'PROYECTO RESIDENCIAL',
    this.nombreProyecto = 'Instalación Familia Rojas',
    this.idProyecto = 'PRJ-2023-8472',
    this.cliente = 'Carlos Rojas Villalobos',
    this.contacto = '+506 8832-1940',
    this.direccion = '150m Norte de la Iglesia Católica, Santa Ana, San José',
  });

  factory TecnicoDetalleProyectoBody.fromProyecto(
    TecnicoProyecto p, {
    required VoidCallback onIniciarLevantamiento,
  }) {
    return TecnicoDetalleProyectoBody(
      onIniciarLevantamiento: onIniciarLevantamiento,
      nombreProyecto: p.nombre,
      idProyecto: p.id,
      cliente: p.cliente,
      contacto: p.contacto,
      direccion: p.direccion,
    );
  }

  static const _modulos = [
    ('Datos generales del sitio', true),
    ('Mediciones eléctricas', true),
    ('Fotografías requeridas', false),
    ('Registro de hallazgos', false),
    ('Firma y cierre', false),
  ];

  @override
  Widget build(BuildContext context) {
    final completados = _modulos.where((m) => m.$2).length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(etiqueta,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(nombreProyecto,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.48,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(idProyecto,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Descargando proyecto para uso sin conexión...')));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Descargar para Offline'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => EstructuraCarpetasScreen(nombreProyecto: nombreProyecto),
              )),
              style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
              icon: const Icon(Icons.folder_outlined, size: 18),
              label: const Text('Ver Estructura de Archivos'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.checklist_outlined, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Módulos de Levantamiento',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: completados / _modulos.length,
                    minHeight: 8,
                    backgroundColor: AppColors.background,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                for (final m in _modulos)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          m.$2 ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 18,
                          color: m.$2 ? AppColors.statusApprovedText : AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Text(m.$1,
                            style: TextStyle(
                                color: m.$2 ? AppColors.textPrimary : AppColors.textSecondary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text('Datos Generales',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.statusPendingBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('PENDIENTE',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.statusPendingText)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(label: 'Cliente', value: cliente),
                _InfoRow(label: 'Contacto', value: contacto),
                _InfoRow(label: 'Dirección', value: direccion),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onIniciarLevantamiento,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Iniciar Levantamiento',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Envoltorio con Scaffold propio para abrir el detalle de un proyecto
/// específico desde la lista "Mis Proyectos" (empujado sobre el shell).
class TecnicoDetalleProyectoScreen extends StatelessWidget {
  final TecnicoProyecto proyecto;
  final VoidCallback onIniciarLevantamiento;
  const TecnicoDetalleProyectoScreen({
    super.key,
    required this.proyecto,
    required this.onIniciarLevantamiento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(proyecto.nombre,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: TecnicoDetalleProyectoBody.fromProyecto(
        proyecto,
        onIniciarLevantamiento: onIniciarLevantamiento,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
