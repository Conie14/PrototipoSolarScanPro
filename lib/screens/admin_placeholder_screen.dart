import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const Map<String, String> _routeTitles = {
  'plantillas': 'Gestion de Plantillas',
  'estadisticas': 'Estadisticas',
  'parametros': 'Parámetros Generales',
  'descargas': 'Descargas',
  'historial': 'Historial',
};

/// Pantalla temporal para rutas que todavía no se han traído
/// desde Figma en detalle. Evita que la navegación se rompa mientras
/// se completan el resto de las pantallas del diseño.
class AdminPlaceholderBody extends StatelessWidget {
  final String route;
  final String? titleOverride;
  const AdminPlaceholderBody({super.key, required this.route, this.titleOverride});

  @override
  Widget build(BuildContext context) {
    final title = titleOverride ?? _routeTitles[route] ?? route;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_outlined,
                size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta pantalla aún no se ha traído desde Figma en detalle.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
