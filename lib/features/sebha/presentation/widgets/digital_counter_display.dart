import 'package:flutter/material.dart';
import 'package:sebha/core/theme/app_colors.dart';

/// Digital counter "screen" widget inside the device body.
///
/// Stateless because animation is driven by [count] only.
class DigitalCounterDisplay extends StatelessWidget {
  final int count;

  const DigitalCounterDisplay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive counter display sizing
    final counterHeight = (screenHeight * 0.12).clamp(
      80.0,
      120.0,
    ); // 12% of height, min 80, max 120
    final fontSize = (screenWidth * 0.12).clamp(
      32.0,
      56.0,
    ); // 12% of width, min 32, max 56
    final letterSpacing =
        fontSize * 0.167; // Proportional letter spacing (~8/48)
    final borderRadius = counterHeight * 0.2; // 20% of height

    return Container(
      height: counterHeight,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Text(
            '$count',
            key: ValueKey(count),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
              fontFamily: 'monospace',
              letterSpacing: letterSpacing,
            ),
          ),
        ),
      ),
    );
  }
}
