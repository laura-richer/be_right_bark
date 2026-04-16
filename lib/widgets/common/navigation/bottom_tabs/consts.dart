import 'package:flutter/material.dart';
import '/widgets/common/navigation/bottom_tabs/types.dart';

final List<BottomTabItem> bottomTabs = [
  BottomTabItem(id: 0, label: 'Home', path: '/home', icon: Icons.home),
  BottomTabItem(id: 1, label: 'Active spots', path: '/active-spots', icon: Icons.format_list_bulleted),
  BottomTabItem(id: 2, label: 'Map', path: '/map', icon: Icons.map),
  BottomTabItem(id: 3, label: 'Stylesetter', path: '/stylesetter', icon: Icons.settings),
];
