import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/text_styles.dart';
import '../animation/fade_in.dart';
import '../animation/slide_in.dart';

enum AppButtonVariant {
  primary,
  outlined,
}

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;

  final AppButtonVariant variant;

  final bool animate;
  final Duration animationDuration;
  final Offset slideFrom;
  final Duration? delay;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.variant,
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
    final colors = theme.colorScheme;

    final bool isOutlined = variant == AppButtonVariant.outlined;

    final BorderSide border = BorderSide(
      color: colors.primary,
      width: 1.5,
    );

    final Color contentColor = isOutlined ? colors.primary : colors.onPrimary;

    final Widget content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              height: 22.h,
              width: 22.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(contentColor),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20.sp, color: contentColor),
                  SizedBox(width: 8.w),
                ],
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: contentColor,
                  ),
                ),
              ],
            ),
    );

    Widget button = SizedBox(
      width: double.infinity,
      height: 46.h,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: border,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),

                // ✅ FORCE "empty" button (no fill in any page/theme)
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,

                // ✅ text/icon color
                foregroundColor: colors.primary,

                // ✅ prevent any pressed/hover fill
                overlayColor: Colors.transparent,

                // optional: keep padding consistent with ElevatedButton
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: content,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: theme.elevatedButtonTheme.style?.copyWith(
                elevation: WidgetStateProperty.all(2),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
              child: content,
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
