import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/main_shell.dart';
import '../features/quiz/screens/quiz_screen.dart';
import '../features/quiz/screens/result_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/progress/screens/progress_screen.dart';

part 'app_router.g.dart';

// Navigation index provider
final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Auth state provider (placeholder - will be implemented in Phase 2)
final authStateProvider = StateProvider<bool>((ref) => false);

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final isAuthenticated = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Route guards will be fully implemented in Phase 2
      // For now, allow all routes for UI development
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      
      // Uncomment when auth is implemented:
      // if (!isAuthenticated && !isLoggingIn) {
      //   return '/login';
      // }
      // if (isAuthenticated && isLoggingIn) {
      //   return '/';
      // }
      
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/practice',
            name: 'practice',
            builder: (context, state) => const HomeScreen(), // Practice starts from home
          ),
          GoRoute(
            path: '/progress',
            name: 'progress',
            builder: (context, state) => const ProgressScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Quiz routes (outside shell - no bottom nav)
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/quiz/result',
        name: 'quizResult',
        builder: (context, state) {
          final sessionId = state.uri.queryParameters['sessionId'] ?? '';
          return ResultScreen(sessionId: sessionId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.path),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
