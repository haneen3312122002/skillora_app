import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/app_text_link.dart';
import 'package:notes_tasks/core/widgets/custom_text_field.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/register.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/firebase/login_firebase_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(firebaseLoginVMProvider);
    final loginNotifier = ref.read(firebaseLoginVMProvider.notifier);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCustomTextField(
            controller: emailController,
            label: 'email'.tr(),
            inputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSpacing.spaceMD),
          AppCustomTextField(
            controller: passwordController,
            label: 'password'.tr(),
            obscureText: true,
            inputAction: TextInputAction.done,
            onSubmitted: (_) async {
              debugPrint('[UI] onSubmitted -> call VM');
              await loginNotifier.login(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
            label: 'login'.tr(),
            isLoading: loginState.isLoading,
            onPressed: () async {
              debugPrint('[UI] login button tapped -> call VM');
              await loginNotifier.login(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              debugPrint(
                  '[UI] after VM call, currentUser=${fb.FirebaseAuth.instance.currentUser?.uid}');
            },
          ),
          SizedBox(height: AppSpacing.spaceLG),
          Center(
            child: AppTextLink(
              textKey: 'create_account',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
            ),
          ),
          loginState.when(
            data: (user) {
              if (user == null) return const SizedBox();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AppNavBarContainer()),
                  (_) => false,
                );
              });
              return const SizedBox();
            },
            loading: () => const LoadingIndicator(withBackground: false),
            error: (e, _) {
              String msg = 'something_went_wrong'.tr();
              if (e is fb.FirebaseAuthException) {
                msg = '${e.code}: ${e.message ?? ''}';
              }
              return ErrorView(message: msg, fullScreen: false);
            },
          ),
        ],
      ),
      actions: const [],
    );
  }
}
