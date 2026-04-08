import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/podcast_data.dart';

enum PodcastState { idle, loading, playing, paused }

class PodcastProvider extends ChangeNotifier {
  PodcastState _state = PodcastState.idle;
  Show? _show;
  int _episodeIndex = 0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late final WebViewController _webCtrl;

  PodcastProvider() {
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'ProgressBridge',
        onMessageReceived: (msg) => _onProgress(msg.message),
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => _injectPolling(),
      ));
  }

  // ── Getters ──────────────────────────────────────────────────────────────────

  WebViewController get webController => _webCtrl;
  PodcastState get state => _state;
  Show? get show => _show;
  int get episodeIndex => _episodeIndex;
  Episode? get episode => _show?.episodes[_episodeIndex];
  bool get isActive => _state != PodcastState.idle;
  bool get isPlaying => _state == PodcastState.playing;
  bool get isPaused => _state == PodcastState.paused;
  bool get isLoading => _state == PodcastState.loading;
  bool get hasPrevious => _episodeIndex > 0;
  bool get hasNext =>
      _show != null && _episodeIndex < _show!.episodes.length - 1;

  Duration get position => _position;
  Duration get duration => _duration;

  double get progress => _duration.inMilliseconds > 0
      ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
      : 0.0;

  String get remainingText {
    if (_duration == Duration.zero) return '';
    final rem = _duration - _position;
    final m = rem.inMinutes.abs();
    final s = rem.inSeconds.abs() % 60;
    return '-${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── JS bridge ────────────────────────────────────────────────────────────────

  void _injectPolling() {
    _webCtrl.runJavaScript(r'''
      (function() {
        var interval = setInterval(function() {
          var a = document.querySelector('audio');
          if (a) {
            ProgressBridge.postMessage(JSON.stringify({
              position: Math.floor(a.currentTime * 1000),
              duration: isNaN(a.duration) ? 0 : Math.floor(a.duration * 1000),
              paused: a.paused,
              ended: a.ended
            }));
          }
        }, 800);
      })();
    ''');
  }

  void _onProgress(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      final posMs = (data['position'] as num?)?.toInt() ?? 0;
      final durMs = (data['duration'] as num?)?.toInt() ?? 0;
      final paused = data['paused'] as bool? ?? true;

      _position = Duration(milliseconds: posMs);
      if (durMs > 0) _duration = Duration(milliseconds: durMs);

      if (_state == PodcastState.loading && durMs > 0) {
        _state = paused ? PodcastState.paused : PodcastState.playing;
        notifyListeners();
      } else if (_state == PodcastState.playing && paused) {
        // Don't auto-flip to paused — user may not have paused yet (buffering)
        notifyListeners();
      } else if (_state != PodcastState.loading) {
        notifyListeners();
      }
    } catch (_) {}
  }

  // ── Public API ────────────────────────────────────────────────────────────────

  Future<void> playEpisode(Show show, int index) async {
    _show = show;
    _episodeIndex = index;
    _position = Duration.zero;
    _duration = Duration.zero;
    _state = PodcastState.loading;
    notifyListeners();

    final base = show.episodes[index].embedUrl;
    final uri = Uri.parse(base);
    final autoUri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        'autoplay': '1',
      },
    );
    await _webCtrl.loadRequest(autoUri);
  }

  Future<void> pause() async {
    await _webCtrl.runJavaScript("document.querySelector('audio')?.pause()");
    _state = PodcastState.paused;
    notifyListeners();
  }

  Future<void> resume() async {
    await _webCtrl.runJavaScript("document.querySelector('audio')?.play()");
    _state = PodcastState.playing;
    notifyListeners();
  }

  void togglePlayPause() {
    if (isPlaying) {
      pause();
    } else if (isPaused) {
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
    _show = null;
    _state = PodcastState.idle;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();
  }
}
