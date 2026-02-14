import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../router/app_router.dart';

/// Main shell with bottom navigation for authenticated screens.
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final router = GoRouter.of(context);

    // Update current index based on location
    final location = router.routerDelegate.currentConfiguration.uri.path;
    final index = _getIndexFromLocation(location);
    
    // Sync provider with actual location
    if (index != currentIndex) {
      Future.microtask(() {
        ref.read(navigationIndexProvider.notifier).state = index;
      });
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
          _navigateToIndex(context, index);
        },
      ),
    );
  }

  int _getIndexFromLocation(String location) {
    switch (location) {
      case '/':
        return 0;
      case '/practice':
        return 1;
      case '/progress':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  void _navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/'); // Practice starts from home
        break;
      case 2:
        context.go('/progress');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
