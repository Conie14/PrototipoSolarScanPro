/// Tipos de campo soportados por el motor de formularios dinámicos
/// (Documento de Requerimientos, sección 9). Se usa tanto en las plantillas
/// predefinidas como en las plantillas creadas por el Admin.
enum TipoCampoFormulario { texto, numero, seleccion, siNo, foto, firma, agendarVisita, nota }

/// Definición de un campo de plantilla: su etiqueta, tipo de respuesta,
/// opciones (si aplica), si es obligatorio, una imagen real opcional para
/// ejemplificarlo, y una condición opcional para mostrarse solo si otra
/// respuesta cumple cierto criterio (campos condicionales).
class CampoFormulario {
  final String id;
  final String etiqueta;
  final TipoCampoFormulario tipo;
  final List<String> opciones;
  final bool obligatorio;
  final String? asset;
  final bool Function(Map<String, dynamic> respuestas)? mostrarSi;

  const CampoFormulario({
    required this.id,
    required this.etiqueta,
    required this.tipo,
    this.opciones = const [],
    this.obligatorio = true,
    this.asset,
    this.mostrarSi,
  });
}
