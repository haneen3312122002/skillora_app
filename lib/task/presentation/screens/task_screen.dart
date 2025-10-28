import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/task/domain/entities/task_entity.dart';
import 'package:notes_tasks/task/presentation/viewmodels/get_all_tasks_viewmodel.dart';
import 'package:notes_tasks/task/presentation/widgets/custom_task_list.dart';
import 'package:notes_tasks/task/presentation/widgets/custom_error_view.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(getAllTasksViewModelProvider);
    final viewModel = ref.read(getAllTasksViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.refreshTasks,
          ),
        ],
      ),
      body: tasksState.when(
        data: (List<TaskEntity> tasks) => CustomTaskList(
          tasks: tasks,
          onRefresh: () => viewModel.refreshTasks(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => CustomErrorView(
          error: error,
          onRetry: viewModel.refreshTasks,
          message: 'Failed to load tasks',
        ),
      ),
    );
  }
}
