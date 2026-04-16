import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/widgets/active_spots/list.dart';
import '/widgets/common/buttons/button_small.dart';
import '../widgets/mark_spot/button.dart';

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Column(children: [
          Expanded(
            flex: 1,
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nearest spot', style: Theme.of(context).textTheme.titleMedium),
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
                  items: [
                    {'title': 'Woodland', 'content': '200m away - Dropped 15mins ago', 'id': '0'},
                  ],
                ),
              ),
            ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: MarkSpotButton(),
            ),
          ),
        ],),
      );
    }
  }
