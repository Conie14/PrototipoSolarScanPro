import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Fotografía de ejemplo con imagen real (assets/) y un ícono/color de
/// respaldo por si la imagen no carga.
class FotoEjemplo {
  final String etiqueta;
  final IconData icon;
  final Color color;
  final String? asset;
  const FotoEjemplo(this.etiqueta, this.icon, this.color, {this.asset});
}

/// Un proyecto de ejemplo completo y consistente a través de los 4 roles
/// (Admin, Supervisor, Técnico, Revisor), con fotografías reales para
/// demostrar el flujo de principio a fin.
class ProyectoEjemplo {
  final String id;
  final String nombre;
  final String cliente;
  final String contacto;
  final String direccion;
  final String tipo;
  final String supervisor;
  final String tecnico;
  final Color accent;
  final List<FotoEjemplo> fotos;

  const ProyectoEjemplo({
    required this.id,
    required this.nombre,
    required this.cliente,
    required this.contacto,
    required this.direccion,
    required this.tipo,
    required this.supervisor,
    required this.tecnico,
    required this.accent,
    required this.fotos,
  });
}

class ProyectosEjemplo {
  ProyectosEjemplo._();

  static const residencial = ProyectoEjemplo(
    id: 'PRJ-2023-8472',
    nombre: 'Instalación Familia Rojas',
    cliente: 'Carlos Rojas Villalobos',
    contacto: '+506 8832-1940',
    direccion: '150m Norte de la Iglesia Católica, Santa Ana, San José',
    tipo: 'INSPECCIÓN INICIAL',
    supervisor: 'J. Martínez',
    tecnico: 'J. Miller',
    accent: AppColors.kpiBrown,
    fotos: [
      FotoEjemplo('Fachada', Icons.home_work_outlined, AppColors.kpiBlue,
          asset: 'assets/images/residencial/fachada.jpg'),
      FotoEjemplo('Tablero Principal', Icons.electrical_services_outlined, AppColors.kpiOrange,
          asset: 'assets/images/residencial/tablero_principal.jpg'),
      FotoEjemplo('Módulos FV', Icons.solar_power_outlined, AppColors.kpiBrown,
          asset: 'assets/images/residencial/modulos_fv.jpg'),
      FotoEjemplo('Medidor', Icons.speed_outlined, AppColors.primary,
          asset: 'assets/images/residencial/medidor.jpg'),
      FotoEjemplo('Cubierta', Icons.roofing_outlined, AppColors.kpiBlue,
          asset: 'assets/images/residencial/cubierta.jpg'),
    ],
  );

  static const industrial = ProyectoEjemplo(
    id: 'PRJ-2023-8842',
    nombre: 'TRUPER Monterrey',
    cliente: 'Truper Herramientas S.A.',
    contacto: '+52 81 4455-2200',
    direccion: 'Parque Industrial, Monterrey, Nuevo León',
    tipo: 'AUDITORÍA FINAL',
    supervisor: 'A. Gómez',
    tecnico: 'A. Gómez',
    accent: AppColors.error,
    fotos: [
      FotoEjemplo('Techo — Muelles de Carga (Dron)', Icons.warehouse_outlined, AppColors.kpiOrange,
          asset: 'assets/images/industrial/techo_dron_1.jpg'),
      FotoEjemplo('Techo General (Dron)', Icons.flight_outlined, AppColors.primary,
          asset: 'assets/images/industrial/techo_dron_2.jpg'),
      FotoEjemplo('Fachada de la Nave', Icons.warehouse_outlined, AppColors.kpiOrange,
          asset: 'assets/images/industrial/fachada_industrial.jpg'),
      FotoEjemplo('Medidor', Icons.speed_outlined, AppColors.primary,
          asset: 'assets/images/industrial/medidor_industrial.jpg'),
      FotoEjemplo('Tablero / Switchgear', Icons.electrical_services_outlined, AppColors.kpiBrown,
          asset: 'assets/images/industrial/tablero_industrial.jpg'),
      FotoEjemplo('Transformador', Icons.bolt_outlined, AppColors.error,
          asset: 'assets/images/industrial/transformador_industrial.jpg'),
      FotoEjemplo('Medición con Multímetro', Icons.speed_outlined, AppColors.kpiBlue,
          asset: 'assets/images/industrial/multimetro_paneles.jpg'),
    ],
  );

  static const plantaSolarAlpha = ProyectoEjemplo(
    id: 'PRJ-2023-C15',
    nombre: 'Planta Solar Alpha',
    cliente: 'EnerTech Corp',
    contacto: '+506 2233-1010',
    direccion: 'Zona Franca Metropolitana, San José',
    tipo: 'VIABILIDAD FV',
    supervisor: 'J. Martínez',
    tecnico: 'J. Miller',
    accent: AppColors.kpiOrange,
    fotos: [
      FotoEjemplo('Techo (Evaluación)', Icons.roofing_outlined, AppColors.kpiBlue,
          asset: 'assets/images/planta_solar_alpha/techo_evaluacion.jpg'),
      FotoEjemplo('Acometida y Medidor', Icons.speed_outlined, AppColors.primary,
          asset: 'assets/images/planta_solar_alpha/acometida_medidor.jpg'),
      FotoEjemplo('Tablero Principal', Icons.electrical_services_outlined, AppColors.kpiOrange,
          asset: 'assets/images/planta_solar_alpha/tablero_principal.jpg'),
      FotoEjemplo('Fachada', Icons.home_work_outlined, AppColors.kpiBrown,
          asset: 'assets/images/planta_solar_alpha/fachada_comercial.jpg'),
    ],
  );

  static const tejadosSur = ProyectoEjemplo(
    id: 'PRJ-2023-M22',
    nombre: 'Tejados Sur M-22',
    cliente: 'Logisur S.A.',
    contacto: '+506 2244-2020',
    direccion: 'Zona Industrial, Cartago',
    tipo: 'MANTENIMIENTO',
    supervisor: 'A. Gómez',
    tecnico: 'S. Connor',
    accent: AppColors.kpiBrown,
    fotos: [
      FotoEjemplo('Cubierta (Mantenimiento)', Icons.roofing_outlined, AppColors.kpiBlue,
          asset: 'assets/images/tejados_sur/paneles_mantenimiento.jpg'),
      FotoEjemplo('Módulos (Desgaste)', Icons.solar_power_outlined, AppColors.kpiBrown,
          asset: 'assets/images/tejados_sur/modulos_desgaste.jpg'),
      FotoEjemplo('Medidor y Acometida', Icons.speed_outlined, AppColors.primary,
          asset: 'assets/images/tejados_sur/medidor_acometida.jpg'),
      FotoEjemplo('Tablero', Icons.electrical_services_outlined, AppColors.kpiOrange,
          asset: 'assets/images/tejados_sur/tablero_bodega.jpg'),
    ],
  );

  static const plantaSolarNorte = ProyectoEjemplo(
    id: 'PRJ-2023-492A',
    nombre: 'Planta Solar Norte',
    cliente: 'EnerTech Corp',
    contacto: '+506 2233-4455',
    direccion: 'Zona Industrial, Nave 4, Alajuela',
    tipo: 'INSPECCIÓN INICIAL',
    supervisor: 'L. Ramírez',
    tecnico: 'A. Gómez',
    accent: AppColors.kpiBlue,
    fotos: [
      FotoEjemplo('Vista Aérea de la Planta', Icons.flight_outlined, AppColors.primary,
          asset: 'assets/images/planta_solar_norte/planta_aerea.jpg'),
      FotoEjemplo('Filas de Paneles', Icons.solar_power_outlined, AppColors.kpiBrown,
          asset: 'assets/images/planta_solar_norte/filas_paneles.jpg'),
      FotoEjemplo('Subestación', Icons.bolt_outlined, AppColors.error,
          asset: 'assets/images/planta_solar_norte/subestacion_planta.jpg'),
      FotoEjemplo('Sala de Inversores', Icons.dns_outlined, AppColors.kpiOrange,
          asset: 'assets/images/planta_solar_norte/sala_inversores.jpg'),
    ],
  );

  static const farmaciaSector4 = ProyectoEjemplo(
    id: 'PRJ-2023-A91',
    nombre: 'Farmacia Sector 4',
    cliente: 'Farmacias del Valle S.A.',
    contacto: '+506 8811-2233',
    direccion: 'Av. Central, Sector 4, Heredia',
    tipo: 'MANTENIMIENTO',
    supervisor: 'J. Martínez',
    tecnico: 'J. Miller',
    accent: AppColors.kpiBlue,
    fotos: [
      FotoEjemplo('Fachada', Icons.storefront_outlined, AppColors.kpiBlue,
          asset: 'assets/images/farmacia_sector4/fachada.jpg'),
      FotoEjemplo('Techo (Mini Arreglo FV)', Icons.solar_power_outlined, AppColors.kpiBrown,
          asset: 'assets/images/farmacia_sector4/techo_mini_fv.jpg'),
      FotoEjemplo('Medidor Comercial', Icons.speed_outlined, AppColors.primary,
          asset: 'assets/images/farmacia_sector4/medidor_comercial.jpg'),
      FotoEjemplo('Tablero del Local', Icons.electrical_services_outlined, AppColors.kpiOrange,
          asset: 'assets/images/farmacia_sector4/tablero_local.jpg'),
    ],
  );

  static const valleyRidge = ProyectoEjemplo(
    id: 'PRJ-2023-B22',
    nombre: 'Valley Ridge Installation',
    cliente: 'Valley Ridge Corp',
    contacto: '+506 8899-1122',
    direccion: 'Ruta 27, Km 12, Puntarenas',
    tipo: 'INSPECCIÓN INICIAL',
    supervisor: 'A. Gómez',
    tecnico: 'S. Connor',
    accent: AppColors.kpiBrown,
    fotos: [
      FotoEjemplo('Instalación (Fachada y Techo)', Icons.home_work_outlined, AppColors.kpiBlue,
          asset: 'assets/images/valley_ridge/instalacion.png'),
      FotoEjemplo('Medidor Rural', Icons.speed_outlined, AppColors.primary,
          asset: 'assets/images/valley_ridge/medidor_rural.png'),
      FotoEjemplo('Tablero', Icons.electrical_services_outlined, AppColors.kpiOrange,
          asset: 'assets/images/valley_ridge/tablero_rural.png'),
    ],
  );

  static const solarFarmExpansion = ProyectoEjemplo(
    id: 'PRJ-2023-089A',
    nombre: 'Solar Farm Expansion',
    cliente: 'Grupo Energético del Pacífico',
    contacto: '+506 2299-5050',
    direccion: 'Guanacaste, Costa Rica',
    tipo: 'EXPANSIÓN DE PLANTA',
    supervisor: 'L. Ramírez',
    tecnico: 'A. Gómez',
    accent: AppColors.primary,
    fotos: [
      FotoEjemplo('Vista Aérea (Dron)', Icons.flight_outlined, AppColors.kpiBlue,
          asset: 'assets/images/solar_farm_expansion/expansion_aerea.jpg'),
      FotoEjemplo('Filas de Paneles Operativos', Icons.solar_power_outlined, AppColors.kpiBrown,
          asset: 'assets/images/solar_farm_expansion/paneles_operativos.jpg'),
    ],
  );

  static const todos = [
    residencial,
    industrial,
    plantaSolarAlpha,
    tejadosSur,
    plantaSolarNorte,
    farmaciaSector4,
    valleyRidge,
    solarFarmExpansion,
  ];

  static ProyectoEjemplo? porId(String? id) {
    if (id == null) return null;
    for (final p in todos) {
      if (p.id == id) return p;
    }
    return null;
  }

  static ProyectoEjemplo? porNombre(String? nombre) {
    if (nombre == null) return null;
    for (final p in todos) {
      if (p.nombre == nombre) return p;
    }
    return null;
  }
}
