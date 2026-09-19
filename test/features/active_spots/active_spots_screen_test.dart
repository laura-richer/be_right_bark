import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/features/active_spots/active_spots_screen/active_spots_screen.dart';
import 'package:be_right_bark/features/active_spots/active_spots_screen/constants.dart';
import 'package:be_right_bark/widgets/confirmation/constants.dart';
import '../../helpers/fake_location_notifier.dart';
import '../../helpers/test_locations.dart';

void main() {
  late FakeLocationNotifier fakeNotifier;

  setUp(() {
    fakeNotifier = FakeLocationNotifier();
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        locationProvider.overrideWith(() => fakeNotifier),
        userPositionProvider.overrideWith((ref) => Stream.value(null)),
      ],
      child: const MaterialApp(home: Scaffold(body: ActiveSpotsScreen())),
    );
  }

  group('There are no active spots', () {
    testWidgets('Should render an empty state', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('No marked spots yet'), findsOneWidget);
    });

    testWidgets('Should not render the clear all button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text(clearAllButtonLabel), findsNothing);
    });
  });

  group('There are active spots', () {
    setUp(() {
      for (final location in createTestLocations(2)) {
        fakeNotifier.seed(location);
      }
    });

    testWidgets('should render a list of active spots', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final locations = createTestLocations(2);
      expect(find.text(locations[0].name!), findsOneWidget);
      expect(find.text(locations[1].name!), findsOneWidget);
    });

    testWidgets('should render the clear all button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text(clearAllButtonLabel), findsOneWidget);
    });

    group('when the clear all button is tapped', () {
      testWidgets('should show a confirmation', (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Clear all'));
        await tester.pumpAndSettle();

        expect(find.text(confirmationTitle), findsOneWidget);
      });

      testWidgets(
        'should close the confirmation if the cancel button is tapped',
        (tester) async {
          await tester.pumpWidget(buildApp());
          await tester.pumpAndSettle();

          await tester.tap(find.text(clearAllButtonLabel));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          expect(find.text(confirmationTitle), findsNothing);
          expect(find.text('Clear all'), findsOneWidget);
        },
      );
    });

    testWidgets(
      'should clear all spots and revert to the empty state if confirm is tapped',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text(clearAllButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text(confirmationTitle), findsNothing);
        expect(find.text(clearAllButtonLabel), findsNothing);
        expect(find.textContaining('No marked spots yet'), findsOneWidget);
        final locations = createTestLocations(2);
        expect(find.text(locations[0].name!), findsNothing);
        expect(find.text(locations[1].name!), findsNothing);
      },
    );
  });
}
