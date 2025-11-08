import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'i_add_task_api_service.dart';

class AddTaskApiService implements IAddTaskApiService {
  @override
  Future<Map<String, dynamic>> addTask({
    required String todo,
    required bool completed,
    required int userId,
  }) async {
    final body = {'todo': todo, 'completed': completed, 'userId': userId};
    return await ApiService.post('${AppEndpoints.todos}/add', body: body);
  }
}
