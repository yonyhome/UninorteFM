import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../services/radio_audio_handler.dart';

enum RadioState { idle, loading, playing, paused, error }

class RadioProvider extends ChangeNotifier {
  final RadioAudioHandler _handler;

  RadioState _state = RadioState.idle;
  bool _isUserStopped = false;

  RadioState get state => _state;
  bool get isPlaying => _state == RadioState.playing;
  bool get isLoading => _state == RadioState.loading;
  bool get isPaused => _state == RadioState.paused;
  bool get isError => _state == RadioState.error;

  /// True while audio is playing, loading, or paused (keeps mini player alive).
  bool get isActive =>
      _state == RadioState.playing ||
      _state == RadioState.loading ||
      _state == RadioState.paused;

  RadioProvider(this._handler) {
    _handler.playbackState.stream.listen(_onPlaybackState);
    _handler.player.processingStateStream.listen(_onProcessingState);
  }

  void _onPlaybackState(PlaybackState state) {
    if (_isUserStopped) return;
    if (state.playing) {
      _setState(RadioState.playing);
    }
    // Idle/stop events are driven by explicit pause()/stop() calls only.
  }

  void _onProcessingState(ProcessingState ps) {
    if (_isUserStopped) return;
    if (ps == ProcessingState.loading || ps == ProcessingState.buffering) {
      _setState(RadioState.loading);
    } else if (ps == ProcessingState.ready && _handler.player.playing) {
      _setState(RadioState.playing);
    }
  }

  void _setState(RadioState s) {
    if (_state == s) return;
    _state = s;
    notifyListeners();
  }

  Future<void> play() async {
    _isUserStopped = false;
    _setState(RadioState.loading);
    try {
      await _handler.play();
    } catch (_) {
      if (!_isUserStopped) {
        _setState(RadioState.error);
        Future.delayed(const Duration(seconds: 3), () {
          if (_state == RadioState.error) _setState(RadioState.idle);
        });
      }
    }
  }

  /// Pauses the stream but keeps the mini player alive (state → paused).
  Future<void> pause() async {
    _isUserStopped = true;
    await _handler.stop();
    _setState(RadioState.paused);
  }

  /// Fully stops the stream and hides the mini player (state → idle).
  Future<void> stop() async {
    _isUserStopped = true;
    await _handler.stop();
    _setState(RadioState.idle);
  }

  void toggle() {
    if (isPlaying || isLoading) {
      pause();
    } else {
      play();
    }
  }
}
