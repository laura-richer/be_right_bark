import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } on LocationServiceDisabledException {
      throw Exception(
        'Location services are disabled. Please enable them in your device settings.',
      );
    } on PermissionDeniedException {
      throw Exception('Location permission was denied.');
    } catch (e) {
      throw Exception('Failed to get location. Please try again.');
    }
  }
}

final geolocatorServiceProvider = Provider<GeolocatorService>((ref) {
  return GeolocatorService();
});
