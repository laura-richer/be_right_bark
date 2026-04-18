import 'package:flutter/material.dart';
import '/widgets/common/navigation/bottom_tabs/types.dart';

final List<BottomTabItem> bottomTabs = [
  BottomTabItem(
    id: 0,
    label: 'Mark spot',
    path: '/mark-spot',
    icon: Icons.add_location_alt_outlined,
  ),
  BottomTabItem(
    id: 1,
    label: 'Active spots',
    path: '/active-spots',
    icon: Icons.format_list_bulleted,
  ),
  BottomTabItem(id: 2, label: 'Map', path: '/map', icon: Icons.map),
  BottomTabItem(
    id: 3,
    label: 'Settings',
    path: '/stylesetter',
    icon: Icons.settings,
  ),
];
