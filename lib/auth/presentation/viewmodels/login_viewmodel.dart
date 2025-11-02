import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';
import 'package:notes_tasks/auth/domain/usecases/login_usecase.dart';
import 'package:notes_tasks/auth/presentation/providers/login_provider.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart';
import 'package:notes_tasks/users/presentation/features/user_list/screens/users_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loginViewModelProvider =
    AsyncNotifierProvider<LoginViewModel, AuthEntity?>(LoginViewModel.new);

class LoginViewModel extends AsyncNotifier<AuthEntity?> {
  late final LoginUseCase _loginUseCase = ref.read(loginUseCaseProvider);

  String? accessToken;
  String? refreshToken;

  @override
  FutureOr<AuthEntity?> build() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    refreshToken = prefs.getString('refreshToken');
    return null;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final auth = await _loginUseCase.call(username, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', auth.accessToken);
      await prefs.setString('refreshToken', auth.refreshToken);

      accessToken = auth.accessToken;
      refreshToken = auth.refreshToken;

      state = AsyncData(auth);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    accessToken = null;
    refreshToken = null;
    state = const AsyncData(null);
  }

  Future<void> checkAuthAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token != null && token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppNavBarContainer()),
        );
      });
    }
  }
}
