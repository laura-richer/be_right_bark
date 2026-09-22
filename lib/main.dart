import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:be_right_bark/router.dart';
import 'package:be_right_bark/styles/theme.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/models/spot_status.dart';
import 'package:be_right_bark/utils/permissions.dart';
import 'package:be_right_bark/utils/hive.dart';
import 'package:be_right_bark/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(SpotStatusAdapter());

  await openHiveBox<Location>('locations');
  await initNotifications();
  final permissionStatus = await initLocationPermission();
  await handleNotificationColdStart();

  runApp(
    ProviderScope(
      overrides: [
        locationPermissionProvider.overrideWith((_) => permissionStatus),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Be Right Bark',
      theme: brbTheme(),
      routerConfig: router,
    );
  }
}
