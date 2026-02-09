import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neumorphic_button.dart';

/// الأزرار الجانبية (إضافة – الأذكار – الأدعية).
///
/// Stateless لأن كل زر يستدعي كولباك فقط، بدون أي حالة داخلية.
class SideActionButtons extends StatelessWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onAdhkarPressed;
  final VoidCallback onDuaPressed;

  const SideActionButtons({
    super.key,
    required this.onAddPressed,
    required this.onAdhkarPressed,
    required this.onDuaPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSideButton(
          context: context,
          label: 'إضافة',
          color: AppColors.accentGreen,
          onPressed: onAddPressed,
        ),
        const SizedBox(height: 12),
        _buildSideButton(
          context: context,
          label: 'الأذكار',
          color: theme.colorScheme.primary,
          onPressed: onAdhkarPressed,
        ),
        const SizedBox(height: 12),
        _buildSideButton(
          context: context,
          label: 'الأدعية',
          color: AppColors.accentYellow,
          onPressed: onDuaPressed,
        ),
      ],
    );
  }

  Widget _buildSideButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 78,
      child: NeumorphicButton(
        onPressed: onPressed,
        borderRadius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        backgroundColor: color,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

