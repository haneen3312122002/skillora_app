import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/notifications/notifications_inbox_providers.dart';
import 'package:notes_tasks/modules/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:notes_tasks/modules/notifications/domain/usecases/watch_notifications_usecase.dart';

final watchNotificationsUseCaseProvider =
    Provider<WatchNotificationsUseCase>((ref) {
  return WatchNotificationsUseCase(ref.read(notificationsInboxServiceProvider));
});

final markNotificationReadUseCaseProvider =
    Provider<MarkNotificationReadUseCase>((ref) {
  return MarkNotificationReadUseCase(
      ref.read(notificationsInboxServiceProvider));
});
