import 'package:notes_tasks/core/services/chat/chat_services.dart';
import 'package:notes_tasks/modules/chat/domain/entities/chat_entity.dart';

class WatchMyChatsUseCase {
  final ChatsService _service;
  WatchMyChatsUseCase(this._service);

  Stream<List<ChatEntity>> call() => _service.watchMyChats();
}
