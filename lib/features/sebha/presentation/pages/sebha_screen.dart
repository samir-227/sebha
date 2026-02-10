import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sebha/features/sebha/presentation/widgets/social_connection_row.dart';

import '../../../../core/theme/theme_controller.dart';
import '../state/sebha_cubit.dart';
import '../widgets/reset_confirm_bottom_sheet.dart';
import '../widgets/end_confirm_bottom_sheet.dart';
import '../widgets/tasbih_counter_body.dart';
import '../widgets/dhikr_actions_column.dart';
import '../widgets/tasbeeh_text_card.dart';
import '../widgets/digital_counter_display.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/add_dhikr_bottom_sheet.dart';
import '../widgets/dhikr_list_bottom_sheet.dart';
import '../widgets/history_bottom_sheet.dart';
import '../utils/responsive_sizing.dart';

/// Main tasbih counter screen.
///
/// Stateless because the counter state is managed by `SebhaCubit` (Provider).
class SebhaScreen extends StatelessWidget {
  const SebhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using watch so the UI rebuilds when the count changes.
    final cubit = context.watch<SebhaCubit>();
    final count = cubit.count;
    final themeController = context.watch<ThemeController>();

    void incrementCounter() => cubit.increment();

    Future<void> resetCounter() async {
      // Show confirmation in Arabic, then reset only on confirm.
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: ResetConfirmBottomSheet(
              count: count,
              onConfirmReset: cubit.reset,
            ),
          );
        },
      );
    }

    Future<void> endCounter() async {
      // Show a confirmation bottom sheet before ending the current session.
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: EndConfirmBottomSheet(
              count: count,
              onConfirmEnd: cubit.endCurrentSession,
            ),
          );
        },
      );
    }

    final isDark =
        Theme.of(context).brightness == Brightness.dark ||
        themeController.isDark;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sizing = ResponsiveSizing(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'السبحة',
          style: TextStyle(
            fontSize: sizing.titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,
        leading: IconButton(
          onPressed: themeController.toggleTheme,
          icon: Icon(
            isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            color: colorScheme.secondary,
            size: sizing.iconSize,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: sizing.verticalSpacing),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizing.horizontalPadding),
            child: TasbeehTextCard(text: cubit.currentDhikr),
          ),
          SizedBox(height: sizing.verticalSpacing),

          // Top section: dhikr action buttons + tasbih device.
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizing.horizontalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DhikrActionsColumn(
                    onAddPressed: () => showAddDhikrBottomSheet(context),
                    onAdhkarPressed: () =>
                        showDhikrListBottomSheet(context, isAdhkar: true),
                    onDuaPressed: () =>
                        showDhikrListBottomSheet(context, isAdhkar: false),
                  ),
                  SizedBox(width: sizing.verticalSpacing),
                  TasbihCounterBody(
                    count: count,
                    onIncrement: incrementCounter,
                    // counterDisplay: DigitalCounterDisplay(count: count),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          ActionButtonsRow(
            onReset: resetCounter,
            onEnd: endCounter,
            onHistory: () => showHistoryBottomSheet(context),
            buttonSize: sizing.buttonSize,
            endButtonWidth: sizing.endButtonWidth,
            buttonHeight: sizing.buttonHeight,
            iconSize: sizing.iconSize,
            fontSize: sizing.fontSize,
            horizontalPadding: sizing.actionButtonPadding,
            isDark: isDark,
          ),
          SizedBox(height: sizing.verticalSpacing),
          const SocialConnectionRow(),

          SizedBox(height: sizing.bottomPadding),
        ],
      ),
    );
  }
}
