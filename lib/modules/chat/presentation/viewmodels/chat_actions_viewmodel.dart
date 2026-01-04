import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/chat/mappers/chat_failure_mapper.dart';
import 'package:notes_tasks/modules/chat/domain/failures/chat_failure.dart';
import 'package:notes_tasks/modules/chat/presentation/providers/chat_usecases_providers.dart';

final chatActionsViewModelProvider =
    AsyncNotifierProvider<ChatActionsViewModel, void>(ChatActionsViewModel.new);

class ChatActionsViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  /// returns true if sent successfully, false otherwise
  Future<bool> send({required String chatId, required String text}) async {
    if (state.isLoading) return false;

    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      state = AsyncError(
        const ChatFailure('chat_empty_message'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    try {
      final sendUseCase = ref.read(sendMessageUseCaseProvider);
      await sendUseCase(chatId: chatId, text: trimmed);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      final failure = mapChatErrorToFailure(e as Object) ??
          const ChatFailure('something_went_wrong');
      state = AsyncError(failure, st);
      return false;
    }
  }

  /// optional: call this after UI consumes error if you want to clear error state
  void reset() {
    if (state.isLoading) return;
    state = const AsyncData(null);
  }
}
