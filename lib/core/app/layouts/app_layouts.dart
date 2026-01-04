import 'package:flutter/material.dart';
import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/widgets/navigation/app_navbar_container.dart';
import 'package:notes_tasks/core/shared/widgets/navigation/app_navbar.dart';

class ClientShell extends StatelessWidget {
  final Widget child;
  const ClientShell({super.key, required this.child});

  static const List<NavItemConfig> navItems = [
    NavItemConfig(
      route: AppRoutes.clientHome,
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    NavItemConfig(
      route: AppRoutes.clientNotifications,
      icon: Icons.notifications_none,
      label: 'Notifications',
    ),
    NavItemConfig(
      route: AppRoutes.clientChats,
      icon: Icons.chat_bubble_outline,
      label: 'Messages',
    ),
    NavItemConfig(
      route: AppRoutes.clientProfile,
      icon: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppNavBarContainer(
      items: navItems,
      child: child,
    );
  }
}

class FreelancerShell extends StatelessWidget {
  final Widget child;
  const FreelancerShell({super.key, required this.child});

  static const List<NavItemConfig> navItems = [
    NavItemConfig(
      route: AppRoutes.freelanceHome,
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    NavItemConfig(
      route: AppRoutes.freelancerNotifications,
      icon: Icons.notifications_none, // ✅ صح
      label: 'Notifications',
    ),
    NavItemConfig(
      route: AppRoutes.freelancerProposals,
      icon: Icons.description_outlined,
      label: 'Proposals',
    ),
    NavItemConfig(
      route: AppRoutes.freelancerChats,
      icon: Icons.chat_bubble_outline,
      label: 'Messages',
    ),
    NavItemConfig(
      route: AppRoutes.freelancerProfile,
      icon: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppNavBarContainer(
      items: navItems,
      child: child,
    );
  }
}
