import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class ButtonLarge extends StatelessWidget {
  final String buttonText;
  final String? image;
  final VoidCallback? onPressed;

  const ButtonLarge({
    super.key,
    required this.buttonText,
    this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 0,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shadowColor: Colors.transparent,
          fixedSize: const Size(250, 250),
          shape: const CircleBorder(),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) ...[
              Image.asset(image!, height: 80),
              const SizedBox(height: BrbSpacers.xs),
            ],
            Text(buttonText),
          ],
        ),
      ),
    );
  }
}
