import 'package:flutter/material.dart';

class ButtonSmall extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconAlignment? iconAlignment;

  const ButtonSmall({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.iconAlignment,

  });

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      textStyle: WidgetStateProperty.all(Theme.of(context).textTheme.labelSmall),
    );

    if (icon != null) {
      return TextButton.icon(
        iconAlignment: iconAlignment == IconAlignment.start
          ? IconAlignment.start
          : IconAlignment.end,
        icon: Icon(icon),
        onPressed: onPressed,
        style: style,
        label: Text(buttonText),

      );
    }

    return TextButton(
      onPressed: onPressed,
      style: style,
      child: Text(buttonText),
    );
  }
}
