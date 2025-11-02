import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/navbar_provider.dart';
import 'package:notes_tasks/task/presentation/screens/task_screen.dart';
import 'package:notes_tasks/users/presentation/features/user_list/screens/users_list_screen.dart';
import 'app_navbar.dart';

class AppNavBarContainer extends ConsumerWidget {
  const AppNavBarContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final notifier = ref.read(navIndexProvider.notifier);

    final pages = const [TaskListScreen(), UsersListScreen()];
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: AppNavBar(
        currentIndex: currentIndex,
        onTap: (index) => notifier.state = index,
      ),
    );
  }
}
