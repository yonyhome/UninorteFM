import 'package:flutter/foundation.dart';
import '../models/podcast_data.dart';

class PodcastProvider extends ChangeNotifier {
  Show? _show;
  int _episodeIndex = 0;

  Show? get show => _show;
  int get episodeIndex => _episodeIndex;
  Episode? get episode => _show?.episodes[_episodeIndex];
  bool get isActive => _show != null;
  bool get hasPrevious => _episodeIndex > 0;
  bool get hasNext =>
      _show != null && _episodeIndex < _show!.episodes.length - 1;

  void playEpisode(Show show, int index) {
    _show = show;
    _episodeIndex = index;
    notifyListeners();
  }

  void next() {
    if (hasNext) {
      _episodeIndex++;
      notifyListeners();
    }
  }

  void previous() {
    if (hasPrevious) {
      _episodeIndex--;
      notifyListeners();
    }
  }

  void clear() {
    _show = null;
    notifyListeners();
  }
}
