import 'package:notes_tasks/task/domain/entities/task_entity.dart';

abstract class IGetAllTasksRepo {
  Future<List<TaskEntity>> getAllTasks();
}
