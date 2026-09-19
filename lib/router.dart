import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/features/active_spots/active_spot_screen/active_spot_screen.dart';
import 'package:be_right_bark/features/active_spots/active_spots_screen/active_spots_screen.dart';
import 'package:be_right_bark/features/mark_spot/mark_spot_screen/mark_spot_screen.dart';
import 'package:be_right_bark/features/map/map_screen.dart';
import 'package:be_right_bark/features/settings/settings_screen.dart';
import 'package:be_right_bark/features/stylesetter.dart';
import 'package:be_right_bark/widgets/app_container.dart';

// Page<void> _noTransitionPage(GoRouterState state, Widget child) {
//   return NoTransitionPage(key: state.pageKey, child: child);
// }

// Page<void> _slideUpPageTransition(GoRouterState state, Widget child) {
//   return CustomTransitionPage(
//     key: state.pageKey,
//     child: child,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       final tween = Tween(
//         begin: const Offset(0, 1),
//         end: Offset.zero,
//       ).chain(CurveTween(curve: Curves.easeInOut));
//       return SlideTransition(position: animation.drive(tween), child: child);
//     },
//   );
// }

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
          pageBuilder: (context, state) =>
              _fadePageTransition(state, const MarkSpotScreen()),
        ),
        GoRoute(
          path: '/active-spots',
          pageBuilder: (context, state) =>
              _fadePageTransition(state, const ActiveSpotsScreen()),
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => _fadePageTransition(
                state,
                ActiveSpotScreen(id: int.parse(state.pathParameters['id']!)),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) =>
              _fadePageTransition(state, const MapScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              _fadePageTransition(state, const SettingsScreen()),
        ),
        GoRoute(
          path: '/stylesetter',
          pageBuilder: (context, state) =>
              _fadePageTransition(state, const StylesetterScreen()),
        ),
      ],
    ),
  ],
);
