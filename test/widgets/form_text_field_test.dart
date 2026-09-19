import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/widgets/form_text_field.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('Should render the correct label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            onSave: (_) {},
            onCancel: () {},
          ),
        ),
      ),
    );

    expect(find.text('Name field'), findsOneWidget);
  });

  testWidgets('Should show save button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            onSave: (_) {},
            onCancel: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Should show cancel button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            onSave: (_) {},
            onCancel: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('Should update character count as text is entered', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            maxLength: 20,
            onSave: (_) {},
            onCancel: () {},
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.suffixText, '0/20');

    await tester.enterText(find.byType(TextField), 'Buddy');
    await tester.pump();

    final updatedTextField = tester.widget<TextField>(find.byType(TextField));
    expect(updatedTextField.decoration?.suffixText, '5/20');
  });

  testWidgets('Should not allow text beyond maxLength', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            maxLength: 20,
            onSave: (_) {},
            onCancel: () {},
          ),
        ),
      ),
    );

    final longText = 'a' * (20 + 10);
    await tester.enterText(find.byType(TextField), longText);
    await tester.pump();

    expect(controller.text.length, 20);
  });

  testWidgets('Should emit onSave event when confirm button is tapped', (
    tester,
  ) async {
    String? savedValue = 'not called';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            onSave: (value) => savedValue = value,
            onCancel: () {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Buddy');
    await tester.tap(find.byIcon(Icons.check));
    expect(savedValue, 'Buddy');
  });

  testWidgets('Should emit null when saving empty text', (tester) async {
    String? savedValue = 'not called';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            onSave: (value) => savedValue = value,
            onCancel: () {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.byIcon(Icons.check));
    expect(savedValue, isNull);
  });

  testWidgets('Should emit onCancel event when cancel button is tapped', (
    tester,
  ) async {
    var cancelled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormTextField(
            label: 'Name field',
            controller: controller,
            onSave: (_) {},
            onCancel: () => cancelled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    expect(cancelled, isTrue);
  });
}
