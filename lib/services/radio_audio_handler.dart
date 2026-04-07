import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

const _streamUrl = 'https://cactus2.uninorte.edu.co/;stream.mp3';

/// Handles background audio playback, lock screen controls,
/// and notification integration via audio_service.
class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    mediaItem.add(const MediaItem(
      id: _streamUrl,
      title: 'Señal en Vivo',
      artist: 'Uninorte 103.1 FM Estéreo',
      album: 'Mueve la Cultura',
    ));

    // Bridge just_audio events to audio_service playback state
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  Stream<AudioPlayer> get playerStream => Stream.value(_player);
  AudioPlayer get player => _player;

  @override
  Future<void> play() async {
    try {
      final cacheBusted =
          '$_streamUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      await _player.setAudioSource(AudioSource.uri(Uri.parse(cacheBusted)));
      await _player.play();
    } catch (_) {
      // Errors surface via playbackState stream
    }
  }

  @override
  Future<void> pause() async {
    await _player.stop();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    // _player.stop() already emits an idle PlaybackEvent through
    // playbackEventStream, which the pipe forwards to playbackState via
    // _transformEvent. No manual add() needed — and it would conflict
    // with the active addStream() pipe anyway.
  }

  @override
  Future<void> onTaskRemoved() async {
    await _player.stop();
    await super.stop(); // Proper cleanup when app is swiped from recents
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
    );
  }
}
