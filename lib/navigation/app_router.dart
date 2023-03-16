import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final GroceryManager groceryManager;

  AppRouter(
    this.appStateManager,
    this.profileManager,
    this.groceryManager,
  );

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
          name: 'home',
          path: '/:tab',
          builder: (context, state) {
            final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
            return Home(
              key: state.pageKey,
              currentTab: tab,
            );
          },
          routes: [
            // TODO: Add Item Subroute
            // TODO: Add Profile Subroute
          ]),
    ],
    redirect: (state) {
      final loggedIn = appStateManager.isLoggedIn;
      final loggingIn = state.subloc == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';

      final isOnboardingComplete = appStateManager.isOnboardingComplete;
      final onboarding = state.subloc == '/onboarding';

      if (!isOnboardingComplete) {
        return onboarding ? null : '/onboarding';
      }

      if (loggingIn || onboarding) return '/${FooderlichTab.explore}';
      return null;
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
  );
}
