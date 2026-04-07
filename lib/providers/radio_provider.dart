import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../services/radio_audio_handler.dart';

enum RadioState { idle, loading, playing, error }

class RadioProvider extends ChangeNotifier {
  final RadioAudioHandler _handler;

  RadioState _state = RadioState.idle;
  // Prevents false error/idle events caused by user-initiated stop
  bool _isUserStopped = false;

  RadioState get state => _state;
  bool get isPlaying => _state == RadioState.playing;
  bool get isLoading => _state == RadioState.loading;
  bool get isError => _state == RadioState.error;
  bool get isActive => _state == RadioState.playing || _state == RadioState.loading;

  RadioProvider(this._handler) {
    _handler.playbackState.stream.listen(_onPlaybackState);
    _handler.player.processingStateStream.listen(_onProcessingState);
  }

  void _onPlaybackState(PlaybackState state) {
    if (_isUserStopped) return;
    if (state.playing) {
      _setState(RadioState.playing);
    }
    // Don't react to idle events here — stop() already sets idle explicitly.
    // Reacting to idle would cause a race where delayed stop-events override
    // the loading state right after the user taps play again.
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
      // Ignore errors caused by a user-initiated stop interrupting the play
      if (!_isUserStopped) {
        _setState(RadioState.error);
        Future.delayed(const Duration(seconds: 3), () {
          if (_state == RadioState.error) _setState(RadioState.idle);
        });
      }
    }
  }

  Future<void> stop() async {
    _isUserStopped = true;
    await _handler.stop();
    _setState(RadioState.idle);
  }

  void toggle() {
    if (isActive) {
      stop();
    } else {
      play();
    }
  }
}
