import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.role,
    super.photoUrl,
    super.coverUrl,
    super.skills = const [],
    super.bio,
  });

  factory ProfileModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return ProfileModel(
      uid: doc.id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      photoUrl: data['photoUrl'] as String?,
      coverUrl: data['coverUrl'] as String?,
      role: parseUserRole(data['role'] as String?),
      skills: (data['skills'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      bio: (data['bio'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'coverUrl': coverUrl,
      'role': userRoleToString(role), // ✅ مهم: لا تخزن enum مباشرة
      'skills': skills,
      'bio': bio,
    };
  }
}
