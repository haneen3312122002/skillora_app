import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/presentation/viewmodels/get_user_address_viewmodel.dart';
import 'package:notes_tasks/users/presentation/viewmodels/get_user_bank_viewmodel.dart';
import 'package:notes_tasks/users/presentation/viewmodels/get_user_comapny_viewmodel.dart';
import 'package:notes_tasks/users/presentation/widgets/user_detail_section.dart';

class UserDetailsScreen extends ConsumerWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 4),

          UserDetailSection(
            title: '🏠 Address',
            provider: getUserAddressViewModelProvider,
            onFetch: () => ref
                .read(getUserAddressViewModelProvider.notifier)
                .getUserAddress(userId),
          ),

          UserDetailSection(
            title: '🏦 Bank',
            provider: getUserBankViewModelProvider,
            onFetch: () => ref
                .read(getUserBankViewModelProvider.notifier)
                .getUserBank(userId),
          ),

          UserDetailSection(
            title: '🏢 Company',
            provider: getUserCompanyViewModelProvider,
            onFetch: () => ref
                .read(getUserCompanyViewModelProvider.notifier)
                .getUserCompany(userId),
          ),
        ],
      ),
    );
  }
}
