import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/auth/services/auth_service.dart';
import 'package:notes_tasks/core/services/auth/account_switcher/saved_accounts_service.dart';
import 'package:notes_tasks/core/services/auth/account_switcher/saved_accounts_provider.dart';

final saveAccountLocallyUseCaseProvider =
    Provider<SaveAccountLocallyUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  final db = ref.read(firebaseFirestoreProvider);
  final savedService = ref.read(savedAccountsServiceProvider);
  return SaveAccountLocallyUseCase(
    authService: authService,
    db: db,
    savedAccountsService: savedService,
    ref: ref,
  );
});

class SaveAccountLocallyUseCase {
  final AuthService _authService;
  final dynamic _db; // FirebaseFirestore
  final dynamic _savedAccountsService; // SavedAccountsService
  final Ref _ref;

  SaveAccountLocallyUseCase({
    required AuthService authService,
    required dynamic db,
    required dynamic savedAccountsService,
    required Ref ref,
  })  : _authService = authService,
        _db = db,
        _savedAccountsService = savedAccountsService,
        _ref = ref;

  Future<void> call({required String email}) async {
    try {
      final uid = _authService.auth.currentUser?.uid;
      if (uid == null) return;

      final userSnap = await _db.collection('users').doc(uid).get();
      final data = userSnap.data() ?? {};

      final name = (data['name'] ?? '').toString();
      final role = (data['role'] ?? '').toString();

      await _savedAccountsService.upsert(
        SavedAccount(
          uid: uid,
          email: email,
          name: name.isNotEmpty ? name : email,
          role: role.isNotEmpty ? role : 'user',
          lastUsedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      _ref.invalidate(savedAccountsProvider);
    } catch (_) {
      // don't block login if saving fails
    }
  }
}
