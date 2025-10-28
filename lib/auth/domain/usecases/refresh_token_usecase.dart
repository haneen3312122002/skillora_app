import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';
import 'package:notes_tasks/auth/domain/repositories/refresh_token_repo.dart';

class RefreshTokenUseCase {
  final IRefreshTokenRepo repo;

  RefreshTokenUseCase(this.repo);

  Future<AuthEntity> call(String refreshToken) async {
    return await repo.refreshToken(refreshToken);
  }
}
