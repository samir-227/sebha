/// كيان الدومين يمثل حالة السبحة فقط بدون أي تفاصيل UI.
class Tasbeeh {
  final int count;
  final String currentDhikr;

  const Tasbeeh({
    required this.count,
    required this.currentDhikr,
  });

  Tasbeeh copyWith({
    int? count,
    String? currentDhikr,
  }) {
    return Tasbeeh(
      count: count ?? this.count,
      currentDhikr: currentDhikr ?? this.currentDhikr,
    );
  }
}

