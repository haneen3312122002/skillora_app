// ===============================
// email_verified_usecase.dart
// modules/auth/domain/usecases/watch_email_verified_usecase.dart
// ===============================
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/auth/services/auth_service.dart';

final watchEmailVerifiedUseCaseProvider =
    Provider<WatchEmailVerifiedUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  final auth = ref.read(firebaseAuthProvider);
  return WatchEmailVerifiedUseCase(
    authService: authService,
    firebaseAuth: auth,
  );
});

class WatchEmailVerifiedUseCase {
  final AuthService _authService;
  final dynamic _firebaseAuth; // FirebaseAuth
  WatchEmailVerifiedUseCase({
    required AuthService authService,
    required dynamic firebaseAuth,
  })  : _authService = authService,
        _firebaseAuth = firebaseAuth;

  Stream<bool> call({Duration interval = const Duration(seconds: 2)}) async* {
    yield _firebaseAuth.currentUser?.emailVerified ?? false;

    final controller = StreamController<bool>();

    final timer = Timer.periodic(interval, (_) async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        controller.add(false);
        return;
      }

      try {
        await _authService
            .reloadCurrentUser()
            .timeout(const Duration(seconds: 10));
        controller.add(_firebaseAuth.currentUser?.emailVerified ?? false);
      } catch (_) {
        // keep stream alive
      }
    });

    controller.onCancel = () {
      timer.cancel();
      controller.close();
    };

    yield* controller.stream;
  }
}
