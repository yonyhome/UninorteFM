import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/radio_provider.dart';
import '../providers/podcast_provider.dart';
import '../screens/home_screen.dart';
import '../screens/podcast_screen.dart';
import '../screens/programacion_screen.dart';
import '../screens/explorar_screen.dart';
import '../screens/mas_screen.dart';
import 'mini_player.dart';
import '../theme/app_theme.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  late final PageController _pageCtrl;

  static const _tabs = <Widget>[
    HomeScreen(),
    PodcastScreen(),
    ProgramacionScreen(),
    ExplorarScreen(),
    MasScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();
    final podcast = context.watch<PodcastProvider>();

    // Mini player shows when podcast is active OR radio is active outside Home.
    final showMini =
        podcast.isActive || (radio.isActive && _currentIndex != 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Hidden podcast WebView (always in tree so audio never stops) ──
          // 1×1 keeps the PlatformView initialized; Offstage would destroy it.
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 1,
              height: 1,
              child: WebViewWidget(
                controller: context.read<PodcastProvider>().webController,
              ),
            ),
          ),

          // ── Main page content ──
          SafeArea(
            bottom: false,
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: _tabs.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) => _KeepAlive(child: _tabs[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(
            visible: showMini,
            onNavigateToHome: () => _goTo(0),
          ),
          _BottomNav(currentIndex: _currentIndex, onTap: _goTo),
        ],
      ),
    );
  }
}

// ─── Keep-alive wrapper ───────────────────────────────────────────────────────

class _KeepAlive extends StatefulWidget {
  final Widget child;
  const _KeepAlive({required this.child});

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// ─── Bottom nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(icon: const _IconLive(), label: 'En Vivo', index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: const _IconMic(), label: 'Podcast', index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: const _IconCalendar(), label: 'Programación', index: 2, current: currentIndex, onTap: onTap),
              _NavItem(icon: const _IconCompass(), label: 'Explorar', index: 3, current: currentIndex, onTap: onTap),
              _NavItem(icon: const _IconDots(), label: 'Más', index: 4, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          color: active ? AppColors.primary : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: active ? 1.0 : 0.45,
                duration: const Duration(milliseconds: 180),
                child: icon,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : Colors.white54,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconLive extends StatelessWidget {
  const _IconLive();
  @override
  Widget build(_) => const Icon(Icons.radio_rounded, color: Colors.white, size: 22);
}

class _IconMic extends StatelessWidget {
  const _IconMic();
  @override
  Widget build(_) => const Icon(Icons.mic_rounded, color: Colors.white, size: 22);
}

class _IconCalendar extends StatelessWidget {
  const _IconCalendar();
  @override
  Widget build(_) => const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20);
}

class _IconCompass extends StatelessWidget {
  const _IconCompass();
  @override
  Widget build(_) => const Icon(Icons.explore_rounded, color: Colors.white, size: 22);
}

class _IconDots extends StatelessWidget {
  const _IconDots();
  @override
  Widget build(_) => const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 22);
}
