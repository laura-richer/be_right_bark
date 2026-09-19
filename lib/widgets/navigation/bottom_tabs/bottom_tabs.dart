import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/widgets/navigation/bottom_tabs/constants.dart';

final _tabPaths = bottomTabs.map((tab) => tab.path).toList();

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _tabPaths.indexWhere(
      (path) => location.startsWith(path),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 3.0,
          ),
        ),
      ),
      child: NavigationBar(
        onDestinationSelected: (index) => context.go(_tabPaths[index]),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return Theme.of(context).textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          );
        }),
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        destinations: bottomTabs
            .map((tab) => _buildDestination(context, tab.icon, tab.label))
            .toList(),
      ),
    );
  }

  NavigationDestination _buildDestination(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    Icon tabIcon(Color color) => Icon(icon, color: color, size: 30);
    return NavigationDestination(
      selectedIcon: tabIcon(Theme.of(context).colorScheme.primary),
      icon: tabIcon(Theme.of(context).colorScheme.tertiary),
      label: label,
    );
  }
}
