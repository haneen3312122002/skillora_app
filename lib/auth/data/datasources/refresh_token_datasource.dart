import 'package:notes_tasks/auth/api/Refresh_Token_API/i_refresh_token_api_service.dart';
import 'package:notes_tasks/auth/data/models/auth_model.dart';

abstract class IRefreshTokenDataSource {
  Future<AuthModel> refreshToken(String token);
}

class RefreshTokenDataSource implements IRefreshTokenDataSource {
  final IRefreshTokenApiService api;

  RefreshTokenDataSource(this.api);

  @override
  Future<AuthModel> refreshToken(String token) async {
    return await api.refreshToken(token);
  }
}
