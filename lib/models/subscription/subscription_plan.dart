import 'package:seller_management/main.export.dart';

class SubscriptionPlan {
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.amount,
    required this.totalProduct,
    required this.duration,
    required this.durationUnit,
  });

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlan(
     id: map.parseInt('id'),
      name: map['name'] ?? '',
      amount: map.parseNum('amount'),
      totalProduct: map.parseInt('total_product'),
      duration: map.parseInt('duration'),
      durationUnit: map['duration_unit'] ?? '',
    );
  }

  final num amount;
  final int duration;
  final String durationUnit;
  final int id;
  final String name;
  final int totalProduct;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'total_product': totalProduct,
      'duration': duration,
      'duration_unit': durationUnit,
    };
  }
}
