import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Bottom sheet shown before ending the current tasbih session.
///
/// Stateless because it only renders UI based on given [count] and callbacks.
class EndConfirmBottomSheet extends StatelessWidget {
  final int count;
  final Future<void> Function() onConfirmEnd;

  const EndConfirmBottomSheet({
    super.key,
    required this.count,
    required this.onConfirmEnd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.flag_rounded,
                size: 28,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'هل أنت متأكد أنك تريد إنهاء التسبيح؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'لقد سبّحت بهذا الذكر $count مرة.\nعند التأكيد سيتم إنهاء الجلسة وتصفير العداد.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      await onConfirmEnd();
                      // بعد حفظ الجلسة يمكن إغلاق الـ BottomSheet.
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('نعم، إنهاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
