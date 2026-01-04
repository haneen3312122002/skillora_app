class JobFailure implements Exception {
  final String messageKey;
  const JobFailure(this.messageKey);

  @override
  String toString() => 'JobFailure($messageKey)';
}
