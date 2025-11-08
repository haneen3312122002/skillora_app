import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/core/services/firebase/firebase_providers.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/app_text_link.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/modules/auth/presentation/providers/firebase/email_verified_stream_provider.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verifiedAsync = ref.watch(emailVerifiedStreamProvider);
    final auth = ref.read(firebaseAuthProvider); // read only data
    final authService = ref.read(authServiceProvider); // actions

    return AppScaffold(
      title: 'verify_email_title'.tr(),
      body: Center(
        child: verifiedAsync.when(
          data: (isVerified) {
            if (isVerified) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const AppNavBarContainer()),
                    (route) => false,
                  );
                }
              });
              return const SizedBox();
            }

            final email = auth.currentUser?.email ?? '';
            return Padding(
              padding: EdgeInsets.all(AppSpacing.spaceLG),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email_outlined, size: 64),
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
                    label: 'resend_verification_link'.tr(),
                    onPressed: () async {
                      try {
                        await authService.sendEmailVerification();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('verification_email_sent'.tr())),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('verification_send_failed'
                                    .tr(args: ['${e}']))),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextLink(
                    textKey: 'back_to_login',
                    onPressed: () async {
                      await authService.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const LoadingIndicator(withBackground: false),
          error: (e, _) => ErrorView(
            message: e.toString(),
            fullScreen: false,
            onRetry: () {
              ref.refresh(emailVerifiedStreamProvider);
            },
          ),
        ),
      ),
      actions: const [],
    );
  }
}
