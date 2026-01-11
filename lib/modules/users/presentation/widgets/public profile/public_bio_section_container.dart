import 'package:flutter/material.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/bio/bio_section.dart';

class PublicBioSectionContainer extends StatelessWidget {
  final ProfileEntity profile;

  const PublicBioSectionContainer({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return BioSection(
      canEdit: false,
      titleKey: 'profile_bio',
      bio: profile.bio,
      emptyHintKey: 'bio_empty_hint',
      isEditing: false,
      isSaving: false,
      onEdit: () {},
      onCancel: () {},
      onChanged: (_) {},
      onSave: () async {},
    );
  }
}
