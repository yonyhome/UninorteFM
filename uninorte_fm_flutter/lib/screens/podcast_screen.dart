import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/podcast_data.dart';
import '../providers/podcast_provider.dart';
import '../providers/radio_provider.dart';

import '../theme/app_theme.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  int? _filterIndex; // null = "Todos"

  List<Show> get _visibleShows =>
      _filterIndex == null ? kShows : [kShows[_filterIndex!]];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Podcast',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Category chips
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _Chip(
                label: 'Todos',
                isActive: _filterIndex == null,
                color: AppColors.primary,
                onTap: () => setState(() => _filterIndex = null),
              ),
              ...List.generate(
                kShows.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _Chip(
                    label: kShows[i].name,
                    isActive: _filterIndex == i,
                    color: kShows[i].color,
                    onTap: () => setState(() => _filterIndex = i),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Show carousels
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 120),
            itemCount: _visibleShows.length,
            itemBuilder: (_, i) {
              final show = _visibleShows[i];
              return _ShowSection(
                // Key causes cards to re-animate when filter changes
                key: ValueKey('${show.id}-$_filterIndex'),
                show: show,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Category chip ────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? color : const Color(0xFF161616),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isActive ? color : const Color(0xFF2A2A2A),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }
}

// ─── Show section ─────────────────────────────────────────────────────────────

class _ShowSection extends StatelessWidget {
  final Show show;

  const _ShowSection({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: show.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  show.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '${show.episodes.length} ep.',
                style: TextStyle(
                  fontSize: 12,
                  color: show.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Horizontal episode carousel
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: show.episodes.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _EpisodeCard(
                show: show,
                episode: show.episodes[i],
                episodeIndex: i,
                // Stagger delay capped at 6 cards to avoid long waits
                delay: Duration(milliseconds: 50 * i.clamp(0, 6)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Episode card ─────────────────────────────────────────────────────────────

class _EpisodeCard extends StatefulWidget {
  final Show show;
  final Episode episode;
  final int episodeIndex;
  final Duration delay;

  const _EpisodeCard({
    required this.show,
    required this.episode,
    required this.episodeIndex,
    required this.delay,
  });

  @override
  State<_EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<_EpisodeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () {
            // Stop radio if active, then load podcast
            context.read<RadioProvider>().stop();
            context
                .read<PodcastProvider>()
                .playEpisode(widget.show, widget.episodeIndex);
          },
          child: _CardBody(
            show: widget.show,
            episodeIndex: widget.episodeIndex,
            title: widget.episode.title,
          ),
        ),
      ),
    );
  }
}

// ─── Card body ────────────────────────────────────────────────────────────────

class _CardBody extends StatelessWidget {
  final Show show;
  final int episodeIndex;
  final String title;

  const _CardBody({
    required this.show,
    required this.episodeIndex,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Gradient fallback — always visible
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            show.color.withValues(alpha: 0.85),
            show.color.withValues(alpha: 0.3),
            const Color(0xFF080808),
          ],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Real cover art (fetched once per show, cached)
          Positioned.fill(
            child: show.coverUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      show.coverUrl,
                      fit: BoxFit.cover,
                      // Fade in when ready
                      frameBuilder: (_, child, frame, wasSync) {
                        if (wasSync) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Decorative circle (top-right), shown behind image overlay
          Positioned(
            top: -18,
            right: -18,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // EP badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                'EP ${episodeIndex + 1}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),

          // Bottom gradient + title
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 28, 10, 11),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.88),
                  ],
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
