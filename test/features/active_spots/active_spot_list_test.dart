import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/features/active_spots/active_spot_list.dart';
import 'package:be_right_bark/features/active_spots/active_spot_card.dart';
import '../../helpers/test_locations.dart';

void main() {
  final testLocations = createTestLocations(3);

  Widget buildApp({required List<Location> locations, int? count}) {
    return MaterialApp(
      home: Scaffold(
        body: ActiveSpotsCardList(locations: locations, count: count),
      ),
    );
  }

  testWidgets('Should render all locations when no count is provided', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(locations: testLocations));

    expect(find.byType(ActiveSpotCard), findsNWidgets(3));
  });

  testWidgets('Should limit the list when count is provided', (tester) async {
    await tester.pumpWidget(buildApp(locations: testLocations, count: 1));

    expect(find.byType(ActiveSpotCard), findsOneWidget);
  });

  testWidgets('Should render an empty list when locations is empty', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(locations: []));

    expect(find.byType(ActiveSpotCard), findsNothing);
  });
}
