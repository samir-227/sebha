import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'digital_counter_display.dart';
import '../../../../core/theme/app_colors.dart';

class TasbihCounterBody extends StatefulWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const TasbihCounterBody({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  State<TasbihCounterBody> createState() => _TasbihCounterBodyState();
}

class _TasbihCounterBodyState extends State<TasbihCounterBody> {
  bool _isPressed = false;

  void _handleTapDown() {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    widget.onIncrement();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final deviceWidth = (screenWidth * 0.52).clamp(180.0, 260.0);
    final deviceHeight = deviceWidth * 1.35;
    final borderRadius = deviceWidth * 0.42;

    final buttonSize = deviceWidth * 0.48;

    // ✅ ألوان مختلفة حسب الثيم
    final Color primaryColor;
    final Color darkColor;
    final Color lightColor;
    final Color borderColor;

    if (isDark) {
      // ألوان الدارك مود - بنفسجي/رمادي معدني
      primaryColor = const Color(0xFF5D4E6D);
      lightColor = const Color(0xFF7D6E8D);
      darkColor = const Color(0xFF3D2E4D);
      borderColor = const Color(0xFF2D1E3D);
    } else {
      // ألوان اللايت مود - من secondary color
      primaryColor = colorScheme.secondary;
      final hslColor = HSLColor.fromColor(primaryColor);
      darkColor = hslColor
          .withLightness((hslColor.lightness - 0.15).clamp(0.0, 1.0))
          .toColor();
      lightColor = hslColor
          .withLightness((hslColor.lightness + 0.1).clamp(0.0, 1.0))
          .toColor();
      borderColor = hslColor
          .withLightness((hslColor.lightness - 0.25).clamp(0.0, 1.0))
          .toColor();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [lightColor, primaryColor, darkColor],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: deviceHeight * 0.12,
                left: deviceWidth * 0.12,
                right: deviceWidth * 0.12,
                child: DigitalCounterDisplay(count: widget.count),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight * 0.1),
                  child: GestureDetector(
                    onTapDown: (_) => _handleTapDown(),
                    onTapUp: (_) => _handleTapUp(),
                    onTapCancel: _handleTapCancel,
                    child: _buildMainButton(
                      buttonSize,
                      borderColor,
                      primaryColor,
                      isDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(
    double size,
    Color borderColor,
    Color textColor,
    bool isDark,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: size,
      height: size,
      transform: Matrix4.translationValues(0, _isPressed ? 3 : 0, 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: _isPressed
              ? isDark
                    ? [const Color(0xFF3A3A3A), const Color(0xFF2A2A2A)]
                    : [const Color(0xFFD0D0D0), const Color(0xFFB0B0B0)]
              : isDark
              ? [
                  const Color(0xFF4A4A4A),
                  const Color(0xFF3A3A3A),
                  const Color(0xFF2A2A2A),
                ]
              : [
                  const Color(0xFFF5F5F5),
                  const Color(0xFFE0E0E0),
                  const Color(0xFFCCCCCC),
                ],
        ),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: _isPressed
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.6 : 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                if (!isDark)
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 4,
                    offset: Offset(-2, -2),
                  ),
              ],
      ),
      child: Center(
        child: Text(
          'اضغط',
          style: TextStyle(
            fontSize: size * 0.22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : textColor,
          ),
        ),
      ),
    );
  }
}
