import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/services/geolocator_service.dart';
import 'package:be_right_bark/utils/permissions.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_button/mark_spot_button.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_button/constants.dart';
import '../../helpers/fake_location_notifier.dart';

final _testPosition = Position(
  latitude: 51.5074,
  longitude: -0.1278,
  timestamp: DateTime.now(),
  accuracy: 10,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

class MockGeolocatorService extends GeolocatorService {
  @override
  Future<Position> getCurrentPosition() async => _testPosition;
}

class SlowGeolocatorService extends GeolocatorService {
  final Completer<Position> completer = Completer<Position>();

  @override
  Future<Position> getCurrentPosition() => completer.future;
}

void main() {
  late FakeLocationNotifier fakeNotifier;

  setUp(() {
    fakeNotifier = FakeLocationNotifier();
  });

  Widget buildApp({
    required GeolocatorService geoService,
    LocationPermissionStatus permission = LocationPermissionStatus.denied,
  }) {
    return ProviderScope(
      overrides: [
        locationProvider.overrideWith(() => fakeNotifier),
        userPositionProvider.overrideWith((ref) => Stream.value(null)),
        geolocatorServiceProvider.overrideWithValue(geoService),
        locationPermissionProvider.overrideWith((_) => permission),
      ],
      child: const MaterialApp(home: Scaffold(body: MarkSpotButton())),
    );
  }

  group('location service disabled', () {
    testWidgets('should show location settings dialog on button tap', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(geoService: MockGeolocatorService()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(buttonLabel));
      await tester.pumpAndSettle();

      expect(find.text(locationAccessTitle), findsOneWidget);
      expect(find.textContaining('enable location access'), findsOneWidget);
    });
  });

  group('location services enabled', () {
    group('loading state', () {
      testWidgets('should show loading overlay on tap', (tester) async {
        final slowService = SlowGeolocatorService();

        await tester.pumpWidget(
          buildApp(
            geoService: slowService,
            permission: LocationPermissionStatus.granted,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(buttonLabel));
        await tester.pump();

        expect(find.text(loadingMessage), findsOneWidget);

        // Complete the future to avoid pending timers
        slowService.completer.complete(_testPosition);
        await tester.pumpAndSettle();
      });

      testWidgets(
        'should cancel request and close loading overlay on cancel button tap',
        (tester) async {
          final slowService = SlowGeolocatorService();

          await tester.pumpWidget(
            buildApp(
              geoService: slowService,
              permission: LocationPermissionStatus.granted,
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.text(buttonLabel));
          await tester.pump();

          expect(find.text(loadingMessage), findsOneWidget);

          await tester.tap(find.text(cancelButtonLabel));
          await tester.pumpAndSettle();

          expect(find.text(loadingMessage), findsNothing);

          // Complete the future to avoid pending timers
          slowService.completer.complete(_testPosition);
          await tester.pumpAndSettle();

          // Spot should not be saved after cancel
          final container = ProviderScope.containerOf(
            tester.element(find.byType(MarkSpotButton)),
          );
          expect(container.read(locationProvider), isEmpty);
        },
      );
    });

    group('success state', () {
      testWidgets('should show success dialog', (tester) async {
        await tester.pumpWidget(
          buildApp(
            geoService: MockGeolocatorService(),
            permission: LocationPermissionStatus.granted,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(buttonLabel));
        await tester.pumpAndSettle();

        expect(find.text('Spot marked!'), findsOneWidget);
      });
    });
  });
}
