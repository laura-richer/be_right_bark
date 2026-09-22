import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class BrbDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const BrbDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(BrbSpacers.md),
      insetPadding: const EdgeInsets.symmetric(horizontal: BrbSpacers.md),
      title: title,
      content: content,
      actions: actions,
    );
  }
}
