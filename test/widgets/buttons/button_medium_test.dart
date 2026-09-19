import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';

void main() {
  testWidgets('Should render correct button text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonMedium(buttonText: 'Mark Spot', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Mark Spot'), findsOneWidget);
  });

  testWidgets('Should emit onPressed event when tapped', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonMedium(
            buttonText: 'Mark Spot',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mark Spot'));
    expect(pressed, isTrue);
  });
}
