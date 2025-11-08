// modules/auth/presentation/viewmodels/firebase/register_viewmodel.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:notes_tasks/core/services/firebase/firebase_providers.dart';

final registerViewModelProvider =
    AsyncNotifierProvider<RegisterViewModel, fb.User?>(RegisterViewModel.new);

class RegisterViewModel extends AsyncNotifier<fb.User?> {
  @override
  FutureOr<fb.User?> build() async => null;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // ✅ امنع تكرار الضغط أثناء التحميل
    if (state.isLoading) {
      debugPrint('[RegisterVM] Ignored duplicate register() while loading');
      return;
    }

    debugPrint('[RegisterVM] Start register: email=$email');

    // ✅ استخدم guard عشان أي خطأ يتحوّل AsyncError تلقائيًا
    state = const AsyncLoading();
    state = await AsyncValue.guard<fb.User?>(() async {
      final auth = ref.read(authServiceProvider);

      // (اختياري) مهلة أمان لو الخدمة علّقت
      final cred = await auth
          .register(name: name, email: email, password: password)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException('register() timed out after 20s');
      });

      final user = cred.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      debugPrint('[RegisterVM] register() completed, user=${user?.uid}');

      return user;
    });
  }
}
