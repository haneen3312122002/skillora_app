import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/register_usecase.dart';

final registerViewModelProvider =
    AsyncNotifierProvider<RegisterViewModel, void>(RegisterViewModel.new);

class RegisterViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async => null;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      final registerUseCase = ref.read(firebaseRegisterUseCaseProvider);
      await registerUseCase(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
        role: role,
      );

      state = const AsyncData(null);
    } catch (e, st) {
      final failure = (e is AuthFailure)
          ? e
          : const AuthFailure('registration_failed'); // ✅ general
      state = AsyncError(failure, st);
    }
  }
}
