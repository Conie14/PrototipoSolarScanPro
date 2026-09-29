import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Revisor - Decisión Final de Validación" (Figma 1:7727).
class RevisorDecisionScreen extends StatefulWidget {
  final String proyectoId;
  final void Function(bool aprobado) onDecision;
  const RevisorDecisionScreen({super.key, required this.proyectoId, required this.onDecision});

  @override
  State<RevisorDecisionScreen> createState() => _RevisorDecisionScreenState();
}

class _RevisorDecisionScreenState extends State<RevisorDecisionScreen> {
  final _comentariosCtrl = TextEditingController();
  String? _error;

  void _rechazar() {
    if (_comentariosCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Los comentarios son obligatorios para rechazar el proyecto.');
      return;
    }
    widget.onDecision(false);
  }

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
                color: AppColors.statusPendingBg.withValues(alpha: 0.25),
                border: Border.all(color: AppColors.statusPendingBg),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.statusPendingText),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Proyecto ${widget.proyectoId}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Text('Listo para decisión final de validación.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _SummaryCard(title: 'Datos del Sitio', value: 'Completo')),
                const SizedBox(width: 12),
                Expanded(child: _SummaryCard(title: 'Mediciones', value: '18/20 OK')),
                const SizedBox(width: 12),
                Expanded(child: _SummaryCard(title: 'Evidencia', value: '24 fotos')),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de Hallazgos',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 8),
                  _HallazgoResumen(codigo: 'INV-001', titulo: 'Panel con fisuras severas', severidad: 'Alto'),
                  _HallazgoResumen(codigo: 'CAB-042', titulo: 'Cableado expuesto', severidad: 'Medio'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Comentarios de Revisión (Obligatorio para rechazo)',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _comentariosCtrl,
              maxLines: 4,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(
                hintText: 'Escriba comentarios finales...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 6),
              Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _rechazar,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Rechazar Proyecto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onDecision(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusApprovedText,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Aprobar Proyecto'),
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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  const _SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _HallazgoResumen extends StatelessWidget {
  final String codigo;
  final String titulo;
  final String severidad;
  const _HallazgoResumen({required this.codigo, required this.titulo, required this.severidad});

  Color get _bg => severidad == 'Alto' ? AppColors.severityHighBg : AppColors.severityMediumBg;
  Color get _text => severidad == 'Alto' ? AppColors.severityHighText : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(999)),
            child: Text(codigo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _text)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(titulo, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
