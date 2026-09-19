import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';

void main() {
  testWidgets('Should render correct button text if text is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonSmall(buttonText: 'Mark Spot', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Mark Spot'), findsOneWidget);
  });

  testWidgets('Should render an icon if icon is supplied', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonSmall(
            buttonText: 'Mark Spot',
            icon: Icons.edit,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('Should render as FilledButton when filled is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonSmall(
            buttonText: 'Mark Spot',
            icon: Icons.edit,
            filled: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('Should render icon at the end when iconAlignment is end', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonSmall(
            buttonText: 'Mark Spot',
            icon: Icons.arrow_forward,
            iconAlignment: IconAlignment.end,
            onPressed: () {},
          ),
        ),
      ),
    );

    final icon = tester.getTopLeft(find.byIcon(Icons.arrow_forward));
    final text = tester.getTopLeft(find.text('Mark Spot'));
    expect(icon.dx, greaterThan(text.dx));
  });

  testWidgets('Should emit onPressed event when tapped', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonSmall(
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
