import 'package:flutter/material.dart';
import '/widgets/active_spots/list.dart';
import '/widgets/common/buttons/button_large.dart';
import '/widgets/common/buttons/button_medium.dart';
import '/widgets/common/buttons/button_small.dart';

class StylesetterScreen extends StatelessWidget {
  const StylesetterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Display large', style: Theme.of(context).textTheme.displayLarge),
            Text('Title large', style: Theme.of(context).textTheme.titleLarge),
            Text('Title medium', style: Theme.of(context).textTheme.titleMedium),
            Text('Title small', style: Theme.of(context).textTheme.titleSmall),
            Text('Headline large', style: Theme.of(context).textTheme.headlineLarge),
            Text('Label large', style: Theme.of(context).textTheme.labelLarge),
            Text('Label medium', style: Theme.of(context).textTheme.labelMedium),
            Text('Label small', style: Theme.of(context).textTheme.labelSmall),
            Text('Body medium', style: Theme.of(context).textTheme.bodyMedium),
            ButtonLarge(buttonText: 'Large button'),
            ButtonMedium(buttonText: 'Medium button'),
            ButtonSmall(buttonText: 'Small button', icon: Icons.edit, onPressed:() {},),
            ActiveSpotsCardList(
              shrinkWrap: true,
              items: [
                {'title': 'Woodland', 'content': '200m away - Dropped 15mins ago', 'id': '0'},
                {'title': 'Grassland', 'content': '50m away - Dropped 94mins ago', 'id': '1'},
              ],
            ),
          ],
        ),
      ),
    );
  }
}
