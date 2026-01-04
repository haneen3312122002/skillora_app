// ===============================
// verify_email_screen.dart
// ===============================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/session/providers/current_user_email_provider.dart';
import 'package:notes_tasks/core/session/providers/email_verified_stream_provider.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/app_icon_button.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/texts/app_text_link.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/email_verified_viewmodel.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/verify_email_actions_viewmodel.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late final ProviderSubscription _verifiedSub;
  late final ProviderSubscription _actionsSub;

  @override
  void initState() {
    super.initState();

    // ✅ Side-effect: navigate when verified
    _verifiedSub = ref.listenManual(emailVerifiedVMProvider, (prev, next) {
      next.whenOrNull(
        data: (isVerified) {
          if (!isVerified) return;
          if (!mounted) return;
          context.go('/');
        },
      );
    });

    // ✅ Side-effects: show snackbar on error/success
    _actionsSub = ref.listenManual(verifyEmailActionsVMProvider, (prev, next) {
      next.when(
        data: (effect) {
          if (effect == null) return;

          if (!mounted) return;
          if (effect is VerifyEmailSuccessEffect) {
            AppSnackbar.show(context, effect.messageKey.tr());
          }
        },
        loading: () {},
        error: (e, _) {
          if (!mounted) return;
          final key =
              (e is AuthFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
        },
      );
    });
  }

  @override
  void dispose() {
    _verifiedSub.close();
    _actionsSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verifiedAsync = ref.watch(emailVerifiedVMProvider);
    final actionsState = ref.watch(verifyEmailActionsVMProvider);

    return AppScaffold(
      title: 'verify_email_title'.tr(),
      body: Center(
        child: verifiedAsync.when(
          data: (isVerified) {
            if (isVerified) return const SizedBox();

            // ✅ UI reads email from VM/provider (no Firebase direct access)
            final email = ref.watch(currentUserEmailProvider);

            return Padding(
              padding: EdgeInsets.all(AppSpacing.spaceLG),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppIconButton(
                    icon: Icons.email_outlined,
                    onTap: null,
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'verify_email_instructions'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  AppPrimaryButton(
                    variant: AppButtonVariant.outlined,
                    label: 'resend_verification_link'.tr(),
                    isLoading: actionsState.isLoading,
                    onPressed: () => ref
                        .read(verifyEmailActionsVMProvider.notifier)
                        .resendVerification(),
                  ),
                  const SizedBox(height: 16),
                  AppTextLink(
                    textKey: 'back_to_login',
                    onPressed: () async {
                      await ref
                          .read(verifyEmailActionsVMProvider.notifier)
                          .logout();

                      if (!mounted) return;
                      context.go('/login');
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const LoadingIndicator(withBackground: false),
          error: (_, __) => ErrorView(
            message: 'something_went_wrong'.tr(),
            fullScreen: false,
            onRetry: () => ref.invalidate(emailVerifiedVMProvider),
          ),
        ),
      ),
      actions: const [],
    );
  }
}
