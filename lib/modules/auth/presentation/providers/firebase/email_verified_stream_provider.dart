import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

final emailVerifiedStreamProvider = StreamProvider<bool>((ref) async* {
  final auth = fb.FirebaseAuth.instance;

  // Emit initial value quickly
  yield auth.currentUser?.emailVerified ?? false;

  // Poll every 2 seconds; stop when provider is disposed.
  final controller = StreamController<bool>();
  final timer = Timer.periodic(const Duration(seconds: 2), (_) async {
    final u = auth.currentUser;
    if (u == null) {
      controller.add(false);
      return;
    }
    try {
      await u.reload();
      controller.add(auth.currentUser?.emailVerified ?? false);
    } catch (_) {
      // ignore errors and keep polling
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  yield* controller.stream;
});
