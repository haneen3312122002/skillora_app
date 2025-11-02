import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/widgets/app_scafold.dart';
import 'package:notes_tasks/core/widgets/empty_vieq.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/app_card.dart';
import 'package:notes_tasks/core/widgets/app_list_tile.dart';
import 'package:notes_tasks/task/domain/entities/task_entity.dart';
import 'package:notes_tasks/task/presentation/viewmodels/get_all_tasks_viewmodel.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(getAllTasksViewModelProvider);
    final viewModel = ref.read(getAllTasksViewModelProvider.notifier);

    return AppScaffold(
      title: 'My Tasks',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: viewModel.refreshTasks,
        ),
      ],
      body: tasksState.when(
        data: (List<TaskEntity> tasks) {
          if (tasks.isEmpty) {
            return const EmptyView(message: 'No tasks yet');
          }

          return RefreshIndicator(
            onRefresh: () async => await viewModel.refreshTasks(),
            child: ListView.builder(
              shrinkWrap: true, // لأن AppScaffold يدعم scrollable
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return AppCard(
                  child: AppListTile(
                    title: task.todo,
                    trailing: Icon(
                      task.completed ? Icons.check_circle : Icons.pending,
                      color: task.completed ? Colors.green : Colors.orange,
                    ),
                    onTap: () {
                      // TODO: Navigate to details or edit
                    },
                  ),
                );
              },
            ),
          );
        },

        loading: () => const LoadingIndicator(withBackground: false),

        error: (error, _) => ErrorView(
          message: 'Failed to load tasks',
          onRetry: viewModel.refreshTasks,
        ),
      ),
    );
  }
}
