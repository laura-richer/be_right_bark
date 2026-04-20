import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  @HiveField(3)
  DateTime? createdAt;

  @HiveField(4)
  String? name;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    this.name,
  });
}
