import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../providers/podcast_provider.dart';
import '../theme/app_theme.dart';
import 'podcast_player_modal.dart';

class MiniPlayer extends StatelessWidget {
  final bool visible;
  final VoidCallback onNavigateToHome;

  const MiniPlayer({
    super.key,
    required this.visible,
    required this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      height: visible ? 72 : 0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: SizedBox(
        height: 72,
        child: _MiniPlayerContent(onNavigateToHome: onNavigateToHome),
      ),
    );
  }
}

class _MiniPlayerContent extends StatelessWidget {
  final VoidCallback onNavigateToHome;

  const _MiniPlayerContent({required this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    final podcast = context.watch<PodcastProvider>();
    if (podcast.isActive) {
      return _PodcastMini(podcast: podcast);
    }
    final radio = context.watch<RadioProvider>();
    return _RadioMini(radio: radio, onNavigateToHome: onNavigateToHome);
  }
}

// ─── Radio mini ───────────────────────────────────────────────────────────────

class _RadioMini extends StatelessWidget {
  final RadioProvider radio;
  final VoidCallback onNavigateToHome;

  const _RadioMini({required this.radio, required this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateToHome,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B0000), AppColors.primary],
          ),
          border: Border(
            top: BorderSide(color: Color(0x40FFFFFF), width: 0.5),
            bottom: BorderSide(color: Color(0x1AFFFFFF), width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Artwork
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.radio_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Señal en Vivo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    radio.isLoading ? 'Conectando...' : 'Uninorte 103.1 FM Estéreo',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Play/stop button
            _CircleButton(
              size: 38,
              onTap: () => radio.isPlaying ? radio.stop() : radio.play(),
              child: radio.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Icon(
                      radio.isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Podcast mini ─────────────────────────────────────────────────────────────

class _PodcastMini extends StatelessWidget {
  final PodcastProvider podcast;

  const _PodcastMini({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final show = podcast.show!;
    final episode = podcast.episode!;
    final epIndex = podcast.episodeIndex;

    return GestureDetector(
      onTap: () => showPodcastPlayer(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              show.color.withValues(alpha: 0.35),
              const Color(0xFF111111),
            ],
          ),
          border: const Border(
            top: BorderSide(color: Color(0x40FFFFFF), width: 0.5),
            bottom: BorderSide(color: Color(0x1AFFFFFF), width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Episode artwork
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [show.color, show.color.withValues(alpha: 0.5)],
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: Text(
                '${epIndex + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    show.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: show.color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Open full player
            _CircleButton(
              size: 38,
              onTap: () => showPodcastPlayer(context),
              child: const Icon(Icons.keyboard_arrow_up_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 8),
            // Close
            _CircleButton(
              size: 32,
              background: Colors.transparent,
              onTap: () => context.read<PodcastProvider>().clear(),
              child: const Icon(Icons.close_rounded, color: Colors.white54, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared button ────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;
  final Widget child;
  final Color background;

  const _CircleButton({
    required this.size,
    required this.onTap,
    required this.child,
    this.background = const Color(0x33FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: background),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
