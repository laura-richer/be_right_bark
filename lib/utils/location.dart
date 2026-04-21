import 'package:geolocator/geolocator.dart';
import '/models/location.dart';
import '/servivces/location.dart';
import '/utils/permissions.dart';

Future<void> saveLocation() async {
  if (!hasLocationPermission) return;

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.lowest,
    ),
  );

  final locationService = LocationService();
  await locationService.addLocation(
    Location(
      latitude: position.latitude,
      longitude: position.longitude,
      createdAt: DateTime.now(),
    ),
  );
}
