import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/presentation/providers/get_user_company_provider.dart';

final getUserCompanyViewModelProvider =
    AsyncNotifierProvider<GetUserCompanyViewModel, CompanyEntity?>(
      GetUserCompanyViewModel.new,
    );

class GetUserCompanyViewModel extends AsyncNotifier<CompanyEntity?> {
  late final _useCase = ref.read(getUserCompanyUseCaseProvider);

  @override
  FutureOr<CompanyEntity?> build() async => null;

  Future<void> getUserCompany(int id) async {
    state = const AsyncLoading();
    try {
      final company = await _useCase.call(id);
      state = AsyncData(company);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearCompany() => state = const AsyncData(null);
}
