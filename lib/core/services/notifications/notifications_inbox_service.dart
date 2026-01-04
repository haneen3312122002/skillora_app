import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/modules/notifications/data/models/app_notification_model.dart';
import 'package:notes_tasks/modules/notifications/domain/entities/app_notification_entity.dart';
import 'package:notes_tasks/modules/notifications/domain/failures/notifications_failure.dart';

class NotificationsInboxService {
  NotificationsInboxService({
    required FirebaseFirestore db,
    required fb.FirebaseAuth auth,
  })  : _db = db,
        _auth = auth;

  final FirebaseFirestore _db;
  final fb.FirebaseAuth _auth;

  fb.User? get _user => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('notifications');

  Stream<List<AppNotificationEntity>> watchMyNotifications() {
    final u = _user;
    if (u == null) return const Stream.empty();

    return _col(u.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(AppNotificationModel.fromDoc).toList());
  }

  Future<void> markRead(String notificationId) async {
    final u = _user;
    if (u == null) throw const NotificationsFailure('auth_required');

    await _col(u.uid).doc(notificationId).set(
      {'read': true},
      SetOptions(merge: true),
    );
  }
}
