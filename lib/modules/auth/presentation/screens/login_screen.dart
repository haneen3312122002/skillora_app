import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/shared/widgets/animation/fade_in.dart';
import 'package:notes_tasks/core/shared/widgets/animation/slide_in.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/texts/app_text_link.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/firebase/login_firebase_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _didPrefill = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _prefillEmailIfAny(BuildContext context) {
    if (_didPrefill) return;
    _didPrefill = true;

    final extra = GoRouterState.of(context).extra;
    if (extra is Map) {
      final v = extra['prefillEmail'];
      final email = v == null ? '' : v.toString().trim();
      if (email.isNotEmpty) emailController.text = email;
    }
  }

  Future<void> submitLogin() async {
    final state = ref.read(firebaseLoginVMProvider);
    if (state.isLoading) return;

    FocusScope.of(context).unfocus();

    await ref.read(firebaseLoginVMProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    _prefillEmailIfAny(context);

    // ✅ Riverpod way: react to state changes (no effects)
    ref.listen<AsyncValue<void>>(firebaseLoginVMProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          context.go('/');
        },
        error: (e, _) {
          if (!mounted) return;
          final key =
              (e is AuthFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(type: SnackbarType.error, context, key.tr());
        },
      );
    });

    final loginState = ref.watch(firebaseLoginVMProvider);

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.spaceMD,
            right: AppSpacing.spaceMD,
            top: AppSpacing.spaceMD,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + AppSpacing.spaceLG,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 250.w,
                height: 250.h,
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spaceSM),
              FadeIn(
                child: SlideIn(
                  from: const Offset(0, -20),
                  child: AppCustomTextField(
                    controller: emailController,
                    label: 'email'.tr(),
                    inputAction: TextInputAction.next,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spaceMD),
              FadeIn(
                delay: const Duration(milliseconds: 100),
                child: SlideIn(
                  from: const Offset(0, -10),
                  child: AppCustomTextField(
                    controller: passwordController,
                    label: 'password'.tr(),
                    obscureText: true,
                    inputAction: TextInputAction.done,
                    onSubmitted: (_) => submitLogin(),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spaceSM),
              FadeIn(
                delay: const Duration(milliseconds: 200),
                child: AppTextLink(
                  textKey: 'forget_password',
                  onPressed: () => context.push('/reset-pass'),
                ),
              ),
              SizedBox(height: AppSpacing.spaceLG),
              FadeIn(
                delay: const Duration(milliseconds: 250),
                child: AppPrimaryButton(
                  variant: AppButtonVariant.primary,
                  label: 'login'.tr(),
                  isLoading: loginState.isLoading,
                  onPressed: submitLogin,
                ),
              ),
              SizedBox(height: AppSpacing.spaceMD),
              FadeIn(
                delay: const Duration(milliseconds: 300),
                child: AppPrimaryButton(
                  variant: AppButtonVariant.outlined,
                  label: 'create_account'.tr(),
                  isLoading: loginState.isLoading,
                  onPressed: () => context.push('/register'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: const [],
    );
  }
}
