import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../providers/podcast_provider.dart';
import '../theme/app_theme.dart';
import 'podcast_player_modal.dart';

class MiniPlayer extends StatefulWidget {
  final bool visible;
  final VoidCallback onNavigateToHome;

  const MiniPlayer({
    super.key,
    required this.visible,
    required this.onNavigateToHome,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();
    final podcast = context.watch<PodcastProvider>();

    final isPlaying = podcast.isPlaying || radio.isPlaying;
    if (isPlaying && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!isPlaying && _pulse.isAnimating) {
      _pulse.stop();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      height: widget.visible ? 74 : 0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: SizedBox(
        height: 74,
        child: _Bar(
          radio: radio,
          podcast: podcast,
          pulse: _pulse,
          onNavigateToHome: widget.onNavigateToHome,
        ),
      ),
    );
  }
}

// ─── Bar ──────────────────────────────────────────────────────────────────────

class _Bar extends StatelessWidget {
  final RadioProvider radio;
  final PodcastProvider podcast;
  final AnimationController pulse;
  final VoidCallback onNavigateToHome;

  const _Bar({
    required this.radio,
    required this.podcast,
    required this.pulse,
    required this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    // Podcast takes priority over radio in the single mini player.
    final isPodcast = podcast.isActive;

    final Color accent = isPodcast ? podcast.show!.color : AppColors.primary;

    final List<Color> bg = isPodcast
        ? [accent.withValues(alpha: 0.35), const Color(0xFF0E0E0E)]
        : [const Color(0xFF8B0000), AppColors.primary];

    // ── What the body tap does ──
    final VoidCallback onTap = isPodcast
        ? () => showPodcastPlayer(context)
        : onNavigateToHome;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: bg),
          border: const Border(
            top: BorderSide(color: Color(0x40FFFFFF), width: 0.5),
          ),
        ),
        child: Column(
          children: [
            // ── Main row ──────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    // Artwork
                    _Artwork(isPodcast: isPodcast, podcast: podcast, accent: accent),
                    const SizedBox(width: 12),

                    // Info
                    Expanded(
                      child: _Info(isPodcast: isPodcast, radio: radio, podcast: podcast, accent: accent),
                    ),
                    const SizedBox(width: 8),

                    // Action button — absorbs tap so bar tap doesn't fire
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onAction(radio, podcast),
                      child: _PulseButton(
                        ctrl: pulse,
                        showPulse: isPodcast ? podcast.isPlaying : radio.isPlaying,
                        accent: accent,
                        child: _actionIcon(radio, podcast),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Progress bar (podcast only) ───────────────────────────────────
            if (isPodcast)
              _ProgressBar(podcast: podcast, accent: accent),
          ],
        ),
      ),
    );
  }

  void _onAction(RadioProvider radio, PodcastProvider podcast) {
    if (podcast.isActive) {
      podcast.togglePlayPause();
    } else if (radio.isPlaying || radio.isLoading) {
      radio.pause();
    } else {
      radio.play();
    }
  }

  Widget _actionIcon(RadioProvider radio, PodcastProvider podcast) {
    if (podcast.isActive) {
      if (podcast.isLoading) {
        return const SizedBox(
          width: 16, height: 16,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        );
      }
      return Icon(
        podcast.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Colors.white, size: 22,
      );
    }
    if (radio.isLoading) {
      return const SizedBox(
        width: 16, height: 16,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    }
    return Icon(
      radio.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      color: Colors.white, size: 22,
    );
  }
}

// ─── Artwork ──────────────────────────────────────────────────────────────────

class _Artwork extends StatelessWidget {
  final bool isPodcast;
  final PodcastProvider podcast;
  final Color accent;

  const _Artwork({
    required this.isPodcast,
    required this.podcast,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPodcast) {
      return Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.radio_rounded, color: Colors.white, size: 22),
      );
    }

    final show = podcast.show!;
    final coverUrl = show.coverUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 46, height: 46,
        child: coverUrl.isNotEmpty
            ? Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(show, accent),
              )
            : _fallback(show, accent),
      ),
    );
  }

  Widget _fallback(show, Color accent) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accent, accent.withValues(alpha: 0.4)],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${podcast.episodeIndex + 1}',
          style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white,
          ),
        ),
      );
}

// ─── Info column ──────────────────────────────────────────────────────────────

class _Info extends StatelessWidget {
  final bool isPodcast;
  final RadioProvider radio;
  final PodcastProvider podcast;
  final Color accent;

  const _Info({
    required this.isPodcast,
    required this.radio,
    required this.podcast,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final String title = isPodcast
        ? (podcast.episode?.title ?? '')
        : 'Señal en Vivo';

    final String subtitle = isPodcast
        ? podcast.show!.name
        : (radio.isLoading ? 'Conectando...' : 'Uninorte 103.1 FM Estéreo');

    final String? timeText =
        isPodcast && podcast.remainingText.isNotEmpty ? podcast.remainingText : null;

    return Center(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isPodcast ? accent : Colors.white60,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (timeText != null) ...[
              const SizedBox(width: 6),
              Text(
                timeText,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ],
      ),
    );
  }
}

// ─── Progress bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final PodcastProvider podcast;
  final Color accent;

  const _ProgressBar({required this.podcast, required this.accent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: LayoutBuilder(
        builder: (_, constraints) => Stack(
          children: [
            Container(color: Colors.white.withValues(alpha: 0.08)),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.linear,
              width: constraints.maxWidth * podcast.progress,
              color: accent,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pulse button ─────────────────────────────────────────────────────────────

class _PulseButton extends StatelessWidget {
  final AnimationController ctrl;
  final bool showPulse;
  final Color accent;
  final Widget child;

  const _PulseButton({
    required this.ctrl,
    required this.showPulse,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48, height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showPulse) ...[
            _Ring(ctrl: ctrl, phase: 0.0, accent: accent),
            _Ring(ctrl: ctrl, phase: 0.5, accent: accent),
          ],
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.2),
              border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.5),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  final AnimationController ctrl;
  final double phase;
  final Color accent;

  const _Ring({required this.ctrl, required this.phase, required this.accent});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = (ctrl.value + phase) % 1.0;
        return Transform.scale(
          scale: 1.0 + t * 0.65,
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.25 * (1.0 - t)),
            ),
          ),
        );
      },
    );
  }
}
