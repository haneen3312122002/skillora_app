import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/chat/chat_provider.dart';
import 'package:notes_tasks/modules/chat/domain/usecases/send_message_usecase.dart';
import 'package:notes_tasks/modules/chat/domain/usecases/watch_messages_usecase.dart';
import 'package:notes_tasks/modules/chat/domain/usecases/watch_my_chats_usecase.dart';

final watchMyChatsUseCaseProvider = Provider<WatchMyChatsUseCase>((ref) {
  return WatchMyChatsUseCase(ref.watch(chatsServiceProvider));
});

final watchMessagesUseCaseProvider = Provider<WatchMessagesUseCase>((ref) {
  return WatchMessagesUseCase(ref.watch(chatsServiceProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(chatsServiceProvider));
});
