import 'package:flutter/material.dart';

/// Colores extraídos directamente del diseño de Figma (SolarScan Pro).
class AppColors {
  static const primary = Color(0xFF005AB6); // Botones, links, acentos
  static const primaryLight = Color(0xFF1672DF); // Ícono de marca, avatar
  static const background = Color(0xFFFBF9F8); // Fondo general
  static const surface = Colors.white; // Tarjetas, inputs
  static const border = Color(0xFFC1C6D5);
  static const textPrimary = Color(0xFF1B1C1C);
  static const textSecondary = Color(0xFF414753);
  static const textMuted = Color(0xFF727785);
  static const placeholder = Color(0xFFC1C6D5);

  // Acentos de las tarjetas KPI del dashboard
  static const kpiOrange = Color(0xFF904D00);
  static const kpiBlue = Color(0xFF005AB6);
  static const kpiBrown = Color(0xFF934700);

  static const error = Color(0xFFBA1A1A);

  // Severidad de hallazgos (Técnico - Registro de Hallazgos)
  static const severityHighBg = Color(0xFFFFDAD6);
  static const severityHighText = Color(0xFF93000A);
  static const severityMediumBg = Color(0xFFB85A00);
  static const severityLowBg = Color(0xFFE4E2E2);

  // Estados de revisión (Revisor)
  static const statusPendingBg = Color(0xFFFFA454);
  static const statusPendingText = Color(0xFF713B00);
  static const statusCorrectionBg = Color(0xFFFFDAD6);
  static const statusCorrectionText = Color(0xFF93000A);
  static const statusApprovedBg = Color(0xFFE8F5E9);
  static const statusApprovedText = Color(0xFF1B5E20);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
    );
  }
}
