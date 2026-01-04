

class ExperienceEntity {
  final String id;
  final String title;
  final String company;
  final DateTime? startDate;
  final DateTime? endDate;
  final String location;
  final String description;

  const ExperienceEntity({
    required this.id,
    required this.title,
    required this.company,
    this.startDate,
    this.endDate,
    required this.location,
    required this.description,
  });
}