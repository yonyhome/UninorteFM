import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/podcast_data.dart';
import '../providers/podcast_provider.dart';
import '../services/cover_art_service.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// MINI BAR
// Aparece encima del bottom nav cuando hay un podcast activo y el panel
// está colapsado.
// ═══════════════════════════════════════════════════════════════════════════════

class PodcastMiniBar extends StatelessWidget {
  const PodcastMiniBar({super.key});

  @override
  Widget build(BuildContext context) {
    final podcast = context.watch<PodcastProvider>();
    final visible = podcast.isActive && !podcast.isExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      height: visible ? 74 : 0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: SizedBox.expand(
        child: _MiniBarContent(podcast: podcast),
      ),
    );
  }
}

class _MiniBarContent extends StatelessWidget {
  final PodcastProvider podcast;
  const _MiniBarContent({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show    = podcast.show;
    final episode = podcast.episode;
    if (show == null || episode == null) return const SizedBox.shrink();

    final accent = show.color;

    return GestureDetector(
      onTap: podcast.expand,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accent.withValues(alpha: 0.4),
              const Color(0xFF0C0C0C),
            ],
          ),
          border: const Border(
            top: BorderSide(color: Color(0x30FFFFFF), width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              // Thumbnail del episodio actual
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: SizedBox(
                  width: 46, height: 46,
                  child: FutureBuilder<String?>(
                    future: CoverArtService.forEpisode(episode.embedUrl),
                    builder: (_, snap) {
                      final url = snap.data ?? podcast.episodeCoverUrl;
                      if (url == null) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accent.withValues(alpha: 0.6),
                                accent.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                          child: Icon(Icons.mic_rounded,
                              color: accent, size: 20),
                        );
                      }
                      return Image.network(
                        url, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: accent.withValues(alpha: 0.3),
                          child: Icon(Icons.mic_rounded,
                              color: accent, size: 20),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      show.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Mini progress
                    if (podcast.progress > 0) ...[
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: podcast.progress,
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.1),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(accent),
                          minHeight: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),

              // Prev
              _MiniIconBtn(
                icon: Icons.skip_previous_rounded,
                enabled: podcast.hasPrevious,
                onTap: podcast.previous,
              ),
              // Play/Pause
              _MiniPlayBtn(podcast: podcast, accent: accent),
              // Next
              _MiniIconBtn(
                icon: Icons.skip_next_rounded,
                enabled: podcast.hasNext,
                onTap: podcast.next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniPlayBtn extends StatelessWidget {
  final PodcastProvider podcast;
  final Color accent;
  const _MiniPlayBtn({required this.podcast, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: podcast.togglePlayPause,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.18),
        ),
        alignment: Alignment.center,
        child: podcast.isLoading
            ? SizedBox(
                width: 15, height: 15,
                child: CircularProgressIndicator(
                    color: accent, strokeWidth: 2),
              )
            : Icon(
                podcast.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 22,
              ),
      ),
    );
  }
}

class _MiniIconBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _MiniIconBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        width: 34, height: 40,
        child: Icon(
          icon,
          color: enabled
              ? Colors.white
              : Colors.white.withValues(alpha: 0.2),
          size: 22,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPANDED PANEL
// El WebView permanece siempre en el árbol (audio continuo) pero queda invisible
// (1×1 px). La UI nativa de Flutter cubre toda la pantalla.
// ═══════════════════════════════════════════════════════════════════════════════

class PodcastExpandedPanel extends StatelessWidget {
  const PodcastExpandedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final podcast = context.watch<PodcastProvider>();
    final mq      = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topPad  = mq.viewPadding.top;
    final panelH  = screenH - topPad;
    final top     = podcast.isExpanded ? topPad : screenH;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
      left: 0, right: 0,
      top: top,
      height: panelH,
      child: Material(
        color: const Color(0xFF080808),
        child: Stack(
          children: [
            // ── WebView a pantalla completa — el IFrame API necesita tamaño ─
            // real para inicializar el controlador de Spotify correctamente.
            Positioned.fill(
              child: WebViewWidget(
                controller: podcast.webController,
              ),
            ),

            // ── Capa opaca que oculta el embed de Spotify al usuario ─────────
            Positioned.fill(
              child: Container(color: const Color(0xFF080808)),
            ),

            // ── UI nativa ────────────────────────────────────────────────────
            Column(
              children: [
                _PanelHeader(podcast: podcast),
                Expanded(child: _PanelBody(podcast: podcast)),
                _PanelControls(podcast: podcast),
                SizedBox(height: mq.viewPadding.bottom + 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  final PodcastProvider podcast;
  const _PanelHeader({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show    = podcast.show;
    final episode = podcast.episode;

    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (d.primaryDelta != null && d.primaryDelta! > 8) {
          podcast.collapse();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0x18FFFFFF), width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Drag handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: podcast.collapse,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white60, size: 30),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          episode?.title ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (show != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            show.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: show.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (show != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: show.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: show.color.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'EP ${podcast.episodeIndex + 1}/${show.episodes.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: show.color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Body — cover art grande + progreso ──────────────────────────────────────

class _PanelBody extends StatelessWidget {
  final PodcastProvider podcast;
  const _PanelBody({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show    = podcast.show;
    final episode = podcast.episode;
    if (show == null || episode == null) return const SizedBox.shrink();

    final accent = show.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 28),

          // ── Cover art grande ──────────────────────────────────────────────
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: _CoverArtWidget(
                  podcast: podcast,
                  episode: episode,
                  show: show,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Título y show ─────────────────────────────────────────────────
          Text(
            episode.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            show.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          const SizedBox(height: 24),

          // ── Barra de progreso con scrubbing ───────────────────────────────
          _ProgressBar(podcast: podcast, accent: accent),
          const SizedBox(height: 8),

          // Tiempos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                podcast.positionText,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                podcast.remainingText,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Cover art animado ────────────────────────────────────────────────────────

class _CoverArtWidget extends StatelessWidget {
  final PodcastProvider podcast;
  final Episode         episode;
  final Show            show;

  const _CoverArtWidget({
    required this.podcast,
    required this.episode,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    final accent = show.color;

    return AnimatedScale(
      scale: podcast.isPlaying ? 1.0 : 0.88,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: podcast.isPlaying ? 0.45 : 0.2),
              blurRadius: podcast.isPlaying ? 40 : 20,
              spreadRadius: podcast.isPlaying ? 4 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: FutureBuilder<String?>(
            future: CoverArtService.forEpisode(episode.embedUrl),
            builder: (_, snap) {
              final url = snap.data ?? podcast.episodeCoverUrl;
              if (url == null) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withValues(alpha: 0.8),
                        accent.withValues(alpha: 0.2),
                        const Color(0xFF111111),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.mic_rounded,
                    color: accent.withValues(alpha: 0.6),
                    size: 64,
                  ),
                );
              }
              return Image.network(
                url,
                fit: BoxFit.cover,
                frameBuilder: (_, child, frame, wasSync) => wasSync
                    ? child
                    : AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: child,
                      ),
                errorBuilder: (_, __, ___) => Container(
                  color: accent.withValues(alpha: 0.3),
                  child: Icon(Icons.mic_rounded,
                      color: accent, size: 64),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Barra de progreso con scrubbing ─────────────────────────────────────────

class _ProgressBar extends StatefulWidget {
  final PodcastProvider podcast;
  final Color           accent;

  const _ProgressBar({required this.podcast, required this.accent});

  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar> {
  double? _draggingValue;

  @override
  Widget build(BuildContext context) {
    final value = _draggingValue ?? widget.podcast.progress;
    final accent = widget.accent;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3.5,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        activeTrackColor: accent,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
        thumbColor: accent,
        overlayColor: accent.withValues(alpha: 0.2),
      ),
      child: Slider(
        value: value.clamp(0.0, 1.0),
        onChanged: (v) => setState(() => _draggingValue = v),
        onChangeEnd: (v) {
          setState(() => _draggingValue = null);
          if (widget.podcast.duration > Duration.zero) {
            final ms = (v * widget.podcast.duration.inMilliseconds).round();
            widget.podcast.seekTo(Duration(milliseconds: ms));
          }
        },
      ),
    );
  }
}

// ─── Panel controls ───────────────────────────────────────────────────────────

class _PanelControls extends StatelessWidget {
  final PodcastProvider podcast;
  const _PanelControls({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show   = podcast.show;
    final accent = show?.color ?? Colors.white;

    return Container(
      height: 100,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x18FFFFFF), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SkipBtn(
            icon: Icons.skip_previous_rounded,
            enabled: podcast.hasPrevious,
            color: accent,
            onTap: podcast.previous,
          ),
          const SizedBox(width: 20),

          // Play / Pause
          GestureDetector(
            onTap: podcast.togglePlayPause,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70, height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: podcast.isLoading
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Icon(
                      podcast.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
            ),
          ),
          const SizedBox(width: 20),

          _SkipBtn(
            icon: Icons.skip_next_rounded,
            enabled: podcast.hasNext,
            color: accent,
            onTap: podcast.next,
          ),
        ],
      ),
    );
  }
}

class _SkipBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  const _SkipBtn({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = enabled ? color : Colors.white.withValues(alpha: 0.2);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 54, height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? color.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: c.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: c, size: 26),
      ),
    );
  }
}
