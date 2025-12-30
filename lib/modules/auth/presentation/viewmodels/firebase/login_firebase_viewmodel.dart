import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/mappers/auth_failure_mapper.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/login_usecase.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/logout_usecase.dart';

// ✅ ADD: saved accounts
import 'package:notes_tasks/core/features/auth/account_switcher/saved_accounts_service.dart';
import 'package:notes_tasks/core/features/auth/account_switcher/saved_accounts_provider.dart';

// ✅ ADD: firestore provider (إذا عندك واحد جاهز استعمليه بدل هذا)
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseLoginVMProvider =
    AsyncNotifierProvider<FirebaseLoginViewModel, void>(
  FirebaseLoginViewModel.new,
  name: 'FirebaseLoginVM',
);

class FirebaseLoginViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> login({required String email, required String password}) async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final loginUseCase = ref.read(firebaseLoginUseCaseProvider);

      // ✅ تنفيذ تسجيل الدخول
      await loginUseCase(email: email, password: password);

      // ✅ بعد نجاح الدخول: خزني الحساب محليًا
      final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _saveAccountLocally(uid: uid, email: email);
      }

      state = const AsyncData(null);
    } on fb.FirebaseAuthException catch (e, st) {
      final failure = mapFirebaseAuthExceptionToFailure(e);
      state = AsyncError(failure, st);
    } catch (e, st) {
      state = AsyncError(const AuthFailure('something_went_wrong'), st);
    }
  }

  Future<void> _saveAccountLocally({
    required String uid,
    required String email,
  }) async {
    try {
      final db = ref.read(firestoreProvider);

      final userSnap = await db.collection('users').doc(uid).get();
      final data = userSnap.data() ?? {};

      final name = (data['name'] ?? '').toString();
      final role = (data['role'] ?? '').toString();

      final service = ref.read(savedAccountsServiceProvider);

      await service.upsert(
        SavedAccount(
          uid: uid,
          email: email,
          name: name.isNotEmpty ? name : email,
          role: role.isNotEmpty ? role : 'user',
          lastUsedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      // ✅ (اختياري) refresh القائمة إذا عندك شاشة بتراقبها
      ref.invalidate(savedAccountsProvider);
    } catch (_) {
      // ما نخلي حفظ الحساب يفشل تسجيل الدخول
    }
  }

  Future<void> logout() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(const AuthFailure('something_went_wrong'), st);
    }
  }
}
