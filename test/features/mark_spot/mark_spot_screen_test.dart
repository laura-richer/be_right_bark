import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/services/geolocator_service.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_screen/mark_spot_screen.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_screen/constants.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_button/mark_spot_button.dart';
import 'package:be_right_bark/features/active_spots/active_spot_card.dart';
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
        geolocatorServiceProvider.overrideWithValue(GeolocatorService()),
      ],
      child: const MaterialApp(home: Scaffold(body: MarkSpotScreen())),
    );
  }

  Widget buildAppWithRouter() {
    final router = GoRouter(
      initialLocation: '/mark-spot',
      routes: [
        GoRoute(
          path: '/mark-spot',
          builder: (context, state) => const Scaffold(body: MarkSpotScreen()),
        ),
        GoRoute(
          path: '/active-spots',
          builder: (context, state) =>
              const Scaffold(body: Text('Active spots screen')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        locationProvider.overrideWith(() => fakeNotifier),
        userPositionProvider.overrideWith((ref) => Stream.value(null)),
        geolocatorServiceProvider.overrideWithValue(GeolocatorService()),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('should show the mark spot button', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(MarkSpotButton), findsOneWidget);
  });

  group('user has marked spots', () {
    setUp(() {
      for (final location in createTestLocations(2)) {
        fakeNotifier.seed(location);
      }
    });

    testWidgets('should show nearest marked spot', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text(nearestSpotTitle), findsOneWidget);
      expect(find.byType(ActiveSpotCard), findsOneWidget);
    });

    testWidgets('should show `see all` button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text(seeAllButtonLabel), findsOneWidget);
    });

    testWidgets(
      'should navigate to `active spots` screen on `see all` button tap',
      (tester) async {
        await tester.pumpWidget(buildAppWithRouter());
        await tester.pumpAndSettle();

        await tester.tap(find.text(seeAllButtonLabel));
        await tester.pumpAndSettle();

        expect(find.text('Active spots screen'), findsOneWidget);
      },
    );
  });

  group('user has no marked spots', () {
    testWidgets('should not show the nearest spot', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Nearest spot'), findsNothing);
      expect(find.byType(ActiveSpotCard), findsNothing);
      expect(find.text('See all'), findsNothing);
    });
  });
}
