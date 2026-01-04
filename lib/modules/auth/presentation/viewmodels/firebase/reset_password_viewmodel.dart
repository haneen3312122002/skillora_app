import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/send_reset_password_email_usecase.dart';

final resetPasswordViewModelProvider =
    AsyncNotifierProvider<ResetPasswordViewModel, void>(
  ResetPasswordViewModel.new,
);

class ResetPasswordViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> sendResetEmail({required String email}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    final usecase = ref.read(sendResetPasswordEmailUseCaseProvider);

    try {
      await usecase(email: email.trim());
      state = const AsyncData(null);
    } catch (e, st) {
      // 🔐 Security: don't reveal whether the email exists or not
      // Still consider it "sent" from the UI perspective.
      state = const AsyncData(null);

      // (optional) لو بدك logging داخلي فقط، بدون ما تطلعيه للمستخدم
      // ignore: unused_local_variable
      final _ = (e, st);
    }
  }
}
