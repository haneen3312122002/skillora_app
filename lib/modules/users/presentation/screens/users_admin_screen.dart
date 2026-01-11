// lib/modules/users/presentation/screens/users_admin_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/app/routes/app_routes.dart';

import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';

import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';

// ✅ تأكدي إن هذا هو الملف اللي فيه ProfileSectionCard عندك
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';

import '../viewmodels/users_admin_viewmodel.dart';

class UsersAdminScreen extends ConsumerWidget {
  const UsersAdminScreen({super.key});

  Future<void> _runAction(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action, {
    String? successMsg,
  }) async {
    try {
      await action();

      final after = ref.read(usersAdminViewModelProvider);
      if (after.hasError) {
        AppSnackbar.show(
          context,
          after.error.toString(),
          type: SnackbarType.error,
        );
        return;
      }

      if (successMsg != null && context.mounted) {
        AppSnackbar.show(
          context,
          successMsg,
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      AppSnackbar.show(context, e.toString(), type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(usersAdminViewModelProvider);
    final vm = ref.read(usersAdminViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileSectionCard(
          titleKey: 'users_list'.tr(),
          useCard: false,
          actions: [
            _RoleFilterDropdown(
              value: ref.watch(usersRoleFilterProvider),
              onChanged: (v) {
                ref.read(usersRoleFilterProvider.notifier).state = v;
              },
            ),
            IconButton(
              tooltip: 'refresh'.tr(),
              icon: const Icon(Icons.refresh_rounded),
              onPressed: vm.refresh,
            ),
          ],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: asyncUsers.when(
              loading: () => const LoadingIndicator(withBackground: false),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: vm.refresh,
                fullScreen: false,
              ),
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Text(
                      'no_users_found'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return AppInfiniteList(
                  items: users,
                  padding: EdgeInsets.only(
                    top: AppSpacing.spaceSM,
                    bottom: AppSpacing.spaceMD,
                  ),
                  hasMore: false,
                  onLoadMore: () {},
                  onRefresh: vm.refresh,
                  itemBuilder: (context, user, index) {
                    return AppListTile(
                      title: user.name.isEmpty ? '(No name)' : user.name,
                      subtitle:
                          '${user.email}\nrole: ${user.role.name} • disabled: ${user.isDisabled}',
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded),
                        onSelected: (v) async {
                          switch (v) {
                            case 'role_admin':
                              await _runAction(
                                context,
                                ref,
                                () => vm.changeRole(
                                  userId: user.id,
                                  role: UserRole.admin,
                                ),
                                successMsg: 'role_updated'.tr(),
                              );
                              break;

                            case 'role_client':
                              await _runAction(
                                context,
                                ref,
                                () => vm.changeRole(
                                  userId: user.id,
                                  role: UserRole.client,
                                ),
                                successMsg: 'role_updated'.tr(),
                              );
                              break;

                            case 'role_freelancer':
                              await _runAction(
                                context,
                                ref,
                                () => vm.changeRole(
                                  userId: user.id,
                                  role: UserRole.freelancer,
                                ),
                                successMsg: 'role_updated'.tr(),
                              );
                              break;

                            case 'toggle_disabled':
                              await _runAction(
                                context,
                                ref,
                                () => vm.toggleDisabled(
                                  userId: user.id,
                                  isDisabled: !user.isDisabled,
                                ),
                                successMsg: (!user.isDisabled)
                                    ? 'user_disabled'.tr()
                                    : 'user_enabled'.tr(),
                              );
                              break;
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'role_admin',
                            child: Text('Set role: Admin'),
                          ),
                          const PopupMenuItem(
                            value: 'role_client',
                            child: Text('Set role: Client'),
                          ),
                          const PopupMenuItem(
                            value: 'role_freelancer',
                            child: Text('Set role: Freelancer'),
                          ),
                          const PopupMenuDivider(),
                        ],
                      ),
                      onTap: () {
                        debugPrint('.................' + user.id + user.email);
                        context.push(AppRoutes.adminUserProfilePath(user.id));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleFilterDropdown extends StatelessWidget {
  final UserRole? value;
  final ValueChanged<UserRole?> onChanged;

  const _RoleFilterDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<UserRole?>(
        value: value,
        isDense: true,
        items: const [
          DropdownMenuItem(value: null, child: Text('All')),
          DropdownMenuItem(value: UserRole.admin, child: Text('Admin')),
          DropdownMenuItem(value: UserRole.client, child: Text('Client')),
          DropdownMenuItem(
              value: UserRole.freelancer, child: Text('Freelancer')),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
