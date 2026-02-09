import '../entities/tasbeeh.dart';

/// UseCase: زيادة العداد. يحافظ على منطق بسيط وقابل للاختبار.
class IncrementCounter {
  const IncrementCounter();

  Tasbeeh call(Tasbeeh current) {
    return current.copyWith(count: current.count + 1);
  }
}

