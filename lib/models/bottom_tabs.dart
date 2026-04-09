import 'package:flutter/material.dart';

// Import your screen widgets here
import '../screens/home.dart';
import '../screens/active_spots.dart';
import '../screens/map.dart';
// import '../screens/settings.dart';
import '../screens/stylesetter.dart';

class PageItem {
  final int id;
  final String label;
  final Widget page;
  final List<PageItem> children;
  final IconData icon;

  PageItem({required this.id, required this.label, required this.page, this.children = const <PageItem>[], required this.icon});
}

final List<PageItem> bottomTabsItems = [
  PageItem(label: 'Home', page: HomeScreen(), id: 0, icon: Icons.home),
  PageItem(label: 'Active spots', page: ActiveSpotsScreen(), id: 1, icon: Icons.format_list_bulleted),
  PageItem(label: 'Map', page: MapScreen(), id: 2, icon: Icons.map),
  PageItem(label: 'Settings', page: StylesetterScreen(), id: 3, icon: Icons.settings),
];
