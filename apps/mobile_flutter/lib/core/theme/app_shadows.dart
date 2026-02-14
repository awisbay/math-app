import 'package:flutter/material.dart';

/// Design tokens for shadows throughout the app.
class AppShadows {
  AppShadows._();

  // Shadow colors
  static const Color _shadowColor = Color(0xFF1E293B);
  static const Color _shadowColorLight = Color(0xFF64748B);

  // No shadow
  static const List<BoxShadow> none = [];

  // Small shadow - for buttons, chips
  static List<BoxShadow> get small => [
    BoxShadow(
      color: _shadowColor.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Medium shadow - for cards, elevated surfaces
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: _shadowColor.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Large shadow - for modals, dialogs
  static List<BoxShadow> get large => [
    BoxShadow(
      color: _shadowColor.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Extra large shadow - for important overlays
  static List<BoxShadow> get xlarge => [
    BoxShadow(
      color: _shadowColor.withOpacity(0.16),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // Colored shadow for primary actions
  static List<BoxShadow> primary(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Success shadow
  static List<BoxShadow> get success => [
    BoxShadow(
      color: const Color(0xFF10B981).withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Error shadow
  static List<BoxShadow> get error => [
    BoxShadow(
      color: const Color(0xFFEF4444).withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
