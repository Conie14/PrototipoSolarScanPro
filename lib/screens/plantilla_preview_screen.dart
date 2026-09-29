import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/campo_formulario.dart';
import '../widgets/visor_foto.dart';

String _formatearFecha(DateTime d) {
  const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  final hora = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final ampm = d.hour >= 12 ? 'p. m.' : 'a. m.';
  final minuto = d.minute.toString().padLeft(2, '0');
  return '${d.day} de ${meses[d.month - 1]}, $hora:$minuto $ampm';
}

/// Vista previa interactiva de una plantilla: reproduce exactamente cómo el
/// sistema solicita y captura la información en campo (Documento de
/// Requerimientos, sección 9 — formularios dinámicos con campos
/// condicionales). No es solo una lista de nombres de campos: se puede
/// completar el ejemplo y ver aparecer/desaparecer los campos dependientes.
class PlantillaPreviewScreen extends StatefulWidget {
  final String nombre;
  final String rol;
  final List<CampoFormulario>? camposPersonalizados;

  const PlantillaPreviewScreen({
    super.key,
    required this.nombre,
    required this.rol,
    this.camposPersonalizados,
  });

  @override
  State<PlantillaPreviewScreen> createState() => _PlantillaPreviewScreenState();
}

class _PlantillaPreviewScreenState extends State<PlantillaPreviewScreen> {
  final Map<String, dynamic> _respuestas = {};
  bool _enviado = false;

  List<CampoFormulario> get _campos {
    if (widget.camposPersonalizados != null) return widget.camposPersonalizados!;
    switch (widget.nombre) {
      case 'Estudio de Viabilidad FV':
        return const [
          CampoFormulario(id: 'viabilidad', etiqueta: '¿Es viable el proyecto?', tipo: TipoCampoFormulario.seleccion,
              opciones: ['Viable', 'No Viable', 'Requiere Visita Previa']),
          CampoFormulario(id: 'agendar_visita', etiqueta: 'Programar visita previa de evaluación',
              tipo: TipoCampoFormulario.agendarVisita, mostrarSi: _requiereVisitaPrevia),
          CampoFormulario(id: 'foto_fachada_viab', etiqueta: 'Fachada', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/planta_solar_alpha/fachada_comercial.jpg'),
          CampoFormulario(id: 'foto_frente_dron', etiqueta: 'Frente (Dron)', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/planta_solar_alpha/techo_evaluacion.jpg'),
          CampoFormulario(id: 'foto_tableros_viab', etiqueta: 'Tableros', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/planta_solar_alpha/tablero_principal.jpg'),
          CampoFormulario(id: 'existen_documentos', etiqueta: '¿Existen documentos previos del sitio?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'doc_previo', etiqueta: 'Cargar documento existente (recibo eléctrico)',
              tipo: TipoCampoFormulario.foto, asset: 'assets/images/documentos/recibo_electrico.jpg',
              mostrarSi: _existenDocumentos),
          CampoFormulario(
              id: 'doc_pendiente_nota',
              etiqueta: 'No hay documentos previos disponibles: se cargarán más adelante, '
                  'durante el levantamiento en campo.',
              tipo: TipoCampoFormulario.nota,
              obligatorio: false,
              mostrarSi: _noExistenDocumentos),
        ];
      case 'Inspección FV Residencial':
        return const [
          CampoFormulario(id: 'nombre_cliente', etiqueta: 'Nombre del cliente', tipo: TipoCampoFormulario.texto),
          CampoFormulario(id: 'direccion_sitio', etiqueta: 'Dirección del sitio', tipo: TipoCampoFormulario.texto),
          CampoFormulario(id: 'tipo_techo', etiqueta: 'Tipo de techo', tipo: TipoCampoFormulario.seleccion,
              opciones: ['Lámina', 'Teja', 'Concreto', 'Otro']),
          CampoFormulario(id: 'orientacion_techo', etiqueta: 'Orientación del techo', tipo: TipoCampoFormulario.seleccion,
              opciones: ['Norte', 'Sur', 'Este', 'Oeste']),
          CampoFormulario(id: 'inclinacion', etiqueta: 'Inclinación aproximada (°)', tipo: TipoCampoFormulario.numero),
          CampoFormulario(id: 'existe_fv', etiqueta: '¿Existe sistema FV instalado?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'num_modulos', etiqueta: 'Número de módulos', tipo: TipoCampoFormulario.numero,
              mostrarSi: _siExisteFv),
          CampoFormulario(id: 'fabricante', etiqueta: 'Fabricante de los módulos', tipo: TipoCampoFormulario.texto,
              mostrarSi: _siExisteFv),
          CampoFormulario(id: 'modelo_inversor', etiqueta: 'Modelo del inversor', tipo: TipoCampoFormulario.texto,
              mostrarSi: _siExisteFv),
          CampoFormulario(id: 'potencia_instalada', etiqueta: 'Potencia instalada estimada (kW)',
              tipo: TipoCampoFormulario.numero, mostrarSi: _siExisteFv),
          CampoFormulario(id: 'hay_sombras', etiqueta: '¿Hay sombras sobre el techo?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'fuente_sombra', etiqueta: 'Fuente de la sombra', tipo: TipoCampoFormulario.texto,
              mostrarSi: _haySombras),
          CampoFormulario(id: 'tipo_acometida', etiqueta: 'Tipo de acometida eléctrica', tipo: TipoCampoFormulario.seleccion,
              opciones: ['Monofásica', 'Trifásica']),
          CampoFormulario(id: 'capacidad_tablero', etiqueta: 'Capacidad del tablero principal (A)',
              tipo: TipoCampoFormulario.numero),
          CampoFormulario(id: 'requiere_ampliacion', etiqueta: '¿Requiere ampliación de tablero?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'foto_fachada', etiqueta: 'Fotografía de fachada', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/residencial/fachada.jpg'),
          CampoFormulario(id: 'foto_tablero', etiqueta: 'Fotografía de tablero principal', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/residencial/tablero_principal.jpg'),
          CampoFormulario(id: 'firma_cliente', etiqueta: 'Firma del cliente', tipo: TipoCampoFormulario.firma),
        ];
      case 'Mantenimiento Preventivo':
        return const [
          CampoFormulario(id: 'estado_general', etiqueta: 'Estado general del sistema', tipo: TipoCampoFormulario.seleccion,
              opciones: ['Óptimo', 'Aceptable', 'Requiere atención']),
          CampoFormulario(id: 'meses_ultima_limpieza', etiqueta: 'Meses desde la última limpieza',
              tipo: TipoCampoFormulario.numero),
          CampoFormulario(id: 'suciedad_detectada', etiqueta: '¿Se detectó suciedad en los paneles?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'nivel_suciedad', etiqueta: 'Nivel de suciedad', tipo: TipoCampoFormulario.seleccion,
              opciones: ['Leve', 'Moderado', 'Alto'], mostrarSi: _suciedadDetectada),
          CampoFormulario(id: 'requiere_repuestos', etiqueta: '¿Requiere repuestos?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'lista_repuestos', etiqueta: 'Repuestos requeridos', tipo: TipoCampoFormulario.texto,
              mostrarSi: _siRequiereRepuestos),
          CampoFormulario(id: 'inversor_errores', etiqueta: '¿El inversor presenta errores?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'codigo_error', etiqueta: 'Código de error mostrado', tipo: TipoCampoFormulario.texto,
              mostrarSi: _inversorConErrores),
          CampoFormulario(id: 'voltaje_salida', etiqueta: 'Voltaje de salida medido (V)', tipo: TipoCampoFormulario.numero),
          CampoFormulario(id: 'corriente_salida', etiqueta: 'Corriente de salida medida (A)', tipo: TipoCampoFormulario.numero),
          CampoFormulario(id: 'foto_panel', etiqueta: 'Fotografía del panel eléctrico', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/tejados_sur/tablero_bodega.jpg'),
          CampoFormulario(id: 'observaciones_mant', etiqueta: 'Observaciones generales', tipo: TipoCampoFormulario.texto),
        ];
      case 'Validación de Levantamiento':
        return const [
          CampoFormulario(id: 'info_completa', etiqueta: '¿La información del sitio está completa?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'aprueba_mediciones', etiqueta: '¿Las mediciones son correctas?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'comentario_rechazo', etiqueta: 'Motivo del rechazo',
              tipo: TipoCampoFormulario.texto, mostrarSi: _noApruebaMediciones),
          CampoFormulario(id: 'evidencia_suficiente', etiqueta: '¿La evidencia fotográfica es suficiente?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'fotos_faltantes', etiqueta: 'Fotografías faltantes', tipo: TipoCampoFormulario.texto,
              mostrarSi: _evidenciaInsuficiente),
          CampoFormulario(id: 'hallazgos_criticos', etiqueta: '¿Hay hallazgos críticos sin resolver?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'detalle_hallazgos', etiqueta: 'Detalle de hallazgos críticos', tipo: TipoCampoFormulario.texto,
              mostrarSi: _hayHallazgosCriticos),
          CampoFormulario(id: 'comentarios_revision', etiqueta: 'Comentarios generales de revisión',
              tipo: TipoCampoFormulario.texto),
          CampoFormulario(id: 'firma_revisor', etiqueta: 'Firma del revisor', tipo: TipoCampoFormulario.firma),
        ];
      case 'Checklist de Visita de Campo':
        return const [
          CampoFormulario(id: 'visita_completada', etiqueta: '¿Visita completada en su totalidad?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'motivo_incompleta', etiqueta: 'Motivo de visita incompleta', tipo: TipoCampoFormulario.texto,
              mostrarSi: _noVisitaCompletada),
          CampoFormulario(id: 'cliente_presente', etiqueta: '¿El cliente estuvo presente?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'fotos_completas', etiqueta: '¿Se tomaron todas las fotografías requeridas?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'mediciones_completas', etiqueta: '¿Se realizaron todas las mediciones?',
              tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'observaciones_visita', etiqueta: 'Observaciones de la visita', tipo: TipoCampoFormulario.texto),
          CampoFormulario(id: 'firma_supervisor', etiqueta: 'Firma del supervisor', tipo: TipoCampoFormulario.firma),
        ];
      default:
        return const [
          CampoFormulario(id: 'campo_ejemplo_si_no', etiqueta: '¿Aplica esta condición?', tipo: TipoCampoFormulario.siNo),
          CampoFormulario(id: 'campo_condicional', etiqueta: 'Detalle (aparece si respondió Sí)',
              tipo: TipoCampoFormulario.texto, mostrarSi: _siExisteFv),
          CampoFormulario(id: 'foto_ejemplo', etiqueta: 'Fotografía de evidencia', tipo: TipoCampoFormulario.foto,
              asset: 'assets/images/residencial/cubierta.jpg'),
        ];
    }
  }

  static bool _siExisteFv(Map<String, dynamic> r) => r['existe_fv'] == true || r['campo_ejemplo_si_no'] == true;
  static bool _haySombras(Map<String, dynamic> r) => r['hay_sombras'] == true;
  static bool _siRequiereRepuestos(Map<String, dynamic> r) => r['requiere_repuestos'] == true;
  static bool _suciedadDetectada(Map<String, dynamic> r) => r['suciedad_detectada'] == true;
  static bool _inversorConErrores(Map<String, dynamic> r) => r['inversor_errores'] == true;
  static bool _noApruebaMediciones(Map<String, dynamic> r) => r['aprueba_mediciones'] == false;
  static bool _evidenciaInsuficiente(Map<String, dynamic> r) => r['evidencia_suficiente'] == false;
  static bool _hayHallazgosCriticos(Map<String, dynamic> r) => r['hallazgos_criticos'] == true;
  static bool _noVisitaCompletada(Map<String, dynamic> r) => r['visita_completada'] == false;
  static bool _requiereVisitaPrevia(Map<String, dynamic> r) => r['viabilidad'] == 'Requiere Visita Previa';
  static bool _existenDocumentos(Map<String, dynamic> r) => r['existen_documentos'] == true;
  static bool _noExistenDocumentos(Map<String, dynamic> r) => r['existen_documentos'] == false;

  bool get _esViabilidad => widget.nombre == 'Estudio de Viabilidad FV';

  List<CampoFormulario> get _camposVisibles =>
      _campos.where((c) => c.mostrarSi == null || c.mostrarSi!(_respuestas)).toList();

  bool get _camposCompletos =>
      _camposVisibles.where((c) => c.obligatorio).every((c) => _respuestas.containsKey(c.id));

  bool get _puedeEnviar {
    if (!_camposCompletos) return false;
    if (_esViabilidad) return _respuestas['viabilidad'] == 'Viable';
    return true;
  }

  String? get _motivoBloqueo {
    if (!_esViabilidad || !_camposCompletos) return null;
    return switch (_respuestas['viabilidad']) {
      'No Viable' => 'El proyecto fue marcado como no viable: no es posible avanzar a crear el proyecto.',
      'Requiere Visita Previa' => 'Complete la visita previa agendada y vuelva a evaluar la viabilidad antes de crear el proyecto.',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _camposVisibles;
    final respondidos =
        visibles.where((c) => c.tipo == TipoCampoFormulario.nota || _respuestas.containsKey(c.id)).length;
    final avance = visibles.isEmpty ? 0.0 : respondidos / visibles.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.nombre,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vista previa interactiva: así se le presenta esta plantilla al rol ${widget.rol} en campo. '
                    'Complete el ejemplo para ver cómo aparecen los campos condicionales.',
                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progreso del formulario',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text('$respondidos / ${visibles.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: avance,
                      minHeight: 8,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final c in visibles) ...[
                    _CampoRenderer(
                      campo: c,
                      valorActual: _respuestas[c.id],
                      onChanged: (v) => setState(() => _respuestas[c.id] = v),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (!_enviado && _motivoBloqueo != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.severityHighBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.block, color: AppColors.severityHighText, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_motivoBloqueo!,
                                style: const TextStyle(fontSize: 12, color: AppColors.severityHighText)),
                          ),
                        ],
                      ),
                    ),
                  if (_enviado)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.statusApprovedBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.statusApprovedText, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _esViabilidad
                                  ? 'Proyecto marcado como viable: ya puede crearse desde Gestión de Proyectos.'
                                  : 'Formulario enviado. La información capturada aquí quedaría registrada en el proyecto y visible para revisión.',
                              style: const TextStyle(fontSize: 12, color: AppColors.statusApprovedText),
                            ),
                          ),
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
                onPressed: _puedeEnviar
                    ? () => setState(() => _enviado = true)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: Icon(_esViabilidad ? Icons.arrow_forward : Icons.send_outlined, size: 18),
                label: Text(_esViabilidad ? 'Avanzar a Crear Proyecto' : 'Enviar Formulario (ejemplo)',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampoRenderer extends StatelessWidget {
  final CampoFormulario campo;
  final dynamic valorActual;
  final ValueChanged<dynamic> onChanged;
  const _CampoRenderer({required this.campo, required this.valorActual, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (campo.tipo == TipoCampoFormulario.nota) return _buildInput(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(campo.etiqueta,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
            if (campo.obligatorio) const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        _buildInput(context),
      ],
    );
  }

  Widget _buildInput(BuildContext context) {
    switch (campo.tipo) {
      case TipoCampoFormulario.texto:
        return TextField(
          onChanged: (v) => onChanged(v.isEmpty ? null : v),
          decoration: _decoration('Escriba aquí...'),
        );
      case TipoCampoFormulario.numero:
        return TextField(
          keyboardType: TextInputType.number,
          onChanged: (v) => onChanged(v.isEmpty ? null : v),
          decoration: _decoration('0'),
        );
      case TipoCampoFormulario.seleccion:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: campo.opciones
              .map((o) => ChoiceChip(
                    label: Text(o),
                    selected: valorActual == o,
                    onSelected: (_) => onChanged(o),
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                        color: valorActual == o ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: valorActual == o ? FontWeight.bold : FontWeight.normal),
                  ))
              .toList(),
        );
      case TipoCampoFormulario.siNo:
        return Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('Sí'),
                selected: valorActual == true,
                onSelected: (_) => onChanged(true),
                selectedColor: AppColors.statusApprovedBg,
                labelStyle: TextStyle(
                    color: valorActual == true ? AppColors.statusApprovedText : AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: const Text('No'),
                selected: valorActual == false,
                onSelected: (_) => onChanged(false),
                selectedColor: AppColors.severityHighBg,
                labelStyle:
                    TextStyle(color: valorActual == false ? AppColors.severityHighText : AppColors.textSecondary),
              ),
            ),
          ],
        );
      case TipoCampoFormulario.foto:
        final capturada = valorActual == true;
        if (capturada && campo.asset != null) {
          return InkWell(
            onTap: () => mostrarFotoAmpliada(context, campo.asset!, etiqueta: campo.etiqueta),
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.asset(campo.asset!, width: double.infinity, height: 140, fit: BoxFit.cover),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      color: Colors.black.withValues(alpha: 0.55),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text('Fotografía capturada · toque para ampliar',
                              style: TextStyle(fontSize: 11, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return InkWell(
          onTap: () => onChanged(true),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
              color: capturada ? AppColors.statusApprovedBg : AppColors.background,
              border: Border.all(color: capturada ? AppColors.statusApprovedText : AppColors.border, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(capturada ? Icons.check_circle : Icons.camera_alt_outlined,
                      color: capturada ? AppColors.statusApprovedText : AppColors.textMuted),
                  const SizedBox(height: 4),
                  Text(capturada ? 'Fotografía capturada' : 'Toque para capturar foto',
                      style: TextStyle(
                          fontSize: 12,
                          color: capturada ? AppColors.statusApprovedText : AppColors.textMuted)),
                ],
              ),
            ),
          ),
        );
      case TipoCampoFormulario.agendarVisita:
        final fecha = valorActual is DateTime ? valorActual : null;
        return InkWell(
          onTap: () async {
            final hoy = DateTime.now();
            final fechaElegida = await showDatePicker(
              context: context,
              initialDate: fecha ?? hoy,
              firstDate: hoy,
              lastDate: hoy.add(const Duration(days: 180)),
            );
            if (fechaElegida == null || !context.mounted) return;
            final horaElegida = await showTimePicker(
              context: context,
              initialTime: fecha != null ? TimeOfDay.fromDateTime(fecha) : const TimeOfDay(hour: 10, minute: 0),
            );
            if (horaElegida == null) return;
            onChanged(DateTime(
                fechaElegida.year, fechaElegida.month, fechaElegida.day, horaElegida.hour, horaElegida.minute));
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: fecha != null ? AppColors.statusApprovedBg : AppColors.statusPendingBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(fecha != null ? Icons.event_available_outlined : Icons.event_outlined,
                    color: fecha != null ? AppColors.statusApprovedText : AppColors.statusPendingText),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fecha != null
                        ? 'Visita previa agendada para ${_formatearFecha(fecha)} · toque para cambiar'
                        : 'Toque para elegir el día y la hora de la visita previa',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: fecha != null ? AppColors.statusApprovedText : AppColors.statusPendingText),
                  ),
                ),
              ],
            ),
          ),
        );
      case TipoCampoFormulario.nota:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(campo.etiqueta, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
            ],
          ),
        );
      case TipoCampoFormulario.firma:
        final firmado = valorActual == true;
        return InkWell(
          onTap: () => onChanged(true),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: firmado ? AppColors.statusApprovedBg : AppColors.background,
              border: Border.all(color: firmado ? AppColors.statusApprovedText : AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(firmado ? 'Firmado' : 'Toque para firmar',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: firmado ? AppColors.statusApprovedText : AppColors.textMuted)),
            ),
          ),
        );
    }
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        isDense: true,
        hintText: hint,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      );
}
