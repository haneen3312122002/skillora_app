import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_get_basic_users_api_service.dart';

class GetBasicUsersApiService implements IGetBasicUsersApiService {
  final String baseUrl = 'https://dummyjson.com';

  @override
  Future<List<Map<String, dynamic>>> getBasicUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch users');
    }

    final data = jsonDecode(res.body);
    final List users = data['users'] ?? [];

    return users.map((u) {
      return {
        'id': u['id'],
        'role': u['role'],
        'firstName': u['firstName'],
        'lastName': u['lastName'],
        'email': u['email'],
        'image': u['image'],
        'age': u['age'],
        'gender': u['gender'],
      };
    }).toList();
  }
}
