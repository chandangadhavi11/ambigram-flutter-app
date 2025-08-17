/// Router configuration for the application.
///
/// This file sets up the routes for the application using go_router.
/// It defines the routes, route names, and route parameters.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/preview/presentation/screens/preview_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../global/state/auth_notifier.dart';

/// Route names for the application
class RouteNames {
  /// Private constructor to prevent instantiation
  const RouteNames._();

  /// Splash screen route name
  static const String splash = 'splash';

  /// Auth screen route name
  static const String auth = 'auth';

  /// Home screen route name
  static const String home = 'home';

  /// Preview screen route name
  static const String preview = 'preview';

  /// Profile screen route name
  static const String profile = 'profile';
}

/// Route paths for the application
class RoutePaths {
  /// Private constructor to prevent instantiation
  const RoutePaths._();

  /// Splash screen route path
  static const String splash = '/';

  /// Auth screen route path
  static const String auth = '/auth';

  /// Home screen route path
  static const String home = '/home';

  /// Preview screen route path
  static const String preview = '/preview';

  /// Profile screen route path
  static const String profile = '/profile';
}

/// Builds the router configuration for the application
GoRouter buildRouter(AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final bool isInitialized = authNotifier.isInitialized;
      final bool isSplashRoute = state.matchedLocation == RoutePaths.splash;

      // Wait for initialization before any redirects
      if (!isInitialized) {
        return null;
      }

      // After initialization, redirect from splash directly to home
      if (isSplashRoute && isInitialized) {
        return RoutePaths.home;
      }

      // No other redirects needed - authentication has been removed
      return null;
    },
    refreshListenable: authNotifier,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.auth,
        name: RouteNames.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.preview,
        name: RouteNames.preview,
        builder: (context, state) {
          final Map<String, dynamic> params =
              state.extra as Map<String, dynamic>? ?? {};

          return PreviewScreen(
            primaryWord: params['primaryWord'] as String? ?? '',
            secondaryWord: params['secondaryWord'] as String?,
            styleId: params['styleId'] as String? ?? 'classic',
            backgroundColor: params['backgroundColor'] as String? ?? '#FFFFFF',
            svgData: params['svgData'] as String?,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Route "${state.uri}" not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
