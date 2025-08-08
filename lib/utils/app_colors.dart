import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Purple/Blue Gradient
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors - Teal/Cyan Accents
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);

  // Accent Colors
  static const Color accent = Color(0xFFEC4899); // Pink
  static const Color accentLight = Color(0xFFF472B6);

  // Success/Warning/Error
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Background Gradients
  static const List<Color> backgroundGradientLight = [
    Color(0xFFF8FAFC), // Slate-50
    Color(0xFFF1F5F9), // Slate-100
    Color(0xFFE2E8F0), // Slate-200
  ];

  static const List<Color> backgroundGradientDark = [
    Color(0xFF0F172A), // Slate-900
    Color(0xFF1E293B), // Slate-800
    Color(0xFF334155), // Slate-700
  ];

  // Glass Effect Colors
  static Color glassLight = Colors.white.withOpacity(0.25);
  static Color glassDark = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);

  static var primaryGradient;
}
