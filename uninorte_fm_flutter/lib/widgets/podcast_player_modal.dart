import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/podcast_provider.dart';
import '../models/podcast_data.dart';

void showPodcastPlayer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    // Pass provider reference — closing the sheet does NOT stop audio.
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<PodcastProvider>(),
      child: const _PlayerSheet(),
    ),
  );
}

// ─── Sheet ────────────────────────────────────────────────────────────────────

class _PlayerSheet extends StatelessWidget {
  const _PlayerSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      snap: true,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF080808),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Consumer<PodcastProvider>(
          builder: (ctx, podcast, __) {
            final show = podcast.show;
            final episode = podcast.episode;
            if (show == null || episode == null) {
              return const SizedBox.shrink();
            }
            return _PlayerContent(
              scrollController: scrollCtrl,
              onClose: () => Navigator.pop(ctx),
            );
          },
        ),
      ),
    );
  }
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _PlayerContent extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onClose;

  const _PlayerContent({
    required this.scrollController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final podcast = context.watch<PodcastProvider>();
    final show = podcast.show!;
    final episode = podcast.episode!;
    final sw = MediaQuery.of(context).size.width;

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        // ── Drag handle ────────────────────────────────────────────────────────
        const SizedBox(height: 14),
        Center(
          child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // ── Top bar ────────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white60, size: 30),
              ),
              const Expanded(
                child: Text(
                  'Reproduciendo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white60,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Episode counter badge
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: show.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: show.color.withValues(alpha: 0.3)),
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

        // ── Artwork ────────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 4, 28, 0),
          child: _Artwork(show: show, size: sw - 56),
        ),

        // ── Title & show ───────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                episode.title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                show.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: show.color,
                ),
              ),
            ],
          ),
        ),

        // ── Progress ───────────────────────────────────────────────────────────
        const SizedBox(height: 28),
        _ProgressSection(podcast: podcast, show: show),

        // ── Controls ───────────────────────────────────────────────────────────
        const SizedBox(height: 28),
        _Controls(podcast: podcast, show: show),

        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── Artwork ──────────────────────────────────────────────────────────────────

class _Artwork extends StatelessWidget {
  final Show show;
  final double size;

  const _Artwork({required this.show, required this.size});

  @override
  Widget build(BuildContext context) {
    final h = size * 0.56;
    final coverUrl = show.coverUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: size, height: h,
        child: coverUrl.isNotEmpty
            ? Image.network(
                coverUrl,
                fit: BoxFit.cover,
                frameBuilder: (_, child, frame, wasSync) {
                  if (wasSync) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
                errorBuilder: (_, __, ___) => _gradientBox(size, h),
              )
            : _gradientBox(size, h),
      ),
    );
  }

  Widget _gradientBox(double w, double h) {
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [show.color, show.color.withValues(alpha: 0.4), Colors.black],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: Center(
        child: Icon(Icons.mic_rounded,
            color: Colors.white.withValues(alpha: 0.5), size: 64),
      ),
    );
  }
}

// ─── Progress section ─────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  final PodcastProvider podcast;
  final Show show;

  const _ProgressSection({required this.podcast, required this.show});

  String _fmt(Duration d) {
    final m = d.inMinutes.abs();
    final s = d.inSeconds.abs() % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = podcast.progress;
    final pos = podcast.position;
    final dur = podcast.duration;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          // Track bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 4,
              child: LayoutBuilder(
                builder: (_, constraints) => Stack(
                  children: [
                    Container(color: Colors.white.withValues(alpha: 0.1)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.linear,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: show.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Time labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmt(pos),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                dur > Duration.zero ? '-${_fmt(dur - pos)}' : '--:--',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Controls ─────────────────────────────────────────────────────────────────

class _Controls extends StatelessWidget {
  final PodcastProvider podcast;
  final Show show;

  const _Controls({required this.podcast, required this.show});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous
        _SkipBtn(
          icon: Icons.skip_previous_rounded,
          enabled: podcast.hasPrevious,
          color: show.color,
          onTap: podcast.previous,
        ),
        const SizedBox(width: 20),

        // Play / Pause (large center button)
        GestureDetector(
          onTap: podcast.togglePlayPause,
          child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: show.color,
              boxShadow: [
                BoxShadow(
                  color: show.color.withValues(alpha: 0.45),
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

        // Next
        _SkipBtn(
          icon: Icons.skip_next_rounded,
          enabled: podcast.hasNext,
          color: show.color,
          onTap: podcast.next,
        ),
      ],
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
          color: enabled ? color.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: c.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: c, size: 26),
      ),
    );
  }
}

