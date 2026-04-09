import 'package:flutter/material.dart';

class MarkSpotScreen extends StatelessWidget {
    const MarkSpotScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Be Right Bark')),
        body: const Center(child: Text('Mark spot')),
      );
    }
  }
