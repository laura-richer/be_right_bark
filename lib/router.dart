import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/screens/active_spot.dart';
import '/screens/active_spots.dart';
import '/screens/mark_spot.dart';
import '/screens/mark_spot_detail.dart';
import '/screens/map.dart';
import '/screens/settings.dart';
import '/screens/stylesetter.dart';
import '/widgets/common/app_container.dart';

// Page<void> _noTransitionPage(GoRouterState state, Widget child) {
//   return NoTransitionPage(key: state.pageKey, child: child);
// }

Page<void> _slideUpPageTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

Page<void> _fadePageTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final router = GoRouter(
  initialLocation: '/mark-spot',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppContainer(child: child),
      routes: [
        GoRoute(
          path: '/mark-spot',
          pageBuilder: (context, state) => _fadePageTransition(state, MarkSpotScreen()),
          routes: [
            GoRoute(
              path: '/detail',
              pageBuilder:(context, state) => _slideUpPageTransition(state, MarkSpotDetailScreen()),
            ),
          ],
        ),
        GoRoute(
          path: '/active-spots',
          pageBuilder: (context, state) => _fadePageTransition(state, ActiveSpotsScreen()),
          routes: [
            GoRoute(
              path: ':id',
              builder:(context, state) => ActiveSpotScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) => _fadePageTransition(state, MapScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _fadePageTransition(state, SettingsScreen()),
        ),
        GoRoute(
          path: '/stylesetter',
          pageBuilder: (context, state) => _fadePageTransition(state, StylesetterScreen()),
        ),
      ],
    ),
  ],
);
