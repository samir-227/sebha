import 'package:flutter/material.dart';

/// جميع ألوان التطبيق موحدة هنا حتى نتجنب الأرقام السحرية في الكود.
class AppColors {
  AppColors._();

  // Base neutrals
  static const Color lightBackground = Color(0xFFEFF3FA);
  static const Color darkBackground = Color(
    0xFF1C1C1C,
  ); // Very dark charcoal from image

  // Card backgrounds
  static const Color lightCard = Color(0xFFF9FBFF);
  static const Color darkCard = Color(
    0xFF2C2C2C,
  ); // Dark gray for containers/app bar from image

// ✅ ألوان السبحة للدارك مود
  static const Color darkTasbihPrimary = Color(0xFF5D4E6D);    // بنفسجي داكن
  static const Color darkTasbihLight = Color(0xFF7D6E8D);      // بنفسجي فاتح
  static const Color darkTasbihDark = Color(0xFF3D2E4D);       // بنفسجي غامق
  // Tasbih screen background
  static const Color tasbihBackground = Color(0xFFF5F0EB);

  // Primary sebha body colors
  static const Color sebhaBlue = Color(0xFF0E4D9C);
  static const Color sebhaGreen = Color(0xFF11A062);

  // Accent colors
  static const Color accentGreen = Color(0xFF16C79A);
  static const Color accentYellow = Color(0xFFF1B97A);
  static const Color accentGold = Color(
    0xFFF1B97A,
  ); // Orange/Gold accent from image

  // Text colors
  static const Color textDark = Color(0xFF1C1F26);
  static const Color textLight = Color(0xFFFFFFFF); // White text from image
  static const Color textSecondary = Color(
    0xFFCCCCCC,
  ); // Light gray secondary text from image

  // Dark mode specific colors from image
  static const Color darkProgressBar = Color(
    0xFF505050,
  ); // Medium gray for progress bar/inactive
  static const Color darkTasbihCasing = Color(
    0xFF3A3A3A,
  ); // Dark gray for tasbih device casing

  // Shadow colors for neumorphism
  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFB8C3D8);

  static const Color lightShadowDarkTheme = Color(0xFF222838);
  static const Color darkShadowDarkTheme = Color(0xFF05070C);
}
