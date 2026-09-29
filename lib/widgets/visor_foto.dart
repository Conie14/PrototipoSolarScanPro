import 'package:flutter/material.dart';

/// Abre una fotografía en un visor de pantalla completa con zoom (pinch to
/// zoom), para poder ver el detalle de la evidencia capturada.
Future<void> mostrarFotoAmpliada(BuildContext context, String asset, {String? etiqueta}) {
  return Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    barrierColor: Colors.black,
    pageBuilder: (_, __, ___) => _VisorFotoScreen(asset: asset, etiqueta: etiqueta),
    transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
  ));
}

class _VisorFotoScreen extends StatelessWidget {
  final String asset;
  final String? etiqueta;
  const _VisorFotoScreen({required this.asset, this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: Center(
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (etiqueta != null)
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Text(
                  etiqueta!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
