import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/visor_foto.dart';

class _DocumentoRequerido {
  final String nombre;
  final IconData icon;
  final String? asset;
  final bool obligatorio;
  const _DocumentoRequerido(this.nombre, this.icon, {this.asset, this.obligatorio = true});
}

/// "Captura de Documentos" (Documento de Requerimientos, sección 13):
/// documentación existente del sitio (recibo eléctrico, diagrama unifilar,
/// identificación, comprobante de domicilio) que se archiva junto con las
/// fotografías en "02 Documentación Existente". Paso del flujo del Técnico
/// entre Información General y Captura de Fotos.
class TecnicoDocumentosScreen extends StatefulWidget {
  final VoidCallback onSiguiente;
  const TecnicoDocumentosScreen({super.key, required this.onSiguiente});

  @override
  State<TecnicoDocumentosScreen> createState() => _TecnicoDocumentosScreenState();
}

class _TecnicoDocumentosScreenState extends State<TecnicoDocumentosScreen> {
  static const _documentos = [
    _DocumentoRequerido('Recibo Eléctrico (Compañía de Luz)', Icons.receipt_long_outlined,
        asset: 'assets/images/documentos/recibo_electrico.jpg'),
    _DocumentoRequerido('Diagrama Unifilar Existente', Icons.schema_outlined,
        asset: 'assets/images/documentos/diagrama_unifilar.jpg'),
    _DocumentoRequerido('Identificación Oficial del Cliente', Icons.badge_outlined),
    _DocumentoRequerido('Comprobante de Domicilio', Icons.home_outlined, obligatorio: false),
  ];

  late final Map<String, bool> _capturados = {
    for (final d in _documentos) d.nombre: d.asset != null,
  };

  bool get _puedeContinuar =>
      _documentos.where((d) => d.obligatorio).every((d) => _capturados[d.nombre] == true);

  void _toggle(_DocumentoRequerido d) {
    if (d.asset != null) return;
    setState(() => _capturados[d.nombre] = !(_capturados[d.nombre] ?? false));
  }

  @override
  Widget build(BuildContext context) {
    final total = _documentos.length;
    final listos = _capturados.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Captura de Documentos',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adjunte la documentación existente del sitio. Se archivará automáticamente en '
              '"02 Documentación Existente" junto con las fotografías del levantamiento.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progreso', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text('$listos/$total', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : listos / total,
                minHeight: 8,
                backgroundColor: AppColors.background,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            for (final d in _documentos) ...[
              _DocumentoTile(
                documento: d,
                capturado: _capturados[d.nombre] ?? false,
                onTap: () => _toggle(d),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _puedeContinuar ? widget.onSiguiente : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.border,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Continuar a Captura de Fotos', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

class _DocumentoTile extends StatelessWidget {
  final _DocumentoRequerido documento;
  final bool capturado;
  final VoidCallback onTap;
  const _DocumentoTile({required this.documento, required this.capturado, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: capturado ? AppColors.statusApprovedText : AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: documento.asset != null
                  ? () => mostrarFotoAmpliada(context, documento.asset!, etiqueta: documento.nombre)
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: documento.asset != null
                      ? Image.asset(
                          documento.asset!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _iconBox(),
                        )
                      : _iconBox(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(documento.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(documento.obligatorio ? 'Obligatorio' : 'Opcional',
                      style: TextStyle(
                          fontSize: 12,
                          color: documento.obligatorio ? AppColors.severityHighText : AppColors.textMuted)),
                ],
              ),
            ),
            Icon(
              capturado ? Icons.check_circle : Icons.add_circle_outline,
              color: capturado ? AppColors.statusApprovedText : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox() {
    return Container(
      color: AppColors.background,
      child: Icon(documento.icon, color: AppColors.textMuted),
    );
  }
}
