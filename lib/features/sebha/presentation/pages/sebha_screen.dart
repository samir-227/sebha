import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_controller.dart';
import '../state/sebha_cubit.dart';
import '../widgets/reset_confirm_bottom_sheet.dart';
import '../widgets/end_confirm_bottom_sheet.dart';
import '../widgets/tasbih_counter_body.dart';
import '../widgets/dhikr_actions_column.dart';
import '../widgets/tasbeeh_text_card.dart';
import '../widgets/add_dhikr_bottom_sheet.dart';
import '../widgets/dhikr_list_bottom_sheet.dart';
import '../widgets/history_bottom_sheet.dart';
import '../widgets/social_connection_row.dart';

class SebhaScreen extends StatelessWidget {
  const SebhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SebhaCubit>();
    final count = cubit.count;
    final themeController = context.watch<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    void incrementCounter() => cubit.increment();

    Future<void> resetCounter() async {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _ModernBottomSheet(
          child: ResetConfirmBottomSheet(
            count: count,
            onConfirmReset: cubit.reset,
          ),
        ),
      );
    }

    Future<void> endCounter() async {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _ModernBottomSheet(
          child: EndConfirmBottomSheet(
            count: count,
            onConfirmEnd: cubit.endCurrentSession,
          ),
        ),
      );
    }

    final bgGradient = isDark
        ? [const Color(0xFF0F0F1A), const Color(0xFF1A1A2E)]
        : [const Color(0xFFF8FAFC), const Color(0xFFEEF2F6)];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgGradient,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // ===== App Bar =====
                  _ModernAppBar(
                    isDark: isDark,
                    onThemeToggle: themeController.toggleTheme,
                  ),

                  const SizedBox(height: 12),

                  // ===== كارت الذكر =====
                  TasbeehTextCard(text: cubit.currentDhikr),

                  // ===== السبحة + الأزرار =====
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DhikrActionsColumn(
                            onAddPressed: () =>
                                showAddDhikrBottomSheet(context),
                            onAdhkarPressed: () => showDhikrListBottomSheet(
                              context,
                              isAdhkar: true,
                            ),
                            onDuaPressed: () => showDhikrListBottomSheet(
                              context,
                              isAdhkar: false,
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          TasbihCounterBody(
                            count: count,
                            onIncrement: incrementCounter,
                            onReset: cubit.reset,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== أزرار الإجراءات =====
                  _ModernActionButtons(
                    onReset: resetCounter,
                    onEnd: endCounter,
                    onHistory: () => showHistoryBottomSheet(context),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // ===== روابط التواصل =====
                  const SocialConnectionRow(),

                  const SizedBox(height: 12),

                  // ===== لا تنسوني من دعائكم =====
                  _DuaRequestText(isDark: isDark),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== نص الدعاء ====================
class _DuaRequestText extends StatelessWidget {
  final bool isDark;

  const _DuaRequestText({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? const Color(0xFFFFD700).withOpacity(0.6)
        : const Color(0xFFD4A574);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite, size: 12, color: color),
        const SizedBox(width: 8),
        Text(
          'لا تنسونا من صالح دعائكم',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.favorite, size: 12, color: color),
      ],
    );
  }

  Widget _buildDecoration() {
    return Icon(
      Icons.star,
      size: 10,
      color: isDark
          ? const Color(0xFFFFD700).withOpacity(0.5)
          : const Color(0xFFD4A574).withOpacity(0.6),
    );
  }
}

// ==================== Custom App Bar ====================

class _ModernAppBar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const _ModernAppBar({required this.isDark, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            onPressed: onThemeToggle,
            isDark: isDark,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: isDark
                      ? const Color(0xFFFFD700)
                      : const Color(0xFFD4A574),
                ),
                const SizedBox(width: 8),
                Text(
                  'السبحة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        transform: Matrix4.identity()..scale(_isPressed ? 0.9 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        child: Icon(
          widget.icon,
          color: widget.isDark
              ? const Color(0xFFFFD700)
              : const Color(0xFFD4A574),
          size: 22,
        ),
      ),
    );
  }
}

// ==================== أزرار الإجراءات ====================

class _ModernActionButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onEnd;
  final VoidCallback onHistory;
  final bool isDark;

  const _ModernActionButtons({
    required this.onReset,
    required this.onEnd,
    required this.onHistory,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionChip(
            icon: Icons.history_rounded,
            label: 'السجل',
            color: const Color(0xFFF59E0B),
            onPressed: onHistory,
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _ActionChip(
            icon: Icons.check_circle_rounded,
            label: 'إنهاء',
            color: const Color(0xFF10B981),
            onPressed: onEnd,
            isDark: isDark,
            isHighlighted: true,
          ),
          const SizedBox(width: 8),
          _ActionChip(
            icon: Icons.refresh_rounded,
            label: 'إعادة',
            color: const Color(0xFF6366F1),
            onPressed: onReset,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isDark;
  final bool isHighlighted;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isDark,
    this.isHighlighted = false,
  });

  @override
  State<_ActionChip> createState() => _ActionChipState();
}

class _ActionChipState extends State<_ActionChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isHighlighted
              ? widget.color
              : widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.isHighlighted ? Colors.white : widget.color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.isHighlighted
                    ? Colors.white
                    : widget.isDark
                    ? Colors.white
                    : widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Bottom Sheet Wrapper ====================

class _ModernBottomSheet extends StatelessWidget {
  final Widget child;

  const _ModernBottomSheet({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
