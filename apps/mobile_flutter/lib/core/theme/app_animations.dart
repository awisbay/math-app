import 'package:flutter/material.dart';

/// Animation durations and curves for consistent motion throughout the app.
class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration slower = Duration(milliseconds: 500);

  // Curves
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve emphasized = Curves.easeInOutCubic;
  static const Curve bounce = Curves.elasticOut;

  // Predefined animation configurations
  static const Duration buttonTap = fast;
  static const Curve buttonTapCurve = emphasized;

  static const Duration screenTransition = normal;
  static const Curve screenTransitionCurve = emphasized;

  static const Duration dialogTransition = normal;
  static const Curve dialogTransitionCurve = emphasized;

  static const Duration snackbarTransition = fast;
  static const Curve snackbarTransitionCurve = enter;

  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration skeletonLoading = Duration(milliseconds: 1000);
}
