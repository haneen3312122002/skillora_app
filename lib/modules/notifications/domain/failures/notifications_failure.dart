class NotificationsFailure implements Exception {
  final String messageKey;
  const NotificationsFailure(this.messageKey);

  @override
  String toString() => 'NotificationsFailure($messageKey)';
}
