import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_success/constants.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_success/mark_spot_success.dart';
import '../../helpers/fake_location_notifier.dart';
import '../../helpers/test_locations.dart';

void main() {
  late FakeLocationNotifier fakeNotifier;
  late int spotKey;

  setUp(() {
    fakeNotifier = FakeLocationNotifier();
    spotKey = fakeNotifier.seed(createTestLocations(1).first);
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [locationProvider.overrideWith(() => fakeNotifier)],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => MarkSpotSuccess(spotKey: spotKey),
              ),
              child: const Text('Open dialog'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
  }

  testWidgets('should show success title', (tester) async {
    await openDialog(tester);

    expect(find.text(spotMarkedTitle), findsOneWidget);
  });

  testWidgets('should show name spot button', (tester) async {
    await openDialog(tester);

    expect(find.text(addNameButtonLabel), findsOneWidget);
  });

  testWidgets('should show view details button', (tester) async {
    await openDialog(tester);

    expect(find.text(viewDetailsButtonLabel), findsOneWidget);
  });

  testWidgets('should show back to walk button', (tester) async {
    await openDialog(tester);

    expect(find.text(backToWalkButtonLabel), findsOneWidget);
  });

  group('naming spot', () {
    testWidgets('should show name field on name button tap', (tester) async {
      await openDialog(tester);

      await tester.tap(find.text(addNameButtonLabel));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    group('entered name', () {
      testWidgets('should not save name on cancel button tap', (tester) async {
        await openDialog(tester);

        await tester.tap(find.text(addNameButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Dog park');
        await tester.pump();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNothing);
        expect(find.text(addNameButtonLabel), findsOneWidget);
      });

      testWidgets(
        'should show edit button and hide the name field on save button tap',
        (tester) async {
          await openDialog(tester);

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'Dog park');
          await tester.pump();

          await tester.tap(find.byIcon(Icons.check));
          await tester.pumpAndSettle();

          expect(find.text('Dog park'), findsOneWidget);
          expect(find.byType(TextField), findsNothing);
        },
      );
    });

    group('editing name', () {
      Future<void> saveInitialName(WidgetTester tester) async {
        await openDialog(tester);

        await tester.tap(find.text(addNameButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Dog park');
        await tester.pump();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();
      }

      testWidgets(
        'should show name field prefilled with spot name on edit button tap',
        (tester) async {
          await saveInitialName(tester);

          await tester.tap(find.text('Dog park'));
          await tester.pumpAndSettle();

          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.controller?.text, 'Dog park');
        },
      );

      testWidgets('should not save any changes on cancel button tap', (
        tester,
      ) async {
        await saveInitialName(tester);

        await tester.tap(find.text('Dog park'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Big tree');
        await tester.pump();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.text('Dog park'), findsOneWidget);
      });

      testWidgets('should save any changes on save button tap', (tester) async {
        await saveInitialName(tester);

        await tester.tap(find.text('Dog park'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Big tree');
        await tester.pump();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text('Big tree'), findsOneWidget);
        expect(find.text('Dog park'), findsNothing);
      });
    });

    testWidgets('should remove name on delete tap', (tester) async {
      await openDialog(tester);

      await tester.tap(find.text(addNameButtonLabel));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Dog park');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text(addNameButtonLabel), findsOneWidget);
      expect(find.text('Dog park'), findsNothing);
    });
  });

  group('view details', () {
    testWidgets('navigates to spot on tap', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => MarkSpotSuccess(spotKey: spotKey),
                  ),
                  child: const Text('Open dialog'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/active-spots/:id',
            builder: (context, state) =>
                const Scaffold(body: Text('Spot detail screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [locationProvider.overrideWith(() => fakeNotifier)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(viewDetailsButtonLabel));
      await tester.pumpAndSettle();

      expect(find.text('Spot detail screen'), findsOneWidget);
    });
  });

  group('back to walk', () {
    testWidgets('closes dialog on tap', (tester) async {
      await openDialog(tester);

      await tester.tap(find.text(backToWalkButtonLabel));
      await tester.pumpAndSettle();

      expect(find.text(spotMarkedTitle), findsNothing);
    });
  });
}
