import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Dark theme matching the same neumorphic language but on dark surfaces.
ThemeData buildDarkTheme() {
  const borderRadius = BorderRadius.all(Radius.circular(24));

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentGold, // Use orange/gold as primary accent
      secondary: AppColors.accentGold,
      surface: AppColors.darkCard,
      onSurface: AppColors.textLight,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCard, // App bar uses secondary background
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.accentGold),
      titleTextStyle: TextStyle(
        color: AppColors.textLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 18,
      shadowColor: AppColors.darkShadowDarkTheme,
      margin: EdgeInsets.zero,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
      titleMedium: TextStyle(
        color: AppColors.textLight,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: AppColors.textLight,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
    useMaterial3: true,
  );
}

