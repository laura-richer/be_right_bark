import 'package:flutter/material.dart';
import '/widgets/common/buttons/button_large.dart';

  class PickedUpButton extends StatelessWidget implements PreferredSizeWidget {

    const PickedUpButton({super.key});

    @override
    Widget build(BuildContext context) {
      return ButtonLarge(buttonText: 'Picked up', onPressed:() {},);
    }

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  }
