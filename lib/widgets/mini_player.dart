import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../providers/schedule_provider.dart';
import '../theme/app_theme.dart';

// Mini player shown only for the live radio stream.
class MiniPlayer extends StatefulWidget {
  final bool visible;
  final VoidCallback onNavigateToHome;

  const MiniPlayer({
    super.key,
    required this.visible,
    required this.onNavigateToHome,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioProvider>();

    if (radio.isPlaying && !_pulse.isAnimating) _pulse.repeat();
    if (!radio.isPlaying && _pulse.isAnimating) _pulse.stop();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      height: widget.visible ? 74 : 0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: SizedBox.expand(
        child: _RadioBar(
          radio: radio,
          pulse: _pulse,
          onNavigateToHome: widget.onNavigateToHome,
        ),
      ),
    );
  }
}

// ─── Radio bar ────────────────────────────────────────────────────────────────

class _RadioBar extends StatelessWidget {
  final RadioProvider radio;
  final AnimationController pulse;
  final VoidCallback onNavigateToHome;

  const _RadioBar({
    required this.radio,
    required this.pulse,
    required this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateToHome,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B0000), AppColors.primary],
          ),
          border: Border(
            top: BorderSide(color: Color(0x40FFFFFF), width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              // Icon
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.radio_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Señal en Vivo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      radio.isLoading
                          ? 'Conectando...'
                          : (context.watch<ScheduleProvider>().current?.name
                              ?? 'Uninorte 103.1 FM Estéreo'),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white60,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Play/pause button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    radio.isPlaying || radio.isLoading
                        ? radio.pause()
                        : radio.play(),
                child: _PulseButton(
                  ctrl: pulse,
                  showPulse: radio.isPlaying,
                  child: radio.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Icon(
                          radio.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pulse button ─────────────────────────────────────────────────────────────

class _PulseButton extends StatelessWidget {
  final AnimationController ctrl;
  final bool showPulse;
  final Widget child;

  const _PulseButton({
    required this.ctrl,
    required this.showPulse,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final scale = showPulse
            ? 1.0 + 0.08 * (0.5 - (ctrl.value - 0.5).abs())
            : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}
