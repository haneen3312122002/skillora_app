import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../constants/spacing.dart';
import '../../../app/theme/text_styles.dart';
import '../buttons/primary_button.dart';
import '../animation/fade_in.dart';
import '../animation/slide_in.dart';

class ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final bool fullScreen;

  final bool animate;

  const ErrorView({
    super.key,
    this.message,
    this.onRetry,
    this.fullScreen = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final iconSize = fullScreen ? 80.h : 40.h;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: colors.error,
          size: iconSize,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        Text(
          message ?? 'error_general'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: colors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onRetry != null) ...[
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
            variant: AppButtonVariant.primary,
            label: 'retry'.tr(),
            onPressed: onRetry!,
            icon: Icons.refresh_rounded,
          ),
        ],
      ],
    );

    Widget view = fullScreen
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.screenHorizontal),
              child: content,
            ),
          )
        : Container(
            width: double.infinity,
            margin: EdgeInsets.all(AppSpacing.spaceMD),
            padding: EdgeInsets.all(AppSpacing.spaceMD),
            decoration: BoxDecoration(
              color: colors.errorContainer.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.error.withOpacity(0.4),
              ),
            ),
            child: content,
          );

    if (!animate) return view;

    return FadeIn(
      duration: const Duration(milliseconds: 220),
      child: SlideIn(
        from: const Offset(0, 10),
        duration: const Duration(milliseconds: 220),
        child: view,
      ),
    );
  }
}
