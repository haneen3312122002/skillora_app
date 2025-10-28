import 'package:notes_tasks/task/data/datasources/get_all_tasks_remote_datasource.dart';
import 'package:notes_tasks/task/domain/entities/task_entity.dart';
import 'package:notes_tasks/task/domain/repositories/get_all_tasks_repo.dart';

class GetAllTasksRepoImpl implements IGetAllTasksRepo {
  final IGetAllTasksRemoteDataSource dataSource;

  GetAllTasksRepoImpl(this.dataSource);

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    final models = await dataSource.getAllTasks();
    return models.map((e) => e.toEntity()).toList();
  }
}
