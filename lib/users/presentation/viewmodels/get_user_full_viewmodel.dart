import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/presentation/providers/get_user_full_provider.dart';

final getUserFullViewModelProvider =
    AsyncNotifierProvider<GetUserFullViewModel, UserEntity?>(
      GetUserFullViewModel.new,
    );

class GetUserFullViewModel extends AsyncNotifier<UserEntity?> {
  late final _useCase = ref.read(getUserFullUseCaseProvider);

  @override
  FutureOr<UserEntity?> build() async => null;

  Future<void> getUserFull(int id) async {
    state = const AsyncLoading();
    try {
      final user = await _useCase.call(id);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearUser() => state = const AsyncData(null);
}
