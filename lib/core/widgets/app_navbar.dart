import 'package:flutter/material.dart';
import 'package:notes_tasks/core/widgets/animation/animated_nav_icon.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.outline,
      selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
      unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.outline,
      ),
      items: [
        BottomNavigationBarItem(
          icon: AnimatedNavIcon(
            icon: Icons.checklist_rounded,
            isActive: currentIndex == 0,
          ),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: AnimatedNavIcon(
            icon: Icons.post_add,
            isActive: currentIndex == 1,
          ),
          label: 'Posts',
        ),
        BottomNavigationBarItem(
          icon: AnimatedNavIcon(
            icon: Icons.people_alt_rounded,
            isActive: currentIndex == 2,
          ),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: AnimatedNavIcon(
            icon: Icons.shopping_basket_outlined,
            isActive: currentIndex == 3,
          ),
          label: 'Carts',
        ),
        BottomNavigationBarItem(
          icon: AnimatedNavIcon(
            icon: Icons.person,
            isActive: currentIndex == 4,
          ),
          label: 'My Profile',
        ),
      ],
    );
  }
}
