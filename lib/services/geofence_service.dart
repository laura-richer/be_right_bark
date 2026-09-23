import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Prefixed because the package has its own Location class, which would
// clash with our Location model.
import 'package:native_geofence/native_geofence.dart' as geo;
import 'package:be_right_bark/domain/spot_machine.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/models/spot_status.dart';
import 'package:be_right_bark/services/notification_service.dart';

/// The heads-up ring. Watched for enter and exit: leaving it arms the spot,
/// coming back into it fires the first alert.
const double outerRadiusMeters = 200;

/// The close ring. Watched for enter only: it escalates to the second alert.
const double innerRadiusMeters = 100;

/// Android needs an expiry on every geofence. Spots are rarely left this long,
/// and the startup check re-registers any fences the OS has dropped.
const Duration _fenceExpiry = Duration(days: 30);

const String _locationsBoxName = 'locations';
const String _fencePrefix = 'brb_';

enum _Ring { outer, inner }

/// Fence ids are built from the spot's createdAt, which never changes and is
/// never reused, so a stale fence can't collide with a newer spot.
String outerFenceId(DateTime createdAt) =>
    '$_fencePrefix${createdAt.millisecondsSinceEpoch}_o';

String innerFenceId(DateTime createdAt) =>
    '$_fencePrefix${createdAt.millisecondsSinceEpoch}_i';

/// Reads a fence id back into the spot it belongs to and which ring it is.
/// Returns null for anything that isn't one of ours.
({int createdAtMs, _Ring ring})? _parseFenceId(String id) {
  if (!id.startsWith(_fencePrefix)) return null;

  final parts = id.substring(_fencePrefix.length).split('_');
  if (parts.length != 2) return null;

  final createdAtMs = int.tryParse(parts[0]);
  final ring = switch (parts[1]) {
    'o' => _Ring.outer,
    'i' => _Ring.inner,
    _ => null,
  };
  if (createdAtMs == null || ring == null) return null;

  return (createdAtMs: createdAtMs, ring: ring);
}

/// Sets the plugin up. Call once from main() before registering any fences.
Future<void> initGeofencing() {
  return geo.NativeGeofenceManager.instance.initialize();
}

/// Registers both rings around a spot.
///
/// Throws [geo.NativeGeofenceException] if it fails, most often because
/// background location hasn't been granted. The caller decides what to do
/// with the spot in that case.
Future<void> registerSpotFences(Location spot) async {
  final centre = geo.Location(
    latitude: spot.latitude,
    longitude: spot.longitude,
  );

  // No initial triggers: we don't want an event just for registering a fence
  // while standing inside it. The dropped status would ignore it anyway.
  const android = geo.AndroidGeofenceSettings(
    initialTriggers: <geo.GeofenceEvent>{},
    expiration: _fenceExpiry,
  );
  const ios = geo.IosGeofenceSettings(initialTrigger: false);

  final manager = geo.NativeGeofenceManager.instance;

  await manager.createGeofence(
    geo.Geofence(
      id: outerFenceId(spot.createdAt),
      location: centre,
      radiusMeters: outerRadiusMeters,
      triggers: {geo.GeofenceEvent.enter, geo.GeofenceEvent.exit},
      iosSettings: ios,
      androidSettings: android,
    ),
    onGeofenceEvent,
  );

  await manager.createGeofence(
    geo.Geofence(
      id: innerFenceId(spot.createdAt),
      location: centre,
      radiusMeters: innerRadiusMeters,
      triggers: {geo.GeofenceEvent.enter},
      iosSettings: ios,
      androidSettings: android,
    ),
    onGeofenceEvent,
  );
}

/// Tries to register a spot's fences and records the outcome on the spot.
///
/// Never throws. A failure, usually missing background location, is saved
/// as fencesRegistered false so the startup check can retry later.
Future<bool> registerAndRecordFences(Location spot) async {
  try {
    await registerSpotFences(spot);
    spot.fencesRegistered = true;
  } catch (e) {
    debugPrint('[geofence] registration failed: $e');
    spot.fencesRegistered = false;
  }
  await spot.save();
  return spot.fencesRegistered!;
}

/// Removes both rings for a spot.
///
/// Best effort, and never throws, so deleting a spot is never blocked by the
/// OS. If a removal fails, [removeOrphanFences] cleans the fence up on the
/// next launch.
Future<void> removeSpotFences(DateTime createdAt) async {
  final manager = geo.NativeGeofenceManager.instance;

  for (final id in [outerFenceId(createdAt), innerFenceId(createdAt)]) {
    try {
      await manager.removeGeofenceById(id);
    } on geo.NativeGeofenceException catch (e) {
      if (e.code == geo.NativeGeofenceErrorCode.geofenceNotFound) continue;
      debugPrint('[geofence] failed to remove $id: $e');
    }
  }
}

/// Removes every fence the app has registered, for when all spots are
/// cleared at once. Best effort, like [removeSpotFences].
Future<void> removeAllSpotFences() async {
  try {
    await geo.NativeGeofenceManager.instance.removeAllGeofences();
  } catch (e) {
    debugPrint('[geofence] failed to remove all fences: $e');
  }
}

/// Removes any registered fence whose spot no longer exists.
///
/// The safety net behind the best-effort removals above. Call on startup,
/// once the locations box is open.
Future<void> removeOrphanFences(Iterable<Location> spots) async {
  final List<String> registered;
  try {
    registered =
        await geo.NativeGeofenceManager.instance.getRegisteredGeofenceIds();
  } catch (e) {
    debugPrint('[geofence] could not list fences: $e');
    return;
  }

  final liveSpots = {
    for (final spot in spots) spot.createdAt.millisecondsSinceEpoch,
  };

  for (final id in registered) {
    final parsed = _parseFenceId(id);
    if (parsed == null || liveSpots.contains(parsed.createdAtMs)) continue;

    debugPrint('[geofence] removing orphan fence $id');
    try {
      await geo.NativeGeofenceManager.instance.removeGeofenceById(id);
    } catch (e) {
      debugPrint('[geofence] failed to remove orphan $id: $e');
    }
  }
}

SpotEvent? _toSpotEvent(_Ring ring, geo.GeofenceEvent event) {
  return switch ((ring, event)) {
    (_Ring.outer, geo.GeofenceEvent.exit) => SpotEvent.outerExit,
    (_Ring.outer, geo.GeofenceEvent.enter) => SpotEvent.outerEnter,
    (_Ring.inner, geo.GeofenceEvent.enter) => SpotEvent.innerEnter,
    _ => null,
  };
}

/// Called by the OS when you cross one of the rings, usually while the app is
/// closed.
///
/// Runs in a separate background isolate with none of the app's state: no
/// Riverpod, no open Hive box, no initialised notifications. Everything it
/// needs is set up from cold here.
///
/// Must stay top level and keep the vm:entry-point annotation, or tree shaking
/// removes it from release builds and fences silently stop doing anything.
@pragma('vm:entry-point')
Future<void> onGeofenceEvent(geo.GeofenceCallbackParams params) async {
  debugPrint('[geofence] ${params.event.name} for '
      '${params.geofences.map((f) => f.id).join(', ')}');

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(LocationAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(SpotStatusAdapter());
  await initNotifications();

  final box = await Hive.openBox<Location>(_locationsBoxName);
  try {
    for (final fence in params.geofences) {
      await _handleFence(box, fence.id, params.event);
    }
  } finally {
    await box.close();
  }
}

Future<void> _handleFence(
  Box<Location> box,
  String fenceId,
  geo.GeofenceEvent geofenceEvent,
) async {
  final parsed = _parseFenceId(fenceId);
  if (parsed == null) return;

  final event = _toSpotEvent(parsed.ring, geofenceEvent);
  if (event == null) return;

  // The spot may already have been picked up, with an event still in flight.
  final key = _keyForSpot(box, parsed.createdAtMs);
  if (key == null) return;
  final spot = box.get(key);
  if (spot == null) return;

  final transition = reduce(
    status: spot.spotStatus,
    notifiedAt: spot.notifiedAt,
    event: event,
    now: DateTime.now(),
  );
  if (!transition.changedFrom(spot.spotStatus, spot.notifiedAt)) return;

  final alert = transition.notify;
  debugPrint('[geofence] spot $key: ${spot.spotStatus.name} -> '
      '${transition.status.name}'
      '${alert == null ? '' : ', alert: ${alert.name}'}');

  spot
    ..status = transition.status
    ..notifiedAt = transition.notifiedAt;
  await spot.save();

  if (alert != null) {
    await showSpotAlert(
      kind: alert,
      spotCreatedAt: spot.createdAt,
      spotKey: key,
      spotName: spot.name,
    );
  }
}

int? _keyForSpot(Box<Location> box, int createdAtMs) {
  for (final key in box.keys) {
    if (box.get(key)?.createdAt.millisecondsSinceEpoch == createdAtMs) {
      return key as int;
    }
  }
  return null;
}
