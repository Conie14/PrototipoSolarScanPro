import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'admin_dashboard_screen.dart';
import 'supervisor_shell.dart';
import 'tecnico_shell.dart';
import 'revisor_shell.dart';

// Cada rol tiene su propio shell (drawer + pantallas): Admin, Supervisor,
// Técnico y Revisor están todos conectados.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _rol = 'Admin';
  static const _roles = ['Admin', 'Supervisor', 'Técnico', 'Revisor'];

  void _irADashboard(BuildContext context) {
    final Widget destino = switch (_rol) {
      'Supervisor' => const SupervisorShell(),
      'Admin' => const AdminShell(),
      'Técnico' => const TecnicoShell(),
      'Revisor' => const RevisorShell(),
      _ => const AdminShell(),
    };
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => destino));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 448),
              padding: const EdgeInsets.all(33),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.solar_power, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SolarScan Pro',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.64,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Portal de Inspección y Análisis Industrial',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  _LabeledInput(
                    label: 'Correo Electrónico',
                    hint: 'tecnico@solarscan.pro',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 24),
                  _LabeledInput(
                    label: 'Contraseña',
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Se envió un enlace de recuperación a tu correo')));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Selector de rol: no existe en el diseño de Figma, se
                  // agrega solo para poder probar cada dashboard del prototipo.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Probar como (solo demo)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _roles.map((r) {
                      final selected = r == _rol;
                      return ChoiceChip(
                        label: Text(r),
                        selected: selected,
                        onSelected: (_) => setState(() => _rol = r),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                            color: selected ? Colors.white : AppColors.textPrimary),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () => _irADashboard(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _LabeledInput({
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.placeholder),
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
