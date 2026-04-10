import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/podcast_data.dart';
import '../providers/podcast_provider.dart';
import '../providers/radio_provider.dart';
import '../services/cover_art_service.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// PODCAST SCREEN — Grid de categorías
// ═══════════════════════════════════════════════════════════════════════════════

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Container(
                width: 4, height: 24,
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
              const Spacer(),
              Text(
                '${kShows.length} shows',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Text(
            'Elige un programa para explorar sus episodios',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // ── Lista de shows (una por fila) ────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            itemCount: kShows.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ShowCard(show: kShows[i]),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tarjeta de show ──────────────────────────────────────────────────────────

class _ShowCard extends StatefulWidget {
  final Show show;
  const _ShowCard({required this.show});

  @override
  State<_ShowCard> createState() => _ShowCardState();
}

class _ShowCardState extends State<_ShowCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_)  => _ctrl.reverse();
  void _onTapUp(_)    => _ctrl.forward();
  void _onTapCancel() => _ctrl.forward();

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => ShowDetailScreen(show: widget.show),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final show = widget.show;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => _openDetail(context),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF111111),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              // Barra de color izquierda
              Container(width: 4, color: show.color),

              // Thumbnail cuadrado
              SizedBox(
                width: 110,
                height: 110,
                child: FutureBuilder<String?>(
                  future: CoverArtService.forShow(
                    show.id,
                    show.episodes.first.embedUrl,
                  ),
                  builder: (_, snap) {
                    final url = snap.data;
                    if (url == null) {
                      return Container(
                        color: show.color.withValues(alpha: 0.18),
                        child: Icon(Icons.mic_rounded,
                            color: show.color, size: 32),
                      );
                    }
                    return Image.network(
                      url,
                      fit: BoxFit.cover,
                      frameBuilder: (_, child, frame, wasSync) => wasSync
                          ? child
                          : AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 350),
                              child: child,
                            ),
                      errorBuilder: (_, __, ___) => Container(
                        color: show.color.withValues(alpha: 0.18),
                        child: Icon(Icons.mic_rounded,
                            color: show.color, size: 32),
                      ),
                    );
                  },
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        show.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      if (show.description.isNotEmpty)
                        Text(
                          show.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.5),
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: show.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: show.color.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              '${show.episodes.length} episodios',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: show.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Flecha derecha
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.25),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHOW DETAIL SCREEN — Lista de episodios
// ═══════════════════════════════════════════════════════════════════════════════

class ShowDetailScreen extends StatelessWidget {
  final Show show;
  const ShowDetailScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    final mq      = MediaQuery.of(context);
    final podcast = context.watch<PodcastProvider>();
    final isThisShow = podcast.show?.id == show.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Header colapsable ──────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _ShowHero(show: show),
                ),
              ),

              // ── Cabecera del show ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: show.color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            show.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      if (show.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          show.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.55),
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _InfoChip(
                            label: '${show.episodes.length} episodios',
                            color: show.color,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            label: 'Spotify',
                            icon: Icons.headphones_rounded,
                            color: const Color(0xFF1DB954),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Divider(color: Colors.white.withValues(alpha: 0.08)),
                    ],
                  ),
                ),
              ),

              // ── Lista de episodios ─────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  16, 0, 16, 120 + mq.viewPadding.bottom),
                sliver: SliverList.builder(
                  itemCount: show.episodes.length,
                  itemBuilder: (_, i) {
                    final ep         = show.episodes[i];
                    final isPlaying  = isThisShow &&
                        podcast.episodeIndex == i &&
                        podcast.isPlaying;
                    final isCurrent  = isThisShow &&
                        podcast.episodeIndex == i &&
                        podcast.isActive;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _EpisodeRow(
                        show:      show,
                        episode:   ep,
                        index:     i,
                        isPlaying: isPlaying,
                        isCurrent: isCurrent,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Hero de portada ──────────────────────────────────────────────────────────

class _ShowHero extends StatelessWidget {
  final Show show;
  const _ShowHero({required this.show});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen de fondo
        FutureBuilder<String?>(
          future: CoverArtService.forShow(
            show.id, show.episodes.first.embedUrl),
          builder: (_, snap) {
            final url = snap.data;
            if (url == null) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      show.color.withValues(alpha: 0.8),
                      const Color(0xFF080808),
                    ],
                  ),
                ),
              );
            }
            return Image.network(
              url, fit: BoxFit.cover,
              frameBuilder: (_, child, frame, wasSync) => wasSync
                  ? child
                  : AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      child: child,
                    ),
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            );
          },
        ),
        // Gradiente inferior
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                  AppColors.background,
                ],
                stops: const [0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),
        // Borde inferior de color
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 2,
            color: show.color.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

// ─── Info chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _InfoChip({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 11),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Fila de episodio ─────────────────────────────────────────────────────────

class _EpisodeRow extends StatelessWidget {
  final Show    show;
  final Episode episode;
  final int     index;
  final bool    isPlaying;
  final bool    isCurrent;

  const _EpisodeRow({
    required this.show,
    required this.episode,
    required this.index,
    required this.isPlaying,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final accent = show.color;

    return GestureDetector(
      onTap: () {
        final podcastProv = context.read<PodcastProvider>();
        if (isCurrent) {
          // Episodio ya cargado — solo toggle play/pause, sin reiniciar
          podcastProv.togglePlayPause();
        } else {
          context.read<RadioProvider>().stop();
          podcastProv.playEpisode(show, index);
          Navigator.of(context).pop();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isCurrent
              ? accent.withValues(alpha: 0.10)
              : const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCurrent
                ? accent.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.06),
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail del episodio
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 58, height: 58,
                  child: FutureBuilder<String?>(
                    future: CoverArtService.forEpisode(episode.embedUrl),
                    builder: (_, snap) {
                      final url = snap.data;
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
                          child: Icon(
                            Icons.mic_rounded,
                            color: accent.withValues(alpha: 0.8),
                            size: 22,
                          ),
                        );
                      }
                      return Image.network(
                        url, fit: BoxFit.cover,
                        frameBuilder: (_, child, frame, wasSync) => wasSync
                            ? child
                            : AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(milliseconds: 400),
                                child: child,
                              ),
                        errorBuilder: (_, __, ___) => Container(
                          color: accent.withValues(alpha: 0.2),
                          child: Icon(Icons.mic_rounded,
                              color: accent, size: 22),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Número + título
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'EP ${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      episode.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isCurrent ? Colors.white : Colors.white,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (episode.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        episode.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Botón play / pause
              _EpisodePlayBtn(
                accent: accent,
                isPlaying: isPlaying,
                isCurrent: isCurrent,
                show: show,
                index: index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Botón de play del episodio ───────────────────────────────────────────────

class _EpisodePlayBtn extends StatelessWidget {
  final Color accent;
  final bool  isPlaying;
  final bool  isCurrent;
  final Show  show;
  final int   index;

  const _EpisodePlayBtn({
    required this.accent,
    required this.isPlaying,
    required this.isCurrent,
    required this.show,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final podcastProv = context.read<PodcastProvider>();
        if (isCurrent) {
          podcastProv.togglePlayPause();
        } else {
          context.read<RadioProvider>().stop();
          podcastProv.playEpisode(show, index);
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrent
              ? accent
              : accent.withValues(alpha: 0.15),
          boxShadow: isCurrent
              ? [BoxShadow(
                  color: accent.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                )]
              : null,
        ),
        child: Icon(
          isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: isCurrent ? Colors.white : accent,
          size: 22,
        ),
      ),
    );
  }
}
