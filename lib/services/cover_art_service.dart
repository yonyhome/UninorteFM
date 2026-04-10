import 'dart:convert';
import 'dart:io';

/// Fetches Spotify podcast artwork via the public oembed endpoint.
/// Two caches:
///   - [_showCache]    showId → Future<imageUrl?>   (portada del show)
///   - [_episodeCache] episodeId → Future<imageUrl?> (portada específica del episodio)
class CoverArtService {
  CoverArtService._();

  static final Map<String, Future<String?>> _showCache    = {};
  static final Map<String, Future<String?>> _episodeCache = {};

  // ── Show cover (uses first episode to derive show art) ──────────────────────
  static Future<String?> forShow(String showId, String firstEmbedUrl) {
    return _showCache.putIfAbsent(showId, () => _fetch(firstEmbedUrl));
  }

  // ── Per-episode cover art ───────────────────────────────────────────────────
  /// Returns the thumbnail specific to this [embedUrl].
  /// Cache key is the episode ID extracted from the URL.
  static Future<String?> forEpisode(String embedUrl) {
    final epId = _episodeId(embedUrl);
    if (epId == null) return Future.value(null);
    return _episodeCache.putIfAbsent(epId, () => _fetch(embedUrl));
  }

  // ── Internal ────────────────────────────────────────────────────────────────
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

  static String? _episodeId(String embedUrl) {
    final segs = Uri.parse(embedUrl).pathSegments;
    final idx  = segs.indexOf('episode');
    if (idx == -1 || idx + 1 >= segs.length) return null;
    return segs[idx + 1];
  }
}
