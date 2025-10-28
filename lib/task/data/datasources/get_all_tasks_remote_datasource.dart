import 'package:notes_tasks/task/api/get_all_tasks_api/i_get_all_tasks_api_service.dart';
import 'package:notes_tasks/task/data/models/task_model.dart';

abstract class IGetAllTasksRemoteDataSource {
  Future<List<TaskModel>> getAllTasks();
}

class GetAllTasksRemoteDataSource implements IGetAllTasksRemoteDataSource {
  final IGetAllTasksApiService api;

  GetAllTasksRemoteDataSource(this.api);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final data = await api.getAllTasks();
    final List todos = data['todos'] ?? [];
    return todos.map((e) => TaskModel.fromMap(e)).toList();
  }
}
