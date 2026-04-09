import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/podcast_provider.dart';

// ─── Mini bar ─────────────────────────────────────────────────────────────────
// Shown above the bottom nav when a podcast is active and the panel is collapsed.

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
      child: SizedBox(
        height: 74,
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
    final show = podcast.show;
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
              accent.withValues(alpha: 0.45),
              const Color(0xFF0E0E0E),
            ],
          ),
          border: const Border(
            top: BorderSide(color: Color(0x40FFFFFF), width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              // Show color dot / artwork indicator
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: accent.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Icon(Icons.mic_rounded, color: accent, size: 22),
              ),
              const SizedBox(width: 12),

              // Episode info
              Expanded(
                child: Center(
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
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Prev
              _MiniIconBtn(
                icon: Icons.skip_previous_rounded,
                enabled: podcast.hasPrevious,
                onTap: podcast.previous,
              ),

              // Play / Pause
              _MiniActionBtn(podcast: podcast, accent: accent),

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

class _MiniActionBtn extends StatelessWidget {
  final PodcastProvider podcast;
  final Color accent;
  const _MiniActionBtn({required this.podcast, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: podcast.togglePlayPause,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.15),
        ),
        alignment: Alignment.center,
        child: podcast.isLoading
            ? SizedBox(
                width: 16, height: 16,
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
        width: 36, height: 42,
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

// ─── Expanded panel ───────────────────────────────────────────────────────────
// Always in the widget tree (AnimatedPositioned off-screen when collapsed)
// so the WebView PlatformView is never destroyed — audio keeps playing.

class PodcastExpandedPanel extends StatelessWidget {
  const PodcastExpandedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final podcast = context.watch<PodcastProvider>();
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topPad = mq.viewPadding.top;
    final panelH = screenH - topPad;

    // When collapsed: slide the whole panel below the screen.
    // The WebView is still in the tree → audio continues.
    final top = podcast.isExpanded ? topPad : screenH;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      top: top,
      height: panelH,
      child: Material(
        color: const Color(0xFF080808),
        child: Column(
          children: [
            // ── Drag handle + header ─────────────────────────────────────────
            _PanelHeader(podcast: podcast),

            // ── Spotify WebView (fills remaining space) ──────────────────────
            Expanded(
              child: WebViewWidget(
                controller: podcast.webController,
              ),
            ),

            // ── Controls ─────────────────────────────────────────────────────
            _PanelControls(podcast: podcast),

            SizedBox(height: mq.viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}

// ─── Panel header ─────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  final PodcastProvider podcast;
  const _PanelHeader({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show = podcast.show;
    final episode = podcast.episode;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x18FFFFFF), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title row
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: podcast.collapse,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
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
                // Episode counter badge
                if (show != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
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
    );
  }
}

// ─── Panel controls ───────────────────────────────────────────────────────────

class _PanelControls extends StatelessWidget {
  final PodcastProvider podcast;
  const _PanelControls({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show = podcast.show;
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
          // Previous
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
            child: Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.4),
                    blurRadius: 20,
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

          // Next
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
