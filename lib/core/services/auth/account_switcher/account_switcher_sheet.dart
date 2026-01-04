import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';

import 'saved_accounts_provider.dart';

class AccountSwitcherSheet extends ConsumerWidget {
  const AccountSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(savedAccountsProvider);
    final auth = ref.read(authServiceProvider);

    final currentEmail = auth.auth.currentUser?.email; // ✅ لإخفاء الحساب الحالي

    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Switch account',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: AppSpacing.spaceSM),
          async.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: $e'),
            ),
            data: (accounts) {
              // ✅ لا تعرضي الحساب الحالي ضمن السويتش (اختياري لكنه أفضل UX)
              final filtered = accounts.where((a) {
                if (currentEmail == null) return true;
                return a.email.toLowerCase() != currentEmail.toLowerCase();
              }).toList();

              if (filtered.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceMD),
                  child: const Text('No other saved accounts yet'),
                );
              }

              return Column(
                children: filtered.map((a) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: AppSpacing.spaceSM),
          AppCard(
            animate: false,
            child: AppListTile(
              leading: const Icon(Icons.logout),
              title: 'Log out',
              subtitle: 'Sign out from this device',
              onTap: () async {
                if (!context.mounted) return;

                context.pop();

                await auth.logout();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  context.go(AppRoutes.login);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
