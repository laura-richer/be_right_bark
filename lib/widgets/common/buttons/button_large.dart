import 'package:flutter/material.dart';

class ButtonLarge extends StatelessWidget {
  final String buttonText;

  const ButtonLarge({
    super.key,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 0,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          fixedSize: const Size(250, 250),
        ),
        onPressed: () {},
        child: Text(buttonText),
      ),
    );
  }
}
