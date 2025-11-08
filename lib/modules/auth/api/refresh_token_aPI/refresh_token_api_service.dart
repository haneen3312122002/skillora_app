import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'package:notes_tasks/modules/auth/data/models/auth_model.dart';
import 'i_refresh_token_api_service.dart';

class RefreshTokenApiService implements IRefreshTokenApiService {
  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    final data = await ApiService.post(
      AppEndpoints.refreshToken,
      body: {'refreshToken': refreshToken, 'expiresInMins': 30},
    );
    return AuthModel.fromJson(data);
  }
}
