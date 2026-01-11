import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/modules/users/presentation/widgets/public%20profile/public_role_based_profile_content.dart';

class UserPublicProfileScreen extends StatelessWidget {
  final String uid;

  const UserPublicProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: true,
      title: 'profile_title'.tr(),
      showLogout: false, // ✅ زائر
      actions: const [],
      body: PublicRoleBasedProfileContent(uid: uid),
    );
  }
}
