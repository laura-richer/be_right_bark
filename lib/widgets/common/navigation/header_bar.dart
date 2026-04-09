import 'package:flutter/material.dart';

  class HeaderBar extends StatelessWidget implements PreferredSizeWidget {

    const HeaderBar({super.key});

    @override
    Widget build(BuildContext context) {
      return AppBar(
        title: Text('Be Right Bark', style: Theme.of(context).textTheme.titleLarge),
      );
    }

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  }
