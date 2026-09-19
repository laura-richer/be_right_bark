import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final void Function(String?) onSave;
  final VoidCallback onCancel;
  final int? maxLength;
  final bool isTextArea;

  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.maxLength,
    this.isTextArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              return TextField(
                controller: controller,
                maxLength: maxLength,
                maxLines: isTextArea ? null : 1,
                minLines: isTextArea ? 3 : null,
                keyboardType: isTextArea ? TextInputType.multiline : null,
                autofocus: true,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(BrbSpacers.sm),
                  isDense: true,
                  counterText: '',
                  suffixText: maxLength != null
                      ? '${value.text.length}/$maxLength'
                      : null,
                  suffixStyle: Theme.of(context).textTheme.labelSmall,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: BrbSpacers.xs),
        IconButton.filled(
          icon: const Icon(Icons.check),
          onPressed: () {
            final value = controller.text.trim();
            onSave(value.isEmpty ? null : value);
          },
        ),
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
