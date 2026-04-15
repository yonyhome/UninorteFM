import 'package:firebase_analytics/firebase_analytics.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ANALYTICS SERVICE
// Centraliza todos los eventos de Firebase Analytics de la app.
// Uso: AnalyticsService.logRadioPlay();
// ═══════════════════════════════════════════════════════════════════════════════

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ── Getter del observer para el NavigatorObserver ────────────────────────────
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ───────────────────────────────────────────────────────────────────────────
  // PANTALLAS
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> logScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // NAVEGACIÓN — Tabs
  // ───────────────────────────────────────────────────────────────────────────

  static const _tabNames = [
    'en_vivo',
    'podcast',
    'programacion',
    'explorar',
    'mas',
  ];

  /// Llamar cuando el usuario cambia de pestaña en el navbar.
  static Future<void> logTabChange(int tabIndex) async {
    final name = tabIndex < _tabNames.length ? _tabNames[tabIndex] : 'unknown';
    await _analytics.logEvent(
      name: 'tab_change',
      parameters: {'tab_name': name, 'tab_index': tabIndex},
    );
    await logScreen(name);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // RADIO EN VIVO
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> logRadioPlay() async {
    await _analytics.logEvent(name: 'radio_play');
  }

  static Future<void> logRadioPause() async {
    await _analytics.logEvent(name: 'radio_pause');
  }

  static Future<void> logRadioStop() async {
    await _analytics.logEvent(name: 'radio_stop');
  }

  static Future<void> logRadioError() async {
    await _analytics.logEvent(name: 'radio_error');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PODCAST — Shows
  // ───────────────────────────────────────────────────────────────────────────

  /// El usuario abre la pantalla de detalle de un show.
  static Future<void> logPodcastShowOpen({
    required String showId,
    required String showName,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_show_open',
      parameters: {'show_id': showId, 'show_name': showName},
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PODCAST — Reproducción
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> logPodcastEpisodePlay({
    required String showId,
    required String showName,
    required int episodeIndex,
    required String episodeTitle,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_episode_play',
      parameters: {
        'show_id': showId,
        'show_name': showName,
        'episode_index': episodeIndex,
        'episode_title': episodeTitle,
      },
    );
  }

  static Future<void> logPodcastEpisodePause({
    required String showId,
    required String episodeTitle,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_episode_pause',
      parameters: {'show_id': showId, 'episode_title': episodeTitle},
    );
  }

  static Future<void> logPodcastEpisodeResume({
    required String showId,
    required String episodeTitle,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_episode_resume',
      parameters: {'show_id': showId, 'episode_title': episodeTitle},
    );
  }

  static Future<void> logPodcastEpisodeSeek({
    required String showId,
    required String episodeTitle,
    required int positionMs,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_episode_seek',
      parameters: {
        'show_id': showId,
        'episode_title': episodeTitle,
        'position_ms': positionMs,
      },
    );
  }

  static Future<void> logPodcastNext({
    required String showId,
    required String fromEpisodeTitle,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_next',
      parameters: {
        'show_id': showId,
        'from_episode_title': fromEpisodeTitle,
      },
    );
  }

  static Future<void> logPodcastPrevious({
    required String showId,
    required String fromEpisodeTitle,
  }) async {
    await _analytics.logEvent(
      name: 'podcast_previous',
      parameters: {
        'show_id': showId,
        'from_episode_title': fromEpisodeTitle,
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PODCAST — Panel
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> logPodcastExpand() async {
    await _analytics.logEvent(name: 'podcast_expand');
  }

  static Future<void> logPodcastCollapse() async {
    await _analytics.logEvent(name: 'podcast_collapse');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // EXPLORAR — Redes sociales
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> logSocialLinkTap(String platform) async {
    await _analytics.logEvent(
      name: 'social_link_tap',
      parameters: {'platform': platform},
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MÁS — Acciones
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> logShareApp() async {
    await _analytics.logShare(
      contentType: 'app',
      itemId: 'uninorte_fm',
      method: 'share_sheet',
    );
  }

  static Future<void> logContactTap() async {
    await _analytics.logEvent(name: 'contact_whatsapp_tap');
  }

  static Future<void> logAboutOpen() async {
    await _analytics.logEvent(name: 'about_open');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LEGAL
  // ───────────────────────────────────────────────────────────────────────────

  /// page: 'terminos' | 'privacidad'
  static Future<void> logLegalView(String page) async {
    await _analytics.logEvent(
      name: 'legal_view',
      parameters: {'page': page},
    );
    await logScreen('legal_$page');
  }
}
