import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/custom_text_field.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/widgets/app_text_link.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';

import 'package:notes_tasks/modules/auth/presentation/viewmodels/firebase/reset_password_viewmodel.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _onSendPressed() async {
    debugPrint('[UI] reset password button tapped -> call VM');

    await ref
        .read(resetPasswordViewModelProvider.notifier)
        .sendResetEmail(email: emailController.text.trim());

    final state = ref.read(resetPasswordViewModelProvider);

    if (!state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('reset_email_sent'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetPasswordViewModelProvider);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'reset_password'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppCustomTextField(
            controller: emailController,
            label: 'email'.tr(),
            inputAction: TextInputAction.done,
            onSubmitted: (_) async => _onSendPressed(),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
              label: 'send_reset_link'.tr(),
              isLoading: resetState.isLoading,
              onPressed: () {
                if (resetState.isLoading) return;
                _onSendPressed();
              }),
          SizedBox(height: AppSpacing.spaceLG),
          Center(
            child: AppTextLink(
              textKey: 'back_to_login',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.spaceMD),
          resetState.when(
            data: (_) {
              return const SizedBox();
            },
            loading: () => const LoadingIndicator(withBackground: false),
            error: (e, _) {
              String msg = 'something_went_wrong'.tr();

              if (e is ResetPasswordFailure) {
                msg = e.messageKey.tr();
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
