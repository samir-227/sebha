import 'package:flutter/material.dart';

/// Helper class for calculating responsive sizes based on screen dimensions.
class ResponsiveSizing {
  final double screenWidth;
  final double screenHeight;

  ResponsiveSizing(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  // Spacing
  double get horizontalPadding => screenWidth * 0.04;
  double get verticalSpacing => (screenHeight * 0.02).clamp(12.0, 24.0);
  double get bottomPadding => (screenHeight * 0.05).clamp(30.0, 50.0);
  double get actionButtonPadding => (screenWidth * 0.075).clamp(20.0, 40.0);

  // Button sizes
  double get buttonSize => (screenWidth * 0.14).clamp(48.0, 64.0);
  double get endButtonWidth => (screenWidth * 0.35).clamp(120.0, 160.0);
  double get buttonHeight => (screenHeight * 0.07).clamp(48.0, 64.0);
  double get iconSize => buttonSize * 0.5;

  // Font sizes
  double get fontSize => (screenWidth * 0.045).clamp(16.0, 20.0);
  double get titleFontSize => (screenWidth * 0.048).clamp(16.0, 20.0);
  double get subtitleFontSize => (screenWidth * 0.032).clamp(10.0, 14.0);
}
