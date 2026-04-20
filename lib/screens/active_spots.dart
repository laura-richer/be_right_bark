import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/widgets/common/buttons/button_small.dart';
import '/widgets/active_spots/list.dart';
import '/models/location.dart';
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
    final locationsBox = Hive.box<Location>('locations');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: locationsBox.listenable(),
        builder: (context, Box<Location> locationsBox, _) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active spots',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (locationsBox.isNotEmpty)
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
              if (locationsBox.isNotEmpty)
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: locationsBox.listenable(),
                    builder: (context, Box<Location> locationsBox, _) {
                      return ActiveSpotsCardList(
                        locations: locationsBox.values.toList(),
                      );
                    },
                  ),
                ),

              if (locationsBox.isEmpty)
                Text('No marked spots yet (TODO - Prompt here to mark a spot)'),
            ],
          );
        },
      ),
    );
  }
}
