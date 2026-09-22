import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:be_right_bark/domain/spot_machine.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/router.dart';
import 'package:be_right_bark/models/spot_status.dart';
import 'package:be_right_bark/services/picked_up_service.dart';

/// Channel for the two spot alerts. High importance - these are the point of
/// the app, so they should make a sound and appear as a heads-up.
const String alertChannelId = 'brb_spot_alerts';
const String _alertChannelName = 'Bag reminders';
const String _alertChannelDescription =
    'Alerts when you are walking back towards a bag you left.';

/// Channel for the persistent "bags still out" notification. Low importance -
/// silent, no heads-up, sits quietly in the shade.
const String summaryChannelId = 'brb_summary';
const String _summaryChannelName = 'Outstanding bags';
const String _summaryChannelDescription =
    'A quiet reminder that you still have bags to collect.';

/// Fixed id for the ongoing summary. Spot alerts derive their own ids.
const int summaryNotificationId = 0;

const String actionPickedUp = 'picked_up';
const String actionGaveUp = 'gave_up';
const String _darwinCategoryId = 'brb_spot_actions';

const String _locationsBoxName = 'locations';

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

/// Android notification ids must fit in a 32 bit int, so the raw millisecond
/// timestamp is too large. Wrapping it keeps ids stable per spot and unique
/// in any realistic case.
int notificationIdForSpot(DateTime createdAt) {
  return createdAt.millisecondsSinceEpoch.remainder(2147483647);
}

/// Handles a notification action when the app is not in the foreground.
///
/// Must stay top level and keep the vm:entry-point annotation, or tree shaking
/// removes it from release builds and actions silently stop working.
@pragma('vm:entry-point')
void onBackgroundNotificationResponse(NotificationResponse response) {
  _resolveInBackgroundIsolate(response);
}

/// This isolate has no Hive, no Riverpod and no widget tree. Everything it
/// needs has to be set up from cold, every time.
Future<void> _resolveInBackgroundIsolate(NotificationResponse response) async {
  final key = _spotKeyFrom(response);
  final resolution = _resolutionFor(response.actionId);
  if (key == null || resolution == null) return;

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(LocationAdapter());
  }

  final box = await Hive.openBox<Location>(_locationsBoxName);
  await _applyResolution(box, key, resolution);
  await box.close();
}

/// The main isolate already has Hive open and a router to navigate with.
void _onForegroundNotificationResponse(NotificationResponse response) {
  handleNotificationResponse(response);
}

/// Shared entry point for a tap or an action, used by the foreground handler
/// and by the cold start path in main().
Future<void> handleNotificationResponse(NotificationResponse response) async {
  final key = _spotKeyFrom(response);
  if (key == null) return;

  final resolution = _resolutionFor(response.actionId);

  // No action id means the user tapped the notification body.
  if (resolution == null) {
    router.go('/active-spots/$key');
    return;
  }

  final box = Hive.box<Location>(_locationsBoxName);
  await _applyResolution(box, key, resolution);

  if (resolution == SpotEvent.userCollected) {
    router.go('/picked-up');
  }
}

int? _spotKeyFrom(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null) return null;
  return int.tryParse(payload);
}

SpotEvent? _resolutionFor(String? actionId) {
  return switch (actionId) {
    actionPickedUp => SpotEvent.userCollected,
    actionGaveUp => SpotEvent.userAbandoned,
    _ => null,
  };
}

/// Runs the spot through reduce() and acts on the result.
///
/// For now that means deleting the record, since collected spots are not kept.
/// Step 3 adds fence teardown here.
Future<void> _applyResolution(
  Box<Location> box,
  int key,
  SpotEvent event,
) async {
  final spot = box.get(key);
  if (spot == null) return;

  final transition = reduce(
    status: spot.spotStatus,
    notifiedAt: spot.notifiedAt,
    event: event,
    now: DateTime.now(),
  );

  await cancelSpotAlert(spot.createdAt);

  // TODO(step 3): if transition.removeFences, deregister the two geofences
  // before deleting, and retry on next launch if that call throws.
  if (transition.status == SpotStatus.collected) {
    await incrementPickedUpCount();
    await box.delete(key);
  } else if (transition.status == SpotStatus.abandoned) {
    await box.delete(key);
  }

  await showOutstandingSummary(
    activeCount: box.length,
    soleSpotCreatedAt: box.length == 1 ? box.values.first.createdAt : null,
  );
}

/// Sets up channels and handlers. Call once from main() before runApp().
Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  // Permission is requested later, in context, rather than on first launch.
  final darwinSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    notificationCategories: <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        _darwinCategoryId,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(actionPickedUp, 'Picked up'),
          DarwinNotificationAction.plain(actionGaveUp, 'Gave up'),
        ],
      ),
    ],
  );

  await _plugin.initialize(
    settings: InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    ),
    onDidReceiveNotificationResponse: _onForegroundNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        onBackgroundNotificationResponse,
  );

  await _createAndroidChannels();
}

/// Handles the case where the app was launched by tapping a notification while
/// it was fully terminated. The normal handlers never fire for that.
Future<void> handleNotificationColdStart() async {
  final details = await _plugin.getNotificationAppLaunchDetails();
  final response = details?.notificationResponse;
  if (details?.didNotificationLaunchApp != true || response == null) return;

  await handleNotificationResponse(response);
}

/// Channel settings are immutable once created, so importance has to be right
/// the first time the app is installed.
Future<void> _createAndroidChannels() async {
  final android = _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  if (android == null) return;

  await android.createNotificationChannel(
    const AndroidNotificationChannel(
      alertChannelId,
      _alertChannelName,
      description: _alertChannelDescription,
      importance: Importance.high,
    ),
  );

  await android.createNotificationChannel(
    const AndroidNotificationChannel(
      summaryChannelId,
      _summaryChannelName,
      description: _summaryChannelDescription,
      importance: Importance.low,
    ),
  );
}

/// Asks for notification permission. Android 13+ and iOS both require this.
Future<bool> requestNotificationPermission() async {
  final android = _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  if (android != null) {
    return await android.requestNotificationsPermission() ?? false;
  }

  final darwin = _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();
  if (darwin != null) {
    return await darwin.requestPermissions(alert: true, sound: true) ?? false;
  }

  return false;
}

String _alertTitle(NotifyKind kind) {
  return switch (kind) {
    NotifyKind.approaching => 'Bag ahead',
    NotifyKind.arrived => "You're right by your bag",
  };
}

String _alertBody(NotifyKind kind, String? spotName) {
  final label = spotName ?? 'A bag';
  return switch (kind) {
    NotifyKind.approaching => '$label is about 200m away.',
    NotifyKind.arrived => '$label is just about here. Good time to grab it.',
  };
}

/// Shows one of the two spot alerts.
///
/// [spotKey] is the Hive key, carried in the payload so taps and actions can
/// find the spot again.
Future<void> showSpotAlert({
  required NotifyKind kind,
  required DateTime spotCreatedAt,
  required int spotKey,
  String? spotName,
}) async {
  const androidDetails = AndroidNotificationDetails(
    alertChannelId,
    _alertChannelName,
    channelDescription: _alertChannelDescription,
    importance: Importance.high,
    priority: Priority.high,
    category: AndroidNotificationCategory.reminder,
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        actionPickedUp,
        'Picked up',
        showsUserInterface: false,
        cancelNotification: true,
      ),
      AndroidNotificationAction(
        actionGaveUp,
        'Gave up',
        showsUserInterface: false,
        cancelNotification: true,
      ),
    ],
  );

  const darwinDetails = DarwinNotificationDetails(
    categoryIdentifier: _darwinCategoryId,
  );

  await _plugin.show(
    id: notificationIdForSpot(spotCreatedAt),
    title: _alertTitle(kind),
    body: _alertBody(kind, spotName),
    notificationDetails: const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    ),
    payload: spotKey.toString(),
  );
}

/// Shows or updates the ongoing "bags still out" notification.
///
/// Actions are only attached when there is exactly one bag, since otherwise
/// "Picked up" would be ambiguous. Pass zero to clear it.
Future<void> showOutstandingSummary({
  required int activeCount,
  DateTime? soleSpotCreatedAt,
  int? soleSpotKey,
}) async {
  if (activeCount <= 0) {
    await _plugin.cancel(id: summaryNotificationId);
    return;
  }

  final single = activeCount == 1;
  final body = single
      ? 'One bag is still waiting to be collected.'
      : '$activeCount bags are still waiting to be collected.';

  final androidDetails = AndroidNotificationDetails(
    summaryChannelId,
    _summaryChannelName,
    channelDescription: _summaryChannelDescription,
    importance: Importance.low,
    priority: Priority.low,
    ongoing: true,
    autoCancel: false,
    silent: true,
    showWhen: false,
    actions: single
        ? const <AndroidNotificationAction>[
            AndroidNotificationAction(
              actionPickedUp,
              'Picked up',
              showsUserInterface: false,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              actionGaveUp,
              'Gave up',
              showsUserInterface: false,
              cancelNotification: true,
            ),
          ]
        : null,
  );

  final darwinDetails = single
      ? const DarwinNotificationDetails(
          presentSound: false,
          categoryIdentifier: _darwinCategoryId,
        )
      : const DarwinNotificationDetails(presentSound: false);

  await _plugin.show(
    id: summaryNotificationId,
    title: 'Be Right Bark',
    body: body,
    notificationDetails: NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    ),
    payload: single && soleSpotKey != null ? soleSpotKey.toString() : null,
  );
}

/// Clears a spot's alert, for when it is collected or abandoned.
Future<void> cancelSpotAlert(DateTime spotCreatedAt) async {
  await _plugin.cancel(id: notificationIdForSpot(spotCreatedAt));
}
