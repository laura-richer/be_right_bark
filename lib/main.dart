import 'package:flutter/material.dart';
import 'widgets/common/app_container.dart';
import 'styles/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be Right Bark',
      theme: brbTheme(),
      home: AppContainer(),
    );
  }
}

