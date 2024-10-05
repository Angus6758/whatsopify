
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';

class Tax {
  const Tax({
    required this.name,
    required this.amount,
    required this.type,
  });

  final num amount;
  final String name;
  final String type;

  String amountFormatted() {
    if (isPercentage()) return '$amount%';
    return amount.formate(rateCheck: true);
  }

  bool isPercentage() => type == 'percentage';

  factory Tax.fromMap(Map<String, dynamic> map) {
    return Tax(
      amount: map['amount'],
      name: map['tax_name'],
      type: map['type'],
    );
  }
  static List<Tax> fromList(Map<String, dynamic>? map) {
    return List<Tax>.from(map?['data']?.map((e) => Tax.fromMap(e)) ?? []);
  }

  Map<String, dynamic> toMap() {
    return {'amount': amount, 'tax_name': name, 'type': type};
  }
}
