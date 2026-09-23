import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class ButtonMedium extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;

  const ButtonMedium({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: BrbSpacers.md,
          vertical: BrbSpacers.xs,
        ),
      ),
      textStyle: WidgetStateProperty.all(
        Theme.of(context).textTheme.labelMedium,
      ),
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.onSecondary,
      ),
      backgroundColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.secondary,
      ),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(const StadiumBorder()),
    );



    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 0,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),

      child: icon != null
          ? FilledButton.icon(
              iconAlignment: IconAlignment.end,
              icon: Icon(icon),
              label: Text(buttonText),
              onPressed: onPressed,
              style: style,
            )
          : FilledButton(
              onPressed: onPressed,
              style: style,
              child: Text(buttonText),
            ),
    );
  }
}
