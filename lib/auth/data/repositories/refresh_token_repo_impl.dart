import 'package:notes_tasks/auth/data/datasources/refresh_token_datasource.dart';
import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';
import 'package:notes_tasks/auth/domain/repositories/refresh_token_repo.dart';

class RefreshTokenRepoImpl implements IRefreshTokenRepo {
  final IRefreshTokenDataSource dataSource;

  RefreshTokenRepoImpl(this.dataSource);

  @override
  Future<AuthEntity> refreshToken(String refreshToken) async {
    final model = await dataSource.refreshToken(refreshToken);
    return model.toEntity();
  }
}
