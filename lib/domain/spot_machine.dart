import 'package:be_right_bark/models/spot_status.dart';

/// Minimum gap between two notifications for the same spot.
///
/// Geofence transitions can be delivered late, so a slow `outerEnter` and a
/// prompt `innerEnter` may arrive seconds apart. Without this guard the user
/// gets buzzed twice in a row for a bag they already know about.
const Duration notifyCooldown = Duration(seconds: 90);

/// Things that can happen to a spot.
///
/// The three ring events come from the OS geofence callback. The two user
/// events come from the UI or a notification action.
enum SpotEvent {
  outerExit,
  outerEnter,
  innerEnter,
  userCollected,
  userAbandoned,
}

/// Which notification to show.
enum NotifyKind {
  /// Crossed the 200m ring — a heads up.
  approaching,

  /// Crossed the 100m ring — close enough to divert.
  arrived,
}

/// The complete result of applying an event to a spot.
///
/// Always describes the full new state rather than a diff, so the caller can
/// write it straight back without working out what changed.
class SpotTransition {
  final SpotStatus status;
  final DateTime? notifiedAt;
  final NotifyKind? notify;
  final bool removeFences;

  const SpotTransition({
    required this.status,
    this.notifiedAt,
    this.notify,
    this.removeFences = false,
  });

  /// True when the caller needs to persist or act on this transition.
  bool changedFrom(SpotStatus previousStatus, DateTime? previousNotifiedAt) {
    return status != previousStatus ||
        notifiedAt != previousNotifiedAt ||
        notify != null ||
        removeFences;
  }
}

/// Decides what happens to a spot when [event] occurs.
///
/// Pure: no storage, no plugins, no clock. Pass [now] in so tests can control
/// the cooldown window.
SpotTransition reduce({
  required SpotStatus status,
  required DateTime? notifiedAt,
  required SpotEvent event,
  required DateTime now,
}) {
  final unchanged = SpotTransition(status: status, notifiedAt: notifiedAt);

  switch (status) {
    // Marked, user still nearby. Rings are not live until they leave one.
    case SpotStatus.dropped:
      switch (event) {
        case SpotEvent.outerExit:
          return SpotTransition(
            status: SpotStatus.armed,
            notifiedAt: notifiedAt,
          );
        case SpotEvent.userCollected:
          return _resolve(SpotStatus.collected, notifiedAt);
        case SpotEvent.userAbandoned:
          return _resolve(SpotStatus.abandoned, notifiedAt);
        // Entering a ring you never left is spurious — ignore it.
        case SpotEvent.outerEnter:
        case SpotEvent.innerEnter:
          return unchanged;
      }

    // User has left a ring. The next entry fires the first alert.
    case SpotStatus.armed:
      switch (event) {
        case SpotEvent.outerEnter:
          return _maybeNotify(
            NotifyKind.approaching,
            notifiedAt,
            now,
            unchanged,
          );
        // Covers the short walk where the outer ring was never crossed.
        case SpotEvent.innerEnter:
          return _maybeNotify(NotifyKind.arrived, notifiedAt, now, unchanged);
        case SpotEvent.userCollected:
          return _resolve(SpotStatus.collected, notifiedAt);
        case SpotEvent.userAbandoned:
          return _resolve(SpotStatus.abandoned, notifiedAt);
        case SpotEvent.outerExit:
          return unchanged;
      }

    // First alert sent. Only the inner ring escalates.
    case SpotStatus.notified:
      switch (event) {
        // Walked off again without collecting — re-arm for the next approach.
        // notifiedAt is deliberately kept so the cooldown still applies.
        case SpotEvent.outerExit:
          return SpotTransition(
            status: SpotStatus.armed,
            notifiedAt: notifiedAt,
          );
        case SpotEvent.innerEnter:
          return _maybeNotify(NotifyKind.arrived, notifiedAt, now, unchanged);
        case SpotEvent.outerEnter:
          return unchanged;
        case SpotEvent.userCollected:
          return _resolve(SpotStatus.collected, notifiedAt);
        case SpotEvent.userAbandoned:
          return _resolve(SpotStatus.abandoned, notifiedAt);
      }

    // Terminal. Late geofence events can still arrive — ignore them.
    case SpotStatus.collected:
    case SpotStatus.abandoned:
      return unchanged;
  }
}

SpotTransition _resolve(SpotStatus status, DateTime? notifiedAt) {
  return SpotTransition(
    status: status,
    notifiedAt: notifiedAt,
    removeFences: true,
  );
}

SpotTransition _maybeNotify(
  NotifyKind kind,
  DateTime? notifiedAt,
  DateTime now,
  SpotTransition unchanged,
) {
  final tooSoon =
      notifiedAt != null && now.difference(notifiedAt) < notifyCooldown;
  if (tooSoon) return unchanged;

  return SpotTransition(
    status: SpotStatus.notified,
    notifiedAt: now,
    notify: kind,
  );
}
