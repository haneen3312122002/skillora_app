import 'package:flutter/material.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

class DetailsTextBlock extends StatelessWidget {
  final String title;
  final String text;

  const DetailsTextBlock({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppSpacing.spaceSM),
        Text(text, style: AppTextStyles.body),
      ],
    );
  }
}
