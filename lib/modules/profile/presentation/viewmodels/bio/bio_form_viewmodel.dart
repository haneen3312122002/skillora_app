import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/domain/usecases/bio/set_bio_usecase.dart';

final bioFormViewModelProvider =
    AsyncNotifierProvider<BioFormViewModel, String?>(
  BioFormViewModel.new,
);

class BioFormViewModel extends AsyncNotifier<String?> {
  late final SetBioUseCase _setBioUseCase = ref.read(setBioUseCaseProvider);

  @override
  FutureOr<String?> build() => null;

  void init(String? initialBio) {
    if (state.value == null) state = AsyncData(initialBio?.trim());
  }

  void onChanged(String value) => state = AsyncData(value);

  Future<String?> saveBio() async {
    if (state.isLoading) return 'something_went_wrong';

    final current = state.value?.trim();
    final valueToSave = (current != null && current.isEmpty) ? null : current;

    state = const AsyncLoading();
    try {
      await _setBioUseCase(valueToSave);
      state = AsyncData(valueToSave);
      return null; // ✅ success
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'failed_with_error';
    }
  }
}
