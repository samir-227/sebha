import 'package:flutter/material.dart';

/// Vertical column of action buttons: Add, Adhkar, Duas.
///
/// Stateless because it exposes callbacks only; all state lives in cubit.
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
    final theme = Theme.of(context);

    ButtonStyle _buildStyle(Color color) {
      return ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.18),
        textStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 90,
          child: ElevatedButton(
            style: _buildStyle(const Color(0xFF16C79A)),
            onPressed: onAddPressed,
            child: const Text('إضافة'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 90,
          child: ElevatedButton(
            style: _buildStyle(const Color(0xFF0E4D9C)),
            onPressed: onAdhkarPressed,
            child: const Text('الأذكار'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 90,
          child: ElevatedButton(
            style: _buildStyle(const Color(0xFFFFC857)),
            onPressed: onDuaPressed,
            child: const Text('الأدعية'),
          ),
        ),
      ],
    );
  }
}
