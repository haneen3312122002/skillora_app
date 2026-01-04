import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/role_based/role_based_profile_content.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      scrollable: true,
      title: 'profile_title'.tr(),
      showLogout: true,
      actions: const [],
      body: const RoleBasedProfileContent(),
    );
  }
}
