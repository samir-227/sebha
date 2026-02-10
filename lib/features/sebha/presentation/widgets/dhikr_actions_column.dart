import 'package:flutter/material.dart';

class DhikrActionsColumn extends StatelessWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onAdhkarPressed;
  final VoidCallback onDuaPressed;

  const DhikrActionsColumn({
    super.key,
    required this.onAddPressed,
    required this.onAdhkarPressed,
    required this.onDuaPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = (screenWidth * 0.13).clamp(48.0, 60.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: Icons.add_rounded,
          label: 'إضافة',
          color: const Color(0xFF10B981),
          onPressed: onAddPressed,
          size: buttonSize,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        _ActionButton(
          icon: Icons.auto_awesome_rounded,
          label: 'الأذكار',
          color: const Color(0xFF3B82F6),
          onPressed: onAdhkarPressed,
          size: buttonSize,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        _ActionButton(
          icon: Icons.favorite_rounded,
          label: 'الأدعية',
          color: const Color(0xFFF59E0B),
          onPressed: onDuaPressed,
          size: buttonSize,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.size,
    required this.isDark,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.size,
            height: widget.size,
            transform: Matrix4.identity()..scale(_isPressed ? 0.9 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color.withOpacity(_isPressed ? 0.8 : 1.0),
                  HSLColor.fromColor(widget.color)
                      .withLightness(
                        (HSLColor.fromColor(widget.color).lightness - 0.15)
                            .clamp(0.0, 1.0),
                      )
                      .toColor(),
                ],
              ),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: widget.color.withOpacity(
                          widget.isDark ? 0.3 : 0.4,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: widget.size * 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: widget.isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
