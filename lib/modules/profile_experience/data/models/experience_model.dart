import 'package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart';

class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    required super.id,
    required super.title,
    required super.company,
    super.startDate,
    super.endDate,
    required super.location,
    required super.description,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> map) {
    DateTime? _date(dynamic v) {
      if (v is DateTime) return v;
      // إذا وصل String أو Timestamp من مكان ثاني، تجاهليه هون (core لازم يجهّز DateTime)
      return null;
    }

    return ExperienceModel(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      company: (map['company'] as String?) ?? '',
      startDate: _date(map['startDate']),
      endDate: _date(map['endDate']),
      location: (map['location'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'company': company,
        'startDate': startDate,
        'endDate': endDate,
        'location': location,
        'description': description,
      };
}
