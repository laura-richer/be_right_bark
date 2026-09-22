import 'package:flutter/material.dart';
import 'package:be_right_bark/widgets/navigation/bottom_tabs/types.dart';

final List<BottomTabItem> bottomTabs = [
  BottomTabItem(
    label: 'Mark spot',
    path: '/mark-spot',
    icon: Icons.add_location_alt_outlined,
  ),
  BottomTabItem(
    label: 'Spots',
    path: '/active-spots',
    icon: Icons.format_list_bulleted,
  ),
  BottomTabItem(label: 'Map', path: '/map', icon: Icons.map),
  BottomTabItem(label: 'Settings', path: '/settings', icon: Icons.settings),
];
