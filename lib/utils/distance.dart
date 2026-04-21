import 'package:geolocator/geolocator.dart';

String formatDistance(Position userPosition, double lat, double lng) {
  final meters = Geolocator.distanceBetween(
    userPosition.latitude,
    userPosition.longitude,
    lat,
    lng,
  );

  if (meters < 1000) {
    return '${meters.round()}m away';
  }
  return '${(meters / 1000).toStringAsFixed(1)}km away';
}
