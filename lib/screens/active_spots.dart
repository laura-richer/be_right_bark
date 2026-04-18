import 'package:flutter/material.dart';
import '/widgets/common/buttons/button_small.dart';
import '/widgets/active_spots/list.dart';

class ActiveSpotsScreen extends StatelessWidget {
    const ActiveSpotsScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Expanded(
            flex: 1,
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active spots', style: Theme.of(context).textTheme.titleMedium),
                  ButtonSmall(
                    buttonText: 'Clear all',
                    icon: Icons.close,
                    iconAlignment: IconAlignment.end,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: ActiveSpotsCardList(),
              ),
            ],
            ),
          ),
      );
    }
  }
