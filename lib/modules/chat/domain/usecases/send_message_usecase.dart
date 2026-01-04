import 'package:notes_tasks/core/services/chat/chat_services.dart';

class SendMessageUseCase {
  final ChatsService _service;
  SendMessageUseCase(this._service);

  Future<void> call({required String chatId, required String text}) {
    return _service.sendMessage(chatId: chatId, text: text);
  }
}
