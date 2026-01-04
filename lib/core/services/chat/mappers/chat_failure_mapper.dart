import 'package:notes_tasks/modules/chat/domain/failures/chat_failure.dart';
import 'package:notes_tasks/core/services/chat/errors/chat_service_exception.dart';

ChatFailure mapChatErrorToFailure(Object error) {
  if (error is ChatFailure) return error;

  if (error is ChatServiceException) {
    switch (error.code) {
      case 'not_authenticated':
        return const ChatFailure('not_authenticated');
      case 'chat_not_found':
        return const ChatFailure('chat_not_found');
      case 'chat_closed':
        return const ChatFailure('chat_closed');
      case 'not_allowed':
        return const ChatFailure('not_allowed');
      case 'send_failed':
        return const ChatFailure('chat_send_failed');
      default:
        return const ChatFailure('something_went_wrong');
    }
  }

  return const ChatFailure('something_went_wrong');
}
