import 'dart:convert';

import 'package:seller_management/features/product/view/user_content/order_model.dart';


class OrderBaseModel {
  OrderBaseModel({
    required this.message,
    required this.order,
    required this.paymentLog,
    this.accessToken,
    this.paymentUrl,
  });

  factory OrderBaseModel.fromJson(String json) {
    return OrderBaseModel.fromMap(jsonDecode(json));
  }

  factory OrderBaseModel.fromMap(Map<String, dynamic> map) {
    return OrderBaseModel(
      message: map['message'] ?? '',
      order: OrderModel.fromMap(map['order']),
      paymentLog: PaymentLog.fromMap(map['payment_log']),
      accessToken: map['access_token'] is String ? map['access_token'] : null,
      paymentUrl: map['payment_url'] is String ? map['payment_url'] : null,
    );
  }

  final String message;
  final String? accessToken;
  final OrderModel order;
  final PaymentLog paymentLog;
  final String? paymentUrl;

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'order': order.toMap(),
      'payment_log': paymentLog.toMap(),
      'access_token': accessToken,
      'payment_url': paymentUrl,
    };
  }

  String toJson() => jsonEncode(toMap());
}
