import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_get_user_carts_api_service.dart';

class GetUserCartsApiService implements IGetUserCartsApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('GET request failed ($endpoint): ${res.statusCode}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserCarts(int userId) async {
    final data = await _get('carts/user/$userId');
    final List carts = data['carts'] ?? [];
    return List<Map<String, dynamic>>.from(carts);
  }
}
