import 'package:notes_tasks/core/shared/enums/role.dart';

class ProfileEntity {
  final String uid;
  final String name;
  final String email;

  final String? photoUrl;
  final String? coverUrl;

  final UserRole role;
  final List<String> skills;
  final String? bio;

  const ProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    this.coverUrl,
    this.skills = const [],
    this.bio,
  });
}
