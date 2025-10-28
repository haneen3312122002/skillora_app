import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:notes_tasks/auth/presentation/providers/get_auth_user_provider.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';

final getAuthUserViewModelProvider =
    AsyncNotifierProvider<GetAuthUserViewModel, UserEntity?>(
      GetAuthUserViewModel.new,
    );

class GetAuthUserViewModel extends AsyncNotifier<UserEntity?> {
  late final GetAuthUserUseCase _getAuthUserUseCase = ref.read(
    getAuthUserUseCaseProvider,
  );

  @override
  FutureOr<UserEntity?> build() async => null;

  Future<void> getAuthUser(String token) async {
    state = const AsyncLoading();
    try {
      final user = await _getAuthUserUseCase.call(token);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearUser() => state = const AsyncData(null);
}
