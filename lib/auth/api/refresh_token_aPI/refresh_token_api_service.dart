import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_tasks/auth/data/models/auth_model.dart';
import 'i_refresh_token_api_service.dart';

class RefreshTokenApiService implements IRefreshTokenApiService {
  final String baseUrl = 'https://dummyjson.com/auth';

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    final res = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken, 'expiresInMins': 30}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return AuthModel.fromJson(data);
    } else {
      throw Exception('Token refresh failed: ${res.body}');
    }
  }
}
