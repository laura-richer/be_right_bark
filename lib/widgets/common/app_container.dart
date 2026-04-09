  import 'package:be_right_bark/models/bottom_tabs.dart';
  import 'package:be_right_bark/state/app_container_state.dart';
  import 'package:be_right_bark/widgets/common/navigation/header_bar.dart';
import 'package:be_right_bark/widgets/common/navigation/bottom_tab_navigation.dart';
  import 'package:flutter/material.dart';

  PageItem? findById(List<PageItem> items, int id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        var found = findById(item.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  class AppContainer extends StatefulWidget {
    const AppContainer({super.key});

    @override
    State<AppContainer> createState() => _AppContainerState();
  }

  class _AppContainerState extends State<AppContainer> {
    final _navState = NavState();

    @override
    void dispose() {
      _navState.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return ListenableBuilder(
        listenable: _navState,
        builder: (context, _) {
          final activeNavItem = findById(bottomTabsItems, _navState.selectedId);

          return LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                appBar: HeaderBar(),
                bottomNavigationBar: BottomTabNavigation(navState: _navState),
                body: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: activeNavItem?.page ?? Placeholder(),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      );
    }
  }
