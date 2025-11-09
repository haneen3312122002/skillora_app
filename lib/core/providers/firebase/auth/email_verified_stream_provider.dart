import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/firebase_providers.dart';

final emailVerifiedStreamProvider = StreamProvider<bool>((ref) async* {
  final auth = ref.read(firebaseAuthProvider); // ✅ بدل instance المباشر

  yield auth.currentUser?.emailVerified ?? false;

  final controller = StreamController<bool>();
  final timer = Timer.periodic(const Duration(seconds: 2), (_) async {
    final u = auth.currentUser;
    if (u == null) {
      controller.add(false);
      return;
    }
    try {
      await u.reload(); // تحديث من الخادم
      controller.add(auth.currentUser?.emailVerified ?? false);
    } catch (_) {}
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  yield* controller.stream;
});
