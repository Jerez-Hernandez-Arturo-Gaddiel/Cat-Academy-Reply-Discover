import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/quiz_editor/quiz_editor_screen.dart';
import '../../features/quiz_runner/quiz_runner_screen.dart';
import '../../features/results/results_screen.dart';
import '../../features/error/error_screen.dart';
import '../../models/quiz_session_config.dart';
import '../../models/quiz_result.dart';
import '../../providers/auth_provider.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      errorBuilder: (context, state) => ErrorScreen(error: state.error),
      redirect: (context, state) {
        final bool loggedIn = authProvider.isLoggedIn;
        final bool loggingIn = state.matchedLocation == '/login';

        if (!loggedIn && !loggingIn) return '/login';
        if (loggedIn && loggingIn) return '/';
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LibraryScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/editor',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const QuizEditorScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/runner',
          pageBuilder: (context, state) {
            final config = state.extra as QuizSessionConfig;
            return CustomTransitionPage(
              key: state.pageKey,
              child: QuizRunnerScreen(config: config),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),
        GoRoute(
          path: '/results',
          pageBuilder: (context, state) {
            final result = state.extra as QuizResult;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ResultsScreen(result: result),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),
      ],
    );
  }
}
