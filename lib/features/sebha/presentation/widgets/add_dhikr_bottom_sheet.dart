import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/sebha_cubit.dart';

Future<void> showAddDhikrBottomSheet(BuildContext context) async {
  // Step 1: اختيار النوع بـ dialog عصري
  final selected = await showGeneralDialog<DhikrCategory>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _CategorySelectionDialog();
    },
  );

  if (selected == null || !context.mounted) return;

  // Step 2: إدخال النص
  final controller = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _AddTextBottomSheet(
        category: selected,
        controller: controller,
      );
    },
  );
}

// ==================== Dialog الاختيار ====================

class _CategorySelectionDialog extends StatelessWidget {
  const _CategorySelectionDialog();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.85,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الأيقونة العلوية
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : const Color(0xFFF0F7FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 40,
                    color: isDark
                        ? Colors.white70
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // العنوان
                Text(
                  'إضافة جديد',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اختر نوع النص الذي تريد إضافته',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 28),

                // خيارات الاختيار
                Row(
                  children: [
                    Expanded(
                      child: _SelectionCard(
                        icon: Icons.auto_awesome_rounded,
                        label: 'ذِكر',
                        subtitle: 'أذكار وتسابيح',
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                        onTap: () => Navigator.of(context).pop(DhikrCategory.adhkar),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SelectionCard(
                        icon: Icons.favorite_rounded,
                        label: 'دعاء',
                        subtitle: 'أدعية متنوعة',
                        color: const Color(0xFFF59E0B),
                        isDark: isDark,
                        onTap: () => Navigator.of(context).pop(DhikrCategory.dua),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // زر الإلغاء
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== كارت الاختيار ====================

class _SelectionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<_SelectionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.color.withOpacity(0.15)
              : widget.isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isPressed
                ? widget.color
                : widget.isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: widget.isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Bottom Sheet إدخال النص ====================

class _AddTextBottomSheet extends StatelessWidget {
  final DhikrCategory category;
  final TextEditingController controller;

  const _AddTextBottomSheet({
    required this.category,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isAdhkar = category == DhikrCategory.adhkar;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // العنوان مع أيقونة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isAdhkar ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isAdhkar ? Icons.auto_awesome_rounded : Icons.favorite_rounded,
                  color: isAdhkar ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isAdhkar ? 'إضافة ذِكر جديد' : 'إضافة دعاء جديد',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // حقل الإدخال
          TextField(
            controller: controller,
            maxLines: 4,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : Colors.grey.shade800,
            ),
            decoration: InputDecoration(
              hintText: 'اكتب النص هنا...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
              filled: true,
              fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isAdhkar ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 20),

          // زر الحفظ
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<SebhaCubit>().addToCategory(category, controller.text);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdhkar ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'حفظ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}