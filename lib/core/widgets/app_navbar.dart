import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface, // 🔹 من الثيم
      selectedItemColor: theme.colorScheme.primary, // 🔹 اللون الأساسي
      unselectedItemColor:
          theme.colorScheme.outline, // 🔹 لون العناصر غير المحددة
      selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
      unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.outline,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist_rounded),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_outlined),
          label: 'Carts',
        ),
      ],
    );
  }
}
