import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_get_user_address_api_service.dart';

class GetUserAddressApiService implements IGetUserAddressApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('GET $endpoint failed: ${res.statusCode}');
  }

  @override
  Future<Map<String, dynamic>> getUserAddress(int id) async {
    final data = await _get('users/$id');
    return (data['address'] ?? {}) as Map<String, dynamic>;
  }
}
