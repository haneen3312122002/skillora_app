// lib/modules/users/data/models/app_user_model.dart
import 'package:notes_tasks/core/shared/enums/role.dart';

import '../../domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isDisabled,
    super.createdAt,
  });

  factory AppUserModel.fromMap(String id, Map<String, dynamic> map) {
    final roleStr = (map['role'] as String?) ?? 'user';

    return AppUserModel(
      id: id,
      name: (map['name'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      role: _roleFromString(roleStr),
      isDisabled: (map['isDisabled'] as bool?) ?? false,
      createdAt: (map['createdAt'] is int)
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role.name,
      'isDisabled': isDisabled,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  static UserRole _roleFromString(String value) {
    return switch (value) {
      'admin' => UserRole.admin,
      'client' => UserRole.client,
      _ => UserRole.freelancer,
    };
  }
}
