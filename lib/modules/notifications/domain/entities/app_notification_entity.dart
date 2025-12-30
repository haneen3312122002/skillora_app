class AppNotificationEntity {
  final String id;
  final String type; // e.g. job_created
  final String title;
  final String body;
  final String? refId; // jobId مثلاً
  final DateTime createdAt;
  final bool read;

  const AppNotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
    this.refId,
  });
}
