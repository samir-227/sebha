import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The main "tasbih device" body (pill-shaped) area.
///
/// Stateless because it only composes UI given current [count] and callbacks.
class TasbihCounterBody extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final Widget counterDisplay;

  const TasbihCounterBody({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.counterDisplay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? AppColors.darkTasbihCasing
        : Theme.of(context).colorScheme.secondary;
    final innerCircle = isDark ? AppColors.darkCard : const Color(0xFFC09561);

    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive sizes based on screen width (using 55% of screen width as base)
    final baseWidth = screenWidth * 0.4;
    final deviceWidth = baseWidth.clamp(180.0, 260.0); // Min 180, Max 260
    final deviceHeight = deviceWidth * 1.286; // Maintain aspect ratio (360/280)

    // Responsive inner circle size (50% of device width)
    final innerCircleSize = deviceWidth * 0.4;

    // Responsive padding and positioning
    final topPadding = deviceHeight * 0.194; // ~70/360
    final sidePadding = deviceWidth * 0.107; // ~30/280
    final bottomPadding = deviceHeight * 0.1; // ~36/360
    final borderRadius = deviceWidth * 0.429; // ~120/280

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                  blurRadius: 20,
                  offset: Offset(0, deviceHeight * 0.028), // Responsive offset
                ),
              ],
            ),
            child: Stack(
              children: [
                // Counter screen area.
                Positioned(
                  top: topPadding,
                  left: sidePadding,
                  right: sidePadding,
                  child: counterDisplay,
                ),

                // Tap circle area.
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Container(
                      width: innerCircleSize,
                      height: innerCircleSize,
                      decoration: BoxDecoration(
                        color: innerCircle,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
