import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'i_get_cart_by_id_api_service.dart';

class GetCartByIdApiService implements IGetCartByIdApiService {
  @override
  Future<Map<String, dynamic>> getCartById(int id) async {
    return await ApiService.get(AppEndpoints.cartById(id));
  }
}
