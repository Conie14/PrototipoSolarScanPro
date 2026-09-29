import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/proyectos_ejemplo.dart';
import '../widgets/visor_foto.dart';

/// "Revisor - Validación de Levantamiento" (Figma 1:7856).
class RevisorValidacionScreen extends StatefulWidget {
  final String proyectoId;
  final VoidCallback onSolicitarCorrecciones;
  final VoidCallback onAprobar;
  const RevisorValidacionScreen({
    super.key,
    required this.proyectoId,
    required this.onSolicitarCorrecciones,
    required this.onAprobar,
  });

  @override
  State<RevisorValidacionScreen> createState() => _RevisorValidacionScreenState();
}

class _RevisorValidacionScreenState extends State<RevisorValidacionScreen> {
  final _decisionCtrl = TextEditingController();

  static const _mediciones = [
    ('String 1', 'Voc 480V', 'Isc 9.2A', 'OK'),
    ('String 2', 'Voc 478V', 'Isc 9.1A', 'OK'),
    ('String 3', 'Voc 465V', 'Isc 8.4A', 'Revisar'),
  ];

  @override
  Widget build(BuildContext context) {
    final ejemplo = ProyectosEjemplo.porId(widget.proyectoId);
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
                        const Text('FLUJO: VALIDACIÓN TÉCNICA',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(ejemplo?.nombre ?? 'TRUPER Monterrey',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text('ID: ${widget.proyectoId} · Levantamiento completado el 12 Oct 2023',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.statusPendingBg, borderRadius: BorderRadius.circular(999)),
                    child: const Text('En Revisión',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.statusPendingText)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Información y Equipos',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _KeyValue(label: 'Cliente', value: ejemplo?.cliente ?? 'Corporación Solar del Norte'),
                  _KeyValue(label: 'Instalador', value: ejemplo?.tecnico ?? 'Alan Gómez'),
                  const _KeyValue(label: 'Fecha de visita', value: '12 Oct 2023'),
                  const _KeyValue(label: 'Módulos PV', value: '20 paneles · 450W'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Mediciones Eléctricas',
              child: Table(
                border: TableBorder.all(color: AppColors.border),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: AppColors.background),
                    children: [
                      _Cell('String', bold: true),
                      _Cell('Voc', bold: true),
                      _Cell('Isc', bold: true),
                      _Cell('Estado', bold: true),
                    ],
                  ),
                  for (final m in _mediciones)
                    TableRow(children: [
                      _Cell(m.$1),
                      _Cell(m.$2),
                      _Cell(m.$3),
                      _Cell(m.$4,
                          color: m.$4 == 'OK' ? AppColors.statusApprovedText : AppColors.statusCorrectionText),
                    ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Evidencia Fotográfica',
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.4,
                children: ejemplo != null
                    ? [
                        for (final f in ejemplo.fotos)
                          GestureDetector(
                            onTap: () => mostrarFotoAmpliada(context, f.asset!, etiqueta: f.etiqueta),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                f.asset!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.background,
                                  child: Icon(f.icon, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                          ),
                      ]
                    : List.generate(
                        4,
                        (i) => Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image_outlined, color: AppColors.textMuted),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Decisión de Revisión',
              child: TextField(
                controller: _decisionCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escriba su decisión y comentarios...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onSolicitarCorrecciones,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Solicitar Correcciones'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onAprobar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusApprovedText,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Aprobar Levantamiento'),
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

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  const _KeyValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? color;
  const _Cell(this.text, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
