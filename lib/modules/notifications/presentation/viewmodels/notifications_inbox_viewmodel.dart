import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_notification_entity.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/watch_notifications_usecase.dart';

final notificationsInboxViewModelProvider =
    StreamProvider<List<AppNotificationEntity>>((ref) {
  return ref.watch(watchNotificationsUseCaseProvider).call();
});

final markNotificationReadControllerProvider =
    Provider<MarkNotificationReadController>((ref) {
  return MarkNotificationReadController(ref);
});

class MarkNotificationReadController {
  MarkNotificationReadController(this.ref);
  final Ref ref;

  Future<void> markAsRead(String id) {
    return ref.read(markNotificationReadUseCaseProvider).call(id);
  }
}
