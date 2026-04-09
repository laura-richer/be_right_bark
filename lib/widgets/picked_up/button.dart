import 'package:flutter/material.dart';
import 'package:be_right_bark/widgets/common/buttons/button_large.dart';

  class PickedUpButton extends StatelessWidget implements PreferredSizeWidget {

    const PickedUpButton({super.key});

    @override
    Widget build(BuildContext context) {
      return ButtonLarge(buttonText: 'Picked up');
    }

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  }
