import 'package:flutter/material.dart';

/// Animated equalizer bars — active when [playing] is true.
class AudioVisualizer extends StatefulWidget {
  final bool playing;
  final Color color;
  final int barCount;
  final double height;

  const AudioVisualizer({
    super.key,
    required this.playing,
    this.color = Colors.white,
    this.barCount = 32,
    this.height = 48,
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  // Static base heights for idle state
  static const _baseHeights = [8.0, 14.0, 22.0, 18.0, 30.0, 16.0, 24.0, 12.0, 28.0, 20.0];
  // Animation durations per pattern (mirrors CSS bar1–bar5)
  static const _durations = [900, 1100, 800, 1300, 1000];
  // Max heights per pattern
  static const _maxHeights = [32.0, 8.0, 40.0, 8.0, 36.0];
  static const _minHeights = [8.0, 20.0, 12.0, 28.0, 16.0];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _durations[i]),
      ),
    );
    _animations = List.generate(
      5,
      (i) => Tween<double>(begin: _minHeights[i], end: _maxHeights[i])
          .animate(CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut)),
    );
    if (widget.playing) _startAll();
  }

  void _startAll() {
    for (var c in _controllers) {
      c.repeat(reverse: true);
    }
  }

  void _stopAll() {
    for (var c in _controllers) {
      c.stop();
    }
  }

  @override
  void didUpdateWidget(AudioVisualizer old) {
    super.didUpdateWidget(old);
    if (widget.playing != old.playing) {
      if (widget.playing) {
        _startAll();
      } else {
        _stopAll();
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(widget.barCount, (i) {
          final pattern = i % 5;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: widget.playing
                ? AnimatedBuilder(
                    animation: _animations[pattern],
                    builder: (_, __) => _Bar(
                      height: _animations[pattern].value,
                      color: widget.color,
                    ),
                  )
                : _Bar(
                    height: _baseHeights[i % 10],
                    color: widget.color,
                  ),
          );
        }),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;

  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
      ),
    );
  }
}
