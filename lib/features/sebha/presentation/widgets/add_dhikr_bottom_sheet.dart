import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/sebha_cubit.dart';

/// Bottom sheet for adding a new dhikr or dua.
Future<void> showAddDhikrBottomSheet(BuildContext context) async {
  // Step 1: ask the user what type to add (dhikr or dua).
  final selected = await showDialog<DhikrCategory>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('إضافة إلى'),
        content: const Text('اختر نوع النص الذي تريد إضافته'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(DhikrCategory.adhkar),
            child: const Text('ذِكر'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(DhikrCategory.dua),
            child: const Text('دعاء'),
          ),
        ],
      );
    },
  );

  if (selected == null) return;

  // Step 2: show bottom sheet to enter the text itself.
  final controller = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              selected == DhikrCategory.adhkar
                  ? 'إضافة ذِكر جديد'
                  : 'إضافة دعاء جديد',
              textAlign: TextAlign.center,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'اكتب النص هنا',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ctx.read<SebhaCubit>().addToCategory(selected, controller.text);
                Navigator.of(ctx).pop();
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      );
    },
  );
}
