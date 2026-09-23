import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/spacers.dart';

class MapScreen extends StatelessWidget {
    const MapScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return const Padding(
        padding: BrbSpacers.screenPadding,
        child: Center(child: Text('Map')),
      );
    }
  }
