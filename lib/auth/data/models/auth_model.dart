import 'package:notes_tasks/users/data/models/user_model.dart';

import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
    super.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: (json['expiresIn'] ?? 0) as int,
      user: UserModel.fromMap(json).toEntity(),
    );
  }

  AuthEntity toEntity() => this;
}
