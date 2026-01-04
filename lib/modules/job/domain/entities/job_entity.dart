import 'package:notes_tasks/modules/profile_projects/domain/entities/profile_item.dart';

class JobEntity implements ProfileItem {
  @override
  final String id;

  /// ✅ صاحب الجوب (مهم للبروبوزال)
  final String clientId;

  @override
  final String title;

  @override
  final String description;

  @override
  final List<String> tags;

  @override
  final String? imageUrl;

  final String? jobUrl;
  final double? budget;
  final DateTime? deadline;
  final bool isOpen;

  final String category;

  const JobEntity({
    required this.id,
    required this.clientId, // ✅ جديد
    required this.title,
    required this.description,
    required List<String> skills,
    this.imageUrl,
    this.jobUrl,
    this.budget,
    this.deadline,
    this.isOpen = true,
    this.category = '',
  }) : tags = skills;

  @override
  String? get linkUrl => jobUrl;

  List<String> get skills => tags;
}
