import 'package:flutter/material.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/presentation/widgets/custom_user_item.dart';


class CustomUserList extends StatelessWidget {
  final List<UserEntity> users;
  final Future<void> Function()? onRefresh;

  const CustomUserList({super.key, required this.users, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('No users found.', style: TextStyle(fontSize: 16)),
      );
    }

    final listView = ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return CustomUserItem(user: user);
      },
    );

    
    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh!, child: listView);
    }

    return listView;
  }
}
