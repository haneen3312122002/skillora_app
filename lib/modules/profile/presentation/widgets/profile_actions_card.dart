import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/widgets/app_card.dart';
import 'package:notes_tasks/core/widgets/app_list_tile.dart';
import 'package:notes_tasks/core/widgets/app_dialog.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UpdateEmailViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UpdateNameViewModel.dart';

import 'edit_field_dialog_content.dart';

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
            onTap: () => _showEditNameDialog(context, ref),
          ),
          const Divider(),
          AppListTile(
            leading: const Icon(Icons.email),
            title: 'Edit email',
            subtitle: profile['email'] ?? '',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditEmailDialog(context, ref),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: profile['name']);

    AppDialog.show(
      context: context,
      title: 'Edit name',
      content: EditFieldDialogContent(
        controller: controller,
        label: 'Name',
        onSave: (value) async {
          await ref
              .read(updateNameViewModelProvider.notifier)
              .submit(context, rawName: value);
        },
      ),
    );
  }

  void _showEditEmailDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: profile['email']);

    AppDialog.show(
      context: context,
      title: 'Edit email',
      content: EditFieldDialogContent(
        controller: controller,
        label: 'Email',
        keyboardType: TextInputType.emailAddress,
        onSave: (value) async {
          await ref
              .read(updateEmailViewModelProvider.notifier)
              .submit(context, rawEmail: value);
        },
      ),
    );
  }
}
