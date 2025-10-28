import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_tasks/auth/data/models/auth_model.dart';
import 'i_login_api_service.dart';

class LoginApiService implements ILoginApiService {
  final String baseUrl = 'https://dummyjson.com/auth';

  @override
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return AuthModel.fromJson(data);
    } else {
      throw Exception('Login failed: ${res.body}');
    }
  }
}
