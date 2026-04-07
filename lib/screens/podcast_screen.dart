import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/podcast_data.dart';
import '../theme/app_theme.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  int _activeShowIndex = 0;
  // Index of the expanded episode (-1 = none)
  int _expandedEpisode = -1;

  Show get _activeShow => kShows[_activeShowIndex];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
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

        // Category pills
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: kShows.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final show = kShows[i];
              final isActive = i == _activeShowIndex;
              return GestureDetector(
                onTap: () => setState(() {
                  _activeShowIndex = i;
                  _expandedEpisode = -1;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? show.color : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(24),
                    border: isActive
                        ? null
                        : Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Text(
                    show.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 4),
        const Divider(color: Color(0xFF1A1A1A), height: 1),

        // Show info bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _activeShow.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.mic_rounded, color: _activeShow.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeShow.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${_activeShow.episodes.length} episodios',
                      style: TextStyle(
                        fontSize: 12,
                        color: _activeShow.color.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Episode cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: _activeShow.episodes.length,
            itemBuilder: (_, i) {
              return _EpisodeCard(
                episode: _activeShow.episodes[i],
                index: i,
                showColor: _activeShow.color,
                isExpanded: _expandedEpisode == i,
                onTap: () => setState(() {
                  _expandedEpisode = _expandedEpisode == i ? -1 : i;
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EpisodeCard extends StatefulWidget {
  final Episode episode;
  final int index;
  final Color showColor;
  final bool isExpanded;
  final VoidCallback onTap;

  const _EpisodeCard({
    required this.episode,
    required this.index,
    required this.showColor,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<_EpisodeCard> {
  WebViewController? _webCtrl;

  @override
  void didUpdateWidget(_EpisodeCard old) {
    super.didUpdateWidget(old);
    // Lazy-init the WebView only when first expanded
    if (widget.isExpanded && _webCtrl == null) {
      _webCtrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..loadRequest(Uri.parse(widget.episode.embedUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: const Color(0xFF0E0E0E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.showColor.withOpacity(0.16),
            ),
          ),
          child: Column(
            children: [
              // Card header
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Row(
                  children: [
                    // Number badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: widget.showColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: widget.showColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Title
                    Expanded(
                      child: Text(
                        widget.episode.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xE6FFFFFF),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Expand indicator
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: widget.showColor.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              // Spotify embed (lazy loaded)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: widget.isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: _webCtrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                        child: SizedBox(
                          height: 152,
                          child: WebViewWidget(controller: _webCtrl!),
                        ),
                      )
                    : const SizedBox(height: 152),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
