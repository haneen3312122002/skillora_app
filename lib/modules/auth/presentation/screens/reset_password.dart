import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/widgets/texts/app_text_link.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

import 'package:notes_tasks/modules/auth/presentation/viewmodels/reset_password_viewmodel.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';

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

  Future<void> _onSendPressed() async {
    final state = ref.read(resetPasswordViewModelProvider);
    if (state.isLoading) return;

    FocusScope.of(context).unfocus();

    await ref.read(resetPasswordViewModelProvider.notifier).sendResetEmail(
          email: emailController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ UI reacts (no manual subscription)
    ref.listen<AsyncValue<void>>(resetPasswordViewModelProvider, (prev, next) {
      next.when(
        loading: () {
          
        },
        data: (_) {
          if (!mounted) return;
          // ✅ generic + safe
          AppSnackbar.show(context, 'reset_email_sent_generic'.tr());
        },
        error: (e, _) {
          if (!mounted) return;

          final key =
              (e is AuthFailure) ? e.messageKey : 'something_went_wrong';

          // ✅ error snackbar
          AppSnackbar.show(
              context, key.tr()); // if you have error variant, use it
          // مثال لو عندك:
          // AppSnackbar.error(context, key.tr());
        },
      );
    });

    final resetState = ref.watch(resetPasswordViewModelProvider);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'reset_password'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            width: 250.w,
            height: 250.h,
            child: Center(
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppCustomTextField(
            controller: emailController,
            label: 'email'.tr(),
            inputAction: TextInputAction.done,
            onSubmitted: (_) => _onSendPressed(),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
            variant: AppButtonVariant.outlined,
            label: 'send_reset_link'.tr(),
            isLoading: resetState.isLoading,
            onPressed: _onSendPressed,
          ),
          SizedBox(height: AppSpacing.spaceLG),
          Center(
            child: AppTextLink(
              textKey: 'back_to_login',
              onPressed: () => context.pushReplacement('/login'),
            ),
          ),
          SizedBox(height: AppSpacing.spaceMD),
        ],
      ),
      actions: const [],
    );
  }
}
