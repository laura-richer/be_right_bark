import 'package:flutter/material.dart';

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
          color: Theme.of(context).colorScheme.secondary,
          blurRadius: 0,
          offset: Offset(0, 3), // pushes shadow downward
          spreadRadius: 0,
        ),
      ],
    ),
    child: FilledButton(
        style: FilledButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelMedium,
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}
