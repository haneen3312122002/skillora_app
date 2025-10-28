import 'package:notes_tasks/auth/data/models/auth_model.dart';

abstract class IRefreshTokenApiService {
  Future<AuthModel> refreshToken(String refreshToken);
}
