import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_notification_model.dart';
import '../entities/app_notification_entity.dart';

final watchNotificationsUseCaseProvider =
    Provider<WatchNotificationsUseCase>((ref) {
  return WatchNotificationsUseCase(
    db: FirebaseFirestore.instance,
    auth: fb.FirebaseAuth.instance,
  );
});

class WatchNotificationsUseCase {
  WatchNotificationsUseCase({required this.db, required this.auth});

  final FirebaseFirestore db;
  final fb.FirebaseAuth auth;

  Stream<List<AppNotificationEntity>> call() {
    final u = auth.currentUser;
    if (u == null) return const Stream.empty();

    return db
        .collection('users')
        .doc(u.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
            (s) => s.docs.map((d) => AppNotificationModel.fromDoc(d)).toList());
  }
}
