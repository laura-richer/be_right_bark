import 'package:flutter/material.dart';

class ActiveSpotScreen extends StatelessWidget {
  final String id;

  const ActiveSpotScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(id)),
    );
  }
}
