import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
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

  static const _tabs = [
    HomeScreen(),
    PodcastScreen(),
    ProgramacionScreen(),
    ExplorarScreen(),
    MasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();
    // Mini player is shown on any tab except En Vivo (index 0)
    final showMini = radio.isActive && _currentIndex != 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Mini player slides in from top when active
            MiniPlayer(visible: showMini),
            // Main content — IndexedStack keeps each screen alive
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _tabs,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

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
              _NavItem(icon: _IconLive(), label: 'En Vivo', index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: _IconMic(), label: 'Podcast', index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: _IconCalendar(), label: 'Programación', index: 2, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: _IconCompass(), label: 'Explorar', index: 3, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: _IconDots(), label: 'Más', index: 4, currentIndex: currentIndex, onTap: onTap),
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
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.45,
                duration: const Duration(milliseconds: 180),
                child: icon,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : Colors.white54,
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

// ── Icon widgets (SVG-equivalent custom painters replaced with Icon) ──────────

class _IconLive extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Icon(Icons.radio_rounded, color: Colors.white, size: 22);
}

class _IconMic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Icon(Icons.mic_rounded, color: Colors.white, size: 22);
}

class _IconCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20);
}

class _IconCompass extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Icon(Icons.explore_rounded, color: Colors.white, size: 22);
}

class _IconDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 22);
}
