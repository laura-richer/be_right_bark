import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/utils/permissions.dart';

class UserPositionBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Position? position) builder;

  const UserPositionBuilder({super.key, required this.builder});

  @override
  State<UserPositionBuilder> createState() => _UserPositionBuilderState();
}

class _UserPositionBuilderState extends State<UserPositionBuilder> {
  Position? _position;
  StreamSubscription<Position>? _subscription;

  @override
  void initState() {
    super.initState();
    if (!hasLocationPermission) return;

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.lowest,
        distanceFilter: 10,
      ),
    ).listen(
      (position) {
        if (mounted) setState(() => _position = position);
      },
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _position);
  }
}
