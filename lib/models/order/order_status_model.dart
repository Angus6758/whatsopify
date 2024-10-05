import 'package:seller_management/main.export.dart';

class OrderStatus {
  OrderStatus({
    required this.id,
    required this.uid,
    required this.paymentStatus,
    required this.paymentNote,
    required this.deliveryStatus,
    required this.deliveryNote,
    required this.createdAt,
  });

  factory OrderStatus.fromMap(Map<String, dynamic> map) {
    return OrderStatus(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      paymentStatus: map['payment_status'] ?? '',
      paymentNote: map['payment_note'] ?? '',
      deliveryStatus: map['delivery_status'] ?? '',
      deliveryNote: map['delivery_note'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  final String createdAt;
  final String deliveryNote;
  final String deliveryStatus;
  final int id;
  final String paymentNote;
  final String paymentStatus;
  final String uid;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'payment_status': paymentStatus});
    result.addAll({'payment_note': paymentNote});
    result.addAll({'delivery_status': deliveryStatus});
    result.addAll({'delivery_note': deliveryNote});
    result.addAll({'created_at': createdAt});

    return result;
  }
}
