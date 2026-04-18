import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '/widgets/common/buttons/button_large.dart';

class MarkSpotButton extends StatefulWidget implements PreferredSizeWidget {
  const MarkSpotButton({super.key});

  @override
  State<MarkSpotButton> createState() => _MarkSpotButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MarkSpotButtonState extends State<MarkSpotButton> {
  Position? _position;
  String? _locationLabel;
  bool _loading = false;

  Future<void> _fetchLocation() async {
    setState(() {
      _loading = true;
      _locationLabel = null;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
        _locationLabel = 'Location unavailable';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
        _locationLabel = 'Permission denied';
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _loading = false;
      _position = position;
      _locationLabel =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ButtonLarge(
      buttonText: 'Mark spot',
      subtitle: _loading ? 'Fetching location...' : _locationLabel,
      image: 'lib/assets/mark_spot_icon.png',
      onPressed: _loading
          ? null
          : () async {
              await _fetchLocation();

              if (mounted && _position != null) {
                context.go('/mark-spot/detail', extra: _position);
              }
            },
    );
  }
}
