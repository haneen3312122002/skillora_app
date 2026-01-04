import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/notifications/domain/entities/app_notification_entity.dart';
import 'notifications_usecases_providers.dart';

final notificationsStreamProvider =
    StreamProvider<List<AppNotificationEntity>>((ref) {
  final uc = ref.watch(watchNotificationsUseCaseProvider);
  return uc();
});
