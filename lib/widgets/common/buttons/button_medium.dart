import 'package:flutter/material.dart';

class ButtonMedium extends StatelessWidget {
  final String buttonText;

  const ButtonMedium({
    super.key,
    required this.buttonText,
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
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelMedium,
          shape: const StadiumBorder(),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {},
        child: Text(buttonText),
      ),
    );
  }
}
