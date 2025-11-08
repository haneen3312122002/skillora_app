import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'i_get_all_tasks_api_service.dart';

class GetAllTasksApiService implements IGetAllTasksApiService {
  @override
  Future<Map<String, dynamic>> getAllTasks() async {
    return await ApiService.get(AppEndpoints.todos);
  }
}
