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
    // Load the stream URL directly. Streams don't need cache-busting, 
    // and appending query parameters to Shoutcast URLs can cause 404/400 errors.
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(_streamUrl),
        tag: mediaItem.value,
      )
    );
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
