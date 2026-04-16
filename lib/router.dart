import 'package:be_right_bark/screens/active_spot.dart';
import 'package:be_right_bark/screens/active_spots.dart';
import 'package:be_right_bark/screens/home.dart';
import 'package:be_right_bark/screens/map.dart';
import 'package:be_right_bark/screens/settings.dart';
import 'package:be_right_bark/screens/stylesetter.dart';
import 'package:be_right_bark/widgets/common/app_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<void> _noTransitionPage(GoRouterState state, Widget child) {
  return NoTransitionPage(key: state.pageKey, child: child);
}

// Page<void> _fadeTransitionPage(GoRouterState state, Widget child) {
//   return CustomTransitionPage(
//     key: state.pageKey,
//     child: child,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(opacity: animation, child: child);
//     },
//   );
// }

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppContainer(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _noTransitionPage(state, HomeScreen()),
        ),
        GoRoute(
          path: '/active-spots',
          pageBuilder: (context, state) => _noTransitionPage(state, ActiveSpotsScreen()),
          routes: [
            GoRoute(
              path: ':id',
              builder:(context, state) => ActiveSpotScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) => _noTransitionPage(state, MapScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _noTransitionPage(state, SettingsScreen()),
        ),
        GoRoute(
          path: '/stylesetter',
          pageBuilder: (context, state) => _noTransitionPage(state, StylesetterScreen()),
        ),
      ],
    ),
  ],
);
