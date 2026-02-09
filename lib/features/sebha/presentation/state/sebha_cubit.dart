import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/tasbeeh_model.dart';
import '../../domain/entities/tasbeeh.dart';
import '../../domain/usecases/increment_counter.dart';
import '../../domain/usecases/reset_counter.dart';

/// نوع النص الحالي (أذكار أو أدعية).
enum DhikrCategory { adhkar, dua }

/// عنصر واحد في سجل الأذكار/الأدعية المنتهية.
class TasbeehHistoryEntry {
  final String text;
  final int count;
  final DhikrCategory category;
  final DateTime timestamp;

  const TasbeehHistoryEntry({
    required this.text,
    required this.count,
    required this.category,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'count': count,
        'category': category.name,
        'timestamp': timestamp.toIso8601String(),
      };

  factory TasbeehHistoryEntry.fromJson(Map<String, dynamic> json) {
    return TasbeehHistoryEntry(
      text: json['text'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      category: (json['category'] as String?) == 'dua'
          ? DhikrCategory.dua
          : DhikrCategory.adhkar,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// رغم الاسم "Cubit" إلا أننا نستخدم [ChangeNotifier] مع Provider
/// ليبقى الكود خفيفاً، مع الحفاظ على فصل منطق الأعمال عن الـ UI.
///
/// Stateful هنا لأن هذه الطبقة تمثل "حالة" التطبيق وتغيّرها مع الوقت.
class SebhaCubit extends ChangeNotifier {
  SebhaCubit()
      : _tasbeeh = TasbeehModel.initial(),
        _incrementCounter = const IncrementCounter(),
        _resetCounter = const ResetCounter() {
    // تأكد أن الذكر المبدئي متزامن مع قائمة الأذكار.
    _tasbeeh = _tasbeeh.copyWith(currentDhikr: _adhkar[_adhkarIndex]);
    _loadHistory();
  }

  Tasbeeh _tasbeeh;
  final IncrementCounter _incrementCounter;
  final ResetCounter _resetCounter;

// قوائم الأذكار والأدعية. يمكن لاحقاً تحميلها من تخزين محلي.
final List<String> _adhkar = <String>[
  'سُبحانَ اللَّهِ وبحمدِهِ',
  'سُبحانَ اللَّهِ العظيم',
  'الْحَمْدُ للَّهِ رَبِّ الْعَالَمِينَ',
  'لَا إِلَهَ إِلَّا اللَّهُ',
  'اللَّهُ أَكْبَرُ',
  'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
  'أستغفرُ اللَّهَ العظيم وأتوبُ إليه',
  'اللهم صلِّ وسلم على نبينا محمد',
];

final List<String> _duas = <String>[
  'اللهم إنك عفوٌ تحب العفو فاعفُ عني',
  'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً',
  'اللهم اهدِ قلبي، واشرح صدري، ويسِّر أمري',
  'اللهم اغفر لي ذنبي كله، دقه وجله، أوله وآخره',
  'اللهم إني أسألك رضاك والجنة، وأعوذ بك من سخطك والنار',
  'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ',
];

  int _adhkarIndex = 0;
  int _duaIndex = 0;
  DhikrCategory _category = DhikrCategory.adhkar;
  final List<TasbeehHistoryEntry> _history = <TasbeehHistoryEntry>[];

  Tasbeeh get state => _tasbeeh;

  int get count => _tasbeeh.count;
  String get currentDhikr => _tasbeeh.currentDhikr;

  DhikrCategory get currentCategory => _category;

  List<TasbeehHistoryEntry> get history => List.unmodifiable(_history);

  /// إرجاع القوائم كـ read‑only حتى لا تُعدّل من الـ UI مباشرة.
  List<String> get adhkar => List.unmodifiable(_adhkar);
  List<String> get duas => List.unmodifiable(_duas);

  static const _historyPrefsKey = 'sebha_history_entries';

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_historyPrefsKey) ?? <String>[];
    _history
      ..clear()
      ..addAll(
        rawList
            .map((e) => jsonDecode(e) as Map<String, dynamic>)
            .map(TasbeehHistoryEntry.fromJson),
      );
    if (_history.isNotEmpty) {
      notifyListeners();
    }
  }

  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _history
        .map(
          (e) => jsonEncode(e.toJson()),
        )
        .toList();
    await prefs.setStringList(_historyPrefsKey, encoded);
  }

  void increment() {
    _tasbeeh = _incrementCounter(_tasbeeh);
    notifyListeners();
  }

  void reset() {
    _tasbeeh = _resetCounter(_tasbeeh);
    notifyListeners();
  }

  /// الانتقال إلى وضع الأذكار، مع إمكانية الانتقال للذكر التالي.
  void switchToAdhkar({bool next = false}) {
    _category = DhikrCategory.adhkar;
    if (next && _adhkar.isNotEmpty) {
      _adhkarIndex = (_adhkarIndex + 1) % _adhkar.length;
    }
    if (_adhkar.isNotEmpty) {
      _tasbeeh = _tasbeeh.copyWith(currentDhikr: _adhkar[_adhkarIndex]);
      notifyListeners();
    }
  }

  /// الانتقال إلى وضع الأدعية، مع إمكانية الانتقال للدعاء التالي.
  void switchToDua({bool next = false}) {
    _category = DhikrCategory.dua;
    if (next && _duas.isNotEmpty) {
      _duaIndex = (_duaIndex + 1) % _duas.length;
    }
    if (_duas.isNotEmpty) {
      _tasbeeh = _tasbeeh.copyWith(currentDhikr: _duas[_duaIndex]);
      notifyListeners();
    }
  }

  /// إضافة ذكر/دعاء جديد إلى القائمة الحالية واختياره مباشرة.
  void addToCurrentCategory(String text) {
    addToCategory(_category, text);
  }

  /// إضافة نص جديد إلى قائمة معيّنة (أذكار أو أدعية) واختياره مباشرة.
  void addToCategory(DhikrCategory category, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _category = category;

    if (category == DhikrCategory.adhkar) {
      _adhkar.add(trimmed);
      _adhkarIndex = _adhkar.length - 1;
    } else {
      _duas.add(trimmed);
      _duaIndex = _duas.length - 1;
    }

    _tasbeeh = _tasbeeh.copyWith(currentDhikr: trimmed);
    notifyListeners();
  }

  void selectAdhkarAt(int index) {
    if (_adhkar.isEmpty) return;
    _category = DhikrCategory.adhkar;
    _adhkarIndex = index.clamp(0, _adhkar.length - 1);
    _tasbeeh = _tasbeeh.copyWith(currentDhikr: _adhkar[_adhkarIndex]);
    notifyListeners();
  }

  void selectDuaAt(int index) {
    if (_duas.isEmpty) return;
    _category = DhikrCategory.dua;
    _duaIndex = index.clamp(0, _duas.length - 1);
    _tasbeeh = _tasbeeh.copyWith(currentDhikr: _duas[_duaIndex]);
    notifyListeners();
  }

  /// حذف ذكر من قائمة الأذكار مع تحديث المؤشر والنص الحالي إذا لزم.
  void removeAdhkarAt(int index) {
    if (_adhkar.isEmpty) return;
    final safeIndex = index.clamp(0, _adhkar.length - 1);
    _adhkar.removeAt(safeIndex);

    if (_adhkar.isEmpty) {
      _adhkarIndex = 0;
      if (_category == DhikrCategory.adhkar) {
        _tasbeeh = _tasbeeh.copyWith(currentDhikr: '');
      }
    } else {
      if (_adhkarIndex >= _adhkar.length) {
        _adhkarIndex = _adhkar.length - 1;
      }
      if (_category == DhikrCategory.adhkar) {
        _tasbeeh = _tasbeeh.copyWith(currentDhikr: _adhkar[_adhkarIndex]);
      }
    }
    notifyListeners();
  }

  /// حذف دعاء من قائمة الأدعية مع تحديث المؤشر والنص الحالي إذا لزم.
  void removeDuaAt(int index) {
    if (_duas.isEmpty) return;
    final safeIndex = index.clamp(0, _duas.length - 1);
    _duas.removeAt(safeIndex);

    if (_duas.isEmpty) {
      _duaIndex = 0;
      if (_category == DhikrCategory.dua) {
        _tasbeeh = _tasbeeh.copyWith(currentDhikr: '');
      }
    } else {
      if (_duaIndex >= _duas.length) {
        _duaIndex = _duas.length - 1;
      }
      if (_category == DhikrCategory.dua) {
        _tasbeeh = _tasbeeh.copyWith(currentDhikr: _duas[_duaIndex]);
      }
    }
    notifyListeners();
  }

  /// حذف عنصر من سجل التاريخ.
  Future<void> removeHistoryAt(int index) async {
    if (_history.isEmpty) return;
    final safeIndex = index.clamp(0, _history.length - 1);
    _history.removeAt(safeIndex);
    await _persistHistory();
    notifyListeners();
  }

  /// حفظ الجلسة الحالية في سجل التاريخ مع إنهاء العدّاد.
  Future<void> endCurrentSession() async {
    if (count <= 0) {
      reset();
      return;
    }

    final entry = TasbeehHistoryEntry(
      text: currentDhikr,
      count: count,
      category: _category,
      timestamp: DateTime.now(),
    );

    _history.insert(0, entry);
    // يمكن تحديد حد أقصى لطول السجل إذا رغبت لاحقاً.
    await _persistHistory();
    reset();
  }
}

