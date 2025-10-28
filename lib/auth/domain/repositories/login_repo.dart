import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';

abstract class ILoginRepo {
  Future<AuthEntity> login(String username, String password);
}
