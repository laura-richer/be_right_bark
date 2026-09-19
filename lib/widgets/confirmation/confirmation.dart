import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/widgets/confirmation/constants.dart';

class Confirmation extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const Confirmation({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(confirmationTitle, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: BrbSpacers.xs),
        IconButton.filled(icon: const Icon(Icons.check), onPressed: onConfirm),
        const SizedBox(width: BrbSpacers.xs),
        IconButton.outlined(
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          icon: const Icon(Icons.close),
          onPressed: onCancel,
        ),
      ],
    );
  }
}
