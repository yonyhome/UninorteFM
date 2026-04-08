import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/podcast_provider.dart';
import '../models/podcast_data.dart';

void showPodcastPlayer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
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
      initialChildSize: 0.93,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      snap: true,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Consumer<PodcastProvider>(
          builder: (ctx, podcast, __) {
            final show = podcast.show;
            final episode = podcast.episode;
            if (show == null || episode == null) return const SizedBox.shrink();
            return _PlayerBody(
              key: ValueKey('${show.id}-${podcast.episodeIndex}'),
              show: show,
              episode: episode,
              episodeIndex: podcast.episodeIndex,
              hasPrevious: podcast.hasPrevious,
              hasNext: podcast.hasNext,
              onPrevious: podcast.previous,
              onNext: podcast.next,
              onClose: () => Navigator.pop(ctx),
              scrollController: scrollCtrl,
            );
          },
        ),
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _PlayerBody extends StatefulWidget {
  final Show show;
  final Episode episode;
  final int episodeIndex;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onClose;
  final ScrollController scrollController;

  const _PlayerBody({
    super.key,
    required this.show,
    required this.episode,
    required this.episodeIndex,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
    required this.onClose,
    required this.scrollController,
  });

  @override
  State<_PlayerBody> createState() => _PlayerBodyState();
}

class _PlayerBodyState extends State<_PlayerBody> {
  late final WebViewController _webCtrl;

  @override
  void initState() {
    super.initState();
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse(widget.episode.embedUrl));
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final artSize = sw - 48;
    final show = widget.show;

    return ListView(
      controller: widget.scrollController,
      padding: EdgeInsets.zero,
      children: [
        // Drag handle
        const SizedBox(height: 14),
        Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Top bar
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70, size: 30),
              ),
              const Expanded(
                child: Text(
                  'Playing now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.ios_share_rounded,
                    color: Colors.white70, size: 22),
              ),
            ],
          ),
        ),

        // Artwork
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: _Artwork(show: show, episodeIndex: widget.episodeIndex, size: artSize),
        ),

        // Title row
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.episode.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      show.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: show.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: show.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: show.color.withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.mic_rounded, color: show.color, size: 18),
              ),
            ],
          ),
        ),

        // Episode counter
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
          child: Text(
            'Episodio ${widget.episodeIndex + 1} de ${widget.show.episodes.length}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ),

        // Prev / Next controls
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Row(
            children: [
              _ControlBtn(
                icon: Icons.skip_previous_rounded,
                size: 52,
                enabled: widget.hasPrevious,
                color: show.color,
                onTap: widget.onPrevious,
              ),
              const SizedBox(width: 12),
              _ControlBtn(
                icon: Icons.skip_next_rounded,
                size: 52,
                enabled: widget.hasNext,
                color: show.color,
                onTap: widget.onNext,
              ),
              const Spacer(),
              Text(
                '${widget.episodeIndex + 1} / ${widget.show.episodes.length}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ),

        // Spotify embed
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 232,
              child: WebViewWidget(controller: _webCtrl),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Artwork ──────────────────────────────────────────────────────────────────

class _Artwork extends StatelessWidget {
  final Show show;
  final int episodeIndex;
  final double size;

  const _Artwork({required this.show, required this.episodeIndex, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            show.color,
            show.color.withValues(alpha: 0.5),
            Colors.black,
          ],
          stops: const [0, 0.5, 1],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: -24,
            right: -24,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -12,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: show.color.withValues(alpha: 0.2),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mic_rounded, color: Colors.white.withValues(alpha: 0.85), size: 52),
                const SizedBox(height: 8),
                Text(
                  'EP ${episodeIndex + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.65),
                    letterSpacing: 3,
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

// ─── Control button ───────────────────────────────────────────────────────────

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  const _ControlBtn({
    required this.icon,
    required this.size,
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
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: c, size: size * 0.48),
      ),
    );
  }
}
