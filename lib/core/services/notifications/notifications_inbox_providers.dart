import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'notifications_inbox_service.dart';

final notificationsInboxServiceProvider =
    Provider<NotificationsInboxService>((ref) {
  return NotificationsInboxService(
    db: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider) as fb.FirebaseAuth,
  );
});
