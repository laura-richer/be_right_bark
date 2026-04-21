import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/widgets/active_spots/list.dart';
import '/widgets/common/buttons/button_small.dart';
import '/widgets/common/locations_builder.dart';
import '/widgets/common/user_position_builder.dart';
import '/widgets/mark_spot/button.dart';

class MarkSpotScreen extends StatelessWidget {
  const MarkSpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserPositionBuilder(
        builder: (context, userPosition) => LocationsBuilder(
        builder: (context, locations) {
          return Column(
            children: [
              if (locations.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearest spot',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ButtonSmall(
                            buttonText: 'See all',
                            icon: Icons.arrow_forward,
                            iconAlignment: IconAlignment.end,
                            onPressed: () => context.go('/active-spots'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
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
              Expanded(flex: 2, child: Center(child: MarkSpotButton())),
            ],
          );
        },
      ),
      ),
    );
  }
}
