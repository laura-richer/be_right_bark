import 'package:flutter/material.dart';
import '/widgets/common/navigation/bottom_tabs/bottom_tabs.dart';
import '/widgets/common/navigation/header_bar.dart';

class AppContainer extends StatelessWidget {
  final Widget child;

  const AppContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
      bottomNavigationBar: BottomTabs(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}
