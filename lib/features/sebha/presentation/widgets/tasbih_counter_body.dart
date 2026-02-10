import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import 'digital_counter_display.dart';

class TasbihCounterBody extends StatefulWidget {
  final int count;
  final VoidCallback onIncrement;

  const TasbihCounterBody({
    super.key,
    required this.count,
    required this.onIncrement,
  });

  @override
  State<TasbihCounterBody> createState() => _TasbihCounterBodyState();
}

class _TasbihCounterBodyState extends State<TasbihCounterBody>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    setState(() => _isPressed = true);
    _pulseController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    _pulseController.reverse();
    widget.onIncrement();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pulseController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final deviceWidth = (screenWidth * 0.5).clamp(200.0, 280.0);
    final deviceHeight = deviceWidth * 1.5;
    final borderRadius = deviceWidth * 0.4;

    final topPadding = deviceHeight * 0.12;
    final sidePadding = deviceWidth * 0.1;
    final bottomPadding = deviceHeight * 0.12;
    final buttonSize = deviceWidth * 0.5;

    final casingGradient = isDark
        ? [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)]
        : [const Color(0xFFE8C896), const Color(0xFFD4A574)];

    final casingBorder = isDark
        ? const Color(0xFF404040)
        : const Color(0xFFBF8A50);

    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: casingGradient,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: casingBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.5 : 0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.2),
                blurRadius: 20,
                offset: const Offset(-10, -10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // تأثير اللمعان
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius - 3),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.center,
                      colors: [
                        Colors.white.withOpacity(isDark ? 0.08 : 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ الشاشة - تستخدم widget.count مباشرة
              Positioned(
                top: topPadding,
                left: sidePadding,
                right: sidePadding,
                child: _buildScreenFrame(
                  isDark,
                  DigitalCounterDisplay(count: widget.count), // ✅ هنا الحل
                ),
              ),

              // زر العد
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: GestureDetector(
                    onTapDown: (_) => _handleTapDown(),
                    onTapUp: (_) => _handleTapUp(),
                    onTapCancel: _handleTapCancel,
                    child: _buildCountButton(isDark, buttonSize),
                  ),
                ),
              ),

              // حلقة التعليق
              Positioned(
                top: -deviceWidth * 0.08,
                left: 0,
                right: 0,
                child: _buildRing(isDark, deviceWidth * 0.15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenFrame(bool isDark, Widget display) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade600,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: display,
    );
  }

  Widget _buildCountButton(bool isDark, double size) {
    final pressedOffset = _isPressed ? 2.0 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: size,
      height: size,
      transform: Matrix4.translationValues(0, pressedOffset, 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: isDark
              ? [
                  const Color(0xFF4A4A4A),
                  const Color(0xFF2A2A2A),
                  const Color(0xFF1A1A1A),
                ]
              : [
                  const Color(0xFFF0D0A0),
                  const Color(0xFFD4A574),
                  const Color(0xFFB8885C),
                ],
        ),
        border: Border.all(
          color: isDark ? Colors.grey.shade600 : const Color(0xFFA06830),
          width: 3,
        ),
        boxShadow: _isPressed
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.6 : 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(isDark ? 0.05 : 0.3),
                  blurRadius: 10,
                  offset: const Offset(-5, -5),
                ),
              ],
      ),
      child: Center(
        child: Container(
          width: size * 0.6,
          height: size * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [Colors.grey.shade700, Colors.grey.shade800]
                  : [const Color(0xFFE8C090), const Color(0xFFC49060)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRing(bool isDark, double size) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey.shade600, Colors.grey.shade800]
                : [const Color(0xFFD4A574), const Color(0xFF8B6B4A)],
          ),
          border: Border.all(
            color: isDark ? Colors.grey.shade500 : const Color(0xFF6B4B2A),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFF3A3A3A),
            ),
          ),
        ),
      ),
    );
  }
}