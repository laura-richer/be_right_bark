import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/location.dart';

class LocationsBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, List<Location> locations)
      builder;

  const LocationsBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Location>('locations');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Location> box, _) {
        return builder(context, box.values.toList());
      },
    );
  }
}

class LocationBuilder extends StatelessWidget {
  final dynamic locationKey;
  final Widget Function(BuildContext context, Location? location) builder;

  const LocationBuilder({
    super.key,
    required this.locationKey,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Location>('locations');

    return ValueListenableBuilder(
      valueListenable: box.listenable(keys: [locationKey]),
      builder: (context, Box<Location> box, _) {
        return builder(context, box.get(locationKey));
      },
    );
  }
}
