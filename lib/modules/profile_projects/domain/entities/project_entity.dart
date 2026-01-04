import 'package:notes_tasks/modules/profile_projects/domain/entities/profile_item.dart';

class ProjectEntity implements ProfileItem {
  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  /// tools = tags
  final List<String> tools;

  @override
  String? get imageUrl => _imageUrl;
  final String? _imageUrl;

  @override
  String? get linkUrl => projectUrl;
  final String? projectUrl;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<String> get tags => tools;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    this.tools = const [],
    String? imageUrl,
    this.projectUrl,
    this.createdAt,
    this.updatedAt,
  }) : _imageUrl = imageUrl;
}
