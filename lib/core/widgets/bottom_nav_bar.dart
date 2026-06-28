import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_extensions.dart';

final class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.common;
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      indicatorColor: context.colors.primary.withValues(alpha: 0.16),
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: translations.dashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.groups_outlined),
          selectedIcon: const Icon(Icons.groups),
          label: translations.groups,
        ),
        NavigationDestination(
          icon: const Icon(Icons.location_on_outlined),
          selectedIcon: const Icon(Icons.location_on),
          label: translations.liveMap,
        ),
        NavigationDestination(
          icon: const Icon(Icons.build_outlined),
          selectedIcon: const Icon(Icons.build),
          label: translations.maintenance,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: translations.profile,
        ),
      ],
    );
  }
}
