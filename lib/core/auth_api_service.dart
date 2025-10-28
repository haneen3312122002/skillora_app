import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_tasks/auth/data/models/auth_model.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';

class AuthApiService {
  final String baseUrl = 'https://dummyjson.com/auth';

  /// 🔹 تسجيل الدخول
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

      // ✅ نحول JSON إلى AuthModel (اللي يحتوي على user داخله)
      return AuthModel.fromJson(data);
    } else {
      throw Exception('Login failed: ${res.body}');
    }
  }

  /// 🔹 جلب المستخدم الحالي (عن طريق الـ token)
  Future<UserModel> getAuthUser(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // ✅ نحول JSON إلى UserModel جاهز
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to fetch auth user: ${res.statusCode}');
    }
  }

  /// 🔹 تجديد التوكن
  Future<AuthModel> refreshToken(String refreshToken) async {
    final res = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken, 'expiresInMins': 30}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // ✅ نحول JSON إلى AuthModel أيضًا
      return AuthModel.fromJson(data);
    } else {
      throw Exception('Token refresh failed: ${res.body}');
    }
  }
}
