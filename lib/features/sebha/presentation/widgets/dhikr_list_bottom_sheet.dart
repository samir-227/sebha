import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/sebha_cubit.dart';

/// Bottom sheet for selecting a dhikr or dua from the list.
Future<void> showDhikrListBottomSheet(
  BuildContext context, {
  required bool isAdhkar,
}) async {
  final cubit = context.read<SebhaCubit>();
  final items = isAdhkar ? cubit.adhkar : cubit.duas;

  if (items.isEmpty) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final colorScheme = theme.colorScheme;
      var allItems = List<String>.from(items);
      var filteredItems = List<String>.from(allItems);
      String? selectedText;

      return StatefulBuilder(
        builder: (context, setState) {
          void applyFilter(String query) {
            final q = query.trim();
            if (q.isEmpty) {
              filteredItems = List<String>.from(allItems);
            } else {
              filteredItems = allItems.where((text) => text.contains(q)).toList();
            }
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      isAdhkar ? 'اختر الذِكر' : 'اختر الدعاء',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    textDirection: TextDirection.ltr,
                    onChanged: (value) {
                      setState(() {
                        applyFilter(value);
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      hintText: isAdhkar ? 'ابحث عن ذكر' : 'ابحث عن دعاء',
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final text = filteredItems[index];
                        final isSelected = text == selectedText;

                        return Dismissible(
                          key: ValueKey(
                            '${isAdhkar ? 'adhkar' : 'dua'}_${index}_${text.hashCode}',
                          ),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) {
                            final currentList =
                                isAdhkar ? cubit.adhkar : cubit.duas;
                            final realIndex = currentList.indexOf(text);
                            if (realIndex != -1) {
                              if (isAdhkar) {
                                cubit.removeAdhkarAt(realIndex);
                              } else {
                                cubit.removeDuaAt(realIndex);
                              }
                            }
                            setState(() {
                              allItems.remove(text);
                              filteredItems.removeAt(index);
                              if (selectedText == text) {
                                selectedText = null;
                              }
                            });
                          },
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              setState(() {
                                selectedText = text;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.secondary.withOpacity(0.1)
                                    : colorScheme.surface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.secondary
                                      : Colors.transparent,
                                  width: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      text,
                                      textDirection: TextDirection.rtl,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorScheme.secondary,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: colorScheme.onSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: selectedText == null
                          ? null
                          : () {
                              final currentList =
                                  isAdhkar ? cubit.adhkar : cubit.duas;
                              final selectedIndex =
                                  currentList.indexOf(selectedText!);
                              if (selectedIndex != -1) {
                                if (isAdhkar) {
                                  cubit.selectAdhkarAt(selectedIndex);
                                } else {
                                  cubit.selectDuaAt(selectedIndex);
                                }
                              }
                              Navigator.of(ctx).pop();
                            },
                      child: Text(isAdhkar ? 'اختيار الذِكر' : 'اختيار الدعاء'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
