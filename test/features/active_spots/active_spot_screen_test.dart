import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/features/active_spots/active_spot_screen/active_spot_screen.dart';
import 'package:be_right_bark/features/active_spots/active_spot_screen/constants.dart';
import 'package:be_right_bark/widgets/confirmation/constants.dart';
import '../../helpers/fake_location_notifier.dart';
import '../../helpers/test_tile_provider.dart';

Position _makePosition(double lat, double lng) {
  return Position(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime.now(),
    accuracy: 10,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

void main() {
  late FakeLocationNotifier fakeNotifier;
  late int locationKey;
  late Location namedLocation;
  late Location unnamedLocation;

  final userPosition = _makePosition(51.5080, -0.1280);

  setUp(() {
    fakeNotifier = FakeLocationNotifier();
    namedLocation = Location(
      latitude: 51.5074,
      longitude: -0.1278,
      createdAt: DateTime(2026, 6, 1, 10, 30),
      name: 'Dog park',
    );
    unnamedLocation = Location(
      latitude: 51.5074,
      longitude: -0.1278,
      createdAt: DateTime(2026, 6, 1, 10, 30),
    );
  });

  Widget buildApp({
    required int id,
    Position? position,
  }) {
    return ProviderScope(
      overrides: [
        locationProvider.overrideWith(() => fakeNotifier),
        userPositionProvider.overrideWith(
          (ref) => Stream.value(position),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ActiveSpotScreen(id: id, tileProvider: TestTileProvider()),
        ),
      ),
    );
  }

  Widget buildAppWithRouter({
    required int id,
    void Function(String)? onNavigated,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            onNavigated?.call('/');
            return const Scaffold(body: Text('Home'));
          },
          routes: [
            GoRoute(
              path: 'active-spots/:id',
              builder: (context, state) => Scaffold(
                body: ActiveSpotScreen(
                  id: int.parse(state.pathParameters['id']!),
                  tileProvider: TestTileProvider(),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        locationProvider.overrideWith(() => fakeNotifier),
        userPositionProvider.overrideWith(
          (ref) => Stream.value(null),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('should show name if the location has a name', (tester) async {
    locationKey = fakeNotifier.seed(namedLocation);

    await tester.pumpWidget(buildApp(id: locationKey));
    await tester.pumpAndSettle();

    expect(find.text('Dog park'), findsOneWidget);
  });

  testWidgets('should show your current distance from the spot', (
    tester,
  ) async {
    locationKey = fakeNotifier.seed(namedLocation);

    await tester.pumpWidget(
      buildApp(id: locationKey, position: userPosition),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('away'), findsOneWidget);
  });

  testWidgets('should show time and date spot was marked', (tester) async {
    locationKey = fakeNotifier.seed(namedLocation);

    await tester.pumpWidget(buildApp(id: locationKey));
    await tester.pumpAndSettle();

    expect(find.text('Marked 10:30, 1 Jun'), findsOneWidget);
  });

  testWidgets('should show the remove button on the page', (tester) async {
    locationKey = fakeNotifier.seed(namedLocation);

    await tester.pumpWidget(buildApp(id: locationKey));
    await tester.pumpAndSettle();

    expect(find.text(removeButtonLabel), findsOneWidget);
  });

  group('remove confirmation', () {
    testWidgets('should not show the remove button', (tester) async {
      locationKey = fakeNotifier.seed(namedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text(removeButtonLabel));
      await tester.pumpAndSettle();

      expect(find.text(removeButtonLabel), findsNothing);
    });

    testWidgets('should show the remove confirmation buttons', (
      tester,
    ) async {
      locationKey = fakeNotifier.seed(namedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text(removeButtonLabel));
      await tester.pumpAndSettle();

      expect(find.text(confirmationTitle), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets(
      'should hide the remove confirmation buttons on cancel button click',
      (tester) async {
        locationKey = fakeNotifier.seed(namedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(removeButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.text(confirmationTitle), findsNothing);
        expect(find.text(removeButtonLabel), findsOneWidget);
      },
    );

    testWidgets(
      'should remove the spot and take you back to the mark spot screen on confirm remove',
      (tester) async {
        locationKey = fakeNotifier.seed(namedLocation);
        String? navigatedTo;

        await tester.pumpWidget(
          buildAppWithRouter(
            id: locationKey,
            onNavigated: (path) => navigatedTo = path,
          ),
        );
        await tester.pumpAndSettle();

        // Navigate from home to the active spot screen
        final router = GoRouter.of(
          tester.element(find.text('Home')),
        );
        router.go('/active-spots/$locationKey');
        await tester.pumpAndSettle();

        await tester.tap(find.text(removeButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(navigatedTo, '/');
        expect(fakeNotifier.getByKey(locationKey), isNull);
      },
    );
  });

  group('spot doesnt have a name', () {
    testWidgets('should not show a spot name', (tester) async {
      locationKey = fakeNotifier.seed(unnamedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      expect(find.text('Dog park'), findsNothing);
    });

    testWidgets('should show `add name` button', (tester) async {
      locationKey = fakeNotifier.seed(unnamedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      expect(find.text(addNameButtonLabel), findsOneWidget);
    });

    group('add name button clicked', () {
      testWidgets('should show dialog with text field label', (tester) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addNameButtonLabel));
        await tester.pumpAndSettle();

        expect(find.text(addNameFieldLabel), findsOneWidget);
      });

      group('on cancel', () {
        testWidgets('should close the dialog', (tester) async {
          locationKey = fakeNotifier.seed(unnamedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsNothing);
        });

        testWidgets('should not show spot name', (tester) async {
          locationKey = fakeNotifier.seed(unnamedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'New name');
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          expect(find.text('New name'), findsNothing);
        });
      });

      group('on save', () {
        testWidgets('should close the dialog', (tester) async {
          locationKey = fakeNotifier.seed(unnamedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'New name');
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.check));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsNothing);
        });

        testWidgets('should show the spot name', (tester) async {
          locationKey = fakeNotifier.seed(unnamedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'New name');
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.check));
          await tester.pumpAndSettle();

          expect(find.text('New name'), findsOneWidget);
        });

        testWidgets('should show the `edit name` button', (tester) async {
          locationKey = fakeNotifier.seed(unnamedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'New name');
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.check));
          await tester.pumpAndSettle();

          expect(find.text(editNameButtonLabel), findsOneWidget);
        });

        testWidgets('should not show the `add name` button', (tester) async {
          locationKey = fakeNotifier.seed(unnamedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(addNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'New name');
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.check));
          await tester.pumpAndSettle();

          expect(find.text(addNameButtonLabel), findsNothing);
        });
      });
    });
  });

  group('spot has name', () {
    testWidgets('should show the spot name', (tester) async {
      locationKey = fakeNotifier.seed(namedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      expect(find.text('Dog park'), findsOneWidget);
    });

    testWidgets('should show `edit name` button', (tester) async {
      locationKey = fakeNotifier.seed(namedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      expect(find.text(editNameButtonLabel), findsOneWidget);
    });

    group('edit name button is clicked', () {
      testWidgets('should show dialog with text field', (tester) async {
        locationKey = fakeNotifier.seed(namedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(editNameButtonLabel));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets(
        'should pre populate the text field with the spot name',
        (tester) async {
          locationKey = fakeNotifier.seed(namedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(editNameButtonLabel));
          await tester.pumpAndSettle();

          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.controller?.text, 'Dog park');
        },
      );

      testWidgets(
        'should close the dialog and update the name on save',
        (tester) async {
          locationKey = fakeNotifier.seed(namedLocation);

          await tester.pumpWidget(buildApp(id: locationKey));
          await tester.pumpAndSettle();

          await tester.tap(find.text(editNameButtonLabel));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), 'Updated park');
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.check));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsNothing);
          expect(find.text('Updated park'), findsOneWidget);
        },
      );

      testWidgets('should not update the name on cancel', (tester) async {
        locationKey = fakeNotifier.seed(namedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(editNameButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Updated park');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.text('Updated park'), findsNothing);
        expect(find.text('Dog park'), findsOneWidget);
      });
    });
  });

  testWidgets('should show `add description` button', (tester) async {
    locationKey = fakeNotifier.seed(unnamedLocation);

    await tester.pumpWidget(buildApp(id: locationKey));
    await tester.pumpAndSettle();

    expect(find.text(addDescriptionButtonLabel), findsOneWidget);
  });

  group('on `add description` button click', () {
    testWidgets('should show dialog', (tester) async {
      locationKey = fakeNotifier.seed(unnamedLocation);

      await tester.pumpWidget(buildApp(id: locationKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text(addDescriptionButtonLabel));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    group('on cancel', () {
      testWidgets('should close the dialog', (tester) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addDescriptionButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('should not show spot description', (tester) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addDescriptionButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'A nice spot');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.text('A nice spot'), findsNothing);
      });
    });

    group('on save', () {
      testWidgets('should close the dialog', (tester) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addDescriptionButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'A nice spot');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('should show the spot description', (tester) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addDescriptionButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'A nice spot');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text('A nice spot'), findsOneWidget);
      });

      testWidgets('should show the `edit description` button', (
        tester,
      ) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addDescriptionButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'A nice spot');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text(editDescriptionButtonLabel), findsOneWidget);
      });

      testWidgets('should not show the `add description` button', (
        tester,
      ) async {
        locationKey = fakeNotifier.seed(unnamedLocation);

        await tester.pumpWidget(buildApp(id: locationKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text(addDescriptionButtonLabel));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'A nice spot');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text(addDescriptionButtonLabel), findsNothing);
      });
    });
  });
}
