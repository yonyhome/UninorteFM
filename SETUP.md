# Uninorte FM — Flutter

## 1. Crear el proyecto Flutter base

Desde esta carpeta, ejecuta:

```bash
flutter create . --project-name uninorte_fm --org com.uninorte --platforms android,ios
```

Esto genera el scaffolding de Android/iOS sin sobrescribir los archivos `lib/` ya creados.

## 2. Copiar assets

Copia las imágenes del proyecto web a `assets/images/`:

```
uninorte-fm/public/logo-icon.png   →  assets/images/logo_icon.png
uninorte-fm/public/senal-en-vivo.png  →  assets/images/senal_en_vivo.png
```

## 3. Instalar dependencias

```bash
flutter pub get
```

## 4. Configuración Android

El archivo `android/app/src/main/AndroidManifest.xml` ya fue generado con los permisos correctos.  
Asegúrate de que `android/app/build.gradle` tenga `minSdkVersion 21` o superior:

```gradle
defaultConfig {
    minSdkVersion 21
    targetSdkVersion 34
}
```

## 5. Configuración iOS

El archivo `ios/Runner/Info.plist` ya fue generado con `UIBackgroundModes: audio`.  
Abre `ios/Runner.xcworkspace` en Xcode y:
- Firma con tu Apple Developer Account
- En "Signing & Capabilities" → añade "Background Modes" → marca "Audio, AirPlay, and Picture in Picture"

## 6. Ejecutar

```bash
# Android
flutter run -d android

# iOS (requiere Mac + Xcode)
flutter run -d ios
```

## Estructura del proyecto

```
lib/
├── main.dart              # Punto de entrada, init audio_service
├── app.dart               # MaterialApp + tema
├── theme/app_theme.dart   # Colores y tipografía
├── models/podcast_data.dart # Datos hardcoded de shows
├── providers/radio_provider.dart  # Estado global del audio
├── services/radio_audio_handler.dart  # Background audio (audio_service)
├── screens/
│   ├── home_screen.dart        # En Vivo
│   ├── podcast_screen.dart     # Podcasts
│   ├── programacion_screen.dart # Programación (WebView)
│   ├── explorar_screen.dart    # Redes sociales
│   └── mas_screen.dart         # Más / Share
└── widgets/
    ├── main_scaffold.dart      # Scaffold + BottomNav + MiniPlayer
    ├── mini_player.dart        # Reproductor flotante animado
    └── audio_visualizer.dart  # Barras animadas del ecualizador
```
