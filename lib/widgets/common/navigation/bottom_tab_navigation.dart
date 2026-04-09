import 'package:be_right_bark/models/bottom_tabs.dart';
import 'package:be_right_bark/state/app_container_state.dart';
import 'package:flutter/material.dart';

class BottomTabNavigation extends StatelessWidget {
  const BottomTabNavigation({
    super.key,
    required NavState navState,
  }) : _navState = navState;

  final NavState _navState;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        border: Border(
          top: BorderSide(
             color: Theme.of(context).colorScheme.primaryContainer,
             width: 3.0,
          )
        ),
      ),
      child: NavigationBar(
        onDestinationSelected: _navState.select,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = Theme.of(context).textTheme.labelSmall;

          if (states.contains(WidgetState.selected)) {
            return base?.copyWith(color: Theme.of(context).colorScheme.secondary);
          }
          return base;
        }),
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        selectedIndex: _navState.selectedId,
        destinations: bottomTabsItems.map((item) {
          Icon tabBarIcon(Color color) => Icon(item.icon, color: color, size: 30);

          return NavigationDestination(
            selectedIcon: tabBarIcon(Theme.of(context).colorScheme.secondary),
            icon: tabBarIcon(Theme.of(context).colorScheme.primary),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
