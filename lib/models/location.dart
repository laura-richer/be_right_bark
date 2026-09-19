import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  String? name;

  @HiveField(5)
  String? description;

  Location({
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.name,
    this.description,
  });
}
