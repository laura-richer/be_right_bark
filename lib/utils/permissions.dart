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

/// Whether the app can see location while it's closed, which geofences need
/// in order to fire. "While using the app" isn't enough.
Future<bool> hasBackgroundLocation() async {
  return await Geolocator.checkPermission() == LocationPermission.always;
}

/// Asks for "Allow all the time".
///
/// iOS can upgrade from "While using" with a system prompt, but only once.
/// Android 11 and later never offer it in a prompt at all. So if the request
/// doesn't come back as always, this opens the app's settings page for the
/// user to change it there.
///
/// Returns true only when the permission is already granted on return.
Future<bool> requestBackgroundLocation() async {
  final permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.always) return true;

  await Geolocator.openAppSettings();
  return false;
}
