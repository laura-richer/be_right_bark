import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/widgets/titles/title_large.dart';
import 'package:be_right_bark/widgets/navigation/header_bar/constants.dart';

class HeaderBar extends StatefulWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  @override
  State<HeaderBar> createState() => _HeaderBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderBarState extends State<HeaderBar> {
  late final GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = GoRouter.of(context);
    _router.routerDelegate.addListener(_onRouteChange);
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRouteChange);
    super.dispose();
  }

  void _onRouteChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      title: const TitleLarge(text: appName),
      centerTitle: true,
      leading: GoRouter.of(context).canPop()
          ? IconButton(
              iconSize: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              icon: const Icon(Icons.chevron_left),
              onPressed: () => context.pop(),
            )
          : null,
    );
  }
}
