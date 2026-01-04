import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/services/utils/date_picker_service.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/app_icon_button.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';

import 'package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart';

class ProfileExperienceSection extends StatelessWidget {
  final String title;
  final List<ExperienceEntity> experiences;

  final VoidCallback? onAddExperience;
  final void Function(ExperienceEntity experience)? onEditExperience;

  const ProfileExperienceSection({
    super.key,
    this.title = 'profile_experience_title',
    required this.experiences,
    this.onAddExperience,
    this.onEditExperience,
  });

  String _formatStartDate(BuildContext context, ExperienceEntity exp) {
    return DateFormatUtils.formatYearMonth(
      context,
      exp.startDate,
      fallback: 'experience_start_fallback'.tr(),
    );
  }

  String _formatEndDate(BuildContext context, ExperienceEntity exp) {
    return DateFormatUtils.formatYearMonth(
      context,
      exp.endDate,
      fallback: 'experience_present_label'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    if (onAddExperience != null) {
      actions.add(AppIconButton(icon: Icons.add, onTap: onAddExperience));
    }

    if (experiences.isEmpty) {
      return ProfileSectionCard(
        titleKey: title,
        actions: actions,
        child: Text(
          'profile_experience_empty'.tr(),
          style: AppTextStyles.caption,
        ),
      );
    }

    final theme = Theme.of(context);
    final dotColor = theme.colorScheme.primary;
    final subtleTextColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return ProfileSectionCard(
      titleKey: title,
      useCard: false,
      actions: actions,
      child: Column(
        children: [
          for (var i = 0; i < experiences.length; i++) ...[
            AppListTile(
              animate: false,
              leading: SizedBox(
                width: 2,
                child: Column(
                  children: [
                    AppIconButton(
                      icon: Icons.circle,
                      onTap: null,
                      size: 24,
                      iconSize: 10,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.08),
                      iconColor: dotColor,
                      isCircular: true,
                    ),
                    if (i != experiences.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: dotColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              title: experiences[i].title,
              subtitleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experiences[i].company,
                    style: AppTextStyles.caption,
                  ),
                  if (experiences[i].location.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.spaceXS),
                    Text(
                      experiences[i].location,
                      style: AppTextStyles.caption.copyWith(
                        color: subtleTextColor,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatStartDate(context, experiences[i]),
                      textAlign: TextAlign.right,
                      style: AppTextStyles.caption.copyWith(
                        color: subtleTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatEndDate(context, experiences[i]),
                      textAlign: TextAlign.right,
                      style: AppTextStyles.caption.copyWith(
                        color: subtleTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: onEditExperience == null
                  ? null
                  : () => onEditExperience!(experiences[i]),
            ),
            if (i != experiences.length - 1)
              SizedBox(height: AppSpacing.spaceMD),
          ]
        ],
      ),
    );
  }
}
