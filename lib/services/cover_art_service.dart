import 'dart:convert';
import 'dart:io';

/// Fetches Spotify podcast show artwork via the public oembed endpoint.
/// Results are cached in memory so each show is only fetched once.
class CoverArtService {
  CoverArtService._();

  // Cache: showId → Future<imageUrl?>
  // Using Future as the value lets multiple concurrent callers share one request.
  static final Map<String, Future<String?>> _cache = {};

  /// Returns the cover art URL for [showId] (derived from its first episode).
  /// Returns null on error or if no image is available.
  static Future<String?> forShow(String showId, String firstEmbedUrl) {
    return _cache.putIfAbsent(showId, () => _fetch(firstEmbedUrl));
  }

  static Future<String?> _fetch(String embedUrl) async {
    try {
      final epId = _episodeId(embedUrl);
      if (epId == null) return null;

      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 8);

      final req = await client.getUrl(Uri.parse(
        'https://open.spotify.com/oembed'
        '?url=https://open.spotify.com/episode/$epId',
      ));
      req.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final res = await req.close();
      if (res.statusCode != 200) return null;

      final body = await res.transform(utf8.decoder).join();
      client.close();

      final data = jsonDecode(body) as Map<String, dynamic>;
      return data['thumbnail_url'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Extracts the Spotify episode ID from an embed URL such as:
  ///   https://open.spotify.com/embed/episode/5mnkdwqeW5BDnSykDOn4KW?...
  static String? _episodeId(String embedUrl) {
    final segs = Uri.parse(embedUrl).pathSegments;
    final idx = segs.indexOf('episode');
    if (idx == -1 || idx + 1 >= segs.length) return null;
    return segs[idx + 1];
  }
}
