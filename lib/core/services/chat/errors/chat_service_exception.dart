class ChatServiceException implements Exception {
  final String code;

  const ChatServiceException(this.code);

  @override
  String toString() => 'ChatServiceException($code)';
}

/// Suggested codes:
/// - not_authenticated
/// - chat_not_found
/// - chat_closed
/// - not_allowed
/// - send_failed
