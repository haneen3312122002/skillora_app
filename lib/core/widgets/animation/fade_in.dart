import 'package:flutter/material.dart';

class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double begin;
  final double end;

  const FadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final totalMs = duration.inMilliseconds + delay.inMilliseconds;
    final totalDuration = Duration(milliseconds: totalMs == 0 ? 1 : totalMs);
    final delayFraction = totalMs == 0 ? 0.0 : delay.inMilliseconds / totalMs;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: totalDuration,
      curve: curve,
      child: child,
      builder: (context, t, child) {
        double animT;
        if (t <= delayFraction) {
          animT = 0;
        } else {
          final progress = (t - delayFraction) / (1 - delayFraction);
          animT = progress.clamp(0.0, 1.0);
        }

        final opacity = begin + (end - begin) * animT;

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }
}
