import 'package:be_right_bark/features/mark_spot/mark_spot_controller.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_success/mark_spot_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';
import 'package:be_right_bark/widgets/buttons/button_large.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_button/constants.dart';
import 'package:be_right_bark/widgets/brb_dialog.dart';

class MarkSpotButton extends ConsumerWidget {
  const MarkSpotButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(markSpotControllerProvider);

    ref.listen(markSpotControllerProvider, (prev, next) {
      switch (next.status) {
        case MarkSpotStatus.loading:
          _showLoadingOverlay(context, ref);
        case MarkSpotStatus.success:
          _showSuccessDialog(context, ref, next.spotKey!);
        case MarkSpotStatus.permissionDenied:
          _showSettingsDialog(context, ref);
        case MarkSpotStatus.error:
          _handleError(context, ref, next.errorMessage!);
        case MarkSpotStatus.idle:
          break;
      }
    });

    return ButtonLarge(
      buttonText: buttonLabel,
      image: buttonImage,
      onPressed: state.status == MarkSpotStatus.loading
          ? null
          : () => ref.read(markSpotControllerProvider.notifier).markSpot(),
    );
  }

  void _handleError(BuildContext context, WidgetRef ref, String message) {
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    ref.read(markSpotControllerProvider.notifier).reset();
  }

  void _showLoadingOverlay(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return PopScope(
          canPop: true,
          child: BrbDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: BrbSpacers.sm),
                const Text(loadingMessage),
                const SizedBox(height: BrbSpacers.sm),
                ButtonSmall(
                  buttonText: cancelButtonLabel,
                  icon: Icons.close,
                  onPressed: () {
                    ref.read(markSpotControllerProvider.notifier).reset();
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, WidgetRef ref, int spotKey) {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      builder: (context) => MarkSpotSuccess(spotKey: spotKey),
    ).then((_) => ref.read(markSpotControllerProvider.notifier).reset());
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => BrbDialog(
        title: Text(
          locationAccessTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: const Text(locationAccessMessage),
        actions: [
          ButtonSmall(
            buttonText: cancelButtonLabel,
            icon: Icons.close,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: BrbSpacers.sm),
          ButtonMedium(
            buttonText: openSettingsButtonLabel,
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
          ),
        ],
      ),
    ).then((_) => ref.read(markSpotControllerProvider.notifier).reset());
  }
}
