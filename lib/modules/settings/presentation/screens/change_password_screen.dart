import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/settings/presentation/viewmodels/change_password_viewmodel.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    await ref.read(changePasswordViewModelProvider.notifier).submit(
          context: context,
          currentPassword: _currentPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordViewModelProvider);

    return AppScaffold(
      title: 'settings_change_password'.tr(),
      showSettingsButton: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'settings_change_password_hint'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppCustomTextField(
            controller: _currentPasswordController,
            label: 'current_password'.tr(),
            obscureText: true,
            inputAction: TextInputAction.done,
            onSubmitted: (_) => _onSubmit(),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          AppPrimaryButton(
            variant: AppButtonVariant.outlined,
            label: 'send_reset_link'.tr(),
            isLoading: state.isLoading,
            onPressed: () {
              if (state.isLoading) return;
              _onSubmit();
            },
          ),
          SizedBox(height: AppSpacing.spaceLG),
          state.when(
            data: (_) => const SizedBox.shrink(),
            loading: () => const LoadingIndicator(withBackground: false),
            error: (e, _) {
              String msg = 'something_went_wrong'.tr();
              if (e is AuthFailure) {
                msg = e.messageKey.tr();
              }
              return ErrorView(
                message: msg,
                fullScreen: false,
              );
            },
          ),
        ],
      ),
      actions: const [],
    );
  }
}
