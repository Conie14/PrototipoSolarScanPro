import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Nodo {
  final String nombre;
  final IconData icon;
  final List<_Nodo> hijos;
  const _Nodo(this.nombre, {this.icon = Icons.folder_outlined, this.hijos = const []});
}

/// Estructura automática de carpetas generada al exportar el proyecto
/// (Documento de Requerimientos, secciones 11 y 23). El técnico no crea
/// estas carpetas manualmente: el sistema las arma según la plantilla.
class EstructuraCarpetasScreen extends StatelessWidget {
  final String nombreProyecto;
  const EstructuraCarpetasScreen({super.key, required this.nombreProyecto});

  static const _estructura = [
    _Nodo('01 Información del Sitio'),
    _Nodo('02 Documentación Existente'),
    _Nodo('03 Fotografías', hijos: [
      _Nodo('3.1 Dron y Cubierta'),
      _Nodo('3.2 Sistema FV Existente'),
      _Nodo('3.3 Acometida, Medidor y Transformador'),
      _Nodo('3.4 Tableros y Canalizaciones', hijos: [
        _Nodo('Tablero Principal', icon: Icons.folder_open),
        _Nodo('Tablero 01', icon: Icons.folder_open),
        _Nodo('Tablero 02', icon: Icons.folder_open),
        _Nodo('Tablero 03', icon: Icons.folder_open),
      ]),
      _Nodo('3.5 Generales'),
    ]),
    _Nodo('04 Videos'),
    _Nodo('05 Reporte de Levantamiento'),
    _Nodo('06 CAD y Modelos 3D'),
    _Nodo('Evidencias Adicionales'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Estructura del Proyecto',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.folder_zip_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreProyecto,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'El sistema organiza automáticamente documentos, fotografías y videos '
                    'según la plantilla del proyecto. No es necesario crear carpetas manualmente.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final n in _estructura) _NodoTile(nodo: n, nivel: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Generando ${_nombreArchivo(nombreProyecto)}...'),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.archive_outlined, size: 18),
                label: const Text('Generar ZIP del Proyecto', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _nombreArchivo(String nombreProyecto) {
    final slug = nombreProyecto
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final fecha = DateTime.now().toIso8601String().split('T').first;
    return '${slug}_LEVANTAMIENTO_$fecha.zip';
  }
}

class _NodoTile extends StatelessWidget {
  final _Nodo nodo;
  final int nivel;
  const _NodoTile({required this.nodo, required this.nivel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16 + nivel * 20, 6, 16, 6),
          child: Row(
            children: [
              Icon(nodo.icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(nodo.nombre,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: nivel == 0 ? FontWeight.w600 : FontWeight.normal)),
              ),
            ],
          ),
        ),
        for (final hijo in nodo.hijos) _NodoTile(nodo: hijo, nivel: nivel + 1),
      ],
    );
  }
}
