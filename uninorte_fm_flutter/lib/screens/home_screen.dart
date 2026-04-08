import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../providers/podcast_provider.dart';
import '../widgets/audio_visualizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _rippleCtrl;
  late final AnimationController _float1Ctrl;
  late final AnimationController _float2Ctrl;

  @override
  void initState() {
    super.initState();
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _float1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _float2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    _float1Ctrl.dispose();
    _float2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();

    if (radio.isPlaying) {
      if (!_rippleCtrl.isAnimating) _rippleCtrl.repeat();
    } else {
      _rippleCtrl.stop();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC01818), Color(0xFFD42020), Color(0xFFB01010)],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Floating decorative circles
          ..._buildDecorativeCircles(),
          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // "Señal en Vivo" banner
                Image.asset(
                  'assets/images/senal_en_vivo.png',
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text(
                    '¡SEÑAL EN VIVO!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Logo
                Image.asset(
                  'assets/images/logo_icon.png',
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text(
                    'UNINORTE\n103.1 FM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                ),
                const Spacer(),
                // Play button with ripple
                _PlayButton(rippleCtrl: _rippleCtrl),
                const SizedBox(height: 16),
                // Status text
                SizedBox(
                  height: 24,
                  child: _StatusText(state: radio.state),
                ),
                const Spacer(),
                // Slogan
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Text(
                        'MUEVE',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withOpacity(0.22),
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'LA CULTURA',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.22),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Visualizer
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AudioVisualizer(
                    playing: radio.isPlaying,
                    color: Colors.white.withOpacity(0.4),
                    barCount: 48,
                    height: 48,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecorativeCircles() {
    return [
      _FloatingCircle(ctrl: _float1Ctrl, top: 0.08, left: 0.08, size: 64, border: true),
      _FloatingCircle(ctrl: _float2Ctrl, top: 0.06, right: 0.20, size: 12, filled: true, opacity: 0.2),
      _FloatingCircle(ctrl: _float1Ctrl, top: 0.20, right: 0.08, size: 40, border: true, opacity: 0.1),
      _FloatingCircle(ctrl: _float2Ctrl, top: 0.32, left: 0.14, size: 16, border: true, opacity: 0.15),
      _FloatingCircle(ctrl: _float1Ctrl, bottom: 0.32, left: 0.06, size: 56, border: true, opacity: 0.1),
      _FloatingCircle(ctrl: _float2Ctrl, bottom: 0.18, left: 0.30, size: 24, border: true, opacity: 0.15),
    ];
  }
}

class _FloatingCircle extends StatelessWidget {
  final AnimationController ctrl;
  final double? top, bottom, left, right;
  final double size;
  final bool border;
  final bool filled;
  final double opacity;

  const _FloatingCircle({
    required this.ctrl,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    this.border = false,
    this.filled = false,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Use child property to prevent rebuilding the Container on every frame
    final circleContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.white.withOpacity(opacity) : null,
        border: border
            ? Border.all(
                color: Colors.white.withOpacity(opacity),
                width: 1.5,
              )
            : null,
      ),
    );

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, child) {
        final offset = math.sin(ctrl.value * math.pi) * 10;
        return Positioned(
          top: top != null ? sh * top! + offset : null,
          bottom: bottom != null ? sh * bottom! - offset : null,
          left: left != null ? sw * left! : null,
          right: right != null ? sw * right! : null,
          child: child!,
        );
      },
      child: circleContent,
    );
  }
}

class _PlayButton extends StatelessWidget {
  final AnimationController rippleCtrl;

  const _PlayButton({required this.rippleCtrl});

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();

    return GestureDetector(
      onTap: () {
        // Clear any active podcast before starting the radio
        context.read<PodcastProvider>().stop();
        radio.toggle();
      },
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple rings (when playing)
            if (radio.isPlaying) ...[
              _RippleRing(ctrl: rippleCtrl, delay: 0),
              _RippleRing(ctrl: rippleCtrl, delay: 0.33),
            ],
            // Outer ring
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(radio.isPlaying ? 0.25 : 0.18),
                    Colors.white.withOpacity(radio.isPlaying ? 0.08 : 0.05),
                  ],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
              ),
            ),
            // Inner button
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
                border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
              ),
              child: Center(child: _ButtonIcon(state: radio.state)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RippleRing extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;

  const _RippleRing({required this.ctrl, required this.delay});

  @override
  Widget build(BuildContext context) {
    const ringContent = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: SizedBox(width: 176, height: 176),
    );

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, child) {
        final t = (ctrl.value + delay) % 1.0;
        return Transform.scale(
          scale: 1.0 + t * 0.8,
          child: Opacity(
            opacity: 0.1 * (1.0 - t),
            child: child!,
          ),
        );
      },
      child: ringContent,
    );
  }
}

class _ButtonIcon extends StatelessWidget {
  final RadioState state;

  const _ButtonIcon({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RadioState.loading:
        return const SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
        );
      case RadioState.playing:
        return const Icon(Icons.pause_rounded, color: Colors.white, size: 40);
      case RadioState.paused:
        return const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 44);
      case RadioState.error:
        return const Icon(Icons.error_outline_rounded, color: Colors.white, size: 36);
      case RadioState.idle:
        return const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 44);
    }
  }
}

class _StatusText extends StatelessWidget {
  final RadioState state;

  const _StatusText({required this.state});

  @override
  Widget build(BuildContext context) {
    String text = '';
    bool pulse = false;

    switch (state) {
      case RadioState.loading:
        text = 'CONECTANDO…';
        pulse = true;
      case RadioState.playing:
        text = '● EN VIVO';
      case RadioState.paused:
        text = 'Pausado';
      case RadioState.error:
        text = 'Error de conexión. Intenta de nuevo.';
      case RadioState.idle:
        break;
    }

    if (text.isEmpty) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: pulse ? 0.7 : 0.85,
      duration: const Duration(milliseconds: 600),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
