import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:notes_tasks/auth/presentation/widgets/button.dart';
import 'package:notes_tasks/auth/presentation/widgets/textfield.dart';
import 'package:notes_tasks/users/presentation/screens/users_screnn.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(controller: usernameController, label: 'Username'),
            const SizedBox(height: 16),
            MyTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            MyButton(
              text: 'Login',
              isLoading: loginState.isLoading,
              onTap: () async {
                await loginNotifier.login(
                  usernameController.text,
                  passwordController.text,
                );
              },
            ),
            const SizedBox(height: 20),
            loginState.when(
              data: (auth) {
                if (auth == null) return const SizedBox();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const UserScreen()),
                    (route) => false,
                  );
                });

                return Text(
                  ' Logged in as: ${auth.user?.firstName ?? "Unknown"}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                );
              },
              loading: () => const SizedBox(),
              error: (e, _) => const Text(
                ' Invalid credentials',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
