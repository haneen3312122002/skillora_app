import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/text_styles.dart';
import 'animation/fade_in.dart';
import 'animation/slide_in.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;

  final bool animate;
  final Duration animationDuration;
  final Offset slideFrom;
  final Duration? delay;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 220),
    this.slideFrom = const Offset(0, 8),
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = ElevatedButton(
      style: theme.elevatedButtonTheme.style,
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              height: 22.h,
              width: 22.h,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon),
                  SizedBox(width: 8.w),
                ],
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
    );

    if (!animate) return button;

    return FadeIn(
      duration: animationDuration,
      child: SlideIn(
        from: slideFrom,
        duration: animationDuration,
        child: button,
      ),
    );
  }
}
