import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/core/widgets/custom_text_field.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/modules/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_list/screens/users_list_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loginViewModelProvider.notifier).checkAuthAndNavigate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginNotifier = ref.read(loginViewModelProvider.notifier);
    print(
      "PRIMARY COLOR................................................................ => ${Theme.of(context).colorScheme.primary}",
    );

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username Field
          AppCustomTextField(
            controller: usernameController,
            label: 'username'.tr(),
            inputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSpacing.spaceMD),

          //  Password Field
          AppCustomTextField(
            controller: passwordController,
            label: 'password'.tr(),
            obscureText: true,
            inputAction: TextInputAction.done,
          ),
          SizedBox(height: AppSpacing.spaceLG),

          // 🔘 Login Button
          AppPrimaryButton(
            label: 'login'.tr(),
            isLoading: loginState.isLoading,
            onPressed: () async {
              await loginNotifier.login(
                usernameController.text.trim(),
                passwordController.text.trim(),
              );
            },
          ),
          SizedBox(height: AppSpacing.spaceLG),

          // 🔁 State Handling (Data, Loading, Error)
          loginState.when(
            data: (auth) {
              if (auth == null) return const SizedBox();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => AppNavBarContainer()),
                  (route) => false,
                );
              });

              return Text(
                '${"login_success".tr()} ${auth.user?.firstName ?? "User"}',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.green),
              );
            },
            loading: () => const LoadingIndicator(withBackground: false),
            error: (e, _) => ErrorView(
              message: 'invalid_credentials'.tr(),
              fullScreen: false,
            ),
          ),
        ],
      ),
      actions: [],
    );
  }
}
