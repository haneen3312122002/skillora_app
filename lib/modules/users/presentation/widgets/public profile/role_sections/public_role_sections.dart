import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

import 'public_admin_sections.dart';
import 'public_client_sections.dart';
import 'public_freelancer_sections.dart';

class PublicRoleSections extends StatelessWidget {
  final String uid;
  final ProfileEntity profile;

  const PublicRoleSections({
    super.key,
    required this.uid,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    switch (profile.role) {
      case UserRole.client:
        return PublicClientSections(uid: uid, profile: profile);
      case UserRole.admin:
        return PublicAdminSections(uid: uid, profile: profile);
      case UserRole.freelancer:
      default:
        return PublicFreelancerSections(uid: uid, profile: profile);
    }
  }
}
