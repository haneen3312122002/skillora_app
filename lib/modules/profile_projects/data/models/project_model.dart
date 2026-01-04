import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    super.tools = const [],
    super.imageUrl,
    super.projectUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    DateTime? _date(dynamic v) => v is DateTime ? v : null;

    return ProjectModel(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      tools: (map['tools'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      imageUrl: map['imageUrl'] as String?,
      projectUrl: map['projectUrl'] as String?,
      createdAt: _date(map['createdAt']),
      updatedAt: _date(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMapForCreate() => {
        'title': title,
        'description': description,
        'tools': tools,
        'imageUrl': imageUrl,
        'projectUrl': projectUrl,
      };

  Map<String, dynamic> toMapForUpdate() => {
        'title': title,
        'description': description,
        'tools': tools,
        'imageUrl': imageUrl,
        'projectUrl': projectUrl,
      };
}
