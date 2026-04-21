import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'router.dart';
import 'styles/theme.dart';
import 'models/location.dart';
import 'utils/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  await Hive.openBox<Location>('locations');

  await initLocationPermission();

  runApp(const MyApp());
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
