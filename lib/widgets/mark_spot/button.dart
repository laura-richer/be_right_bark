import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/widgets/common/buttons/button_large.dart';
import '/utils/location.dart';

class MarkSpotButton extends StatefulWidget implements PreferredSizeWidget {
  const MarkSpotButton({super.key});

  @override
  State<MarkSpotButton> createState() => _MarkSpotButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MarkSpotButtonState extends State<MarkSpotButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonLarge(
      buttonText: 'Mark spot',
      image: 'lib/assets/mark_spot_icon.png',
      onPressed: () async {
        saveLocation();
      },
    );
  }
}
