import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasRequestedKey = 'location_permission_requested';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

LocationPermissionStatus? _cachedStatus;

LocationPermissionStatus get locationPermissionStatus =>
    _cachedStatus ?? LocationPermissionStatus.denied;

bool get hasLocationPermission =>
    _cachedStatus == LocationPermissionStatus.granted;

Future<LocationPermissionStatus> initLocationPermission() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    _cachedStatus = LocationPermissionStatus.serviceDisabled;
    return _cachedStatus!;
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

  _cachedStatus = _mapPermission(permission);
  return _cachedStatus!;
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
