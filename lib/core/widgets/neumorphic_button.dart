import 'package:flutter/material.dart';

import '../animations/tap_scale_animation.dart';
import '../theme/app_colors.dart';

/// زر نيو مرفيك عام يمكن استخدامه في أماكن متعددة.
///
/// Stateless لأن الزر لا يحتفظ بأي حالة داخلية، بل يعتمد على الكولباك
/// القادم من الطبقة الأعلى (state management في الـ presentation).
class NeumorphicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? backgroundColor;

  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius = 32,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = backgroundColor ??
        (isDark ? AppColors.darkCard : AppColors.lightCard);

    final Color topShadow =
        isDark ? AppColors.lightShadowDarkTheme : AppColors.lightShadow;
    final Color bottomShadow =
        isDark ? AppColors.darkShadowDarkTheme : AppColors.darkShadow;

    return TapScaleAnimation(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: bottomShadow.withOpacity(0.8),
              offset: const Offset(6, 6),
              blurRadius: 14,
            ),
            BoxShadow(
              color: topShadow.withOpacity(0.9),
              offset: const Offset(-6, -6),
              blurRadius: 14,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

