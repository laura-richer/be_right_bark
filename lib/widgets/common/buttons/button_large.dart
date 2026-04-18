import 'package:flutter/material.dart';

class ButtonLarge extends StatelessWidget {
  final String buttonText;
  final String? subtitle;
  final String? image;
  final VoidCallback? onPressed;


  const ButtonLarge({
    super.key,
    required this.buttonText,
    this.subtitle,
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
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 0,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
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
              Image.asset(
                image!,
                height: 80,
              ),
              const SizedBox(height: 10),
            ],
            Text(buttonText),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
