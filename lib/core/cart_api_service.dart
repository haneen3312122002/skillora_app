import 'dart:convert';
import 'package:http/http.dart' as http;

class CartApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('GET request failed ($endpoint): ${res.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getFirstCart() async {
    final data = await _get('carts');
    final List carts = data['carts'] ?? [];

    if (carts.isEmpty) {
      throw Exception('No carts found');
    }

    return Map<String, dynamic>.from(carts.first);
  }

  Future<Map<String, dynamic>> getCartById(int id) async {
    final data = await _get('carts/$id');
    return data;
  }

  Future<List<Map<String, dynamic>>> getUserCarts(int userId) async {
    final data = await _get('carts/user/$userId');
    final List carts = data['carts'] ?? [];
    return List<Map<String, dynamic>>.from(carts);
  }
}
