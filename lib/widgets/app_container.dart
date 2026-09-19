import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/utils/hive.dart';
import 'package:be_right_bark/widgets/navigation/bottom_tabs/bottom_tabs.dart';
import 'package:be_right_bark/widgets/navigation/header_bar/header_bar.dart';

class AppContainer extends StatefulWidget {
  final Widget child;

  const AppContainer({super.key, required this.child});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  @override
  void initState() {
    super.initState();
    if (hiveDataWasReset) {
      hiveDataWasReset = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong and your saved spots were reset.',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      bottomNavigationBar: const BottomTabs(),
      body: Padding(
        padding: const EdgeInsets.all(BrbSpacers.lg),
        child: widget.child,
      ),
    );
  }
}
