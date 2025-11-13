import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/widgets/app_scaffold.dart';

import 'package:notes_tasks/modules/profile/presentation/widgets/profile_content.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: 'Profile',
      showLogout: true,
      actions: const [],
      body: const ProfileContent(),
    );
  }
}
