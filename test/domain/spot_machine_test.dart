import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/domain/spot_machine.dart';
import 'package:be_right_bark/models/spot_status.dart';

final DateTime _now = DateTime(2026, 9, 19, 14, 30);

SpotTransition _apply(
  SpotStatus status,
  SpotEvent event, {
  DateTime? notifiedAt,
  DateTime? now,
}) {
  return reduce(
    status: status,
    notifiedAt: notifiedAt,
    event: event,
    now: now ?? _now,
  );
}

void main() {
  group('dropped', () {
    test('should arm when the user leaves the outer ring', () {
      final result = _apply(SpotStatus.dropped, SpotEvent.outerExit);

      expect(result.status, SpotStatus.armed);
      expect(result.notify, isNull);
    });

    test('should not notify on entering a ring it never left', () {
      expect(_apply(SpotStatus.dropped, SpotEvent.outerEnter).notify, isNull);
      expect(_apply(SpotStatus.dropped, SpotEvent.innerEnter).notify, isNull);
    });

    test('should stay dropped on a spurious ring entry', () {
      final result = _apply(SpotStatus.dropped, SpotEvent.innerEnter);

      expect(result.status, SpotStatus.dropped);
    });

    test('should resolve and remove fences when collected', () {
      final result = _apply(SpotStatus.dropped, SpotEvent.userCollected);

      expect(result.status, SpotStatus.collected);
      expect(result.removeFences, isTrue);
    });

    test('should resolve and remove fences when abandoned', () {
      final result = _apply(SpotStatus.dropped, SpotEvent.userAbandoned);

      expect(result.status, SpotStatus.abandoned);
      expect(result.removeFences, isTrue);
    });
  });

  group('armed', () {
    test('should notify approaching on entering the outer ring', () {
      final result = _apply(SpotStatus.armed, SpotEvent.outerEnter);

      expect(result.status, SpotStatus.notified);
      expect(result.notify, NotifyKind.approaching);
      expect(result.notifiedAt, _now);
    });

    test('should notify arrived on entering the inner ring', () {
      final result = _apply(SpotStatus.armed, SpotEvent.innerEnter);

      expect(result.status, SpotStatus.notified);
      expect(result.notify, NotifyKind.arrived);
    });

    test('should resolve and remove fences when collected', () {
      final result = _apply(SpotStatus.armed, SpotEvent.userCollected);

      expect(result.status, SpotStatus.collected);
      expect(result.removeFences, isTrue);
    });

    test('should resolve and remove fences when abandoned', () {
      final result = _apply(SpotStatus.armed, SpotEvent.userAbandoned);

      expect(result.status, SpotStatus.abandoned);
      expect(result.removeFences, isTrue);
    });
  });

  group('notified', () {
    test('should escalate to arrived once the cooldown has passed', () {
      final result = _apply(
        SpotStatus.notified,
        SpotEvent.innerEnter,
        notifiedAt: _now.subtract(const Duration(minutes: 5)),
      );

      expect(result.notify, NotifyKind.arrived);
      expect(result.notifiedAt, _now);
    });

    test('should not escalate while still inside the cooldown', () {
      final result = _apply(
        SpotStatus.notified,
        SpotEvent.innerEnter,
        notifiedAt: _now.subtract(const Duration(seconds: 10)),
      );

      expect(result.notify, isNull);
      expect(result.status, SpotStatus.notified);
    });

    test('should ignore a second outer ring entry', () {
      final result = _apply(
        SpotStatus.notified,
        SpotEvent.outerEnter,
        notifiedAt: _now.subtract(const Duration(hours: 1)),
      );

      expect(result.notify, isNull);
    });

    test('should re-arm when the user walks away again', () {
      final earlier = _now.subtract(const Duration(minutes: 5));
      final result = _apply(
        SpotStatus.notified,
        SpotEvent.outerExit,
        notifiedAt: earlier,
      );

      expect(result.status, SpotStatus.armed);
      expect(
        result.notifiedAt,
        earlier,
        reason: 'cooldown must survive re-arm',
      );
    });

    test('should resolve and remove fences when collected', () {
      final result = _apply(SpotStatus.notified, SpotEvent.userCollected);

      expect(result.status, SpotStatus.collected);
      expect(result.removeFences, isTrue);
    });
  });

  group('terminal states', () {
    test('should ignore late geofence events once collected', () {
      for (final event in SpotEvent.values) {
        final result = _apply(SpotStatus.collected, event);

        expect(result.status, SpotStatus.collected, reason: '$event');
        expect(result.notify, isNull, reason: '$event');
        expect(result.removeFences, isFalse, reason: '$event');
      }
    });

    test('should ignore late geofence events once abandoned', () {
      for (final event in SpotEvent.values) {
        final result = _apply(SpotStatus.abandoned, event);

        expect(result.status, SpotStatus.abandoned, reason: '$event');
        expect(result.notify, isNull, reason: '$event');
      }
    });
  });

  group('walk scenarios', () {
    test('should stay silent while marking a bag and standing still', () {
      final result = _apply(SpotStatus.dropped, SpotEvent.innerEnter);

      expect(result.notify, isNull);
      expect(result.status, SpotStatus.dropped);
    });

    test('should notify twice on a normal out and back walk', () {
      final left = _apply(SpotStatus.dropped, SpotEvent.outerExit);
      expect(left.status, SpotStatus.armed);

      final approaching = _apply(
        left.status,
        SpotEvent.outerEnter,
        notifiedAt: left.notifiedAt,
        now: _now,
      );
      expect(approaching.notify, NotifyKind.approaching);

      final arrived = _apply(
        approaching.status,
        SpotEvent.innerEnter,
        notifiedAt: approaching.notifiedAt,
        now: _now.add(const Duration(minutes: 2)),
      );
      expect(arrived.notify, NotifyKind.arrived);
    });

    test(
      'should not double buzz when a late outer event trails an inner one',
      () {
        final approaching = _apply(SpotStatus.armed, SpotEvent.outerEnter);
        expect(approaching.notify, NotifyKind.approaching);

        final trailing = _apply(
          approaching.status,
          SpotEvent.innerEnter,
          notifiedAt: approaching.notifiedAt,
          now: _now.add(const Duration(seconds: 5)),
        );
        expect(trailing.notify, isNull);
      },
    );
  });
}
