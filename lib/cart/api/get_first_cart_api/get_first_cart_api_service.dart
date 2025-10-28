import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_get_first_cart_api_service.dart';

class GetFirstCartApiService implements IGetFirstCartApiService {
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
  Future<Map<String, dynamic>> getFirstCart() async {
    final data = await _get('carts');
    final List carts = data['carts'] ?? [];

    if (carts.isEmpty) {
      throw Exception('No carts found');
    }

    return Map<String, dynamic>.from(carts.first);
  }
}
