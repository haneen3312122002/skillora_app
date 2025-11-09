import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/tasks/task_service_provider.dart';
import 'package:notes_tasks/modules/task/domain/entities/task_entity.dart';

final tasksViewModelProvider =
    StreamNotifierProvider<TasksViewModel, List<TaskEntity>>(
        TasksViewModel.new);

class TasksViewModel extends StreamNotifier<List<TaskEntity>> {
  @override
  Stream<List<TaskEntity>> build() {
    final svc = ref.read(TaskServiceProvider);
    return svc.streamTasks();
  }

  Future<void> refresh() async {}
}
