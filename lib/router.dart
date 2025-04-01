import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:benchy/screens/home_screen.dart';
import 'package:benchy/screens/profile_screen.dart';
import 'package:benchy/screens/workout_screen.dart';
import 'package:benchy/widgets/nav_bar.dart';
import 'package:benchy/screens/control_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/home",
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          ControlScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/workout',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const WorkoutScreen(),
        ),
        GoRoute(
          path: '/settings',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ProfileScreen(),
          routes: [
          ],
        ),
      ],
    )
  ],
);
