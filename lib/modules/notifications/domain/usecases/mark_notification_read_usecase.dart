import 'package:notes_tasks/core/services/notifications/notifications_inbox_service.dart';

class MarkNotificationReadUseCase {
  final NotificationsInboxService _service;
  MarkNotificationReadUseCase(this._service);

  Future<void> call(String notificationId) => _service.markRead(notificationId);
}
