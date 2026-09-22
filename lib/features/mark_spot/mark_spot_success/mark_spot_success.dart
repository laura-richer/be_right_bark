import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';
import 'package:be_right_bark/widgets/titles/title_large.dart';
import 'package:be_right_bark/widgets/form_text_field.dart';
import 'package:be_right_bark/widgets/confirmation/confirmation.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_success/constants.dart';
import 'package:be_right_bark/constants/name.dart';
import 'package:be_right_bark/widgets/animations/spot_marked_animation.dart';

class MarkSpotSuccess extends ConsumerStatefulWidget {
  final int spotKey;

  const MarkSpotSuccess({super.key, required this.spotKey});

  @override
  ConsumerState<MarkSpotSuccess> createState() => _MarkSpotSuccessState();
}

class _MarkSpotSuccessState extends ConsumerState<MarkSpotSuccess> {
  final _nameController = TextEditingController();
  String _previousName = '';
  bool _nameFieldIsActive = false;
  bool _deleteConfirmIsActive = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleEditName() {
    _previousName = _nameController.text;
    setState(() => _nameFieldIsActive = true);
  }

  void _handleNameFieldClose() {
    _nameController.text = _previousName;
    setState(() => _nameFieldIsActive = false);
  }

  Future<void> _handleSaveName(String? value) async {
    await ref.read(locationProvider.notifier).updateName(widget.spotKey, value);
    setState(() => _nameFieldIsActive = false);
  }

  void _handleShowDeleteConfirmation() {
    setState(() => _deleteConfirmIsActive = true);
  }

  void _handleCancelDelete() {
    setState(() => _deleteConfirmIsActive = false);
  }

  Future<void> _handleDeleteName() async {
    await ref.read(locationProvider.notifier).updateName(widget.spotKey, null);
    _nameController.clear();
    setState(() => _deleteConfirmIsActive = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(BrbSpacers.xl),
        child: Column(
          children: [
            const TitleLarge(text: spotMarkedTitle),
            const SizedBox(height: BrbSpacers.md),
            const SpotMarkedAnimation(size: 220),
            const SizedBox(height: BrbSpacers.xs),
            Text(
              spotMarkedMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: BrbSpacers.xxl),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Column(
                children: [
                  if (!_nameFieldIsActive && !_deleteConfirmIsActive) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonSmall(
                          buttonText: _nameController.text.trim().isNotEmpty
                              ? _nameController.text
                              : addNameButtonLabel,
                          icon: Icons.edit,
                          iconAlignment: IconAlignment.end,
                          filled: _nameController.text.trim().isNotEmpty
                              ? true
                              : false,
                          onPressed: () => _handleEditName(),
                        ),
                        if (_nameController.text.trim().isNotEmpty &&
                            !_deleteConfirmIsActive) ...[
                          const SizedBox(width: BrbSpacers.xs),
                          IconButton(
                            style: IconButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            icon: const Icon(Icons.delete),
                            onPressed: () => _handleShowDeleteConfirmation(),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (_deleteConfirmIsActive) ...[
                    Confirmation(
                      onConfirm: () => _handleDeleteName(),
                      onCancel: () => _handleCancelDelete(),
                    ),
                  ],
                  if (_nameFieldIsActive) ...[
                    FormTextField(
                      label: addNameButtonLabel,
                      controller: _nameController,
                      maxLength: nameMaxLength,
                      onSave: (value) => _handleSaveName(value),
                      onCancel: () => _handleNameFieldClose(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: BrbSpacers.xs),
            ButtonSmall(
              buttonText: viewDetailsButtonLabel,
              icon: Icons.arrow_forward,
              iconAlignment: IconAlignment.end,
              onPressed: () {
                Navigator.pop(context);
                context.push('/active-spots/${widget.spotKey}');
              },
            ),
            const SizedBox(height: BrbSpacers.md),
            ButtonMedium(
              buttonText: backToWalkButtonLabel,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
