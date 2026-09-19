import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/features/active_spots/active_spot_list.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_button/mark_spot_button.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';
import 'package:be_right_bark/widgets/titles/title_medium.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_screen/constants.dart';

class MarkSpotScreen extends ConsumerWidget {
  const MarkSpotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationProvider);
    final userPosition = ref.watch(userPositionProvider).valueOrNull;

    return Column(
      children: [
        if (locations.isNotEmpty)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleMedium(text: nearestSpotTitle),
                      ButtonSmall(
                        buttonText: seeAllButtonLabel,
                        icon: Icons.arrow_forward,
                        iconAlignment: IconAlignment.end,
                        onPressed: () => context.push('/active-spots'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BrbSpacers.sm),
                Expanded(
                  child: ActiveSpotsCardList(
                    count: 1,
                    locations: locations,
                    userPosition: userPosition,
                  ),
                ),
              ],
            ),
          ),
        const Expanded(flex: 2, child: Center(child: MarkSpotButton())),
      ],
    );
  }
}
