// modules/auth/presentation/screens/register.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/app_text_link.dart';
import 'package:notes_tasks/core/widgets/custom_text_field.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/firebase/register_viewmodel.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerViewModelProvider);
    final registerNotifier = ref.read(registerViewModelProvider.notifier);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCustomTextField(
            controller: nameController,
            label: 'name'.tr(),
            inputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSpacing.spaceMD),
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
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
              label: 'register'.tr(),
              isLoading: registerState.isLoading,
              onPressed: () async {
                if (registerState.isLoading) return;
                await registerNotifier.register(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
              }),
          SizedBox(height: AppSpacing.spaceLG),
          Center(
            child: AppTextLink(
              textKey: 'back_to_login',
              onPressed: () {
                context.pushReplacement('login');
              },
            ),
          ),
          SizedBox(height: AppSpacing.spaceMD),
          registerState.when(
            data: (user) {
              return const SizedBox();
            },
            error: (e, _) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('something_went_wrong'.tr())),
                );
              });
              return ErrorView(
                  message: 'something_went_wrong'.tr(), fullScreen: false);
            },
            loading: () => const SizedBox(),
          )
        ],
      ),
      actions: const [],
    );
  }
}
