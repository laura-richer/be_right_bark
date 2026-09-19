import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasRequestedKey = 'location_permission_requested';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

final locationPermissionProvider =
    StateProvider<LocationPermissionStatus>((_) => LocationPermissionStatus.denied);

Future<LocationPermissionStatus> initLocationPermission() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return LocationPermissionStatus.serviceDisabled;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    final prefs = await SharedPreferences.getInstance();
    final hasAsked = prefs.getBool(_hasRequestedKey) ?? false;

    if (!hasAsked) {
      await prefs.setBool(_hasRequestedKey, true);
      permission = await Geolocator.requestPermission();
    }
  }

  return _mapPermission(permission);
}

LocationPermissionStatus _mapPermission(LocationPermission permission) {
  switch (permission) {
    case LocationPermission.whileInUse:
    case LocationPermission.always:
      return LocationPermissionStatus.granted;
    case LocationPermission.deniedForever:
      return LocationPermissionStatus.deniedForever;
    default:
      return LocationPermissionStatus.denied;
  }
}
