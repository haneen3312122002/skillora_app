import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/presentation/providers/get_user_bank_provider.dart';

final getUserBankViewModelProvider =
    AsyncNotifierProvider<GetUserBankViewModel, BankEntity?>(
      GetUserBankViewModel.new,
    );

class GetUserBankViewModel extends AsyncNotifier<BankEntity?> {
  late final _useCase = ref.read(getUserBankUseCaseProvider);

  @override
  FutureOr<BankEntity?> build() async => null;

  Future<void> getUserBank(int id) async {
    state = const AsyncLoading();
    try {
      final bank = await _useCase.call(id);
      state = AsyncData(bank);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearBank() => state = const AsyncData(null);
}
