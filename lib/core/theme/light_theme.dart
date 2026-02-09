import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light theme with soft neumorphic surfaces.
ThemeData buildLightTheme() {
  const borderRadius = BorderRadius.all(Radius.circular(24));

  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.tasbihBackground,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: AppColors.sebhaBlue,
      secondary: AppColors.accentGold,
      surface: AppColors.lightCard,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 12,
      shadowColor: AppColors.darkShadow,
      margin: EdgeInsets.zero,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 14,
      ),
      titleMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
    useMaterial3: true,
  );
}

