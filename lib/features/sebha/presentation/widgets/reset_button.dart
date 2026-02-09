import 'package:flutter/material.dart';

import '../../../../core/animations/tap_scale_animation.dart';
import '../../../../core/theme/app_colors.dart';

/// زر إعادة التعيين الصغير بجوار شاشة العداد.
///
/// Stateless لأن حالة العداد نفسها موجودة في `SebhaCubit`.
class ResetButton extends StatelessWidget {
  final VoidCallback onReset;

  const ResetButton({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TapScaleAnimation(
      onTap: onReset,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.6 : 0.16),
              blurRadius: 10,
              offset: const Offset(3, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'RESET',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
        ),
      ),
    );
  }
}

