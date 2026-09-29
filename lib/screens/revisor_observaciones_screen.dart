import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Revisor - Registro de Observaciones" (Figma 1:7652).
class RevisorObservacionesScreen extends StatefulWidget {
  final String proyectoId;
  final VoidCallback onGuardado;
  final VoidCallback onSolicitarCorrecciones;
  const RevisorObservacionesScreen({
    super.key,
    required this.proyectoId,
    required this.onGuardado,
    required this.onSolicitarCorrecciones,
  });

  @override
  State<RevisorObservacionesScreen> createState() => _RevisorObservacionesScreenState();
}

class _RevisorObservacionesScreenState extends State<RevisorObservacionesScreen> {
  final _comentariosCtrl = TextEditingController();
  final Map<String, bool> _problemas = {
    'Mediciones fuera de rango': false,
    'Evidencia fotográfica insuficiente': false,
    'Documentación incompleta': false,
    'Cableado o instalación no conforme': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('SolarScan Pro',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.proyectoId,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Text('Solar Farm Expansion - Technical Review Phase 2',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.statusPendingBg, borderRadius: BorderRadius.circular(999)),
                    child: const Text('En revisión',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.statusPendingText)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Problemas comunes identificados',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Seleccione todas las opciones que correspondan según la evaluación técnica.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            for (final key in _problemas.keys)
              CheckboxListTile(
                value: _problemas[key],
                onChanged: (v) => setState(() => _problemas[key] = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: Text(key, style: const TextStyle(color: AppColors.textPrimary)),
              ),
            const SizedBox(height: 16),
            const Text('Comentarios del Revisor',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _comentariosCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Descripción detallada de las observaciones, ubicaciones específicas de los problemas y acciones correctivas requeridas...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onSolicitarCorrecciones,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.undo, size: 18),
                    label: const Text('Solicitar Correcciones'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onGuardado,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: const Text('Guardar Observaciones'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
