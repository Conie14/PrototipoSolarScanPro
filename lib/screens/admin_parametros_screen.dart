import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Parámetros Generales" — ítem del drawer de Admin sin frame exacto en
/// Figma; construido con el mismo lenguaje visual (tarjetas + inputs) que
/// el resto del rol.
class AdminParametrosBody extends StatefulWidget {
  const AdminParametrosBody({super.key});

  @override
  State<AdminParametrosBody> createState() => _AdminParametrosBodyState();
}

class _AdminParametrosBodyState extends State<AdminParametrosBody> {
  final _empresaCtrl = TextEditingController(text: 'SolarScan Pro Industrial S.A.');
  final _correoCtrl = TextEditingController(text: 'contacto@solarscan.pro');
  String _unidad = 'Métrico';
  String _zonaHoraria = 'GMT-6 (Ciudad de México)';
  bool _notificacionesPush = true;
  bool _notificacionesCorreo = true;
  bool _sincronizacionAutomatica = false;

  static const _unidades = ['Métrico', 'Imperial'];
  static const _zonas = [
    'GMT-6 (Ciudad de México)',
    'GMT-5 (Bogotá / Lima)',
    'GMT-3 (Buenos Aires)',
    'GMT+1 (Madrid)',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Parámetros Generales',
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.64, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Configuración general de la organización y del sistema.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _Section(
            title: 'Organización',
            children: [
              _LabeledField(label: 'Nombre de la Empresa', controller: _empresaCtrl),
              const SizedBox(height: 16),
              _LabeledField(label: 'Correo de Contacto', controller: _correoCtrl),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Regional',
            children: [
              const Text('Unidad de medida',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _unidades.map((u) {
                  return ChoiceChip(
                    label: Text(u),
                    selected: _unidad == u,
                    onSelected: (_) => setState(() => _unidad = u),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: _unidad == u ? Colors.white : AppColors.textPrimary),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Zona horaria',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _zonaHoraria,
                    isExpanded: true,
                    items: _zonas.map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                    onChanged: (v) => setState(() => _zonaHoraria = v!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Notificaciones y Sincronización',
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                value: _notificacionesPush,
                onChanged: (v) => setState(() => _notificacionesPush = v),
                title: const Text('Notificaciones push', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Alertas de nuevas visitas y hallazgos críticos',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                value: _notificacionesCorreo,
                onChanged: (v) => setState(() => _notificacionesCorreo = v),
                title: const Text('Notificaciones por correo', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Resumen semanal y reportes finalizados',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                value: _sincronizacionAutomatica,
                onChanged: (v) => setState(() => _sincronizacionAutomatica = v),
                title: const Text('Sincronización automática', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Sincronizar levantamientos de campo al conectar a Wi-Fi',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Parámetros guardados correctamente')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _LabeledField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
