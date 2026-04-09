import 'package:flutter/material.dart';

class ButtonSmall extends StatelessWidget {
  final String buttonText;
  final IconData? icon;

  const ButtonSmall({
    super.key,
    required this.buttonText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      textStyle: WidgetStateProperty.all(Theme.of(context).textTheme.labelSmall),
    );

    if (icon != null) {
      return TextButton.icon(
        onPressed: () {},
        style: style,
        label: Text(buttonText),
        icon: Icon(icon),
      );
    }

    return TextButton(
      onPressed: () {},
      style: style,
      child: Text(buttonText),
    );
  }
}
