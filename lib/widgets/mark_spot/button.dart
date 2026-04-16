import 'package:flutter/material.dart';
import '/widgets/common/buttons/button_large.dart';

  class MarkSpotButton extends StatelessWidget implements PreferredSizeWidget {

    const MarkSpotButton({super.key});

    @override
    Widget build(BuildContext context) {
      return ButtonLarge(buttonText: 'Mark spot');
    }

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  }
