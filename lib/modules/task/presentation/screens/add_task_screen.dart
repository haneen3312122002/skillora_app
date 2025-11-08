import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/widgets/custom_text_field.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/modules/task/presentation/viewmodels/firebase/add_task_viewmodel.dart';
// ^ make sure this path matches where your VM lives

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI reads AsyncValue to show loading only; all logic is in the ViewModel.
    final state = ref.watch(addTaskViewModelProvider); // ✅ correct provider
    final vm = ref.read(addTaskViewModelProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCustomTextField(
          controller: _titleController,
          label: 'Task Title',
          hint: 'Enter your task',
          inputAction: TextInputAction.done,
          onSubmitted: (_) {
            // Forward raw input to the VM; VM handles validation/snackbar/pop.
            vm.submit(
              context,
              rawTitle: _titleController.text,
            );
          },
        ),
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: 'Add Task',
          icon: Icons.add,
          isLoading: state.isLoading, // show loading on the button only
          onPressed: () {
            if (state.isLoading) return; // prevent duplicate taps
            vm.submit(
              context,
              rawTitle: _titleController.text,
            );
          },
        ),
      ],
    );
  }
}
