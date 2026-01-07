import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';

import '../../data/models/app_user_model.dart';
import '../providers/users_usecases_providers.dart';

final usersRoleFilterProvider = StateProvider<UserRole?>((ref) => null);

final usersAdminViewModelProvider =
    AsyncNotifierProvider<UsersAdminViewModel, List<AppUserModel>>(
  UsersAdminViewModel.new,
);

class UsersAdminViewModel extends AsyncNotifier<List<AppUserModel>> {
  @override
  FutureOr<List<AppUserModel>> build() async {
    final role = ref.watch(usersRoleFilterProvider);
    final getUsers = ref.watch(getUsersUseCaseProvider);
    return getUsers(role: role);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => await build());
  }

  Future<void> changeRole({
    required String userId,
    required UserRole role,
  }) async {
    final setRole = ref.read(setUserRoleUseCaseProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await setRole(userId: userId, role: role);
      return await build();
    });
  }

  Future<void> toggleDisabled({
    required String userId,
    required bool isDisabled,
  }) async {
    final setDisabled = ref.read(setUserDisabledUseCaseProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await setDisabled(userId: userId, isDisabled: isDisabled);
      return await build();
    });
  }
}
