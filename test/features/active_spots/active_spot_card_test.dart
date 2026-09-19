import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/features/active_spots/active_spot_card.dart';
import '../../helpers/test_locations.dart';

void main() {
  final testLocation = createTestLocations(1).first;

  final unnamedLocation = Location(
    latitude: 51.5080,
    longitude: -0.1280,
    createdAt: DateTime(2026, 6, 1, 10, 30),
  );

  Widget buildApp({required Location location, String distance = '67m away'}) {
    return MaterialApp(
      home: Scaffold(
        body: ActiveSpotCard(item: location, distance: distance),
      ),
    );
  }

  testWidgets('Should show the spot name if one exists', (tester) async {
    await tester.pumpWidget(buildApp(location: testLocation));

    expect(find.text(testLocation.name!), findsOneWidget);
  });

  testWidgets('Should not show a name when location has no name', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(location: unnamedLocation));

    expect(find.text(testLocation.name!), findsNothing);
    expect(find.byType(ActiveSpotCard), findsOneWidget);
  });

  testWidgets('Should show the distance from the users current location', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(location: testLocation, distance: '67m away'),
    );

    expect(find.text('67m away'), findsOneWidget);
  });

  testWidgets('Should show the marked date and time', (tester) async {
    await tester.pumpWidget(buildApp(location: testLocation));

    expect(find.text('Marked 10:30, 1 Jun'), findsOneWidget);
  });

  testWidgets('Should navigate to the correct active spot screen on tap', (
    tester,
  ) async {
    String? navigatedTo;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: ActiveSpotCard(item: unnamedLocation, distance: '67m away'),
          ),
        ),
        GoRoute(
          path: '/active-spots/:id',
          builder: (context, state) {
            navigatedTo = state.uri.toString();
            return const Scaffold(body: Text('Detail'));
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ActiveSpotCard));
    await tester.pumpAndSettle();

    expect(navigatedTo, contains('/active-spots/'));
  });
}
