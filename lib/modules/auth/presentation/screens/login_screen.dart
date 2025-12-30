import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
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

// ✅ ADD (لو عملتي AccountSwitcherSheet)
import 'package:notes_tasks/core/features/auth/account_switcher/account_switcher_sheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late final ProviderSubscription _loginSub;

  // ✅ ADD: حتى ما نعمل prefill كل rebuild
  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();

    _loginSub = ref.listenManual(firebaseLoginVMProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          context.go('/');
        },
        error: (e, _) {
          final key =
              (e is AuthFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
        },
      );
    });
  }

  @override
  void dispose() {
    _loginSub.close();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ✅ ADD: اقرأ prefillEmail من extra مرة وحدة
  void _prefillEmailIfAny(BuildContext context) {
    if (_didPrefill) return;
    _didPrefill = true;

    final extra = GoRouterState.of(context).extra;
    if (extra is Map) {
      final v = extra['prefillEmail'];
      final email = v == null ? '' : v.toString();
      if (email.isNotEmpty) {
        emailController.text = email;
      }
    }
  }

  Future<void> submitLogin() async {
    final state = ref.read(firebaseLoginVMProvider);
    if (state.isLoading) return;

    FocusScope.of(context).unfocus();

    await ref.read(firebaseLoginVMProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  void _openAccountSwitcher() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const AccountSwitcherSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _prefillEmailIfAny(context);

    final loginState = ref.watch(firebaseLoginVMProvider);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ زر صغير فوق لتبديل الحسابات (اختياري)
          Align(
            alignment: Alignment.centerRight,
            child: AppTextLink(
              textKey: 'switch_account', // ضيفي key بالترجمة
              onPressed: _openAccountSwitcher,
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
              textKey: 'forget password?',
              onPressed: () => context.push('/reset-pass'),
            ),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          FadeIn(
            delay: const Duration(milliseconds: 250),
            child: AppPrimaryButton(
              label: 'login'.tr(),
              isLoading: loginState.isLoading,
              onPressed: submitLogin,
            ),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          Center(
            child: AppTextLink(
              textKey: 'create_account',
              onPressed: () => context.pushReplacement('/register'),
            ),
          ),
        ],
      ),
      actions: const [],
    );
  }
}
