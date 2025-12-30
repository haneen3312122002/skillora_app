import 'package:flutter/material.dart';
import '../../constants/spacing.dart';
import '../animation/fade_in.dart';
import '../animation/slide_in.dart';

class AppCard extends StatefulWidget {
  final Widget child;

  /// ❌ لا يوجد padding افتراضي
  /// لو بدك padding مرّريه صراحة من الصفحة
  final EdgeInsetsGeometry? padding;

  final bool animate;
  final Duration animationDuration;
  final Offset slideFrom;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.slideFrom = const Offset(0, 10),
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    final radius = (cardTheme.shape is RoundedRectangleBorder)
        ? (cardTheme.shape as RoundedRectangleBorder).borderRadius
        : BorderRadius.circular(AppSpacing.r(16));

    Widget card = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: cardTheme.margin, // فقط margin من الثيم
        padding: widget.padding, // ✅ null = لا padding
        decoration: BoxDecoration(
          color: cardTheme.color,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color:
                  theme.colorScheme.primary.withOpacity(_hovered ? 0.15 : 0.08),
              blurRadius: _hovered ? 18 : 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: cardTheme.shape is RoundedRectangleBorder
              ? Border.fromBorderSide(
                  (cardTheme.shape as RoundedRectangleBorder).side,
                )
              : null,
        ),
        child: widget.child,
      ),
    );

    if (!widget.animate) return card;

    return FadeIn(
      duration: widget.animationDuration,
      child: SlideIn(
        from: widget.slideFrom,
        duration: widget.animationDuration,
        child: card,
      ),
    );
  }
}
