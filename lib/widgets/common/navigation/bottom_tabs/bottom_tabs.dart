import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/widgets/common/navigation/bottom_tabs/consts.dart';

final _tabPaths = bottomTabs.map((tab) => tab.path).toList();

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _tabPaths.indexWhere((path) => location.startsWith(path));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 3.0,
          ),
        ),
      ),
      child: NavigationBar(
        onDestinationSelected: (index) => context.go(_tabPaths[index]),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = Theme.of(context).textTheme.labelSmall;
          if (states.contains(WidgetState.selected)) {
            return base?.copyWith(color: Theme.of(context).colorScheme.secondary);
          }
          return base;
        }),
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        destinations: bottomTabs.map((tab) => _buildDestination(context, tab.icon, tab.label)).toList(),
      ),
    );
  }

  NavigationDestination _buildDestination(BuildContext context, IconData icon, String label) {
    Icon tabIcon(Color color) => Icon(icon, color: color, size: 30);
    return NavigationDestination(
      selectedIcon: tabIcon(Theme.of(context).colorScheme.secondary),
      icon: tabIcon(Theme.of(context).colorScheme.primary),
      label: label,
    );
  }
}
