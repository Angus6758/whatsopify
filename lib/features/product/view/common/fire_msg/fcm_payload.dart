import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  order,
  customerChat,
  sellerChat,
  productUpdate;

  static NotificationType? fromValue(String? value) {
    return switch (value) {
      'order' => order,
      'customer_chat' => customerChat,
      'seller_chat' => sellerChat,
      'product_update' => productUpdate,
      _ => null,
    };
  }

  String get btnLabel => switch (this) {
        order => 'Open Order',
        customerChat => 'Reply',
        sellerChat => 'Reply',
        productUpdate => 'Show Product',
      };

  void action({
    VoidCallback? onOrder,
    VoidCallback? onCustomerChat,
    VoidCallback? onSellerChat,
    VoidCallback? onProductUpdate,
  }) {
    switch (this) {
      case NotificationType.order:
        onOrder?.call();
        break;

      case NotificationType.customerChat:
        onCustomerChat?.call();
        break;
      case NotificationType.sellerChat:
        onSellerChat?.call();
        break;
      case NotificationType.productUpdate:
        onProductUpdate?.call();
        break;
    }
  }
}

class FCMPayload {
  const FCMPayload({
    required this.title,
    required this.body,
    required this.image,
    required this.sellerId,
    required this.userId,
    required this.orderNumber,
    required this.orderUid,
    required this.orderId,
    required this.productUid,
    required this.type,
  });

  final String body;

  final String? image;
  final String? orderId;
  final String? orderNumber;
  final String? orderUid;
  final String? productUid;
  final String? sellerId;
  final String title;
  final NotificationType? type;
  final String? userId;

  factory FCMPayload.fromRM(RemoteMessage message) {
    final map = message.data;
    final notification = message.notification;
    return FCMPayload(
      title: map['title'] ?? notification?.title ?? '',
      body: map['body'] ?? notification?.body ?? '',
      image: map['image'] ?? '',
      sellerId: map['seller_id'],
      userId: map['user_id'],
      orderNumber: map['order_number'],
      orderUid: map['order_uid'],
      orderId: map['order_id'],
      productUid: map['product_uid'],
      type: NotificationType.fromValue(map['type']),
    );
  }
  factory FCMPayload.fromMap(Map<String, dynamic> map) {
    return FCMPayload(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      image: map['image'] ?? '',
      sellerId: map['seller_id'],
      userId: map['user_id'],
      orderNumber: map['order_number'],
      orderUid: map['order_uid'],
      orderId: map['order_id'],
      productUid: map['product_uid'],
      type: NotificationType.fromValue(map['type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'seller_id': sellerId,
      'user_id': userId,
      'order_number': orderNumber,
      'order_uid': orderUid,
      'order_id': orderId,
      'product_uid': productUid,
      'type': type?.name,
    };
  }
}
