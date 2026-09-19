import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class ButtonSmall extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconAlignment? iconAlignment;
  final bool? filled;

  const ButtonSmall({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.filled,
    this.iconAlignment = IconAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.all(BrbSpacers.sm)),
      foregroundColor: WidgetStateProperty.all(
        filled == true
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary,
      ),
      textStyle: WidgetStateProperty.all(
        Theme.of(context).textTheme.labelSmall,
      ),
    );

    if (filled == true && icon != null) {
      return FilledButton.icon(
        iconAlignment: iconAlignment,
        icon: Icon(icon),
        label: Text(buttonText),
        onPressed: onPressed,
        style: style,
      );
    }

    if (icon != null) {
      return TextButton.icon(
        iconAlignment: iconAlignment,
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
