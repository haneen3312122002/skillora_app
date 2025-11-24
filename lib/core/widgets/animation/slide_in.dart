import 'package:flutter/material.dart';

class SlideIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset from; // in pixels (x, y)

  const SlideIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.from = const Offset(0, 30),
  });

  @override
  Widget build(BuildContext context) {
    final totalMs = duration.inMilliseconds + delay.inMilliseconds;
    final totalDuration = Duration(milliseconds: totalMs == 0 ? 1 : totalMs);
    final delayFraction = totalMs == 0 ? 0.0 : delay.inMilliseconds / totalMs;

    return TweenAnimationBuilder<double>(
      // animate a value from 0 → 1
      tween: Tween(begin: 0.0, end: 1.0),
      duration: totalDuration,
      curve: curve,
      child: child,
      builder: (context, t, child) {
        // t = 0..1 across (delay + animation)
        double animT;
        if (t <= delayFraction) {
          animT = 0; // still in delay → no movement yet
        } else {
          final progress = (t - delayFraction) / (1 - delayFraction);
          animT = progress.clamp(0.0, 1.0);
        }

        final dx = from.dx * (1 - animT);
        final dy = from.dy * (1 - animT);

        return Transform.translate(
          offset: Offset(dx, dy),
          child: child,
        );
      },
    );
  }
}
