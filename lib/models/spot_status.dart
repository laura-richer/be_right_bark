import 'package:hive/hive.dart';

part 'spot_status.g.dart';

@HiveType(typeId: 1)
enum SpotStatus {
  @HiveField(0)
  dropped, // marked, user still nearby, rings not live

  @HiveField(1)
  armed, // user has left a ring, reminder is live

  @HiveField(2)
  notified, // first alert sent, second may still follow

  @HiveField(3)
  collected, // picked up — counts for Good Human

  @HiveField(4)
  abandoned, // gave up — doesn't count
}
