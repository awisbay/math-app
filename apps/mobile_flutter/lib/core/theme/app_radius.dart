import 'package:flutter/material.dart';

/// Design tokens for border radius throughout the app.
class AppRadius {
  AppRadius._();

  // Base unit
  static const double unit = 4.0;

  // Radius scale
  static const double none = 0;
  static const double xs = unit;           // 4
  static const double sm = unit * 2;       // 8
  static const double md = unit * 3;       // 12
  static const double lg = unit * 4;       // 16
  static const double xl = unit * 6;       // 24
  static const double xxl = unit * 8;      // 32
  static const double full = 9999;         // Fully rounded (pills/circles)

  // Component-specific radii
  static const double buttonRadius = lg;   // 16
  static const double cardRadius = xl;     // 24
  static const double chipRadius = full;   // Pill shape
  static const double inputRadius = lg;    // 16
  static const double dialogRadius = xl;   // 24
  static const double avatarRadius = full; // Circle
  static const double timerRadius = full;  // Circle

  // BorderRadius objects
  static BorderRadius get noneRadius => BorderRadius.zero;
  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);

  // Component-specific BorderRadius
  static BorderRadius get button => BorderRadius.circular(buttonRadius);
  static BorderRadius get card => BorderRadius.circular(cardRadius);
  static BorderRadius get chip => BorderRadius.circular(chipRadius);
  static BorderRadius get input => BorderRadius.circular(inputRadius);
  static BorderRadius get dialog => BorderRadius.circular(dialogRadius);
}
