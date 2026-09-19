import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:be_right_bark/models/location.dart';

class LocationNotifier extends Notifier<List<Location>> {
  static const String boxName = 'locations';
  Box<Location> get _box => Hive.box<Location>(boxName);

  @override
  List<Location> build() {
    return _box.values.toList();
  }

  Location? getByKey(dynamic key) => _box.get(key);

  Future<int> addLocation(Location location) async {
    final key = await _box.add(location);
    state = _box.values.toList();
    return key;
  }

  Future<int> saveFromPosition(Position position) async {
    try {
      return await addLocation(
        Location(
          latitude: position.latitude,
          longitude: position.longitude,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      throw Exception('Failed to save spot. Please try again.');
    }
  }

  Future<void> deleteLocation(int key) async {
    await _box.delete(key);
    state = _box.values.toList();
  }

  Future<void> clearLocations() async {
    await _box.clear();
    state = _box.values.toList();
  }

  Future<void> updateName(int key, String? name) async {
    final location = _box.get(key);
    if (location == null) return;

    location.name = name;
    await location.save();
    state = _box.values.toList();
  }

  Future<void> updateDescription(int key, String? description) async {
    final location = _box.get(key);
    if (location == null) return;

    location.description = description;
    await location.save();
    state = _box.values.toList();
  }
}

final locationProvider = NotifierProvider<LocationNotifier, List<Location>>(
  LocationNotifier.new,
);
