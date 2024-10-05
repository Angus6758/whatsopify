import 'package:seller_management/main.export.dart';

class OrderDetails {
  const OrderDetails({
    required this.id,
    required this.uid,
    required this.productName,
    required this.productImage,
    required this.quantity,
    // required this.price,
    required this.total,
    required this.physicalAttribute,
    required this.digitalAttribute,
    required this.status,
    required this.originalTotal,
    required this.totalTax,
    required this.discount,
  });

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    return OrderDetails(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      productName: map['product_name'],
      productImage: map['product_image'],
      quantity: map.parseInt('quantity'),
      // price: map.parseNum('item_price'),
      total: map.parseNum('total_price'),
      originalTotal: map.parseNum('original_total_price'),
      totalTax: map.parseNum('total_taxes'),
      discount: map.parseNum('discount'),
      physicalAttribute: map['attribute'],
      digitalAttribute: map['digital_attribute'],
      status: map['status'],
    );
  }

  final String? digitalAttribute;
  final int id;
  final String? physicalAttribute;
  // final num price;
  final String productImage;
  final String productName;
  final int quantity;
  final num total;
  final num originalTotal;
  final num totalTax;
  final num discount;
  final String uid;
  final String status;

  String get attribute => physicalAttribute ?? digitalAttribute ?? '';
  num get price => total / quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'product_name': productName,
      'product_image': productImage,
      'quantity': quantity,
      // 'item_price': price,
      'total_price': total,
      'original_total_price': originalTotal,
      'total_taxes': totalTax,
      'discount': discount,
      'attribute': physicalAttribute,
      'digital_attribute': digitalAttribute,
      'status': status,
    };
  }
}
