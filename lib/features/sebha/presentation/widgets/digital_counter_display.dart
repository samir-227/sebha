import 'package:flutter/material.dart';

class DigitalCounterDisplay extends StatelessWidget {
  final int count;

  const DigitalCounterDisplay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final height = (screenWidth * 0.22).clamp(70.0, 95.0);
    final fontSize = (screenWidth * 0.12).clamp(32.0, 48.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1A2A1A), const Color(0xFF0D1A0D)]
              : [const Color(0xFF2A3A2A), const Color(0xFF1A2A1A)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade700,
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            count.toString().padLeft(4, '0'),
            key: ValueKey(count),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00FF41),
              fontFamily: 'monospace',
              letterSpacing: fontSize * 0.1,
              shadows: [
                Shadow(
                  color: const Color(0xFF00FF41).withOpacity(0.8),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
