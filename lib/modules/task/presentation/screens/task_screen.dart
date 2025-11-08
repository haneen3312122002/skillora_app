import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_tasks/core/widgets/app_dialog.dart';
import 'package:notes_tasks/core/widgets/app_fab.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/empty_vieq.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/app_card.dart';
import 'package:notes_tasks/core/widgets/app_list_tile.dart';
import 'package:notes_tasks/modules/task/domain/entities/task_entity.dart';
import 'package:notes_tasks/modules/task/presentation/screens/add_task_screen.dart';
import 'package:notes_tasks/modules/task/presentation/viewmodels/firebase/tasks_viewmodel.dart';
// ^ use the stream-based VM you created

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI reads AsyncValue only. All logic (fetch/refresh) lives in the ViewModel.
    final tasksState = ref.watch(tasksViewModelProvider);
    final vm = ref.read(tasksViewModelProvider.notifier);

    return AppScaffold(
      showLogout: true,
      scrollable: false,
      title: 'app_title'.tr(),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: vm.refresh, // delegate to VM (no logic here)
        ),
      ],
      body: tasksState.when(
        // ✅ Data state: render list of tasks
        data: (List<TaskEntity> tasks) {
          if (tasks.isEmpty) {
            return EmptyView(message: 'no_tasks'.tr());
          }

          // Use RefreshIndicator; ListView must be scrollable for pull-to-refresh.
          return RefreshIndicator(
            onRefresh:
                vm.refresh, // VM decides how to refresh (no-op for streams)
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              // Make sure it's scrollable even if items < screen height
              physics: const AlwaysScrollableScrollPhysics(),
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
                      // keep UI dumb; toggling/completion can be added via VM later
                    },
                  ),
                );
              },
            ),
          );
        },

        // 🔄 Loading state: small loader (no full-screen overlay)
        loading: () => const LoadingIndicator(withBackground: false),

        // ❌ Error state: delegate retry to VM
        error: (error, _) => ErrorView(
          message: 'failed_load_tasks'.tr(),
          onRetry: vm.refresh,
        ),
      ),
      floatingActionButton: AppFAB(
        tooltip: 'Add Task',
        onPressed: () {
          // Open add-task sheet; VM handles the add logic inside submit()
          AppDialog.show(context: context, content: const AddTaskScreen());
        },
      ),
    );
  }
}
