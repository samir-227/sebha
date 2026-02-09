import '../../domain/entities/tasbeeh.dart';

/// Model layer to convert Tasbeeh to/from persistence if needed later.
///
/// Having a model separate from the entity respects Clean Architecture and
/// keeps infra concerns (serialization, storage) away from the domain.
class TasbeehModel extends Tasbeeh {
  const TasbeehModel({
    required super.count,
    required super.currentDhikr,
  });

  factory TasbeehModel.initial() {
    return const TasbeehModel(
      count: 0,
      currentDhikr: 'اللهم إنك عفو كريم تحب العفو فاعفُ عني',
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'currentDhikr': currentDhikr,
      };

  factory TasbeehModel.fromJson(Map<String, dynamic> json) {
    return TasbeehModel(
      count: json['count'] as int? ?? 0,
      currentDhikr: json['currentDhikr'] as String? ??
          'اللهم إنك عفو كريم تحب العفو فاعفُ عني',
    );
  }
}

