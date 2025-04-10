import 'package:setforge/screens/setup/faq_screen.dart';
import 'package:setforge/screens/setup/profile_screen.dart';
import 'package:setforge/screens/setup/theme_screen.dart';
import 'package:setforge/screens/setup/units_screen.dart';
import 'package:setforge/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setforge/screens/home_screen.dart';
import 'package:setforge/screens/setup_screen.dart';
import 'package:setforge/screens/workout_screen.dart';
import 'package:setforge/widgets/nav_bar.dart';
import 'package:setforge/screens/control_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/home",
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: Duration.zero,
          child: ControlScreen(child: child),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: Duration.zero,
              child: const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
        GoRoute(
          path: '/workout',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: Duration.zero,
              child: const WorkoutScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
        GoRoute(
          path: '/settings',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: Duration.zero,
              child: const SetupScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/units',
      builder: (context, state) => const UnitsScreen(),
      routes: [
      ],
    ),
    GoRoute(
      path: '/theme',
      builder: (context, state) => const ThemeScreen(),
      routes: [
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
      routes: [
      ],
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const FaqScreen(),
      routes: [
      ],
    )
  ],
);
