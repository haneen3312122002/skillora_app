import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/presentation/viewmodels/get_basic_users_viewmodel.dart';
import 'package:notes_tasks/users/presentation/widgets/custom_user_list.dart';
import 'package:notes_tasks/users/presentation/widgets/custom_error_view.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getBasicUsersViewModelProvider.notifier).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(getBasicUsersViewModelProvider);
    final viewModel = ref.read(getBasicUsersViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.fetchUsers(),
          ),
        ],
      ),
      body: usersState.when(
        data: (List<UserEntity> users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return CustomUserList(users: users, onRefresh: viewModel.fetchUsers);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => CustomErrorView(
          error: e,
          message: 'Failed to load users',
          onRetry: viewModel.fetchUsers,
        ),
      ),
    );
  }
}
