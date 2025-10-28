import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';
import 'package:notes_tasks/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:notes_tasks/auth/presentation/providers/refresh_token_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final refreshTokenViewModelProvider =
    AsyncNotifierProvider<RefreshTokenViewModel, AuthEntity?>(
      RefreshTokenViewModel.new,
    );

class RefreshTokenViewModel extends AsyncNotifier<AuthEntity?> {
  late final RefreshTokenUseCase _refreshTokenUseCase = ref.read(
    refreshTokenUseCaseProvider,
  );

  @override
  FutureOr<AuthEntity?> build() async => null;

  Future<void> refresh(String refreshToken) async {
    state = const AsyncLoading();
    try {
      final newAuth = await _refreshTokenUseCase.call(refreshToken);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', newAuth.accessToken);
      await prefs.setString('refreshToken', newAuth.refreshToken);

      state = AsyncData(newAuth);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void reset() => state = const AsyncData(null);
}
