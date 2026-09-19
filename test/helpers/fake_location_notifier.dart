import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/providers/location_provider.dart';

class FakeLocationNotifier extends Notifier<List<Location>>
    implements LocationNotifier {
  final Map<int, Location> _store = {};
  int _nextKey = 0;

  @override
  List<Location> build() => _store.values.toList();

  int seed(Location location) {
    final key = _nextKey++;
    _store[key] = location;
    return key;
  }

  @override
  Location? getByKey(dynamic key) => _store[key];

  @override
  Future<int> addLocation(Location location) async {
    final key = _nextKey++;
    _store[key] = location;
    state = _store.values.toList();
    return key;
  }

  @override
  Future<int> saveFromPosition(Position position) async {
    return addLocation(
      Location(
        latitude: position.latitude,
        longitude: position.longitude,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> deleteLocation(int key) async {
    _store.remove(key);
    state = _store.values.toList();
  }

  @override
  Future<void> clearLocations() async {
    _store.clear();
    state = _store.values.toList();
  }

  @override
  Future<void> updateName(int key, String? name) async {
    _store[key]?.name = name;
    state = _store.values.toList();
  }

  @override
  Future<void> updateDescription(int key, String? description) async {
    _store[key]?.description = description;
    state = _store.values.toList();
  }
}
