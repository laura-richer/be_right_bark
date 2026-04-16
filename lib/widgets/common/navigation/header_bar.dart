import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text('Be Right Bark', style: Theme.of(context).textTheme.titleLarge),
      leading: context.canPop()
        ? IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        )
      : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
