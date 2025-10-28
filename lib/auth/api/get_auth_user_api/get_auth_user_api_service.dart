import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_tasks/users/data/models/user_model.dart';
import 'i_get_auth_user_api_service.dart';

class GetAuthUserApiService implements IGetAuthUserApiService {
  final String baseUrl = 'https://dummyjson.com/auth';

  @override
  Future<UserModel> getAuthUser(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to fetch auth user: ${res.statusCode}');
    }
  }
}
