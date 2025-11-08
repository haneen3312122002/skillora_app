import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'i_get_basic_users_api_service.dart';

class GetBasicUsersApiService implements IGetBasicUsersApiService {
  @override
  Future<List<Map<String, dynamic>>> getBasicUsers() async {
    final data = await ApiService.get(AppEndpoints.getUsers);
    final List users = data['users'] ?? [];
    return users
        .map(
          (u) => {
            'id': u['id'],
            'role': u['role'],
            'firstName': u['firstName'],
            'lastName': u['lastName'],
            'email': u['email'],
            'image': u['image'],
            'age': u['age'],
            'gender': u['gender'],
          },
        )
        .toList();
  }
}
