import 'package:flutter/material.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/role_based/admin/admin_profile_sections.dart';

class PublicAdminSections extends StatelessWidget {
  final String uid;
  final ProfileEntity profile;

  const PublicAdminSections({
    super.key,
    required this.uid,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ نفس الويجت، بس ما في أدوات فعلية أصلاً غير عرض
    return AdminProfileSections(profile: profile);
  }
}
