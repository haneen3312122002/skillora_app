import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/texts/app_text_link.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/fields/app_dropdown.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/validators/auth_validators.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/register_viewmodel.dart';
import 'package:notes_tasks/modules/auth/presentation/providers/register_role_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final List<UserRole> _roles = const [
    UserRole.client,
    UserRole.freelancer,
  ];

  late final ProviderSubscription _registerSub;

  @override
  void initState() {
    super.initState();

    _registerSub = ref.listenManual(registerViewModelProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;

          // prevent re-trigger if user returns to this screen
          ref.invalidate(registerViewModelProvider);

          context.go('/verify-email');
        },
        error: (e, _) {
          if (!mounted) return;
          final key =
              (e is AuthFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(type: SnackbarType.error, context, key.tr());
        },
      );
    });
  }

  @override
  void dispose() {
    _registerSub.close();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showError(String key) {
    AppSnackbar.show(type: SnackbarType.error, context, key.tr());
  }

  Future<void> _submitRegister() async {
    final registerState = ref.read(registerViewModelProvider);
    if (registerState.isLoading) return;

    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ✅ Empty fields validation
    if (name.isEmpty) {
      _showError('name_required'); // add this key in translations
      return;
    }

    if (email.isEmpty) {
      _showError('email_required'); // add this key in translations
      return;
    }

    if (password.isEmpty) {
      _showError('password_required'); // add this key in translations
      return;
    }

    // ✅ Email/Password rules (use your existing validators)
    final emailKey = AuthValidators.validateEmail(email);
    if (emailKey != null) {
      _showError(emailKey);
      return;
    }

    final passKey = AuthValidators.validatePassword(password);
    if (passKey != null) {
      _showError(passKey);
      return;
    }

    // ✅ Role validation
    final role = ref.read(selectedRoleProvider);
    if (role == null) {
      _showError('please_select_role');
      return;
    }

    await ref.read(registerViewModelProvider.notifier).register(
          name: name,
          email: email,
          password: password,
          role: userRoleToString(role),
        );
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerViewModelProvider);
    final selectedRole = ref.watch(selectedRoleProvider);

    return AppScaffold(
      actions: const [],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 250.w,
            height: 250.h,
            child: Center(
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: AppSpacing.spaceSM),
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
            onSubmitted: (_) => _submitRegister(),
          ),
          SizedBox(height: AppSpacing.spaceMD),
          AppDropdown<UserRole>(
            label: 'role'.tr(),
            hint: 'select_your_role'.tr(),
            items: _roles,
            value: selectedRole,
            onChanged: (role) {
              ref.read(selectedRoleProvider.notifier).state = role;
            },
            itemLabelBuilder: (role) => role.labelKey.tr(),
            validator: (role) =>
                role == null ? 'please_select_role'.tr() : null,
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
            variant: AppButtonVariant.outlined,
            label: 'register'.tr(),
            isLoading: registerState.isLoading,
            onPressed: _submitRegister,
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
    );
  }
}
