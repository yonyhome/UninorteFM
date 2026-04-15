import 'package:firebase_remote_config/firebase_remote_config.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// REMOTE CONFIG SERVICE
//
// Parámetros que debes crear en la consola de Firebase Remote Config:
//
//   min_required_version  (String)  →  Ej: "10.3.0"
//     Versión mínima que puede correr la app. Si la versión instalada es
//     inferior, se bloquea la app y se fuerza la actualización.
//
//   store_url_android  (String)  →  URL de Play Store
//   store_url_ios      (String)  →  URL de App Store
// ═══════════════════════════════════════════════════════════════════════════════

class RemoteConfigService {
  RemoteConfigService._();

  // Valores por defecto — la app funciona aunque Remote Config no responda.
  static const _defaults = <String, dynamic>{
    'min_required_version': '1.0.0',
    'store_url_android':
        'https://play.google.com/store/apps/details?id=co.edu.uninorte.UninorteFM',
    'store_url_ios':
        'https://apps.apple.com/app/id000000000', // TODO: reemplazar con el ID real
  };

  static final _rc = FirebaseRemoteConfig.instance;

  /// Inicializa Remote Config y descarga los valores más recientes.
  static Future<void> init() async {
    await _rc.setConfigSettings(RemoteConfigSettings(
      // En producción fetcha como máximo cada hora para no agotar la cuota.
      minimumFetchInterval: const Duration(hours: 1),
      fetchTimeout: const Duration(seconds: 10),
    ));
    await _rc.setDefaults(_defaults);

    // Intenta descargar y activar. Si falla (sin red), usa los valores en caché.
    try {
      await _rc.fetchAndActivate();
    } catch (_) {}
  }

  // ── Getters ────────────────────────────────────────────────────────────────

  static String get minRequiredVersion =>
      _rc.getString('min_required_version');

  static String get storeUrlAndroid =>
      _rc.getString('store_url_android');

  static String get storeUrlIos =>
      _rc.getString('store_url_ios');

  // ── Lógica de versiones ────────────────────────────────────────────────────

  /// Compara [current] con [minRequired] usando semver (MAJOR.MINOR.PATCH).
  /// Devuelve `true` si la app necesita actualizarse.
  static bool needsUpdate(String current) {
    final min = minRequiredVersion;
    return _compareSemver(current, min) < 0;
  }

  /// Retorna:
  ///  -1  →  a < b  (necesita actualizar)
  ///   0  →  a == b
  ///   1  →  a > b
  static int _compareSemver(String a, String b) {
    final partsA = _parseSemver(a);
    final partsB = _parseSemver(b);

    for (int i = 0; i < 3; i++) {
      if (partsA[i] < partsB[i]) return -1;
      if (partsA[i] > partsB[i]) return 1;
    }
    return 0;
  }

  static List<int> _parseSemver(String version) {
    // Elimina sufijos como "-rc1", "+build", etc.
    final clean = version.split(RegExp(r'[-+]')).first;
    final parts = clean.split('.');
    return List.generate(3, (i) {
      if (i >= parts.length) return 0;
      return int.tryParse(parts[i]) ?? 0;
    });
  }
}
