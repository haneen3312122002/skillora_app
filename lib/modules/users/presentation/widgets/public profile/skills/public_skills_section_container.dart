import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

class PublicSkillsSectionContainer extends StatelessWidget {
  final ProfileEntity profile;

  const PublicSkillsSectionContainer({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final skills = profile.skills;

    return ProfileSectionCard(
      titleKey: 'profile_skills', // تأكدي عندك key
      useCard: false,
      actions: const [], // ✅ no edit
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
        child: skills.isEmpty
            ? Text('no_skills_yet'.tr())
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in skills)
                    Chip(
                      label: Text(s),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
      ),
    );
  }
}
