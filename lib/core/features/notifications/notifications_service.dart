import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef OnNotificationTap = void Function(Map<String, dynamic> data);

class NotificationsService {
  NotificationsService({
    required FirebaseMessaging messaging,
    required FirebaseFirestore db,
    required FlutterLocalNotificationsPlugin local,
  })  : _messaging = messaging,
        _db = db,
        _local = local;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _db;
  final FlutterLocalNotificationsPlugin _local;

  static const String _channelId = 'jobs_channel';

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    _channelId,
    'Jobs Notifications',
    description: 'Notifications about jobs and chats',
    importance: Importance.high,
  );

  bool _initialized = false;
  StreamSubscription<String>? _tokenSub;
  Future<void> removeCurrentToken(String uid) async {
    final t = await _messaging.getToken();
    if (t == null) return;

    await _db.collection('users').doc(uid).update({
      'fcmTokens': FieldValue.arrayRemove([t]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> initForUser({
    required String uid,
    required bool isFreelancer,
    OnNotificationTap? onTap,
  }) async {
    if (_initialized) return;
    _initialized = true;

    // 1) Permissions
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2) Local notifications init (مرة وحدة فقط)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) {
        final p = resp.payload;
        if (p == null || p.isEmpty) return;

        try {
          final data = Map<String, dynamic>.from(jsonDecode(p));
          onTap?.call(data);
        } catch (_) {}
      },
    );

    // Create channel on Android
    final android = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(_androidChannel);

    // 3) Handle taps from system notifications (FCM)
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      scheduleMicrotask(() {
        onTap?.call(Map<String, dynamic>.from(initial.data));
      });
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      onTap?.call(Map<String, dynamic>.from(msg.data));
    });

    // 4) Foreground messages => show local notification (مع payload)
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      final title = msg.notification?.title ?? 'New notification';
      final body = msg.notification?.body ?? '';

      _showLocal(
        title: title,
        body: body,
        payload: msg.data,
      );
    });

    // 5) Token save + refresh
    await _saveToken(uid);
    _tokenSub = _messaging.onTokenRefresh.listen(
      (t) => _saveToken(uid, token: t),
    );

    // 6) Topics
    if (isFreelancer) {
      await _messaging.subscribeToTopic('freelancers');
    } else {
      await _messaging.unsubscribeFromTopic('freelancers');
    }
  }

  Future<void> dispose() async {
    await _tokenSub?.cancel();
  }

  Future<void> _saveToken(String uid, {String? token}) async {
    final t = token ?? await _messaging.getToken();
    if (t == null) return;

    await _db.collection('users').doc(uid).set({
      'fcmTokens': FieldValue.arrayUnion([t]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _showLocal({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Jobs Notifications',
      channelDescription: 'Notifications about jobs and chats',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload == null ? null : jsonEncode(payload),
    );
  }
}
