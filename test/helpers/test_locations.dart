import 'package:be_right_bark/models/location.dart';

final _testData = [
  (lat: 51.5074, lng: -0.1278, name: 'Dog park'),
  (lat: 51.5080, lng: -0.1280, name: 'Big tree'),
  (lat: 51.5090, lng: -0.1290, name: 'Pond'),
  (lat: 51.5100, lng: -0.1300, name: 'Corner shop'),
  (lat: 51.5110, lng: -0.1310, name: 'Bus stop'),
];

List<Location> createTestLocations(int count) {
  return List.generate(count, (i) {
    final data = _testData[i % _testData.length];
    return Location(
      latitude: data.lat,
      longitude: data.lng,
      createdAt: DateTime(2026, 6, 1, 10 + i, 30),
      name: data.name,
    );
  });
}
