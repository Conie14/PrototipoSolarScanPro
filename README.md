# SolarScan Pro — Prototipo de pantallas (Figma → Flutter)

Este proyecto contiene 2 pantallas recreadas pixel-a-pixel desde tu Figma:

- `lib/screens/login_screen.dart` → "Inicio de Sesión"
- `lib/screens/admin_dashboard_screen.dart` → "Dashboard Admin"

Al tocar **"Iniciar Sesión"** navega al Dashboard (sin backend, solo navegación visual).

## Requisitos previos (en tu computadora, no aquí)

1. Instalar **Flutter SDK**: https://docs.flutter.dev/get-started/install
2. Instalar **Android Studio** (trae el Android SDK necesario para compilar el APK).
3. Verificar que todo esté bien configurado:
   ```
   flutter doctor
   ```
   Soluciona cualquier ❌ que aparezca (normalmente licencias de Android: `flutter doctor --android-licenses`).

## Cómo correr el proyecto

1. Descomprime este proyecto y entra a la carpeta:
   ```
   cd solarscan_pro
   ```
2. Instala las dependencias:
   ```
   flutter pub get
   ```
3. Para probarlo en un emulador o teléfono conectado (USB, con depuración activada):
   ```
   flutter run
   ```

## Cómo generar el APK

```
flutter build apk --release
```

El archivo se genera en:
```
build/app/outputs/flutter-apk/app-release.apk
```

Cópialo a tu teléfono e instálalo (activa "Instalar apps de orígenes desconocidos" si Android te lo pide).

## Siguientes pasos

Este es solo el arranque (Login + Dashboard Admin). El archivo de Figma tiene ~70 pantallas
únicas repartidas en 4 roles (Admin, Supervisor, Técnico, Revisor). Cuando quieras seguir,
dile a Claude qué rol o pantallas agregar y se van sumando a `lib/screens/` siguiendo el
mismo patrón (un archivo por pantalla + navegación entre ellas).
# PrototipoSolarScanPro
