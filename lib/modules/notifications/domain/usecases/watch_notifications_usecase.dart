import 'package:notes_tasks/core/services/notifications/notifications_inbox_service.dart';
import 'package:notes_tasks/modules/notifications/domain/entities/app_notification_entity.dart';

class WatchNotificationsUseCase {
  final NotificationsInboxService _service;
  WatchNotificationsUseCase(this._service);

  Stream<List<AppNotificationEntity>> call() => _service.watchMyNotifications();
}
