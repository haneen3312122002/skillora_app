import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'i_get_user_address_api_service.dart';

class GetUserAddressApiService implements IGetUserAddressApiService {
  @override
  Future<Map<String, dynamic>> getUserAddress(int id) async {
    final data = await ApiService.get(AppEndpoints.userAddress(id));
    return (data['address'] ?? {}) as Map<String, dynamic>;
  }
}
