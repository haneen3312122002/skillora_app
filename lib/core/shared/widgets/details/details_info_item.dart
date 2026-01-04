import 'package:flutter/material.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

class DetailsInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget? trailing;

  const DetailsInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: AppSpacing.spaceXS),
                Text(value, style: AppTextStyles.body),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: AppSpacing.spaceSM),
            trailing!,
          ],
        ],
      ),
    );
  }
}
