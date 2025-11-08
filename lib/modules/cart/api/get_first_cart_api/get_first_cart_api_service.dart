import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'i_get_first_cart_api_service.dart';

class GetFirstCartApiService implements IGetFirstCartApiService {
  @override
  Future<Map<String, dynamic>> getFirstCart() async {
    final data = await ApiService.get(AppEndpoints.carts);
    final List carts = data['carts'] ?? [];
    if (carts.isEmpty) throw Exception('No carts found');
    return Map<String, dynamic>.from(carts.first);
  }
}
