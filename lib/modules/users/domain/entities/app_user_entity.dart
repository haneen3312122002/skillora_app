// lib/modules/users/domain/entities/app_user_entity.dart

import 'package:notes_tasks/core/shared/enums/role.dart';

class AppUserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isDisabled;
  final DateTime? createdAt;

  const AppUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isDisabled,
    this.createdAt,
  });
}
