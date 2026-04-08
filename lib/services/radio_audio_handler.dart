import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// HTTP because the server's TLS cert is not trusted by Android's CA store.
// cleartext is scoped only to this domain via network_security_config.xml.
const _streamUrl = 'http://cactus2.uninorte.edu.co/;stream.mp3';

class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    mediaItem.add(const MediaItem(
      id: _streamUrl,
      title: 'Señal en Vivo',
      artist: 'Uninorte 103.1 FM Estéreo',
      album: 'Mueve la Cultura',
    ));

    // Bridge just_audio events → audio_service playback state.
    // handleError swallows stream-level errors (e.g. ExoPlayer source errors)
    // so they don't become unhandled exceptions that crash the app.
    _player.playbackEventStream
        .handleError((_, __) {})
        .map(_transformEvent)
        .pipe(playbackState);
  }

  AudioPlayer get player => _player;

  @override
  Future<void> play() async {
    // Use Uri.replace to safely append the cache-busting param so the
    // semicolon in the path is never re-parsed by Uri.parse.
    final base = Uri.parse(_streamUrl);
    final uri = base.replace(
      queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()},
    );
    // Let exceptions propagate — RadioProvider.play() catches them and sets
    // RadioState.error so the UI can show a useful message.
    await _player.setAudioSource(AudioSource.uri(uri));
    await _player.play();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    await _player.stop();
    await super.stop();
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
