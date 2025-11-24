// lib/core/widgets/animation/shake_animation.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset; // shake strength in pixels
  final bool trigger; // when true → run shake once

  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 10,
    required this.trigger,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // run when trigger becomes true
    if (!oldWidget.trigger && widget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value; // 0..1
        // simple shake: amplitude decreases over time
        final dx = (1 - t) * math.sin(t * math.pi * 6) * widget.offset;

        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
    );
  }
}
