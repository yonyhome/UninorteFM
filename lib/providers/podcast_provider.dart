import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/podcast_data.dart';
import '../services/cover_art_service.dart';

enum PodcastState { idle, loading, playing, paused }

class PodcastProvider extends ChangeNotifier {
  PodcastState _state         = PodcastState.idle;
  bool         _isExpanded    = false;
  Show?        _show;
  int          _episodeIndex  = 0;
  Duration     _position      = Duration.zero;
  Duration     _duration      = Duration.zero;
  String?      _episodeCoverUrl;

  late final WebViewController _webCtrl;

  PodcastProvider() {
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'ProgressBridge',
        onMessageReceived: (msg) => _onProgress(msg.message),
      );
  }

  // ── Getters ──────────────────────────────────────────────────────────────────

  WebViewController get webController  => _webCtrl;
  PodcastState      get state          => _state;
  Show?             get show           => _show;
  int               get episodeIndex   => _episodeIndex;
  Episode?          get episode        => _show?.episodes[_episodeIndex];
  bool              get isActive       => _state != PodcastState.idle;
  bool              get isPlaying      => _state == PodcastState.playing;
  bool              get isPaused       => _state == PodcastState.paused;
  bool              get isLoading      => _state == PodcastState.loading;
  bool              get isExpanded     => _isExpanded;
  bool              get hasPrevious    => _episodeIndex > 0;
  bool              get hasNext        =>
      _show != null && _episodeIndex < _show!.episodes.length - 1;

  Duration get position => _position;
  Duration get duration => _duration;

  /// URL de la portada del episodio actual (puede ser null mientras carga).
  String? get episodeCoverUrl => _episodeCoverUrl;

  double get progress => _duration.inMilliseconds > 0
      ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
      : 0.0;

  String get positionText => _formatDuration(_position);
  String get durationText => _formatDuration(_duration);

  String get remainingText {
    if (_duration == Duration.zero) return '';
    final rem = _duration - _position;
    final m   = rem.inMinutes.abs();
    final s   = rem.inSeconds.abs() % 60;
    return '-${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$m:$s';
  }

  // ── JS bridge ────────────────────────────────────────────────────────────────

  void _onProgress(String message) {
    try {
      final data  = jsonDecode(message) as Map<String, dynamic>;
      final posMs = (data['position'] as num?)?.toInt() ?? 0;
      final durMs = (data['duration'] as num?)?.toInt() ?? 0;
      final paused = data['paused'] as bool? ?? true;

      _position = Duration(milliseconds: posMs);
      if (durMs > 0) _duration = Duration(milliseconds: durMs);

      if (_state == PodcastState.loading && durMs > 0) {
        _state = paused ? PodcastState.paused : PodcastState.playing;
        notifyListeners();
      } else if (_state == PodcastState.playing && paused) {
        _state = PodcastState.paused;
        notifyListeners();
      } else if (_state == PodcastState.paused && !paused) {
        _state = PodcastState.playing;
        notifyListeners();
      } else if (_state != PodcastState.loading) {
        notifyListeners();
      }
    } catch (_) {}
  }

  // ── Public API ────────────────────────────────────────────────────────────────

  Future<void> playEpisode(Show show, int index) async {
    _show          = show;
    _episodeIndex  = index;
    _position      = Duration.zero;
    _duration      = Duration.zero;
    _episodeCoverUrl = null;
    _state         = PodcastState.loading;
    _isExpanded    = true;
    notifyListeners();

    final ep       = show.episodes[index];
    final embedUrl = ep.embedUrl;

    // Cargar la portada específica del episodio en background
    CoverArtService.forEpisode(embedUrl).then((url) {
      if (url != null && _show?.id == show.id && _episodeIndex == index) {
        _episodeCoverUrl = url;
        notifyListeners();
      }
    });

    String episodeId = '';
    try {
      final uri = Uri.parse(embedUrl);
      episodeId = uri.pathSegments.last;
      if (episodeId == 'video') {
        episodeId = uri.pathSegments[uri.pathSegments.length - 2];
      }
    } catch (_) {}

    final noAutoplay = Platform.isIOS;

    // El iframe se carga pero permanece invisible — la UI nativa controla todo.
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <style>
        body, html {
          margin: 0; padding: 0;
          width: 100%; height: 100%;
          background-color: #000;
          overflow: hidden;
        }
        /* El iframe ocupa toda la vista para que el IFrame API inicialice
           correctamente. La UI de Flutter lo tapa con una capa opaca. */
        #embed-iframe {
          position: absolute;
          width: 100%; height: 100%;
          border: none;
        }
      </style>
    </head>
    <body>
      <div id="embed-iframe"></div>
      <script src="https://open.spotify.com/embed/iframe-api/v1" async></script>
      <script>
        const _noAutoplay = $noAutoplay;
        window.onSpotifyIframeApiReady = (IFrameAPI) => {
          const element = document.getElementById('embed-iframe');
          const options = {
            width: '100%',
            height: '100%',
            uri: 'spotify:episode:$episodeId'
          };
          const callback = (EmbedController) => {
            window.spotifyCtrl = EmbedController;
            EmbedController.addListener('playback_update', e => {
              ProgressBridge.postMessage(JSON.stringify({
                position: e.data.position,
                duration: e.data.duration,
                paused: e.data.isPaused
              }));
            });
            EmbedController.addListener('ready', () => {
              if (!_noAutoplay) EmbedController.play();
            });
          };
          IFrameAPI.createController(element, options, callback);
        };
        function playPodcast()   { window.spotifyCtrl && window.spotifyCtrl.play(); }
        function resumePodcast() { window.spotifyCtrl && window.spotifyCtrl.resume(); }
        function pausePodcast()  { window.spotifyCtrl && window.spotifyCtrl.pause(); }
        function seekPodcast(ms) { window.spotifyCtrl && window.spotifyCtrl.seek(ms); }
      </script>
    </body>
    </html>
    ''';

    await _webCtrl.loadHtmlString(html);
  }

  void expand() {
    if (!isActive) return;
    _isExpanded = true;
    notifyListeners();
  }

  void collapse() {
    _isExpanded = false;
    notifyListeners();
  }

  Future<void> pause() async {
    await _webCtrl.runJavaScript('pausePodcast()');
  }

  Future<void> resume() async {
    await _webCtrl.runJavaScript('resumePodcast()');
  }

  Future<void> seekTo(Duration position) async {
    await _webCtrl.runJavaScript('seekPodcast(${position.inMilliseconds})');
    _position = position;
    notifyListeners();
  }

  Future<void> play() async {
    await _webCtrl.runJavaScript('playPodcast()');
  }

  void togglePlayPause() {
    if (isPlaying) {
      pause();
    } else if (isLoading) {
      // En iOS el autoplay está bloqueado; el usuario arranca la reproducción
      // manualmente con play() en lugar de resume().
      play();
    } else {
      resume();
    }
  }

  void next() {
    if (hasNext) playEpisode(_show!, _episodeIndex + 1);
  }

  void previous() {
    if (hasPrevious) playEpisode(_show!, _episodeIndex - 1);
  }

  void stop() {
    _webCtrl.loadRequest(Uri.parse('about:blank'));
    _show            = null;
    _state           = PodcastState.idle;
    _isExpanded      = false;
    _position        = Duration.zero;
    _duration        = Duration.zero;
    _episodeCoverUrl = null;
    notifyListeners();
  }
}
