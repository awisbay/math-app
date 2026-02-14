import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentNavIndex;
  final ValueChanged<int>? onNavTap;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool showBottomNav;

  const AppScaffold({
    super.key,
    required this.body,
    this.currentNavIndex = 0,
    this.onNavTap,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      backgroundColor: backgroundColor,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: showBottomNav && onNavTap != null
          ? AppBottomNav(
              currentIndex: currentNavIndex,
              onTap: onNavTap!,
            )
          : null,
    );
  }
}

/// A scaffold specifically for main screens with bottom navigation.
class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentNavIndex;
  final ValueChanged<int> onNavTap;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const MainScaffold({
    super.key,
    required this.body,
    required this.currentNavIndex,
    required this.onNavTap,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: body,
      currentNavIndex: currentNavIndex,
      onNavTap: onNavTap,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      showBottomNav: true,
    );
  }
}

/// A scaffold for screens without bottom navigation (like quiz, auth).
class SimpleScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;

  const SimpleScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: body,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      showBottomNav: false,
    );
  }
}
