import 'package:flutter/material.dart';

/// Design tokens for spacing throughout the app.
/// All values are in logical pixels.
class AppSpacing {
  AppSpacing._();

  // Base unit (4px)
  static const double unit = 4.0;

  // Spacing scale
  static const double xs = unit;           // 4
  static const double sm = unit * 2;       // 8
  static const double md = unit * 3;       // 12
  static const double lg = unit * 4;       // 16
  static const double xl = unit * 6;       // 24
  static const double xxl = unit * 8;      // 32
  static const double xxxl = unit * 12;    // 48

  // Screen padding
  static const double screenPadding = lg;  // 16
  static const double screenPaddingLarge = xl; // 24

  // Component spacing
  static const double cardPadding = lg;
  static const double buttonPaddingHorizontal = xl;
  static const double buttonPaddingVertical = md;
  static const double inputPadding = lg;
  static const double chipPaddingHorizontal = md;
  static const double chipPaddingVertical = sm;

  // Gap values for Row/Column spacing
  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  static const double gapXl = xl;

  // Helper methods for symmetric padding
  static EdgeInsets get paddingXs => const EdgeInsets.all(xs);
  static EdgeInsets get paddingSm => const EdgeInsets.all(sm);
  static EdgeInsets get paddingMd => const EdgeInsets.all(md);
  static EdgeInsets get paddingLg => const EdgeInsets.all(lg);
  static EdgeInsets get paddingXl => const EdgeInsets.all(xl);

  // Horizontal padding
  static EdgeInsets get paddingHorizontal => const EdgeInsets.symmetric(horizontal: screenPadding);
  static EdgeInsets get paddingHorizontalLarge => const EdgeInsets.symmetric(horizontal: screenPaddingLarge);

  // Screen padding with safe area consideration
  static EdgeInsets get screenInsets => const EdgeInsets.all(screenPadding);
}
