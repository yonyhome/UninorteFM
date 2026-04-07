import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../theme/app_theme.dart';

/// Animated mini-player that slides down from the top of the screen
/// when audio is active and the user navigates away from the live tab.
class MiniPlayer extends StatelessWidget {
  final bool visible;

  const MiniPlayer({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: visible ? 64 : 0,
      child: visible ? const _MiniPlayerContent() : const SizedBox.shrink(),
    );
  }
}

class _MiniPlayerContent extends StatelessWidget {
  const _MiniPlayerContent();

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB01010), AppColors.primary],
        ),
        border: Border(
          bottom: BorderSide(color: Color(0x1FFFFFFF), width: 1),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Live pulse dot
          _PulseDot(),
          const SizedBox(width: 10),
          // Station info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uninorte 103.1 FM Estéreo',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  radio.isLoading ? 'Conectando…' : 'EN VIVO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white60,
                      ),
                ),
              ],
            ),
          ),
          // Play / pause
          _CircleButton(
            size: 36,
            onTap: () => radio.isPlaying ? radio.stop() : radio.play(),
            child: radio.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.pause_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          // Close
          _CircleButton(
            size: 32,
            background: Colors.transparent,
            onTap: radio.stop,
            child: const Icon(Icons.close_rounded,
                color: Colors.white54, size: 16),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _scale = Tween<double>(begin: 1, end: 2.2)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0.7, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(_opacity.value),
                ),
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
