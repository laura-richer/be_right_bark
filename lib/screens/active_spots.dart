import 'package:flutter/material.dart';
import '/widgets/common/buttons/button_small.dart';
import '/widgets/common/locations_builder.dart';
import '/widgets/common/user_position_builder.dart';
import '/widgets/active_spots/list.dart';
import '/servivces/location.dart';

class ActiveSpotsScreen extends StatefulWidget {
  const ActiveSpotsScreen({super.key});

  @override
  State<ActiveSpotsScreen> createState() => _ActiveSpotsScreenState();
}

class _ActiveSpotsScreenState extends State<ActiveSpotsScreen> {
  final LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserPositionBuilder(
        builder: (context, userPosition) => LocationsBuilder(
          builder: (context, locations) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active spots',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (locations.isNotEmpty)
                      ButtonSmall(
                        buttonText: 'Clear all',
                        icon: Icons.close,
                        iconAlignment: IconAlignment.end,
                        onPressed: () async {
                          await locationService.clearLocations();
                        },
                      ),
                  ],
                ),
                SizedBox(height: 12),
                if (locations.isNotEmpty)
                  Expanded(
                    child: ActiveSpotsCardList(
                      locations: locations,
                      userPosition: userPosition,
                    ),
                  ),
                if (locations.isEmpty)
                  Text('No marked spots yet (TODO - Prompt here to mark a spot)'),
              ],
            );
          },
        ),
      ),
    );
  }
}
