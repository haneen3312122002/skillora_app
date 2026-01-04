import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/notifications/domain/failures/notifications_failure.dart';
import 'package:notes_tasks/modules/notifications/presentation/providers/notifications_usecases_providers.dart';

final notificationsActionsViewModelProvider =
    AsyncNotifierProvider<NotificationsActionsViewModel, void>(
  NotificationsActionsViewModel.new,
);

class NotificationsActionsViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> markAsRead(String id) async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    try {
      final uc = ref.read(markNotificationReadUseCaseProvider);
      await uc(id);
      state = const AsyncData(null);
    } on NotificationsFailure catch (f, st) {
      state = AsyncError(f, st);
    } catch (_, st) {
      state =
          AsyncError(const NotificationsFailure('something_went_wrong'), st);
    }
  }
}
