import 'package:notes_tasks/users/domain/entities/user_entity.dart';

class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserEntity? user; 

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.user,
  });
}
