import '../entities/tasbeeh.dart';

/// UseCase: إعادة تعيين العداد للصفر.
class ResetCounter {
  const ResetCounter();

  Tasbeeh call(Tasbeeh current) {
    return current.copyWith(count: 0);
  }
}

