import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';
import 'package:be_right_bark/widgets/titles/title_medium.dart';
import 'package:be_right_bark/features/active_spots/active_spot_list.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/widgets/confirmation/confirmation.dart';
import 'package:be_right_bark/features/active_spots/active_spots_screen/constants.dart';
import 'package:be_right_bark/widgets/brb_dialog.dart';

class ActiveSpotsScreen extends ConsumerStatefulWidget {
  const ActiveSpotsScreen({super.key});

  @override
  ConsumerState<ActiveSpotsScreen> createState() => _ActiveSpotsScreenState();
}

class _ActiveSpotsScreenState extends ConsumerState<ActiveSpotsScreen> {
  void _handleClearLocations(WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => BrbDialog(
        content: Confirmation(
          onConfirm: () {
            ref.read(locationProvider.notifier).clearLocations();
            Navigator.of(dialogContext).pop();
          },
          onCancel: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationProvider);
    final userPosition = ref.watch(userPositionProvider).valueOrNull;

    return Padding(
      padding: BrbSpacers.screenPadding,
      child: Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleMedium(text: activeSpotsTitle),
              if (locations.isNotEmpty)
                ButtonSmall(
                  buttonText: clearAllButtonLabel,
                  icon: Icons.close,
                  iconAlignment: IconAlignment.end,
                  onPressed: () => _handleClearLocations(ref),
                ),
            ],
          ),
        ),
        const SizedBox(height: BrbSpacers.sm),
        if (locations.isNotEmpty)
          Expanded(
            child: ActiveSpotsCardList(
              locations: locations,
              userPosition: userPosition,
            ),
          ),
        if (locations.isEmpty) const Text('No marked spots yet.'),
      ],
      ),
    );
  }
}
