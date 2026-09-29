import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum _TipoPendiente { obligatorio, opcional, justificado }

class _Pendiente {
  final String texto;
  final _TipoPendiente tipo;
  bool justificado;
  _Pendiente(this.texto, this.tipo, {this.justificado = false});
}

/// "Validación del Levantamiento" (Documento de Requerimientos, sección 20):
/// distingue pendientes obligatorios (bloquean el cierre), opcionales (no
/// bloquean) y justificados (el supervisor puede permitir el cierre con
/// una justificación). Paso previo a la Firma dentro del flujo del Técnico.
class TecnicoValidacionScreen extends StatefulWidget {
  final VoidCallback onFinalizarVisita;
  const TecnicoValidacionScreen({super.key, required this.onFinalizarVisita});

  @override
  State<TecnicoValidacionScreen> createState() => _TecnicoValidacionScreenState();
}

class _TecnicoValidacionScreenState extends State<TecnicoValidacionScreen> {
  final List<_Pendiente> _pendientes = [
    _Pendiente('Falta placa del transformador', _TipoPendiente.obligatorio),
    _Pendiente('Falta medición Fase-Tierra', _TipoPendiente.obligatorio),
    _Pendiente('Falta fotografía de tablero principal', _TipoPendiente.justificado),
    _Pendiente('Falta comentario en fotografía de cubierta', _TipoPendiente.opcional),
  ];

  final _justificacionCtrl = TextEditingController();

  bool get _hayObligatoriosSinResolver =>
      _pendientes.any((p) => p.tipo == _TipoPendiente.obligatorio);

  bool get _hayJustificadosSinJustificar =>
      _pendientes.any((p) => p.tipo == _TipoPendiente.justificado && !p.justificado);

  double get _avance {
    const totalPasos = 20; // total de ítems del checklist de la plantilla (mock)
    final resueltos = totalPasos - _pendientes.length;
    return resueltos / totalPasos;
  }

  bool get _puedeFinalizar => !_hayObligatoriosSinResolver && !_hayJustificadosSinJustificar;

  @override
  Widget build(BuildContext context) {
    final porcentaje = (_avance * 100).round();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Validación del Levantamiento',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
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
                      const Text('Levantamiento',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      Text('$porcentaje %',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: _avance,
                      minHeight: 10,
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation(
                          _puedeFinalizar ? AppColors.statusApprovedText : AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_pendientes.where((p) => p.tipo == _TipoPendiente.obligatorio).isNotEmpty) ...[
              const _SectionTitle('Pendientes Obligatorios', subtitle: 'Impiden cerrar el levantamiento.'),
              for (final p in _pendientes.where((p) => p.tipo == _TipoPendiente.obligatorio).toList())
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.severityHighBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.block, size: 16, color: AppColors.severityHighText),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(p.texto, style: const TextStyle(color: AppColors.severityHighText))),
                      TextButton(
                        onPressed: () => setState(() => _pendientes.remove(p)),
                        child: const Text('Marcar resuelto'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],
            if (_pendientes.where((p) => p.tipo == _TipoPendiente.justificado).isNotEmpty) ...[
              const _SectionTitle('Pendientes Justificados',
                  subtitle: 'El supervisor puede permitir el cierre indicando una justificación.'),
              for (final p in _pendientes.where((p) => p.tipo == _TipoPendiente.justificado))
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.statusPendingBg),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.statusPendingText),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(p.texto,
                                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      if (!p.justificado) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: _justificacionCtrl,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Escriba la justificación del supervisor...',
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: _justificacionCtrl.text.trim().isEmpty
                                ? null
                                : () => setState(() => p.justificado = true),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                            ),
                            child: const Text('Justificar y continuar'),
                          ),
                        ),
                      ] else
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: AppColors.statusApprovedText),
                              SizedBox(width: 6),
                              Text('Justificado', style: TextStyle(color: AppColors.statusApprovedText)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
            ],
            if (_pendientes.where((p) => p.tipo == _TipoPendiente.opcional).isNotEmpty) ...[
              const _SectionTitle('Pendientes Opcionales', subtitle: 'No impiden cerrar el levantamiento.'),
              for (final p in _pendientes.where((p) => p.tipo == _TipoPendiente.opcional))
                _PendienteTile(
                  texto: p.texto,
                  color: AppColors.textSecondary,
                  bg: AppColors.background,
                  icon: Icons.info_outline,
                ),
            ],
            const SizedBox(height: 24),
            if (!_puedeFinalizar)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.severityHighBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.severityHighText, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Resuelva los pendientes obligatorios o justifique los pendientes justificados para continuar.',
                        style: TextStyle(fontSize: 12, color: AppColors.severityHighText),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _puedeFinalizar ? widget.onFinalizarVisita : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.task_alt, size: 18),
                label: const Text('Finalizar Visita', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle(this.title, {required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _PendienteTile extends StatelessWidget {
  final String texto;
  final Color color;
  final Color bg;
  final IconData icon;
  const _PendienteTile({required this.texto, required this.color, required this.bg, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(texto, style: TextStyle(color: color))),
        ],
      ),
    );
  }
}
