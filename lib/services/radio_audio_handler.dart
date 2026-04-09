import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// The CA certificate for this host is bundled in
// android/app/src/main/res/raw/uninorte_ca.crt and trusted via
// android/app/src/main/res/xml/network_security_config.xml.
const _streamUrl = 'https://cactus2.uninorte.edu.co/;stream.mp3';

class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    mediaItem.add(const MediaItem(
      id: _streamUrl,
      title: 'Señal en Vivo',
      artist: 'Uninorte 103.1 FM Estéreo',
      album: 'Mueve la Cultura',
    ));

    _player.playbackEventStream
        .handleError((_, __) {})
        .map(_transformEvent)
        .pipe(playbackState);
  }

  AudioPlayer get player => _player;

  @override
  Future<void> play() async {
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(_streamUrl),
        tag: mediaItem.value,
      ),
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
