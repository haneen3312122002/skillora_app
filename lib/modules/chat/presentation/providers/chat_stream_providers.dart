import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/chat/domain/entities/chat_entity.dart';
import 'package:notes_tasks/modules/chat/domain/entities/message_entity.dart';
import 'package:notes_tasks/modules/chat/presentation/providers/chat_usecases_providers.dart';

final myChatsStreamProvider = StreamProvider<List<ChatEntity>>((ref) {
  return ref.watch(watchMyChatsUseCaseProvider)();
});

final chatMessagesStreamProvider =
    StreamProvider.family<List<MessageEntity>, String>((ref, chatId) {
  return ref.watch(watchMessagesUseCaseProvider)(chatId);
});
