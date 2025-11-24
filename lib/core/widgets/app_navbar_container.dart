import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/routs/app_routes.dart';
import 'package:notes_tasks/core/widgets/app_navbar.dart';
import 'package:notes_tasks/core/widgets/animation/slide_in.dart';

class AppNavBarContainer extends StatelessWidget {
  final Widget child; // current page from ShellRoute

  const AppNavBarContainer({
    super.key,
    required this.child,
  });

  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.posts)) return 1;
    if (location.startsWith(AppRoutes.users)) return 2;
    if (location.startsWith(AppRoutes.cart)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0; // default = home/tasks ('/')
  }

  @override
  Widget build(BuildContext context) {
    // current url:
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      // each time location changes, this SlideIn gets a new key
      body: SlideIn(
        key: ValueKey(location),
        from: const Offset(40, 0), // slide from right 40px
        duration: const Duration(milliseconds: 300),
        child: child,
      ),

      bottomNavigationBar: AppNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.posts);
              break;
            case 2:
              context.go(AppRoutes.users);
              break;
            case 3:
              context.go(AppRoutes.cart);
              break;
            case 4:
              context.go(AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }
}
