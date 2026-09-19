import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/utils/distance.dart';

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
  test('should return "Unknown distance" when user position is null', () {
    expect(formatDistance(null, 51.5074, -0.1278), 'Unknown distance');
  });

  test('should return distance in meters when under 1km', () {
    final position = _makePosition(51.5074, -0.1278);
    final result = formatDistance(position, 51.5080, -0.1280);

    expect(result, endsWith('m away'));
    expect(result, isNot(contains('km')));
  });

  test('should return distance in kilometres when 1km or over', () {
    final position = _makePosition(51.5074, -0.1278);
    // ~11km away
    final result = formatDistance(position, 51.6074, -0.1278);

    expect(result, endsWith('km away'));
  });

  test('should return 0m when positions are identical', () {
    final position = _makePosition(51.5074, -0.1278);
    final result = formatDistance(position, 51.5074, -0.1278);

    expect(result, '0m away');
  });
}
