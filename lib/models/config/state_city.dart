import 'package:seller_management/main.export.dart';

class StateCity {
  const StateCity({
    required this.id,
    required this.name,
    required this.shippingFees,
  });

  factory StateCity.fromMap(Map<String, dynamic> map) {
    return StateCity(
     id: map.parseInt('id'),
      name: map['name'] as String,
      shippingFees: map.parseNum('shipping_fees'),
    );
  }

  final int id;
  final String name;
  final num shippingFees;

  static List<StateCity> fromList(QMap map) {
    return List<StateCity>.from(map['data']?.map((x) => StateCity.fromMap(x)));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shipping_fees': shippingFees,
    };
  }
}
