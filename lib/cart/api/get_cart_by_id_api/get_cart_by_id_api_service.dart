import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_get_cart_by_id_api_service.dart';

class GetCartByIdApiService implements IGetCartByIdApiService {
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
  Future<Map<String, dynamic>> getCartById(int id) async {
    final data = await _get('carts/$id');
    return Map<String, dynamic>.from(data);
  }
}
