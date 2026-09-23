import 'package:flutter/material.dart';
// import 'package:be_right_bark/widgets/active_spots/list.dart';
import 'package:be_right_bark/widgets/buttons/button_large.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';
import 'package:be_right_bark/styles/spacers.dart';

class StylesetterScreen extends StatelessWidget {
  const StylesetterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BrbSpacers.screenPadding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Display large',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text('Title large', style: Theme.of(context).textTheme.titleLarge),
            Text(
              'Title medium',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Title small', style: Theme.of(context).textTheme.titleSmall),
            Text(
              'Headline large',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text('Label large', style: Theme.of(context).textTheme.labelLarge),
            Text(
              'Label medium',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text('Label small', style: Theme.of(context).textTheme.labelSmall),
            Text('Body small', style: Theme.of(context).textTheme.bodySmall),
            ButtonLarge(buttonText: 'Large button', onPressed: () {}),
            ButtonMedium(buttonText: 'Medium button', onPressed: () {}),
            ButtonSmall(
              buttonText: 'Small button',
              icon: Icons.edit,
              onPressed: () {},
            ),
            // ActiveSpotsCardList(
            //   shrinkWrap: true,
            // ),
          ],
        ),
      ),
    );
  }
}
