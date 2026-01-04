import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'notifications_service.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService(
    messaging: FirebaseMessaging.instance,
    db: ref.read(firebaseFirestoreProvider), // ✅
    local: FlutterLocalNotificationsPlugin(),
  );
});

final notificationsBootstrapProvider = Provider<NotificationsBootstrap>((ref) {
  ref.keepAlive();
  return NotificationsBootstrap(ref);
});

class NotificationsBootstrap {
  NotificationsBootstrap(this.ref);
  final Ref ref;

  bool _didInit = false;
  String? _uid;

  Future<void> init({
    required String uid,
    required bool isFreelancer,
    OnNotificationTap? onTap,
  }) async {
    if (_didInit && _uid == uid) return;

    _uid = uid;
    _didInit = true;

    await ref.read(notificationsServiceProvider).initForUser(
          uid: uid,
          isFreelancer: isFreelancer,
          onTap: onTap,
        );
  }

  Future<void> reset() async {
    _didInit = false;
    _uid = null;
    await ref.read(notificationsServiceProvider).dispose();
  }
}
