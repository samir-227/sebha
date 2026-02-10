import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/sebha_cubit.dart';

Future<void> showDhikrListBottomSheet(
  BuildContext context, {
  required bool isAdhkar,
}) async {
  final cubit = context.read<SebhaCubit>();
  final items = isAdhkar ? cubit.adhkar : cubit.duas;

  if (items.isEmpty) {
    _showEmptyDialog(context, isAdhkar);
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _DhikrListSheet(
      isAdhkar: isAdhkar,
      cubit: cubit,
      items: items,
    ),
  );
}

void _showEmptyDialog(BuildContext context, bool isAdhkar) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAdhkar ? Icons.auto_awesome_rounded : Icons.favorite_rounded,
            size: 48,
            color: isAdhkar ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 16),
          Text(
            isAdhkar ? 'لا توجد أذكار' : 'لا توجد أدعية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على زر الإضافة لإضافة ${isAdhkar ? "ذكر" : "دعاء"} جديد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('حسناً'),
        ),
      ],
    ),
  );
}

class _DhikrListSheet extends StatefulWidget {
  final bool isAdhkar;
  final SebhaCubit cubit;
  final List<String> items;

  const _DhikrListSheet({
    required this.isAdhkar,
    required this.cubit,
    required this.items,
  });

  @override
  State<_DhikrListSheet> createState() => _DhikrListSheetState();
}

class _DhikrListSheetState extends State<_DhikrListSheet> {
  late List<String> allItems;
  late List<String> filteredItems;
  String? selectedText;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    allItems = List<String>.from(widget.items);
    filteredItems = List<String>.from(allItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _applyFilter(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredItems = List<String>.from(allItems);
      } else {
        filteredItems = allItems.where((text) => text.contains(query.trim())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    final accentColor = widget.isAdhkar 
        ? const Color(0xFF10B981) 
        : const Color(0xFFF59E0B);

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.75),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== المقبض =====
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ===== العنوان =====
            _buildHeader(isDark, accentColor),
            const SizedBox(height: 20),

            // ===== حقل البحث =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchField(isDark, accentColor),
            ),
            const SizedBox(height: 16),

            // ===== القائمة =====
            Flexible(
              child: filteredItems.isEmpty
                  ? _buildEmptySearch(isDark)
                  : _buildList(isDark, accentColor),
            ),

            // ===== زر الاختيار =====
            _buildSelectButton(isDark, accentColor),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.isAdhkar ? Icons.auto_awesome_rounded : Icons.favorite_rounded,
            color: accentColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isAdhkar ? 'الأذكار' : 'الأدعية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
            Text(
              '${allItems.length} ${widget.isAdhkar ? "ذكر" : "دعاء"}',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(bool isDark, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        textDirection: TextDirection.rtl,
        onChanged: _applyFilter,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          hintText: widget.isAdhkar ? 'ابحث في الأذكار...' : 'ابحث في الأدعية...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilter('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildEmptySearch(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(bool isDark, Color accentColor) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final text = filteredItems[index];
        final isSelected = text == selectedText;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Dismissible(
            key: ValueKey('${widget.isAdhkar ? 'adhkar' : 'dua'}_${text.hashCode}'),
            direction: DismissDirection.endToStart,
            background: _buildDismissBackground(),
            confirmDismiss: (_) => _confirmDelete(context, isDark),
            onDismissed: (_) => _deleteItem(text, index),
            child: _buildListItem(text, isSelected, isDark, accentColor, index),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'حذف',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, bool isDark) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(color: isDark ? Colors.white : Colors.grey.shade800),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا ${widget.isAdhkar ? "الذكر" : "الدعاء"}؟',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'إلغاء',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  void _deleteItem(String text, int index) {
    final currentList = widget.isAdhkar ? widget.cubit.adhkar : widget.cubit.duas;
    final realIndex = currentList.indexOf(text);
    
    if (realIndex != -1) {
      if (widget.isAdhkar) {
        widget.cubit.removeAdhkarAt(realIndex);
      } else {
        widget.cubit.removeDuaAt(realIndex);
      }
    }
    
    setState(() {
      allItems.remove(text);
      filteredItems.removeAt(index);
      if (selectedText == text) {
        selectedText = null;
      }
    });
  }

  Widget _buildListItem(String text, bool isSelected, bool isDark, Color accentColor, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedText = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(isDark ? 0.2 : 0.1)
              : isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // رقم العنصر
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor
                    : isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isSelected
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // النص
            Expanded(
              child: Text(
                text,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ),

            // سهم السحب للحذف
            Icon(
              Icons.chevron_left_rounded,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(bool isDark, Color accentColor) {
    final isEnabled = selectedText != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: isEnabled ? _selectItem : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? LinearGradient(
                    colors: [
                      accentColor,
                      HSLColor.fromColor(accentColor)
                          .withLightness(
                            (HSLColor.fromColor(accentColor).lightness - 0.1)
                                .clamp(0.0, 1.0),
                          )
                          .toColor(),
                    ],
                  )
                : null,
            color: isEnabled ? null : (isDark ? Colors.white12 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: isEnabled
                    ? Colors.white
                    : isDark
                        ? Colors.white38
                        : Colors.grey.shade400,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                widget.isAdhkar ? 'اختيار الذكر' : 'اختيار الدعاء',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isEnabled
                      ? Colors.white
                      : isDark
                          ? Colors.white38
                          : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectItem() {
    if (selectedText == null) return;

    final currentList = widget.isAdhkar ? widget.cubit.adhkar : widget.cubit.duas;
    final selectedIndex = currentList.indexOf(selectedText!);

    if (selectedIndex != -1) {
      if (widget.isAdhkar) {
        widget.cubit.selectAdhkarAt(selectedIndex);
      } else {
        widget.cubit.selectDuaAt(selectedIndex);
      }
    }
    Navigator.of(context).pop();
  }
}