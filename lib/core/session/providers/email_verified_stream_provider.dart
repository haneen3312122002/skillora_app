import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/auth/domain/usecases/watch_email_verified_usecase.dart';

final emailVerifiedVMProvider =
    StreamNotifierProvider<EmailVerifiedViewModel, bool>(
  EmailVerifiedViewModel.new,
  name: 'EmailVerifiedVM',
);

class EmailVerifiedViewModel extends StreamNotifier<bool> {
  @override
  Stream<bool> build() {
    final watch = ref.read(watchEmailVerifiedUseCaseProvider);
    return watch(); // Stream<bool>
  }
}
