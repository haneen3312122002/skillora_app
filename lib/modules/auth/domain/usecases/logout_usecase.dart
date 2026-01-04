import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/auth/auth_service.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  return LogoutUseCase(authService);
});

class LogoutUseCase {
  final AuthService _authService;
  LogoutUseCase(this._authService);

  Future<void> call() async {
    try {
      await _authService.logout().timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw const AuthFailure('request_timeout');
    } catch (_) {
      throw const AuthFailure('something_went_wrong');
    }
  }
}
