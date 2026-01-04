import 'package:flutter/material.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_wrap.dart';

class DetailsTagsBlock extends StatelessWidget {
  final String title;
  final List<String> tags;

  const DetailsTagsBlock({
    super.key,
    required this.title,
    required this.tags,
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
        AppTagsWrap(tags: tags),
      ],
    );
  }
}
