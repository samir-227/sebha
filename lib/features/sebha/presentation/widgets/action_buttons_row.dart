import 'package:flutter/material.dart';

/// Row of action buttons (Reset, End, History) at the bottom of the screen.
class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onEnd;
  final VoidCallback onHistory;
  final double buttonSize;
  final double endButtonWidth;
  final double buttonHeight;
  final double iconSize;
  final double fontSize;
  final double horizontalPadding;
  final bool isDark;

  const ActionButtonsRow({
    super.key,
    required this.onReset,
    required this.onEnd,
    required this.onHistory,
    required this.buttonSize,
    required this.endButtonWidth,
    required this.buttonHeight,
    required this.iconSize,
    required this.fontSize,
    required this.horizontalPadding,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Reset button
          _ActionButton(
            onPressed: onReset,
            icon: Icons.refresh,
            size: buttonSize,
            height: buttonHeight,
            iconSize: iconSize,
            colorScheme: colorScheme,
            theme: theme,
            isDark: isDark,
          ),
          // End button
          Container(
            width: endButtonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(buttonSize * 0.286),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: Offset(0, buttonHeight * 0.071),
                ),
              ],
            ),
            child: TextButton(
              onPressed: onEnd,
              child: Text(
                'End',
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // History button
          _ActionButton(
            onPressed: onHistory,
            icon: Icons.history,
            size: buttonSize,
            height: buttonHeight,
            iconSize: iconSize,
            colorScheme: colorScheme,
            theme: theme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final double height;
  final double iconSize;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final bool isDark;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.size,
    required this.height,
    required this.iconSize,
    required this.colorScheme,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: height,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(size * 0.286),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: Offset(0, height * 0.071),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: colorScheme.secondary,
          size: iconSize,
        ),
      ),
    );
  }
}
