import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF3730A3);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryContainer = Color(0xFFD1FAE5);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF065F46);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onSurface = Color(0xFF1E293B);
  static const Color onSurfaceVariant = Color(0xFF64748B);

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color onBackground = Color(0xFF1E293B);

  // Error Colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF991B1B);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Timer Colors
  static const Color timerNormal = Color(0xFF10B981);
  static const Color timerWarning = Color(0xFFF59E0B);
  static const Color timerCritical = Color(0xFFEF4444);

  // Grade Colors (for grade chips)
  static const List<Color> gradeColors = [
    Color(0xFFEF4444), // Grade 1 - Red
    Color(0xFFF97316), // Grade 2 - Orange
    Color(0xFFF59E0B), // Grade 3 - Amber
    Color(0xFFEAB308), // Grade 4 - Yellow
    Color(0xFF84CC16), // Grade 5 - Lime
    Color(0xFF22C55E), // Grade 6 - Green
    Color(0xFF10B981), // Grade 7 - Emerald
    Color(0xFF14B8A6), // Grade 8 - Teal
    Color(0xFF06B6D4), // Grade 9 - Cyan
    Color(0xFF0EA5E9), // Grade 10 - Sky
    Color(0xFF3B82F6), // Grade 11 - Blue
    Color(0xFF6366F1), // Grade 12 - Indigo
  ];
}
