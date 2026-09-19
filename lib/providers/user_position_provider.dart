import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/utils/permissions.dart';

final userPositionProvider = StreamProvider<Position?>((ref) {
  final locations = ref.watch(locationProvider);
  if (locations.isEmpty) return Stream.value(null);

  final permission = ref.watch(locationPermissionProvider);
  if (permission != LocationPermissionStatus.granted) return Stream.value(null);

  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
});
