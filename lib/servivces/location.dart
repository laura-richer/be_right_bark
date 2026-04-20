import 'package:hive/hive.dart';
import '/models/location.dart';

class LocationService {
  static const String boxName = 'locations';
  Box<Location> get _box => Hive.box<Location>(boxName);

  List<Location> getAll() => _box.values.toList();

  Future<Box<Location>> _openBox() async {
    return await Hive.openBox<Location>(boxName);
  }

  Future<List<Location>> getLocations() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> addLocation(Location location) async {
    final box = await _openBox();
    await box.add(location);
  }

  Future<void> deleteLocation(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }

  Future<void> clearLocations() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<void> updateLocation(int index, Location location) async {
    final box = await _openBox();
    await box.putAt(index, location);
  }
}
