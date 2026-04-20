import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '/models/location.dart';
import '/servivces/location.dart';

// Future<void> getLocationPermissions() async {
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     setState(() {
//       _loading = false;
//       _locationLabel = 'Location unavailable';
//     });
//     return;
//   }

//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever) {
//     setState(() {
//       _loading = false;
//       _locationLabel = 'Permission denied';
//     });
//     return;
//   }

//   final position = await Geolocator.getCurrentPosition();
//   setState(() {
//     _loading = false;
//     _position = position;
//     _locationLabel =
//         '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
//   });
// }

Future<void> saveLocation() async {
  final LocationService locationService = LocationService();

  await locationService.addLocation(
    Location(
      id: DateTime.now().millisecondsSinceEpoch,
      latitude: 53.65,
      longitude: 54.23,
      createdAt: DateTime.now(),
    ),
  );
}
