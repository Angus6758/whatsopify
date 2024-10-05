import 'package:seller_management/main.export.dart';

class Stock {
  Stock({
    required this.id,
    required this.uid,
    required this.attribute,
    required this.qty,
    required this.price,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      attribute: map['attribute'] ?? '',
      qty: map['qty'] ?? '',
      price: map.parseNum('price'),
    );
  }

  final String attribute;
  final int id;
  final num price;
  final String qty;
  final String uid;

  static List<Stock> mapToList(Map<String, dynamic> map) {
    return List<Stock>.from(
      map['stock']?['data'].map((e) => Stock.fromMap(e)) ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'attribute': attribute,
      'qty': qty,
      'price': price
    };
  }
}
