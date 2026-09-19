import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class ButtonMedium extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const ButtonMedium({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: BrbSpacers.md,
            vertical: BrbSpacers.xs,
          ),
          textStyle: Theme.of(context).textTheme.labelMedium,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}
