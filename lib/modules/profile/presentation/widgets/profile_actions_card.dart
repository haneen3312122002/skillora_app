import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/widgets/app_card.dart';
import 'package:notes_tasks/core/widgets/app_list_tile.dart';

import 'package:notes_tasks/modules/profile/services/photo_services.dart';

class ProfileActionsCard extends ConsumerWidget {
  final Map<String, dynamic> profile;

  const ProfileActionsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        children: [
          AppListTile(
            leading: const Icon(Icons.person),
            title: 'Edit name',
            subtitle: profile['name'] ?? '',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showEditNameDialog(context, ref, profile),
          ),
          const Divider(),
          AppListTile(
            leading: const Icon(Icons.email),
            title: 'Edit email',
            subtitle: profile['email'] ?? '',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showEditEmailDialog(context, ref, profile),
          ),
        ],
      ),
    );
  }
}
