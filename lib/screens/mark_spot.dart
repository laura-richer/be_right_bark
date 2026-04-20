import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/widgets/active_spots/list.dart';
import '/widgets/common/buttons/button_small.dart';
import '/widgets/mark_spot/button.dart';
import '/models/location.dart';

class MarkSpotScreen extends StatelessWidget {
  const MarkSpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationsBox = Hive.box<Location>('locations');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: locationsBox.listenable(),
        builder: (context, Box<Location> locationsBox, _) {
          return Column(
            children: [
              if (locationsBox.isNotEmpty)
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
                        child: ValueListenableBuilder(
                          valueListenable: locationsBox.listenable(),
                          builder: (context, Box<Location> locationsBox, _) {
                            return ActiveSpotsCardList(
                              count: 1,
                              locations: locationsBox.values.toList(),
                            );
                          },
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
    );
  }
}
