import 'package:hive/hive.dart';
import 'package:be_right_bark/models/spot_status.dart';

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

  @HiveField(6)
  SpotStatus? status;

  @HiveField(7)
  DateTime? notifiedAt;

  @HiveField(8)
  DateTime? resolvedAt;

  @HiveField(9)
  bool? fencesRegistered;

  Location({
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.name,
    this.description,
    this.status,
    this.notifiedAt,
    this.resolvedAt,
    this.fencesRegistered,
  });

  SpotStatus get spotStatus => status ?? SpotStatus.dropped;

  bool get isActive =>
      spotStatus != SpotStatus.collected && spotStatus != SpotStatus.abandoned;

  bool get needsFences => isActive && !(fencesRegistered ?? false);
}
