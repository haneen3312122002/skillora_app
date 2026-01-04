import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'saved_accounts_service.dart';

final savedAccountsServiceProvider = Provider<SavedAccountsService>((ref) {
  return SavedAccountsService();
});

final savedAccountsProvider = FutureProvider<List<SavedAccount>>((ref) async {
  return ref.read(savedAccountsServiceProvider).getAll();
});
