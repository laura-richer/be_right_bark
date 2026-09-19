import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/widgets/confirmation/confirmation.dart';
import 'package:be_right_bark/widgets/confirmation/constants.dart';

void main() {
  testWidgets(
    'Should show `are you sure` text, confirm button and cancel button',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Confirmation(onConfirm: () {}, onCancel: () {}),
          ),
        ),
      );

      expect(find.text(confirmationTitle), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    },
  );

  testWidgets('Should emit onConfirm event when confirm button is tapped', (
    tester,
  ) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Confirmation(
            onConfirm: () => confirmed = true,
            onCancel: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.check));
    expect(confirmed, isTrue);
  });

  testWidgets('Should emit onCancel event when cancel button is tapped', (
    tester,
  ) async {
    var cancelled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Confirmation(
            onConfirm: () {},
            onCancel: () => cancelled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    expect(cancelled, isTrue);
  });
}
