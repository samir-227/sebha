import 'package:flutter/material.dart';

/// بسيط: يضيف أنيميشن تكبير/تصغير عند الضغط يمكن إعادة استخدامه مع أي زر.
///
/// Stateless لأن الأنيميشن يُبنى باستخدام [TweenAnimationBuilder] الذي يدير
/// حالته داخلياً بدون الحاجة إلى [StatefulWidget].
class TapScaleAnimation extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const TapScaleAnimation({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 160),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, value, child) {
          // نستخدم AnimatedScale مع AnimatedOpacity لنعطي إحساس ضغط ناعم.
          return Listener(
            onPointerDown: (_) {},
            child: AnimatedScale(
              scale: 0.97,
              duration: const Duration(milliseconds: 90),
              curve: Curves.easeOut,
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}

