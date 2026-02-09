import 'package:flutter/material.dart';

/// البطاقة التي تحتوي على نص الذكر في أعلى السبحة.
///
/// Stateless لأن النص يأتي من طبقة الحالة ولا يتغير هنا إلا بإعادة بناء
/// الويدجت نفسه.
class TasbeehTextCard extends StatelessWidget {
  final String text;

  const TasbeehTextCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium?.copyWith(
          height: 1.6,
        ),
      ),
    );
  }
}

